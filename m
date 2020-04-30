Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF24DC8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84BF2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgD3NUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:60762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgD3NUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 312F3AF28;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 18/41] megaraid_sas: use shost_priv()
Date:   Thu, 30 Apr 2020 15:18:41 +0200
Message-Id: <20200430131904.5847-19-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cleanup code by using shost_priv() instead of directly
referencing the ->hostdata pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 63 +++++++++++--------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 949ae49a6967..b241a0ae9955 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1755,12 +1755,9 @@ megasas_build_and_issue_cmd(struct megasas_instance *instance,
 static int
 megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = shost_priv(shost);
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
-	instance = (struct megasas_instance *)
-	    scmd->device->host->hostdata;
-
 	if (instance->unload == 1) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
@@ -1857,14 +1854,13 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 {
 	u16 pd_index = 0, ld;
 	u32 device_id;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = shost_priv(sdev->host);
 	struct fusion_context *fusion;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
 	struct MR_LD_RAID *raid;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	fusion = instance->ctrl_context;
 	mr_device_priv_data = sdev->hostdata;
 
@@ -1937,7 +1933,7 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
 	struct megasas_instance *instance;
 	u32 mr_nvme_pg_size;
 
-	instance = (struct megasas_instance *)sdev->host->hostdata;
+	instance = shost_priv(sdev->host);
 	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
 
@@ -1961,10 +1957,9 @@ static void megasas_set_fw_assisted_qd(struct scsi_device *sdev,
 	u8 interface_type;
 	u32 device_qd = MEGASAS_DEFAULT_CMD_PER_LUN;
 	u32 tgt_device_qd;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = shost_priv(sdev->host);
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	mr_device_priv_data = sdev->hostdata;
 	interface_type  = mr_device_priv_data->interface_type;
 
@@ -2838,7 +2833,7 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
 	int ret_val;
 	struct megasas_instance *instance;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = shost_priv(scmd->device->host);
 
 	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
 		 scmd->cmnd[0], scmd->retries);
@@ -2875,7 +2870,7 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 		return BLK_EH_DONE;
 	}
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = shost_priv(scmd->device->host);
 	if (!(instance->flag & MEGASAS_FW_BUSY)) {
 		/* FW is busy, throttle IO */
 		spin_lock_irqsave(instance->host->host_lock, flags);
@@ -2942,10 +2937,9 @@ megasas_dump_fusion_io(struct scsi_cmnd *scmd)
 {
 	struct megasas_cmd_fusion *cmd;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = shost_priv(scmd->device->host);
 
 	cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, scmd,
 		    "scmd: (0x%p)  retries: 0x%x  allowed: 0x%x\n",
@@ -3001,9 +2995,7 @@ megasas_dump_sys_regs(void __iomem *reg_set, char *buf)
 static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 {
 	int ret;
-	struct megasas_instance *instance;
-
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	struct megasas_instance *instance = shost_priv(scmd->device->host);
 
 	scmd_printk(KERN_INFO, scmd,
 		"OCR is requested due to IO timeout!!\n");
@@ -3035,9 +3027,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 static int megasas_task_abort(struct scsi_cmnd *scmd)
 {
 	int ret;
-	struct megasas_instance *instance;
-
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	struct megasas_instance *instance = shost_priv(scmd->device->host);
 
 	if (instance->adapter_type != MFI_SERIES)
 		ret = megasas_task_abort_fusion(scmd);
@@ -3057,9 +3047,7 @@ static int megasas_task_abort(struct scsi_cmnd *scmd)
 static int megasas_reset_target(struct scsi_cmnd *scmd)
 {
 	int ret;
-	struct megasas_instance *instance;
-
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	struct megasas_instance *instance = shost_priv(scmd->device->host);
 
 	if (instance->adapter_type != MFI_SERIES)
 		ret = megasas_reset_target_fusion(scmd);
@@ -3173,8 +3161,7 @@ fw_crash_buffer_store(struct device *cdev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-		(struct megasas_instance *) shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 	int val = 0;
 	unsigned long flags;
 
@@ -3192,8 +3179,7 @@ fw_crash_buffer_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-		(struct megasas_instance *) shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 	u32 size;
 	unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
 	unsigned long chunk_left_bytes;
@@ -3237,8 +3223,7 @@ fw_crash_buffer_size_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-		(struct megasas_instance *) shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%ld\n", (unsigned long)
 		((instance->fw_crash_buffer_size) * 1024 * 1024)/PAGE_SIZE);
@@ -3249,8 +3234,7 @@ fw_crash_state_store(struct device *cdev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-		(struct megasas_instance *) shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 	int val = 0;
 	unsigned long flags;
 
@@ -3284,8 +3268,7 @@ fw_crash_state_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-		(struct megasas_instance *) shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", instance->fw_crash_state);
 }
@@ -3302,7 +3285,7 @@ ldio_outstanding_show(struct device *cdev, struct device_attribute *attr,
 	char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&instance->ldio_outstanding));
 }
@@ -3312,7 +3295,7 @@ fw_cmds_outstanding_show(struct device *cdev,
 				 struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&instance->fw_outstanding));
 }
@@ -3322,7 +3305,7 @@ enable_sdev_max_qd_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", instance->enable_sdev_max_qd);
 }
@@ -3332,7 +3315,7 @@ enable_sdev_max_qd_store(struct device *cdev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 	u32 val = 0;
 	bool is_target_prop;
 	int ret_target_prop = DCMD_FAILED;
@@ -3364,8 +3347,7 @@ dump_system_regs_show(struct device *cdev,
 			       struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-			(struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return megasas_dump_sys_regs(instance->reg_set, buf);
 }
@@ -3375,8 +3357,7 @@ raid_map_id_show(struct device *cdev, struct device_attribute *attr,
 			  char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
-	struct megasas_instance *instance =
-			(struct megasas_instance *)shost->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
 	return snprintf(buf, PAGE_SIZE, "%ld\n",
 			(unsigned long)instance->map_id);
@@ -7334,7 +7315,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		goto fail_alloc_instance;
 	}
 
-	instance = (struct megasas_instance *)host->hostdata;
+	instance = shost_priv(host);
 	memset(instance, 0, sizeof(*instance));
 	atomic_set(&instance->fw_reset_no_pci_access, 0);
 
-- 
2.16.4

