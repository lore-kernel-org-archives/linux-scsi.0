From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] target_core_alua: check for buffer overflow
Date: Thu, 19 Dec 2013 14:36:11 +0100
Message-ID: <1387460172-27396-2-git-send-email-hare@suse.de>
References: <1387460172-27396-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387460172-27396-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When a writing to a command-provided buffer we need to ensure
that we're not writing past the end of it.
At the same time we need to continue processing as typically
the final data length (ie the required size of the buffer)
need to be returned.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 104847e..9b1856d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -96,22 +96,33 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 		int pg_num;
 
 		off += 4;
-		put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		if (cmd->data_length > off)
+			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
 		off += 8;
-		put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		if (cmd->data_length > off)
+			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
 		off += 8;
 		rd_len += 20;
 		pg_num = 0;
 		list_for_each_entry(map_mem, &map->lba_map_mem_list,
 				    lba_map_mem_list) {
-			buf[off++] = map_mem->lba_map_mem_alua_state & 0x0f;
+			int alua_state = map_mem->lba_map_mem_alua_state;
+			int alua_pg_id = map_mem->lba_map_mem_alua_pg_id;
+
+			if (cmd->data_length > off)
+				buf[off] = alua_state & 0x0f;
+			off += 2;
+			if (cmd->data_length > off)
+				buf[off] = (alua_pg_id >> 8) & 0xff;
+			off++;
+			if (cmd->data_length > off)
+				buf[off] = (alua_pg_id & 0xff);
 			off++;
-			buf[off++] = (map_mem->lba_map_mem_alua_pg_id >> 8) & 0xff;
-			buf[off++] = (map_mem->lba_map_mem_alua_pg_id & 0xff);
 			rd_len += 4;
 			pg_num++;
 		}
-		buf[desc_num] = pg_num;
+		if (cmd->data_length > desc_num)
+			buf[desc_num] = pg_num;
 	}
 	spin_unlock(&dev->t10_alua.lba_map_lock);
 
-- 
1.7.12.4
