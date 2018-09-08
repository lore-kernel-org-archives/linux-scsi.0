From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/11] compat_ioctl: move tape handling into drivers
Date: Sat,  8 Sep 2018 16:28:17 +0200
Message-ID: <20180908142837.2819693-11-arnd@arndb.de>
References: <20180908142837.2819693-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180908142837.2819693-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

MTIOCPOS and MTIOCGET are incompatible between 32-bit and 64-bit user
space, and traditionally have been translated in fs/compat_ioctl.c.

To get rid of that translation handler, move a corresponding
implementation into each of the four drivers implementing those commands.

The interesting part of that is now in a new linux/mtio.h header that
wraps the existing uapi/linux/mtio.h header and provides an abstraction
to let drivers handle both cases easily.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ide/ide-tape.c        | 31 ++++++++++++----
 drivers/s390/char/tape_char.c | 41 ++++++++------------
 drivers/scsi/osst.c           | 34 ++++++++++-------
 drivers/scsi/st.c             | 35 +++++++++++-------
 fs/compat_ioctl.c             | 70 -----------------------------------
 include/linux/mtio.h          | 58 +++++++++++++++++++++++++++++
 6 files changed, 137 insertions(+), 132 deletions(-)
 create mode 100644 include/linux/mtio.h

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 34c1165226a4..137febf3658d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -19,6 +19,7 @@
 
 #define IDETAPE_VERSION "1.20"
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -1368,7 +1369,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
  * ide-tape ioctls are supported on both interfaces.
  */
 static long do_idetape_chrdev_ioctl(struct file *file,
-				unsigned int cmd, unsigned long arg)
+				unsigned int cmd, unsigned long arg, bool compat)
 {
 	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
@@ -1407,14 +1408,10 @@ static long do_idetape_chrdev_ioctl(struct file *file,
 		if (tape->drv_write_prot)
 			mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
 
-		if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
-			return -EFAULT;
-		return 0;
+		return put_user_mtget(argp, &mtget, compat);
 	case MTIOCPOS:
 		mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
-		if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
-			return -EFAULT;
-		return 0;
+		return put_user_mtpos(argp, &mtpos, compat);
 	default:
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			ide_tape_discard_merge_buffer(drive, 1);
@@ -1427,7 +1424,23 @@ static long idetape_chrdev_ioctl(struct file *file,
 {
 	long ret;
 	mutex_lock(&ide_tape_mutex);
-	ret = do_idetape_chrdev_ioctl(file, cmd, arg);
+	ret = do_idetape_chrdev_ioctl(file, cmd, arg, false);
+	mutex_unlock(&ide_tape_mutex);
+	return ret;
+}
+
+static long idetape_chrdev_compat_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	if (cmd == MTIOCPOS32)
+		cmd = MTIOCPOS;
+	else if (cmd == MTIOCGET32)
+		cmd = MTIOCGET;
+
+	mutex_lock(&ide_tape_mutex);
+	ret = do_idetape_chrdev_ioctl(file, cmd, arg, true);
 	mutex_unlock(&ide_tape_mutex);
 	return ret;
 }
@@ -1886,6 +1899,8 @@ static const struct file_operations idetape_fops = {
 	.read		= idetape_chrdev_read,
 	.write		= idetape_chrdev_write,
 	.unlocked_ioctl	= idetape_chrdev_ioctl,
+	.compat_ioctl	= IS_ENABLED(CONFIG_COMPAT) ?
+			  idetape_chrdev_compat_ioctl : NULL,
 	.open		= idetape_chrdev_open,
 	.release	= idetape_chrdev_release,
 	.llseek		= noop_llseek,
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index fc206c9d1c56..522ca9b836e3 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -341,14 +341,14 @@ tapechar_release(struct inode *inode, struct file *filp)
  */
 static int
 __tapechar_ioctl(struct tape_device *device,
-		 unsigned int no, unsigned long data)
+		 unsigned int no, void __user *data, bool compat)
 {
 	int rc;
 
 	if (no == MTIOCTOP) {
 		struct mtop op;
 
-		if (copy_from_user(&op, (char __user *) data, sizeof(op)) != 0)
+		if (copy_from_user(&op, data, sizeof(op)) != 0)
 			return -EFAULT;
 		if (op.mt_count < 0)
 			return -EINVAL;
@@ -392,9 +392,7 @@ __tapechar_ioctl(struct tape_device *device,
 		if (rc < 0)
 			return rc;
 		pos.mt_blkno = rc;
-		if (copy_to_user((char __user *) data, &pos, sizeof(pos)) != 0)
-			return -EFAULT;
-		return 0;
+		return put_user_mtpos(data, &pos, compat);
 	}
 	if (no == MTIOCGET) {
 		/* MTIOCGET: query the tape drive status. */
@@ -424,15 +422,12 @@ __tapechar_ioctl(struct tape_device *device,
 			get.mt_blkno = rc;
 		}
 
-		if (copy_to_user((char __user *) data, &get, sizeof(get)) != 0)
-			return -EFAULT;
-
-		return 0;
+		return put_user_mtget(data, &get, compat);
 	}
 	/* Try the discipline ioctl function. */
 	if (device->discipline->ioctl_fn == NULL)
 		return -EINVAL;
-	return device->discipline->ioctl_fn(device, no, data);
+	return device->discipline->ioctl_fn(device, no, (unsigned long)data);
 }
 
 static long
@@ -445,7 +440,7 @@ tapechar_ioctl(struct file *filp, unsigned int no, unsigned long data)
 
 	device = (struct tape_device *) filp->private_data;
 	mutex_lock(&device->mutex);
-	rc = __tapechar_ioctl(device, no, data);
+	rc = __tapechar_ioctl(device, no, (void __user *)data, false);
 	mutex_unlock(&device->mutex);
 	return rc;
 }
@@ -455,23 +450,17 @@ static long
 tapechar_compat_ioctl(struct file *filp, unsigned int no, unsigned long data)
 {
 	struct tape_device *device = filp->private_data;
-	int rval = -ENOIOCTLCMD;
-	unsigned long argp;
+	long rc;
 
-	/* The 'arg' argument of any ioctl function may only be used for
-	 * pointers because of the compat pointer conversion.
-	 * Consider this when adding new ioctls.
-	 */
-	argp = (unsigned long) compat_ptr(data);
-	if (device->discipline->ioctl_fn) {
-		mutex_lock(&device->mutex);
-		rval = device->discipline->ioctl_fn(device, no, argp);
-		mutex_unlock(&device->mutex);
-		if (rval == -EINVAL)
-			rval = -ENOIOCTLCMD;
-	}
+	if (no == MTIOCPOS32)
+		no = MTIOCPOS;
+	else if (no == MTIOCGET32)
+		no = MTIOCGET;
 
-	return rval;
+	mutex_lock(&device->mutex);
+	rc = __tapechar_ioctl(device, no, compat_ptr(data), false);
+	mutex_unlock(&device->mutex);
+	return rc;
 }
 #endif /* CONFIG_COMPAT */
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 7a1a1edde35d..842457b9134a 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -33,6 +33,7 @@ static const char * osst_version = "0.99.4";
 
 #include <linux/module.h>
 
+#include <linux/compat.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
@@ -4941,7 +4942,7 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
 static long osst_ioctl(struct file * file,
 	 unsigned int cmd_in, unsigned long arg)
 {
-	int		      i, cmd_nr, cmd_type, blk, retval = 0;
+	int		      i, cmd_nr, cmd_type, cmd_size, blk, retval = 0;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
 	struct osst_request * SRpnt = NULL;
@@ -4978,6 +4979,7 @@ static long osst_ioctl(struct file * file,
 
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr   = _IOC_NR(cmd_in);
+	cmd_size = _IOC_SIZE(cmd_in);
 #if DEBUG
 	printk(OSST_DEB_MSG "%s:D: Ioctl %d,%d in %s mode\n", name,
 			    cmd_type, cmd_nr, STp->raw?"raw":"normal");
@@ -5179,7 +5181,8 @@ static long osst_ioctl(struct file * file,
 	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
 		struct mtget mt_status;
 
-		if (_IOC_SIZE(cmd_in) != sizeof(struct mtget)) {
+		if (cmd_size != sizeof(struct mtget) &&
+		    cmd_size != sizeof(struct mtget32)) {
 			 retval = (-EINVAL);
 			 goto out;
 		}
@@ -5229,21 +5232,18 @@ static long osst_ioctl(struct file * file,
 		    STp->drv_buffer != 0)
 			mt_status.mt_gstat |= GMT_IM_REP_EN(0xffffffff);
 
-		i = copy_to_user(p, &mt_status, sizeof(struct mtget));
-		if (i) {
-			retval = (-EFAULT);
-			goto out;
-		}
-
-		STp->recover_erreg = 0;  /* Clear after read */
-		retval = 0;
+		retval = put_user_mtget(p, &mt_status,
+					cmd_size == sizeof(struct mtget32));
+		if (!retval)
+			STp->recover_erreg = 0;  /* Clear after read */
 		goto out;
 	} /* End of MTIOCGET */
 
 	if (cmd_type == _IOC_TYPE(MTIOCPOS) && cmd_nr == _IOC_NR(MTIOCPOS)) {
 		struct mtpos mt_pos;
 
-		if (_IOC_SIZE(cmd_in) != sizeof(struct mtpos)) {
+		if (cmd_size != sizeof(struct mtpos) &&
+		    cmd_size != sizeof(struct mtpos32)) {
 			retval = (-EINVAL);
 			goto out;
 		}
@@ -5256,9 +5256,7 @@ static long osst_ioctl(struct file * file,
 			goto out;
 		}
 		mt_pos.mt_blkno = blk;
-		i = copy_to_user(p, &mt_pos, sizeof(struct mtpos));
-		if (i)
-			retval = -EFAULT;
+		retval = put_user_mtpos(p, &mt_pos, cmd_size == sizeof(struct mtpos32));
 		goto out;
 	}
 	if (SRpnt) osst_release_request(SRpnt);
@@ -5284,6 +5282,14 @@ static long osst_compat_ioctl(struct file * file, unsigned int cmd_in, unsigned
 	struct osst_tape *STp = file->private_data;
 	struct scsi_device *sdev = STp->device;
 	int ret = -ENOIOCTLCMD;
+
+	switch (cmd_in) {
+	case MTIOCTOP:
+	case MTIOCPOS32:
+	case MTIOCGET32:
+		return osst_ioctl(file, cmd_in, (unsigned long)compat_ptr(arg));
+	}
+
 	if (sdev->host->hostt->compat_ioctl) {
 
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 307df2fa39a3..62244ce53baa 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -21,6 +21,7 @@ static const char *verstr = "20160209";
 
 #include <linux/module.h>
 
+#include <linux/compat.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
@@ -3498,7 +3499,7 @@ static int partition_tape(struct scsi_tape *STp, int size)
 /* The ioctl command */
 static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
-	int i, cmd_nr, cmd_type, bt;
+	int i, cmd_nr, cmd_type, cmd_size, bt;
 	int retval = 0;
 	unsigned int blk;
 	struct scsi_tape *STp = file->private_data;
@@ -3532,6 +3533,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
+	cmd_size = _IOC_SIZE(cmd_in);
 
 	if (cmd_type == _IOC_TYPE(MTIOCTOP) && cmd_nr == _IOC_NR(MTIOCTOP)) {
 		struct mtop mtc;
@@ -3741,7 +3743,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
 		struct mtget mt_status;
 
-		if (_IOC_SIZE(cmd_in) != sizeof(struct mtget)) {
+		if (cmd_size != sizeof(struct mtget) &&
+		    cmd_size != sizeof(struct mtget32)) {
 			 retval = (-EINVAL);
 			 goto out;
 		}
@@ -3796,19 +3799,16 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		if (STp->cleaning_req)
 			mt_status.mt_gstat |= GMT_CLN(0xffffffff);
 
-		i = copy_to_user(p, &mt_status, sizeof(struct mtget));
-		if (i) {
-			retval = (-EFAULT);
-			goto out;
-		}
+		retval = put_user_mtget(p, &mt_status,
+					cmd_size == sizeof(struct mtget32));
 
 		STp->recover_reg = 0;		/* Clear after read */
-		retval = 0;
 		goto out;
 	}			/* End of MTIOCGET */
 	if (cmd_type == _IOC_TYPE(MTIOCPOS) && cmd_nr == _IOC_NR(MTIOCPOS)) {
 		struct mtpos mt_pos;
-		if (_IOC_SIZE(cmd_in) != sizeof(struct mtpos)) {
+		if (cmd_size != sizeof(struct mtpos) &&
+		    cmd_size != sizeof(struct mtpos32)) {
 			 retval = (-EINVAL);
 			 goto out;
 		}
@@ -3817,9 +3817,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			goto out;
 		}
 		mt_pos.mt_blkno = blk;
-		i = copy_to_user(p, &mt_pos, sizeof(struct mtpos));
-		if (i)
-			retval = (-EFAULT);
+		retval = put_user_mtpos(p, &mt_pos,
+					cmd_size == sizeof(struct mtpos32));
 		goto out;
 	}
 	mutex_unlock(&STp->lock);
@@ -3853,14 +3852,22 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
 	struct scsi_tape *STp = file->private_data;
 	struct scsi_device *sdev = STp->device;
 	int ret = -ENOIOCTLCMD;
+
+	switch (cmd_in) {
+	case MTIOCTOP:
+	case MTIOCPOS32:
+	case MTIOCGET32:
+		return st_ioctl(file, cmd_in, (unsigned long)compat_ptr(arg));
+	}
+
 	if (sdev->host->hostt->compat_ioctl) { 
 
-		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
 
 	}
 	return ret;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index bb73d52f02a2..70db940aeea9 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -35,7 +35,6 @@
 #include <linux/ppp_defs.h>
 #include <linux/ppp-ioctl.h>
 #include <linux/if_pppox.h>
-#include <linux/mtio.h>
 #include <linux/tty.h>
 #include <linux/vt_kern.h>
 #include <linux/fb.h>
@@ -265,70 +264,6 @@ static int sg_ioctl_trans(struct file *file, unsigned int cmd,
 	return err;
 }
 
-struct mtget32 {
-	compat_long_t	mt_type;
-	compat_long_t	mt_resid;
-	compat_long_t	mt_dsreg;
-	compat_long_t	mt_gstat;
-	compat_long_t	mt_erreg;
-	compat_daddr_t	mt_fileno;
-	compat_daddr_t	mt_blkno;
-};
-#define MTIOCGET32	_IOR('m', 2, struct mtget32)
-
-struct mtpos32 {
-	compat_long_t	mt_blkno;
-};
-#define MTIOCPOS32	_IOR('m', 3, struct mtpos32)
-
-static int mt_ioctl_trans(struct file *file,
-		unsigned int cmd, void __user *argp)
-{
-	/* NULL initialization to make gcc shut up */
-	struct mtget __user *get = NULL;
-	struct mtget32 __user *umget32;
-	struct mtpos __user *pos = NULL;
-	struct mtpos32 __user *upos32;
-	unsigned long kcmd;
-	void *karg;
-	int err = 0;
-
-	switch(cmd) {
-	case MTIOCPOS32:
-		kcmd = MTIOCPOS;
-		pos = compat_alloc_user_space(sizeof(*pos));
-		karg = pos;
-		break;
-	default:	/* MTIOCGET32 */
-		kcmd = MTIOCGET;
-		get = compat_alloc_user_space(sizeof(*get));
-		karg = get;
-		break;
-	}
-	if (karg == NULL)
-		return -EFAULT;
-	err = do_ioctl(file, kcmd, (unsigned long)karg);
-	if (err)
-		return err;
-	switch (cmd) {
-	case MTIOCPOS32:
-		upos32 = argp;
-		err = convert_in_user(&pos->mt_blkno, &upos32->mt_blkno);
-		break;
-	case MTIOCGET32:
-		umget32 = argp;
-		err = convert_in_user(&get->mt_type, &umget32->mt_type);
-		err |= convert_in_user(&get->mt_resid, &umget32->mt_resid);
-		err |= convert_in_user(&get->mt_dsreg, &umget32->mt_dsreg);
-		err |= convert_in_user(&get->mt_gstat, &umget32->mt_gstat);
-		err |= convert_in_user(&get->mt_erreg, &umget32->mt_erreg);
-		err |= convert_in_user(&get->mt_fileno, &umget32->mt_fileno);
-		err |= convert_in_user(&get->mt_blkno, &umget32->mt_blkno);
-		break;
-	}
-	return err ? -EFAULT: 0;
-}
-
 #endif /* CONFIG_BLOCK */
 
 /* Bluetooth ioctls */
@@ -544,8 +479,6 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
  */
 COMPATIBLE_IOCTL(_IOR('p', 20, int[7])) /* RTCGET */
 COMPATIBLE_IOCTL(_IOW('p', 21, int[7])) /* RTCSET */
-/* Little m */
-COMPATIBLE_IOCTL(MTIOCTOP)
 /* Socket level stuff */
 COMPATIBLE_IOCTL(FIOQSIZE)
 #ifdef CONFIG_BLOCK
@@ -657,9 +590,6 @@ static long do_ioctl_trans(unsigned int cmd,
 #ifdef CONFIG_BLOCK
 	case SG_IO:
 		return sg_ioctl_trans(file, cmd, argp);
-	case MTIOCGET32:
-	case MTIOCPOS32:
-		return mt_ioctl_trans(file, cmd, argp);
 #endif
 	/* Serial */
 	case TIOCGSERIAL:
diff --git a/include/linux/mtio.h b/include/linux/mtio.h
new file mode 100644
index 000000000000..02640756a40d
--- /dev/null
+++ b/include/linux/mtio.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MTIO_COMPAT_H
+#define _LINUX_MTIO_COMPAT_H
+
+#include <uapi/linux/mtio.h>
+#include <linux/uaccess.h>
+
+/*
+ * helper functions for implementing compat ioctls on the four tape
+ * drivers: we define the 32-bit layout of each incompatible strucucture,
+ * plus a wrapper function to copy it to user space in either format.
+ */
+
+struct	mtget32 {
+	s32	mt_type;
+	s32	mt_resid;
+	s32	mt_dsreg;
+	s32	mt_gstat;
+	s32	mt_erreg;
+	s32	mt_fileno;
+	s32	mt_blkno;
+};
+#define	MTIOCGET32	_IOR('m', 2, struct mtget32)
+
+struct	mtpos32 {
+	s32 	mt_blkno;
+};
+#define	MTIOCPOS32	_IOR('m', 3, struct mtpos32)
+
+static inline int put_user_mtget(void __user *u, struct mtget *k, bool compat)
+{
+	struct mtget32 k32 = {
+		.mt_type   = k->mt_type,
+		.mt_resid  = k->mt_resid,
+		.mt_dsreg  = k->mt_dsreg,
+		.mt_gstat  = k->mt_gstat,
+		.mt_fileno = k->mt_fileno,
+		.mt_blkno  = k->mt_blkno,
+	};
+	int ret;
+
+	if (IS_ENABLED(CONFIG_COMPAT) && compat)
+		ret = copy_to_user(u, &k32, sizeof(k32));
+	else
+		ret = copy_to_user(u, k, sizeof(*k));
+
+	return ret ? -EFAULT : 0;
+}
+
+static inline int put_user_mtpos(void __user *u, struct mtpos *k, bool compat)
+{
+	if (IS_ENABLED(CONFIG_COMPAT) && compat)
+		return put_user(k->mt_blkno, (u32 __user *)u);
+	else
+		return put_user(k->mt_blkno, (long __user *)u);
+}
+
+#endif
-- 
2.18.0
