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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3307BC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 07:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF18C23127
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 07:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgLVHGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 02:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgLVHG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 02:06:29 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9607C0619D2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 23:05:43 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g3so6965213plp.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 23:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SX6z+t1WP5LnbLF2U7/IIjHCAdT+IYVjRNk0tn9QneI=;
        b=dpgic7bUf+asU12QPaSlvHBbnX53I7lorQocU1YYQE+aERBdYDEL6VJ1EeaaXKOk7O
         w4QE9Xl3DL7bwv8YdkUZmG4DlxGXlu5kcw92Hzcf1ph1V3T+6DXP5KAlxejSkoqhNRPg
         LNtgMSBYEIXIqv4Nsqd5TfMHl7ohjgT68+22M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=SX6z+t1WP5LnbLF2U7/IIjHCAdT+IYVjRNk0tn9QneI=;
        b=PlVGLLUiGLKgk2kTZ43XbzDQGpJuUlgXKIPXIGugVRPAj5Gu43SOUBCaTBBpZlhxaS
         kHANd3eDx7Tjac8o7bOo1cPF7W9hhBppdk1XEmMGi/7taZ08Ey4pENiMWdb8dPp1VRL2
         Wb9ty367yQ8FpRXGvT//8effVGUMUKV7M/o5okQVdYyEK3QYQ99u6j/hGtCgF2gSKgDR
         8p9EA2UzcM5vZBwsPgynwsaYYGtJ8pG1EYpwiv4V9cmU5w0aslDLrhw1dMgK7p7norcx
         E4q7bOY5zqtjY1zzE3eXYIG1FmBwqeFaVKNyDdbAz0A4r4LaAxWzMHwcwlFLn3Wm96RO
         eRcQ==
MIME-Version: 1.0
X-Gm-Message-State: AOAM530z0VK5bn66fJkW4/azWQmyTCP0jXAtVFB+xSWd/mAguYbVIqzb
        CarfEcQexlQRhjO9SdzDnrg9XROW5bGoWH18s54YnRqK+yPTtS5cebtNPkklN+ugXjm0Nh6TiV9
        c4U9G7jlqXcn8L3VBVAuYeXU=
X-Google-Smtp-Source: ABdhPJxk77lBKK/RtdZ6O+xI0wqcFsfpcsNlBiNjxh5OA2GeFDHIukWwVXRnLpPNoWF432hiWdnW0g==
X-Received: by 2002:a17:90a:e507:: with SMTP id t7mr20870261pjy.26.1608620743119;
        Mon, 21 Dec 2020 23:05:43 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id t9sm12466082pgh.41.2020.12.21.23.05.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 23:05:42 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v6 11/16] lpfc: vmid: Implements CT commands for appid.
Date:   Tue, 22 Dec 2020 05:41:53 +0530
Message-Id: <1608595918-21954-12-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ffbfe805b70833b5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ffbfe805b70833b5
Content-Type: text/plain; charset="US-ASCII"

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

The patch implements CT commands for registering and deregistering the
appid for the application. Also, a small change in decrementing the ndlp
ref counter has been added.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v6:
Added Forward declarations and functions to static

v5:
No change

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
Removed redundant code due to changes since last submit
---
 drivers/scsi/lpfc/lpfc_ct.c | 252 ++++++++++++++++++++++++++++++++++++
 1 file changed, 252 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index dd0b432f7ac5..fc1150e8adc6 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -75,6 +75,9 @@
 
 
 static char *lpfc_release_version = LPFC_DRIVER_VERSION;
+static void
+lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		      struct lpfc_iocbq *rspiocb);
 
 static void
 lpfc_ct_ignore_hbq_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
@@ -3744,3 +3747,252 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 	}
 	return;
 }
+
+static void
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
+	if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
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
+	/* Decrement ndlp reference count to release ndlp reference held
+	 * for the failed command's callback function.
+	 */
+	lpfc_nlp_put(ndlp);
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
+	return FAILURE;
+}
-- 
2.26.2


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000ffbfe805b70833b5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQTQYJKoZIhvcNAQcCoIIQPjCCEDoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2iMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFTzCCBDegAwIBAgIMX/krgFDQUQNyOf+1MA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTA0MDgz
NTI5WhcNMjIwOTA1MDgzNTI5WjCBljELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRowGAYDVQQDExFNdW5l
ZW5kcmEgS3VtYXIgTTErMCkGCSqGSIb3DQEJARYcbXVuZWVuZHJhLmt1bWFyQGJyb2FkY29tLmNv
bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMoadg8/B0JvnQVWQZyfiiEMmDhh0bSq
BIThkSCjIdy7yOV9fBOs6MdrPZgCDeX5rJvOw6PJiWjeQQ9RkTJH6WccvxwXugoyspkG/RfFdUKk
t0/bk1Ml9aUobcee2+cC79gyzwpHUjzEpcsx49FskGIxI+n9wybrDhpurtj8mmc1C1sVzKNoIEwC
/eHrCsDnag9JEGotxVVv0KcLXv7N0CXs03bP8uvocms3+gO1K8dasJkc7noMt/i0/xcZnaABWkgV
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCBO12MUh7MfYkjGn2475t1FOfwVNXskvB5PB8QVdKgKUjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEyMjIwNzA1NDNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAp9wlULykKN5l0swa
UVumLYdEEispEYLjnnLaT1Nv4fKq2OXKZUtGxPOdiysX1j6Lk0b6VNkd3Rv+26PmP0VGbLWCKhr9
K4m0eODfOAC34Lbo5tl8lCcwe/nk26S2ZJkBtEB9a+ymv9/i15tmok8z1jFxq25XcZRWrFypuKDJ
yhdWH2ST/a7HiL+tONAb9vxrVgR4O7o6J4InGqYAyx+yPHe6vrQ4M8lpU2n5Zp0V20wQeYD/og56
N/NMfDhVkBeGq6Yl+hy1zOSNdzHxB0wFWWxPw26+SN0GOdS+LWUnQpPZuABVJbnkj4dVNgzn0DBJ
uocLab2PvhCFwZMtBmpV/g==
--000000000000ffbfe805b70833b5--
