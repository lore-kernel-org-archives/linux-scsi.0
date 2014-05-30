From: Fabian Frederick <fabf@skynet.be>
Subject: [RFC 1/1] drivers/scsi/bfa/bfad_debugfs.c: replace 2 kzalloc/copy_from_user to memdup_user
Date: Fri, 30 May 2014 19:07:36 +0200
Message-ID: <1401469656-10332-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

(memdup_user can be used to replace kmalloc/copy_from_user. Not sure if it's ok with kzalloc ...)

Cc: linux-scsi@vger.kernel.org
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/bfa/bfad_debugfs.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 8e83d04..07b9e36 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -260,17 +260,12 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
+	kern_buf = memdup_user((void __user *)buf, nbytes);
 
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
+	if (IS_ERR(kern_buf)) {
+		printk(KERN_INFO "bfad[%d]: Failed to copy buffer\n",
+		       bfad->inst_no);
+		return PTR_ERR(kern_buf);
 	}
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
@@ -336,17 +331,12 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
+	kern_buf = memdup_user((void __user *)buf, nbytes);
 
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
+	if (IS_ERR(kern_buf)) {
+		printk(KERN_INFO "bfad[%d]: Failed to copy buffer\n",
+		       bfad->inst_no);
+		return PTR_ERR(kern_buf);
 	}
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
-- 
1.8.4.5
