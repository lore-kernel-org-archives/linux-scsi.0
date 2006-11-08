From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/4] iscsi: always release crypto
Date: Wed, 08 Nov 2006 15:58:31 -0600
Message-ID: <11630231152581-git-send-email-michaelc@cs.wisc.edu>
References: <11630231143038-git-send-email-michaelc@cs.wisc.edu>
Reply-To: Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:27802 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965690AbWKHV6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 16:58:37 -0500
In-Reply-To: <11630231143038-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Pete Wyckoff <pw@osc.edu>

From: Pete Wyckoff <pw@osc.edu>

Unconditionally free crypto state, as it is always allocated during
TCP connection creation.  Without this, crypto structures leak and
crc32c module refcounts grow as connections are created and
destroyed.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0a9dbc5..c0b8b33 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1816,21 +1816,14 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int digest = 0;
-
-	if (conn->hdrdgst_en || conn->datadgst_en)
-		digest = 1;
 
 	iscsi_tcp_release_conn(conn);
 	iscsi_conn_teardown(cls_conn);
 
-	/* now free tcp_conn */
-	if (digest) {
-		if (tcp_conn->tx_hash.tfm)
-			crypto_free_hash(tcp_conn->tx_hash.tfm);
-		if (tcp_conn->rx_hash.tfm)
-			crypto_free_hash(tcp_conn->rx_hash.tfm);
-	}
+	if (tcp_conn->tx_hash.tfm)
+		crypto_free_hash(tcp_conn->tx_hash.tfm);
+	if (tcp_conn->rx_hash.tfm)
+		crypto_free_hash(tcp_conn->rx_hash.tfm);
 
 	kfree(tcp_conn);
 }
-- 
1.4.1.1

