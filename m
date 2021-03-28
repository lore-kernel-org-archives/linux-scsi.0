Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A74AC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 01:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F75619A2
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 01:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhC1BEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Mar 2021 21:04:39 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:48664 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230464AbhC1BEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Mar 2021 21:04:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B892812802E2;
        Sat, 27 Mar 2021 18:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1616893448;
        bh=XNPQapFOZ1LWpqHJWpj0rTpKyIoY8CSRz85nd1PLsRA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=LrrRCLSYOAIeBXiewmibxwc4UnIEaEDe+b+Q8hhMoiIPEjH3N1ieV4vDmHISRDD00
         iWbVjLnI0uUsBalYHj7jH7o0WVXJj3OLN6a7R3Jqk1A6wDPY5YDcgLJ3jBvg4rN3V7
         u5tFYvfb3gDpgXyS+UyousHvfANdR5/vnUbwU/uw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Hi4V6pLdPgbd; Sat, 27 Mar 2021 18:04:08 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 589D712802CF;
        Sat, 27 Mar 2021 18:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1616893448;
        bh=XNPQapFOZ1LWpqHJWpj0rTpKyIoY8CSRz85nd1PLsRA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=LrrRCLSYOAIeBXiewmibxwc4UnIEaEDe+b+Q8hhMoiIPEjH3N1ieV4vDmHISRDD00
         iWbVjLnI0uUsBalYHj7jH7o0WVXJj3OLN6a7R3Jqk1A6wDPY5YDcgLJ3jBvg4rN3V7
         u5tFYvfb3gDpgXyS+UyousHvfANdR5/vnUbwU/uw=
Message-ID: <466055c2bdf8d6e61b616bc9e1f7393516365bcf.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 27 Mar 2021 18:04:06 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seven fixes, all in drivers (qla2xxx, mkt3sas, qedi, target, ibmvscsi).
The most serious are the target pscsi oom and the qla2xxx revert which
can otherwise cause a use after free.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: Revert "qla2xxx: Make sure that aborted commands are freed"

Jia-Ju Bai (2):
      scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()
      scsi: qedi: Fix error return code of qedi_alloc_global_queues()

Martin Wilck (2):
      scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
      scsi: target: pscsi: Avoid OOM in pscsi_map_sg()

Tyrel Datwyler (2):
      scsi: ibmvfc: Make ibmvfc_wait_for_ops() MQ aware
      scsi: ibmvfc: Fix potential race in ibmvfc_wait_for_ops()

And the diffstat:

 drivers/scsi/ibmvscsi/ibmvfc.c      | 67 ++++++++++++++++++++++++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_base.c |  8 +++--
 drivers/scsi/qedi/qedi_main.c       |  1 +
 drivers/scsi/qla2xxx/qla_target.c   | 13 +++----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  |  4 ---
 drivers/target/target_core_pscsi.c  |  9 ++++-
 6 files changed, 74 insertions(+), 28 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6a92891ac488..bb64e3247a6c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2371,6 +2371,24 @@ static int ibmvfc_match_lun(struct ibmvfc_event *evt, void *device)
 	return 0;
 }
 
+/**
+ * ibmvfc_event_is_free - Check if event is free or not
+ * @evt:	ibmvfc event struct
+ *
+ * Returns:
+ *	true / false
+ **/
+static bool ibmvfc_event_is_free(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_event *loop_evt;
+
+	list_for_each_entry(loop_evt, &evt->queue->free, queue_list)
+		if (loop_evt == evt)
+			return true;
+
+	return false;
+}
+
 /**
  * ibmvfc_wait_for_ops - Wait for ops to complete
  * @vhost:	ibmvfc host struct
@@ -2385,35 +2403,58 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 {
 	struct ibmvfc_event *evt;
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int wait;
+	int wait, i, q_index, q_size;
 	unsigned long flags;
 	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
+	struct ibmvfc_queue *queues;
 
 	ENTER;
+	if (vhost->mq_enabled && vhost->using_channels) {
+		queues = vhost->scsi_scrqs.scrqs;
+		q_size = vhost->scsi_scrqs.active_queues;
+	} else {
+		queues = &vhost->crq;
+		q_size = 1;
+	}
+
 	do {
 		wait = 0;
-		spin_lock_irqsave(&vhost->crq.l_lock, flags);
-		list_for_each_entry(evt, &vhost->crq.sent, queue_list) {
-			if (match(evt, device)) {
-				evt->eh_comp = &comp;
-				wait++;
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		for (q_index = 0; q_index < q_size; q_index++) {
+			spin_lock(&queues[q_index].l_lock);
+			for (i = 0; i < queues[q_index].evt_pool.size; i++) {
+				evt = &queues[q_index].evt_pool.events[i];
+				if (!ibmvfc_event_is_free(evt)) {
+					if (match(evt, device)) {
+						evt->eh_comp = &comp;
+						wait++;
+					}
+				}
 			}
+			spin_unlock(&queues[q_index].l_lock);
 		}
-		spin_unlock_irqrestore(&vhost->crq.l_lock, flags);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 		if (wait) {
 			timeout = wait_for_completion_timeout(&comp, timeout);
 
 			if (!timeout) {
 				wait = 0;
-				spin_lock_irqsave(&vhost->crq.l_lock, flags);
-				list_for_each_entry(evt, &vhost->crq.sent, queue_list) {
-					if (match(evt, device)) {
-						evt->eh_comp = NULL;
-						wait++;
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				for (q_index = 0; q_index < q_size; q_index++) {
+					spin_lock(&queues[q_index].l_lock);
+					for (i = 0; i < queues[q_index].evt_pool.size; i++) {
+						evt = &queues[q_index].evt_pool.events[i];
+						if (!ibmvfc_event_is_free(evt)) {
+							if (match(evt, device)) {
+								evt->eh_comp = NULL;
+								wait++;
+							}
+						}
 					}
+					spin_unlock(&queues[q_index].l_lock);
 				}
-				spin_unlock_irqrestore(&vhost->crq.l_lock, flags);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (wait)
 					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
 				LEAVE;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ac066f86bb14..ac0eef975f17 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7806,14 +7806,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->pend_os_device_add_sz++;
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
-	if (!ioc->pend_os_device_add)
+	if (!ioc->pend_os_device_add) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->device_remove_in_progress_sz = ioc->pend_os_device_add_sz;
 	ioc->device_remove_in_progress =
 		kzalloc(ioc->device_remove_in_progress_sz, GFP_KERNEL);
-	if (!ioc->device_remove_in_progress)
+	if (!ioc->device_remove_in_progress) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->fwfault_debug = mpt3sas_fwfault_debug;
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 47ad64b06623..69c5b5ee2169 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1675,6 +1675,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		if (!qedi->global_queues[i]) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to allocation global queue %d.\n", i);
+			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c48daf52725d..480e7d2dcf3e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3222,8 +3222,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
@@ -3234,8 +3233,9 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
-	if (unlikely(res != 0))
-		goto free;
+	if (unlikely(res != 0)) {
+		return res;
+	}
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
@@ -3255,8 +3255,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3359,8 +3358,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-free:
-	vha->hw->tgt.tgt_ops->free_cmd(cmd);
 	return res;
 }
 EXPORT_SYMBOL(qlt_xmit_response);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b55fc768a2a7..8b4890cdd4ca 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -644,7 +644,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -657,7 +656,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 
@@ -685,7 +683,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	if (cmd->aborted) {
@@ -699,7 +696,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
 		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
 		    cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 	cmd->bufflen = se_cmd->data_length;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3cbc074992bc..9ee797b8cb7e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -882,7 +882,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio) {
 new_bio:
 				nr_vecs = bio_max_segs(nr_pages);
-				nr_pages -= nr_vecs;
 				/*
 				 * Calls bio_kmalloc() and sets bio->bi_end_io()
 				 */
@@ -939,6 +938,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	return 0;
 fail:
+	if (bio)
+		bio_put(bio);
+	while (req->bio) {
+		bio = req->bio;
+		req->bio = bio->bi_next;
+		bio_put(bio);
+	}
+	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 

