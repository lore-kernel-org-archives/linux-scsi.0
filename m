From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/5] hpsa: reorganize error handling in hpsa_passthru_ioctl
Date: Wed, 20 Feb 2013 11:24:52 -0600
Message-ID: <20130220172452.12929.66387.stgit@beardog.cce.hp.com>
References: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:46265 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab3BTQYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 11:24:54 -0500
In-Reply-To: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, shuah.khan@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38c8aa5..a7c3d47 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2959,6 +2959,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	struct CommandList *c;
 	char *buff = NULL;
 	union u64bit temp64;
+	int rc = 0;
 
 	if (!argp)
 		return -EINVAL;
@@ -2978,8 +2979,8 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 			/* Copy the data into the buffer we created */
 			if (copy_from_user(buff, iocommand.buf,
 				iocommand.buf_size)) {
-				kfree(buff);
-				return -EFAULT;
+				rc = -EFAULT;
+				goto out_kfree;
 			}
 		} else {
 			memset(buff, 0, iocommand.buf_size);
@@ -2987,8 +2988,8 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	c = cmd_special_alloc(h);
 	if (c == NULL) {
-		kfree(buff);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_kfree;
 	}
 	/* Fill in the command type */
 	c->cmd_type = CMD_IOCTL_PEND;
@@ -3027,22 +3028,22 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	memcpy(&iocommand.error_info, c->err_info,
 		sizeof(iocommand.error_info));
 	if (copy_to_user(argp, &iocommand, sizeof(iocommand))) {
-		kfree(buff);
-		cmd_special_free(h, c);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out;
 	}
 	if (iocommand.Request.Type.Direction == XFER_READ &&
 		iocommand.buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		if (copy_to_user(iocommand.buf, buff, iocommand.buf_size)) {
-			kfree(buff);
-			cmd_special_free(h, c);
-			return -EFAULT;
+			rc = -EFAULT;
+			goto out;
 		}
 	}
-	kfree(buff);
+out:
 	cmd_special_free(h, c);
-	return 0;
+out_kfree:
+	kfree(buff);
+	return rc;
 }
 
 static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)

