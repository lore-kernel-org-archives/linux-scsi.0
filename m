From: Matthias Prager <linux@matthiasprager.de>
Subject: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Fri, 22 Jun 2012 13:19:38 +0200
Message-ID: <4FE454CA.6080007@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:33302 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2FVL0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 07:26:19 -0400
Received: from [192.168.0.13] (p5DDCD437.dip.t-dialin.net [93.220.212.55])
	by dd15408.kasserver.com (Postfix) with ESMTPSA id 530969403BD
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2012 13:19:51 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello linux-scsi,

I'm reporting a problem which I'm experiencing since kernel version
3.1.10 upwards.

Background:
----
OS:     Gentoo (as Guest-OS running on ESXi 5)
Kernel: 3.0.33-gentoo x86_64 (latest kernel version without the issue)
MB:     Intel S3210SH (latest FW/BIOS)
HBA:    LSI 9211-8i (in IR mode)
mpt2sas 08.100.00.02 (kernel driver of 3.0.33-gentoo)
FW Ver  13.00.57.00 (lsi-hba)
BIOS    07.25.00.00 (lsi-hba)
DISK    Seagate Barracuda ES.2 ST3750330NS Firmware: SN06 (and others)
        Layout: ext4 on-top of raid1 software-md
ESXi uses an LSI 9240-8i HBA as datastore. Two LSI 9211-8i HBAs, the
onboard Intel ICH9R and an Intel networkcard are passed-through to the
guest OS. HW-Raid is only used for the datastore (on 9240-8i).
----

Since kernel 3.1.10 I'm experiencing issues with disks not waking up
from spindown. All I need to do to trigger it is to wait until the disks
timeout/spindown and then try to access the content. The issue is most
prominent with one disk, but not limited to it (what makes this disk so
special? - I don't have a clue).

I've tried every kernel version from 3.1.10 to 3.4.2 (vanilla as well as
gentoo-patched-sources).
I've upgraded the controller firmware to the latest version available
from LSI.
I've patched the ESXi 5 host with the latest upgrades.
I've tried booting with 'pci=noioapicquirk' (thinking there may be a
link to bug 43074 on the kernel bug tracker).
I'm booting with 'scsi_mod.scan=sync' to avoid any async scanning issues.
But nothing fixed the issue except going back to kernel 3.0.33 .

I would greatly appreciate any suggestions or help in the matter. Please
do tell me what else you need from me to close down on the issue.
Or should I rather file a bug in the kernel bug tracker?

Thank you

Matthias Prager

Kernel messages when the issue occurs:
---------------------------------------------------
...
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] CDB: Read(10): 28 00 2e 41 c0
3f 00 00 08 00
Apr 04 22:55:10 [kernel] end_request: I/O error, dev sdj, sector 776060991
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 57 54
52 3f 00 00 08 00
Apr 04 22:55:10 [kernel] end_request: I/O error, dev sdj, sector 1465143871
                - Last output repeated twice -
Apr 04 22:55:10 [kernel] md: super_written gets error=-5, uptodate=0
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 00 00
00 3f 00 00 08 00
Apr 04 22:55:10 [kernel] end_request: I/O error, dev sdj, sector 63
Apr 04 22:55:10 [kernel] Buffer I/O error on device md4, logical block 0
Apr 04 22:55:10 [kernel] lost page write due to I/O error on md4
Apr 04 22:55:10 [kernel] EXT4-fs error (device md4):
ext4_find_entry:935: inode #24248321: comm smbd: reading directory lblock 0
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 57 54
52 3f 00 00 08 00
Apr 04 22:55:10 [kernel] end_request: I/O error, dev sdj, sector 1465143871
                - Last output repeated twice -
Apr 04 22:55:10 [kernel] md: super_written gets error=-5, uptodate=0
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] CDB: Read(10): 28 00 2e 41 c0
3f 00 00 08 00
Apr 04 22:58:50 [kernel] end_request: I/O error, dev sdj, sector 776060991
Apr 04 22:58:50 [kernel] EXT4-fs (md4): previous I/O error to superblock
detected
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 57 54
52 3f 00 00 08 00
Apr 04 22:58:50 [kernel] end_request: I/O error, dev sdj, sector 1465143871
                - Last output repeated twice -
Apr 04 22:58:50 [kernel] md: super_written gets error=-5, uptodate=0
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:58:50 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 00 00
00 3f 00 00 08 00
Apr 04 22:58:50 [kernel] end_request: I/O error, dev sdj, sector 63
Apr 04 22:58:50 [kernel] Buffer I/O error on device md4, logical block 0
Apr 04 22:58:50 [kernel] lost page write due to I/O error on md4
Apr 04 22:58:50 [kernel] EXT4-fs error (device md4):
ext4_find_entry:935: inode #24248321: comm smbd: reading directory lblock 0
Apr 04 22:58:51 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:58:51 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Apr 04 22:58:51 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:58:51 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not
ready, initializing command required
Apr 04 22:58:51 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 57 54
52 3f 00 00 08 00
Apr 04 22:58:51 [kernel] end_request: I/O error, dev sdj, sector 1465143871
                - Last output repeated twice -
Apr 04 22:58:51 [kernel] md: super_written gets error=-5, uptodate=0
...
---------------------------------------------------


