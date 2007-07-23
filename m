From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] aacraid: Resend, Fix security hole
Date: Mon, 23 Jul 2007 14:51:05 +0100
Message-ID: <20070723145105.01b3acc3@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45717 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXGWNoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 09:44:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On the SCSI layer ioctl path there is no implicit permissions check for
ioctls (and indeed other drivers implement unprivileged ioctls). aacraid
however allows all sorts of very admin only things to be done so should
check.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1/drivers/scsi/aacraid/linit.c linux-2.6.23rc1/drivers/scsi/aacraid/linit.c
--- linux.vanilla-2.6.23rc1/drivers/scsi/aacraid/linit.c	2007-07-23 12:56:12.000000000 +0100
+++ linux-2.6.23rc1/drivers/scsi/aacraid/linit.c	2007-07-23 12:57:45.000000000 +0100
@@ -636,6 +636,8 @@
 static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
@@ -689,6 +691,8 @@
 
 static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
 }
 #endif
