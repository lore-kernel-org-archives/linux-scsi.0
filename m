Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904E7C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiDLXgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiDLXcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C6D8CD99
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q3so284540plg.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64/BCqJFZd6ks5SKwOEnA94soxcA/qZP55c28M4pGkg=;
        b=MjdJe3uXg6W/f2xeR1DgSYikg6nccP6Dy0+37+59qUllhw+qplyZYPsJvnnBJidNSx
         t8JJMAUonBbUbxQnIqguojdCOwl4ZPQ/KVUBCRLoJAK6Q3zXkgoU8Y24r2bkhYiP6Wni
         sER9r7lGwhvMRwpx1+6gg8HlyUx15m+YjbcCWxekQlVrkRjFf7rg8W2cCiWkVquNhkHS
         QnPFltW58REwKwbmaZm3z9SRfKwpoMg+C7OfNxe7kbSxTKo24jQfNEUfvOqZgkjoYDBm
         XCKxAcDw2F7yPyw2XNY0IGGT85ESD+9AGOp21FTLdWby+FQuGgtf33z/EOGRWYGSxcsv
         9uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64/BCqJFZd6ks5SKwOEnA94soxcA/qZP55c28M4pGkg=;
        b=GXCShwM8d/xkW9RCLsw1dCeWZj5nTZTgApQ0yhR+aSf2enChoqpkE8UW3Rt0CFMVHu
         or7u+kY7o/jRYeql7fWDWGUX4kjvLGrNQSF1BdRHSeKdGwnLeiiop41GxuPieadOBxD8
         /+NCjzF4QfxyxgTh14iAgWHYCp3aGarKY+DYw6YrQtDNkEARpg9oW7+L49cKSH7CrzCD
         Jy/3+D4oDJx2nBXSO6rdx2QFZ6EGJNvcXvonDhJBkv1jv1N/clQqw4Tgxb9K2l4mwPgd
         hd62MgdPnkqz7TJZqjv3r/YYDKnMod2zYGhfTag1+Bf7IRQUV6q+Y+E/mdVSe20o+EKk
         ECiQ==
X-Gm-Message-State: AOAM5336Smvn6WzGS/vC5+g1GJZWt0nptjCjfsdgDxzQW0JEdxKH9aWB
        ZgOlvVP80iDBlL3OEsM+Poq3ZoBo1QM=
X-Google-Smtp-Source: ABdhPJylCIvEdWQHppKqArQSXNQd1vqWJpa/+x3dsXwNj5zQLoJiw66w5UQv/VxWsRPKI3AK4znf0w==
X-Received: by 2002:a17:903:1105:b0:156:3e9d:bb7b with SMTP id n5-20020a170903110500b001563e9dbb7bmr39192352plh.136.1649802016260;
        Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/26] lpfc: Tweak message log categories for ELS/FDMI/NVME Rescan
Date:   Tue, 12 Apr 2022 15:19:43 -0700
Message-Id: <20220412222008.126521-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several log message categories were updated:
- Enable msg 4623 (Xmit of ECD) to display for ELS logging.
- Change msg 0220 (FDMI cmd failed) to display for ELS logging.
- Change msg 6460 (FDMI RPA failure) to be warning not hard error.
- Change msg 6172 (NVME rescan of DID) to be logged under NVME
  discovery.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c   | 6 +++---
 drivers/scsi/lpfc/lpfc_els.c  | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 4b024aa03c1b..4334bd358c5a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2236,7 +2236,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	cmd =  be16_to_cpu(fdmi_cmd);
 	if (fdmi_rsp == cpu_to_be16(SLI_CT_RESPONSE_FS_RJT)) {
 		/* FDMI rsp failed */
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_ELS,
 				 "0220 FDMI cmd failed FS_RJT Data: x%x", cmd);
 
 		/* Should we fallback to FDMI-2 / FDMI-1 ? */
@@ -2272,9 +2272,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				phba->link_flag &= ~LS_CT_VEN_RPA;
 				if (phba->cmf_active_mode == LPFC_CFG_OFF)
 					return;
-				lpfc_printf_log(phba, KERN_ERR,
+				lpfc_printf_log(phba, KERN_WARNING,
 						LOG_DISCOVERY | LOG_ELS,
-						"6460 VEN FDMI RPA failure\n");
+						"6460 VEN FDMI RPA RJT\n");
 				return;
 			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_PORT_ATTR) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3a445a0fea86..65e884a416a5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4257,7 +4257,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 
 	phba->cgn_sig_freq = lpfc_fabric_cgn_frequency;
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_CGN_MGMT,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 			 "4623 Xmit EDC to remote "
 			 "NPORT x%x reg_sig x%x reg_fpin:x%x\n",
 			 ndlp->nlp_DID, phba->cgn_reg_signal,
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8d26f207ebd2..699b79d4f496 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2466,12 +2466,12 @@ lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (!nrport || !remoteport)
 		goto rescan_exit;
 
-	/* Only rescan if we are an NVME target in the MAPPED state */
+	/* Rescan an NVME target in MAPPED state with DISCOVERY role set */
 	if (remoteport->port_role & FC_PORT_ROLE_NVME_DISCOVERY &&
 	    ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
 		nvme_fc_rescan_remoteport(remoteport);
 
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 				 "6172 NVME rescanned DID x%06x "
 				 "port_state x%x\n",
 				 ndlp->nlp_DID, remoteport->port_state);
-- 
2.26.2

