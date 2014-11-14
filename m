From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V4 linux-next RESEND 2] bfa: replace 2 kzalloc/copy_from_user by memdup_user
Date: Fri, 14 Nov 2014 19:49:58 +0100
Message-ID: <1415990998-29659-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch also removes unnecessary printk(KERN_INFO

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V4: remove blank line after memdup_user
V3: memdup_user first argument is already void __user * (thanks to Joe Perches)
    typo in title
V2: Remove printk(KERN_INFO (suggested by Alan)

 drivers/scsi/bfa/bfad_debugfs.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 8e83d04..74a307c 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -260,18 +260,9 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2) {
@@ -336,18 +327,9 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
-- 
1.9.3
