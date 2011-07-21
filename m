From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 080/103] loopback: Fix memory leak in tcm_loop_make_scsi_hba()
Date: Thu, 21 Jul 2011 00:12:03 -0700
Message-ID: <1311232346-6674-81-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.146]:31261 "HELO
	nm6-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752194Ab1GUHIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:36 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jesper Juhl <jj@chaosbits.net>

From: Jesper Juhl <jj@chaosbits.net>

There is a memory leak in tcm_loop_make_scsi_hba().

If all the strstr() calls return NULL and we end up at return ERR_PTR(-EINVAL);
then we'll be leaking the memory previously allocated to tl_hba as
that variable goes out of scope.

This patch should fix the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index e53cec6..fe11a33 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1288,22 +1288,21 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 		goto check_len;
 	}
 	ptr = strstr(name, "iqn.");
-	if (ptr) {
-		tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
-		goto check_len;
+	if (!ptr) {
+		printk(KERN_ERR "Unable to locate prefix for emulated Target "
+				"Port: %s\n", name);
+		ret = -EINVAL;
+		goto out;
 	}
-
-	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
-			" %s\n", name);
-	return ERR_PTR(-EINVAL);
+	tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
 		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
 			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
 			TL_WWN_ADDR_LEN);
-		kfree(tl_hba);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto out;
 	}
 	snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
-- 
1.7.6

