From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 13/38] cxlflash: Support adapter file descriptors for OpenCXL
Date: Thu, 22 Feb 2018 16:24:26 -0600
Message-ID: <1519338266-52253-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Allocate a file descriptor for an adapter context when requested. In order
to allocate inodes for the file descriptors, a pseudo filesystem is created
and used.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 200 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |   1 +
 2 files changed, 201 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 30db79d..ee3702d 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -12,13 +12,144 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/file.h>
 #include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/mount.h>
 
 #include <misc/ocxl.h>
 
 #include "backend.h"
 #include "ocxl_hw.h"
 
+/*
+ * Pseudo-filesystem to allocate inodes.
+ */
+
+#define OCXLFLASH_FS_MAGIC      0x1697698f
+
+static int ocxlflash_fs_cnt;
+static struct vfsmount *ocxlflash_vfs_mount;
+
+static const struct dentry_operations ocxlflash_fs_dops = {
+	.d_dname	= simple_dname,
+};
+
+/*
+ * ocxlflash_fs_mount() - mount the pseudo-filesystem
+ * @fs_type:	File system type.
+ * @flags:	Flags for the filesystem.
+ * @dev_name:	Device name associated with the filesystem.
+ * @data:	Data pointer.
+ *
+ * Return: pointer to the directory entry structure
+ */
+static struct dentry *ocxlflash_fs_mount(struct file_system_type *fs_type,
+					 int flags, const char *dev_name,
+					 void *data)
+{
+	return mount_pseudo(fs_type, "ocxlflash:", NULL, &ocxlflash_fs_dops,
+			    OCXLFLASH_FS_MAGIC);
+}
+
+static struct file_system_type ocxlflash_fs_type = {
+	.name		= "ocxlflash",
+	.owner		= THIS_MODULE,
+	.mount		= ocxlflash_fs_mount,
+	.kill_sb	= kill_anon_super,
+};
+
+/*
+ * ocxlflash_release_mapping() - release the memory mapping
+ * @ctx:	Context whose mapping is to be released.
+ */
+static void ocxlflash_release_mapping(struct ocxlflash_context *ctx)
+{
+	if (ctx->mapping)
+		simple_release_fs(&ocxlflash_vfs_mount, &ocxlflash_fs_cnt);
+	ctx->mapping = NULL;
+}
+
+/*
+ * ocxlflash_getfile() - allocate pseudo filesystem, inode, and the file
+ * @dev:	Generic device of the host.
+ * @name:	Name of the pseudo filesystem.
+ * @fops:	File operations.
+ * @priv:	Private data.
+ * @flags:	Flags for the file.
+ *
+ * Return: pointer to the file on success, ERR_PTR on failure
+ */
+static struct file *ocxlflash_getfile(struct device *dev, const char *name,
+				      const struct file_operations *fops,
+				      void *priv, int flags)
+{
+	struct qstr this;
+	struct path path;
+	struct file *file;
+	struct inode *inode = NULL;
+	int rc;
+
+	if (fops->owner && !try_module_get(fops->owner)) {
+		dev_err(dev, "%s: Owner does not exist\n", __func__);
+		rc = -ENOENT;
+		goto err1;
+	}
+
+	rc = simple_pin_fs(&ocxlflash_fs_type, &ocxlflash_vfs_mount,
+			   &ocxlflash_fs_cnt);
+	if (unlikely(rc < 0)) {
+		dev_err(dev, "%s: Cannot mount ocxlflash pseudofs rc=%d\n",
+			__func__, rc);
+		goto err2;
+	}
+
+	inode = alloc_anon_inode(ocxlflash_vfs_mount->mnt_sb);
+	if (IS_ERR(inode)) {
+		rc = PTR_ERR(inode);
+		dev_err(dev, "%s: alloc_anon_inode failed rc=%d\n",
+			__func__, rc);
+		goto err3;
+	}
+
+	this.name = name;
+	this.len = strlen(name);
+	this.hash = 0;
+	path.dentry = d_alloc_pseudo(ocxlflash_vfs_mount->mnt_sb, &this);
+	if (!path.dentry) {
+		dev_err(dev, "%s: d_alloc_pseudo failed\n", __func__);
+		rc = -ENOMEM;
+		goto err4;
+	}
+
+	path.mnt = mntget(ocxlflash_vfs_mount);
+	d_instantiate(path.dentry, inode);
+
+	file = alloc_file(&path, OPEN_FMODE(flags), fops);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		dev_err(dev, "%s: alloc_file failed rc=%d\n",
+			__func__, rc);
+		goto err5;
+	}
+
+	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
+	file->private_data = priv;
+out:
+	return file;
+err5:
+	path_put(&path);
+err4:
+	iput(inode);
+err3:
+	simple_release_fs(&ocxlflash_vfs_mount, &ocxlflash_fs_cnt);
+err2:
+	module_put(fops->owner);
+err1:
+	file = ERR_PTR(rc);
+	goto out;
+}
+
 /**
  * ocxlflash_set_master() - sets the context as master
  * @ctx_cookie:	Adapter context to set as master.
@@ -75,6 +206,7 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 
 	ctx->pe = rc;
 	ctx->master = false;
+	ctx->mapping = NULL;
 	ctx->hw_afu = afu;
 out:
 	return ctx;
@@ -100,6 +232,7 @@ static int ocxlflash_release_context(void *ctx_cookie)
 		goto out;
 
 	idr_remove(&ctx->hw_afu->idr, ctx->pe);
+	ocxlflash_release_mapping(ctx);
 	kfree(ctx);
 out:
 	return rc;
@@ -262,6 +395,72 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 	goto out;
 }
 
+static const struct file_operations ocxl_afu_fops = {
+	.owner		= THIS_MODULE,
+};
+
+/**
+ * ocxlflash_get_fd() - get file descriptor for an adapter context
+ * @ctx_cookie:	Adapter context.
+ * @fops:	File operations to be associated.
+ * @fd:		File descriptor to be returned back.
+ *
+ * Return: pointer to the file on success, ERR_PTR on failure
+ */
+static struct file *ocxlflash_get_fd(void *ctx_cookie,
+				     struct file_operations *fops, int *fd)
+{
+	struct ocxlflash_context *ctx = ctx_cookie;
+	struct device *dev = ctx->hw_afu->dev;
+	struct file *file;
+	int flags, fdtmp;
+	int rc = 0;
+	char *name = NULL;
+
+	/* Only allow one fd per context */
+	if (ctx->mapping) {
+		dev_err(dev, "%s: Context is already mapped to an fd\n",
+			__func__);
+		rc = -EEXIST;
+		goto err1;
+	}
+
+	flags = O_RDWR | O_CLOEXEC;
+
+	/* This code is similar to anon_inode_getfd() */
+	rc = get_unused_fd_flags(flags);
+	if (unlikely(rc < 0)) {
+		dev_err(dev, "%s: get_unused_fd_flags failed rc=%d\n",
+			__func__, rc);
+		goto err1;
+	}
+	fdtmp = rc;
+
+	/* Use default ops if there is no fops */
+	if (!fops)
+		fops = (struct file_operations *)&ocxl_afu_fops;
+
+	name = kasprintf(GFP_KERNEL, "ocxlflash:%d", ctx->pe);
+	file = ocxlflash_getfile(dev, name, fops, ctx, flags);
+	kfree(name);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		dev_err(dev, "%s: ocxlflash_getfile failed rc=%d\n",
+			__func__, rc);
+		goto err2;
+	}
+
+	ctx->mapping = file->f_mapping;
+	*fd = fdtmp;
+out:
+	return file;
+err2:
+	put_unused_fd(fdtmp);
+err1:
+	file = ERR_PTR(rc);
+	goto out;
+}
+
 /* Backend ops to ocxlflash services */
 const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.module			= THIS_MODULE,
@@ -271,4 +470,5 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.release_context	= ocxlflash_release_context,
 	.create_afu		= ocxlflash_create_afu,
 	.destroy_afu		= ocxlflash_destroy_afu,
+	.get_fd			= ocxlflash_get_fd,
 };
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 49d5d08..7f234b1 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -32,6 +32,7 @@ struct ocxl_hw_afu {
 
 struct ocxlflash_context {
 	struct ocxl_hw_afu *hw_afu;	/* HW AFU back pointer */
+	struct address_space *mapping;	/* Mapping for pseudo filesystem */
 	bool master;			/* Whether this is a master context */
 	int pe;				/* Process element */
 };
-- 
2.1.0
