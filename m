Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11829C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E7122EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbhAGEyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:54:37 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:52256 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbhAGEyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:54:37 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 74ED182D0E;
        Wed,  6 Jan 2021 20:53:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 74ED182D0E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609995204;
        bh=oJqXbD0xSFen+mzopT8Bg9Elk8nDINE5/lmnF7Eybk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH8XXoaCBcFhc36GRgBG/zQ+bzao7evjyja6rO/LFY/auiaOZQ5X7S3GbLtmC4yRU
         xAMcD3iNIwtH0g19OwxBfQP+8cx46QoMEjTCUw9V5hYvG0EoB8wIzPnis70iuSVvBn
         tA1LTpENnoPMKrrcgPKkezZCU/5wTZBAHl/7fR/k=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v7 08/16] lpfc: vmid: Add support for vmid in mailbox command, does vmid resource allocation and vmid cleanup
Date:   Thu,  7 Jan 2021 03:30:22 +0530
Message-Id: <1609970430-19084-9-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch does the following -
1.adds supporting datastructures for mailbox command which helps in
determining if the firmware supports appid or not.
2.This patch allocates the resource for vmid and checks if the firmware
supports the feature or not.
3.The patch cleans up the vmid resources and stops the timer.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v7:
No change

v6:
Added Forward declarations and functions to static

v5:
Merged patches 8 and 11 of v4 to this patch
Changed Return code to non-numeric/Symbol

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 12 ++++++
 drivers/scsi/lpfc/lpfc_init.c | 69 +++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_mbox.c |  6 +++
 drivers/scsi/lpfc/lpfc_scsi.c | 21 +++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  |  9 +++++
 5 files changed, 117 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 541b9aef6bfe..5fdafc92fc2d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -272,6 +272,9 @@ struct lpfc_sli4_flags {
 #define lpfc_vfi_rsrc_rdy_MASK		0x00000001
 #define lpfc_vfi_rsrc_rdy_WORD		word0
 #define LPFC_VFI_RSRC_RDY		1
+#define lpfc_ftr_ashdr_SHIFT            4
+#define lpfc_ftr_ashdr_MASK             0x00000001
+#define lpfc_ftr_ashdr_WORD             word0
 };
 
 struct sli4_bls_rsp {
@@ -2943,6 +2946,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rq_mrqp_SHIFT		16
 #define lpfc_mbx_rq_ftr_rq_mrqp_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_mrqp_WORD		word2
+#define lpfc_mbx_rq_ftr_rq_ashdr_SHIFT          17
+#define lpfc_mbx_rq_ftr_rq_ashdr_MASK           0x00000001
+#define lpfc_mbx_rq_ftr_rq_ashdr_WORD           word2
 	uint32_t word3;
 #define lpfc_mbx_rq_ftr_rsp_iaab_SHIFT		0
 #define lpfc_mbx_rq_ftr_rsp_iaab_MASK		0x00000001
@@ -2974,6 +2980,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_mrqp_SHIFT		16
 #define lpfc_mbx_rq_ftr_rsp_mrqp_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
+#define lpfc_mbx_rq_ftr_rsp_ashdr_SHIFT         17
+#define lpfc_mbx_rq_ftr_rsp_ashdr_MASK          0x00000001
+#define lpfc_mbx_rq_ftr_rsp_ashdr_WORD          word3
 };
 
 struct lpfc_mbx_supp_pages {
@@ -4391,6 +4400,9 @@ struct wqe_common {
 #define wqe_xchg_WORD         word10
 #define LPFC_SCSI_XCHG	      0x0
 #define LPFC_NVME_XCHG	      0x1
+#define wqe_appid_SHIFT       5
+#define wqe_appid_MASK        0x00000001
+#define wqe_appid_WORD        word10
 #define wqe_oas_SHIFT         6
 #define wqe_oas_MASK          0x00000001
 #define wqe_oas_WORD          word10
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ac67f420ec26..dea423bc1293 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -98,6 +98,7 @@ static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 #define LPFC_NVMET_BUF_POST 254
+static u8 lpfc_vmid_res_alloc(struct lpfc_hba *phba, struct lpfc_vport *vport);
 
 /**
  * lpfc_config_port_prep - Perform lpfc initialization prior to config port
@@ -2843,6 +2844,10 @@ lpfc_cleanup(struct lpfc_vport *vport)
 	if (phba->link_state > LPFC_LINK_DOWN)
 		lpfc_port_link_failure(vport);
 
+	/* cleanup vmid resources */
+	if (lpfc_is_vmid_enabled(phba))
+		lpfc_vmid_vport_cleanup(vport);
+
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
 		if (vport->port_type != LPFC_PHYSICAL_PORT &&
 		    ndlp->nlp_DID == Fabric_DID) {
@@ -4269,6 +4274,62 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 		return rol64(wwn, 32);
 }
 
+/**
+ * lpfc_vmid_res_alloc - Allocates resources for VMID
+ * @phba: pointer to lpfc hba data structure.
+ * @vport: pointer to vport data structure
+ *
+ * This routine allocated the resources needed for the vmid.
+ *
+ * Return codes
+ *	0 on Succeess
+ *	Non-0 on Failure
+ */
+static u8
+lpfc_vmid_res_alloc(struct lpfc_hba *phba, struct lpfc_vport *vport)
+{
+	u16 i;
+
+	/* vmid feature is supported only on SLI4 */
+	if (phba->sli_rev == LPFC_SLI_REV3) {
+		phba->cfg_vmid_app_header = 0;
+		phba->cfg_vmid_priority_tagging = 0;
+	}
+
+	/* if enabled, then allocated the resources */
+	if (lpfc_is_vmid_enabled(phba)) {
+		vport->vmid =
+		    kmalloc_array(phba->cfg_max_vmid, sizeof(struct lpfc_vmid),
+				  GFP_KERNEL);
+		if (!vport->vmid)
+			return FAILURE;
+
+		memset(vport->vmid, 0,
+		       phba->cfg_max_vmid * sizeof(struct lpfc_vmid));
+
+		rwlock_init(&vport->vmid_lock);
+
+		/* setting the VMID parameters for the vport */
+		vport->vmid_priority_tagging = phba->cfg_vmid_priority_tagging;
+		vport->vmid_inactivity_timeout =
+		    phba->cfg_vmid_inactivity_timeout;
+		vport->max_vmid = phba->cfg_max_vmid;
+		vport->cur_vmid_cnt = 0;
+
+		for (i = 0; i < LPFC_VMID_HASH_SIZE; i++)
+			vport->hash_table[i] = NULL;
+
+		vport->vmid_priority_range = bitmap_zalloc
+			(LPFC_VMID_MAX_PRIORITY_RANGE, GFP_KERNEL);
+
+		if (!vport->vmid_priority_range) {
+			kfree(vport->vmid);
+			return FAILURE;
+		}
+	}
+	return 0;
+}
+
 /**
  * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
@@ -4421,6 +4482,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 			vport->port_type, shost->sg_tablesize,
 			phba->cfg_scsi_seg_cnt, phba->cfg_sg_seg_cnt);
 
+	/* allocate the resources for vmid */
+	rc = lpfc_vmid_res_alloc(phba, vport);
+
+	if (rc)
+		goto out;
+
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
@@ -4445,6 +4512,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	return vport;
 
 out_put_shost:
+	kfree(vport->vmid);
+	bitmap_free(vport->vmid_priority_range);
 	scsi_host_put(shost);
 out:
 	return NULL;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 3414ffcb26fe..78a9b9baecf3 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2100,6 +2100,12 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 		bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
 		bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
 	}
+
+	/* Enable Application Services Header for apphedr VMID */
+	if (phba->cfg_vmid_app_header) {
+		bf_set(lpfc_mbx_rq_ftr_rq_ashdr, &mboxq->u.mqe.un.req_ftrs, 1);
+		bf_set(lpfc_ftr_ashdr, &phba->sli4_hba.sli4_flags, 1);
+	}
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3b989f720937..b79b6f03cdb6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5370,6 +5370,27 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	return 0;
 }
 
+/*
+ * lpfc_vmid_vport_cleanup - cleans up the resources associated with a vports
+ * @vport: The virtual port for which this call is being executed.
+ */
+void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport)
+{
+	/* delete the timer */
+	if (vport->port_type == LPFC_PHYSICAL_PORT)
+		del_timer_sync(&vport->phba->inactive_vmid_poll);
+
+	/* free the resources */
+	kfree(vport->qfpa_res);
+	kfree(vport->vmid_priority.vmid_range);
+	kfree(vport->vmid);
+
+	/* reset variables */
+	vport->qfpa_res = NULL;
+	vport->vmid_priority.vmid_range = NULL;
+	vport->vmid = NULL;
+	vport->cur_vmid_cnt = 0;
+}
 
 /**
  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 95caad764fb7..f9b6e32db618 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7696,6 +7696,15 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		goto out_free_mbox;
 	}
 
+	/* Disable vmid if app header is not supported */
+	if (phba->cfg_vmid_app_header && !(bf_get(lpfc_mbx_rq_ftr_rsp_ashdr,
+						  &mqe->un.req_ftrs))) {
+		bf_set(lpfc_ftr_ashdr, &phba->sli4_hba.sli4_flags, 0);
+		phba->cfg_vmid_app_header = 0;
+		lpfc_printf_log(phba, KERN_DEBUG, LOG_SLI,
+				"1242 vmid feature not supported");
+	}
+
 	/*
 	 * The port must support FCP initiator mode as this is the
 	 * only mode running in the host.
-- 
2.26.2

