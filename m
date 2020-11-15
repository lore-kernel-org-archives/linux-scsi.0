Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F073C63699
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB7E22384
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NxQVjqfv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgKOT1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKOT1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:00 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC95FC0613D2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:00 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so7025609plr.9
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=vbzQdVLuU924UxqTlKJCnz96rLPUOj/oiYPgL8jQjok=;
        b=NxQVjqfvZi9ooP7Gb+w24sFQ6VlSwhBPG3dTvQoIVBRWzkXnnQ80p4CRGLQ5qNMneV
         /Q7MxND6BwoSsNMg1y5du7IiNebndKWhi2s2gRgEVr3tU80BGl527/9QViLKTsZqAfA6
         udhOxSHzyBD6RKIzxyLUp/gGQ4Hr8QPFEE0mE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=vbzQdVLuU924UxqTlKJCnz96rLPUOj/oiYPgL8jQjok=;
        b=WYPMNm0GJSWJY4ISHNA5N7R/HzROgJWqDZr2lXyepyTDmco2up7NYeXkQresPaBs4j
         nRBf9fJ9FnB6unMfUuWVqJB6F3dsN61GsxD/gV2WRy97faZ4gG0GTVCsrk8e5UCgN70a
         tD08b6ifUnQdqWtW7/29tjipOihdVCel8TmY8y/3kwJtFReLsSGqbd4lkliwL04RJHt5
         6a2u8Y8UYyDnH5LWXEpWhXuELQ9zr9xcwxzPTJiyL32cQ2w8AlJ8YLkKUQu/fjCtD9wr
         v09lpawH+1GCCRhYPtNXWbF4AIUQh0ps5/Nher+OohmqMB2vf/JhWjkautpSiv09HNCh
         boTA==
X-Gm-Message-State: AOAM530iCNV3T5E9pq5EiUTJwv2uHOrsl8IsTwlaQ1kMYx5rrBWB8A1u
        jsu3oMMbHSYOzxKN/heBqI9E0pN3SrCw3H8HWtv66K2QfbI7L2v4b6AuR11jUuACRVSSdziINNb
        qaSoqb6Hz0zd8HgTMRKBQWJTiZ+tONCoxoxyCPnvlB+BetcaiMfgT6s/T0B+2Eo85zOeNLhppcX
        UI6dk=
X-Google-Smtp-Source: ABdhPJza3xbAhMQnqYIZtmbWBOz9Kk3iithQIiGatbsj5S8fijSSNAG7OM6o6UwWc8vQOTAX6TmRww==
X-Received: by 2002:a17:902:244:b029:d6:c451:8566 with SMTP id 62-20020a1709020244b02900d6c4518566mr10146370plc.46.1605468419101;
        Sun, 15 Nov 2020 11:26:59 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:26:58 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/17] lpfc: Fix refcounting around scsi and nvme transport apis
Date:   Sun, 15 Nov 2020 11:26:33 -0800
Message-Id: <20201115192646.12977-5-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dd7b5505b42a3ee4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000dd7b5505b42a3ee4
Content-Transfer-Encoding: 8bit

Due to bug history and code review, the node reference counting approach
in the driver isn't implemented consistently with how the scsi and nvme
transport perform registrations and unregistrations and their callbacks.
This resulted in many bad/stale node pointers.

Reword the driver so that reference handling is performed as follows:
- The initial node reference is taken on structure allocation
- Take a reference on any add/register call to the transport
- Remove a reference on any delete/unregister call to the transport
- After the node has fully removed from both the scsi and nvme transports
  (dev_loss_callbacks have called back) call the discovery engine
  DEVICE_RM event which will remove the final reference and release
  the node structure.
- Alter dev_loss handling when a vport or base port is unloading.
- Remove the put_node handling - no longer needed.
- Rewrite the vport_delete handling on reference counts.  Part of
   this effort was driven from the FDISC not registering with the
   transport and disrupting the model for node reference counting.
- Deleted lpfc_nlp_remove.  Pushed it's remaining ops into
  lpfc_nlp_release.
- Several other small code cleanups.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_disc.h  |  6 ++-
 drivers/scsi/lpfc/lpfc_els.c   | 89 +++++++++++-----------------------
 drivers/scsi/lpfc/lpfc_init.c  | 49 ++++++++++++-------
 drivers/scsi/lpfc/lpfc_nvme.c  | 62 +++++++++++++++--------
 drivers/scsi/lpfc/lpfc_nvme.h  |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c   | 13 +++--
 drivers/scsi/lpfc/lpfc_vport.c | 73 +++++-----------------------
 7 files changed, 130 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 09d4ec2a20db..b831f10a686c 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -131,13 +131,17 @@ struct lpfc_nodelist {
 	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
-	uint32_t upcall_flags;
+	uint32_t fc4_xpt_flags;
 #define NLP_WAIT_FOR_UNREG    0x1
+#define SCSI_XPT_REGD         0x2
+#define NVME_XPT_REGD         0x4
+
 
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
 	uint32_t nlp_defer_did;
 };
+
 struct lpfc_node_rrq {
 	struct list_head list;
 	uint16_t xritag;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b56dc69ff2b2..5a592ab323e5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1554,7 +1554,7 @@ lpfc_more_plogi(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_plogi_confirm_nport - Confirm pologi wwpn matches stored ndlp
+ * lpfc_plogi_confirm_nport - Confirm plogi wwpn matches stored ndlp
  * @phba: pointer to lpfc hba data structure.
  * @prsp: pointer to response IOCB payload.
  * @ndlp: pointer to a node-list data structure.
@@ -1591,8 +1591,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct lpfc_vport *vport = ndlp->vport;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *new_ndlp;
-	struct lpfc_rport_data *rdata;
-	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
@@ -1600,7 +1598,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	uint16_t keep_nlp_state;
 	u32 keep_nlp_fc4_type = 0;
 	struct lpfc_nvme_rport *keep_nrport = NULL;
-	int  put_node;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
@@ -1730,26 +1727,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 "3179 PLOGI confirm NEW: %x %x\n",
 			 new_ndlp->nlp_DID, keepDID);
 
-		/* Fix up the rport accordingly */
-		rport =  ndlp->rport;
-		if (rport) {
-			rdata = rport->dd_data;
-			if (rdata->pnode == ndlp) {
-				/* break the link before dropping the ref */
-				ndlp->rport = NULL;
-				lpfc_nlp_put(ndlp);
-				rdata->pnode = lpfc_nlp_get(new_ndlp);
-				new_ndlp->rport = rport;
-			}
-			new_ndlp->nlp_type = ndlp->nlp_type;
-		}
-
-		/* Fix up the nvme rport */
-		if (ndlp->nrport) {
-			ndlp->nrport = NULL;
-			lpfc_nlp_put(ndlp);
-		}
-
 		/* Two ndlps cannot have the same did on the nodelist.
 		 * Note: for this case, ndlp has a NULL WWPN so setting
 		 * the nlp_fc4_type isn't required.
@@ -1789,25 +1766,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		    (ndlp->nlp_state == NLP_STE_MAPPED_NODE))
 			keep_nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
-
-		/* Previous ndlp no longer active with nvme host transport.
-		 * Remove reference from earlier registration unless the
-		 * nvme host took care of it.
-		 */
-		if (ndlp->nrport)
-			lpfc_nlp_put(ndlp);
 		ndlp->nrport = keep_nrport;
-
-		/* Fix up the rport accordingly */
-		rport = ndlp->rport;
-		if (rport) {
-			rdata = rport->dd_data;
-			put_node = rdata->pnode != NULL;
-			rdata->pnode = NULL;
-			ndlp->rport = NULL;
-			if (put_node)
-				lpfc_nlp_put(ndlp);
-		}
 	}
 
 	/*
@@ -2027,10 +1986,12 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
-		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
+		/* Do not call DSM for lpfc_els_abort'ed ELS cmds. Just execute
+		 * the final node put to free it to the pool.
+		 */
 		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-						NLP_EVT_CMPL_PLOGI);
+						NLP_EVT_DEVICE_RM);
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -2038,7 +1999,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				  struct lpfc_dmabuf, list);
 		ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-					     NLP_EVT_CMPL_PLOGI);
+					NLP_EVT_CMPL_PLOGI);
 	}
 
 	if (disc && vport->num_disc_nodes) {
@@ -4439,15 +4400,16 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mempool_free(pmb, phba->mbox_mem_pool);
 	if (ndlp) {
 		lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-				 "0006 rpi%x DID:%x flg:%x %d x%px\n",
+				 "0006 rpi x%x DID:%x flg:%x %d x%px\n",
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 				 kref_read(&ndlp->kref),
 				 ndlp);
-		lpfc_nlp_put(ndlp);
 		/* This is the end of the default RPI cleanup logic for
-		 * this ndlp. If no other discovery threads are using
-		 * this ndlp, free all resources associated with it.
+		 * this ndlp and it could get released.  Clear the nlp_flags to
+		 * prevent any further processing.
 		 */
+		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
+		lpfc_nlp_put(ndlp);
 		lpfc_nlp_not_used(ndlp);
 	}
 
@@ -4652,7 +4614,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 * the routine lpfc_els_free_iocb.
 				 */
 				cmdiocb->context1 = NULL;
-
 	}
 
 	/* Release the originating IO reference. */
@@ -8945,6 +8906,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			lpfc_nlp_put(ndlp);
 	}
 
+	/* Release the reference on this elsiocb, not the ndlp. */
 	lpfc_nlp_put(elsiocb->context1);
 	elsiocb->context1 = NULL;
 
@@ -9261,8 +9223,9 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					lpfc_start_fdiscs(phba);
 				lpfc_do_scr_ns_plogi(phba, vport);
 			}
-		} else
+		} else {
 			lpfc_do_scr_ns_plogi(phba, vport);
+		}
 	}
 mbox_err_exit:
 	/* Now, we decrement the ndlp reference count held for this
@@ -9536,6 +9499,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * to update the MAC address.
 		 */
 		lpfc_register_new_vport(phba, vport, ndlp);
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 		goto out;
 	}
 
@@ -9545,7 +9509,13 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_register_new_vport(phba, vport, ndlp);
 	else
 		lpfc_do_scr_ns_plogi(phba, vport);
+
+	/* The FDISC completed successfully. Move the fabric ndlp to
+	 * UNMAPPED state and register with the transport.
+	 */
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	goto out;
+
 fdisc_failed:
 	if (vport->fc_vport &&
 	    (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS))
@@ -9697,19 +9667,14 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		"LOGO npiv cmpl:  status:x%x/x%x did:x%x",
 		irsp->ulpStatus, irsp->un.ulpWord[4], irsp->un.rcvels.remoteID);
 
-	lpfc_nlp_put(ndlp);
-	lpfc_els_free_iocb(phba, cmdiocb);
-	vport->unreg_vpi_cmpl = VPORT_ERROR;
-
-	/* Trigger the release of the ndlp after logo */
-	lpfc_nlp_put(ndlp);
-
 	/* NPIV LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2928 NPIV LOGO completes to NPort x%x "
-			 "Data: x%x x%x x%x x%x\n",
+			 "Data: x%x x%x x%x x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes);
+			 irsp->ulpTimeout, vport->num_disc_nodes,
+			 kref_read(&ndlp->kref), ndlp->nlp_flag,
+			 ndlp->fc4_xpt_flags);
 
 	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
 		spin_lock_irq(shost->host_lock);
@@ -9718,7 +9683,11 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		spin_unlock_irq(shost->host_lock);
 		lpfc_can_disctmo(vport);
 	}
+
+	/* Safe to release resources now. */
+	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
+	vport->unreg_vpi_cmpl = VPORT_ERROR;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 72448287a3d1..65b9e4e06b9f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2859,12 +2859,17 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			continue;
 		}
 
-		if (ndlp->nlp_type & NLP_FABRIC)
+		/* Fabric Ports not in UNMAPPED state are cleaned up in the
+		 * DEVICE_RM event.
+		 */
+		if (ndlp->nlp_type & NLP_FABRIC &&
+		    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 
-		lpfc_disc_state_machine(vport, ndlp, NULL,
-					     NLP_EVT_DEVICE_RM);
+		if (!(ndlp->fc4_xpt_flags & (NVME_XPT_REGD|SCSI_XPT_REGD)))
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 	}
 
 	/* At this point, ALL ndlp's should be gone
@@ -2879,11 +2884,13 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						&vport->fc_nodes, nlp_listp) {
 				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
-						LOG_TRACE_EVENT,
-						"0282 did:x%x ndlp:x%px "
-						"refcnt:%d\n",
-						ndlp->nlp_DID, (void *)ndlp,
-						kref_read(&ndlp->kref));
+						 LOG_TRACE_EVENT,
+						 "0282 did:x%x ndlp:x%px "
+						 "refcnt:%d xflags x%x nflag x%x\n",
+						 ndlp->nlp_DID, (void *)ndlp,
+						 kref_read(&ndlp->kref),
+						 ndlp->fc4_xpt_flags,
+						 ndlp->nlp_flag);
 			}
 			break;
 		}
@@ -3499,10 +3506,10 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				 * comes back online.
 				 */
 				if (phba->sli_rev == LPFC_SLI_REV4) {
-					lpfc_printf_vlog(ndlp->vport, KERN_INFO,
+					lpfc_printf_vlog(vports[i], KERN_INFO,
 						 LOG_NODE | LOG_DISCOVERY,
 						 "0011 Free RPI x%x on "
-						 "ndlp:x%px did x%x\n",
+						 "ndlp: %p did x%x\n",
 						 ndlp->nlp_rpi, ndlp,
 						 ndlp->nlp_DID);
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
@@ -3513,8 +3520,18 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				if (ndlp->nlp_type & NLP_FABRIC) {
 					lpfc_disc_state_machine(vports[i], ndlp,
 						NULL, NLP_EVT_DEVICE_RECOVERY);
-					lpfc_disc_state_machine(vports[i], ndlp,
-						NULL, NLP_EVT_DEVICE_RM);
+
+					/* Don't remove the node unless the
+					 * has been unregistered with the
+					 * transport.  If so, let dev_loss
+					 * take care of the node.
+					 */
+					if (!(ndlp->fc4_xpt_flags &
+					      (NVME_XPT_REGD | SCSI_XPT_REGD)))
+						lpfc_disc_state_machine
+							(vports[i], ndlp,
+							 NULL,
+							 NLP_EVT_DEVICE_RM);
 				}
 			}
 		}
@@ -12501,13 +12518,11 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 
 	/* Remove FC host with the physical port */
 	fc_remove_host(shost);
+	scsi_remove_host(shost);
 
 	/* Clean up all nodes, mailboxes and IOs. */
 	lpfc_cleanup(vport);
 
-	/* Remove the shost now that the devices connections are lost. */
-	scsi_remove_host(shost);
-
 	/*
 	 * Bring down the SLI Layer. This step disable all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
@@ -13359,6 +13374,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
 	/* Remove FC host with the physical port */
 	fc_remove_host(shost);
+	scsi_remove_host(shost);
 
 	/* Perform ndlp cleanup on the physical port.  The nvme and nvmet
 	 * localports are destroyed after to cleanup all transport memory.
@@ -13371,9 +13387,6 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	if (phba->cfg_xri_rebalancing)
 		lpfc_destroy_multixri_pools(phba);
 
-	/* Remove the shost now that the devices connections are lost. */
-	scsi_remove_host(shost);
-
 	/*
 	 * Bring down the SLI Layer. This step disables all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9e92fb337abd..275ddccd9950 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -357,39 +357,47 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	struct lpfc_nvme_rport *rport = remoteport->private;
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
+	u32 fc4_xpt_flags;
 
 	ndlp = rport->ndlp;
-	if (!ndlp)
+	if (!ndlp) {
+		pr_err("**** %s: NULL ndlp on rport %p remoteport %p\n",
+		       __func__, rport, remoteport);
 		goto rport_err;
+	}
 
 	vport = ndlp->vport;
-	if (!vport)
+	if (!vport) {
+		pr_err("**** %s: Null vport on ndlp %p, ste x%x rport %p\n",
+		       __func__, ndlp, ndlp->nlp_state, rport);
 		goto rport_err;
+	}
+
+	fc4_xpt_flags = NVME_XPT_REGD | SCSI_XPT_REGD;
 
 	/* Remove this rport from the lport's list - memory is owned by the
 	 * transport. Remove the ndlp reference for the NVME transport before
 	 * calling state machine to remove the node.
 	 */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			"6146 remoteport delete of remoteport x%px\n",
+			"6146 remoteport delete of remoteport %p\n",
 			remoteport);
 	spin_lock_irq(&vport->phba->hbalock);
 
 	/* The register rebind might have occurred before the delete
 	 * downcall.  Guard against this race.
 	 */
-	if (ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
-		ndlp->nrport = NULL;
-		ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
-		spin_unlock_irq(&vport->phba->hbalock);
+	if (ndlp->fc4_xpt_flags & NLP_WAIT_FOR_UNREG)
+		ndlp->fc4_xpt_flags &= ~(NLP_WAIT_FOR_UNREG | NVME_XPT_REGD);
 
-		/* Remove original register reference. The host transport
-		 * won't reference this rport/remoteport any further.
-		 */
-		lpfc_nlp_put(ndlp);
-	} else {
-		spin_unlock_irq(&vport->phba->hbalock);
-	}
+	spin_unlock_irq(&vport->phba->hbalock);
+
+	/* On a devloss timeout event, one more put is executed provided the
+	 * NVME and SCSI rport unregister requests are complete.  If the vport
+	 * is unloading, this extra put is executed by lpfc_drop_node.
+	 */
+	if (!(ndlp->fc4_xpt_flags & fc4_xpt_flags))
+		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
  rport_err:
 	return;
@@ -661,6 +669,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 				 "Data: x%x x%x  rc x%x\n",
 				 ndlp->nlp_DID, genwqe->iotag,
 				 vport->port_state, rc);
+		lpfc_nlp_put(ndlp);
 		lpfc_sli_release_iocbq(phba, genwqe);
 		return 1;
 	}
@@ -1692,7 +1701,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 				 "IO. State x%x, Type x%x Flg x%x\n",
 				 pnvme_rport->port_id,
 				 ndlp->nlp_state, ndlp->nlp_type,
-				 ndlp->upcall_flags);
+				 ndlp->fc4_xpt_flags);
 		atomic_inc(&lport->xmt_fcp_bad_ndlp);
 		ret = -EBUSY;
 		goto out_fail;
@@ -2490,7 +2499,8 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * race that leaves the WAIT flag set.
 		 */
 		spin_lock_irq(&vport->phba->hbalock);
-		ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
+		ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
+		ndlp->fc4_xpt_flags |= NVME_XPT_REGD;
 		spin_unlock_irq(&vport->phba->hbalock);
 		rport = remote_port->private;
 		if (oldrport) {
@@ -2501,7 +2511,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 */
 			spin_lock_irq(&vport->phba->hbalock);
 			ndlp->nrport = NULL;
-			ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
+			ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
 			spin_unlock_irq(&vport->phba->hbalock);
 			rport->ndlp = NULL;
 			rport->remoteport = NULL;
@@ -2638,10 +2648,11 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6033 Unreg nvme remoteport x%px, portname x%llx, "
-			 "port_id x%06x, portstate x%x port type x%x\n",
+			 "port_id x%06x, portstate x%x port type x%x "
+			 "refcnt %d\n",
 			 remoteport, remoteport->port_name,
 			 remoteport->port_id, remoteport->port_state,
-			 ndlp->nlp_type);
+			 ndlp->nlp_type, kref_read(&ndlp->kref));
 
 	/* Sanity check ndlp type.  Only call for NVME ports. Don't
 	 * clear any rport state until the transport calls back.
@@ -2651,7 +2662,9 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* No concern about the role change on the nvme remoteport.
 		 * The transport will update it.
 		 */
-		ndlp->upcall_flags |= NLP_WAIT_FOR_UNREG;
+		spin_lock_irq(&vport->phba->hbalock);
+		ndlp->fc4_xpt_flags |= NLP_WAIT_FOR_UNREG;
+		spin_unlock_irq(&vport->phba->hbalock);
 
 		/* Don't let the host nvme transport keep sending keep-alives
 		 * on this remoteport. Vport is unloading, no recovery. The
@@ -2662,8 +2675,15 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			(void)nvme_fc_set_remoteport_devloss(remoteport, 0);
 
 		ret = nvme_fc_unregister_remoteport(remoteport);
+
+		/* The driver no longer knows if the nrport memory is valid.
+		 * because the controller teardown process has begun and
+		 * is asynchronous.  Break the binding in the ndlp. Also
+		 * remove the register ndlp reference to setup node release.
+		 */
+		ndlp->nrport = NULL;
+		lpfc_nlp_put(ndlp);
 		if (ret != 0) {
-			lpfc_nlp_put(ndlp);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6167 NVME unregister failed %d "
 					 "port_state x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 4a4c3f780e1f..4e11ce8d5e31 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -38,7 +38,7 @@
 #define LPFC_NVME_INFO_MORE_STR		"\nCould be more info...\n"
 
 #define lpfc_ndlp_get_nrport(ndlp)					\
-	((!ndlp->nrport || (ndlp->upcall_flags & NLP_WAIT_FOR_UNREG))	\
+	((!ndlp->nrport || (ndlp->fc4_xpt_flags & NLP_WAIT_FOR_UNREG))	\
 	? NULL : ndlp->nrport)
 
 struct lpfc_nvme_qhandle {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1232fad17d1e..1f020d2abfa0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2528,9 +2528,10 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				vport,
 				KERN_INFO, LOG_MBOX | LOG_DISCOVERY,
 				"1438 UNREG cmpl deferred mbox x%x "
-				"on NPort x%x Data: x%x x%x %px\n",
+				"on NPort x%x Data: x%x x%x %px x%x x%x\n",
 				ndlp->nlp_rpi, ndlp->nlp_DID,
-				ndlp->nlp_flag, ndlp->nlp_defer_did, ndlp);
+				ndlp->nlp_flag, ndlp->nlp_defer_did,
+				ndlp, vport->load_flag, kref_read(&ndlp->kref));
 
 			if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
 			    (ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING)) {
@@ -2585,7 +2586,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		     LPFC_SLI_INTF_IF_TYPE_2)) {
 			if (ndlp) {
 				lpfc_printf_vlog(
-					vport, KERN_INFO, LOG_MBOX | LOG_SLI,
+					 vport, KERN_INFO, LOG_MBOX | LOG_SLI,
 					 "0010 UNREG_LOGIN vpi:%x "
 					 "rpi:%x DID:%x defer x%x flg x%x "
 					 "%px\n",
@@ -13415,6 +13416,12 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 					 pmbox->un.varWords[0], pmb);
 			pmb->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
 			pmb->ctx_buf = mp;
+
+			/* No reference taken here.  This is a default
+			 * RPI reg/immediate unreg cycle. The reference was
+			 * taken in the reg rpi path and is released when
+			 * this mailbox completes.
+			 */
 			pmb->ctx_ndlp = ndlp;
 			pmb->vport = vport;
 			rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 0261495b44d3..f590d18b3f06 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -593,16 +593,14 @@ lpfc_vport_disable(struct fc_vport *fc_vport, bool disable)
 		return enable_vport(fc_vport);
 }
 
-
 int
 lpfc_vport_delete(struct fc_vport *fc_vport)
 {
 	struct lpfc_nodelist *ndlp = NULL;
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_hba  *phba = vport->phba;
 	long timeout;
-	bool ns_ndlp_referenced = false;
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -619,9 +617,11 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 				 "static vport.\n");
 		return VPORT_ERROR;
 	}
+
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
+
 	/*
 	 * If we are not unloading the driver then prevent the vport_delete
 	 * from happening until after this vport's discovery is finished.
@@ -649,52 +649,22 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		return VPORT_INVAL;
 
 	lpfc_free_sysfs_attr(vport);
-
 	lpfc_debugfs_terminate(vport);
 
-	/*
-	 * The call to fc_remove_host might release the NameServer ndlp. Since
-	 * we might need to use the ndlp to send the DA_ID CT command,
-	 * increment the reference for the NameServer ndlp to prevent it from
-	 * being released.
-	 */
-	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (ndlp) {
-		lpfc_nlp_get(ndlp);
-		ns_ndlp_referenced = true;
-	}
-
 	/* Remove FC host to break driver binding. */
 	fc_remove_host(shost);
+	scsi_remove_host(shost);
 
-	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-
-	/* In case of driver unload, we shall not perform fabric logo as the
-	 * worker thread already stopped at this stage and, in this case, we
-	 * can safely skip the fabric logo.
-	 */
-	if (phba->pport->load_flag & FC_UNLOADING) {
-		if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-		    phba->link_state >= LPFC_LINK_UP) {
-			/* First look for the Fabric ndlp */
-			ndlp = lpfc_findnode_did(vport, Fabric_DID);
-			if (!ndlp)
-				goto skip_logo;
-
-			/* Remove ndlp from vport npld list */
-			lpfc_dequeue_node(vport, ndlp);
-
-			/* Kick off release ndlp when it can be safely done */
-			lpfc_nlp_put(ndlp);
-		}
+	/* Send the DA_ID and Fabric LOGO to cleanup Nameserver entries. */
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (!ndlp)
 		goto skip_logo;
-	}
 
-	/* Otherwise, we will perform fabric logo as needed */
 	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP &&
 	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
+			/* Send DA_ID and wait for a completion. */
 			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 			if (!lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0))
 				while (vport->ct_flags && timeout)
@@ -705,25 +675,19 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 						"1829 CT command failed to "
 						"delete objects on fabric\n");
 		}
-		/* First look for the Fabric ndlp */
-		ndlp = lpfc_findnode_did(vport, Fabric_DID);
-		if (!ndlp) {
-			/* Cannot find existing Fabric ndlp, allocate one */
-			ndlp = lpfc_nlp_init(vport, Fabric_DID);
-			if (!ndlp)
-				goto skip_logo;
-		}
 
 		/*
 		 * If the vpi is not registered, then a valid FDISC doesn't
 		 * exist and there is no need for a ELS LOGO.  Just cleanup
 		 * the ndlp.
 		 */
-		if (!(vport->vpi_state & LPFC_VPI_REGISTERED)) {
-			lpfc_nlp_put(ndlp);
+		if (!(vport->vpi_state & LPFC_VPI_REGISTERED))
 			goto skip_logo;
-		}
 
+		/* Issue a Fabric LOGO to cleanup fabric resources. */
+		ndlp = lpfc_findnode_did(vport, Fabric_DID);
+		if (!ndlp)
+			goto skip_logo;
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
@@ -736,21 +700,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 skip_logo:
 
-	/*
-	 * If the NameServer ndlp has been incremented to allow the DA_ID CT
-	 * command to be sent, decrement the ndlp now.
-	 */
-	if (ns_ndlp_referenced) {
-		ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		lpfc_nlp_put(ndlp);
-	}
-
 	lpfc_cleanup(vport);
 
 	/* Remove scsi host now.  The nodes are cleaned up. */
-	scsi_remove_host(shost);
 	lpfc_sli_host_down(vport);
-
 	lpfc_stop_vport_timers(vport);
 
 	if (!(phba->pport->load_flag & FC_UNLOADING)) {
-- 
2.26.2


--000000000000dd7b5505b42a3ee4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRPkivpBuqFxCdd3f
8EmHuzA9+hajKviHnyLZcp8DTRkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNjU5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABCNGMn1ZfYkBGNXD5xXQvHx1FqGKSnyQqww
kvU2/L/9QNJOzMfpskvEHz1OP7jbkQb+mL37szxuUAndReQWT1fqs1/0kEYi0F/+MQL3O6yExEzq
fU90iHRlKKFdsDcmUALKKDboGQp/Qexn8lklg7ejEvqwNzMK1Hw/DHKEXz8kH0H4WK3swnM9xne1
MD9FUKEEC2LZPsq2sObeJdD9gHyY3Go82zbsGJWD342TJok82xghTcm2msQ/rZweIX7Sj1ZsXtJB
FO7HtiyaNriyBfPK+BkFvj2ELQvqmr2JkDVFpCk4Dxl/w4+81Xp74vUMWnBuHZMwl4JsFS7dKnk2
jso=
--000000000000dd7b5505b42a3ee4--
