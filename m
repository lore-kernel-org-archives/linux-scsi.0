From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 13/14] tcm_fc: Convert to TARGET_SCF_ACK_KREF I/O + TMR krefs
Date: Fri, 11 Mar 2016 06:30:09 +0000
Message-ID: <1457677810-2478-14-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34253 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042AbcCKGey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 01:34:54 -0500
Received: by mail-ob0-f181.google.com with SMTP id ts10so104308680obc.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 22:34:54 -0800 (PST)
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mark Rustad <mark.d.rustad@intel.com>, Robert Love <robert.w.love@intel.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts tcm_fc to modern TARGET_SCF_ACK_KREF
usage for ft_queue_status(), and fixes ft_check_stop_free()
to return transport_generic_free_cmd() for ->cmd_kref.

It also converts TM request -> ft_send_tm() to use ACK_KREF,
and update ft_queue_tm_resp() to drop the outstanding kref
after queueing TM response into fabric code.

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 064d6df..216e18c 100644
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
 
@@ -387,7 +392,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	/* FIXME: Add referenced task tag for ABORT_TASK */
 	rc = target_submit_tmr(&cmd->se_cmd, cmd->sess->se_sess,
 		&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-		cmd, tm_func, GFP_KERNEL, 0, 0);
+		cmd, tm_func, GFP_KERNEL, 0, TARGET_SCF_ACK_KREF);
 	if (rc < 0)
 		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
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
@@ -560,7 +571,8 @@ static void ft_send_work(struct work_struct *work)
 	 */
 	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-			      ntohl(fcp->fc_dl), task_attr, data_dir, 0))
+			      ntohl(fcp->fc_dl), task_attr, data_dir,
+			      TARGET_SCF_ACK_KREF))
 		goto err;
 
 	pr_debug("r_ctl %x alloc target_submit_cmd\n", fh->fh_r_ctl);
-- 
1.9.1

