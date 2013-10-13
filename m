From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan in the
 middle
Date: Mon, 14 Oct 2013 01:23:16 +0800
Message-ID: <525AD704.6040705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi James,

[1.] One line summary of the problem:
special sense code asc,ascq=04h,0Ch abort scsi scan in the middle

[2.] Full description of the problem/report:
For instance, storage represents 8 iscsi LUNs, however the LUN No.7 is 
not well configured or has something wrong.
Then messages received:
kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning, 
scan aborted
Which will make LUN No.8 unavailable.
It's confirmed that Windows and Solaris systems will continue the scan 
and make LUN No.1,2,3,4,5,6 and 8 available.

Log snippet is as below:
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan: INQUIRY 
pass 1 length 36
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send: 0xffff8801e9bd4280
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 00 
00 00 24 00
Aug 24 00:32:49 vmhodtest019 kernel: buffer = 0xffff8801f71fc180, 
bufflen = 36, queuecommand 0xffffffffa00b99e7
Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done: 
0xffff8801e9bd4280 SUCCESS
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result: 
hostbyte=DID_OK driverbyte=DRIVER_OK
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 00 
00 00 24 00
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not Ready 
[current]
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense: Logical 
unit not accessible, target port in unavailable state
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy 1 failed 0
Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes done.
Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed with code 
0x8000002
Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected response 
from lun 7 while scanning, scan aborted

According to scsi_report_lun_scan(), I found:
Linux use an inquiry command to probe a lun according to the result of 
report_lun command.
It assumes every probe cmd will get a legal result. Otherwise, it 
regards the whole peripheral not exist or dead.
If the return of inquiry passes its legal checking and indicates 'LUN 
not present', it won't break but also continue with the scan process.
In the log, inquiry to LUN7 return a sense - asc,ascq=04h,0Ch (Logical 
unit not accessible, target port in unavailable state).
And this is ignored, so scsi_probe_lun() returns -EIO and the scan 
process is aborted.

I have two questions:
1. Is it correct for hardware to return a sense 04h,0Ch to inquiry 
again, even after presenting this lun in responce to REPORT_LUN command?
2. Since windows and solaris can continue scan, is it reasonable for 
linux to do the same, even for a fault-tolerance purpose?

Below is information of our storage setting:
Storage array is configured as a cluster mode, and there is a "default" 
target group and "default" initiator group exist on
the storage that includes the target nodename of both the nodes in the 
cluster and all initiator names respectively.
In the partner node, there was lun mapped to the default target 
group/initiator group and having the ID 7.
Since that lun is owner by the partner node, the SCSI inquiry was 
failing on it and as a result the initiator aborts the scan.

Thanks,
Vaughan
