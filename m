Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63B2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 09:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiGEJmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 05:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiGEJmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 05:42:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC87DEB8
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 02:42:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 632A320180;
        Tue,  5 Jul 2022 09:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657014130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5xMMK/1FVkAvyx9AM8UOkh6ugka2iKW8S0nH2H/t8Ig=;
        b=uQYSuVnv7n6AMm0CEsMzlkXunQs6lC+jm/NILYN3zZa4bF2jwW/FvJYUYrQbD/TN8wAu3M
        qMgVp7to+XOrdQ8XH5pm1R/2Cpgh55K4rENjJbMLknuUbWZsOBmmp9RCo6TWT1cPnJVKdT
        5i4k7IeeizFkH5dJK4qbmhzIX7HmR1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657014130;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5xMMK/1FVkAvyx9AM8UOkh6ugka2iKW8S0nH2H/t8Ig=;
        b=zHwsyiYx/JDvb4dkPU8t56fwkRRvalbo1ul7DnOx7JDamXly+Wg/Qx4q3ImUaLXILxv3a5
        WZomU3rqiD7hEXDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 585FE2C141;
        Tue,  5 Jul 2022 09:42:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 17828)
        id 45E8F51984D2; Tue,  5 Jul 2022 11:42:10 +0200 (CEST)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        "Dwip N. Banerjee" <dnbanerg@us.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] lpfc: Decouple port_template and vport_template
Date:   Tue,  5 Jul 2022 11:42:03 +0200
Message-Id: <20220705094203.50154-1-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>

The problem here is that the lpfc_hba structure has been freed but the
Scsi_Host's hostt pointer is still pointing to the (v) port template
area inside the freed hba structure - through which the module is
accessed.

Basically we need to ensure that the access to the module structure
(via the host template or otherwise) stays valid even after the HBA
structure is freed (or delay that free).

Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

This patch is in our downstream kernels for a while. I've forward
ported so we also fix the upstream driver for everyone.

@Dwip, I took the liberty to add your SoB, hope this is okay.

Daniel

 drivers/scsi/lpfc/lpfc.h      |  5 -----
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 22 +++++++---------------
 drivers/scsi/lpfc/lpfc_scsi.c | 28 ++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index da9070cdad91..4c72e639fdaf 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1616,11 +1616,6 @@ struct lpfc_hba {
 #define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
 
 	char os_host_name[MAXHOSTNAMELEN];
-
-	/* SCSI host template information - for physical port */
-	struct scsi_host_template port_template;
-	/* SCSI host template information - for all vports */
-	struct scsi_host_template vport_template;
 	atomic_t dbg_log_idx;
 	atomic_t dbg_log_cnt;
 	atomic_t dbg_log_dmping;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b1be0dd0337a..4331b85c2e79 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -456,6 +456,7 @@ extern const struct attribute_group *lpfc_hba_groups[];
 extern const struct attribute_group *lpfc_vport_groups[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_nvme;
+extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 93b94c64518d..4d1e813a94db 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4686,7 +4686,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
 	struct lpfc_vport *vport;
 	struct Scsi_Host  *shost = NULL;
-	struct scsi_host_template *template;
+	struct scsi_host_template *template, *vport_template;
 	int error = 0;
 	int i;
 	uint64_t wwn;
@@ -4718,42 +4718,34 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
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
 
 			/* Template for all vports this physical port creates */
-			memcpy(&phba->vport_template, &lpfc_template,
-			       sizeof(*template));
-			phba->vport_template.shost_groups = lpfc_vport_groups;
-			phba->vport_template.eh_bus_reset_handler = NULL;
-			phba->vport_template.eh_host_reset_handler = NULL;
-			phba->vport_template.vendor_id = 0;
+			vport_template = &lpfc_vport_template;
 
 			/* Initialize the host templates with updated value */
 			if (phba->sli_rev == LPFC_SLI_REV4) {
 				template->sg_tablesize = phba->cfg_scsi_seg_cnt;
-				phba->vport_template.sg_tablesize =
+				vport_template->sg_tablesize =
 					phba->cfg_scsi_seg_cnt;
 			} else {
 				template->sg_tablesize = phba->cfg_sg_seg_cnt;
-				phba->vport_template.sg_tablesize =
+				vport_template->sg_tablesize =
 					phba->cfg_sg_seg_cnt;
 			}
 
 		} else {
 			/* NVMET is for physical port only */
-			memcpy(template, &lpfc_template_nvme,
-			       sizeof(*template));
+			template = &lpfc_template_nvme;
 		}
 	} else {
-		template = &phba->vport_template;
+		template = &lpfc_vport_template;
 	}
 
 	shost = scsi_host_alloc(template, sizeof(struct lpfc_vport));
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d43968203248..5b6368428cb8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6848,3 +6848,31 @@ struct scsi_host_template lpfc_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
 };
+
+/* Template for all vports this physical port creates */
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
+	.eh_host_reset_handler  = NULL,
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
2.29.2

