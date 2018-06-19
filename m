From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3] target: fix truncated PR-in ReadKeys response
Date: Tue, 19 Jun 2018 17:58:24 +0200
Message-ID: <20180619155824.15388-1-ddiss@suse.de>
References: <20180619140216.23077c60@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180619140216.23077c60@suse.de>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org, stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>
List-Id: linux-scsi@vger.kernel.org

SPC5r17 states that the contents of the ADDITIONAL LENGTH field are not
altered based on the allocation length, so always calculate and pack the
full key list length even if the list itself is truncated.

According to Maged:
  Yes it fixes the "Storage Spaces Persistent Reservation" test in the
  Windows 2016 Server Failover Cluster validation suites when having
  many connections that result in more than 8 registrations. I tested
  your patch on 4.17 with iblock.

This behaviour can be tested using the libiscsi PrinReadKeys.Truncate
test.

Cc: stable@vger.kernel.org
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Tested-by: Maged Mokhtar <mmokhtar@petasan.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changes since v2:
* drop unnecessary braces
* add Christoph's Reviewed-by

Changes since v1:
* CC stable
* mention Maged's Windows PR test fix comment in commit message
* add Reviewed-by and Tested-by tags

 drivers/target/target_core_pr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 01ac306131c1..10db5656fd5d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3727,11 +3727,16 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 		 * Check for overflow of 8byte PRI READ_KEYS payload and
 		 * next reservation key list descriptor.
 		 */
-		if ((add_len + 8) > (cmd->data_length - 8))
-			break;
-
-		put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
-		off += 8;
+		if (off + 8 <= cmd->data_length) {
+			put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
+			off += 8;
+		}
+		/*
+		 * SPC5r17: 6.16.2 READ KEYS service action
+		 * The ADDITIONAL LENGTH field indicates the number of bytes in
+		 * the Reservation key list. The contents of the ADDITIONAL
+		 * LENGTH field are not altered based on the allocation length
+		 */
 		add_len += 8;
 	}
 	spin_unlock(&dev->t10_pr.registration_lock);
-- 
2.13.7
