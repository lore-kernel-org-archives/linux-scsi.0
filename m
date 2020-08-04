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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1B4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC96206DA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dJxz8k3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgHDJHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbgHDJHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:32 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D39C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:32 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h21so23956725qtp.11
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fU1s2plBGtfkevtflW3ply4f5WZDVLmrUNmu2pRbOXw=;
        b=dJxz8k3FAhMIKUQMXKH9bkaPqwwSFh/Ym2lT5xFuEcNVMQjqVgpkIagiobH1P18HiO
         PTh7GejO8FzltwmjIGWEheCPFzZOSeSjFm94qyj+l8ymQhNCWfCTNeO20MbohzXuGQdI
         n/FG6Jqt2ZbQ7d+uYPQnlmKuFerR3eSIcUvVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fU1s2plBGtfkevtflW3ply4f5WZDVLmrUNmu2pRbOXw=;
        b=az6vP1dV2d6GPKo2U2r9MUXHkxH8aHOmzvOVoFmLbYhaMXjWRA7+luGVV8+b0uO4Co
         ZFEFNEWc8TTW59VRKP9VoH1qws8SbS1a3x6hC2AxNxHT/DG1TKbvJGx+eLN2CgLmhlSK
         jYi6AJTEMUwQtNz0cNnDr4+DmG+/amPlSDjQr/5EAcktnfjX39kiytv7kDhUizaUYJIx
         1KrXjuDHoedTJLcgyuoXarQTt2YfURdbAOiL+V6aqkpDpOy/kVqSIrnvLxg+WjgOYDQs
         6TuK5KN65bNpMOJ8AG/4DEHSOCrfbn2yAgV4mZEs6dts5st0RY4BCsvR3S11WLfGHCyp
         cS4g==
X-Gm-Message-State: AOAM533NK4ZQXkLGmW4z9U9bpZtlz44RowFUn4kv4moizOnPsCv8GMtH
        yMTXFKfGVaniolSliDIIE+2+jw==
X-Google-Smtp-Source: ABdhPJwsgxyh5SKUL2/9BfdUwkyCOaHeglh8/s7zzAXQK1RpXkBWS+3dtSDf/hqi7E4zJEUO61uJDg==
X-Received: by 2002:ac8:581:: with SMTP id a1mr20338464qth.247.1596532051670;
        Tue, 04 Aug 2020 02:07:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:31 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 08/16] lpfc: vmid: vmid resource allocation
Date:   Tue,  4 Aug 2020 07:43:08 +0530
Message-Id: <1596507196-27417-9-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch allocates the resource for vmid and checks if the firmware
supports the feature or not.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 64 +++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_mbox.c |  6 ++++
 drivers/scsi/lpfc/lpfc_sli.c  |  9 +++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index db768e28d3f9..2936a15f7441 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4284,6 +4284,62 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
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
+u8
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
+			return 1;
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
+			return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
@@ -4439,6 +4495,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
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
@@ -4463,6 +4525,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
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
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8582b51b0613..bf006ec4ceb1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7558,6 +7558,15 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
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
2.18.2

