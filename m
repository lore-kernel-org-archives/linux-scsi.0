Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36AFC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870C8613A3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbhDGF72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:59:28 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:39338 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345339AbhDGF7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 01:59:25 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 0ADB724324;
        Tue,  6 Apr 2021 22:59:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0ADB724324
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1617775156;
        bh=qBzGoPVfrxWdKqcZg/KO+c35PWwrSf7NaLtP2w5jmwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwENxNX8cu88nsUiQ4FZNsUlGACbQFDK37ZBa2nt+v3QtAw9VWlT+HJFYGpPz/+aQ
         CxZm5DnjM5xMW970FR2/n36MLSIKLmHuCVvatUdw5Eb677k5YVtd948qb+5LJiHVd/
         TizHKGKfloiDS8VoY4y9oFUFN89iv1ly6biaUnvg=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v9 07/13] lpfc: vmid: Implements ELS commands for appid patch
Date:   Wed,  7 Apr 2021 04:36:31 +0530
Message-Id: <1617750397-26466-8-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch implements ELS command like QFPA and UVEM for the priority
tagging appid support. Other supporting functions are also part of this
patch.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v9:
Added a lock while accessing a flag

v8:
Added log messages modifications, memory allocation API changes,
return error codes

v7:
No change

v6:
Added Forward declarations, static functions and
removed unused variables

v5:
Changed Return code to non-numeric/Symbol.
Addressed the review comments by Hannes

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_els.c | 366 ++++++++++++++++++++++++++++++++++-
 1 file changed, 362 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a04546eca18f..22a87559f62d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -55,9 +56,15 @@ static int lpfc_issue_els_fdisc(struct lpfc_vport *vport,
 				struct lpfc_nodelist *ndlp, uint8_t retry);
 static int lpfc_issue_fabric_iocb(struct lpfc_hba *phba,
 				  struct lpfc_iocbq *iocb);
+static void lpfc_cmpl_els_uvem(struct lpfc_hba *, struct lpfc_iocbq *,
+			       struct lpfc_iocbq *);
 
 static int lpfc_max_els_tries = 3;
 
+static void lpfc_init_cs_ctl_bitmap(struct lpfc_vport *vport);
+static void lpfc_vmid_set_cs_ctl_range(struct lpfc_vport *vport, u32 min, u32 max);
+static void lpfc_vmid_put_cs_ctl(struct lpfc_vport *vport, u32 ctcl_vmid);
+
 /**
  * lpfc_els_chk_latt - Check host link attention event for a vport
  * @vport: pointer to a host virtual N_Port data structure.
@@ -314,10 +321,10 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "0116 Xmit ELS command x%x to remote "
 				 "NPORT x%x I/O tag: x%x, port state:x%x "
-				 "rpi x%x fc_flag:x%x\n",
+				 "rpi x%x fc_flag:x%x nlp_flag:x%x vport:x%p\n",
 				 elscmd, did, elsiocb->iotag,
 				 vport->port_state, ndlp->nlp_rpi,
-				 vport->fc_flag);
+				 vport->fc_flag, ndlp->nlp_flag, vport);
 	} else {
 		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -1112,11 +1119,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0101 FLOGI completes successfully, I/O tag:x%x, "
-			 "xri x%x Data: x%x x%x x%x x%x x%x %x\n",
+			 "xri x%x Data: x%x x%x x%x x%x x%x x%x x%x\n",
 			 cmdiocb->iotag, cmdiocb->sli4_xritag,
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution,
-			 vport->port_state, vport->fc_flag);
+			 vport->port_state, vport->fc_flag,
+			 sp->cmn.priority_tagging);
+
+	if (sp->cmn.priority_tagging)
+		vport->vmid_flag |= LPFC_VMID_ISSUE_QFPA;
 
 	if (vport->port_state == LPFC_FLOGI) {
 		/*
@@ -1299,6 +1310,18 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
+	/* to deterine if switch supports priority tagging */
+	if (phba->cfg_vmid_priority_tagging) {
+		sp->cmn.priority_tagging = 1;
+		/* lpfc_vmid_host_uuid is combination of wwpn and wwnn */
+		if (uuid_is_null((uuid_t *)vport->lpfc_vmid_host_uuid)) {
+			memcpy(vport->lpfc_vmid_host_uuid, phba->wwpn,
+			       sizeof(phba->wwpn));
+			memcpy(&vport->lpfc_vmid_host_uuid[8], phba->wwnn,
+			       sizeof(phba->wwnn));
+		}
+	}
+
 	if  (phba->sli_rev == LPFC_SLI_REV4) {
 		if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 		    LPFC_SLI_INTF_IF_TYPE_0) {
@@ -1907,6 +1930,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp, *free_ndlp;
 	struct lpfc_dmabuf *prsp;
 	int disc;
+	struct serv_parm *sp = NULL;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -1997,6 +2021,23 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				   cmdiocb->context2)->list.next,
 				  struct lpfc_dmabuf, list);
 		ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
+
+		sp = (struct serv_parm *)((u8 *)prsp->virt +
+					  sizeof(u32));
+
+		ndlp->vmid_support = 0;
+		if ((phba->cfg_vmid_app_header && sp->cmn.app_hdr_support) ||
+		    (phba->cfg_vmid_priority_tagging &&
+		     sp->cmn.priority_tagging)) {
+			lpfc_printf_log(phba, KERN_DEBUG, LOG_ELS,
+					"4018 app_hdr_support %d tagging %d DID x%x\n",
+					sp->cmn.app_hdr_support,
+					sp->cmn.priority_tagging,
+					ndlp->nlp_DID);
+			/* if the dest port supports VMID, mark it in ndlp */
+			ndlp->vmid_support = 1;
+		}
+
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 	}
@@ -2119,6 +2160,14 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
 	sp->cmn.bbRcvSizeMsb &= 0xF;
 
+	/* check if the destination port supports VMID */
+	ndlp->vmid_support = 0;
+	if (vport->vmid_priority_tagging)
+		sp->cmn.priority_tagging = 1;
+	else if (phba->cfg_vmid_app_header &&
+		 bf_get(lpfc_ftr_ashdr, &phba->sli4_hba.sli4_flags))
+		sp->cmn.app_hdr_support = 1;
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PLOGI:     did:x%x",
 		did, 0, 0);
@@ -10260,3 +10309,312 @@ lpfc_sli_abts_recover_port(struct lpfc_vport *vport,
 	lpfc_unreg_rpi(vport, ndlp);
 }
 
+static void lpfc_init_cs_ctl_bitmap(struct lpfc_vport *vport)
+{
+	bitmap_zero(vport->vmid_priority_range, LPFC_VMID_MAX_PRIORITY_RANGE);
+}
+
+static void
+lpfc_vmid_set_cs_ctl_range(struct lpfc_vport *vport, u32 min, u32 max)
+{
+	u32 i;
+
+	if ((min > max) || (max > LPFC_VMID_MAX_PRIORITY_RANGE))
+		return;
+
+	for (i = min; i <= max; i++)
+		set_bit(i, vport->vmid_priority_range);
+}
+
+static void lpfc_vmid_put_cs_ctl(struct lpfc_vport *vport, u32 ctcl_vmid)
+{
+	set_bit(ctcl_vmid, vport->vmid_priority_range);
+}
+
+u32 lpfc_vmid_get_cs_ctl(struct lpfc_vport *vport)
+{
+	u32 i;
+
+	i = find_first_bit(vport->vmid_priority_range,
+			   LPFC_VMID_MAX_PRIORITY_RANGE);
+
+	if (i == LPFC_VMID_MAX_PRIORITY_RANGE)
+		return 0;
+
+	clear_bit(i, vport->vmid_priority_range);
+	return i;
+}
+
+#define MAX_PRIORITY_DESC	255
+
+static void
+lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		   struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct priority_range_desc *desc;
+	struct lpfc_dmabuf *prsp = NULL;
+	struct lpfc_vmid_priority_range *vmid_range = NULL;
+	u32 *data;
+	struct lpfc_dmabuf *dmabuf = cmdiocb->context2;
+	IOCB_t *irsp = &rspiocb->iocb;
+	u8 *pcmd, max_desc;
+	u32 len, i;
+	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+
+	prsp = list_get_first(&dmabuf->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
+
+	pcmd = prsp->virt;
+	data = (u32 *)pcmd;
+	if (data[0] == ELS_CMD_LS_RJT) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "3277 QFPA LS_RJT x%x  x%x\n",
+				 data[0], data[1]);
+		goto out;
+	}
+	if (irsp->ulpStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
+				 "6529 QFPA failed with status x%x  x%x\n",
+				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+		goto out;
+	}
+
+	if (!vport->qfpa_res) {
+		max_desc = FCELSSIZE / sizeof(*vport->qfpa_res);
+		vport->qfpa_res = kcalloc(max_desc, sizeof(*vport->qfpa_res),
+					  GFP_KERNEL);
+		if (!vport->qfpa_res)
+			goto out;
+	}
+
+	len = *((u32 *)(pcmd + 4));
+	len = be32_to_cpu(len);
+	memcpy(vport->qfpa_res, pcmd, len + 8);
+	len = len / LPFC_PRIORITY_RANGE_DESC_SIZE;
+
+	desc = (struct priority_range_desc *)(pcmd + 8);
+	vmid_range = vport->vmid_priority.vmid_range;
+	if (!vmid_range) {
+		vmid_range = kcalloc(MAX_PRIORITY_DESC, sizeof(*vmid_range),
+				     GFP_KERNEL);
+		if (!vmid_range) {
+			kfree(vport->qfpa_res);
+			goto out;
+		}
+		vport->vmid_priority.vmid_range = vmid_range;
+	}
+	vport->vmid_priority.num_descriptors = len;
+
+	for (i = 0; i < len; i++, vmid_range++, desc++) {
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
+				 "6539 vmid values low=%d, high=%d, qos=%d, "
+				 "local ve id=%d\n", desc->lo_range,
+				 desc->hi_range, desc->qos_priority,
+				 desc->local_ve_id);
+
+		vmid_range->low = desc->lo_range << 1;
+		if (desc->local_ve_id == QFPA_ODD_ONLY)
+			vmid_range->low++;
+		if (desc->qos_priority)
+			vport->vmid_flag |= LPFC_VMID_QOS_ENABLED;
+		vmid_range->qos = desc->qos_priority;
+
+		vmid_range->high = desc->hi_range << 1;
+		if ((desc->local_ve_id == QFPA_ODD_ONLY) ||
+		    (desc->local_ve_id == QFPA_EVEN_ODD))
+			vmid_range->high++;
+	}
+	lpfc_init_cs_ctl_bitmap(vport);
+	for (i = 0; i < vport->vmid_priority.num_descriptors; i++) {
+		lpfc_vmid_set_cs_ctl_range(vport,
+				vport->vmid_priority.vmid_range[i].low,
+				vport->vmid_priority.vmid_range[i].high);
+	}
+
+	vport->vmid_flag |= LPFC_VMID_QFPA_CMPL;
+ out:
+	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
+}
+
+int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_iocbq *elsiocb;
+	u8 *pcmd;
+	int ret;
+
+	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
+	if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
+		return -ENXIO;
+
+	elsiocb = lpfc_prep_els_iocb(vport, 1, LPFC_QFPA_SIZE, 2, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_QFPA);
+	if (!elsiocb)
+		return -ENOMEM;
+
+	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	*((u32 *)(pcmd)) = ELS_CMD_QFPA;
+	pcmd += 4;
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_qfpa;
+
+	elsiocb->context1 = lpfc_nlp_get(ndlp);
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(vport->phba, elsiocb);
+		return -ENXIO;
+	}
+
+	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 2);
+	if (ret != IOCB_SUCCESS) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return -EIO;
+	}
+	vport->vmid_flag &= ~LPFC_VMID_QOS_ENABLED;
+	return 0;
+}
+
+int
+lpfc_vmid_uvem(struct lpfc_vport *vport,
+	       struct lpfc_vmid *vmid, bool instantiated)
+{
+	struct lpfc_vem_id_desc *vem_id_desc;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_iocbq *elsiocb;
+	struct instantiated_ve_desc *inst_desc;
+	struct lpfc_vmid_context *vmid_context;
+	u8 *pcmd;
+	u32 *len;
+	int ret = 0;
+
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
+		return -ENXIO;
+
+	vmid_context = kmalloc(sizeof(*vmid_context), GFP_KERNEL);
+	if (!vmid_context)
+		return -ENOMEM;
+	elsiocb = lpfc_prep_els_iocb(vport, 1, LPFC_UVEM_SIZE, 2,
+				     ndlp, Fabric_DID, ELS_CMD_UVEM);
+	if (!elsiocb)
+		goto out;
+
+	lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
+			 "3427 Host vmid %s %d\n",
+			 vmid->host_vmid, instantiated);
+	vmid_context->vmp = vmid;
+	vmid_context->nlp = ndlp;
+	vmid_context->instantiated = instantiated;
+	elsiocb->vmid_tag.vmid_context = vmid_context;
+	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	if (uuid_is_null((uuid_t *)vport->lpfc_vmid_host_uuid))
+		memcpy(vport->lpfc_vmid_host_uuid, vmid->host_vmid,
+		       LPFC_COMPRESS_VMID_SIZE);
+
+	*((u32 *)(pcmd)) = ELS_CMD_UVEM;
+	len = (u32 *)(pcmd + 4);
+	*len = cpu_to_be32(LPFC_UVEM_SIZE - 8);
+
+	vem_id_desc = (struct lpfc_vem_id_desc *)(pcmd + 8);
+	vem_id_desc->tag = be32_to_cpu(VEM_ID_DESC_TAG);
+	vem_id_desc->length = be32_to_cpu(LPFC_UVEM_VEM_ID_DESC_SIZE);
+	memcpy(vem_id_desc->vem_id, vport->lpfc_vmid_host_uuid,
+	       LPFC_COMPRESS_VMID_SIZE);
+
+	inst_desc = (struct instantiated_ve_desc *)(pcmd + 32);
+	inst_desc->tag = be32_to_cpu(INSTANTIATED_VE_DESC_TAG);
+	inst_desc->length = be32_to_cpu(LPFC_UVEM_VE_MAP_DESC_SIZE);
+	memcpy(inst_desc->global_vem_id, vmid->host_vmid,
+	       LPFC_COMPRESS_VMID_SIZE);
+
+	bf_set(lpfc_instantiated_nport_id, inst_desc, vport->fc_myDID);
+	bf_set(lpfc_instantiated_local_id, inst_desc,
+	       vmid->un.cs_ctl_vmid);
+	if (instantiated) {
+		inst_desc->tag = be32_to_cpu(INSTANTIATED_VE_DESC_TAG);
+	} else {
+		inst_desc->tag = be32_to_cpu(DEINSTANTIATED_VE_DESC_TAG);
+		lpfc_vmid_put_cs_ctl(vport, vmid->un.cs_ctl_vmid);
+	}
+	inst_desc->word6 = cpu_to_be32(inst_desc->word6);
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_uvem;
+
+	elsiocb->context1 = lpfc_nlp_get(ndlp);
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(vport->phba, elsiocb);
+		goto out;
+	}
+
+	ret = lpfc_sli_issue_iocb(vport->phba, LPFC_ELS_RING, elsiocb, 0);
+	if (ret != IOCB_SUCCESS) {
+		lpfc_els_free_iocb(vport->phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		goto out;
+	}
+
+	return 0;
+ out:
+	kfree(vmid_context);
+	return -EIO;
+}
+
+static void
+lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
+		   struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = icmdiocb->vport;
+	struct lpfc_dmabuf *prsp = NULL;
+	struct lpfc_vmid_context *vmid_context =
+	    icmdiocb->vmid_tag.vmid_context;
+	struct lpfc_nodelist *ndlp = icmdiocb->context1;
+	u8 *pcmd;
+	u32 *data;
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_dmabuf *dmabuf = icmdiocb->context2;
+	struct lpfc_vmid *vmid;
+
+	vmid = vmid_context->vmp;
+	if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
+		ndlp = NULL;
+
+	prsp = list_get_first(&dmabuf->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
+	pcmd = prsp->virt;
+	data = (u32 *)pcmd;
+	if (data[0] == ELS_CMD_LS_RJT) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "4532 UVEM LS_RJT %x %x\n", data[0], data[1]);
+		goto out;
+	}
+	if (irsp->ulpStatus) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "4533 UVEM error status %x: %x\n",
+				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+		goto out;
+	}
+	spin_lock(&phba->hbalock);
+	/* Set IN USE flag */
+	vport->vmid_flag |= LPFC_VMID_IN_USE;
+	phba->pport->vmid_flag |= LPFC_VMID_IN_USE;
+	spin_unlock(&phba->hbalock);
+
+	if (vmid_context->instantiated) {
+		write_lock(&vport->vmid_lock);
+		vmid->flag |= LPFC_VMID_REGISTERED;
+		vmid->flag &= ~LPFC_VMID_REQ_REGISTER;
+		write_unlock(&vport->vmid_lock);
+	}
+
+ out:
+	kfree(vmid_context);
+	lpfc_els_free_iocb(phba, icmdiocb);
+	lpfc_nlp_put(ndlp);
+}
-- 
2.26.2

