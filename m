From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] Print useful error message when iscsi crc23c allocation fails
Date: Wed, 28 Feb 2007 17:32:21 -0600
Message-ID: <1172705545601-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu> <11727055433394-git-send-email-michaelc@cs.wisc.edu> <1172705543740-git-send-email-michaelc@cs.wisc.edu> <1172705544330-git-send-email-michaelc@cs.wisc.edu> <11727055441132-git-send-email-michaelc@cs.wisc.edu> <11727055453295-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXB1Xcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:39 -0500
In-Reply-To: <11727055453295-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

People do not read the README and seem to like to
unselect the crc32c module even though iscsi_tcp selects
it for them. This patch spits a error that tells the user
that they really do need the module. Hopefully, we will
get less people asking about this now.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 861cb9b..c9a3abf 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1777,14 +1777,24 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->tx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->tx_hash.tfm))
+	if (IS_ERR(tcp_conn->tx_hash.tfm)) {
+		printk(KERN_ERR "Could not create connection due to crc32c "
+		       "loading error %ld. Make sure the crc32c module is "
+		       "built as a module or into the kernel\n",
+			PTR_ERR(tcp_conn->tx_hash.tfm));
 		goto free_tcp_conn;
+	}
 
 	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->rx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->rx_hash.tfm))
+	if (IS_ERR(tcp_conn->rx_hash.tfm)) {
+		printk(KERN_ERR "Could not create connection due to crc32c "
+		       "loading error %ld. Make sure the crc32c module is "
+		       "built as a module or into the kernel\n",
+			PTR_ERR(tcp_conn->rx_hash.tfm));
 		goto free_tx_tfm;
+	}
 
 	return cls_conn;
 
-- 
1.4.1.1

