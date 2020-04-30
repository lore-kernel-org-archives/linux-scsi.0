Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4836C83012
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E12A2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgD3NUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:60864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgD3NUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50D7EAF33;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 17/41] megaraid_sas: kill this_id and init_id
Date:   Thu, 30 Apr 2020 15:18:40 +0200
Message-Id: <20200430131904.5847-18-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  2 --
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++-------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 83d8c4cb1ad5..d295a2036588 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2323,7 +2323,6 @@ struct megasas_instance {
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
-	s8 init_id;
 
 	u16 max_num_sge;
 	u16 max_fw_cmds;
@@ -2359,7 +2358,6 @@ struct megasas_instance {
 	wait_queue_head_t abort_cmd_wait_q;
 
 	struct pci_dev *pdev;
-	u32 unique_id;
 	u32 fw_support_ieee;
 	u32 threshold_reply_count;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index fb9c3ceed508..949ae49a6967 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3425,6 +3425,7 @@ static struct scsi_host_template megasas_template = {
 	.bios_param = megasas_bios_param,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
+	.this_id = -1,
 };
 
 /**
@@ -5494,9 +5495,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		goto fail_fw_init;
 
 	if (megasas_get_ctrl_info(instance)) {
-		dev_err(&instance->pdev->dev, "(%d): Could get controller info "
-			"Fail from %s %d\n", instance->unique_id,
-			__func__, __LINE__);
+		dev_err(&instance->pdev->dev, "Couldn't get controller info\n");
 		goto fail_fw_init;
 	}
 
@@ -6758,9 +6757,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	/*
 	 * Export parameters required by SCSI mid-layer
 	 */
-	host->unique_id = instance->unique_id;
 	host->can_queue = instance->max_scsi_cmds;
-	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
 
 	if (instance->fw_support_ieee)
@@ -7346,8 +7343,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	 */
 	instance->pdev = pdev;
 	instance->host = host;
-	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
-	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
+	host->unique_id = pdev->bus->number << 8 | pdev->devfn;
 
 	megasas_set_adapter_type(instance);
 
-- 
2.16.4

