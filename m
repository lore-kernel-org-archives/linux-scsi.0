From: Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH v4 5/7] iscsi-target: replace iscsi_initiatorname_tolower() with strtolower()
Date: Fri, 22 Jul 2016 16:31:07 -0700
Message-ID: <1469230269-1644-6-git-send-email-mmayer@broadcom.com>
References: <1469230269-1644-1-git-send-email-mmayer@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469230269-1644-1-git-send-email-mmayer@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, Varun Prakash <varun@chelsio.com>
Cc: Markus Mayer <mmayer@broadcom.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After introducing generic strtolower(), iscsi_initiatorname_tolower() is
no longer needed.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_nego.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 89d34bd..fa20638 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -987,21 +987,6 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 	return 0;
 }
 
-static void iscsi_initiatorname_tolower(
-	char *param_buf)
-{
-	char *c;
-	u32 iqn_size = strlen(param_buf), i;
-
-	for (i = 0; i < iqn_size; i++) {
-		c = &param_buf[i];
-		if (!isupper(*c))
-			continue;
-
-		*c = tolower(*c);
-	}
-}
-
 /*
  * Processes the first Login Request..
  */
@@ -1075,7 +1060,7 @@ int iscsi_target_locate_portal(
 	 * RFC-3720 3.2.6.1. section c) that says that iSCSI IQNs
 	 * are NOT case sensitive.
 	 */
-	iscsi_initiatorname_tolower(i_buf);
+	strtolower(i_buf);
 
 	if (!s_buf) {
 		if (!login->leading_connection)
-- 
2.7.4
