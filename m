Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED616C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63DA64F8F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhCKUR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4091 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhCKURN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493832; x=1647029832;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yc787RcJ/Rv/GkqgQkwHLsORWM0Ah2fPfwej8gsC5AE=;
  b=ERFxXI9H9l2YZcQhNzQ8LpxYe/6hkn9A3tq9/DD7dWNuVINziyxb6ljD
   Aw7J/dxsrE4H4hUWqiyqlt4rkgTTnMHLdZcZG58ShE1Bj1qFsfClbbBMp
   W2i/e6R8H4ZEerJtZjhjbg7y3+ZjZp/GsBHaYPyjwLtTAMFvYwSz7ulN9
   nb/8i9/9l00w6VhLRSZmcOA4uXQ9eT/hvJMDB8OIn3JY2yQFlx0k1T8IZ
   /+OLFkru3kdai8x2MaNp99otT16n0jD9TKG16aLmqRYCerBBDFJs4D6eL
   i4sspbxJlOKHr+EAca8zYglsmi7p4RzRsvcjqORmnX2bDkBVVDPKdFn0H
   A==;
IronPort-SDR: b1XQudDQ4/yxzNQFTD5HGXCBAxKt9zZxZxtrhMU4kvoCoU/CcotRmf5qq8Pz32XIpxMu2p4afZ
 pDLxHTdAf1s65YoQQz/PpuzJaZlilsab9mifHBbZ/sVL5x66QV3Qy5pjZ69vhYaPfohAlaqbmA
 I2m6WfRt11rj7URTCsTkuDudHfqsQJyFXXiyERv/5SnJ1YAQDb4whzxmPhUNRrl5ui+vFOYM+R
 QvKOf+5PIlujsBfkEY7oToqQvnNpYYlYJasxZu8Y0tc8nalUstysiqb94U/vAlMNTCRUJmCW+I
 J6Q=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="106859251"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:56 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:55 -0700
Subject: [PATCH V5 21/31] smartpqi: update ofa management
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:55 -0600
Message-ID: <161549381563.25025.2647205502550052197.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

OFA - Online Firmware Activation.
      Allows users to update firmware without a reboot.

 * Change OFA setup to a worker thread.
 * Delay soft resets.
 * Add in OFA event handler to allow FW to
   initiate OFA.
 * Add in memory allocation to OFA events.
   * Update ofa buffer size calculations.
 * Add in ability to cancel OFA events.
 * Update OFA quiesce/un-quiesce.
 * Prevent Kernel crashes while issuing ioctl during OFA.
 * Returned EBUSY for pass-through IOCTLs throughout
   all stages of OFA.
 * Add in mutex to prevent parallel OFA updates.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   18 +-
 drivers/scsi/smartpqi/smartpqi_init.c |  374 +++++++++++++++++----------------
 2 files changed, 196 insertions(+), 196 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 1b9aa6e9e04c..0b94c755a74c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -511,10 +511,6 @@ struct pqi_vendor_general_response {
 #define PQI_OFA_SIGNATURE		"OFA_QRM"
 #define PQI_OFA_MAX_SG_DESCRIPTORS	64
 
-#define PQI_OFA_MEMORY_DESCRIPTOR_LENGTH \
-	(offsetof(struct pqi_ofa_memory, sg_descriptor) + \
-	(PQI_OFA_MAX_SG_DESCRIPTORS * sizeof(struct pqi_sg_descriptor)))
-
 struct pqi_ofa_memory {
 	__le64	signature;	/* "OFA_QRM" */
 	__le16	version;	/* version of this struct (1 = 1st version) */
@@ -522,7 +518,7 @@ struct pqi_ofa_memory {
 	__le32	bytes_allocated;	/* total allocated memory in bytes */
 	__le16	num_memory_descriptors;
 	u8	reserved1[2];
-	struct pqi_sg_descriptor sg_descriptor[1];
+	struct pqi_sg_descriptor sg_descriptor[PQI_OFA_MAX_SG_DESCRIPTORS];
 };
 
 struct pqi_aio_error_info {
@@ -1075,7 +1071,6 @@ struct pqi_scsi_dev {
 	u8	volume_offline : 1;
 	u8	rescan : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
-	bool	in_reset;
 	bool	in_remove;
 	bool	device_offline;
 	u8	vendor[8];		/* bytes 8-15 of inquiry data */
@@ -1219,8 +1214,6 @@ struct pqi_event {
 	u8	event_type;
 	u16	event_id;
 	u32	additional_event_id;
-	__le32	ofa_bytes_requested;
-	__le16	ofa_cancel_reason;
 };
 
 #define PQI_RESERVED_IO_SLOTS_LUN_RESET			1
@@ -1292,12 +1285,9 @@ struct pqi_ctrl_info {
 
 	struct mutex	scan_mutex;
 	struct mutex	lun_reset_mutex;
-	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
 	bool		scan_blocked;
-	bool		in_ofa;
-	bool		in_shutdown;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
@@ -1347,10 +1337,14 @@ struct pqi_ctrl_info {
 	atomic_t	num_blocked_threads;
 	wait_queue_head_t block_requests_wait;
 
+	struct mutex	ofa_mutex;
 	struct pqi_ofa_memory *pqi_ofa_mem_virt_addr;
 	dma_addr_t	pqi_ofa_mem_dma_handle;
 	void		**pqi_ofa_chunk_virt_addr;
-	atomic_t	sync_cmds_outstanding;
+	struct work_struct ofa_memory_alloc_work;
+	struct work_struct ofa_quiesce_work;
+	u32		ofa_bytes_requested;
+	u16		ofa_cancel_reason;
 };
 
 enum pqi_ctrl_mode {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b44de3e25541..89b6972a21f6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -45,6 +45,9 @@
 
 #define PQI_EXTRA_SGL_MEMORY	(12 * sizeof(struct pqi_sg_descriptor))
 
+#define PQI_POST_RESET_DELAY_SECS			5
+#define PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS	10
+
 MODULE_AUTHOR("Microsemi");
 MODULE_DESCRIPTION("Driver for Microsemi Smart Family Controller version "
 	DRIVER_VERSION);
@@ -76,9 +79,8 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev_raid_map_data *rmd);
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info);
-static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info);
-static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info,
-	u32 bytes_requested);
+static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs);
+static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
@@ -345,24 +347,25 @@ static inline bool pqi_device_offline(struct pqi_scsi_dev *device)
 	return device->device_offline;
 }
 
-static inline bool pqi_device_in_reset(struct pqi_scsi_dev *device)
+static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
 {
-	return device->in_reset;
+	mutex_lock(&ctrl_info->ofa_mutex);
 }
 
-static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
 {
-	ctrl_info->in_ofa = true;
+	mutex_unlock(&ctrl_info->ofa_mutex);
 }
 
-static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_wait_until_ofa_finished(struct pqi_ctrl_info *ctrl_info)
 {
-	ctrl_info->in_ofa = false;
+	mutex_lock(&ctrl_info->ofa_mutex);
+	mutex_unlock(&ctrl_info->ofa_mutex);
 }
 
-static inline bool pqi_ctrl_in_ofa(struct pqi_ctrl_info *ctrl_info)
+static inline bool pqi_ofa_in_progress(struct pqi_ctrl_info *ctrl_info)
 {
-	return ctrl_info->in_ofa;
+	return mutex_is_locked(&ctrl_info->ofa_mutex);
 }
 
 static inline void pqi_device_remove_start(struct pqi_scsi_dev *device)
@@ -375,14 +378,20 @@ static inline bool pqi_device_in_remove(struct pqi_scsi_dev *device)
 	return device->in_remove;
 }
 
-static inline void pqi_ctrl_shutdown_start(struct pqi_ctrl_info *ctrl_info)
+static inline int pqi_event_type_to_event_index(unsigned int event_type)
 {
-	ctrl_info->in_shutdown = true;
+	int index;
+
+	for (index = 0; index < ARRAY_SIZE(pqi_supported_event_types); index++)
+		if (event_type == pqi_supported_event_types[index])
+			return index;
+
+	return -1;
 }
 
-static inline bool pqi_ctrl_in_shutdown(struct pqi_ctrl_info *ctrl_info)
+static inline bool pqi_is_supported_event(unsigned int event_type)
 {
-	return ctrl_info->in_shutdown;
+	return pqi_event_type_to_event_index(event_type) != -1;
 }
 
 static inline void pqi_schedule_rescan_worker_with_delay(struct pqi_ctrl_info *ctrl_info,
@@ -390,8 +399,6 @@ static inline void pqi_schedule_rescan_worker_with_delay(struct pqi_ctrl_info *c
 {
 	if (pqi_ctrl_offline(ctrl_info))
 		return;
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		return;
 
 	schedule_delayed_work(&ctrl_info->rescan_work, delay);
 }
@@ -1982,8 +1989,18 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		pqi_ctrl_ofa_done(ctrl_info);
+	/*
+	 * If OFA is in progress and there are devices that need to be deleted,
+	 * allow any pending reset operations to continue and unblock any SCSI
+	 * requests before removal.
+	 */
+	if (pqi_ofa_in_progress(ctrl_info)) {
+		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry)
+			if (pqi_is_device_added(device))
+				pqi_device_remove_start(device);
+		pqi_ctrl_unblock_device_reset(ctrl_info);
+		pqi_scsi_unblock_requests(ctrl_info);
+	}
 
 	/* Remove all devices that have gone away. */
 	list_for_each_entry_safe(device, next, &delete_list, delete_list_entry) {
@@ -2318,8 +2335,6 @@ static void pqi_scan_start(struct Scsi_Host *shost)
 	struct pqi_ctrl_info *ctrl_info;
 
 	ctrl_info = shost_to_hba(shost);
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		return;
 
 	pqi_scan_scsi_devices(ctrl_info);
 }
@@ -2336,24 +2351,6 @@ static int pqi_scan_finished(struct Scsi_Host *shost,
 	return !mutex_is_locked(&ctrl_info->scan_mutex);
 }
 
-static void pqi_wait_until_scan_finished(struct pqi_ctrl_info *ctrl_info)
-{
-	mutex_lock(&ctrl_info->scan_mutex);
-	mutex_unlock(&ctrl_info->scan_mutex);
-}
-
-static void pqi_wait_until_lun_reset_finished(struct pqi_ctrl_info *ctrl_info)
-{
-	mutex_lock(&ctrl_info->lun_reset_mutex);
-	mutex_unlock(&ctrl_info->lun_reset_mutex);
-}
-
-static void pqi_wait_until_ofa_finished(struct pqi_ctrl_info *ctrl_info)
-{
-	mutex_lock(&ctrl_info->ofa_mutex);
-	mutex_unlock(&ctrl_info->ofa_mutex);
-}
-
 static inline void pqi_set_encryption_info(struct pqi_encryption_info *encryption_info,
 	struct raid_map *raid_map, u64 first_block)
 {
@@ -3320,6 +3317,7 @@ static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
 static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
+	unsigned int delay_secs;
 	enum pqi_soft_reset_status reset_status;
 
 	if (ctrl_info->soft_reset_handshake_supported)
@@ -3327,8 +3325,11 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	else
 		reset_status = RESET_INITIATE_FIRMWARE;
 
+	delay_secs = PQI_POST_RESET_DELAY_SECS;
+
 	switch (reset_status) {
 	case RESET_TIMEDOUT:
+		delay_secs = PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS;
 		fallthrough;
 	case RESET_INITIATE_DRIVER:
 		dev_info(&ctrl_info->pci_dev->dev,
@@ -3338,7 +3339,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	case RESET_INITIATE_FIRMWARE:
 		ctrl_info->pqi_mode_enabled = false;
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
-		rc = pqi_ofa_ctrl_restart(ctrl_info);
+		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
 		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
@@ -3368,43 +3369,74 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	}
 }
 
-static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_event *event)
+static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
 {
-	u16 event_id;
+	struct pqi_ctrl_info *ctrl_info;
 
-	event_id = get_unaligned_le16(&event->event_id);
+	ctrl_info = container_of(work, struct pqi_ctrl_info, ofa_memory_alloc_work);
 
-	mutex_lock(&ctrl_info->ofa_mutex);
+	pqi_ctrl_ofa_start(ctrl_info);
+	pqi_ofa_setup_host_buffer(ctrl_info);
+	pqi_ofa_host_memory_update(ctrl_info);
+}
 
-	if (event_id == PQI_EVENT_OFA_QUIESCE) {
+static void pqi_ofa_quiesce_worker(struct work_struct *work)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_event *event;
+
+	ctrl_info = container_of(work, struct pqi_ctrl_info, ofa_quiesce_work);
+
+	event = &ctrl_info->events[pqi_event_type_to_event_index(PQI_EVENT_TYPE_OFA)];
+
+	pqi_ofa_ctrl_quiesce(ctrl_info);
+	pqi_acknowledge_event(ctrl_info, event);
+	pqi_process_soft_reset(ctrl_info);
+}
+
+static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_event *event)
+{
+	bool ack_event;
+
+	ack_event = true;
+
+	switch (event->event_id) {
+	case PQI_EVENT_OFA_MEMORY_ALLOCATION:
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Received Online Firmware Activation quiesce event for controller %u\n",
-			ctrl_info->ctrl_id);
-		pqi_ofa_ctrl_quiesce(ctrl_info);
-		pqi_acknowledge_event(ctrl_info, event);
-		pqi_process_soft_reset(ctrl_info);
-	} else if (event_id == PQI_EVENT_OFA_MEMORY_ALLOCATION) {
-		pqi_acknowledge_event(ctrl_info, event);
-		pqi_ofa_setup_host_buffer(ctrl_info,
-			le32_to_cpu(event->ofa_bytes_requested));
-		pqi_ofa_host_memory_update(ctrl_info);
-	} else if (event_id == PQI_EVENT_OFA_CANCELED) {
-		pqi_ofa_free_host_buffer(ctrl_info);
-		pqi_acknowledge_event(ctrl_info, event);
+			"received Online Firmware Activation memory allocation request\n");
+		schedule_work(&ctrl_info->ofa_memory_alloc_work);
+		break;
+	case PQI_EVENT_OFA_QUIESCE:
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Online Firmware Activation(%u) cancel reason : %u\n",
-			ctrl_info->ctrl_id, event->ofa_cancel_reason);
+			"received Online Firmware Activation quiesce request\n");
+		schedule_work(&ctrl_info->ofa_quiesce_work);
+		ack_event = false;
+		break;
+	case PQI_EVENT_OFA_CANCELED:
+		dev_info(&ctrl_info->pci_dev->dev,
+			"received Online Firmware Activation cancel request: reason: %u\n",
+			ctrl_info->ofa_cancel_reason);
+		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_ctrl_ofa_done(ctrl_info);
+		break;
+	default:
+		dev_err(&ctrl_info->pci_dev->dev,
+			"received unknown Online Firmware Activation request: event ID: %u\n",
+			event->event_id);
+		break;
 	}
 
-	mutex_unlock(&ctrl_info->ofa_mutex);
+	return ack_event;
 }
 
 static void pqi_event_worker(struct work_struct *work)
 {
 	unsigned int i;
+	bool rescan_needed;
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_event *event;
+	bool ack_event;
 
 	ctrl_info = container_of(work, struct pqi_ctrl_info, event_work);
 
@@ -3413,22 +3445,26 @@ static void pqi_event_worker(struct work_struct *work)
 	if (pqi_ctrl_offline(ctrl_info))
 		goto out;
 
-	pqi_schedule_rescan_worker_delayed(ctrl_info);
-
+	rescan_needed = false;
 	event = ctrl_info->events;
 	for (i = 0; i < PQI_NUM_SUPPORTED_EVENTS; i++) {
 		if (event->pending) {
 			event->pending = false;
 			if (event->event_type == PQI_EVENT_TYPE_OFA) {
-				pqi_ctrl_unbusy(ctrl_info);
-				pqi_ofa_process_event(ctrl_info, event);
-				return;
+				ack_event = pqi_ofa_process_event(ctrl_info, event);
+			} else {
+				ack_event = true;
+				rescan_needed = true;
 			}
-			pqi_acknowledge_event(ctrl_info, event);
+			if (ack_event)
+				pqi_acknowledge_event(ctrl_info, event);
 		}
 		event++;
 	}
 
+	if (rescan_needed)
+		pqi_schedule_rescan_worker_delayed(ctrl_info);
+
 out:
 	pqi_ctrl_unbusy(ctrl_info);
 }
@@ -3485,37 +3521,18 @@ static inline void pqi_stop_heartbeat_timer(struct pqi_ctrl_info *ctrl_info)
 	del_timer_sync(&ctrl_info->heartbeat_timer);
 }
 
-static inline int pqi_event_type_to_event_index(unsigned int event_type)
+static void pqi_ofa_capture_event_payload(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_event *event, struct pqi_event_response *response)
 {
-	int index;
-
-	for (index = 0; index < ARRAY_SIZE(pqi_supported_event_types); index++)
-		if (event_type == pqi_supported_event_types[index])
-			return index;
-
-	return -1;
-}
-
-static inline bool pqi_is_supported_event(unsigned int event_type)
-{
-	return pqi_event_type_to_event_index(event_type) != -1;
-}
-
-static void pqi_ofa_capture_event_payload(struct pqi_event *event,
-	struct pqi_event_response *response)
-{
-	u16 event_id;
-
-	event_id = get_unaligned_le16(&event->event_id);
-
-	if (event->event_type == PQI_EVENT_TYPE_OFA) {
-		if (event_id == PQI_EVENT_OFA_MEMORY_ALLOCATION) {
-			event->ofa_bytes_requested =
-			response->data.ofa_memory_allocation.bytes_requested;
-		} else if (event_id == PQI_EVENT_OFA_CANCELED) {
-			event->ofa_cancel_reason =
-			response->data.ofa_cancelled.reason;
-		}
+	switch (event->event_id) {
+	case PQI_EVENT_OFA_MEMORY_ALLOCATION:
+		ctrl_info->ofa_bytes_requested =
+			get_unaligned_le32(&response->data.ofa_memory_allocation.bytes_requested);
+		break;
+	case PQI_EVENT_OFA_CANCELED:
+		ctrl_info->ofa_cancel_reason =
+			get_unaligned_le16(&response->data.ofa_cancelled.reason);
+		break;
 	}
 }
 
@@ -3559,7 +3576,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 			event->additional_event_id =
 				get_unaligned_le32(&response->additional_event_id);
 			if (event->event_type == PQI_EVENT_TYPE_OFA)
-				pqi_ofa_capture_event_payload(event, response);
+				pqi_ofa_capture_event_payload(ctrl_info, event, response);
 		}
 
 		oq_ci = (oq_ci + 1) % PQI_NUM_EVENT_QUEUE_ELEMENTS;
@@ -6282,6 +6299,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
+	if (pqi_ofa_in_progress(ctrl_info) && pqi_ctrl_blocked(ctrl_info))
+		return -EBUSY;
 	if (!arg)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
@@ -6418,9 +6437,6 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 
 	ctrl_info = shost_to_hba(sdev->host);
 
-	if (pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info))
-		return -EBUSY;
-
 	switch (cmd) {
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWDISK:
@@ -8003,7 +8019,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
-	pqi_schedule_update_time_worker(ctrl_info);
+	if (pqi_ofa_in_progress(ctrl_info))
+		pqi_ctrl_unblock_scan(ctrl_info);
 
 	pqi_scan_scsi_devices(ctrl_info);
 
@@ -8123,6 +8140,9 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	timer_setup(&ctrl_info->heartbeat_timer, pqi_heartbeat_timer_handler, 0);
 	INIT_WORK(&ctrl_info->ctrl_offline_work, pqi_ctrl_offline_worker);
 
+	INIT_WORK(&ctrl_info->ofa_memory_alloc_work, pqi_ofa_memory_alloc_worker);
+	INIT_WORK(&ctrl_info->ofa_quiesce_work, pqi_ofa_quiesce_worker);
+
 	sema_init(&ctrl_info->sync_request_sem,
 		PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
 	init_waitqueue_head(&ctrl_info->block_requests_wait);
@@ -8191,11 +8211,9 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_cancel_update_time_worker(ctrl_info);
-	pqi_cancel_rescan_worker(ctrl_info);
-	pqi_wait_until_lun_reset_finished(ctrl_info);
-	pqi_wait_until_scan_finished(ctrl_info);
-	pqi_ctrl_ofa_start(ctrl_info);
+	pqi_ctrl_block_scan(ctrl_info);
+	pqi_scsi_block_requests(ctrl_info);
+	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_ctrl_wait_for_pending_io(ctrl_info, PQI_PENDING_IO_TIMEOUT_SECS);
@@ -8208,63 +8226,47 @@ static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_ofa_free_host_buffer(ctrl_info);
-	ctrl_info->pqi_mode_enabled = true;
-	pqi_save_ctrl_mode(ctrl_info, PQI_MODE);
-	ctrl_info->controller_online = true;
-	pqi_ctrl_unblock_requests(ctrl_info);
 	pqi_start_heartbeat_timer(ctrl_info);
-	pqi_schedule_update_time_worker(ctrl_info);
-	pqi_clear_soft_reset_status(ctrl_info);
-	pqi_scan_scsi_devices(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
 }
 
-static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info,
-	u32 total_size, u32 chunk_size)
+static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info, u32 total_size, u32 chunk_size)
 {
-	u32 sg_count;
-	u32 size;
 	int i;
-	struct pqi_sg_descriptor *mem_descriptor = NULL;
+	u32 sg_count;
 	struct device *dev;
 	struct pqi_ofa_memory *ofap;
-
-	dev = &ctrl_info->pci_dev->dev;
-
-	sg_count = (total_size + chunk_size - 1);
-	sg_count /= chunk_size;
+	struct pqi_sg_descriptor *mem_descriptor;
+	dma_addr_t dma_handle;
 
 	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
 
-	if (sg_count*chunk_size < total_size)
+	sg_count = DIV_ROUND_UP(total_size, chunk_size);
+	if (sg_count == 0 || sg_count > PQI_OFA_MAX_SG_DESCRIPTORS)
 		goto out;
 
-	ctrl_info->pqi_ofa_chunk_virt_addr =
-				kcalloc(sg_count, sizeof(void *), GFP_KERNEL);
+	ctrl_info->pqi_ofa_chunk_virt_addr = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
 	if (!ctrl_info->pqi_ofa_chunk_virt_addr)
 		goto out;
 
-	for (size = 0, i = 0; size < total_size; size += chunk_size, i++) {
-		dma_addr_t dma_handle;
+	dev = &ctrl_info->pci_dev->dev;
 
+	for (i = 0; i < sg_count; i++) {
 		ctrl_info->pqi_ofa_chunk_virt_addr[i] =
-			dma_alloc_coherent(dev, chunk_size, &dma_handle,
-					   GFP_KERNEL);
-
+			dma_alloc_coherent(dev, chunk_size, &dma_handle, GFP_KERNEL);
 		if (!ctrl_info->pqi_ofa_chunk_virt_addr[i])
-			break;
-
+			goto out_free_chunks;
 		mem_descriptor = &ofap->sg_descriptor[i];
 		put_unaligned_le64((u64)dma_handle, &mem_descriptor->address);
 		put_unaligned_le32(chunk_size, &mem_descriptor->length);
 	}
 
-	if (!size || size < total_size)
-		goto out_free_chunks;
-
 	put_unaligned_le32(CISS_SG_LAST, &mem_descriptor->flags);
 	put_unaligned_le16(sg_count, &ofap->num_memory_descriptors);
-	put_unaligned_le32(size, &ofap->bytes_allocated);
+	put_unaligned_le32(sg_count * chunk_size, &ofap->bytes_allocated);
 
 	return 0;
 
@@ -8272,82 +8274,87 @@ static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info,
 	while (--i >= 0) {
 		mem_descriptor = &ofap->sg_descriptor[i];
 		dma_free_coherent(dev, chunk_size,
-				ctrl_info->pqi_ofa_chunk_virt_addr[i],
-				get_unaligned_le64(&mem_descriptor->address));
+			ctrl_info->pqi_ofa_chunk_virt_addr[i],
+			get_unaligned_le64(&mem_descriptor->address));
 	}
 	kfree(ctrl_info->pqi_ofa_chunk_virt_addr);
 
 out:
-	put_unaligned_le32 (0, &ofap->bytes_allocated);
 	return -ENOMEM;
 }
 
 static int pqi_ofa_alloc_host_buffer(struct pqi_ctrl_info *ctrl_info)
 {
 	u32 total_size;
+	u32 chunk_size;
 	u32 min_chunk_size;
-	u32 chunk_sz;
 
-	total_size = le32_to_cpu(
-			ctrl_info->pqi_ofa_mem_virt_addr->bytes_allocated);
-	min_chunk_size = total_size / PQI_OFA_MAX_SG_DESCRIPTORS;
+	if (ctrl_info->ofa_bytes_requested == 0)
+		return 0;
+
+	total_size = PAGE_ALIGN(ctrl_info->ofa_bytes_requested);
+	min_chunk_size = DIV_ROUND_UP(total_size, PQI_OFA_MAX_SG_DESCRIPTORS);
+	min_chunk_size = PAGE_ALIGN(min_chunk_size);
 
-	for (chunk_sz = total_size; chunk_sz >= min_chunk_size; chunk_sz /= 2)
-		if (!pqi_ofa_alloc_mem(ctrl_info, total_size, chunk_sz))
+	for (chunk_size = total_size; chunk_size >= min_chunk_size;) {
+		if (pqi_ofa_alloc_mem(ctrl_info, total_size, chunk_size) == 0)
 			return 0;
+		chunk_size /= 2;
+		chunk_size = PAGE_ALIGN(chunk_size);
+	}
 
 	return -ENOMEM;
 }
 
-static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info,
-	u32 bytes_requested)
+static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info)
 {
-	struct pqi_ofa_memory *pqi_ofa_memory;
 	struct device *dev;
+	struct pqi_ofa_memory *ofap;
 
 	dev = &ctrl_info->pci_dev->dev;
-	pqi_ofa_memory = dma_alloc_coherent(dev,
-					    PQI_OFA_MEMORY_DESCRIPTOR_LENGTH,
-					    &ctrl_info->pqi_ofa_mem_dma_handle,
-					    GFP_KERNEL);
 
-	if (!pqi_ofa_memory)
+	ofap = dma_alloc_coherent(dev, sizeof(*ofap),
+		&ctrl_info->pqi_ofa_mem_dma_handle, GFP_KERNEL);
+	if (!ofap)
 		return;
 
-	put_unaligned_le16(PQI_OFA_VERSION, &pqi_ofa_memory->version);
-	memcpy(&pqi_ofa_memory->signature, PQI_OFA_SIGNATURE,
-					sizeof(pqi_ofa_memory->signature));
-	pqi_ofa_memory->bytes_allocated = cpu_to_le32(bytes_requested);
-
-	ctrl_info->pqi_ofa_mem_virt_addr = pqi_ofa_memory;
+	ctrl_info->pqi_ofa_mem_virt_addr = ofap;
 
 	if (pqi_ofa_alloc_host_buffer(ctrl_info) < 0) {
-		dev_err(dev, "Failed to allocate host buffer of size = %u",
-			bytes_requested);
+		dev_err(dev,
+			"failed to allocate host buffer for Online Firmware Activation\n");
+		dma_free_coherent(dev, sizeof(*ofap), ofap, ctrl_info->pqi_ofa_mem_dma_handle);
+		ctrl_info->pqi_ofa_mem_virt_addr = NULL;
+		return;
 	}
 
-	return;
+	put_unaligned_le16(PQI_OFA_VERSION, &ofap->version);
+	memcpy(&ofap->signature, PQI_OFA_SIGNATURE, sizeof(ofap->signature));
 }
 
 static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
 {
-	int i;
-	struct pqi_sg_descriptor *mem_descriptor;
+	unsigned int i;
+	struct device *dev;
 	struct pqi_ofa_memory *ofap;
+	struct pqi_sg_descriptor *mem_descriptor;
+	unsigned int num_memory_descriptors;
 
 	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
-
 	if (!ofap)
 		return;
 
-	if (!ofap->bytes_allocated)
+	dev = &ctrl_info->pci_dev->dev;
+
+	if (get_unaligned_le32(&ofap->bytes_allocated) == 0)
 		goto out;
 
 	mem_descriptor = ofap->sg_descriptor;
+	num_memory_descriptors =
+		get_unaligned_le16(&ofap->num_memory_descriptors);
 
-	for (i = 0; i < get_unaligned_le16(&ofap->num_memory_descriptors);
-		i++) {
-		dma_free_coherent(&ctrl_info->pci_dev->dev,
+	for (i = 0; i < num_memory_descriptors; i++) {
+		dma_free_coherent(dev,
 			get_unaligned_le32(&mem_descriptor[i].length),
 			ctrl_info->pqi_ofa_chunk_virt_addr[i],
 			get_unaligned_le64(&mem_descriptor[i].address));
@@ -8355,46 +8362,45 @@ static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
 	kfree(ctrl_info->pqi_ofa_chunk_virt_addr);
 
 out:
-	dma_free_coherent(&ctrl_info->pci_dev->dev,
-			PQI_OFA_MEMORY_DESCRIPTOR_LENGTH, ofap,
-			ctrl_info->pqi_ofa_mem_dma_handle);
+	dma_free_coherent(dev, sizeof(*ofap), ofap,
+		ctrl_info->pqi_ofa_mem_dma_handle);
 	ctrl_info->pqi_ofa_mem_virt_addr = NULL;
 }
 
 static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
 {
+	u32 buffer_length;
 	struct pqi_vendor_general_request request;
-	size_t size;
 	struct pqi_ofa_memory *ofap;
 
 	memset(&request, 0, sizeof(request));
 
-	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
-
 	request.header.iu_type = PQI_REQUEST_IU_VENDOR_GENERAL;
 	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
 		&request.header.iu_length);
 	put_unaligned_le16(PQI_VENDOR_GENERAL_HOST_MEMORY_UPDATE,
 		&request.function_code);
 
+	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
+
 	if (ofap) {
-		size = offsetof(struct pqi_ofa_memory, sg_descriptor) +
+		buffer_length = offsetof(struct pqi_ofa_memory, sg_descriptor) +
 			get_unaligned_le16(&ofap->num_memory_descriptors) *
 			sizeof(struct pqi_sg_descriptor);
 
 		put_unaligned_le64((u64)ctrl_info->pqi_ofa_mem_dma_handle,
 			&request.data.ofa_memory_allocation.buffer_address);
-		put_unaligned_le32(size,
+		put_unaligned_le32(buffer_length,
 			&request.data.ofa_memory_allocation.buffer_length);
-
 	}
 
 	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 }
 
-static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info)
+static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs)
 {
-	msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+	ssleep(delay_secs);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 

