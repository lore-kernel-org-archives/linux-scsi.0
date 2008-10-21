From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/IBLOCK]: Added support for
	->create_virtdevice_from_fd()
Date: Tue, 21 Oct 2008 13:24:33 -0700
Message-ID: <1224620673.24358.32.camel__27194.0971994356$1224620793$gmane$org@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43588 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752343AbYJUUYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 16:24:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vg>
Cc: Joel Becker <joel.becker@oracle.com>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "H. Peter Anvin" <hpa@zytor.com>, Mike Christie <michaelc@cs.wisc.edu>

>From 9c6293c1bfe82d04a215fab22a3a850ea879a137 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 20 Oct 2008 23:33:01 -0700
Subject: [PATCH] [Target_Core_Mod/IBLOCK]: Added support for ->create_virtdevice_from_fd()

Added se_subsystem_api_t->create_virtdevice_from_fd() for locating
and claiming struct block_device from a passed open file descriptor for
Linux/BLOCK storage objects.

This patch also adds target_core_device.c:linux_blockdevice_claim_bd()
for use with iblock_create_virtdevice_from_fd().

This patch relies upon commit 362d4ef391699b0282dfbef3da633a561d9cbde7 for
the target_core_mod configfs infrastructure.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |   19 +++++-
 drivers/lio-core/target_core_device.h |    1 +
 drivers/lio-core/target_core_iblock.c |  116 ++++++++++++++++++++++++++-------
 drivers/lio-core/target_core_iblock.h |    2 +
 4 files changed, 112 insertions(+), 26 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 8a2a4fe..bcb564e 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -64,7 +64,24 @@
 #undef TARGET_CORE_DEVICE_C
 
 extern se_global_t *se_global;
-extern __u32 iscsi_unpack_lun (unsigned char *);
+
+extern struct block_device *linux_blockdevice_claim_bd (struct block_device *bd, void *claim_ptr)
+{
+	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ, O_RDWR) < 0)
+		return(NULL);	
+	/*
+	 * If no claim pointer was passed from claimee, use struct block_device.
+	 */
+	if (!claim_ptr)
+		claim_ptr = (void *)bd;
+
+	if (bd_claim(bd, claim_ptr) < 0) {
+		blkdev_put(bd);
+		return(NULL);
+	}
+	
+	return(bd);
+}
 
 extern struct block_device *__linux_blockdevice_claim (int major, int minor, void *claim_ptr, int *ret)
 {
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 0aaaad9..7f5a4f3 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -27,6 +27,7 @@
 #ifndef TARGET_CORE_DEVICE_H
 #define TARGET_CORE_DEVICE_H
  
+extern struct block_device *linux_blockdevice_claim_bd (struct block_device *, void *);
 extern struct block_device *__linux_blockdevice_claim (int, int, void *, int *);
 extern struct block_device *linux_blockdevice_claim (int, int, void *);
 extern int linux_blockdevice_release (int, int, struct block_device *);
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 8303786..2c66c5b 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -37,6 +37,7 @@
 #include <linux/smp_lock.h>
 #include <linux/bio.h>
 #include <linux/genhd.h>
+#include <linux/file.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
         
@@ -48,6 +49,7 @@
 #include <iscsi_target_core.h>
 #include <iscsi_target_ioctl.h>
 #include <iscsi_target_ioctl_defs.h>
+#include <target_core_device.h>
 #include <iscsi_target_device.h>
 #include <target_core_transport.h>
 #include <iscsi_target_util.h>
@@ -57,10 +59,6 @@
 #undef TARGET_CORE_IBLOCK_C
 
 extern se_global_t *se_global;
-extern struct block_device *__linux_blockdevice_claim (int, int, void *, int *); 
-extern struct block_device *linux_blockdevice_claim(int, int, void *);
-
-extern int linux_blockdevice_release(int, int, struct block_device *);
 
 #if 0
 #define DEBUG_IBLOCK(x...) PYXPRINT(x)
@@ -203,32 +201,49 @@ extern se_device_t *iblock_create_virtdevice (se_hba_t *hba, void *p)
 		TRACE_ERROR("Unable to locate iblock_dev_t parameter\n");
 		return(0);
 	}
-
-	PYXPRINT("IBLOCK: Claiming %p Major:Minor - %d:%d\n", ib_dev,
-                ib_dev->ibd_major, ib_dev->ibd_minor);
-
-	if ((bd = __linux_blockdevice_claim(ib_dev->ibd_major, ib_dev->ibd_minor, ib_dev, &ret)))
-		if (ret == 1)
-			dev_flags = DF_CLAIMED_BLOCKDEV;
-		else if (ib_dev->ibd_force) {
-			dev_flags = DF_READ_ONLY;
-			PYXPRINT("IBLOCK: DF_READ_ONLY for Major:Minor - %d:%d\n",
-				ib_dev->ibd_major, ib_dev->ibd_minor);
-		} else {
-			TRACE_ERROR("WARNING: Unable to claim block device. Only use"
-				" force=1 for READ-ONLY access.\n");
-			goto failed;
-		}
-	else
-		goto failed;	
+	/*
+	 * Check if we have an open file descritpor passed through configfs
+	 * $TARGET/iblock_0/some_bd/fd pointing to an underlying.
+	 * struct block_device.  If so, claim it with the pointer from
+	 * iblock_create_virtdevice_from_fd()
+	 *
+	 * Otherwise, assume that parameters through 'control' attribute
+	 * have set ib_dev->ibd_[major,minor]
+	 */
+	if (ib_dev->ibd_bd) {
+		PYXPRINT("IBLOCK: Claiming struct block_device: %p\n", ib_dev->ibd_bd);
 	
-	ib_dev->ibd_bd = bd;
+		if (!(bd = linux_blockdevice_claim_bd(ib_dev->ibd_bd, ib_dev))) 
+			goto failed;
+		dev_flags = DF_CLAIMED_BLOCKDEV;
+		ib_dev->ibd_major = bd->bd_disk->major;
+		ib_dev->ibd_minor = bd->bd_disk->first_minor;
+	} else {
+		PYXPRINT("IBLOCK: Claiming %p Major:Minor - %d:%d\n", ib_dev,
+			ib_dev->ibd_major, ib_dev->ibd_minor);
+
+		if ((bd = __linux_blockdevice_claim(ib_dev->ibd_major,
+				ib_dev->ibd_minor, ib_dev, &ret))) {
+			if (ret == 1)
+				dev_flags = DF_CLAIMED_BLOCKDEV;
+			else if (ib_dev->ibd_force) {
+				dev_flags = DF_READ_ONLY;
+				PYXPRINT("IBLOCK: DF_READ_ONLY for Major:Minor - %d:%d\n",
+					ib_dev->ibd_major, ib_dev->ibd_minor);
+			} else {
+				TRACE_ERROR("WARNING: Unable to claim block device. Only use"
+					" force=1 for READ-ONLY access.\n");
+				goto failed;
+			}
+			ib_dev->ibd_bd = bd;
+		} else
+			goto failed;	
+	}
 	if (dev_flags & DF_CLAIMED_BLOCKDEV)
 		ib_dev->ibd_bd->bd_contains = bd;
 
 	if (!(ib_dev->ibd_bio_set = bioset_create(32, 64))) {
-		TRACE_ERROR("Unable to create bioset for IBLOCK\n");
-		dump_stack();
+		printk(KERN_ERR "IBLOCK: Unable to create bioset()\n");
 		goto failed;
 	}
 	printk("IBLOCK: Created bio_set() for major/minor: %d:%d\n",
@@ -636,6 +651,57 @@ extern ssize_t iblock_show_configfs_dev_params (se_hba_t *hba, se_subsystem_dev_
 	return((ssize_t)bl);
 }
 
+extern se_device_t *iblock_create_virtdevice_from_fd (
+	se_subsystem_dev_t *se_dev,
+	const char *page)
+{
+	iblock_dev_t *ibd = (iblock_dev_t *) se_dev->se_dev_su_ptr;
+	se_device_t *dev = NULL;
+	struct file *filp;
+	struct inode *inode;
+	char *p = (char *)page;
+	int fd;
+
+	fd = simple_strtol(p, &p, 0);	
+	if ((fd < 3 || fd > 7)) {
+		printk(KERN_ERR "IBLOCK: Illegal value of file descriptor: %d\n", fd);
+		return(ERR_PTR(-EINVAL));
+	}
+	if (!(filp = fget(fd))) {
+		printk(KERN_ERR "IBLOCK: Unable to fget() fd: %d\n", fd);
+		return(ERR_PTR(-EBADF));
+	}
+	if (!(inode = igrab(filp->f_mapping->host))) {
+		printk(KERN_ERR "IBLOCK: Unable to locate struct inode for struct"
+				" block_device fd\n");
+		fput(filp);
+		return(ERR_PTR(-EINVAL));
+	}
+	if (!(S_ISBLK(inode->i_mode))) {
+		printk(KERN_ERR "IBLOCK: S_ISBLK(inode->i_mode) failed for file"
+				" descriptor: %d\n", fd);
+		iput(inode);
+		fput(filp);
+		return(ERR_PTR(-ENODEV));
+	}
+	if (!(ibd->ibd_bd = I_BDEV(filp->f_mapping->host))) {
+		printk(KERN_ERR "IBLOCK: Unable to locate struct block_device"
+				" from I_BDEV()\n");
+		iput(inode);
+		fput(filp);
+		return(ERR_PTR(-EINVAL));
+	}
+	/*
+	 * iblock_create_virtdevice() will call linux_blockdevice_claim_bd()
+	 * to claim struct block_device.
+	 */
+	dev = iblock_create_virtdevice(se_dev->se_dev_hba, (void *)ibd);
+
+	iput(inode);
+	fput(filp);
+	return(dev);
+}
+
 extern int iblock_check_dev_params (se_hba_t *hba, struct iscsi_target *t, se_dev_transport_info_t *dti)
 {
 	if (!(t->hba_params_set & PARAM_HBA_IBLOCK_MAJOR) ||
diff --git a/drivers/lio-core/target_core_iblock.h b/drivers/lio-core/target_core_iblock.h
index 2c793b7..5545dc5 100644
--- a/drivers/lio-core/target_core_iblock.h
+++ b/drivers/lio-core/target_core_iblock.h
@@ -66,6 +66,7 @@ extern int iblock_check_hba_params (se_hbainfo_t *, struct iscsi_target *, int);
 extern ssize_t iblock_set_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, const char *, ssize_t);
 extern ssize_t iblock_check_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *);
 extern ssize_t iblock_show_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, char *);
+extern se_device_t *iblock_create_virtdevice_from_fd (se_subsystem_dev_t *, const char *);
 extern int iblock_check_dev_params (se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
 extern int iblock_check_virtdev_params (se_devinfo_t *di, struct iscsi_target *);
 extern void iblock_get_plugin_info (void *, char *, int *);
@@ -160,6 +161,7 @@ se_subsystem_spc_t iblock_template_spc = ISCSI_IBLOCK_SPC;
 	check_configfs_dev_params: iblock_check_configfs_dev_params, \
 	set_configfs_dev_params: iblock_set_configfs_dev_params, \
 	show_configfs_dev_params: iblock_show_configfs_dev_params, \
+	create_virtdevice_from_fd: iblock_create_virtdevice_from_fd, \
 	check_virtdev_params:	iblock_check_virtdev_params,	\
 	check_dev_params:	iblock_check_dev_params,	\
 	get_plugin_info:	iblock_get_plugin_info,		\
-- 
1.5.4.1



