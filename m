From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 16/21] iscsi-target: Implement iSCSI target IPv6 address printing.
Date: Wed, 17 Aug 2011 23:17:20 +0000
Message-ID: <1313623045-15916-17-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58345 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1HQXmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:42 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chris Boot <bootc@bootc.net>

From: Chris Boot <bootc@bootc.net>

The iSCSI target configfs code to print out an initiator's IPv6 address
is not fully implemented. This patch uses snprintf() with the "%pI6c"
format string to format the IPv6 address for display purposes.

Signed-off-by: Chris Boot <bootc@bootc.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_login.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index bcaf82f..daad362 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1013,19 +1013,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			goto new_sess_out;
 		}
-#if 0
-		if (!iscsi_ntop6((const unsigned char *)
-				&sock_in6.sin6_addr.in6_u,
-				(char *)&conn->ipv6_login_ip[0],
-				IPV6_ADDRESS_SPACE)) {
-			pr_err("iscsi_ntop6() failed\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-					ISCSI_LOGIN_STATUS_TARGET_ERROR);
-			goto new_sess_out;
-		}
-#else
-		pr_debug("Skipping iscsi_ntop6()\n");
-#endif
+		snprintf(conn->login_ip, sizeof(conn->login_ip), "%pI6c",
+				&sock_in6.sin6_addr.in6_u);
+		conn->login_port = ntohs(sock_in6.sin6_port);
 	} else {
 		memset(&sock_in, 0, sizeof(struct sockaddr_in));
 
-- 
1.7.6

