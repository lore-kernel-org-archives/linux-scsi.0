Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800FBECAAD3
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiIKWPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIKWPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:18 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8B513F7F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:16 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c11so5007144qtw.8
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=x7xGpBRpDYjHU388YPQRii5xQ1gPVLYQpfyRyXO+jd0=;
        b=Cx6j7AnZ8ZFhalhIMjgk40KORgbH9UDj9qk6GXhjg91OdNh6piyDtWJs16mVt/OKH1
         whT1PyC0n+wQaDLLJlKBPGBZ4ytY7YPUvZJDriQt0GkZVDVGEqiQAPoV3UQ+ZBpPLyfN
         B5sw7VTP2B2f1OL6qxc+QuJ6s7VW/MmFn46e4WH7ejVzRunUsFdOJ2JfW18RFErNINDT
         Zs8IRF9TW05dD7vyiNr4AqU82eDSEm8tTGYMvOnneH68nAXG1AKaMrKADMtFsSbW+EIx
         FYVJZ3fMcYHQAZ99FbrbXWBQVbMmOn9WnqcIB7trlgNv39vemKLKgm5+9DwgrAJmz7Ob
         LqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=x7xGpBRpDYjHU388YPQRii5xQ1gPVLYQpfyRyXO+jd0=;
        b=LZBcAmTlarycUItfftR0xhX1upPsh/egHnThHomQJbIU0VstnjsVdTvMP81FKs5h+B
         ox2//+k00+rTG/kZPzllFLjMizN2G2bdYg7k5Q0nO04Qcxc7x9DKeY3EwFxsg77aY1aY
         dCw+zEj9MV7JlMLSwQ2vuDSpV3+l7OyO8Cr5a4EMKg75uvKK1tkkuNOWFD0NYeTZSxGq
         rsk2U0B9GYJNUv2GgiuoTq1B78OEcrRZPxr31u4ucOJHF3Vov/JxjRNwRXvChDyQqpKz
         djaTUSv4DRRtfSmlBtxOW7oR1KnZ41ah2ycvZ7xNxonRMqXpZX5ChJEyhUZSulAPg/vn
         TlEQ==
X-Gm-Message-State: ACgBeo2LI0lBwOjZiiFHYMyq8F2aB+uH/9ou8y19CnhdzTC5FNF+kKCB
        wuzPFZAnL2V7fj4b1mrcdp7xl2YWkwA=
X-Google-Smtp-Source: AA6agR61VxbzTcnz7vxZc1WqohC2/uEKzTsDZ1BdO5c2PbmSR/g07HSHbUH/k1qWl4mgKbhtcv//gg==
X-Received: by 2002:a05:622a:651:b0:35b:b051:875a with SMTP id a17-20020a05622a065100b0035bb051875amr3761930qtb.637.1662934515880;
        Sun, 11 Sep 2022 15:15:15 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        "Dwip N . Banerjee" <dnbanerg@us.ibm.com>,
        Daniel Wagner <dwagner@suse.de>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/13] lpfc: Move scsi_host_template outside dynamically allocated/freed phba
Date:   Sun, 11 Sep 2022 15:14:58 -0700
Message-Id: <20220911221505.117655-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a PCI hotplug capable system, it is possible for scsi_device_put
to happen after lpfc_pci_remove_one is called.  As a result, the
sdev->host->hostt->module dereference is for a previously freed
memory location because the phba structure containing the hostt
template was already freed when lpfc_pci_remove_one returned.

Since the lpfc module is still loaded during power slot disable,
all scsi_host_templates should be declared as part of the global
data segment instead of inside the heap allocated phba structure.
This way the sdev->host->hostt memory area is always valid as long as
the module is loaded regardless if PCI hotplug dynamically allocates
or frees phba structures.

Move all scsi_host_templates in the phba structure to global
variables.  Create a small helper routine to determine appropriate
sg_tablesize during shost allocation.

Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  4 ---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 50 ++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_scsi.c | 27 +++++++++++++++++++
 4 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 5d07418fa4ea..68b3bd70dd52 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1596,10 +1596,6 @@ struct lpfc_hba {
 
 	char os_host_name[MAXHOSTNAMELEN];
 
-	/* SCSI host template information - for physical port */
-	struct scsi_host_template port_template;
-	/* SCSI host template information - for all vports */
-	struct scsi_host_template vport_template;
 	atomic_t dbg_log_idx;
 	atomic_t dbg_log_cnt;
 	atomic_t dbg_log_dmping;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index c8cac90240b9..84880b567dbb 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -462,6 +462,7 @@ extern const struct attribute_group *lpfc_hba_groups[];
 extern const struct attribute_group *lpfc_vport_groups[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_nvme;
+extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 460295b7c9fe..0a4a82f5df5c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4614,6 +4614,17 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 		return rol64(wwn, 32);
 }
 
+static unsigned short lpfc_get_sg_tablesize(struct lpfc_hba *phba)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		if (phba->cfg_xpsgl && !phba->nvmet_support)
+			return LPFC_MAX_SG_TABLESIZE;
+		else
+			return phba->cfg_scsi_seg_cnt;
+	else
+		return phba->cfg_sg_seg_cnt;
+}
+
 /**
  * lpfc_vmid_res_alloc - Allocates resources for VMID
  * @phba: pointer to lpfc hba data structure.
@@ -4716,42 +4727,26 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	/* Seed template for SCSI host registration */
 	if (dev == &phba->pcidev->dev) {
-		template = &phba->port_template;
-
 		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
 			/* Seed physical port template */
-			memcpy(template, &lpfc_template, sizeof(*template));
+			template = &lpfc_template;
 
 			if (use_no_reset_hba)
 				/* template is for a no reset SCSI Host */
 				template->eh_host_reset_handler = NULL;
 
-			/* Template for all vports this physical port creates */
-			memcpy(&phba->vport_template, &lpfc_template,
-			       sizeof(*template));
-			phba->vport_template.shost_groups = lpfc_vport_groups;
-			phba->vport_template.eh_bus_reset_handler = NULL;
-			phba->vport_template.eh_host_reset_handler = NULL;
-			phba->vport_template.vendor_id = 0;
-
-			/* Initialize the host templates with updated value */
-			if (phba->sli_rev == LPFC_SLI_REV4) {
-				template->sg_tablesize = phba->cfg_scsi_seg_cnt;
-				phba->vport_template.sg_tablesize =
-					phba->cfg_scsi_seg_cnt;
-			} else {
-				template->sg_tablesize = phba->cfg_sg_seg_cnt;
-				phba->vport_template.sg_tablesize =
-					phba->cfg_sg_seg_cnt;
-			}
-
+			/* Seed updated value of sg_tablesize */
+			template->sg_tablesize = lpfc_get_sg_tablesize(phba);
 		} else {
 			/* NVMET is for physical port only */
-			memcpy(template, &lpfc_template_nvme,
-			       sizeof(*template));
+			template = &lpfc_template_nvme;
 		}
 	} else {
-		template = &phba->vport_template;
+		/* Seed vport template */
+		template = &lpfc_vport_template;
+
+		/* Seed updated value of sg_tablesize */
+		template->sg_tablesize = lpfc_get_sg_tablesize(phba);
 	}
 
 	shost = scsi_host_alloc(template, sizeof(struct lpfc_vport));
@@ -4784,11 +4779,6 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 		shost->dma_boundary =
 			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
-
-		if (phba->cfg_xpsgl && !phba->nvmet_support)
-			shost->sg_tablesize = LPFC_MAX_SG_TABLESIZE;
-		else
-			shost->sg_tablesize = phba->cfg_scsi_seg_cnt;
 	} else
 		/* SLI-3 has a limited number of hardware queues (3),
 		 * thus there is only one for FCP processing.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c2f53f04e1f7..63fd5bd38ca1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6794,3 +6794,30 @@ struct scsi_host_template lpfc_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
 };
+
+struct scsi_host_template lpfc_vport_template = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
+	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
+	.eh_abort_handler	= lpfc_abort_handler,
+	.eh_device_reset_handler = lpfc_device_reset_handler,
+	.eh_target_reset_handler = lpfc_target_reset_handler,
+	.eh_bus_reset_handler	= NULL,
+	.eh_host_reset_handler	= NULL,
+	.slave_alloc		= lpfc_slave_alloc,
+	.slave_configure	= lpfc_slave_configure,
+	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
+	.this_id		= -1,
+	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
+	.cmd_per_lun		= LPFC_CMD_PER_LUN,
+	.shost_groups		= lpfc_vport_groups,
+	.max_sectors		= 0xFFFFFFFF,
+	.vendor_id		= 0,
+	.change_queue_depth	= scsi_change_queue_depth,
+	.track_queue_depth	= 1,
+};
-- 
2.35.3

