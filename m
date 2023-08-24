Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB450C7EE2C
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242304AbjHXP44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242333AbjHXP4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C211B199F
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892588; x=1724428588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iWGTv4d2LBreI8cEq7C5MqJuPDFU+qTApIYX/lRKqiA=;
  b=YwX/sT/0pRL6DZmnoRoV0kgGfniYvZr6VCO/fs4Lqytttggu3x8nJGmP
   A/EImOlD9lRuamYVid8czvf5EFDB98ZlGC9NPF4EGXkoU/yPWLUY9SlcZ
   xKH2GWJ9ClmF+88igDOrxxM/sFPVeZ5kuRz+uek8gtYIGeduquWmfSkqa
   mscH3/0IFL0DsqV0su7y5p1CsXo/tTK3MDOFvIfhzdQ/4JYYtrEDIVse9
   t1eiW0fLtjd+0ONWNkWdivo+4c9UhdYBnDv7JCKpOmIMrHYfgDCmzhVUb
   fIQ8PqOz7on4m+I+jSA20pIdtiyM5/TQWEsz1XCAGszD/7y99IpAJx3k+
   g==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1149041"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:11 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:10 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 1/8] smartpqi: add abort handler
Date:   Thu, 24 Aug 2023 10:58:05 -0500
Message-ID: <20230824155812.789913-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Implement aborts as resets.

Avoid I/O stalls across all devices attached to a controller when
device I/O requests time out.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  14 ++-
 drivers/scsi/smartpqi/smartpqi_init.c | 171 ++++++++++++++++++++------
 2 files changed, 149 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e392eaf5b2bf..e560d99efa95 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1085,7 +1085,16 @@ struct pqi_stream_data {
 	u32	last_accessed;
 };
 
-#define PQI_MAX_LUNS_PER_DEVICE         256
+#define PQI_MAX_LUNS_PER_DEVICE		256
+
+struct pqi_tmf_work {
+	struct work_struct work_struct;
+	struct scsi_cmnd *scmd;
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
+	u8	lun;
+	u8	scsi_opcode;
+};
 
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY command */
@@ -1111,6 +1120,7 @@ struct pqi_scsi_dev {
 	u8	erase_in_progress : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
 	bool	in_remove;
+	bool	in_reset[PQI_MAX_LUNS_PER_DEVICE];
 	bool	device_offline;
 	u8	vendor[8];		/* bytes 8-15 of inquiry data */
 	u8	model[16];		/* bytes 16-31 of inquiry data */
@@ -1149,6 +1159,8 @@ struct pqi_scsi_dev {
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
 	unsigned int raid_bypass_cnt;
+
+	struct pqi_tmf_work tmf_work[PQI_MAX_LUNS_PER_DEVICE];
 };
 
 /* VPD inquiry pages */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6aaaa7ebca37..60cdc06ace61 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -48,6 +48,8 @@
 #define PQI_POST_RESET_DELAY_SECS			5
 #define PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS	10
 
+#define PQI_NO_COMPLETION	((void *)-1)
+
 MODULE_AUTHOR("Microchip");
 MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 	DRIVER_VERSION);
@@ -96,6 +98,7 @@ static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, u8 lun, unsigned long timeout_msecs);
 static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info);
+static void pqi_tmf_worker(struct work_struct *work);
 
 /* for flags argument to pqi_submit_raid_request_synchronous() */
 #define PQI_SYNC_FLAGS_INTERRUPTABLE	0x1
@@ -455,6 +458,21 @@ static inline bool pqi_device_in_remove(struct pqi_scsi_dev *device)
 	return device->in_remove;
 }
 
+static inline void pqi_device_reset_start(struct pqi_scsi_dev *device, u8 lun)
+{
+	device->in_reset[lun] = true;
+}
+
+static inline void pqi_device_reset_done(struct pqi_scsi_dev *device, u8 lun)
+{
+	device->in_reset[lun] = false;
+}
+
+static inline bool pqi_device_in_reset(struct pqi_scsi_dev *device, u8 lun)
+{
+	return device->in_reset[lun];
+}
+
 static inline int pqi_event_type_to_event_index(unsigned int event_type)
 {
 	int index;
@@ -2137,6 +2155,15 @@ static inline bool pqi_is_device_added(struct pqi_scsi_dev *device)
 	return device->sdev != NULL;
 }
 
+static inline void pqi_init_device_tmf_work(struct pqi_scsi_dev *device)
+{
+	unsigned int lun;
+	struct pqi_tmf_work *tmf_work;
+
+	for (lun = 0, tmf_work = device->tmf_work; lun < PQI_MAX_LUNS_PER_DEVICE; lun++, tmf_work++)
+		INIT_WORK(&tmf_work->work_struct, pqi_tmf_worker);
+}
+
 static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *new_device_list[], unsigned int num_new_devices)
 {
@@ -2217,6 +2244,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		list_add_tail(&device->add_list_entry, &add_list);
 		/* To prevent this device structure from being freed later. */
 		device->keep_device = true;
+		pqi_init_device_tmf_work(device);
 	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
@@ -5850,6 +5878,7 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 {
 	struct pqi_scsi_dev *device;
+	struct completion *wait;
 
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5863,6 +5892,10 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 	}
 
 	atomic_dec(&device->scsi_cmds_outstanding[scmd->device->lun]);
+
+	wait = (struct completion *)xchg(&scmd->host_scribble, NULL);
+	if (wait != PQI_NO_COMPLETION)
+		complete(wait);
 }
 
 static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
@@ -5948,6 +5981,9 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	u16 hw_queue;
 	struct pqi_queue_group *queue_group;
 	bool raid_bypassed;
+	u8 lun;
+
+	scmd->host_scribble = PQI_NO_COMPLETION;
 
 	device = scmd->device->hostdata;
 
@@ -5957,7 +5993,9 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 		return 0;
 	}
 
-	atomic_inc(&device->scsi_cmds_outstanding[scmd->device->lun]);
+	lun = (u8)scmd->device->lun;
+
+	atomic_inc(&device->scsi_cmds_outstanding[lun]);
 
 	ctrl_info = shost_to_hba(shost);
 
@@ -5967,7 +6005,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 		return 0;
 	}
 
-	if (pqi_ctrl_blocked(ctrl_info)) {
+	if (pqi_ctrl_blocked(ctrl_info) || pqi_device_in_reset(device, lun)) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -6002,8 +6040,10 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	if (rc)
-		atomic_dec(&device->scsi_cmds_outstanding[scmd->device->lun]);
+	if (rc) {
+		scmd->host_scribble = NULL;
+		atomic_dec(&device->scsi_cmds_outstanding[lun]);
+	}
 
 	return rc;
 }
@@ -6097,7 +6137,7 @@ static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
 }
 
 static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+	struct pqi_scsi_dev *device, u8 lun)
 {
 	unsigned int i;
 	unsigned int path;
@@ -6127,6 +6167,9 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 				if (scsi_device != device)
 					continue;
 
+				if ((u8)scmd->device->lun != lun)
+					continue;
+
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
 				pqi_free_io_request(io_request);
@@ -6224,15 +6267,13 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 
 #define PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS	30
 
-static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
+static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun)
 {
 	int rc;
 	struct pqi_io_request *io_request;
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct pqi_task_management_request *request;
-	struct pqi_scsi_dev *device;
 
-	device = scmd->device->hostdata;
 	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
@@ -6247,7 +6288,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 	memcpy(request->lun_number, device->scsi3addr,
 		sizeof(request->lun_number));
 	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
-		request->ml_device_lun_number = (u8)scmd->device->lun;
+		request->ml_device_lun_number = lun;
 	request->task_management_function = SOP_TASK_MANAGEMENT_LUN_RESET;
 	if (ctrl_info->tmf_iu_timeout_supported)
 		put_unaligned_le16(PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS, &request->timeout);
@@ -6255,7 +6296,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
-	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, (u8)scmd->device->lun, &wait);
+	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, lun, &wait);
 	if (rc == 0)
 		rc = io_request->status;
 
@@ -6269,18 +6310,16 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS		(10 * 60 * 1000)
 #define PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS	(2 * 60 * 1000)
 
-static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
+static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun)
 {
 	int reset_rc;
 	int wait_rc;
 	unsigned int retries;
 	unsigned long timeout_msecs;
-	struct pqi_scsi_dev *device;
 
-	device = scmd->device->hostdata;
 	for (retries = 0;;) {
-		reset_rc = pqi_lun_reset(ctrl_info, scmd);
-		if (reset_rc == 0 || reset_rc == -ENODEV || ++retries > PQI_LUN_RESET_RETRIES)
+		reset_rc = pqi_lun_reset(ctrl_info, device, lun);
+		if (reset_rc == 0 || reset_rc == -ENODEV || reset_rc == -ENXIO || ++retries > PQI_LUN_RESET_RETRIES)
 			break;
 		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
 	}
@@ -6288,60 +6327,53 @@ static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct sc
 	timeout_msecs = reset_rc ? PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS :
 		PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS;
 
-	wait_rc = pqi_device_wait_for_pending_io(ctrl_info, device, scmd->device->lun, timeout_msecs);
+	wait_rc = pqi_device_wait_for_pending_io(ctrl_info, device, lun, timeout_msecs);
 	if (wait_rc && reset_rc == 0)
 		reset_rc = wait_rc;
 
 	return reset_rc == 0 ? SUCCESS : FAILED;
 }
 
-static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
+static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun)
 {
 	int rc;
-	struct pqi_scsi_dev *device;
 
-	device = scmd->device->hostdata;
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
-	pqi_fail_io_queued_for_device(ctrl_info, device);
+	pqi_fail_io_queued_for_device(ctrl_info, device, lun);
 	rc = pqi_wait_until_inbound_queues_empty(ctrl_info);
+	pqi_device_reset_start(device, lun);
+	pqi_ctrl_unblock_requests(ctrl_info);
 	if (rc)
 		rc = FAILED;
 	else
-		rc = pqi_lun_reset_with_retries(ctrl_info, scmd);
-	pqi_ctrl_unblock_requests(ctrl_info);
+		rc = pqi_lun_reset_with_retries(ctrl_info, device, lun);
+	pqi_device_reset_done(device, lun);
 
 	return rc;
 }
 
-static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
+static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun, struct scsi_cmnd *scmd, u8 scsi_opcode)
 {
 	int rc;
-	struct Scsi_Host *shost;
-	struct pqi_ctrl_info *ctrl_info;
-	struct pqi_scsi_dev *device;
-
-	shost = scmd->device->host;
-	ctrl_info = shost_to_hba(shost);
-	device = scmd->device->hostdata;
 
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
-		shost->host_no,
-		device->bus, device->target, (u32)scmd->device->lun,
+		ctrl_info->scsi_host->host_no,
+		device->bus, device->target, lun,
 		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
 		rc = FAILED;
 	else
-		rc = pqi_device_reset(ctrl_info, scmd);
+		rc = pqi_device_reset(ctrl_info, device, lun);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"reset of scsi %d:%d:%d:%d: %s\n",
-		shost->host_no, device->bus, device->target, (u32)scmd->device->lun,
+		"reset of scsi %d:%d:%d:%u: %s\n",
+		ctrl_info->scsi_host->host_no, device->bus, device->target, lun,
 		rc == SUCCESS ? "SUCCESS" : "FAILED");
 
 	mutex_unlock(&ctrl_info->lun_reset_mutex);
@@ -6349,6 +6381,74 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	return rc;
 }
 
+static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
+	u8 scsi_opcode;
+
+	shost = scmd->device->host;
+	ctrl_info = shost_to_hba(shost);
+	device = scmd->device->hostdata;
+	scsi_opcode = scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff;
+
+	return pqi_device_reset_handler(ctrl_info, device, (u8)scmd->device->lun, scmd, scsi_opcode);
+}
+
+static void pqi_tmf_worker(struct work_struct *work)
+{
+	struct pqi_tmf_work *tmf_work;
+	struct scsi_cmnd *scmd;
+
+	tmf_work = container_of(work, struct pqi_tmf_work, work_struct);
+	scmd = (struct scsi_cmnd *)xchg(&tmf_work->scmd, NULL);
+
+	pqi_device_reset_handler(tmf_work->ctrl_info, tmf_work->device, tmf_work->lun, scmd, tmf_work->scsi_opcode);
+}
+
+static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
+	struct pqi_tmf_work *tmf_work;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	shost = scmd->device->host;
+	ctrl_info = shost_to_hba(shost);
+
+	dev_err(&ctrl_info->pci_dev->dev,
+		"attempting TASK ABORT on SCSI cmd at %p\n", scmd);
+
+	if (cmpxchg(&scmd->host_scribble, PQI_NO_COMPLETION, (void *)&wait) == NULL) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"SCSI cmd at %p already completed\n", scmd);
+		scmd->result = DID_RESET << 16;
+		goto out;
+	}
+
+	device = scmd->device->hostdata;
+	tmf_work = &device->tmf_work[scmd->device->lun];
+
+	if (cmpxchg(&tmf_work->scmd, NULL, scmd) == NULL) {
+		tmf_work->ctrl_info = ctrl_info;
+		tmf_work->device = device;
+		tmf_work->lun = (u8)scmd->device->lun;
+		tmf_work->scsi_opcode = scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff;
+		schedule_work(&tmf_work->work_struct);
+	}
+
+	wait_for_completion(&wait);
+
+	dev_err(&ctrl_info->pci_dev->dev,
+		"TASK ABORT on SCSI cmd at %p: SUCCESS\n", scmd);
+
+out:
+
+	return SUCCESS;
+}
+
 static int pqi_slave_alloc(struct scsi_device *sdev)
 {
 	struct pqi_scsi_dev *device;
@@ -7362,6 +7462,7 @@ static const struct scsi_host_template pqi_driver_template = {
 	.scan_finished = pqi_scan_finished,
 	.this_id = -1,
 	.eh_device_reset_handler = pqi_eh_device_reset_handler,
+	.eh_abort_handler = pqi_eh_abort_handler,
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
-- 
2.42.0

