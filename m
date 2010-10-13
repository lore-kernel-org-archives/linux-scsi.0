From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Drop struct se_subsystem_api->create_virtdevice_from_fd()
Date: Wed, 13 Oct 2010 02:08:00 -0700
Message-ID: <1286960880-9847-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the SSA->create_virtdevice_from_fd() API op that was
originally used by TCM/IBLOCK and TCM/pSCSI to perform backstore assocation
using a user -> kernel passed file descriptor.  This is now considered an
unsafe method and this patch converts the last remaining user of this
code (TCM/IBLOCK) to enforce the usage of open_bdev_exclusive() from
a passed udev_path= within target_core_iblock:iblock_create_virtdevice().

Note that this change does break TCM/IBLOCK v3.x userspace code with
TCM v4.0 code which currently assumes generic TCM/ConfigFS file descriptor
association support with IBLOCK backstores.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_configfs.c  |   48 +-------------
 drivers/target/target_core_iblock.c    |  118 ++++----------------------------
 drivers/target/target_core_pscsi.c     |    1 -
 drivers/target/target_core_stgt.c      |    1 -
 include/target/target_core_transport.h |    5 --
 5 files changed, 16 insertions(+), 157 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 62c39d1..bd2d4af 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1930,48 +1930,6 @@ static struct target_core_configfs_attribute target_core_attr_dev_control = {
 	.store	= target_core_store_dev_control,
 };
 
-static ssize_t target_core_store_dev_fd(void *p, const char *page, size_t count)
-{
-	struct se_subsystem_dev *se_dev = (struct se_subsystem_dev *)p;
-	struct se_device *dev;
-	struct se_hba *hba = se_dev->se_dev_hba;
-	struct se_subsystem_api *t = hba->transport;
-
-	if (se_dev->se_dev_ptr) {
-		printk(KERN_ERR "se_dev->se_dev_ptr already set, ignoring"
-			" fd request\n");
-		return -EEXIST;
-	}
-
-	if (!(t->create_virtdevice_from_fd)) {
-		printk(KERN_ERR "struct se_subsystem_api->create_virtdevice_from"
-			"_fd() NULL for: %s\n", hba->transport->name);
-		return -EINVAL;
-	}
-	/*
-	 * The subsystem PLUGIN is responsible for calling target_core_mod
-	 * symbols to claim the underlying struct block_device for TYPE_DISK.
-	 */
-	dev = t->create_virtdevice_from_fd(se_dev, page);
-	if (!(dev) || IS_ERR(dev))
-		goto out;
-
-	se_dev->se_dev_ptr = dev;
-	printk(KERN_INFO "Target_Core_ConfigFS: Registered %s se_dev->se_dev"
-		"_ptr: %p from fd\n", hba->transport->name, se_dev->se_dev_ptr);
-	return count;
-out:
-	return -EINVAL;
-}
-
-static struct target_core_configfs_attribute target_core_attr_dev_fd = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "fd",
-		    .ca_mode = S_IWUSR },
-	.show	= NULL,
-	.store	= target_core_store_dev_fd,
-};
-
 static ssize_t target_core_show_dev_alias(void *p, char *page)
 {
 	struct se_subsystem_dev *se_dev = (struct se_subsystem_dev *)p;
@@ -2252,7 +2210,6 @@ static struct target_core_configfs_attribute target_core_attr_dev_alua_lu_gp = {
 static struct configfs_attribute *lio_core_dev_attrs[] = {
 	&target_core_attr_dev_info.attr,
 	&target_core_attr_dev_control.attr,
-	&target_core_attr_dev_fd.attr,
 	&target_core_attr_dev_alias.attr,
 	&target_core_attr_dev_udev_path.attr,
 	&target_core_attr_dev_enable.attr,
@@ -2992,10 +2949,7 @@ static struct config_group *target_core_call_createdev(
 	 *
 	 * se_dev->se_dev_ptr will be set after ->create_virtdev()
 	 * has been called successfully in the next level up in the
-	 * configfs tree for device object's struct config_group.  This
-	 * pointer is set in target_core_store_dev_fd() and
-	 * target_core_store_dev_enable() above depending upon the
-	 * reference method for struct scsi_device.
+	 * configfs tree for device object's struct config_group.
 	 */
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, name);
 	if (!(se_dev->se_dev_su_ptr)) {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5e810ea..e740265 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -156,49 +156,22 @@ static struct se_device *iblock_create_virtdevice(
 	}
 	printk(KERN_INFO "IBLOCK: Created bio_set()\n");
 	/*
-	 * Check if we have an open file descritpor passed through configfs
-	 * $TARGET/iblock_0/some_bd/fd pointing to an underlying.
-	 * struct block_device.  If so, claim it with the pointer from
-	 * iblock_create_virtdevice_from_fd()
-	 *
-	 * Otherwise, assume that parameters through 'control' attribute
-	 * have set ib_dev->ibd_[major,minor]
+	 * iblock_check_configfs_dev_params() ensures that ib_dev->ibd_udev_path
+	 * must already have been set in order for echo 1 > $HBA/$DEV/enable to run.
 	 */
-	if (ib_dev->ibd_bd) {
-		printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %p\n",
-			 ib_dev->ibd_bd);
-
-		ib_dev->ibd_major = MAJOR(ib_dev->ibd_bd->bd_dev);
-		ib_dev->ibd_minor = MINOR(ib_dev->ibd_bd->bd_dev);
-
-		bd = linux_blockdevice_claim(ib_dev->ibd_major,
-				ib_dev->ibd_minor, ib_dev);
-		if (!(bd)) {
-			printk(KERN_INFO "IBLOCK: Unable to claim"
-					" struct block_device\n");
-			goto failed;
-		}
-		dev_flags = DF_CLAIMED_BLOCKDEV;
-	} else {
-		/*
-		 * iblock_check_configfs_dev_params() ensures that
-		 * ib_dev->ibd_udev_path must already have been set
-		 * in order for echo 1 > $HBA/$DEV/enable to run.
-		 */
-		printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %s\n",
-				ib_dev->ibd_udev_path);
-
-		bd = open_bdev_exclusive(ib_dev->ibd_udev_path,
-				FMODE_WRITE|FMODE_READ, ib_dev);
-		if (!(bd))
-			goto failed;
-
-		dev_flags = DF_CLAIMED_BLOCKDEV;
-		ib_dev->ibd_major = MAJOR(bd->bd_dev);
-		ib_dev->ibd_minor = MINOR(bd->bd_dev);
-		ib_dev->ibd_bd = bd;
-		ib_dev->ibd_flags |= IBDF_BDEV_EXCLUSIVE;
-	}
+	printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %s\n",
+			ib_dev->ibd_udev_path);
+
+	bd = open_bdev_exclusive(ib_dev->ibd_udev_path,
+			FMODE_WRITE|FMODE_READ, ib_dev);
+	if (!(bd))
+		goto failed;
+
+	dev_flags = DF_CLAIMED_BLOCKDEV;
+	ib_dev->ibd_major = MAJOR(bd->bd_dev);
+	ib_dev->ibd_minor = MINOR(bd->bd_dev);
+	ib_dev->ibd_bd = bd;
+	ib_dev->ibd_flags |= IBDF_BDEV_EXCLUSIVE;
 	/*
 	 * Pass dev_flags for linux_blockdevice_claim() or
 	 * linux_blockdevice_claim() from the usage above.
@@ -686,66 +659,6 @@ static ssize_t iblock_show_configfs_dev_params(
 	return (ssize_t)bl;
 }
 
-static struct se_device *iblock_create_virtdevice_from_fd(
-	struct se_subsystem_dev *se_dev,
-	const char *page)
-{
-	struct iblock_dev *ibd = se_dev->se_dev_su_ptr;
-	struct se_device *dev = NULL;
-	struct file *filp;
-	struct inode *inode;
-	char *p = (char *)page;
-	unsigned long long fd;
-	int ret;
-
-	ret = strict_strtoull(p, 0, (unsigned long long *)&fd);
-	if (ret < 0) {
-		printk(KERN_ERR "strict_strtol() failed for fd\n");
-		return ERR_PTR(-EINVAL);
-	}
-	if ((fd < 3 || fd > 7)) {
-		printk(KERN_ERR "IBLOCK: Illegal value of file descriptor:"
-				" %llu\n", fd);
-		return ERR_PTR(-EINVAL);
-	}
-	filp = fget(fd);
-	if (!(filp)) {
-		printk(KERN_ERR "IBLOCK: Unable to fget() fd: %llu\n", fd);
-		return ERR_PTR(-EBADF);
-	}
-	inode = igrab(filp->f_mapping->host);
-	if (!(inode)) {
-		printk(KERN_ERR "IBLOCK: Unable to locate struct inode for"
-			" struct block_device fd\n");
-		fput(filp);
-		return ERR_PTR(-EINVAL);
-	}
-	if (!(S_ISBLK(inode->i_mode))) {
-		printk(KERN_ERR "IBLOCK: S_ISBLK(inode->i_mode) failed for file"
-				" descriptor: %llu\n", fd);
-		iput(inode);
-		fput(filp);
-		return ERR_PTR(-ENODEV);
-	}
-	ibd->ibd_bd = I_BDEV(filp->f_mapping->host);
-	if (!(ibd->ibd_bd)) {
-		printk(KERN_ERR "IBLOCK: Unable to locate struct block_device"
-				" from I_BDEV()\n");
-		iput(inode);
-		fput(filp);
-		return ERR_PTR(-EINVAL);
-	}
-	/*
-	 * iblock_create_virtdevice() will call linux_blockdevice_claim()
-	 * to claim struct block_device.
-	 */
-	dev = iblock_create_virtdevice(se_dev->se_dev_hba, se_dev, (void *)ibd);
-
-	iput(inode);
-	fput(filp);
-	return dev;
-}
-
 static void iblock_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM iBlock Plugin %s\n", IBLOCK_VERSION);
@@ -1093,7 +1006,6 @@ static struct se_subsystem_api iblock_template = {
 	.check_configfs_dev_params = iblock_check_configfs_dev_params,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
-	.create_virtdevice_from_fd = iblock_create_virtdevice_from_fd,
 	.get_plugin_info	= iblock_get_plugin_info,
 	.get_hba_info		= iblock_get_hba_info,
 	.get_dev_info		= iblock_get_dev_info,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 57ed0d6..ea96636 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1567,7 +1567,6 @@ static struct se_subsystem_api pscsi_template = {
 	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
 	.set_configfs_dev_params = pscsi_set_configfs_dev_params,
 	.show_configfs_dev_params = pscsi_show_configfs_dev_params,
-	.create_virtdevice_from_fd = NULL,
 	.get_plugin_info	= pscsi_get_plugin_info,
 	.get_hba_info		= pscsi_get_hba_info,
 	.get_dev_info		= pscsi_get_dev_info,
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index 567c3a3..2248468 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -930,7 +930,6 @@ static struct se_subsystem_api stgt_template = {
 	.check_configfs_dev_params = stgt_check_configfs_dev_params,
 	.set_configfs_dev_params = stgt_set_configfs_dev_params,
 	.show_configfs_dev_params = stgt_show_configfs_dev_params,
-	.create_virtdevice_from_fd = NULL,
 	.plugin_init		= stgt_plugin_init,
 	.plugin_free		= stgt_plugin_free,
 	.get_plugin_info	= stgt_get_plugin_info,
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index b8182e3..1f29cf3 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -496,11 +496,6 @@ struct se_subsystem_api {
 	ssize_t (*show_configfs_dev_params)(struct se_hba *, struct se_subsystem_dev *,
 						char *);
 	/*
-	 * create_virtdevice_from-fd():
-	 */
-	struct se_device *(*create_virtdevice_from_fd)(struct se_subsystem_dev *,
-						const char *);
-	/*
 	 * plugin_init():
 	 */
 	int (*plugin_init)(void);
-- 
1.5.6.5
