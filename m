From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] iscsi: fix crypto_alloc_hash() error check
Date: Sun, 17 Dec 2006 12:10:25 -0600
Message-ID: <11663790303684-git-send-email-michaelc@cs.wisc.edu>
References: <1166379028772-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbWLQSKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:10:52 -0500
In-Reply-To: <1166379028772-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Andrew Morton <akpm@osdl.org>, Mike Christie <michaelc@cs.wisc.edu>

From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of crypto_alloc_hash() should be checked by
IS_ERR().

Cc: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 61e3a61..8889686 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1777,13 +1777,13 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->tx_hash.flags = 0;
-	if (!tcp_conn->tx_hash.tfm)
+	if (IS_ERR(tcp_conn->tx_hash.tfm))
 		goto free_tcp_conn;
 
 	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->rx_hash.flags = 0;
-	if (!tcp_conn->rx_hash.tfm)
+	if (IS_ERR(tcp_conn->rx_hash.tfm))
 		goto free_tx_tfm;
 
 	return cls_conn;
-- 
1.4.1.1

