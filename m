Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCD4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25331206DA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iOYVnM17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgHDJHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgHDJHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:40 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F0CC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:40 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e5so16316616qth.5
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hoXhJ2apW5T522xOAJP1Ix+CO9BUJYbeYj/575zZFvQ=;
        b=iOYVnM17gu3/vzTC4ftU2i6xD8Flr08fmbzH5Ck9oZxXa/Gn0Ow3immdCrwUPOtxSW
         C1wIeajjq/s4cLwYYAOIEq1Lp1xHl0z2Xvfx5+/xgUQbVY8XMNfgp1gtGfrfjXp52FM3
         iNS5sCyFW1fj/5QNx/tMgWEi3nU5dXTwQtqB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hoXhJ2apW5T522xOAJP1Ix+CO9BUJYbeYj/575zZFvQ=;
        b=qUZBCVecvboJDsv4h33h12QWaJIDCh1npBut8A5hS4TQY7VtMyZcWLiOY7haHCwjtn
         sSTfhcic/G4vM6Hw9IleN/8FvqVmqw6kwiYMHrrEq0UmtEuhcv6hso/vjn9yCWxwrI65
         1BjeSlOhi3s4dBhrLrl5fvuRmSp2JoiFs3p6NRey1rd6WqfH7+z4MFjIWrpYf+mbtj+v
         GVcjJFRttguFKfw0gKUNfBxbf+GwA8dRi/sn0zbcwzS5tcEPxzmcj3FqnbsLwry/yEnL
         ldQzcjvNOxpI5Dd8NjeroUIHmMqm5PjHgp2J1CbWbxF/Tf1ZsBSOwUqwaSg+rRokGzKs
         DQAg==
X-Gm-Message-State: AOAM533cmniQa1h/VcOCQ8hOVx/YkghdEJ0zxthF6kkCzT8lkdLogW/e
        +8pbwAKAA4DyocyGGSKLqLGKqA==
X-Google-Smtp-Source: ABdhPJxCtRLuGI4hUcmH1wjQseZm/UXE80rF0waenXM4tY1GpWp9DRzuFil55asgR4O/M4/TAouj9w==
X-Received: by 2002:aed:208b:: with SMTP id 11mr21201786qtb.234.1596532059075;
        Tue, 04 Aug 2020 02:07:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:38 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 10/16] lpfc: vmid: Implements ELS commands for appid patch
Date:   Tue,  4 Aug 2020 07:43:10 +0530
Message-Id: <1596507196-27417-11-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch implements ELS command like QFPA and UVEM for the priority
tagging appid support. Other supporting functions are also part of this
patch.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 356 ++++++++++++++++++++++++++++++++++-
 1 file changed, 349 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 85d4e4000c25..bdb3ab9fd052 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -55,6 +56,8 @@ static int lpfc_issue_els_fdisc(struct lpfc_vport *vport,
 				struct lpfc_nodelist *ndlp, uint8_t retry);
 static int lpfc_issue_fabric_iocb(struct lpfc_hba *phba,
 				  struct lpfc_iocbq *iocb);
+static void lpfc_cmpl_els_uvem(struct lpfc_hba *, struct lpfc_iocbq *,
+			       struct lpfc_iocbq *);
 
 static int lpfc_max_els_tries = 3;
 
@@ -316,12 +319,12 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	if (expectRsp) {
 		/* Xmit ELS command <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "0116 Xmit ELS command x%x to remote "
-				 "NPORT x%x I/O tag: x%x, port state:x%x "
-				 "rpi x%x fc_flag:x%x\n",
+				 "0116 Xmit ELS command x%x to remote\n"
+				 "NPORT x%x I/O tag: x%x, port state:x%x\n"
+				 "rpi x%x fc_flag:x%x nlp_flag:x%x vport:x%p\n",
 				 elscmd, did, elsiocb->iotag,
 				 vport->port_state, ndlp->nlp_rpi,
-				 vport->fc_flag);
+				 vport->fc_flag, ndlp->nlp_flag, vport);
 	} else {
 		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -1116,12 +1119,16 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes successfully, I/O tag:x%x, "
-			 "xri x%x Data: x%x x%x x%x x%x x%x %x\n",
+			 "0101 FLOGI completes successfully, I/O tag:x%x,\n"
+			 "xri x%x Data: x%x x%x x%x x%x x%x %x %x\n",
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
@@ -1302,6 +1309,18 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
+	/* to deterine if switch supports priority tagging */
+	if (phba->cfg_vmid_priority_tagging) {
+		sp->cmn.priority_tagging = 1;
+		/* lpfc_vmid_host_uuid is combination of wwpn and wwnn */
+		if (vport->lpfc_vmid_host_uuid[0] == 0) {
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
@@ -1999,6 +2018,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *prsp;
 	int disc;
+	struct serv_parm *sp = NULL;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2074,6 +2094,23 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
+					"4018 app_hdr_support %d tagging %d DID x%x",
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
@@ -2192,6 +2229,14 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
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
@@ -10153,3 +10198,300 @@ lpfc_sli_abts_recover_port(struct lpfc_vport *vport,
 	lpfc_unreg_rpi(vport, ndlp);
 }
 
+void lpfc_init_cs_ctl_bitmap(struct lpfc_vport *vport)
+{
+	bitmap_zero(vport->vmid_priority_range, LPFC_VMID_MAX_PRIORITY_RANGE);
+}
+
+void
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
+void lpfc_vmid_put_cs_ctl(struct lpfc_vport *vport, u32 ctcl_vmid)
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
+	u8 *pcmd;
+	u32 len, i;
+
+	prsp = list_get_first(&dmabuf->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
+
+	pcmd = prsp->virt;
+	data = (u32 *)pcmd;
+	if (*((u32 *)(pcmd)) == ELS_CMD_LS_RJT) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "6528 QFPA LS_RJT %x  %x ", data[0], data[1]);
+		goto out;
+	}
+	if (irsp->ulpStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
+				 "6529 QFPA failed with status %x  %x ",
+				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+		goto out;
+	}
+
+	if (!vport->qfpa_res) {
+		vport->qfpa_res = kmalloc(FCELSSIZE, GFP_KERNEL);
+		if (!vport->qfpa_res)
+			goto out;
+		memset(vport->qfpa_res, 0, FCELSSIZE);
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
+		vmid_range = kmalloc_array(MAX_PRIORITY_DESC,
+					   sizeof
+					   (struct lpfc_vmid_priority_range),
+					   GFP_KERNEL);
+		if (!vmid_range)
+			goto out;
+		memset(vmid_range, 0, MAX_PRIORITY_DESC *
+		       sizeof(struct lpfc_vmid_priority_range));
+		vport->vmid_priority.vmid_range = vmid_range;
+	}
+	vport->vmid_priority.num_descriptors = len;
+
+	for (i = 0; i < len; i++, vmid_range++, desc++) {
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
+				 "6539 vmid values low=%d, high=%d, qos=%d,\n"
+				 " local ve id=%d\n", desc->lo_range,
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
+}
+
+int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	IOCB_t *icmd;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_iocbq *elsiocb;
+	struct lpfc_sli *psli;
+	u8 *pcmd;
+	int ret;
+
+	psli = &phba->sli;
+
+	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
+	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
+		return 1;
+
+	if (!ndlp)
+		return 1;
+
+	elsiocb = lpfc_prep_els_iocb(vport, 1, LPFC_QFPA_SIZE, 2, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_QFPA);
+	if (!elsiocb)
+		return 1;
+
+	icmd = &elsiocb->iocb;
+	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	*((u32 *)(pcmd)) = ELS_CMD_QFPA;
+	pcmd += 4;
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_qfpa;
+	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 2);
+	if (ret != IOCB_SUCCESS) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
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
+	IOCB_t *icmd;
+	struct lpfc_iocbq *elsiocb;
+	struct instantiated_ve_desc *inst_desc;
+	struct lpfc_vmid_context *vmid_context;
+	u8 *pcmd;
+	u32 *len;
+	int ret = 0;
+
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
+		return 1;
+
+	vmid_context = kmalloc(sizeof(*vmid_context), GFP_KERNEL);
+	if (!vmid_context)
+		return 1;
+	elsiocb = lpfc_prep_els_iocb(vport, 1, LPFC_UVEM_SIZE, 2,
+				     ndlp, Fabric_DID, ELS_CMD_UVEM);
+	if (!elsiocb)
+		goto out;
+
+	lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
+			 "3427 %s %d", vmid->host_vmid, instantiated);
+	vmid_context->vmp = vmid;
+	vmid_context->nlp = ndlp;
+	vmid_context->instantiated = instantiated;
+	elsiocb->vmid_tag.vmid_context = vmid_context;
+	icmd = &elsiocb->iocb;
+	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	if (vport->lpfc_vmid_host_uuid[0] == 0)
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
+	ret = lpfc_sli_issue_iocb(vport->phba, LPFC_ELS_RING, elsiocb, 0);
+	if (ret != IOCB_SUCCESS) {
+		lpfc_els_free_iocb(vport->phba, elsiocb);
+		goto out;
+	}
+
+	return 0;
+ out:
+	kfree(vmid_context);
+	return 1;
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
+	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
+		ndlp = NULL;
+
+	prsp = list_get_first(&dmabuf->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
+	pcmd = prsp->virt;
+	data = (u32 *)pcmd;
+	if (*((u32 *)(pcmd)) == ELS_CMD_LS_RJT) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "4532 UVEM LS_RJT %x %x ", data[0], data[1]);
+		goto out;
+	}
+	if (irsp->ulpStatus) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
+				 "4533 UVEM error status %x: %x ",
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
+		vmid->flag |= LPFC_VMID_REGISTERED;
+		vmid->flag &= ~LPFC_VMID_REQ_REGISTER;
+	}
+
+ out:
+	kfree(vmid_context);
+	lpfc_els_free_iocb(phba, icmdiocb);
+}
-- 
2.18.2

