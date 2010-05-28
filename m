From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16070] New: Fail to issue Start/Stop Unit
Date: Fri, 28 May 2010 14:55:31 GMT
Message-ID: <bug-16070-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35653 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0E1Ozc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 10:55:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4SEtVLQ022637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 14:55:31 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16070

           Summary: Fail to issue Start/Stop Unit
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.34-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: ian@beware.dropbear.id.au
        Regression: No


I am attempting to save power by spinning down idle scsi disks. These are old
fashioned parallel (U320) disks on a SCSI storage controller: LSI Logic /
Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07).

I do:

sg_start --stop /dev/sde
echo 0xfffffff > /sys/module/scsi_mod/parameters/scsi_logging_level
dd if=/dev/sde of=/dev/null count=1
sleep 10
echo 0 > /sys/module/scsi_mod/parameters/scsi_logging_level

I get:
dd: reading `/dev/sde': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00536828 s, 0.0 kB/s

If I manually spin up the disk with sg_start --start /dev/sde, then things work
again as expected.

The relevant log is as follows:

May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_open
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0, count=32
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 32/32 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 20 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 16384, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 20 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 32 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 20 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 0
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 1
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 2
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 3
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0, count=8
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 8/8 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 4096, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 8 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_release
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_open
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 00 00 00 fe 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 254, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 00 00 00 fe 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 0)
May 28 23:55:13 fs kernel: 0 sectors total, 254 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_release
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_open
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 01 00 00 fe 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 254, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 01 00 00 fe 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 0)
May 28 23:55:13 fs kernel: 0 sectors total, 254 bytes done.
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 01 80 00 fe 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 254, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Inquiry: 12 01 80 00 fe 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 0)
May 28 23:55:13 fs kernel: 0 sectors total, 254 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_release
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_open
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0,
count=256
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 256/256 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: buffer = 0xf70faa00, bufflen = 131072, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 256 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 0
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 1
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 2
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 3
May 28 23:55:13 fs kernel: Buffer I/O error on device sde, logical block 4
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0, count=8
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 8/8 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 4096, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 8 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_release
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_open
May 28 23:55:13 fs kernel: scsi_block_when_processing_errors: rtn: 1
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0,
count=256
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 256/256 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: buffer = 0xf70faa00, bufflen = 131072, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 256 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 01 00 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_init_command: block=0, count=8
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] block=0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] reading 8/8 512 byte blocks.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Send: 0xe3772780 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: buffer = 0xe37726e0, bufflen = 4096, queuecommand
0xf81773c6
May 28 23:55:13 fs kernel: leaving scsi_dispatch_cmnd()
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Done: 0xe3772780 SUCCESS
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] scsi host busy 1 failed 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: Notifying upper driver of completion
(result 8000002)
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_done:
sb[respc,sk,asc,ascq]=70,2,4,2
May 28 23:55:13 fs kernel: 8 sectors total, 0 bytes done.
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Device not ready
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Sense Key : Not Ready [current] 
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Logical unit not
ready, initializing command required
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] CDB: Read(10): 28 00 00 00 00 00
00 00 08 00
May 28 23:55:13 fs kernel: end_request: I/O error, dev sde, sector 0
May 28 23:55:13 fs kernel: sd 6:0:0:0: [sde] sd_release
May 28 23:55:14 fs kernel: scsi_block_when_processing_errors: rtn: 1


After getting: "Add. Sense: Logical unit not ready, initializing command
required" I would expect a Start/Stop unit command, but it appears that none is
ever issued.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
