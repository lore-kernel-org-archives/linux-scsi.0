From: "Wu Zhou" <zhouwu@cn.ibm.com>
Subject: /dev/nst0 Input/Output error,dmesg showing "sense key Unit Attention, Additional
 sense indicates Power on,reset,or bus device reset occurred"
Date: Fri, 29 Aug 2003 18:29:50 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF783A9861.65122639-ON48256D91.0039644D@cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausmtp01.au.ibm.com ([202.81.18.186]:508 "EHLO
	ausmtp01.au.ibm.com") by vger.kernel.org with ESMTP id S264495AbTH2Kdq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 06:33:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi

Hi,

      While I am using tar to test a new kind of SCSI tape on linux for
ppc64, I found a "Input/Output error". Running "dmesg" will showing "sense
key Unit Attention, Additional sense indicates Power on,reset,or bus device
reset occurred". Following is the runing process:

------------------------- Running process start here
-----------------------------------------
[root@plinuxt14 root]# mt -f /dev/nst0 rewind
[root@plinuxt14 root]# mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 1024 bytes. Density code 0x28 (Exabyte Mammoth-2).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN
[root@plinuxt14 root]# tar cf /dev/nst0 install.log
[root@plinuxt14 root]# tar cf /dev/nst0 install.log.syslog
tar: /dev/nst0: Warning: Cannot close: Input/output error
[root@plinuxt14 root]# mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=1, block number=-1, partition=0.
Tape block size 1024 bytes. Density code 0x28 (Exabyte Mammoth-2).
Soft error count since last status=0
General status bits on (1010000):
 ONLINE IM_REP_EN
[root@plinuxt14 root]#  dmesg |tail -n 20
sym53c8xx_abort: pid=14926 serial_number=14927
serial_number_at_timeout=14927
scsi : aborting command due to timeout : pid 14927, scsi1, channel 0, id 2,
lun 0 Write (10) 00 00 03 cd b8 00 00 08 00
sym53c8xx_abort: pid=14927 serial_number=14928
serial_number_at_timeout=14928
scsi : aborting command due to timeout : pid 14928, scsi1, channel 0, id 2,
lun 0 Write (10) 00 00 03 cd c0 00 00 08 00
sym53c8xx_abort: pid=14928 serial_number=14929
serial_number_at_timeout=14929
scsi : aborting command due to timeout : pid 14929, scsi1, channel 0, id 2,
lun 0 Write (10) 00 00 03 cd c8 00 00 08 00
sym53c8xx_abort: pid=14929 serial_number=14930
serial_number_at_timeout=14930
scsi : aborting command due to timeout : pid 14930, scsi1, channel 0, id 2,
lun 0 Write (10) 00 00 03 cd d0 00 00 08 00
sym53c8xx_abort: pid=14930 serial_number=14931
serial_number_at_timeout=14931
scsi : aborting command due to timeout : pid 14931, scsi1, channel 0, id 2,
lun 0 Write (10) 00 00 03 cd d8 00 00 08 00
sym53c8xx_abort: pid=14931 serial_number=14932
serial_number_at_timeout=14932
SCSI host 1 abort (pid 14924) timed out - resetting
SCSI bus is being reset for host 1 channel 0.
sym53c8xx_reset: pid=14924 reset_flags=2 serial_number=14925
serial_number_at_timeout=14925
sym53c896-1: handling phase mismatch from SCRIPTS.
st0: Error with sense data: <6>sym53c896-1-<2,*>: FAST-20 WIDE SCSI 40.0
MB/s (50.0 ns, offset 31)
Current st09:00: sense key Unit Attention
Additional sense indicates Power on,reset,or bus device reset occurred
st0: Error on flush.
sym53c896-1-<0,*>: FAST-20 WIDE SCSI 40.0 MB/s (50.0 ns, offset 31)
----------------------- Running process stop here
-------------------------------------------------------


      Could anyone explain why this error message will display? Why a
poweron, reset or bus device reset would occured? What cause this? Is it a
hardware failure, or a software defect? Thanks very much!

Thanks and Best Regards
---------------------------------------------
Wu Zhou
Software Engineer, IBM China Development Lab
Email: zhouwu@cn.ibm.com
Notes: Wu Zhou/China/IBM@IBMCN

