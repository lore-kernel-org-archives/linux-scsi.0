From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 06 Jul 2018 14:38:54 -0700
Message-ID: <1530913134.3135.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is two minor bug fixes (aacraid, target) and a fix for a potential
exploit in the way sg handles teardown.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

David Disseldorp (1):
      scsi: target: Fix truncated PR-in ReadKeys response

Jann Horn (1):
      scsi: sg: mitigate read/write abuse

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix PD performance regression over incorrect qd being set

And the diffstat:

 drivers/scsi/aacraid/aachba.c   | 15 +++++++--------
 drivers/scsi/sg.c               | 42 +++++++++++++++++++++++++++++++++++++++--
 drivers/target/target_core_pr.c | 15 ++++++++++-----
 3 files changed, 57 insertions(+), 15 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a9831bd37a73..a57f3a7d4748 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1974,7 +1974,6 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev)
 	u32 lun_count, nexus;
 	u32 i, bus, target;
 	u8 expose_flag, attribs;
-	u8 devtype;
 
 	lun_count = aac_get_safw_phys_lun_count(dev);
 
@@ -1992,23 +1991,23 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev)
 			continue;
 
 		if (expose_flag != 0) {
-			devtype = AAC_DEVTYPE_RAID_MEMBER;
-			goto update_devtype;
+			dev->hba_map[bus][target].devtype =
+				AAC_DEVTYPE_RAID_MEMBER;
+			continue;
 		}
 
 		if (nexus != 0 && (attribs & 8)) {
-			devtype = AAC_DEVTYPE_NATIVE_RAW;
+			dev->hba_map[bus][target].devtype =
+				AAC_DEVTYPE_NATIVE_RAW;
 			dev->hba_map[bus][target].rmw_nexus =
 					nexus;
 		} else
-			devtype = AAC_DEVTYPE_ARC_RAW;
+			dev->hba_map[bus][target].devtype =
+				AAC_DEVTYPE_ARC_RAW;
 
 		dev->hba_map[bus][target].scan_counter = dev->scan_counter;
 
 		aac_set_safw_target_qd(dev, bus, target);
-
-update_devtype:
-		dev->hba_map[bus][target].devtype = devtype;
 	}
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 53ae52dbff84..cd2fdac000c9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -51,6 +51,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
+#include <linux/cred.h> /* for sg_check_file_access() */
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -209,6 +210,33 @@ static void sg_device_destroy(struct kref *kref);
 	sdev_prefix_printk(prefix, (sdp)->device,		\
 			   (sdp)->disk->disk_name, fmt, ##a)
 
+/*
+ * The SCSI interfaces that use read() and write() as an asynchronous variant of
+ * ioctl(..., SG_IO, ...) are fundamentally unsafe, since there are lots of ways
+ * to trigger read() and write() calls from various contexts with elevated
+ * privileges. This can lead to kernel memory corruption (e.g. if these
+ * interfaces are called through splice()) and privilege escalation inside
+ * userspace (e.g. if a process with access to such a device passes a file
+ * descriptor to a SUID binary as stdin/stdout/stderr).
+ *
+ * This function provides protection for the legacy API by restricting the
+ * calling context.
+ */
+static int sg_check_file_access(struct file *filp, const char *caller)
+{
+	if (filp->f_cred != current_real_cred()) {
+		pr_err_once("%s: process %d (%s) changed security contexts after opening file descriptor, this is not allowed.\n",
+			caller, task_tgid_vnr(current), current->comm);
+		return -EPERM;
+	}
+	if (uaccess_kernel()) {
+		pr_err_once("%s: process %d (%s) called from kernel context, this is not allowed.\n",
+			caller, task_tgid_vnr(current), current->comm);
+		return -EACCES;
+	}
+	return 0;
+}
+
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
@@ -393,6 +421,14 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
 
+	/*
+	 * This could cause a response to be stranded. Close the associated
+	 * file descriptor to free up any resources being held.
+	 */
+	retval = sg_check_file_access(filp, __func__);
+	if (retval)
+		return retval;
+
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
@@ -580,9 +616,11 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
 	unsigned char cmnd[SG_MAX_CDB_SIZE];
+	int retval;
 
-	if (unlikely(uaccess_kernel()))
-		return -EINVAL;
+	retval = sg_check_file_access(filp, __func__);
+	if (retval)
+		return retval;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 01ac306131c1..10db5656fd5d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3727,11 +3727,16 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 		 * Check for overflow of 8byte PRI READ_KEYS payload and
 		 * next reservation key list descriptor.
 		 */
-		if ((add_len + 8) > (cmd->data_length - 8))
-			break;
-
-		put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
-		off += 8;
+		if (off + 8 <= cmd->data_length) {
+			put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
+			off += 8;
+		}
+		/*
+		 * SPC5r17: 6.16.2 READ KEYS service action
+		 * The ADDITIONAL LENGTH field indicates the number of bytes in
+		 * the Reservation key list. The contents of the ADDITIONAL
+		 * LENGTH field are not altered based on the allocation length
+		 */
 		add_len += 8;
 	}
 	spin_unlock(&dev->t10_pr.registration_lock);
