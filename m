Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C98CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C1E2089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYMGKwgM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503048AbfJRVTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38699 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so4612345pfe.5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0+Cu0VgmMOtIHukmQ1s3wFRwpxnU/ckQw9vK0ORWLl0=;
        b=mYMGKwgMwHYbTDALUUqvJOTb6qbPRawrtJ+SAqcfMIQ+Ohr+tyuY6R0T0h8PCK4Ied
         Y5kBTefLrf5GiiciU4DkoeXTtLcmJGS4JY8eeXr4W+Jso7LsVbaQFfwPrTE2rXVAfYxQ
         56xLr54nXB3piJIN1H807gHgCFHBXe1i9odUDbHTCsOsMFqHHDT3PCFecqG/oJyVu6nE
         dlUNSrFyOB0wRmN64RI4Bn0F+sReNQvxW65OM2iKV1T3VPkMTyVYjzxL1XQjpkbYWCBq
         NQzvMxTtdH2snlFxFPhtEUxYxQDgnZs24dAxDStbKzDdxHI87TY8QFaO/VU38eRhObAJ
         2Ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0+Cu0VgmMOtIHukmQ1s3wFRwpxnU/ckQw9vK0ORWLl0=;
        b=aVRddlpwxnGl6lzmCMjF8J35mXK+m7ZLmcNwYpaCQ4aJJ0qTZQcA5/FPo0zg/+kf7C
         bMknFW3g2uqgupqSh5XzwbKJfb5zqNbiullMJ3Hh1hEYSCLBjtDKYCh9yNvXw1tByikV
         /pbPTiAxkOrhoojz2vQU0Zl9KypJUnRNeGuoIUi0IZ9ZtRtFXsZEmWS599d0WDVwNKgf
         UA7B2hR6hnyf8eUT1XN0dIl/VY10ZOMJN49j0u7ceyxpWtmqDYv98UBGwok/+O26hFgp
         aSeXxpB/5Kra6ElW5TGd0dtjJQQox6Hztk97UzRMIUbwKrRKAuYFtISP18pBclob52TJ
         Gd8A==
X-Gm-Message-State: APjAAAWTj/pCuPS/DVMl85Qj1VwaGjXUVoAEqQQfl+uarNVoIv803hM8
        4P2CPXKO9l//3OnBArS3x23uOVRl
X-Google-Smtp-Source: APXvYqxgjPpd9cIhkhxTQ9o4O/WYNCDjbux8bIbRXUdtVSIhhzlWV7lDimHNf1MM3z0p6N9BAVmHzQ==
X-Received: by 2002:a17:90a:9e2:: with SMTP id 89mr13473696pjo.67.1571433562108;
        Fri, 18 Oct 2019 14:19:22 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/16] lpfc: Add additional discovery log messages
Date:   Fri, 18 Oct 2019 14:18:31 -0700
Message-Id: <20191018211832.7917-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When debugging a recent discovery customer problem it was very
hard to tell what was happening with the existing discovery log
messages. To fully debug the issue additional log messages were
necessary.

Add or extend log messages so that sufficient information is
present for debugging.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 22 +++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_els.c     | 10 ++++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 39 +++++++++++++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f883fac2d2b1..99c9bb249758 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -763,9 +763,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    cpu_to_be16(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0208 NameServer Rsp Data: x%x x%x "
-					 "sz x%x\n",
+					 "x%x x%x sz x%x\n",
 					 vport->fc_flag,
 					 CTreq->un.gid.Fc4Type,
+					 vport->num_disc_nodes,
+					 vport->gidft_inp,
 					 irsp->un.genreq64.bdl.bdeSize);
 
 			lpfc_ns_rsp(vport,
@@ -961,9 +963,13 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    cpu_to_be16(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "4105 NameServer Rsp Data: x%x x%x\n",
+					 "4105 NameServer Rsp Data: x%x x%x "
+					 "x%x x%x sz x%x\n",
 					 vport->fc_flag,
-					 CTreq->un.gid.Fc4Type);
+					 CTreq->un.gid.Fc4Type,
+					 vport->num_disc_nodes,
+					 vport->gidft_inp,
+					 irsp->un.genreq64.bdl.bdeSize);
 
 			lpfc_ns_rsp(vport,
 				    outp,
@@ -1025,6 +1031,11 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 		vport->gidft_inp--;
 	}
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "6450 GID_PT cmpl inp %d disc %d\n",
+			 vport->gidft_inp, vport->num_disc_nodes);
+
 	/* Link up / RSCN discovery */
 	if ((vport->num_disc_nodes == 0) &&
 	    (vport->gidft_inp == 0)) {
@@ -1159,6 +1170,11 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Link up / RSCN discovery */
 	if (vport->num_disc_nodes)
 		vport->num_disc_nodes--;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "6451 GFF_ID cmpl inp %d disc %d\n",
+			 vport->gidft_inp, vport->num_disc_nodes);
+
 	if (vport->num_disc_nodes == 0) {
 		/*
 		 * The driver has cycled through all Nports in the RSCN payload.
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2235a45999a8..9a1b7f331718 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5265,6 +5265,11 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 			}
 		}
 	}
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "6452 Discover PLOGI %d flag x%x\n",
+			 sentplogi, vport->fc_flag);
+
 	if (sentplogi) {
 		lpfc_set_disctmo(vport);
 	}
@@ -6668,9 +6673,10 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 
 	/* RSCN processed */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-			 "0215 RSCN processed Data: x%x x%x x%x x%x\n",
+			 "0215 RSCN processed Data: x%x x%x x%x x%x x%x x%x\n",
 			 vport->fc_flag, 0, vport->fc_rscn_id_cnt,
-			 vport->port_state);
+			 vport->port_state, vport->num_disc_nodes,
+			 vport->gidft_inp);
 
 	/* To process RSCN, first compare RSCN data with NameServer */
 	vport->fc_ns_retry = 0;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 808ad666bb1b..40075b391546 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5404,6 +5404,13 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		if (!ndlp)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "6453 Setup New Node 2B_DISC x%x "
+				 "Data:x%x x%x x%x\n",
+				 ndlp->nlp_DID, ndlp->nlp_flag,
+				 ndlp->nlp_state, vport->fc_flag);
+
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5417,6 +5424,12 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 					 "0014 Could not enable ndlp\n");
 			return NULL;
 		}
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "6454 Setup Enabled Node 2B_DISC x%x "
+				 "Data:x%x x%x x%x\n",
+				 ndlp->nlp_DID, ndlp->nlp_flag,
+				 ndlp->nlp_state, vport->fc_flag);
+
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5436,6 +5449,12 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
 
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+					 "6455 Setup RSCN Node 2B_DISC x%x "
+					 "Data:x%x x%x x%x\n",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_state, vport->fc_flag);
+
 			/* NVME Target mode waits until rport is known to be
 			 * impacted by the RSCN before it transitions.  No
 			 * active management - just go to NPR provided the
@@ -5458,9 +5477,21 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
-		} else
+		} else {
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+					 "6456 Skip Setup RSCN Node x%x "
+					 "Data:x%x x%x x%x\n",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_state, vport->fc_flag);
 			ndlp = NULL;
+		}
 	} else {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "6457 Setup Active Node 2B_DISC x%x "
+				 "Data:x%x x%x x%x\n",
+				 ndlp->nlp_DID, ndlp->nlp_flag,
+				 ndlp->nlp_state, vport->fc_flag);
+
 		/* If the initiator received a PLOGI from this NPort or if the
 		 * initiator is already in the process of discovery on it,
 		 * there's no need to try to discover it again.
@@ -5612,10 +5643,10 @@ lpfc_disc_start(struct lpfc_vport *vport)
 
 	/* Start Discovery state <hba_state> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-			 "0202 Start Discovery hba state x%x "
-			 "Data: x%x x%x x%x\n",
+			 "0202 Start Discovery port state x%x "
+			 "flg x%x Data: x%x x%x x%x\n",
 			 vport->port_state, vport->fc_flag, vport->fc_plogi_cnt,
-			 vport->fc_adisc_cnt);
+			 vport->fc_adisc_cnt, vport->fc_npr_cnt);
 
 	/* First do ADISCs - if any */
 	num_sent = lpfc_els_disc_adisc(vport);
-- 
2.13.7

