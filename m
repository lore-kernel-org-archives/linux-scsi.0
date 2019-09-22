Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D8EC3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3422320B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g75CQDyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfIVD7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:25 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34156 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfIVD7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:24 -0400
Received: by mail-oi1-f194.google.com with SMTP id 83so5020042oii.1
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=isNDh6GlCV8xvxY7lIirXZIGb+mX0FeehwfVKzV967Y=;
        b=g75CQDyMu6Y9MQfLq7eL+TFwTaJ8WLNr6jd2/nYdirGiYKg/xEhEZVprXwDB3W6f6D
         lefABesJRPZSXXVWwCZZDMdvdiRPWtqb3DP2ifYoD9RIEeCK6yzCoX61v7M4eVI9j45D
         OWS8uPhI2Y7Nk7fnKinkujEK1gER/7XiVNRFqiN0Q1xJ8zc5TSuLH84jNOkSkPxjeToe
         J8Crd+HeZmp7h+NToIJtOO/eUpn9m+KlEMk6hkRKtrkjadLNf1YU48U6n/CakLu1ewBt
         +jknrPSrBFA72al/f0sJtptL/RnTQTlaRB4WefYHLNHaAcTSgJCdh0SLgWE4IigFch7n
         L6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=isNDh6GlCV8xvxY7lIirXZIGb+mX0FeehwfVKzV967Y=;
        b=htHO2N2vpAogzUh9jvDekb/6dPpVEY1S8hxDhnFPXtBiu4jA0YR2/kugcCu4OZnvFm
         ySb4zZiJtc1rtUMGkjPHvU+ZqcdgwEGsKslFMBqxnTAB/q6mBRrhWBKi01MNSltEmb+j
         sT3Nxeu9Vmq5b11wfC3eNFKM7ITtM+tAS3FK4wsAX1rZsWVKBxavVe8pDFNQvj8ws+0S
         yWmjhkvjqSoKA8eqVBQA0wS+ryrS+uh9LdQqlsjGH+T/Me3dZcgRZOW8D4QfnyFV0K2P
         o20jEfT0Ikub7MwV+EdnhEZ74uKI6HS9vdp04mxLeFsEYCVFpEN2fVXuz7oT7X+j9GVF
         Su3w==
X-Gm-Message-State: APjAAAXEHVcab7vmHoETWt0W/aNJe7U3JYXloaDuNHDBqXvH5c6hgcva
        yNxhIE9zPkGvk+8ESsF6kPDqtJkG
X-Google-Smtp-Source: APXvYqy1T52h3wdhy04V3kjZeRd9AxFVQZP2N7k8jpNHEBJrZBH9inhyX/Z+E1vHqEx4AyRcymLOXg==
X-Received: by 2002:aca:52cd:: with SMTP id g196mr9211369oib.163.1569124761414;
        Sat, 21 Sep 2019 20:59:21 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/20] lpfc: Fix device recovery errors after PLOGI failures
Date:   Sat, 21 Sep 2019 20:58:52 -0700
Message-Id: <20190922035906.10977-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When target-side fault injections are made, the driver isn't
reconnecting to the remote port. The driver is logging "2753"
error messages which state:
"PLOGI failure DID:1B2400 Status:x3/xf0240008"

The failures status is indicating a Illegal field error, which
points to the Temporary RPI field being used for the ELS. This
error typically means the driver used an RPI that was already
registered (shouldn't be registered if using it in this context).

Study has found that if the driver were in discovery attempts and
encountered an error, it wouldn't flag the temporary rpi in error.
Yet the rpi was released for reallocation in these error paths
and another ELS could allocate the rpi. In the failure situation
a retry was done on an ELS that had encountered an error, and as
the rpi wasn't marked in error, the ELS reused the rpi it originally
allocated. But that rpi had been allocated by a different ELS issued
after the original error and before the retry attempt. The different
ELS had succeeded and the RPI was registered.

Fix by marking the rpi state for the node to be in error, aka
as needing reallocation, upon an error in the els processing.
Error state marking is always done prior to release back to the
internal rpi free list, which the driver wasn't doing in cases
prior.

Also enhanced some of the logging to help in the next case
of problem troubleshooting.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 44 ++++++++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_init.c    | 40 ++++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_sli.c     |  8 +++++---
 3 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9df6f0cabab0..144786947b63 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4046,7 +4046,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
 			 "0003 rpi:%x DID:%x flg:%x %d map%x x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
@@ -4575,8 +4575,10 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return ndlp;
 
 free_rpi:
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_sli4_free_rpi(vport->phba, rpi);
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+	}
 	return NULL;
 }
 
@@ -4835,6 +4837,7 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
 			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
 			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 		}
 		ndlp->nlp_flag &= ~NLP_UNREG_INP;
 	}
@@ -4898,7 +4901,8 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED ||
 	    ndlp->nlp_flag & NLP_REG_LOGIN_SEND) {
 		if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_DISCOVERY,
 					 "3366 RPI x%x needs to be "
 					 "unregistered nlp_flag x%x "
 					 "did x%x\n",
@@ -4909,7 +4913,8 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * no need to queue up another one.
 		 */
 		if (ndlp->nlp_flag & NLP_UNREG_INP) {
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_DISCOVERY,
 					 "1436 unreg_rpi SKIP UNREG x%x on "
 					 "NPort x%x deferred x%x  flg x%x "
 					 "Data: x%px\n",
@@ -4939,7 +4944,8 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			    (!(vport->fc_flag & FC_OFFLINE_MODE)))
 				ndlp->nlp_flag |= NLP_UNREG_INP;
 
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_DISCOVERY,
 					 "1433 unreg_rpi UNREG x%x on "
 					 "NPort x%x deferred flg x%x "
 					 "Data:x%px\n",
@@ -5195,8 +5201,10 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
 		 */
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-				 "0005 rpi:%x DID:%x flg:%x %d map:%x x%px\n",
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_NODE | LOG_DISCOVERY,
+				 "0005 Cleanup Default rpi:x%x DID:x%x flg:x%x "
+				 "ref %d map:x%x ndlp x%px\n",
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 				 kref_read(&ndlp->kref),
 				 ndlp->nlp_usg_map, ndlp);
@@ -5233,8 +5241,9 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 */
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
 				"0940 removed node x%px DID x%x "
-				" rport not null x%px\n",
-				ndlp, ndlp->nlp_DID, ndlp->rport);
+				"rpi %d rport not null x%px\n",
+				 ndlp, ndlp->nlp_DID, ndlp->nlp_rpi,
+				 ndlp->rport);
 		rport = ndlp->rport;
 		rdata = rport->dd_data;
 		rdata->pnode = NULL;
@@ -6026,7 +6035,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
 			 "0004 rpi:%x DID:%x flg:%x %d map:%x x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
@@ -6215,12 +6224,12 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		ndlp->nlp_rpi = rpi;
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-				 "0007 rpi:%x DID:%x flg:%x refcnt:%d "
-				 "map:%x x%px\n", ndlp->nlp_rpi, ndlp->nlp_DID,
-				 ndlp->nlp_flag,
-				 kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map, ndlp);
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
+				 "0007 Init New ndlp x%px, rpi:x%x DID:%x "
+				 "flg:x%x refcnt:%d map:x%x\n",
+				 ndlp, ndlp->nlp_rpi, ndlp->nlp_DID,
+				 ndlp->nlp_flag, kref_read(&ndlp->kref),
+				 ndlp->nlp_usg_map);
 
 		ndlp->active_rrqs_xri_bitmap =
 				mempool_alloc(vport->phba->active_rrq_pool,
@@ -6449,7 +6458,8 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 				goto out;
 			} else if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 				ret = 1;
-				lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				lpfc_printf_log(phba, KERN_INFO,
+						LOG_NODE | LOG_DISCOVERY,
 						"2624 RPI %x DID %x flag %x "
 						"still logged in\n",
 						ndlp->nlp_rpi, ndlp->nlp_DID,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bb84d2a20e76..12885b01fa27 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3053,11 +3053,12 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 				continue;
 			}
 			ndlp->nlp_rpi = rpi;
-			lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-					 "0009 rpi:%x DID:%x "
-					 "flg:%x map:%x x%px\n", ndlp->nlp_rpi,
-					 ndlp->nlp_DID, ndlp->nlp_flag,
-					 ndlp->nlp_usg_map, ndlp);
+			lpfc_printf_vlog(ndlp->vport, KERN_INFO,
+					 LOG_NODE | LOG_DISCOVERY,
+					 "0009 Assign RPI x%x to ndlp x%px "
+					 "DID:x%06x flg:x%x map:x%x\n",
+					 ndlp->nlp_rpi, ndlp, ndlp->nlp_DID,
+					 ndlp->nlp_flag, ndlp->nlp_usg_map);
 		}
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -3453,10 +3454,15 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
-				if (!NLP_CHK_NODE_ACT(ndlp))
-					continue;
-				if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+				if ((!NLP_CHK_NODE_ACT(ndlp)) ||
+				    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+					/* Driver must assume RPI is invalid for
+					 * any unused or inactive node.
+					 */
+					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 					continue;
+				}
+
 				if (ndlp->nlp_type & NLP_FABRIC) {
 					lpfc_disc_state_machine(vports[i], ndlp,
 						NULL, NLP_EVT_DEVICE_RECOVERY);
@@ -3472,16 +3478,16 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				 * comes back online.
 				 */
 				if (phba->sli_rev == LPFC_SLI_REV4) {
-					lpfc_printf_vlog(ndlp->vport,
-							 KERN_INFO, LOG_NODE,
-							 "0011 lpfc_offline: "
-							 "ndlp:x%px did %x "
-							 "usgmap:x%x rpi:%x\n",
-							 ndlp, ndlp->nlp_DID,
-							 ndlp->nlp_usg_map,
-							 ndlp->nlp_rpi);
-
+					lpfc_printf_vlog(ndlp->vport, KERN_INFO,
+						 LOG_NODE | LOG_DISCOVERY,
+						 "0011 Free RPI x%x on "
+						 "ndlp:x%px did x%x "
+						 "usgmap:x%x\n",
+						 ndlp->nlp_rpi, ndlp,
+						 ndlp->nlp_DID,
+						 ndlp->nlp_usg_map);
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 				}
 				lpfc_unreg_rpi(vports[i], ndlp);
 			}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f764012ba0a6..24d6779a99f8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18131,8 +18131,9 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 		phba->sli4_hba.max_cfg_param.rpi_used++;
 		phba->sli4_hba.rpi_count++;
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"0001 rpi:%x max:%x lim:%x\n",
+	lpfc_printf_log(phba, KERN_INFO,
+			LOG_NODE | LOG_DISCOVERY,
+			"0001 Allocated rpi:x%x max:x%x lim:x%x\n",
 			(int) rpi, max_rpi, rpi_limit);
 
 	/*
@@ -18192,7 +18193,8 @@ __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 		phba->sli4_hba.rpi_count--;
 		phba->sli4_hba.max_cfg_param.rpi_used--;
 	} else {
-		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+		lpfc_printf_log(phba, KERN_INFO,
+				LOG_NODE | LOG_DISCOVERY,
 				"2016 rpi %x not inuse\n",
 				rpi);
 	}
-- 
2.13.7

