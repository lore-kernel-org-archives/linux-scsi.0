From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 1/3] target: Inline transport_get_sense_codes()
Date: Mon,  6 Jul 2015 11:02:25 +0300
Message-ID: <1436169747-28834-2-git-send-email-sagig@mellanox.com>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

Inline this function in its call site since it performs a trivial
task and since it is only called once.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1bc8378..e895156 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2620,17 +2620,6 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-static int transport_get_sense_codes(
-	struct se_cmd *cmd,
-	u8 *asc,
-	u8 *ascq)
-{
-	*asc = cmd->scsi_asc;
-	*ascq = cmd->scsi_ascq;
-
-	return 0;
-}
-
 static
 void transport_err_sector_info(unsigned char *buffer, sector_t bad_sector)
 {
@@ -2824,9 +2813,8 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* Not Ready */
 		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		transport_get_sense_codes(cmd, &asc, &ascq);
-		buffer[SPC_ASC_KEY_OFFSET] = asc;
-		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+		buffer[SPC_ASC_KEY_OFFSET] = cmd->scsi_asc;
+		buffer[SPC_ASCQ_KEY_OFFSET] = cmd->scsi_ascq;
 		break;
 	case TCM_MISCOMPARE_VERIFY:
 		/* CURRENT ERROR */
-- 
1.8.4.3
