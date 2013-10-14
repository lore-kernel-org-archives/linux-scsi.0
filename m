From: Hannes Reinecke <hare@suse.de>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Mon, 14 Oct 2013 13:13:46 +0200
Message-ID: <525BD1EA.6000701@suse.de>
References: <525AD704.6040705@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060009010800080902030803"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525AD704.6040705@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060009010800080902030803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 10/13/2013 07:23 PM, Vaughan Cao wrote:
> Hi James,
> 
> [1.] One line summary of the problem:
> special sense code asc,ascq=04h,0Ch abort scsi scan in the middle
> 
> [2.] Full description of the problem/report:
> For instance, storage represents 8 iscsi LUNs, however the LUN No.7
> is not well configured or has something wrong.
> Then messages received:
> kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning,
> scan aborted
> Which will make LUN No.8 unavailable.
> It's confirmed that Windows and Solaris systems will continue the
> scan and make LUN No.1,2,3,4,5,6 and 8 available.
> 
> Log snippet is as below:
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan:
> INQUIRY pass 1 length 36
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send:
> 0xffff8801e9bd4280
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12
> 00 00 00 24 00
> Aug 24 00:32:49 vmhodtest019 kernel: buffer = 0xffff8801f71fc180,
> bufflen = 36, queuecommand 0xffffffffa00b99e7
> Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done:
> 0xffff8801e9bd4280 SUCCESS
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result:
> hostbyte=DID_OK driverbyte=DRIVER_OK
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12
> 00 00 00 24 00
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not
> Ready [current]
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense:
> Logical unit not accessible, target port in unavailable state
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy 1
> failed 0
> Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes done.
> Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed with
> code 0x8000002
> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected
> response from lun 7 while scanning, scan aborted
> 
> According to scsi_report_lun_scan(), I found:
> Linux use an inquiry command to probe a lun according to the result
> of report_lun command.
> It assumes every probe cmd will get a legal result. Otherwise, it
> regards the whole peripheral not exist or dead.
> If the return of inquiry passes its legal checking and indicates
> 'LUN not present', it won't break but also continue with the scan
> process.
> In the log, inquiry to LUN7 return a sense - asc,ascq=04h,0Ch
> (Logical unit not accessible, target port in unavailable state).
> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
> process is aborted.
> 
> I have two questions:
> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
> again, even after presenting this lun in responce to REPORT_LUN
> command?
Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' state.

> 2. Since windows and solaris can continue scan, is it reasonable for
> linux to do the same, even for a fault-tolerance purpose?
> 
Hmm. Yes, and no.

_Actually_ this is an issue with the target, as it looks as if it
will return the above sense code while sending an 'INQUIRY' to the
device.
SPC explicitely states that the INQUIRY command should _not_ fail
for unavailable devices.
But yeah, we probably should work around this issues.
Nevertheless, please raise this issue with your array vendor.

Please try the attached patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------060009010800080902030803
Content-Type: text/x-patch;
 name="scsi_scan-continue-after-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_scan-continue-after-error.patch"

>From b0e90778f012010c881f8bdc03bce63a36921b77 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 14 Oct 2013 13:11:22 +0200
Subject: [PATCH] scsi_scan: continue report_lun_scan after error

When scsi_probe_and_add_lun() fails in scsi_report_lun_scan() this
does _not_ indicate that the entire target is done for.
So continue scanning for the remaining devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..973a121 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1484,13 +1484,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				lun, NULL, NULL, rescan, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
-				 * Got some results, but now none, abort.
+				 * Got some results, but now none, ignore.
 				 */
 				sdev_printk(KERN_ERR, sdev,
 					"Unexpected response"
-				        " from lun %d while scanning, scan"
-				        " aborted\n", lun);
-				break;
+					" from lun %d while scanning,"
+					" ignoring device\n", lun);
 			}
 		}
 	}

--------------060009010800080902030803--
