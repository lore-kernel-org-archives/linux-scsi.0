From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] target/tcm_fc: use CPU affinity for responses
Date: Mon, 22 Aug 2016 10:54:11 +0200
Message-ID: <1471856051-87398-7-git-send-email-hare@suse.de>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

The libfc stack assigns exchange IDs based on the CPU the request
was received on, so we need to send the responses via the same CPU.
Otherwise the send logic gets confuses and responses will be delayed,
causing exchange timeouts on the initiator side.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/tcm_fc/tfc_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 36f0864..ff5de9a 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -572,7 +572,7 @@ static void ft_send_work(struct work_struct *work)
 	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF))
+			      TARGET_SCF_ACK_KREF | TARGET_SCF_USE_CPUID))
 		goto err;
 
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
-- 
1.8.5.6
