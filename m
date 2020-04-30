Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7DBC8300E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483EC20870
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgD3NUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:60974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbgD3NUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B588CAF72;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 21/41] megaraid_sas: megaraid_sas: reshuffle SCSI host allocation
Date:   Thu, 30 Apr 2020 15:18:44 +0200
Message-Id: <20200430131904.5847-22-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reshuffle SCSI host allocation such that the scsi host device
can be allocated prior to the first command being sent.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 36 ++++++++++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 ++++
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d295a2036588..b47306a66650 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2677,6 +2677,9 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	u8 crash_buf_state);
 void megasas_free_host_crash_buffer(struct megasas_instance *instance);
 
+int megasas_io_attach(struct megasas_instance *instance);
+void megasas_io_detach(struct megasas_instance *instance);
+
 void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd);
 int megasas_issue_blocked_cmd(struct megasas_instance *instance,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00a1d5caf7d5..ddb8df03481f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5468,6 +5468,13 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		goto fail_reply_queue;
 	}
 
+	/*
+	 * Notify the mid-layer about the new controller; do this
+	 * early so that we can allocate internal commands
+	 */
+	if (megasas_io_attach(instance))
+		goto fail_io_attach;
+
 	if (megasas_issue_init_mfi(instance))
 		goto fail_fw_init;
 
@@ -5490,7 +5497,8 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 	return 0;
 
 fail_fw_init:
-
+	megasas_io_detach(instance);
+fail_io_attach:
 	dma_free_coherent(&instance->pdev->dev, reply_q_sz,
 			    instance->reply_queue, instance->reply_queue_h);
 fail_reply_queue:
@@ -6340,6 +6348,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
+	megasas_set_max_sectors(instance);
+
 	/* Check for valid throttlequeuedepth module parameter */
 	if (throttlequeuedepth &&
 			throttlequeuedepth <= instance->max_scsi_cmds)
@@ -6757,7 +6767,7 @@ static int megasas_start_aen(struct megasas_instance *instance)
  * megasas_io_attach -	Attaches this driver to SCSI mid-layer
  * @instance:		Adapter soft state
  */
-static int megasas_io_attach(struct megasas_instance *instance)
+int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
 
@@ -6767,7 +6777,8 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->can_queue = instance->max_scsi_cmds;
 	host->sg_tablesize = instance->max_num_sge;
 
-	megasas_set_max_sectors(instance);
+	/* Will be adjusted later */
+	host->max_sectors = MEGASAS_MAX_SECTORS_IEEE;
 
 	host->cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
@@ -6788,6 +6799,15 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	return 0;
 }
 
+/**
+ * megasas_io_detach -	Detaches this driver from the SCSI mid-layer
+ * @instance:		Adapter soft state
+ */
+void megasas_io_detach(struct megasas_instance *instance)
+{
+	scsi_remove_host(instance->host);
+}
+
 /**
  * megasas_set_dma_mask -	Set DMA mask for supported controllers
  *
@@ -7373,12 +7393,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = instance;
 	megasas_mgmt_info.max_index++;
 
-	/*
-	 * Register with SCSI mid-layer
-	 */
-	if (megasas_io_attach(instance))
-		goto fail_io_attach;
-
 	instance->unload = 0;
 	/*
 	 * Trigger SCSI to scan our drives
@@ -7404,7 +7418,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	return 0;
 
 fail_start_aen:
-fail_io_attach:
 	megasas_mgmt_info.count--;
 	megasas_mgmt_info.max_index--;
 	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
@@ -7802,7 +7815,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->fw_crash_state != UNAVAILABLE)
 		megasas_free_host_crash_buffer(instance);
-	scsi_remove_host(instance->host);
 	instance->unload = 1;
 
 	if (megasas_wait_for_adapter_operational(instance))
@@ -7812,6 +7824,8 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 
 skip_firing_dcmds:
+	megasas_io_detach(instance);
+
 	/* cancel the delayed work if this work still in queue*/
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bec3d4cca74f..483146051957 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1857,6 +1857,9 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	if (megasas_alloc_cmds_fusion(instance))
 		goto fail_alloc_cmds;
 
+	if (megasas_io_attach(instance))
+		goto fail_io_attach;
+
 	if (megasas_ioc_init_fusion(instance)) {
 		status_reg = instance->instancet->read_fw_status_reg(instance);
 		if (((status_reg & MFI_STATE_MASK) == MFI_STATE_FAULT) &&
@@ -1895,6 +1898,8 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	return 0;
 
 fail_ioc_init:
+	megasas_io_detach(instance);
+fail_io_attach:
 	megasas_free_cmds_fusion(instance);
 fail_alloc_cmds:
 	megasas_free_cmds(instance);
-- 
2.16.4

