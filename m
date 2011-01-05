From: James Bottomley <James.Bottomley@suse.de>
Subject: target: Fix excessive stack usage
Date: Tue, 04 Jan 2011 18:29:21 -0600
Message-ID: <1294187361.7879.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1AEA30 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2011 19:29:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is showing up in compiles:

  CC [M]  drivers/target/target_core_alua.o
drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
drivers/target/target_core_pr.c:1952: warning: the frame size of 1124 bytes is larger than 1024 bytes

And is caused by a tmp[1024] buffer in the routine.  This looks to be
fixable with a GFP_KERNEL allocation ... although it's hard to say; the
routine is called under the dev_reservation_lock which, best as I can
tell, is only ever called with user context ... so why isn't it a mutex?
There's also no need to zero initialise an entire string buffer; as long
as the kernel prints the string (which it does in this case), it's fine
just to start it with a null.

James

---

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index b43bf8d..6c3dd82 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1857,9 +1857,9 @@ static int __core_scsi3_update_aptpl_buf(
 	struct se_portal_group *tpg;
 	struct se_subsystem_dev *su_dev = SU_DEV(dev);
 	struct t10_pr_registration *pr_reg;
-	unsigned char tmp[1024], isid_buf[32];
+	unsigned char *tmp, isid_buf[32];
 	ssize_t len = 0;
-	int reg_count = 0;
+	int reg_count = 0, ret = 0;
 
 	memset(buf, 0, pr_aptpl_buf_len);
 	/*
@@ -1870,6 +1870,10 @@ static int __core_scsi3_update_aptpl_buf(
 				"No Registrations or Reservations\n");
 		return 0;
 	}
+	tmp = kmalloc(1024, GFP_KERNEL);
+	if (!tmp)
+		return -1;
+
 	/*
 	 * Walk the registration list..
 	 */
@@ -1877,8 +1881,8 @@ static int __core_scsi3_update_aptpl_buf(
 	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
 			pr_reg_list) {
 
-		memset(tmp, 0, 1024);
-		memset(isid_buf, 0, 32);
+		tmp[0] = '\0';
+		isid_buf[0] = '\0';
 		tpg = pr_reg->pr_reg_nacl->se_tpg;
 		lun = pr_reg->pr_reg_tg_pt_lun;
 		/*
@@ -1920,7 +1924,8 @@ static int __core_scsi3_update_aptpl_buf(
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&T10_RES(su_dev)->registration_lock);
-			return -1;
+			ret = -1;
+			goto out;
 		}
 		len += sprintf(buf+len, "%s", tmp);
 
@@ -1938,17 +1943,20 @@ static int __core_scsi3_update_aptpl_buf(
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&T10_RES(su_dev)->registration_lock);
-			return -1;
+			ret = -1;
+			goto out;
 		}
 		len += sprintf(buf+len, "%s", tmp);
 		reg_count++;
 	}
 	spin_unlock(&T10_RES(su_dev)->registration_lock);
 
-	 if (!(reg_count))
+	if (!(reg_count))
 		len += sprintf(buf+len, "No Registrations or Reservations");
 
-	return 0;
+ out:
+	kfree(tmp);
+	return ret;
 }
 
 static int core_scsi3_update_aptpl_buf(


