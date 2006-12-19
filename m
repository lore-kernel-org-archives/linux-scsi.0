From: akpm@osdl.org
Subject: [patch 21/26] iscsi: fix crypto_alloc_hash() error check
Date: Tue, 19 Dec 2006 13:14:56 -0800
Message-ID: <200612192114.kBJLEuVp010743@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbWLSVPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:15:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, akinobu.mita@gmail.com, dmitry_yus@yahoo.com, itn780@yahoo.com, michaelc@cs.wisc.edu

From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of crypto_alloc_hash() should be checked by
IS_ERR().

Cc: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/iscsi_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check
+++ a/drivers/scsi/iscsi_tcp.c
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
_
