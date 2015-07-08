From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 1/5] target: Inline transport_get_sense_codes()
Date: Wed,  8 Jul 2015 17:58:50 +0300
Message-ID: <1436367534-15995-2-git-send-email-sagig@mellanox.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:56976 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934821AbbGHO7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 10:59:22 -0400
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

Inline this function in its call site since it performs a trivial
task and since it is only called once.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

