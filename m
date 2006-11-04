From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] iscsi: always release crypto
Date: Sat, 4 Nov 2006 18:33:11 -0500
Message-ID: <20061104233311.GA14929@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d60-77-190.col.wideopenwest.com ([65.60.190.77]:43969 "EHLO
	pw.padd.com") by vger.kernel.org with ESMTP id S965741AbWKDXdM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 18:33:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Unconditionally free crypto state, as it is always allocated during
TCP connection creation.  Without this, crypto structures leak and
crc32c module refcounts grow as connections are created and
destroyed.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---

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
