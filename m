From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
Date: Mon, 14 Jan 2008 15:43:18 +0100
Message-ID: <1200321798-27015-1-git-send-email-mathieu.segaud@regala.cx>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753627AbYANOnd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Segaud <mathieu.segaud@regala.cx>
List-Id: linux-scsi@vger.kernel.org

As of now, compat_ioctl already runs without the BKL, whereas ioctl runs
with the BKL. This patch first converts changer_fops to use a .unlocked_ioctl
member. It applies the same locking rationale than ch_ioctl_compat() uses
to ch_ioctl().

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/ch.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2311019..cead0f5 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -92,8 +92,7 @@ static int  ch_probe(struct device *);
 static int  ch_remove(struct device *);
 static int  ch_open(struct inode * inode, struct file * filp);
 static int  ch_release(struct inode * inode, struct file * filp);
-static int  ch_ioctl(struct inode * inode, struct file * filp,
-		     unsigned int cmd, unsigned long arg);
+static long ch_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long ch_ioctl_compat(struct file * filp,
 			    unsigned int cmd, unsigned long arg);
@@ -130,12 +129,12 @@ static struct scsi_driver ch_template =
 
 static const struct file_operations changer_fops =
 {
-	.owner        = THIS_MODULE,
-	.open         = ch_open,
-	.release      = ch_release,
-	.ioctl        = ch_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= ch_open,
+	.release	= ch_release,
+	.unlocked_ioctl	= ch_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = ch_ioctl_compat,
+	.compat_ioctl	= ch_ioctl_compat,
 #endif
 };
 
@@ -626,7 +625,7 @@ ch_checkrange(scsi_changer *ch, unsigned int type, unsigned int unit)
 	return 0;
 }
 
-static int ch_ioctl(struct inode * inode, struct file * file,
+static long ch_ioctl(struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
 	scsi_changer *ch = file->private_data;
@@ -887,8 +886,7 @@ static long ch_ioctl_compat(struct file * file,
 	case CHIOINITELEM:
 	case CHIOSVOLTAG:
 		/* compatible */
-		return ch_ioctl(NULL /* inode, unused */,
-				file, cmd, arg);
+		return ch_ioctl(file, cmd, arg);
 	case CHIOGSTATUS32:
 	{
 		struct changer_element_status32 ces32;
-- 
1.5.3.8

