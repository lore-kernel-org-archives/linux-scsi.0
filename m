From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI st : convert to unlocked_ioctl
Date: Thu, 17 Jan 2008 22:45:22 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0801172243510.5102@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47238 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYAQUph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 15:45:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Convert st to unlocked_ioctl. The necessary locking was already in place.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch is against 2.6.24-rc8.

 drivers/scsi/st.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6/drivers/scsi/st.c	2007-12-20 18:26:03.000000000 +0200
+++ linux-2.6-rc8-test/drivers/scsi/st.c	2008-01-17 21:49:14.000000000 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsky,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
 
-   Copyright 1992 - 2007 Kai Makisara
+   Copyright 1992 - 2008 Kai Makisara
    email Kai.Makisara@kolumbus.fi
 
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20070203";
+static const char *verstr = "20080117";
 
 #include <linux/module.h>
 
@@ -3214,8 +3214,7 @@ static int partition_tape(struct scsi_ta
 
 
 /* The ioctl command */
-static int st_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd_in, unsigned long arg)
+static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
@@ -3870,7 +3869,7 @@ static const struct file_operations st_f
 	.owner =	THIS_MODULE,
 	.read =		st_read,
 	.write =	st_write,
-	.ioctl =	st_ioctl,
+	.unlocked_ioctl = st_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = st_compat_ioctl,
 #endif
