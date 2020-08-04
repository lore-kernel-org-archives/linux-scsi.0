Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF1BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1962D22B40
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D/fZX0F4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgHDJHr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgHDJHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:47 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F13EC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:47 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id w2so6566163qvh.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l61nojNUPkIRND3NUwrxjmc37uGdSMnKAucqjZPVZbU=;
        b=D/fZX0F48bJXaKgYWRH1AyXe0iTrl1IjJQi/SjgcTHTg5DtefdVzirn8SZBPjnlEqK
         Dx//UfEeFyjwu+YnyES85KRWpJ8tmoZOOcSY1si8SgYazWSVYSCCJuRtVAboM/N4kkp0
         P/GGKeF9uCgS+AXFMUHhDDHBKKcNTsuyPmINU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l61nojNUPkIRND3NUwrxjmc37uGdSMnKAucqjZPVZbU=;
        b=ea77yD5C5ykONOvrIIj7ZVeOcWIFxdEJYuydgN/5I+j/K69Yp5Nbz8HL6gdSrSToH+
         YcDghU/u/5PjGL2gU4tTW4PJzqfw+apAILcThgpRYr+5a9ymm6VGwMFXRLg1tTW6zBIJ
         t3IF57PsdG9Y5Xl+6B3GEOVm9F6Ws1dPoyc5odH+CRDftV/XJNHNWqMegKxN8DT0lFNl
         KmvoOnMJRIdWMhi4r5ZA0ZSyjKB9YEye1dOi7j04mQm3PC3Xiq28SNkwp3NvNntuclFj
         NnWdMA0dQTPjlGqdMXx1IB16c6W9GIjt+CBIEvq5aOFq4w0tTyHrIsx8DhrKQ4h4l50X
         5MiQ==
X-Gm-Message-State: AOAM533DzIc+8UtBIISKyeR8sexXatEsOCUtM/iWJMpfwbbOImK8RqrI
        r+bUDfT9D+Df3KNDZ+gIloR9EA==
X-Google-Smtp-Source: ABdhPJwKkN4i2j42tWpTHR9wvijek5wjudcsn6ndVDhVJQa37yO0z2uQY7dqw/6gIF66sUkgVzEamA==
X-Received: by 2002:a05:6214:154a:: with SMTP id t10mr12090169qvw.146.1596532066328;
        Tue, 04 Aug 2020 02:07:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:45 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 12/16] lpfc: vmid: Implements CT commands for appid.
Date:   Tue,  4 Aug 2020 07:43:12 +0530
Message-Id: <1596507196-27417-13-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

The patch implements CT commands for registering and deregistering the
appid for the application. Also, a small change in decrementing the ndlp
ref counter has been added.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 256 ++++++++++++++++++++++++++++++++++--
 1 file changed, 245 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index dd9f2bf54edd..d194a3efe61b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -388,6 +388,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 
 	if (rc == IOCB_ERROR) {
 		lpfc_sli_release_iocbq(phba, geniocb);
+		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 
@@ -1829,11 +1830,6 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	}
 	rc=6;
 
-	/* Decrement ndlp reference count to release ndlp reference held
-	 * for the failed command's callback function.
-	 */
-	lpfc_nlp_put(ndlp);
-
 ns_cmd_free_bmpvirt:
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 ns_cmd_free_bmp:
@@ -3238,12 +3234,6 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, 0))
 		return 0;
 
-	/*
-	 * Decrement ndlp reference count to release ndlp reference held
-	 * for the failed command's callback function.
-	 */
-	lpfc_nlp_put(ndlp);
-
 fdmi_cmd_free_bmpvirt:
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 fdmi_cmd_free_bmp:
@@ -3394,3 +3384,247 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 	}
 	return;
 }
+
+void
+lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		      struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_dmabuf *inp = cmdiocb->context1;
+	struct lpfc_dmabuf *outp = cmdiocb->context2;
+	struct lpfc_sli_ct_request *ctcmd = inp->virt;
+	struct lpfc_sli_ct_request *ctrsp = outp->virt;
+	u16 rsp = ctrsp->CommandResponse.bits.CmdRsp;
+	struct app_id_object *app;
+	u32 cmd, hash;
+	struct lpfc_vmid *vmp;
+	u8 *data = outp->virt;
+	int i;
+
+	cmd = be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
+	if (cmd == SLI_CTAS_DALLAPP_ID)
+		lpfc_ct_free_iocb(phba, cmdiocb);
+
+	if (lpfc_els_chk_latt(vport) || rspiocb->iocb.ulpStatus) {
+		if (cmd != SLI_CTAS_DALLAPP_ID)
+			return;
+	}
+	/* Check for a CT LS_RJT response */
+	if (rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
+		if (cmd != SLI_CTAS_DALLAPP_ID)
+			lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+					 "3306 VMID FS_RJT Data: x%x  %x %x\n",
+				 cmd, ctrsp->ReasonCode, ctrsp->Explanation);
+		if ((cmd != SLI_CTAS_DALLAPP_ID) ||
+		    (ctrsp->ReasonCode != SLI_CT_UNABLE_TO_PERFORM_REQ) ||
+		    (ctrsp->Explanation != SLI_CT_APP_ID_NOT_AVAILABLE)) {
+			/* If DALLAPP_ID failed retry later */
+			if (cmd == SLI_CTAS_DALLAPP_ID)
+				vport->load_flag |= FC_DEREGISTER_ALL_APP_ID;
+			return;
+		}
+	}
+
+	switch (cmd) {
+	case SLI_CTAS_RAPP_IDENT:
+		app = (struct app_id_object *)(RAPP_IDENT_OFFSET + data);
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "6712 RAPP_IDENT app id %d  port id %x id\n"
+				 "len %d\n", be32_to_cpu(app->app_id),
+				 be32_to_cpu(app->port_id),
+				 app->obj.entity_id_len);
+
+		if (app->obj.entity_id_len == 0 || app->port_id == 0)
+			return;
+
+		hash = lpfc_vmid_hash_fn(app->obj.entity_id,
+					 app->obj.entity_id_len);
+		vmp = lpfc_get_vmid_from_hastable(vport, hash,
+						  app->obj.entity_id);
+		if (vmp) {
+			vmp->un.app_id = be32_to_cpu(app->app_id);
+			vmp->flag |= LPFC_VMID_REGISTERED;
+			vmp->flag &= ~LPFC_VMID_REQ_REGISTER;
+			/* Set IN USE flag */
+			vport->vmid_flag |= LPFC_VMID_IN_USE;
+		} else {
+			lpfc_printf_vlog(vport, KERN_DEBUG,
+					 LOG_DISCOVERY, "6901 No entry found\n"
+					 "%s hash %d\n", app->obj.entity_id,
+					 hash);
+		}
+		break;
+	case SLI_CTAS_DAPP_IDENT:
+		app = (struct app_id_object *)(DAPP_IDENT_OFFSET + data);
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "6713 DAPP_IDENT app id %d  port id %x",
+				 cpu_to_be32(app->app_id),
+				 cpu_to_be32(app->port_id));
+		break;
+	case SLI_CTAS_DALLAPP_ID:
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "8856 Deregistered all app ids");
+		for (i = 0; i < phba->cfg_max_vmid; i++) {
+			vmp = &vport->vmid[i];
+			if (vmp->flag != LPFC_VMID_SLOT_FREE)
+				memset(vmp, 0, sizeof(struct lpfc_vmid));
+		}
+		for (i = 0; i < LPFC_VMID_HASH_SIZE; i++)
+			vport->hash_table[i] = NULL;
+		vport->load_flag |= FC_ALLOW_VMID;
+		break;
+	default:
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "8857 Invalid command code");
+	}
+}
+
+/**
+ * lpfc_vmid_cmd - Build and send a FDMI cmd to the specified NPort
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: ndlp to send FDMI cmd to (if NULL use FDMI_DID)
+ * cmdcode: FDMI command to send
+ * mask: Mask of HBA or PORT Attributes to send
+ *
+ * Builds and sends a FDMI command using the CT subsystem.
+ */
+int
+lpfc_vmid_cmd(struct lpfc_vport *vport,
+	      int cmdcode, struct lpfc_vmid *vmid)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_dmabuf *mp, *bmp;
+	struct lpfc_sli_ct_request *ctreq;
+	struct ulp_bde64 *bpl;
+	u32 size;
+	u32 rsp_size;
+	u8 *data;
+	struct lpfc_vmid_rapp_ident_list *rap;
+	struct lpfc_vmid_dapp_ident_list *dap;
+	u8 retry = 0;
+	struct lpfc_nodelist *ndlp;
+
+	void (*cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		     struct lpfc_iocbq *rspiocb);
+
+	ndlp = lpfc_findnode_did(vport, FDMI_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return 0;
+
+	cmpl = lpfc_cmpl_ct_cmd_vmid;
+
+	/* fill in BDEs for command */
+	/* Allocate buffer for command payload */
+	mp = kmalloc(sizeof(*mp), GFP_KERNEL);
+	if (!mp)
+		goto vmid_free_mp_exit;
+
+	mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+	if (!mp->virt)
+		goto vmid_free_mp_virt_exit;
+
+	/* Allocate buffer for Buffer ptr list */
+	bmp = kmalloc(sizeof(*bmp), GFP_KERNEL);
+	if (!bmp)
+		goto vmid_free_bmp_exit;
+
+	bmp->virt = lpfc_mbuf_alloc(phba, 0, &bmp->phys);
+	if (!bmp->virt)
+		goto vmid_free_bmp_virt_exit;
+
+	INIT_LIST_HEAD(&mp->list);
+	INIT_LIST_HEAD(&bmp->list);
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "0218 VMID Request Data: x%x x%x x%x",
+			 vport->fc_flag, vport->port_state, cmdcode);
+	ctreq = (struct lpfc_sli_ct_request *)mp->virt;
+	data = mp->virt;
+	/* First populate the CT_IU preamble */
+	memset(data, 0, LPFC_BPL_SIZE);
+	ctreq->RevisionId.bits.Revision = SLI_CT_REVISION;
+	ctreq->RevisionId.bits.InId = 0;
+
+	ctreq->FsType = SLI_CT_MANAGEMENT_SERVICE;
+	ctreq->FsSubType = SLI_CT_APP_SEV_Subtypes;
+
+	ctreq->CommandResponse.bits.CmdRsp = cpu_to_be16(cmdcode);
+	rsp_size = LPFC_BPL_SIZE;
+	size = 0;
+
+	switch (cmdcode) {
+	case SLI_CTAS_RAPP_IDENT:
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "1329 RAPP_IDENT for %s", vmid->host_vmid);
+		ctreq->un.PortID = cpu_to_be32(vport->fc_myDID);
+		rap = (struct lpfc_vmid_rapp_ident_list *)
+			(DAPP_IDENT_OFFSET + data);
+		rap->no_of_objects = cpu_to_be32(1);
+		rap->obj[0].entity_id_len = vmid->vmid_len;
+		memcpy(rap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
+		size = RAPP_IDENT_OFFSET +
+			sizeof(struct lpfc_vmid_rapp_ident_list);
+		retry = 1;
+		break;
+
+	case SLI_CTAS_GALLAPPIA_ID:
+		ctreq->un.PortID = cpu_to_be32(vport->fc_myDID);
+		size = GALLAPPIA_ID_SIZE;
+		break;
+
+	case SLI_CTAS_DAPP_IDENT:
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "1469 DAPP_IDENT for %s", vmid->host_vmid);
+		ctreq->un.PortID = cpu_to_be32(vport->fc_myDID);
+		dap = (struct lpfc_vmid_dapp_ident_list *)
+			(DAPP_IDENT_OFFSET + data);
+		dap->no_of_objects = cpu_to_be32(1);
+		dap->obj[0].entity_id_len = vmid->vmid_len;
+		memcpy(dap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
+		size = DAPP_IDENT_OFFSET +
+			sizeof(struct lpfc_vmid_dapp_ident_list);
+		vmid->flag &= ~LPFC_VMID_REGISTERED;
+		retry = 1;
+		break;
+
+	case SLI_CTAS_DALLAPP_ID:
+		ctreq->un.PortID = cpu_to_be32(vport->fc_myDID);
+		size = DALLAPP_ID_SIZE;
+		break;
+
+	default:
+		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+				 "7062 VMID cmdcode x%x not supported",
+				 cmdcode);
+		goto vmid_free_all_mem;
+	}
+
+	ctreq->CommandResponse.bits.Size = cpu_to_be16(rsp_size);
+
+	bpl = (struct ulp_bde64 *)bmp->virt;
+	bpl->addrHigh = putPaddrHigh(mp->phys);
+	bpl->addrLow = putPaddrLow(mp->phys);
+	bpl->tus.f.bdeFlags = 0;
+	bpl->tus.f.bdeSize = size;
+
+	/* The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
+	 * to hold ndlp reference for the corresponding callback function.
+	 */
+	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, retry))
+		return 0;
+
+ vmid_free_all_mem:
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+ vmid_free_bmp_virt_exit:
+	kfree(bmp);
+ vmid_free_bmp_exit:
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+ vmid_free_mp_virt_exit:
+	kfree(mp);
+ vmid_free_mp_exit:
+
+	/* Issue FDMI request failed */
+	lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
+			 "0244 Issue FDMI request failed Data: x%x", cmdcode);
+	return 1;
+}
-- 
2.18.2

