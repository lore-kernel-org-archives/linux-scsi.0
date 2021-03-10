Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A67C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A005664FC9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhCJUC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2512 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhCJUCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406563; x=1646942563;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/STKQypHgTEIW+z8Uo6IGDqC9JFNMPlcrnG0DuRcoQ=;
  b=0giqEInLmj2hZv4bEyzgt4noxmS2RMmVgOz8EgtwMhL1gpDWbtdEqKAf
   +H7LoJRyhfXmyCJOHdKvnTECttLtwh2hXRlzFD6fZ79+lw7VahrbY5tEx
   4ylxzeqfpGmQEyaJIGogmpr3Ei3OxxDXb+Z3VNzCE00JhTgJuqVATLUxD
   4jq4+EFaZoooU0swcuA4KJGdgDPNXInpMorNGBuqedAeHFRLnH9cSgNRA
   STQfIXvsNwmbOOPE6pwjEdGY6W7WZCm9vO0MYw02HuX/mau+Vxdp/Z2v2
   AV8hfsyivy/NU7okcv0/2KJefb1k/E+ISfUg6xfq/MhKa3jNUcDHyXyvn
   Q==;
IronPort-SDR: qVV1PMjxA2dHL3C0WfNQ0wFichZavXjrxjkhxs0fAHdI8fgMKpc/6sLMiHx44yDaGExkUT3Vg5
 2OOMaPEXYPTgcgRTVzwwDV8qJwHjOF/0tfZ5BcCl5bzvmSkzIwzDbGPa0izNTVbKtd5GMv3APp
 qSKlQVqJMU86vSKLiQFy65zbCTkEDbszjzbHDkPU1cy8pp33qfrw1+amsaKD8vHkgC8WMqsdOp
 As5D9GMiu8Ahx3/4g7+pKxlpCy567waRDJe949DVkaf2InK91r2b1TXtJVW4uTtVhmmFq6VDYm
 Fcs=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="109505759"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:42 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:41 -0700
Subject: [PATCH V4 20/31] smartpqi: update raid bypass handling
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:41 -0600
Message-ID: <161540656181.19430.8015829080211904463.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Simplify aio retry management by removing retry list and
list management. Need to retry is already set in the response status.
Also remove the bypass worker thread.

AIO - Accelerated I/O
  I/O requests bypass the RAID engine and go directly to
  either an HBA disk or to a physical component of a RAID
  volume.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    4 -
 drivers/scsi/smartpqi/smartpqi_init.c |  172 ++++-----------------------------
 2 files changed, 19 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index fa1ebeea777d..1b9aa6e9e04c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1347,10 +1347,6 @@ struct pqi_ctrl_info {
 	atomic_t	num_blocked_threads;
 	wait_queue_head_t block_requests_wait;
 
-	struct list_head raid_bypass_retry_list;
-	spinlock_t	raid_bypass_retry_list_lock;
-	struct work_struct raid_bypass_retry_work;
-
 	struct pqi_ofa_memory *pqi_ofa_mem_virt_addr;
 	dma_addr_t	pqi_ofa_mem_dma_handle;
 	void		**pqi_ofa_chunk_virt_addr;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7d0ab509c2c5..48761cb340c9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5280,12 +5280,6 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		device, scmd, queue_group);
 }
 
-static inline void pqi_schedule_bypass_retry(struct pqi_ctrl_info *ctrl_info)
-{
-	if (!pqi_ctrl_blocked(ctrl_info))
-		schedule_work(&ctrl_info->raid_bypass_retry_work);
-}
-
 static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 {
 	struct scsi_cmnd *scmd;
@@ -5302,7 +5296,7 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 		return false;
 
 	device = scmd->device->hostdata;
-	if (pqi_device_offline(device))
+	if (pqi_device_offline(device) || pqi_device_in_remove(device))
 		return false;
 
 	ctrl_info = shost_to_hba(scmd->device->host);
@@ -5312,132 +5306,6 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 	return true;
 }
 
-static inline void pqi_add_to_raid_bypass_retry_list(
-	struct pqi_ctrl_info *ctrl_info,
-	struct pqi_io_request *io_request, bool at_head)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctrl_info->raid_bypass_retry_list_lock, flags);
-	if (at_head)
-		list_add(&io_request->request_list_entry,
-			&ctrl_info->raid_bypass_retry_list);
-	else
-		list_add_tail(&io_request->request_list_entry,
-			&ctrl_info->raid_bypass_retry_list);
-	spin_unlock_irqrestore(&ctrl_info->raid_bypass_retry_list_lock, flags);
-}
-
-static void pqi_queued_raid_bypass_complete(struct pqi_io_request *io_request,
-	void *context)
-{
-	struct scsi_cmnd *scmd;
-
-	scmd = io_request->scmd;
-	pqi_free_io_request(io_request);
-	pqi_scsi_done(scmd);
-}
-
-static void pqi_queue_raid_bypass_retry(struct pqi_io_request *io_request)
-{
-	struct scsi_cmnd *scmd;
-	struct pqi_ctrl_info *ctrl_info;
-
-	io_request->io_complete_callback = pqi_queued_raid_bypass_complete;
-	scmd = io_request->scmd;
-	scmd->result = 0;
-	ctrl_info = shost_to_hba(scmd->device->host);
-
-	pqi_add_to_raid_bypass_retry_list(ctrl_info, io_request, false);
-	pqi_schedule_bypass_retry(ctrl_info);
-}
-
-static int pqi_retry_raid_bypass(struct pqi_io_request *io_request)
-{
-	struct scsi_cmnd *scmd;
-	struct pqi_scsi_dev *device;
-	struct pqi_ctrl_info *ctrl_info;
-	struct pqi_queue_group *queue_group;
-
-	scmd = io_request->scmd;
-	device = scmd->device->hostdata;
-	if (pqi_device_in_reset(device)) {
-		pqi_free_io_request(io_request);
-		set_host_byte(scmd, DID_RESET);
-		pqi_scsi_done(scmd);
-		return 0;
-	}
-
-	ctrl_info = shost_to_hba(scmd->device->host);
-	queue_group = io_request->queue_group;
-
-	pqi_reinit_io_request(io_request);
-
-	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
-		device, scmd, queue_group);
-}
-
-static inline struct pqi_io_request *pqi_next_queued_raid_bypass_request(
-	struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned long flags;
-	struct pqi_io_request *io_request;
-
-	spin_lock_irqsave(&ctrl_info->raid_bypass_retry_list_lock, flags);
-	io_request = list_first_entry_or_null(
-		&ctrl_info->raid_bypass_retry_list,
-		struct pqi_io_request, request_list_entry);
-	if (io_request)
-		list_del(&io_request->request_list_entry);
-	spin_unlock_irqrestore(&ctrl_info->raid_bypass_retry_list_lock, flags);
-
-	return io_request;
-}
-
-static void pqi_retry_raid_bypass_requests(struct pqi_ctrl_info *ctrl_info)
-{
-	int rc;
-	struct pqi_io_request *io_request;
-
-	pqi_ctrl_busy(ctrl_info);
-
-	while (1) {
-		if (pqi_ctrl_blocked(ctrl_info))
-			break;
-		io_request = pqi_next_queued_raid_bypass_request(ctrl_info);
-		if (!io_request)
-			break;
-		rc = pqi_retry_raid_bypass(io_request);
-		if (rc) {
-			pqi_add_to_raid_bypass_retry_list(ctrl_info, io_request,
-				true);
-			pqi_schedule_bypass_retry(ctrl_info);
-			break;
-		}
-	}
-
-	pqi_ctrl_unbusy(ctrl_info);
-}
-
-static void pqi_raid_bypass_retry_worker(struct work_struct *work)
-{
-	struct pqi_ctrl_info *ctrl_info;
-
-	ctrl_info = container_of(work, struct pqi_ctrl_info,
-		raid_bypass_retry_work);
-	pqi_retry_raid_bypass_requests(ctrl_info);
-}
-
-static void pqi_clear_all_queued_raid_bypass_retries(
-	struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctrl_info->raid_bypass_retry_list_lock, flags);
-	INIT_LIST_HEAD(&ctrl_info->raid_bypass_retry_list);
-	spin_unlock_irqrestore(&ctrl_info->raid_bypass_retry_list_lock, flags);
-}
-
 static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	void *context)
 {
@@ -5445,12 +5313,11 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 
 	scmd = io_request->scmd;
 	scsi_dma_unmap(scmd);
-	if (io_request->status == -EAGAIN)
+	if (io_request->status == -EAGAIN || pqi_raid_bypass_retry_needed(io_request)) {
 		set_host_byte(scmd, DID_IMM_RETRY);
-	else if (pqi_raid_bypass_retry_needed(io_request)) {
-		pqi_queue_raid_bypass_retry(io_request);
-		return;
+		scmd->SCp.this_residual++;
 	}
+
 	pqi_free_io_request(io_request);
 	pqi_scsi_done(scmd);
 }
@@ -5667,6 +5534,14 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 	return hw_queue;
 }
 
+static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
+{
+	if (blk_rq_is_passthrough(scmd->request))
+		return false;
+
+	return scmd->SCp.this_residual == 0;
+}
+
 /*
  * This function gets called just before we hand the completed SCSI request
  * back to the SML.
@@ -5792,9 +5667,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 		return 0;
 	}
 
-	pqi_ctrl_busy(ctrl_info);
-	if (pqi_ctrl_blocked(ctrl_info) || pqi_device_in_reset(device) ||
-	    pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info)) {
+	if (pqi_ctrl_blocked(ctrl_info)) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -5811,13 +5684,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	if (pqi_is_logical_device(device)) {
 		raid_bypassed = false;
 		if (device->raid_bypass_enabled &&
-			!blk_rq_is_passthrough(scmd->request)) {
-			if (!pqi_is_parity_write_stream(ctrl_info, scmd)) {
-				rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
-				if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
-					raid_bypassed = true;
-					atomic_inc(&device->raid_bypass_cnt);
-				}
+			pqi_is_bypass_eligible_request(scmd) &&
+			!pqi_is_parity_write_stream(ctrl_info, scmd)) {
+			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
+			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
+				raid_bypassed = true;
+				atomic_inc(&device->raid_bypass_cnt);
 			}
 		}
 		if (!raid_bypassed)
@@ -8255,11 +8127,6 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 		PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
 	init_waitqueue_head(&ctrl_info->block_requests_wait);
 
-	INIT_LIST_HEAD(&ctrl_info->raid_bypass_retry_list);
-	spin_lock_init(&ctrl_info->raid_bypass_retry_list_lock);
-	INIT_WORK(&ctrl_info->raid_bypass_retry_work,
-		pqi_raid_bypass_retry_worker);
-
 	ctrl_info->ctrl_id = atomic_inc_return(&pqi_controller_count) - 1;
 	ctrl_info->irq_mode = IRQ_MODE_NONE;
 	ctrl_info->max_msix_vectors = PQI_MAX_MSIX_VECTORS;
@@ -8585,7 +8452,6 @@ static void pqi_take_ctrl_offline_deferred(struct pqi_ctrl_info *ctrl_info)
 	pqi_cancel_update_time_worker(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_all_outstanding_requests(ctrl_info);
-	pqi_clear_all_queued_raid_bypass_retries(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
 }
 

