Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB08C54FCE
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5C12072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6UPl5ya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCVSNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:17 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55660 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVSNR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:17 -0400
Received: by mail-pj1-f68.google.com with SMTP id mj6so5020967pjb.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kgVDrqtGxfNR5jwu86FIHr01k+E4XTF8N1pM+jwVmCg=;
        b=S6UPl5yapwC0hf3y2i+Pjo+5I4d6R3RBi34ZV0/NKaP9w7C2gfDc+3xUbrPlz/2LO0
         ewG5+d33wE2k1k6q3VubZtpl7DJVADr0rxVqLggJ3mUsqWLuDfV0EtTvlPh8EUDl90DY
         /L1OQygu6FY1Vhf0lRquNSdBS9xKqngMa3gsI5idQY4xB+T7Q7b3CwambLSVpKgpn/jl
         mtKlikxeYR5oravgGTidVX9DJrLvX1iDS7ZvDP+blYmXuIbxC1lKeY8IJnDi3hodGtOd
         7VVfq5M/UP2RiQTYsi549cX1X3qOhs0+4Eoo5qOlie68fs3w3DXUqCkj5PyFsoKmhUWu
         PObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kgVDrqtGxfNR5jwu86FIHr01k+E4XTF8N1pM+jwVmCg=;
        b=iKlwzVaAFhqpadHEgRUfWqXjPBpsQe36SpLk3j5EoHES6JFX/CXlgKKRbJcOo9mIqC
         2CStfe1A/ebTkqj5Bjpbdh0XcpGaSBkHmhEUX/ovMG+LBT0t3lHuJqnyn0cA0CSFxEa7
         c15uArk55NfYjhQ8Zz0OMEYsfvdpNMC3PRgMW6Fwe1VgZ5WU01M9Xvuf/zf5z8u7fb21
         RrIf3U3GniUT4UBVuEUwVxV/DHEXCWhVviao/asGmU6HlqreAI2/65dSYtMXGYg+srCS
         W6f2J6AQksNCyNw+kb1LrzAXuRfk6nzxGFbibC/gg6VEPhFm+TMLax4LrHvmHJFii8e4
         wHXQ==
X-Gm-Message-State: ANhLgQ3DIKrJyOX7YlzRvkTxY5qk47OweUklpuN4Wuklzmn8OgZc7c7n
        Cvj4/kvvV+/tUVGO9/rz9UYbgxbm
X-Google-Smtp-Source: ADFU+vvOKatXxc5jmRL5hBDmvoZAKG5dTqG4BIxnwg0Xjb7X0Nh9sz6qwq2z8AUYC2nGHV3gekxZQA==
X-Received: by 2002:a17:902:8b87:: with SMTP id ay7mr18702675plb.2.1584900795732;
        Sun, 22 Mar 2020 11:13:15 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/12] lpfc: Fix scsi host template for SLI3 vports
Date:   Sun, 22 Mar 2020 11:12:56 -0700
Message-Id: <20200322181304.37655-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI layer sends driver IOs with more s/g segments than driver can
handle.  This results in "Too many sg segments from dma_map_sg. Config
64, seg_cnt 219" error messages from the lpfc_scsi_prep_dma_buf_s3()
routine.

The was due to use the driver using individual templates for pport and
vport, host reset enabled or not, nvme vs scsi, etc. In the end, there
was a combination for a vport that didn't match the pport.

Rather than enumerating more templates and more discretionary
assignments, revert to a base template that is copied to a template
specific to the pport/vport. Then, based on role, attributes and sli
type, modify the fields that are different for that port.  Added a log
message to lpfc_create_port to validate values.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  5 +++
 drivers/scsi/lpfc/lpfc_crtn.h |  2 --
 drivers/scsi/lpfc/lpfc_init.c | 73 +++++++++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_scsi.c | 48 ----------------------------
 4 files changed, 54 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 357fdec06bae..e940a49f9f02 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1225,6 +1225,11 @@ struct lpfc_hba {
 #define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
 
 	char os_host_name[MAXHOSTNAMELEN];
+
+	/* SCSI host template information - for physical port */
+	struct scsi_host_template port_template;
+	/* SCSI host template information - for all vports */
+	struct scsi_host_template vport_template;
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index a450477a7e00..a0ef3bac0612 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -404,9 +404,7 @@ void lpfc_free_sysfs_attr(struct lpfc_vport *);
 extern struct device_attribute *lpfc_hba_attrs[];
 extern struct device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
-extern struct scsi_host_template lpfc_template_no_hr;
 extern struct scsi_host_template lpfc_template_nvme;
-extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6eb3112a45a2..1dadf247a0aa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4231,6 +4231,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
 	struct lpfc_vport *vport;
 	struct Scsi_Host  *shost = NULL;
+	struct scsi_host_template *template;
 	int error = 0;
 	int i;
 	uint64_t wwn;
@@ -4259,22 +4260,50 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 		}
 	}
 
-	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
-		if (dev != &phba->pcidev->dev) {
-			shost = scsi_host_alloc(&lpfc_vport_template,
-						sizeof(struct lpfc_vport));
+	/* Seed template for SCSI host registration */
+	if (dev == &phba->pcidev->dev) {
+		template = &phba->port_template;
+
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+			/* Seed physical port template */
+			memcpy(template, &lpfc_template, sizeof(*template));
+
+			if (use_no_reset_hba) {
+				/* template is for a no reset SCSI Host */
+				template->max_sectors = 0xffff;
+				template->eh_host_reset_handler = NULL;
+			}
+
+			/* Template for all vports this physical port creates */
+			memcpy(&phba->vport_template, &lpfc_template,
+			       sizeof(*template));
+			phba->vport_template.max_sectors = 0xffff;
+			phba->vport_template.shost_attrs = lpfc_vport_attrs;
+			phba->vport_template.eh_bus_reset_handler = NULL;
+			phba->vport_template.eh_host_reset_handler = NULL;
+			phba->vport_template.vendor_id = 0;
+
+			/* Initialize the host templates with updated value */
+			if (phba->sli_rev == LPFC_SLI_REV4) {
+				template->sg_tablesize = phba->cfg_scsi_seg_cnt;
+				phba->vport_template.sg_tablesize =
+					phba->cfg_scsi_seg_cnt;
+			} else {
+				template->sg_tablesize = phba->cfg_sg_seg_cnt;
+				phba->vport_template.sg_tablesize =
+					phba->cfg_sg_seg_cnt;
+			}
+
 		} else {
-			if (!use_no_reset_hba)
-				shost = scsi_host_alloc(&lpfc_template,
-						sizeof(struct lpfc_vport));
-			else
-				shost = scsi_host_alloc(&lpfc_template_no_hr,
-						sizeof(struct lpfc_vport));
+			/* NVMET is for physical port only */
+			memcpy(template, &lpfc_template_nvme,
+			       sizeof(*template));
 		}
-	} else if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
-		shost = scsi_host_alloc(&lpfc_template_nvme,
-					sizeof(struct lpfc_vport));
+	} else {
+		template = &phba->vport_template;
 	}
+
+	shost = scsi_host_alloc(template, sizeof(struct lpfc_vport));
 	if (!shost)
 		goto out;
 
@@ -4329,6 +4358,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 		vport->port_type = LPFC_PHYSICAL_PORT;
 	}
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_FCP,
+			"9081 CreatePort TMPLATE type %x TBLsize %d "
+			"SEGcnt %d/%d\n",
+			vport->port_type, shost->sg_tablesize,
+			phba->cfg_scsi_seg_cnt, phba->cfg_sg_seg_cnt);
+
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
@@ -6301,11 +6336,6 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
 	 */
 
-	/* Initialize the host templates the configured values. */
-	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template_no_hr.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		entry_sz = sizeof(struct sli4_sge);
 	else
@@ -6346,7 +6376,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_FCP,
-			"9088 sg_tablesize:%d dmabuf_size:%d total_bde:%d\n",
+			"9088 INIT sg_tablesize:%d dmabuf_size:%d total_bde:%d\n",
 			phba->cfg_sg_seg_cnt, phba->cfg_sg_dma_buf_size,
 			phba->cfg_total_seg_cnt);
 
@@ -6816,11 +6846,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_nvme_seg_cnt = phba->cfg_sg_seg_cnt;
 	}
 
-	/* Initialize the host templates with the updated values. */
-	lpfc_vport_template.sg_tablesize = phba->cfg_scsi_seg_cnt;
-	lpfc_template.sg_tablesize = phba->cfg_scsi_seg_cnt;
-	lpfc_template_no_hr.sg_tablesize = phba->cfg_scsi_seg_cnt;
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_FCP,
 			"9087 sg_seg_cnt:%d dmabuf_size:%d "
 			"total:%d scsi:%d nvme:%d\n",
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fc9a242bc65..be62795715f7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6023,31 +6023,6 @@ struct scsi_host_template lpfc_template_nvme = {
 	.track_queue_depth	= 0,
 };
 
-struct scsi_host_template lpfc_template_no_hr = {
-	.module			= THIS_MODULE,
-	.name			= LPFC_DRIVER_NAME,
-	.proc_name		= LPFC_DRIVER_NAME,
-	.info			= lpfc_info,
-	.queuecommand		= lpfc_queuecommand,
-	.eh_timed_out		= fc_eh_timed_out,
-	.eh_abort_handler	= lpfc_abort_handler,
-	.eh_device_reset_handler = lpfc_device_reset_handler,
-	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
-	.slave_alloc		= lpfc_slave_alloc,
-	.slave_configure	= lpfc_slave_configure,
-	.slave_destroy		= lpfc_slave_destroy,
-	.scan_finished		= lpfc_scan_finished,
-	.this_id		= -1,
-	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
-	.cmd_per_lun		= LPFC_CMD_PER_LUN,
-	.shost_attrs		= lpfc_hba_attrs,
-	.max_sectors		= 0xFFFFFFFF,
-	.vendor_id		= LPFC_NL_VENDOR_ID,
-	.change_queue_depth	= scsi_change_queue_depth,
-	.track_queue_depth	= 1,
-};
-
 struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
@@ -6073,26 +6048,3 @@ struct scsi_host_template lpfc_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
 };
-
-struct scsi_host_template lpfc_vport_template = {
-	.module			= THIS_MODULE,
-	.name			= LPFC_DRIVER_NAME,
-	.proc_name		= LPFC_DRIVER_NAME,
-	.info			= lpfc_info,
-	.queuecommand		= lpfc_queuecommand,
-	.eh_timed_out		= fc_eh_timed_out,
-	.eh_abort_handler	= lpfc_abort_handler,
-	.eh_device_reset_handler = lpfc_device_reset_handler,
-	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.slave_alloc		= lpfc_slave_alloc,
-	.slave_configure	= lpfc_slave_configure,
-	.slave_destroy		= lpfc_slave_destroy,
-	.scan_finished		= lpfc_scan_finished,
-	.this_id		= -1,
-	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
-	.cmd_per_lun		= LPFC_CMD_PER_LUN,
-	.shost_attrs		= lpfc_vport_attrs,
-	.max_sectors		= 0xFFFF,
-	.change_queue_depth	= scsi_change_queue_depth,
-	.track_queue_depth	= 1,
-};
-- 
2.16.4

