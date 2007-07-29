From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape driver
Date: Sun, 29 Jul 2007 23:38:15 +0200
Message-ID: <20070729213815.GF3432@traven>
References: <20070729212909.GC3432@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33555
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S935705AbXG2ViX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2007 17:38:23 -0400
Content-Disposition: inline
In-Reply-To: <20070729212909.GC3432@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a4f7b84..73c44cb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1485,7 +1485,7 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 	struct st_buffer *STbp;
 	char *name =3D tape_name(STp);
=20
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
=20
 	retval =3D rw_checks(STp, filp, count);
@@ -1736,7 +1736,7 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 	if (SRpnt !=3D NULL)
 		st_release_request(SRpnt);
 	release_buffering(STp, 0);
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
=20
 	return retval;
 }
@@ -1942,7 +1942,7 @@ st_read(struct file *filp, char __user *buf, size=
_t count, loff_t * ppos)
 	struct st_buffer *STbp =3D STp->buffer;
 	DEB( char *name =3D tape_name(STp); )
=20
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
=20
 	retval =3D rw_checks(STp, filp, count);
@@ -2069,7 +2069,7 @@ st_read(struct file *filp, char __user *buf, size=
_t count, loff_t * ppos)
 		release_buffering(STp, 1);
 		STbp->buffer_bytes =3D 0;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
=20
 	return retval;
 }
@@ -3226,7 +3226,7 @@ static int st_ioctl(struct inode *inode, struct f=
ile *file,
 	char *name =3D tape_name(STp);
 	void __user *p =3D (void __user *)arg;
=20
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
=20
         DEB(
@@ -3537,7 +3537,7 @@ static int st_ioctl(struct inode *inode, struct f=
ile *file,
 			retval =3D (-EFAULT);
 		goto out;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
 		case SCSI_IOCTL_GET_BUS_NUMBER:
@@ -3563,7 +3563,7 @@ static int st_ioctl(struct inode *inode, struct f=
ile *file,
 	return retval;
=20
  out:
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	return retval;
 }
=20
@@ -4029,7 +4029,7 @@ static int st_probe(struct device *dev)
=20
 	tpnt->density_changed =3D tpnt->compression_changed =3D
 	    tpnt->blksize_changed =3D 0;
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
=20
 	st_nr_dev++;
 	write_unlock(&st_dev_arr_lock);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 50f3deb..6c80757 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -3,6 +3,7 @@
 #define _ST_H
=20
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/kref.h>
 #include <scsi/scsi_cmnd.h>
=20
@@ -98,7 +99,7 @@ struct st_partstat {
 struct scsi_tape {
 	struct scsi_driver *driver;
 	struct scsi_device *device;
-	struct semaphore lock;	/* For serialization */
+	struct mutex lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	struct st_buffer *buffer;
=20
--=20
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Ma patrie est o=F9 je suis, o=F9 personne ne me d=E9range, o=F9 per=
sonne
    ne me demande que je suis, d'o=F9 je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
