From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 13/14] tcm_fc: Convert to TARGET_SCF_ACK_KREF I/O + TMR krefs
Date: Sat, 30 Jan 2016 07:05:57 +0000
Message-ID: <1454137558-30396-14-git-send-email-nab@daterainc.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454137558-30396-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>, Vasu Dev <vasu.dev@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 064d6df..768aec3 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -107,8 +107,7 @@ void ft_release_cmd(struct se_cmd *se_cmd)
 
 int ft_check_stop_free(struct se_cmd *se_cmd)
 {
-	transport_generic_free_cmd(se_cmd, 0);
-	return 1;
+	return transport_generic_free_cmd(se_cmd, 0);
 }
 
 /*
@@ -179,6 +178,12 @@ int ft_queue_status(struct se_cmd *se_cmd)
 		return -ENOMEM;
 	}
 	lport->tt.exch_done(cmd->seq);
+	/*
+	 * Drop the extra ACK_KREF reference taken by target_submit_cmd()
+	 * ahead of ft_check_stop_free() -> transport_generic_free_cmd()
+	 * final se_cmd->cmd_kref put.
+	 */
+	target_put_sess_cmd(&cmd->se_cmd);
 	return 0;
 }
 
@@ -422,6 +427,12 @@ void ft_queue_tm_resp(struct se_cmd *se_cmd)
 	pr_debug("tmr fn %d resp %d fcp code %d\n",
 		  tmr->function, tmr->response, code);
 	ft_send_resp_code(cmd, code);
+	/*
+	 * Drop the extra ACK_KREF reference taken by target_submit_tmr()
+	 * ahead of ft_check_stop_free() -> transport_generic_free_cmd()
+	 * final se_cmd->cmd_kref put.
+	 */
+	target_put_sess_cmd(&cmd->se_cmd);
 }
 
 void ft_aborted_task(struct se_cmd *se_cmd)
-- 
1.9.1
