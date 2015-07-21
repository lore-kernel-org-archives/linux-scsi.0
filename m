From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target/iscsi: fix digest computation for chained SGs
Date: Mon, 20 Jul 2015 17:12:12 -0700
Message-ID: <1437437534-17931-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from catern.com ([104.131.201.120]:52706 "EHLO mail.catern.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbbGUASd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jul 2015 20:18:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: joern@purestorage.com, Alexei Potashnik <alexei@purestorage.com>

From: Alexei Potashnik <alexei@purestorage.com>

Current implementation assumes that all the buffers of an IO are linked
with a single SG list. Which makes it fail if SG chaining is used.

Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
---
 drivers/target/iscsi/iscsi_target.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4e68b62..a4cf58c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1209,7 +1209,6 @@ static u32 iscsit_do_crypto_hash_sg(
 	u8 *pad_bytes)
 {
 	u32 data_crc;
-	u32 i;
 	struct scatterlist *sg;
 	unsigned int page_off;
 
@@ -1218,15 +1217,15 @@ static u32 iscsit_do_crypto_hash_sg(
 	sg = cmd->first_data_sg;
 	page_off = cmd->first_data_sg_off;
 
-	i = 0;
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
+		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
 
-		crypto_hash_update(hash, &sg[i], cur_len);
+		crypto_hash_update(hash, sg, cur_len);
 
 		data_length -= cur_len;
 		page_off = 0;
-		i++;
+		/* iscsit_map_iovec has already checked for invalid sg pointers */
+		sg = sg_next(sg);
 	}
 
 	if (padding) {
-- 
2.4.3

