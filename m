From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] user_space_eject: unlock door before issuing CDROMEJECT command
Date: Thu, 06 Jun 2013 16:47:15 +0800
Message-ID: <51B04C93.8010508@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34057 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab3FFIqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 04:46:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karel Zak <kzak@redhat.com>, Michal Luscon <mluscon@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>

Hi Karel & Michal,
Not sure if I should send this to you, please kindly forward it to other
people if they should take care of this instead, thanks.

Note that this is a patch for user space tool eject, but since it also
has something to do with the SCSI driver, the SCSI mailing list is CC-ed
in case people there think it should be solved in another way.

Here is the patch.

>From d4202374d620bf72953a0b59f108521f94cefbd6 Mon Sep 17 00:00:00 2001
From: Aaron Lu <aaron.lu@intel.com>
Date: Thu, 6 Jun 2013 16:28:37 +0800
Subject: [PATCH] eject: unlock door before issuing CDROMEJECT command

If user has inserted a disc into the drive, the drive will normally be
locked. When using eject command to eject the drive, we need to unlock
the door first, or the CDROMEJECT command will fail.

Though the 2nd attmpt to eject the drive with eject_scsi will succeed,
it actually does two things: first to unlock the door and then to eject
the tray, both with the SG_IO ioctl. The problem is, Linux SCSI driver
keeps track of if a device is in locked state or not, if we go with
SG_IO to do the unlocking, the driver will not be aware of the unlocking
and would think the drive is locked while actually it has already been
unlocked by the first SG_IO command.

Fix this by issuing a unlock door command before the CDROMEJECT command
in cdrom_eject. Prior to this fix, the following output is expected when
there is a disc inside:

[aaron@aaronlu util-linux-2.22.2]$ eject -v /dev/sr0
eject: device name is `/dev/sr0'
eject: /dev/sr0: mounted on /run/media/aaron/CD_ROM
eject: /dev/sr0: is whole-disk device
eject: /dev/sr0: is removable device
eject: /run/media/aaron/CD_ROM: unmounting
eject: /dev/sr0: trying to eject using CD-ROM eject command
eject: CD-ROM eject command failed
eject: /dev/sr0: trying to eject using SCSI commands
eject: SCSI eject succeeded

After this fix, the following output is expected:
[aaron@aaronlu util-linux-2.22.2]$ ./eject -v /dev/sr0
lt-eject: device name is `/dev/sr0'
lt-eject: /dev/sr0: mounted on /run/media/aaron/CD_ROM
lt-eject: /dev/sr0: is whole-disk device
lt-eject: /dev/sr0: is removable device
lt-eject: /run/media/aaron/CD_ROM: unmounting
lt-eject: /dev/sr0: trying to eject using CD-ROM eject command
lt-eject: CD-ROM eject command succeeded

And the SCSI device's locked state is correct now.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 sys-utils/eject.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sys-utils/eject.c b/sys-utils/eject.c
index 6d0da18..72e2cb1 100644
--- a/sys-utils/eject.c
+++ b/sys-utils/eject.c
@@ -398,6 +398,9 @@ static void close_tray(int fd)
 static int eject_cdrom(int fd)
 {
 #if defined(CDROMEJECT)
+	int ret = ioctl(fd, CDROM_LOCKDOOR, 0);
+	if (ret < 0)
+		return 0;
 	return ioctl(fd, CDROMEJECT) >= 0;
 #elif defined(CDIOCEJECT)
 	return ioctl(fd, CDIOCEJECT) >= 0;
-- 
1.8.3.3.gfada522

