From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi/st: remove BKL from open
Date: Tue,  1 Jun 2010 23:16:54 +0200
Message-ID: <1275427014-9801-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab0FAVRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 17:17:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Willem Riede <osst@riede.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <James.Bottomley@suse.de>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The st_open function is serialized through the st_dev_arr_lock
and the STp->in_use flag, so there is no race that the BKL
can protect against in the driver itself, and the function
does not access any global state outside of the driver that
might be protected with the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Willem Riede <osst@riede.org>
Cc: "Kai M=C3=A4kisara" <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: osst-users@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
 drivers/scsi/st.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 24211d0..8d4c4bb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -39,7 +39,6 @@ static const char *verstr =3D "20081215";
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
=20
 #include <asm/uaccess.h>
 #include <asm/dma.h>
@@ -1180,7 +1179,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	int dev =3D TAPE_NR(inode);
 	char *name;
=20
-	lock_kernel();
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if th=
at
@@ -1188,10 +1186,8 @@ static int st_open(struct inode *inode, struct f=
ile *filp)
 	 */
 	filp->f_mode &=3D ~(FMODE_PREAD | FMODE_PWRITE);
=20
-	if (!(STp =3D scsi_tape_get(dev))) {
-		unlock_kernel();
+	if (!(STp =3D scsi_tape_get(dev)))
 		return -ENXIO;
-	}
=20
 	write_lock(&st_dev_arr_lock);
 	filp->private_data =3D STp;
@@ -1200,7 +1196,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
 		scsi_tape_put(STp);
-		unlock_kernel();
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
@@ -1249,14 +1244,12 @@ static int st_open(struct inode *inode, struct =
file *filp)
 			retval =3D (-EIO);
 		goto err_out;
 	}
-	unlock_kernel();
 	return 0;
=20
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use =3D 0;
 	scsi_tape_put(STp);
-	unlock_kernel();
 	return retval;
=20
 }
--=20
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
