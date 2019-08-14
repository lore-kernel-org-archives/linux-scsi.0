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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD414C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8328120866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3yKYlC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfHNX5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37616 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbfHNX5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id 129so342471pfa.4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I4zkRjpTJmes3Rg55KRKT7IgggKDcF2Y9IUwiNG2BOk=;
        b=S3yKYlC1qhanQHDvLiT0X6C5Rg72dH7cHoDqEYzdxgJdytyX0lRfXF7qvH9ptO9TnZ
         tNuYPnjY9CVLSNGqWPg2i4dxaSk9l0A3BZ2CBJxcgGupRzbpl0Gokp2EgCtjllhx3YgP
         TSPNB9owzf1PWdMk5CzmLzLYGq+QCY/sTrkHwLa1a+PqkC1AuV7JCxHCV7nzNLHe9PQG
         mzXsFIkjwBAbVYV8ZS22YBgpQcTKrJJRTeKqgKEfAylImsFbylubcBfugbQa5AMb5taz
         05bHx+roas/+GZOubhLVcCLjcqh72MCWgnqi3HMKcKEkv331gliThUEa1DuQNyKjltIV
         mQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I4zkRjpTJmes3Rg55KRKT7IgggKDcF2Y9IUwiNG2BOk=;
        b=hyqnu1+NU1lk6tpevcrQnSLdfOvqkK3nTMDjTDkSSUGz6s5iyhCx14b+zvW8C/PL80
         0dz9FzIBkwBfY/TbWfxx4aaTuv0YBZKlPIMU1TYsBHLMt+LcOerbqTBoA4kP9steUVNT
         4ZSsilHwT5jqJ4YUHkzL1ZJ9yM1Yx/wIzm4MnHFDkhHOPsSEWR3wq7vTcJzaPsoFrBHt
         fpIQd8rwpewNeNEylQAP+wMqjM7TMXVUdlLxxwScxi8CS9PznVnungy6YKLEtq9mfKXg
         EOaiyf6W5tPIeb8so1hgKD7yUaFyC6ql0umqjJ4DszuhHVqWmFcwwknbnfGriz0RWXwi
         1VTw==
X-Gm-Message-State: APjAAAV384wsIeavMh975StjmpQjEoN7uGhuRGJksK2HKNWtuwoBrOX4
        zi/D2/TSarF1YqJHw+UnNtCdeIvO
X-Google-Smtp-Source: APXvYqxvzB1zTqIKzkrEdi4gt4JC+Y/n4QX66J7zpOYzAOgYKxfdMuA7Fb35nkk45peCg/qRm/JBfQ==
X-Received: by 2002:a65:4546:: with SMTP id x6mr1359940pgr.266.1565827055355;
        Wed, 14 Aug 2019 16:57:35 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 17/42] lpfc: Fix loss of remote port after devloss due to lack of RPIs
Date:   Wed, 14 Aug 2019 16:56:47 -0700
Message-Id: <20190814235712.4487-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In tests with remote ports contantly logging out/logging coupled
with occassional local link bounce, if a remote port is disocnnected
for longer than devloss_tmo and then subsequently reconnected,
eventually the test will fail to login with the remote port and
remote port connectivity is lost.

When devloss_tmo expires, the driver does not free the node struct
until the port or npiv instances is being deleted. The node is left
allocated but the state set to UNUSED. If the node was in the
process of logging in when the local link drop occurred, meaning
the RPI was allocated for the node in order to send the ELS, but not
yet registered which comes after successful login, the node is
moved to the NPR state, and if devloss expires, to UNUSED state.
If the remote port comes back, the node associated with it is
restarted and this path happens to allocate a new RPI and overwrites
the prior RPI value. In the cases where the port was logged in and
loggs out, the path did release the RPI but did not set the node
rpi value.  In the cases where the remote port never finished logging
in, the path never did the call to release the rpi. In this latter
case, when the node is subsequently restore, the new rpi allocation
overwrites the rpi that was not released, and the rpi is now leaked.
Eventually the port will run out of RPI resources to log into new
remote ports.

Fix by following changes
- When an rpi is released, do so under locks and ensure the
  node rpi value is set to a non-allocated value (LPFC_RPI_ALLOC_ERROR).
  Note: refactored to a small service routine to avoid indentation
  issues.
= When re-enabling a node, check the rpi value to determine if a new
  allocation is necessary. If already set, use the prior rpi.

enhanced logging to help in the future.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      |  7 ++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 41 +++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_sli.c     | 34 +++++++++++++++++++--------------
 3 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 7649903d4134..c52d5edf4d44 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -462,6 +462,7 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 	struct lpfc_nodelist *ndlp;
 
 	if ((vport->port_type != LPFC_NPIV_PORT) ||
+	    (fc4_type == FC_TYPE_FCP) ||
 	    !(vport->ct_flags & FC_CT_RFF_ID) || !vport->cfg_restrict_login) {
 
 		ndlp = lpfc_setup_disc_node(vport, Did);
@@ -501,9 +502,9 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0239 Skip x%06x NameServer Rsp "
-					 "Data: x%x x%x\n", Did,
-					 vport->fc_flag,
-					 vport->fc_rscn_id_cnt);
+					 "Data: x%x x%x %p\n",
+					 Did, vport->fc_flag,
+					 vport->fc_rscn_id_cnt, ndlp);
 		}
 	} else {
 		if (!(vport->fc_flag & FC_RSCN_MODE) ||
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6360683417b8..a47db99784ab 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4480,9 +4480,21 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return NULL;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		rpi = lpfc_sli4_alloc_rpi(vport->phba);
-		if (rpi == LPFC_RPI_ALLOC_ERROR)
+		if (ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)
+			rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		else
+			rpi = ndlp->nlp_rpi;
+
+		if (rpi == LPFC_RPI_ALLOC_ERROR) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+					 "0359 %s: ndlp:x%px "
+					 "usgmap:x%x refcnt:%d FAILED RPI "
+					 " ALLOC\n",
+					 __func__,
+					 (void *)ndlp, ndlp->nlp_usg_map,
+					 kref_read(&ndlp->kref));
 			return NULL;
+		}
 	}
 
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
@@ -4541,6 +4553,14 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (state != NLP_STE_UNUSED_NODE)
 		lpfc_nlp_set_state(vport, ndlp, state);
+	else
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0013 rpi:%x DID:%x flg:%x refcnt:%d "
+				 "map:%x x%px STATE=UNUSED\n",
+				 ndlp->nlp_rpi, ndlp->nlp_DID,
+				 ndlp->nlp_flag,
+				 kref_read(&ndlp->kref),
+				 ndlp->nlp_usg_map, ndlp);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
 		"node enable:       did:x%x",
@@ -5249,15 +5269,15 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (lpfc_matchdid(vport, ndlp, did)) {
-			data1 = (((uint32_t) ndlp->nlp_state << 24) |
-				 ((uint32_t) ndlp->nlp_xri << 16) |
-				 ((uint32_t) ndlp->nlp_type << 8) |
-				 ((uint32_t) ndlp->nlp_rpi & 0xff));
+			data1 = (((uint32_t)ndlp->nlp_state << 24) |
+				 ((uint32_t)ndlp->nlp_xri << 16) |
+				 ((uint32_t)ndlp->nlp_type << 8) |
+				 ((uint32_t)ndlp->nlp_usg_map & 0xff));
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 					 "0929 FIND node DID "
-					 "Data: x%p x%x x%x x%x %p\n",
+					 "Data: x%px x%x x%x x%x x%x x%px\n",
 					 ndlp, ndlp->nlp_DID,
-					 ndlp->nlp_flag, data1,
+					 ndlp->nlp_flag, data1, ndlp->nlp_rpi,
 					 ndlp->active_rrqs_xri_bitmap);
 			return ndlp;
 		}
@@ -5342,8 +5362,11 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		if (vport->phba->nvmet_support)
 			return NULL;
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
-		if (!ndlp)
+		if (!ndlp) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+					 "0014 Could not enable ndlp\n");
 			return NULL;
+		}
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 52704e709925..058c092bda73 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2426,6 +2426,20 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	return;
 }
 
+static void
+__lpfc_sli_rpi_release(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	unsigned long iflags;
+
+	if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+		lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
+		spin_lock_irqsave(&vport->phba->ndlp_lock, iflags);
+		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+		spin_unlock_irqrestore(&vport->phba->ndlp_lock, iflags);
+	}
+	ndlp->nlp_flag &= ~NLP_UNREG_INP;
+}
 
 /**
  * lpfc_sli_def_mbox_cmpl - Default mailbox completion handler
@@ -2507,12 +2521,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 			} else {
-				if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-					lpfc_sli4_free_rpi(vport->phba,
-							   ndlp->nlp_rpi);
-					ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-				}
-				ndlp->nlp_flag &= ~NLP_UNREG_INP;
+				__lpfc_sli_rpi_release(vport, ndlp);
 			}
 			pmb->ctx_ndlp = NULL;
 		}
@@ -2587,14 +2596,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					lpfc_issue_els_plogi(
 						vport, ndlp->nlp_DID, 0);
 				} else {
-					if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-						lpfc_sli4_free_rpi(
-							vport->phba,
-							ndlp->nlp_rpi);
-						ndlp->nlp_flag &=
-							~NLP_RELEASE_RPI;
-					}
-					ndlp->nlp_flag &= ~NLP_UNREG_INP;
+					__lpfc_sli_rpi_release(vport, ndlp);
 				}
 			}
 		}
@@ -18226,6 +18228,10 @@ __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
 		phba->sli4_hba.rpi_count--;
 		phba->sli4_hba.max_cfg_param.rpi_used--;
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2016 rpi %x not inuse\n",
+				rpi);
 	}
 }
 
-- 
2.13.7

