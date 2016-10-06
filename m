From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176701] New: hdparm security erase gets aborted by SML
Date: Thu, 06 Oct 2016 15:44:54 +0000
Message-ID: <bug-176701-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942075AbcJFPo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Oct 2016 11:44:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id ECA5120394
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2016 15:44:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 720E32037E
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2016 15:44:54 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176701

            Bug ID: 176701
           Summary: hdparm security erase gets aborted by SML
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: igor@media-clone.com
        Regression: No

The security erase command sent by hdparm with ATA pass through using ioctl
SG_IO gets aborted after a few minutes. It seems that the SCSI level thinks
that the task got stuck and aborts it.

dmesg output:

[ 1229.996993] sd 2:0:0:0: attempting task abort! scmd(ffff880215289200)
[ 1229.997005] sd 2:0:0:0: [sdb] tag#1 CDB: ATA command pass through(16) 85 06
20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1229.997011] scsi target2:0:0: handle(0x0009),
sas_address(0x4433221101000000), phy(1)
[ 1229.997015] scsi target2:0:0: enclosure_logical_id(0x500605b0080c87d0),
slot(2)
[ 1230.036462] sd 2:0:0:0: task abort: SUCCESS scmd(ffff880215289200)
[ 1230.196445] sd 2:0:0:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[ 1230.196447] mpt2sas_cm0:     sas_address(0x4433221101000000), phy(1)
[ 1230.196448] mpt2sas_cm0:    
enclosure_logical_id(0x500605b0080c87d0),slot(2)
[ 1230.196449] mpt2sas_cm0:     handle(0x0009), ioc_status(success)(0x0000),
smid(1)
[ 1230.196449] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1230.196450] mpt2sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000000)
[ 1230.196451] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1230.196452] mpt2sas_cm0:     [sense_key,asc,ascq]: [0x06,0x29,0x00],
count(18)
[ 1823.036119] sd 2:0:0:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[ 1823.036121] mpt2sas_cm0:     sas_address(0x4433221101000000), phy(1)
[ 1823.036122] mpt2sas_cm0:    
enclosure_logical_id(0x500605b0080c87d0),slot(2)
[ 1823.036123] mpt2sas_cm0:     handle(0x0009), ioc_status(success)(0x0000),
smid(1)
[ 1823.036123] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1823.036124] mpt2sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000000)
[ 1823.036125] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1823.036126] mpt2sas_cm0:     [sense_key,asc,ascq]: [0x06,0x29,0x00],
count(18)

---------------------------------------------------------------------

hdparm output:

user@user-MS-7887:~$ sudo hdparm --security-set-pass xxx /dev/sdb
security_password: "xxx"

/dev/sdb:
 Issuing SECURITY_SET_PASS command, password="xxx", user=user, mode=high
user@user-MS-7887:~$ sudo hdparm --security-erase xxx /dev/sdb
security_password: "xxx"

/dev/sdb:
 Issuing SECURITY_ERASE command, password="xxx", user=user
The running kernel lacks CONFIG_IDE_TASK_IOCTL support for this device.
SECURITY_ERASE: Invalid argument
user@user-MS-7887:~$ sudo hdparm --verbose --security-erase xxx /dev/sdb
security_password: "xxx"

/dev/sdb:
 Issuing SECURITY_ERASE command, password="xxx", user=user
outgoing cdb:  85 08 0e 00 00 00 01 00 00 00 00 00 00 40 ec 00
SG_IO: ATA_16 status=0x0, host_status=0x0, driver_status=0x0
SG_IO: sb[]:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00
incoming_data:  7a 42 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00 00 00 00 00 20
20 20 20 57 20 2d 44 43 57 33 43 33 46 54 4b 54 50 31 33 00 00 00 00 00 00 31
30 30 2e 41 31 31 30 44 57 20 43 44 57 30 31 5a 45 58 45 30 2d 42 30 35 4e 30
41 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 10 80 00 40 00
2f 01 40 00 00 00 00 07 00 ff 3f 10 00 3f 00 10 fc fb 00 00 01 ff ff ff 0f 00
00 07 00 03 00 78 00 78 00 78 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 1f
00 0e 97 06 00 44 00 44 00 fe 03 1f 00 6b 74 61 7d 23 41 6b 74 41 bc 23 41 7f
40 3f 00 3f 00 00 00 fe ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b0 6d 70
74 00 00 00 00 00 00 00 00 03 60 00 00 01 50 e2 4e 7a b6 f8 7e 00 00 00 00 00
00 00 00 00 00 00 00 00 00 18 40 18 40 00 00 00 00 00 00 00 00 00 00 00 00 00
00 23 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 35 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 1c 00
00 00 00 00 00 00 00 7e 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 01 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a5 ef
SG_IO: desc[]:  00 00
      ATA_16 stat=00 err=00 nsect=00 lbal=00 lbam=00 lbah=00 dev=00
outgoing cdb:  85 06 20 00 00 00 00 00 00 00 00 00 00 40 f3 00
SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[]:  72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 00 00 00 00 40 50
00 00 00 00 00 00 00 00 00 00
SG_IO: desc[]:  09 0c 00 00 00 00 00 00 00 00 00 00 40 50
      ATA_16 stat=50 err=00 nsect=00 lbal=00 lbam=00 lbah=00 dev=40
oflags.bits.lob_all=0x8a, flags={ feat nsect command }
oflags.bits.hob_all=0x00, flags={ }
outgoing cdb:  85 0a 06 00 00 00 01 00 00 00 00 00 00 40 f4 00
outgoing_data:  00 00 4d 43 49 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: ATA_16 status=0x0, host_status=0xb, driver_status=0x0
SG_IO: bad host status: 0xb
trying legacy HDIO_DRIVE_TASKFILE
rc=-1, errno=22, returned ATA registers:
The running kernel lacks CONFIG_IDE_TASK_IOCTL support for this device.
SECURITY_ERASE: Invalid argument

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
