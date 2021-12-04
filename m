Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AE7C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383709AbhLDAaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354412AbhLDAaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:18 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AB9C061751
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:53 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r130so4427697pfc.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=penQCOHdz+dKm0WVkjWhd8LFIt83Iq116gseXWeXtXc=;
        b=cesxwG6LBRbhpDgDwkFtj7qmhOC6qEbzuvraKpAPNgiRbZW0z51CGShCBrF49+AaaP
         Dfq8GZnudvsJaWqqK1tQw+OYvVbmFAYJKiCU+Xf9m8HCi9cd1F0LrojwOC+HAjjG9Wms
         Q2Em7jow47hkCdz76uL7ifrV0QmfNxYH1+rSwhT8rR6D5mFZXnNCDsayK17rWonH7t57
         SEDYLwSOJL8Z9vwIMFGruTZjrzomT/JNI3oF/4nu9TyOdoUt6l0xOM3jOn+9IlWkb94E
         Fow+F48qcr5GksGfloP6MTHHuWTsFDIa/eK/cRDz1KD/MQR1tX6J63GvSNL43n/12j/K
         ZgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=penQCOHdz+dKm0WVkjWhd8LFIt83Iq116gseXWeXtXc=;
        b=B+i5rrwcvAnVVTZ80tdXHEBLDoMO7yhq+r1mQM27Ot9rLGDDsCJaqJZomdAKWr1aNz
         cbWfwtGbAdr/g+oUwQzpDMMh26TmYvx0U7VEW65HyJIGu8ZYEEUVE1P8wAf4W9TTAClF
         FDqNw0o8K5yfzZnVcitHrmS2p2yOc/VeRT9z3T5dFt5mHGPs020fj4HnGoitRAphk/jk
         yCfSBMdu58cnHE6p6duYQ/zZSpuN4B+LE28e1bBbl2Yc8iih6/HwpzyLcpD0J8LshLbY
         /VYqmhHFVYfF/6Q8zKmX4f2xyX63C45rxzzIywwlfVrh5QALBLLD45aERQhZiPj1Umvc
         I/Cw==
X-Gm-Message-State: AOAM532++SbTOtXgm7g7F9hvUXDIqkXNdPtFYoUql9+qRDHHE2kWo30v
        DxiyxFucjLA6Ii59IyFoMKo61oN2y1Q=
X-Google-Smtp-Source: ABdhPJzZKboEzpoFnyK3ywCHWDtdj5oNXmvivc79fl4lzMcD+NBoz4NRG1+QzoZCReuAKwlu2h4iEA==
X-Received: by 2002:a05:6a00:23cc:b0:49f:bfaa:e2f6 with SMTP id g12-20020a056a0023cc00b0049fbfaae2f6mr22401316pfc.35.1638577613102;
        Fri, 03 Dec 2021 16:26:53 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/9] lpfc: Fix NPIV port deletion crash
Date:   Fri,  3 Dec 2021 16:26:39 -0800
Message-Id: <20211204002644.116455-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is calling schedule_timeout after the DA_ID nameserver request
and LOGO commands are issued to the fabric by the initiator virtual
endport.  These fixed delay functions are causing long delays in the
driver's worker thread when processing discovery IOs in a serialized
fashion, which is then triggering mailbox timeout errors artificially.

To fix this, don't wait on the DA_ID request to complete and call
wait_event_timeout to allow the vport delete thread to make progress on
an event driven basis rather than fixing the wait time.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 -
 drivers/scsi/lpfc/lpfc_els.c     | 11 ++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  2 -
 drivers/scsi/lpfc/lpfc_vport.c   | 83 ++++++++++++++++++++++++--------
 4 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 2f8e6d0a926f..a04995832459 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -669,8 +669,6 @@ struct lpfc_vport {
 	struct timer_list els_tmofunc;
 	struct timer_list delayed_disc_tmo;
 
-	int unreg_vpi_cmpl;
-
 	uint8_t load_flag;
 #define FC_LOADING		0x1	/* HBA in process of loading drvr */
 #define FC_UNLOADING		0x2	/* HBA in process of unloading drvr */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 78024f11b794..db5ccae1b63d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10973,10 +10973,19 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_can_disctmo(vport);
 	}
 
+	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
+		/* Wake up lpfc_vport_delete if waiting...*/
+		if (ndlp->logo_waitq)
+			wake_up(ndlp->logo_waitq);
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_flag &= ~(NLP_ISSUE_LOGO | NLP_LOGO_SND);
+		ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
+		spin_unlock_irq(&ndlp->lock);
+	}
+
 	/* Safe to release resources now. */
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	vport->unreg_vpi_cmpl = VPORT_ERROR;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9fe6e5b386ce..802fd30a9fb8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3928,7 +3928,6 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	spin_unlock_irq(shost->host_lock);
-	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	lpfc_cleanup_vports_rrqs(vport, NULL);
 	/*
@@ -3958,7 +3957,6 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vport)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "1800 Could not issue unreg_vpi\n");
 		mempool_free(mbox, phba->mbox_mem_pool);
-		vport->unreg_vpi_cmpl = VPORT_ERROR;
 		return rc;
 	}
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index da9a1f72d938..d694d0cff5a5 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -485,23 +485,68 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	return rc;
 }
 
+static int
+lpfc_send_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	int rc;
+	struct lpfc_hba *phba = vport->phba;
+
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
+
+	spin_lock_irq(&ndlp->lock);
+	if (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO) &&
+	    !ndlp->logo_waitq) {
+		ndlp->logo_waitq = &waitq;
+		ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+		ndlp->nlp_flag |= NLP_ISSUE_LOGO;
+		ndlp->save_flags |= NLP_WAIT_FOR_LOGO;
+	}
+	spin_unlock_irq(&ndlp->lock);
+	rc = lpfc_issue_els_npiv_logo(vport, ndlp);
+	if (!rc) {
+		wait_event_timeout(waitq,
+				   (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO)),
+				   msecs_to_jiffies(phba->fc_ratov * 2000));
+
+		if (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO))
+			goto logo_cmpl;
+		/* LOGO wait failed.  Correct status. */
+		rc = -EINTR;
+	} else {
+		rc = -EIO;
+	}
+
+	/* Error - clean up node flags. */
+	spin_lock_irq(&ndlp->lock);
+	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
+	ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
+	spin_unlock_irq(&ndlp->lock);
+
+ logo_cmpl:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT,
+			 "1824 Issue LOGO completes with status %d\n",
+			 rc);
+	spin_lock_irq(&ndlp->lock);
+	ndlp->logo_waitq = NULL;
+	spin_unlock_irq(&ndlp->lock);
+	return rc;
+}
+
 static int
 disable_vport(struct fc_vport *fc_vport)
 {
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
-	long timeout;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
+	/* Can't disable during an outstanding delete. */
+	if (vport->load_flag & FC_UNLOADING)
+		return 0;
+
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (ndlp && phba->link_state >= LPFC_LINK_UP) {
-		vport->unreg_vpi_cmpl = VPORT_INVAL;
-		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
-		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
-			while (vport->unreg_vpi_cmpl == VPORT_INVAL && timeout)
-				timeout = schedule_timeout(timeout);
-	}
+	if (ndlp && phba->link_state >= LPFC_LINK_UP)
+		(void)lpfc_send_npiv_logo(vport, ndlp);
 
 	lpfc_sli_host_down(vport);
 
@@ -600,7 +645,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
-	long timeout;
+	int rc;
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -665,15 +710,14 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
 			/* Send DA_ID and wait for a completion. */
-			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
-			if (!lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0))
-				while (vport->ct_flags && timeout)
-					timeout = schedule_timeout(timeout);
-			else
+			rc = lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0);
+			if (rc) {
 				lpfc_printf_log(vport->phba, KERN_WARNING,
 						LOG_VPORT,
 						"1829 CT command failed to "
-						"delete objects on fabric\n");
+						"delete objects on fabric, "
+						"rc %d\n", rc);
+			}
 		}
 
 		/*
@@ -688,11 +732,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);
 		if (!ndlp)
 			goto skip_logo;
-		vport->unreg_vpi_cmpl = VPORT_INVAL;
-		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
-		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
-			while (vport->unreg_vpi_cmpl == VPORT_INVAL && timeout)
-				timeout = schedule_timeout(timeout);
+
+		rc = lpfc_send_npiv_logo(vport, ndlp);
+		if (rc)
+			goto skip_logo;
 	}
 
 	if (!(phba->pport->load_flag & FC_UNLOADING))
-- 
2.26.2

