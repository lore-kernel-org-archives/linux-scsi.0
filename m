From: Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH v2 5/7] iscsi-target: replace iscsi_initiatorname_tolower() with strtolower()
Date: Tue,  5 Jul 2016 13:47:09 -0700
Message-ID: <1467751631-22878-6-git-send-email-mmayer@broadcom.com>
References: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35757 "EHLO
	mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbcGEUsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 16:48:42 -0400
Received: by mail-qt0-f170.google.com with SMTP id f89so107196203qtd.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2016 13:48:42 -0700 (PDT)
In-Reply-To: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, Varun Prakash <varun@chelsio.com>
Cc: Markus Mayer <mmayer@broadcom.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

After introducing generic strtolower(), iscsi_initiatorname_tolower() is
no longer needed.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
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

