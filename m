Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CFDC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EDE920866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qCaUFjB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfHNX5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45991 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbfHNX5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so403521pgp.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hs2Gwj96c1P3h9nEEsYoOT+h2vRm5sFoNlI0mg43RMM=;
        b=qCaUFjB1SQD6hg09izxLHBhFEJAukhnEtNiQw54HFpKwiGfvnQTRb2KSSHxseefm3y
         0T756HPC4LYvstA7PfGlgxtwVBIG5eCyc4bv6Sz5ZiaqGlSBj8Yit+BYOwrTbwiAnnH0
         sVtyIP/cIPbT0zxFmLqIn68bsrvQ/ee81sXdMjbsLyuzLKKkasIqrT9d1+qADVoqzVex
         XQiau4J+wUFvRxYSkC4ATPt9rZXbPF34LXm8q3VqHK+3yVP6ixDLKw1MZoENm6tvmRrP
         CuyWFDZqA1EoEeZcbWjw8iHEAhpga+SOHtiDR3zPzcjpoLtuH/e1jqt9iNq7Lcc8Q27J
         ApbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hs2Gwj96c1P3h9nEEsYoOT+h2vRm5sFoNlI0mg43RMM=;
        b=mWO3YK+Xrdvjn4eJb+0t0NhnooVQAfrLY66BiX4L5tJ1n7u08YtJLyDSAfmFbg3VeB
         o/vX43vtAcS+eI/r2yc+IWXzAcKrum0FsPp6zziR5EKM/JGTyDv59bQRuh5L+lQ0pWAB
         7gqJGpLYJTZUGmB4oz1iKiegwiRKdBcipiqsmgGq4xiRwvV7dNfnRuAmogtnk/bsBQHi
         6PkrWYAVCatzod9YjUR8wqOEijjIYAquV0Rq+PmkUoCZUIdV6bIEQaPXQe/BMzwkHgsN
         cJzUwZB9O0XmnWaAG1S1NHKvvvL12f1i5vzLqFdsPfxL31o/xZFXdExQwaYqDAOiYSXo
         yQEQ==
X-Gm-Message-State: APjAAAWyh8YzR9eduaGDmUUt9asuXnsBH8Q8sNWVKLis6zjTc18MFLJQ
        5RxT5IvsiPZn/sbcAi/j/+Lqhk+T
X-Google-Smtp-Source: APXvYqwsPnsTvoWqwhE6NOgeGUHOb93mSB00wz/UTCq7c1ZfYr/OQInJELuWRkFIPqPIxq6DIjcgwg==
X-Received: by 2002:a62:be04:: with SMTP id l4mr2478581pff.77.1565827059390;
        Wed, 14 Aug 2019 16:57:39 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 22/42] lpfc: Fix deadlock on host_lock during cable pulls
Date:   Wed, 14 Aug 2019 16:56:52 -0700
Message-Id: <20190814235712.4487-23-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During cable pull testing a deadlock was seen between
lpfc_nlp_counters() vs lpfc_mbox_process_link_up() vs
lpfc_work_list_done(). They are all waiting on the
shost->host_lock.

Issue is all of these cases raise irq when taking out
the lock but use spin_unlock_irq() when unlocking. The
unlock path is will unconditionally re-enable interrupts
in cases where irq state should be preserved. The re-enablement
allowed the other paths to execute which then causes the
deadlock.

Fix by converting the lock/unlock to irqsave/irqrestore.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 47 ++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a47db99784ab..44e779e4c885 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -118,6 +118,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_work_evt *evtp;
 	int  put_node;
 	int  put_rport;
+	unsigned long iflags;
 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
@@ -170,22 +171,22 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	}
 
 	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, iflags);
 	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, iflags);
 
 	/* We need to hold the node by incrementing the reference
 	 * count until this queued work is done
 	 */
 	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (evtp->evt_arg1) {
 		evtp->evt = LPFC_EVT_DEV_LOSS;
 		list_add_tail(&evtp->evt_listp, &phba->work_list);
 		lpfc_worker_wake_up(phba);
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	return;
 }
@@ -212,14 +213,15 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	int  put_node;
 	int warn_on = 0;
 	int fcf_inuse = 0;
+	unsigned long iflags;
 
 	rport = ndlp->rport;
 	vport = ndlp->vport;
 	shost = lpfc_shost_from_vport(vport);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, iflags);
 	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, iflags);
 
 	if (!rport)
 		return fcf_inuse;
@@ -3115,8 +3117,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	int rc;
 	struct fcf_record *fcf_record;
 	uint32_t fc_flags = 0;
+	unsigned long iflags;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->fc_linkspeed = bf_get(lpfc_mbx_read_top_link_spd, la);
 
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
@@ -3213,12 +3216,12 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		vport->fc_myDID = phba->fc_pref_DID;
 		fc_flags |= FC_LBIT;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	if (fc_flags) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irqsave(shost->host_lock, iflags);
 		vport->fc_flag |= fc_flags;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irqrestore(shost->host_lock, iflags);
 	}
 
 	lpfc_linkup(phba);
@@ -3292,22 +3295,22 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		 * The driver is expected to do FIP/FCF. Call the port
 		 * and get the FCF Table.
 		 */
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflags);
 		if (phba->hba_flag & FCF_TS_INPROG) {
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			return;
 		}
 		/* This is the initial FCF discovery scan */
 		phba->fcf.fcf_flag |= FCF_INIT_DISC;
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2778 Start FCF table scan at linkup\n");
 		rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba,
 						     LPFC_FCOE_FCF_GET_FIRST);
 		if (rc) {
-			spin_lock_irq(&phba->hbalock);
+			spin_lock_irqsave(&phba->hbalock, iflags);
 			phba->fcf.fcf_flag &= ~FCF_INIT_DISC;
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto out;
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
@@ -3366,6 +3369,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
 	uint8_t attn_type;
+	unsigned long iflags;
 
 	/* Unblock ELS traffic */
 	pring = lpfc_phba_elsring(phba);
@@ -3387,12 +3391,12 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, iflags);
 	if (bf_get(lpfc_mbx_read_top_pb, la))
 		vport->fc_flag |= FC_BYPASSED_MODE;
 	else
 		vport->fc_flag &= ~FC_BYPASSED_MODE;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, iflags);
 
 	if (phba->fc_eventTag <= la->eventTag) {
 		phba->fc_stat.LinkMultiEvent++;
@@ -3403,12 +3407,12 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	phba->fc_eventTag = la->eventTag;
 	if (phba->sli_rev < LPFC_SLI_REV4) {
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflags);
 		if (bf_get(lpfc_mbx_read_top_mm, la))
 			phba->sli.sli_flag |= LPFC_MENLO_MAINT;
 		else
 			phba->sli.sli_flag &= ~LPFC_MENLO_MAINT;
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
 	phba->link_events++;
@@ -4196,8 +4200,9 @@ static void
 lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	unsigned long iflags;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, iflags);
 	switch (state) {
 	case NLP_STE_UNUSED_NODE:
 		vport->fc_unused_cnt += count;
@@ -4227,7 +4232,7 @@ lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 			vport->fc_npr_cnt += count;
 		break;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, iflags);
 }
 
 static void
-- 
2.13.7

