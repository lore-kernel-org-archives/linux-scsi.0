From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -next] crct10dif: remove extra function call in crc_t10dif() and crc_t10dif_update()
Date: Wed,  6 May 2015 18:18:51 +0900
Message-ID: <1430903931-4465-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35832 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbEFJTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 05:19:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tim Chen <tim.c.chen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Calling crypto_shash_import() in crc_t10dif() and crc_t10dif_update()
is overkill as the existing crct10dif modules (crct10dif-generic and
crct10dif-pclmul) don't require.

We also do the same thing with crc32c() in lib/libcrc32.c.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 lib/crc-t10dif.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index d775737..1ad33e5 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -32,9 +32,8 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 
 	desc.shash.tfm = crct10dif_tfm;
 	desc.shash.flags = 0;
+	*(__u16 *)desc.ctx = crc;
 
-	err = crypto_shash_import(&desc.shash, &crc);
-	BUG_ON(err);
 	err = crypto_shash_update(&desc.shash, buffer, len);
 	BUG_ON(err);
 
-- 
1.9.1

