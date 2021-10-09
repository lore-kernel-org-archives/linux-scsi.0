Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F56C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 21:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51F460E95
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 21:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhJIV53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 17:57:29 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:55276 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbhJIV51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 17:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1633816529;
        bh=RVOoFIwtw765v35RQld5MPceTE33+33mpkvCn2tC1GI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=hv6kJn+AWQAzKfcdc18uih5j6RwO4GV3+cr95FDAnPmZ04q4Cg4jHyf3Ir0bQPH8U
         40qVKZNyv+Z/DdoGr4/XizfEYOyAHfQGFJRylM/6e3tETCDEV9UCvg4HD4zHIeihqo
         Pc4RV9rvrr3o7NBbj0gj84Ug6rmLHOfkoZyrx8pE=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id DB88B1280D79;
        Sat,  9 Oct 2021 14:55:29 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XsdJ-zfbuRdM; Sat,  9 Oct 2021 14:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1633816529;
        bh=RVOoFIwtw765v35RQld5MPceTE33+33mpkvCn2tC1GI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=hv6kJn+AWQAzKfcdc18uih5j6RwO4GV3+cr95FDAnPmZ04q4Cg4jHyf3Ir0bQPH8U
         40qVKZNyv+Z/DdoGr4/XizfEYOyAHfQGFJRylM/6e3tETCDEV9UCvg4HD4zHIeihqo
         Pc4RV9rvrr3o7NBbj0gj84Ug6rmLHOfkoZyrx8pE=
Received: from [172.20.0.118] (unknown [50.237.197.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 69EE41280D77;
        Sat,  9 Oct 2021 14:55:29 -0700 (PDT)
Message-ID: <4083dcd4a97427aef6ffca411c1147af4fbd1bcd.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.15-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 09 Oct 2021 16:55:28 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five fixes, all in drivers.  The big change is the UFS task management
rework, with lpfc next and the rest being fairly minor and obvious
fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: core: Fix task management completion

Dan Carpenter (1):
      scsi: elx: efct: Delete stray unlock statement

James Smart (1):
      scsi: lpfc: Fix memory overwrite during FC-GS I/O abort handling

John Garry (1):
      scsi: acornscsi: Remove scsi_cmd_to_tag() reference

Mike Christie (1):
      scsi: iscsi: Fix iscsi_task use after free

And the diffstat:

 drivers/scsi/arm/acornscsi.c      |  2 +-
 drivers/scsi/elx/efct/efct_scsi.c |  3 +--
 drivers/scsi/libiscsi.c           | 15 ++++++-----
 drivers/scsi/lpfc/lpfc_sli.c      | 11 ++++++---
 drivers/scsi/ufs/ufshcd.c         | 52 +++++++++++++++++----------------------
 drivers/scsi/ufs/ufshcd.h         |  1 +
 6 files changed, 41 insertions(+), 43 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index b4cb5fb19998..0cc62c1b0825 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1776,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
 	host->scsi.disconnectable = 0;
 	if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
 	    host->SCpnt->device->lun == host->scsi.reconnected.lun &&
-	    scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
+	    scsi_cmd_to_rq(host->SCpnt)->tag == host->scsi.reconnected.tag) {
 #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
 	    DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
 		    host->host->host_no, acornscsi_target(host)));
diff --git a/drivers/scsi/elx/efct/efct_scsi.c b/drivers/scsi/elx/efct/efct_scsi.c
index 40fb3a724c76..cf2e41dd354c 100644
--- a/drivers/scsi/elx/efct/efct_scsi.c
+++ b/drivers/scsi/elx/efct/efct_scsi.c
@@ -32,7 +32,7 @@ efct_scsi_io_alloc(struct efct_node *node)
 	struct efct *efct;
 	struct efct_xport *xport;
 	struct efct_io *io;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	efct = node->efct;
 
@@ -44,7 +44,6 @@ efct_scsi_io_alloc(struct efct_node *node)
 	if (!io) {
 		efc_log_err(efct, "IO alloc Failed\n");
 		atomic_add_return(1, &xport->io_alloc_failed_count);
-		spin_unlock_irqrestore(&node->active_ios_lock, flags);
 		return NULL;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4683c183e9d4..5bc91d34df63 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2281,11 +2281,6 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
-	conn = session->leadconn;
-	iscsi_get_conn(conn->cls_conn);
-	conn->eh_abort_cnt++;
-	age = session->age;
-
 	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task || !task->sc) {
@@ -2293,8 +2288,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 
 		spin_unlock(&session->back_lock);
-		goto success;
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		return SUCCESS;
 	}
+
+	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
+	conn->eh_abort_cnt++;
+	age = session->age;
+
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 78ce38d7251c..026a1196a54d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12292,12 +12292,12 @@ void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = NULL;
 	IOCB_t *irsp = &rspiocb->iocb;
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"0139 Ignoring ELS cmd tag x%x completion Data: "
+			"0139 Ignoring ELS cmd code x%x completion Data: "
 			"x%x x%x x%x\n",
 			irsp->ulpIoTag, irsp->ulpStatus,
 			irsp->un.ulpWord[4], irsp->ulpTimeout);
@@ -12305,10 +12305,13 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
 	 * if exchange is busy.
 	 */
-	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
+	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) {
+		ndlp = cmdiocb->context_un.ndlp;
 		lpfc_ct_free_iocb(phba, cmdiocb);
-	else
+	} else {
+		ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 		lpfc_els_free_iocb(phba, cmdiocb);
+	}
 
 	lpfc_nlp_put(ndlp);
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 188de6f91050..95be7ecdfe10 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6377,27 +6377,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	return retval;
 }
 
-struct ctm_info {
-	struct ufs_hba	*hba;
-	unsigned long	pending;
-	unsigned int	ncpl;
-};
-
-static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
-{
-	struct ctm_info *const ci = priv;
-	struct completion *c;
-
-	WARN_ON_ONCE(reserved);
-	if (test_bit(req->tag, &ci->pending))
-		return true;
-	ci->ncpl++;
-	c = req->end_io_data;
-	if (c)
-		complete(c);
-	return true;
-}
-
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
@@ -6408,18 +6387,24 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	unsigned long flags;
-	struct request_queue *q = hba->tmf_queue;
-	struct ctm_info ci = {
-		.hba	 = hba,
-	};
+	unsigned long flags, pending, issued;
+	irqreturn_t ret = IRQ_NONE;
+	int tag;
+
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ci.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	issued = hba->outstanding_tasks & ~pending;
+	for_each_set_bit(tag, &issued, hba->nutmrs) {
+		struct request *req = hba->tmf_rqs[tag];
+		struct completion *c = req->end_io_data;
+
+		complete(c);
+		ret = IRQ_HANDLED;
+	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
+	return ret;
 }
 
 /**
@@ -6542,9 +6527,9 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	blk_mq_start_request(req);
 
 	task_tag = req->tag;
+	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
@@ -6585,6 +6570,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -9635,6 +9621,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		err = PTR_ERR(hba->tmf_queue);
 		goto free_tmf_tag_set;
 	}
+	hba->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
+				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
+	if (!hba->tmf_rqs) {
+		err = -ENOMEM;
+		goto free_tmf_queue;
+	}
 
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f0da5d3db1fa..41f6e06f9185 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -828,6 +828,7 @@ struct ufs_hba {
 
 	struct blk_mq_tag_set tmf_tag_set;
 	struct request_queue *tmf_queue;
+	struct request **tmf_rqs;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;

