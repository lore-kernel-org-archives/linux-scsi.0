From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 06/18] osd_uld: API for retrieving osd devices from Kernel
Date: Tue,  6 Jan 2009 16:16:11 +0200
Message-ID: <1231251371-5420-1-git-send-email-bharrosh@panasas.com>
References: <49636507.8060808@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:26265 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbZAFOQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:16:14 -0500
In-Reply-To: <49636507.8060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Kernel clients like exofs can retrieve struct osd_dev(s)
by means of below API.

+ osduld_path_lookup() - given a path (e.g "/dev/osd0") locks and
returns the corresponding struct osd_dev, which is then needed
for subsequent libosd use.

+ osduld_put_device() - free up use of an osd_dev.

Devices can be shared by multiple clients. The osd_uld_device's
life time is governed by an embedded kref structure.

The osd_uld_device holds an extra reference to both it's
char-device and it's scsi_device, and will release these just
before the final deallocation.

There are three possible lock sources of the osd_uld_device
1. First and for most is the probe() function called by
  scsi-ml upon a successful login into a target. Released in release()
  when logout.
2. Second by user-mode file handles opened on the char-dev.
3. Third is here by Kernel users.
All three locks must be removed before the osd_uld_device is freed.

The MODULE has three lock sources as well:
1. scsi-ml at probe() time, removed after release(). (login/logout)
2. The user-mode file handles open/close.
3. Import symbols by client modules like exofs.

TODO:
  This API is not enough for the pNFS-objects LD. A more versatile
  API will be needed. Proposed API could be:
  struct osd_dev *osduld_sysid_lookup(const char id[OSD_SYSTEMID_LEN]);

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c   |   64 ++++++++++++++++++++++++++++++++++++++++++
 include/scsi/osd_initiator.h |    5 +++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index bd6c018..b8cb141 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -42,6 +42,7 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/namei.h>
 #include <linux/cdev.h>
 #include <linux/fs.h>
 #include <linux/module.h>
@@ -142,6 +143,69 @@ static const struct file_operations osd_fops = {
 	.unlocked_ioctl = osd_uld_ioctl,
 };
 
+struct osd_dev *osduld_path_lookup(const char *path)
+{
+	struct nameidata nd;
+	struct inode *inode;
+	struct cdev *cdev;
+	struct osd_uld_device *uninitialized_var(oud);
+	int error;
+
+	if (!path || !*path) {
+		OSD_ERR("Mount with !path || !*path\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	error = path_lookup(path, LOOKUP_FOLLOW, &nd);
+	if (error) {
+		OSD_ERR("path_lookup of %s faild=>%d\n", path, error);
+		return ERR_PTR(error);
+	}
+
+	inode = nd.path.dentry->d_inode;
+	error = -EINVAL; /* Not the right device e.g osd_uld_device */
+	if (!S_ISCHR(inode->i_mode)) {
+		OSD_DEBUG("!S_ISCHR()\n");
+		goto out;
+	}
+
+	cdev = inode->i_cdev;
+	if (!cdev) {
+		OSD_ERR("Before mounting an OSD Based filesystem\n");
+		OSD_ERR("  user-mode must open+close the %s device\n", path);
+		OSD_ERR("  Example: bash: echo < %s\n", path);
+		goto out;
+	}
+
+	/* The Magic wand. Is it our char-dev */
+	/* TODO: Support sg devices */
+	if (cdev->owner != THIS_MODULE) {
+		OSD_ERR("Error mounting %s - is not an OSD device\n", path);
+		goto out;
+	}
+
+	oud = container_of(cdev, struct osd_uld_device, cdev);
+
+	__uld_get(oud);
+	error = 0;
+
+out:
+	path_put(&nd.path);
+	return error ? ERR_PTR(error) : &oud->od;
+}
+EXPORT_SYMBOL(osduld_path_lookup);
+
+void osduld_put_device(struct osd_dev *od)
+{
+	if (od) {
+		struct osd_uld_device *oud = container_of(od,
+						struct osd_uld_device, od);
+
+		__uld_put(oud);
+	}
+}
+EXPORT_SYMBOL(osduld_put_device);
+
 /*
  * Scsi Device operations
  */
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 1d92247..93fa86b 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -33,6 +33,11 @@ struct osd_dev {
 	unsigned def_timeout;
 };
 
+/* Retrieve/return osd_dev(s) for use by Kernel clients */
+struct osd_dev *osduld_path_lookup(const char *dev_name); /*Use IS_ERR/ERR_PTR*/
+void osduld_put_device(struct osd_dev *od);
+
+/* These are called by uld at probe time */
 void osd_dev_init(struct osd_dev *od, struct scsi_device *scsi_device);
 void osd_dev_fini(struct osd_dev *od);
 
-- 
1.6.0.1

