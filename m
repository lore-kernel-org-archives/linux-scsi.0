From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 27/62] target: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:07 +0800
Message-ID: <1322371662-26166-28-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1K0FeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Nov 2011 00:34:00 -0500
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/target/target_core_transport.c |    4 ++--
 drivers/target/tcm_fc/tfc_io.c         |   10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3400ae6..b4a59d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2382,7 +2382,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
 
 	offset = 0;
 	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
-		addr = kmap_atomic(sg_page(sg), KM_USER0);
+		addr = kmap_atomic(sg_page(sg));
 		if (!addr)
 			goto out;
 
@@ -2390,7 +2390,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
 			*(addr + sg->offset + i) ^= *(buf + offset + i);
 
 		offset += sg->length;
-		kunmap_atomic(addr, KM_USER0);
+		kunmap_atomic(addr);
 	}
 
 out:
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 1369b1c..1a2ff72 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -149,14 +149,13 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 					PAGE_SIZE << compound_order(page);
 		} else {
 			BUG_ON(!page);
-			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
-					   KM_SOFTIRQ0);
+			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
 			page_addr = from;
 			from += mem_off & ~PAGE_MASK;
 			tlen = min(tlen, (size_t)(PAGE_SIZE -
 						(mem_off & ~PAGE_MASK)));
 			memcpy(to, from, tlen);
-			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			kunmap_atomic(page_addr);
 			to += tlen;
 		}
 
@@ -294,14 +293,13 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 
 		tlen = min(mem_len, frame_len);
 
-		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
-				 KM_SOFTIRQ0);
+		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
 		page_addr = to;
 		to += mem_off & ~PAGE_MASK;
 		tlen = min(tlen, (size_t)(PAGE_SIZE -
 					  (mem_off & ~PAGE_MASK)));
 		memcpy(to, from, tlen);
-		kunmap_atomic(page_addr, KM_SOFTIRQ0);
+		kunmap_atomic(page_addr);
 
 		from += tlen;
 		frame_len -= tlen;
-- 
1.7.4.4

