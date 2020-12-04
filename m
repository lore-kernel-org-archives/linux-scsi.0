Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C60C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922C822D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgLDXDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:46 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1456 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgLDXDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123025; x=1638659025;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zcCUVYgnYiMLqO37EPXUlfW3vL8agdFT8HecNCeQ+bM=;
  b=DsxU76qFzZr8ERRFAFRP+aX9sRDJtkMv7CHhkzww3b7x7gkSZse0jZyn
   tyEmWwIKPbjYTKeMkpXmYVwJ59QqPMNEmFv1/iM0N6wqibOiqpgpI/xlf
   cnLADvQK0PPE1ZO0XnglfPM1+bFT8+Vji9AaTf+lUCqsxfeQFGk/cV8a2
   LClIbaBdGDx2Jh6PR/yj3ZmAEqbo/pXHwVbzr1/XtvfHc1h4iBmKktyzG
   YkBQITJ9KWBrItU7PJ1QgADXc5q9evxqg+931dh44G8bDi6pX9N5hbT9/
   p6/5FwoplTsLuok7YXzuj5An/n5C+nlV/QpnpHOgfVXqMnONZSB7e6Gu6
   Q==;
IronPort-SDR: oPdkddk5TgywnpQBDyYXY6E+YRCdQxp6A2tpIlgKPU/JSb5O9hn+Hx20gVcl3GE5DZfSqiP+em
 r0ZnwK+EZZTq/frqPSzZoY4n5+hMP1l6LfjbqfjQqpL/CLmlNQfStTn2xBlU6BYAZfbrt91ge+
 uzIOs0CI3aheyEu5S/8HBdPcxyaGI0tQ8eSBru6DOd/eAY1+ArCcSZCn2/TMudCQqWlr7NK3Dv
 RQfZWMW2kpvdHx+Yu0Aaiv+er5aUhJJtOMEScGV0L0wGPGst4c2FWtZAdwZ0JSkQse/dbDWH8T
 JME=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548717"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:12 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:12 -0700
Subject: [PATCH 14/25] smartpqi: fix driver synchronization issues
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:11 -0600
Message-ID: <160712293190.21372.8193896733647433880.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* synchronize: LUN resets, shutdowns, suspend, hibernate,
  OFA, and controller offline events.
* prevent I/O during the the above conditions.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   48 -
 drivers/scsi/smartpqi/smartpqi_init.c | 1157 +++++++++++++--------------------
 2 files changed, 474 insertions(+), 731 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 976bfd8c5192..0b94c755a74c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -130,9 +130,12 @@ struct pqi_iu_header {
 				/* of this header */
 	__le16	response_queue_id;	/* specifies the OQ where the */
 					/* response IU is to be delivered */
-	u8	work_area[2];	/* reserved for driver use */
+	u16	driver_flags;	/* reserved for driver use */
 };
 
+/* manifest constants for pqi_iu_header.driver_flags */
+#define PQI_DRIVER_NONBLOCKABLE_REQUEST		0x1
+
 /*
  * According to the PQI spec, the IU header is only the first 4 bytes of our
  * pqi_iu_header structure.
@@ -508,10 +511,6 @@ struct pqi_vendor_general_response {
 #define PQI_OFA_SIGNATURE		"OFA_QRM"
 #define PQI_OFA_MAX_SG_DESCRIPTORS	64
 
-#define PQI_OFA_MEMORY_DESCRIPTOR_LENGTH \
-	(offsetof(struct pqi_ofa_memory, sg_descriptor) + \
-	(PQI_OFA_MAX_SG_DESCRIPTORS * sizeof(struct pqi_sg_descriptor)))
-
 struct pqi_ofa_memory {
 	__le64	signature;	/* "OFA_QRM" */
 	__le16	version;	/* version of this struct (1 = 1st version) */
@@ -519,7 +518,7 @@ struct pqi_ofa_memory {
 	__le32	bytes_allocated;	/* total allocated memory in bytes */
 	__le16	num_memory_descriptors;
 	u8	reserved1[2];
-	struct pqi_sg_descriptor sg_descriptor[1];
+	struct pqi_sg_descriptor sg_descriptor[PQI_OFA_MAX_SG_DESCRIPTORS];
 };
 
 struct pqi_aio_error_info {
@@ -850,7 +849,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT			13
 #define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
 #define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
-#define PQI_FIRMWARE_FEATURE_MAXIMUM				15
+#define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				16
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1071,7 +1071,6 @@ struct pqi_scsi_dev {
 	u8	volume_offline : 1;
 	u8	rescan : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
-	bool	in_reset;
 	bool	in_remove;
 	bool	device_offline;
 	u8	vendor[8];		/* bytes 8-15 of inquiry data */
@@ -1107,6 +1106,7 @@ struct pqi_scsi_dev {
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding;
 	atomic_t raid_bypass_cnt;
+	u8	page_83_identifier[16];
 };
 
 /* VPD inquiry pages */
@@ -1212,10 +1212,8 @@ struct pqi_io_request {
 struct pqi_event {
 	bool	pending;
 	u8	event_type;
-	__le16	event_id;
-	__le32	additional_event_id;
-	__le32	ofa_bytes_requested;
-	__le16	ofa_cancel_reason;
+	u16	event_id;
+	u32	additional_event_id;
 };
 
 #define PQI_RESERVED_IO_SLOTS_LUN_RESET			1
@@ -1287,12 +1285,9 @@ struct pqi_ctrl_info {
 
 	struct mutex	scan_mutex;
 	struct mutex	lun_reset_mutex;
-	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
-	bool		block_device_reset;
-	bool		in_ofa;
-	bool		in_shutdown;
+	bool		scan_blocked;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
@@ -1300,6 +1295,7 @@ struct pqi_ctrl_info {
 	u8		soft_reset_handshake_supported : 1;
 	u8		raid_iu_timeout_supported : 1;
 	u8		tmf_iu_timeout_supported : 1;
+	u8		unique_wwid_in_report_phys_lun_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
@@ -1341,14 +1337,14 @@ struct pqi_ctrl_info {
 	atomic_t	num_blocked_threads;
 	wait_queue_head_t block_requests_wait;
 
-	struct list_head raid_bypass_retry_list;
-	spinlock_t	raid_bypass_retry_list_lock;
-	struct work_struct raid_bypass_retry_work;
-
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
@@ -1619,16 +1615,6 @@ struct bmic_diag_options {
 
 #pragma pack()
 
-static inline void pqi_ctrl_busy(struct pqi_ctrl_info *ctrl_info)
-{
-	atomic_inc(&ctrl_info->num_busy_threads);
-}
-
-static inline void pqi_ctrl_unbusy(struct pqi_ctrl_info *ctrl_info)
-{
-	atomic_dec(&ctrl_info->num_busy_threads);
-}
-
 static inline struct pqi_ctrl_info *shost_to_hba(struct Scsi_Host *shost)
 {
 	void *hostdata = shost_priv(shost);
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8148a270854e..0472ba6de43b 100644
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
@@ -54,7 +57,6 @@ MODULE_LICENSE("GPL");
 
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
-static void pqi_retry_raid_bypass_requests(struct pqi_ctrl_info *ctrl_info);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
 static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
@@ -62,7 +64,7 @@ static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request);
 static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_iu_header *request, unsigned int flags,
-	struct pqi_raid_error_info *error_info, unsigned long timeout_msecs);
+	struct pqi_raid_error_info *error_info);
 static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
@@ -77,9 +79,8 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
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
@@ -245,14 +246,66 @@ static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
 	sis_write_driver_scratch(ctrl_info, mode);
 }
 
+static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->scan_blocked = true;
+	mutex_lock(&ctrl_info->scan_mutex);
+}
+
+static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->scan_blocked = false;
+	mutex_unlock(&ctrl_info->scan_mutex);
+}
+
+static inline bool pqi_ctrl_scan_blocked(struct pqi_ctrl_info *ctrl_info)
+{
+	return ctrl_info->scan_blocked;
+}
+
 static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctrl_info)
 {
-	ctrl_info->block_device_reset = true;
+	mutex_lock(&ctrl_info->lun_reset_mutex);
+}
+
+static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info *ctrl_info)
+{
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
+}
+
+static inline void pqi_scsi_block_requests(struct pqi_ctrl_info *ctrl_info)
+{
+	struct Scsi_Host *shost;
+	unsigned int num_loops;
+	int msecs_sleep;
+
+	shost = ctrl_info->scsi_host;
+
+	scsi_block_requests(shost);
+
+	num_loops = 0;
+	msecs_sleep = 20;
+	while (scsi_host_busy(shost)) {
+		num_loops++;
+		if (num_loops == 10)
+			msecs_sleep = 500;
+		msleep(msecs_sleep);
+	}
+}
+
+static inline void pqi_scsi_unblock_requests(struct pqi_ctrl_info *ctrl_info)
+{
+	scsi_unblock_requests(ctrl_info->scsi_host);
+}
+
+static inline void pqi_ctrl_busy(struct pqi_ctrl_info *ctrl_info)
+{
+	atomic_inc(&ctrl_info->num_busy_threads);
 }
 
-static inline bool pqi_device_reset_blocked(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_ctrl_unbusy(struct pqi_ctrl_info *ctrl_info)
 {
-	return ctrl_info->block_device_reset;
+	atomic_dec(&ctrl_info->num_busy_threads);
 }
 
 static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
@@ -263,44 +316,23 @@ static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 static inline void pqi_ctrl_block_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	ctrl_info->block_requests = true;
-	scsi_block_requests(ctrl_info->scsi_host);
 }
 
 static inline void pqi_ctrl_unblock_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	ctrl_info->block_requests = false;
 	wake_up_all(&ctrl_info->block_requests_wait);
-	pqi_retry_raid_bypass_requests(ctrl_info);
-	scsi_unblock_requests(ctrl_info->scsi_host);
 }
 
-static unsigned long pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info,
-	unsigned long timeout_msecs)
+static void pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned long remaining_msecs;
-
 	if (!pqi_ctrl_blocked(ctrl_info))
-		return timeout_msecs;
+		return;
 
 	atomic_inc(&ctrl_info->num_blocked_threads);
-
-	if (timeout_msecs == NO_TIMEOUT) {
-		wait_event(ctrl_info->block_requests_wait,
-			!pqi_ctrl_blocked(ctrl_info));
-		remaining_msecs = timeout_msecs;
-	} else {
-		unsigned long remaining_jiffies;
-
-		remaining_jiffies =
-			wait_event_timeout(ctrl_info->block_requests_wait,
-				!pqi_ctrl_blocked(ctrl_info),
-				msecs_to_jiffies(timeout_msecs));
-		remaining_msecs = jiffies_to_msecs(remaining_jiffies);
-	}
-
+	wait_event(ctrl_info->block_requests_wait,
+		!pqi_ctrl_blocked(ctrl_info));
 	atomic_dec(&ctrl_info->num_blocked_threads);
-
-	return remaining_msecs;
 }
 
 static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
@@ -315,34 +347,25 @@ static inline bool pqi_device_offline(struct pqi_scsi_dev *device)
 	return device->device_offline;
 }
 
-static inline void pqi_device_reset_start(struct pqi_scsi_dev *device)
-{
-	device->in_reset = true;
-}
-
-static inline void pqi_device_reset_done(struct pqi_scsi_dev *device)
-{
-	device->in_reset = false;
-}
-
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
@@ -355,14 +378,20 @@ static inline bool pqi_device_in_remove(struct pqi_scsi_dev *device)
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
@@ -370,8 +399,6 @@ static inline void pqi_schedule_rescan_worker_with_delay(struct pqi_ctrl_info *c
 {
 	if (pqi_ctrl_offline(ctrl_info))
 		return;
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		return;
 
 	schedule_delayed_work(&ctrl_info->rescan_work, delay);
 }
@@ -408,22 +435,15 @@ static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 
 static inline u8 pqi_read_soft_reset_status(struct pqi_ctrl_info *ctrl_info)
 {
-	if (!ctrl_info->soft_reset_status)
-		return 0;
-
 	return readb(ctrl_info->soft_reset_status);
 }
 
-static inline void pqi_clear_soft_reset_status(struct pqi_ctrl_info *ctrl_info,
-	u8 clear)
+static inline void pqi_clear_soft_reset_status(struct pqi_ctrl_info *ctrl_info)
 {
 	u8 status;
 
-	if (!ctrl_info->soft_reset_status)
-		return;
-
 	status = pqi_read_soft_reset_status(ctrl_info);
-	status &= ~clear;
+	status &= ~PQI_SOFT_RESET_ABORT;
 	writeb(status, ctrl_info->soft_reset_status);
 }
 
@@ -512,6 +532,7 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		put_unaligned_be32(cdb_length, &cdb[6]);
 		break;
 	case SA_FLUSH_CACHE:
+		request->header.driver_flags = PQI_DRIVER_NONBLOCKABLE_REQUEST;
 		request->data_direction = SOP_WRITE_FLAG;
 		cdb[0] = BMIC_WRITE;
 		cdb[6] = BMIC_FLUSH_CACHE;
@@ -606,7 +627,7 @@ static void pqi_free_io_request(struct pqi_io_request *io_request)
 
 static int pqi_send_scsi_raid_request(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	u8 *scsi3addr, void *buffer, size_t buffer_length, u16 vpd_page,
-	struct pqi_raid_error_info *error_info,	unsigned long timeout_msecs)
+	struct pqi_raid_error_info *error_info)
 {
 	int rc;
 	struct pqi_raid_path_request request;
@@ -618,7 +639,7 @@ static int pqi_send_scsi_raid_request(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 		return rc;
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0,
-		error_info, timeout_msecs);
+		error_info);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -631,7 +652,7 @@ static inline int pqi_send_ctrl_raid_request(struct pqi_ctrl_info *ctrl_info,
 	u8 cmd, void *buffer, size_t buffer_length)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, cmd, RAID_CTLR_LUNID,
-		buffer, buffer_length, 0, NULL, NO_TIMEOUT);
+		buffer, buffer_length, 0, NULL);
 }
 
 static inline int pqi_send_ctrl_raid_with_error(struct pqi_ctrl_info *ctrl_info,
@@ -639,7 +660,7 @@ static inline int pqi_send_ctrl_raid_with_error(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_raid_error_info *error_info)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, cmd, RAID_CTLR_LUNID,
-		buffer, buffer_length, 0, error_info, NO_TIMEOUT);
+		buffer, buffer_length, 0, error_info);
 }
 
 static inline int pqi_identify_controller(struct pqi_ctrl_info *ctrl_info,
@@ -661,7 +682,7 @@ static inline int pqi_scsi_inquiry(struct pqi_ctrl_info *ctrl_info,
 	u8 *scsi3addr, u16 vpd_page, void *buffer, size_t buffer_length)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, INQUIRY, scsi3addr,
-		buffer, buffer_length, vpd_page, NULL, NO_TIMEOUT);
+		buffer, buffer_length, vpd_page, NULL);
 }
 
 static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
@@ -683,8 +704,7 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	request.cdb[2] = (u8)bmic_device_index;
 	request.cdb[9] = (u8)(bmic_device_index >> 8);
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -741,7 +761,7 @@ static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
 	request.cdb[2] = BMIC_SENSE_FEATURE_IO_PAGE;
 	request.cdb[3] = BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -794,13 +814,6 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct bmic_flush_cache *flush_cache;
 
-	/*
-	 * Don't bother trying to flush the cache if the controller is
-	 * locked up.
-	 */
-	if (pqi_ctrl_offline(ctrl_info))
-		return -ENXIO;
-
 	flush_cache = kzalloc(sizeof(*flush_cache), GFP_KERNEL);
 	if (!flush_cache)
 		return -ENOMEM;
@@ -979,9 +992,6 @@ static void pqi_update_time_worker(struct work_struct *work)
 	ctrl_info = container_of(to_delayed_work(work), struct pqi_ctrl_info,
 		update_time_work);
 
-	if (pqi_ctrl_offline(ctrl_info))
-		return;
-
 	rc = pqi_write_current_time_to_host_wellness(ctrl_info);
 	if (rc)
 		dev_warn(&ctrl_info->pci_dev->dev,
@@ -1271,9 +1281,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 		return -ENOMEM;
 
 	rc = pqi_send_scsi_raid_request(ctrl_info, CISS_GET_RAID_MAP,
-		device->scsi3addr, raid_map, sizeof(*raid_map),
-		0, NULL, NO_TIMEOUT);
-
+		device->scsi3addr, raid_map, sizeof(*raid_map), 0, NULL);
 	if (rc)
 		goto error;
 
@@ -1288,8 +1296,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 			return -ENOMEM;
 
 		rc = pqi_send_scsi_raid_request(ctrl_info, CISS_GET_RAID_MAP,
-			device->scsi3addr, raid_map, raid_map_size,
-			0, NULL, NO_TIMEOUT);
+			device->scsi3addr, raid_map, raid_map_size, 0, NULL);
 		if (rc)
 			goto error;
 
@@ -1464,6 +1471,9 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
 
+	memcpy(&device->page_83_identifier, &id_phys->page_83_identifier,
+		sizeof(device->page_83_identifier));
+
 	return 0;
 }
 
@@ -1970,8 +1980,13 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		pqi_ctrl_ofa_done(ctrl_info);
+	if (pqi_ofa_in_progress(ctrl_info)) {
+		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry)
+			if (pqi_is_device_added(device))
+				pqi_device_remove_start(device);
+		pqi_ctrl_unblock_device_reset(ctrl_info);
+		pqi_scsi_unblock_requests(ctrl_info);
+	}
 
 	/* Remove all devices that have gone away. */
 	list_for_each_entry_safe(device, next, &delete_list, delete_list_entry) {
@@ -1993,19 +2008,14 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	 * Notify the SCSI ML if the queue depth of any existing device has
 	 * changed.
 	 */
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
-		if (device->sdev) {
-			if (device->queue_depth !=
-				device->advertised_queue_depth) {
-				device->advertised_queue_depth = device->queue_depth;
-				scsi_change_queue_depth(device->sdev,
-					device->advertised_queue_depth);
-			}
-			if (device->rescan) {
-				scsi_rescan_device(&device->sdev->sdev_gendev);
-				device->rescan = false;
-			}
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		if (device->sdev && device->queue_depth != device->advertised_queue_depth) {
+			device->advertised_queue_depth = device->queue_depth;
+			scsi_change_queue_depth(device->sdev, device->advertised_queue_depth);
+		}
+		if (device->rescan) {
+			scsi_rescan_device(&device->sdev->sdev_gendev);
+			device->rescan = false;
 		}
 	}
 
@@ -2073,6 +2083,16 @@ static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
 }
 
+static inline void pqi_set_physical_device_wwid(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device, struct report_phys_lun_extended_entry *phys_lun_ext_entry)
+{
+	if (ctrl_info->unique_wwid_in_report_phys_lun_supported ||
+		pqi_is_device_with_sas_address(device))
+		device->wwid = phys_lun_ext_entry->wwid;
+	else
+		device->wwid = cpu_to_be64(get_unaligned_be64(&device->page_83_identifier));
+}
+
 static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int i;
@@ -2238,7 +2258,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		pqi_assign_bus_target_lun(device);
 
 		if (device->is_physical_device) {
-			device->wwid = phys_lun_ext_entry->wwid;
+			pqi_set_physical_device_wwid(ctrl_info, device, phys_lun_ext_entry);
 			if ((phys_lun_ext_entry->device_flags &
 				CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) &&
 				phys_lun_ext_entry->aio_handle) {
@@ -2278,21 +2298,27 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
-	int rc = 0;
+	int rc;
+	int mutex_acquired;
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
 
-	if (!mutex_trylock(&ctrl_info->scan_mutex)) {
+	mutex_acquired = mutex_trylock(&ctrl_info->scan_mutex);
+
+	if (!mutex_acquired) {
+		if (pqi_ctrl_scan_blocked(ctrl_info))
+			return -EBUSY;
 		pqi_schedule_rescan_worker_delayed(ctrl_info);
-		rc = -EINPROGRESS;
-	} else {
-		rc = pqi_update_scsi_devices(ctrl_info);
-		if (rc)
-			pqi_schedule_rescan_worker_delayed(ctrl_info);
-		mutex_unlock(&ctrl_info->scan_mutex);
+		return -EINPROGRESS;
 	}
 
+	rc = pqi_update_scsi_devices(ctrl_info);
+	if (rc && !pqi_ctrl_scan_blocked(ctrl_info))
+		pqi_schedule_rescan_worker_delayed(ctrl_info);
+
+	mutex_unlock(&ctrl_info->scan_mutex);
+
 	return rc;
 }
 
@@ -2301,8 +2327,6 @@ static void pqi_scan_start(struct Scsi_Host *shost)
 	struct pqi_ctrl_info *ctrl_info;
 
 	ctrl_info = shost_to_hba(shost);
-	if (pqi_ctrl_in_ofa(ctrl_info))
-		return;
 
 	pqi_scan_scsi_devices(ctrl_info);
 }
@@ -2319,27 +2343,8 @@ static int pqi_scan_finished(struct Scsi_Host *shost,
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
-static inline void pqi_set_encryption_info(
-	struct pqi_encryption_info *encryption_info, struct raid_map *raid_map,
-	u64 first_block)
+static inline void pqi_set_encryption_info(struct pqi_encryption_info *encryption_info,
+	struct raid_map *raid_map, u64 first_block)
 {
 	u32 volume_blk_size;
 
@@ -3182,8 +3187,8 @@ static void pqi_acknowledge_event(struct pqi_ctrl_info *ctrl_info,
 	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
 		&request.header.iu_length);
 	request.event_type = event->event_type;
-	request.event_id = event->event_id;
-	request.additional_event_id = event->additional_event_id;
+	put_unaligned_le16(event->event_id, &request.event_id);
+	put_unaligned_le16(event->additional_event_id, &request.additional_event_id);
 
 	pqi_send_event_ack(ctrl_info, &request, sizeof(request));
 }
@@ -3194,8 +3199,8 @@ static void pqi_acknowledge_event(struct pqi_ctrl_info *ctrl_info,
 static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
 	struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned long timeout;
 	u8 status;
+	unsigned long timeout;
 
 	timeout = (PQI_SOFT_RESET_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
 
@@ -3207,120 +3212,169 @@ static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
 		if (status & PQI_SOFT_RESET_ABORT)
 			return RESET_ABORT;
 
+		if (!sis_is_firmware_running(ctrl_info))
+			return RESET_NORESPONSE;
+
 		if (time_after(jiffies, timeout)) {
-			dev_err(&ctrl_info->pci_dev->dev,
+			dev_warn(&ctrl_info->pci_dev->dev,
 				"timed out waiting for soft reset status\n");
 			return RESET_TIMEDOUT;
 		}
 
-		if (!sis_is_firmware_running(ctrl_info))
-			return RESET_NORESPONSE;
-
 		ssleep(PQI_SOFT_RESET_STATUS_POLL_INTERVAL_SECS);
 	}
 }
 
-static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info,
-	enum pqi_soft_reset_status reset_status)
+static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
+	unsigned int delay_secs;
+	enum pqi_soft_reset_status reset_status;
+
+	if (ctrl_info->soft_reset_handshake_supported)
+		reset_status = pqi_poll_for_soft_reset_status(ctrl_info);
+	else
+		reset_status = RESET_INITIATE_FIRMWARE;
+
+	pqi_ofa_free_host_buffer(ctrl_info);
+
+	delay_secs = PQI_POST_RESET_DELAY_SECS;
 
 	switch (reset_status) {
-	case RESET_INITIATE_DRIVER:
 	case RESET_TIMEDOUT:
+		delay_secs = PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS;
+		fallthrough;
+	case RESET_INITIATE_DRIVER:
 		dev_info(&ctrl_info->pci_dev->dev,
-			"resetting controller %u\n", ctrl_info->ctrl_id);
+				"Online Firmware Activation: resetting controller\n");
 		sis_soft_reset(ctrl_info);
 		fallthrough;
 	case RESET_INITIATE_FIRMWARE:
-		rc = pqi_ofa_ctrl_restart(ctrl_info);
-		pqi_ofa_free_host_buffer(ctrl_info);
+		ctrl_info->pqi_mode_enabled = false;
+		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
+		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
+		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Online Firmware Activation for controller %u: %s\n",
-			ctrl_info->ctrl_id, rc == 0 ? "SUCCESS" : "FAILED");
+				"Online Firmware Activation: %s\n",
+				rc == 0 ? "SUCCESS" : "FAILED");
 		break;
 	case RESET_ABORT:
-		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Online Firmware Activation for controller %u: %s\n",
-			ctrl_info->ctrl_id, "ABORTED");
+				"Online Firmware Activation ABORTED\n");
+		if (ctrl_info->soft_reset_handshake_supported)
+			pqi_clear_soft_reset_status(ctrl_info);
+		pqi_ctrl_ofa_done(ctrl_info);
+		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
 	case RESET_NORESPONSE:
-		pqi_ofa_free_host_buffer(ctrl_info);
+		fallthrough;
+	default:
+		dev_err(&ctrl_info->pci_dev->dev,
+			"unexpected Online Firmware Activation reset status: 0x%x\n",
+			reset_status);
+		pqi_ctrl_ofa_done(ctrl_info);
+		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info);
 		break;
 	}
 }
 
-static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_event *event)
+static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
 {
-	u16 event_id;
-	enum pqi_soft_reset_status status;
+	struct pqi_ctrl_info *ctrl_info;
 
-	event_id = get_unaligned_le16(&event->event_id);
+	ctrl_info = container_of(work, struct pqi_ctrl_info, ofa_memory_alloc_work);
 
-	mutex_lock(&ctrl_info->ofa_mutex);
+	pqi_ctrl_ofa_start(ctrl_info);
+	pqi_ofa_setup_host_buffer(ctrl_info);
+	pqi_ofa_host_memory_update(ctrl_info);
+}
 
-	if (event_id == PQI_EVENT_OFA_QUIESCE) {
-		dev_info(&ctrl_info->pci_dev->dev,
-			"Received Online Firmware Activation quiesce event for controller %u\n",
-			ctrl_info->ctrl_id);
-		pqi_ofa_ctrl_quiesce(ctrl_info);
-		pqi_acknowledge_event(ctrl_info, event);
-		if (ctrl_info->soft_reset_handshake_supported) {
-			status = pqi_poll_for_soft_reset_status(ctrl_info);
-			pqi_process_soft_reset(ctrl_info, status);
-		} else {
-			pqi_process_soft_reset(ctrl_info,
-					RESET_INITIATE_FIRMWARE);
-		}
+static void pqi_ofa_quiesce_worker(struct work_struct *work)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_event *event;
 
-	} else if (event_id == PQI_EVENT_OFA_MEMORY_ALLOCATION) {
-		pqi_acknowledge_event(ctrl_info, event);
-		pqi_ofa_setup_host_buffer(ctrl_info,
-			le32_to_cpu(event->ofa_bytes_requested));
-		pqi_ofa_host_memory_update(ctrl_info);
-	} else if (event_id == PQI_EVENT_OFA_CANCELED) {
-		pqi_ofa_free_host_buffer(ctrl_info);
-		pqi_acknowledge_event(ctrl_info, event);
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
+		dev_info(&ctrl_info->pci_dev->dev,
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
 
 	pqi_ctrl_busy(ctrl_info);
-	pqi_wait_if_ctrl_blocked(ctrl_info, NO_TIMEOUT);
+	pqi_wait_if_ctrl_blocked(ctrl_info);
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
@@ -3377,37 +3431,18 @@ static inline void pqi_stop_heartbeat_timer(struct pqi_ctrl_info *ctrl_info)
 	del_timer_sync(&ctrl_info->heartbeat_timer);
 }
 
-static inline int pqi_event_type_to_event_index(unsigned int event_type)
-{
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
+static void pqi_ofa_capture_event_payload(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_event *event, struct pqi_event_response *response)
 {
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
 
@@ -3441,17 +3476,17 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 		num_events++;
 		response = event_queue->oq_element_array + (oq_ci * PQI_EVENT_OQ_ELEMENT_LENGTH);
 
-		event_index =
-			pqi_event_type_to_event_index(response->event_type);
+		event_index = pqi_event_type_to_event_index(response->event_type);
 
 		if (event_index >= 0 && response->request_acknowledge) {
 			event = &ctrl_info->events[event_index];
 			event->pending = true;
 			event->event_type = response->event_type;
-			event->event_id = response->event_id;
-			event->additional_event_id = response->additional_event_id;
+			event->event_id = get_unaligned_le16(&response->event_id);
+			event->additional_event_id =
+				get_unaligned_le32(&response->additional_event_id);
 			if (event->event_type == PQI_EVENT_TYPE_OFA)
-				pqi_ofa_capture_event_payload(event, response);
+				pqi_ofa_capture_event_payload(ctrl_info, event, response);
 		}
 
 		oq_ci = (oq_ci + 1) % PQI_NUM_EVENT_QUEUE_ELEMENTS;
@@ -3468,8 +3503,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 
 #define PQI_LEGACY_INTX_MASK	0x1
 
-static inline void pqi_configure_legacy_intx(struct pqi_ctrl_info *ctrl_info,
-	bool enable_intx)
+static inline void pqi_configure_legacy_intx(struct pqi_ctrl_info *ctrl_info, bool enable_intx)
 {
 	u32 intx_mask;
 	struct pqi_device_registers __iomem *pqi_registers;
@@ -4147,59 +4181,36 @@ static int pqi_process_raid_io_error_synchronous(
 	return rc;
 }
 
+static inline bool pqi_is_blockable_request(struct pqi_iu_header *request)
+{
+	return (request->driver_flags & PQI_DRIVER_NONBLOCKABLE_REQUEST) == 0;
+}
+
 static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_iu_header *request, unsigned int flags,
-	struct pqi_raid_error_info *error_info, unsigned long timeout_msecs)
+	struct pqi_raid_error_info *error_info)
 {
 	int rc = 0;
 	struct pqi_io_request *io_request;
-	unsigned long start_jiffies;
-	unsigned long msecs_blocked;
 	size_t iu_length;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	/*
-	 * Note that specifying PQI_SYNC_FLAGS_INTERRUPTABLE and a timeout value
-	 * are mutually exclusive.
-	 */
-
 	if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE) {
 		if (down_interruptible(&ctrl_info->sync_request_sem))
 			return -ERESTARTSYS;
 	} else {
-		if (timeout_msecs == NO_TIMEOUT) {
-			down(&ctrl_info->sync_request_sem);
-		} else {
-			start_jiffies = jiffies;
-			if (down_timeout(&ctrl_info->sync_request_sem,
-				msecs_to_jiffies(timeout_msecs)))
-				return -ETIMEDOUT;
-			msecs_blocked =
-				jiffies_to_msecs(jiffies - start_jiffies);
-			if (msecs_blocked >= timeout_msecs) {
-				rc = -ETIMEDOUT;
-				goto out;
-			}
-			timeout_msecs -= msecs_blocked;
-		}
+		down(&ctrl_info->sync_request_sem);
 	}
 
 	pqi_ctrl_busy(ctrl_info);
-	timeout_msecs = pqi_wait_if_ctrl_blocked(ctrl_info, timeout_msecs);
-	if (timeout_msecs == 0) {
-		pqi_ctrl_unbusy(ctrl_info);
-		rc = -ETIMEDOUT;
-		goto out;
-	}
+	if (pqi_is_blockable_request(request))
+		pqi_wait_if_ctrl_blocked(ctrl_info);
 
 	if (pqi_ctrl_offline(ctrl_info)) {
-		pqi_ctrl_unbusy(ctrl_info);
 		rc = -ENXIO;
 		goto out;
 	}
 
-	atomic_inc(&ctrl_info->sync_cmds_outstanding);
-
 	io_request = pqi_alloc_io_request(ctrl_info);
 
 	put_unaligned_le16(io_request->index,
@@ -4219,18 +4230,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
-	pqi_ctrl_unbusy(ctrl_info);
-
-	if (timeout_msecs == NO_TIMEOUT) {
-		pqi_wait_for_completion_io(ctrl_info, &wait);
-	} else {
-		if (!wait_for_completion_io_timeout(&wait,
-			msecs_to_jiffies(timeout_msecs))) {
-			dev_warn(&ctrl_info->pci_dev->dev,
-				"command timed out\n");
-			rc = -ETIMEDOUT;
-		}
-	}
+	pqi_wait_for_completion_io(ctrl_info, &wait);
 
 	if (error_info) {
 		if (io_request->error_info)
@@ -4243,8 +4243,8 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_free_io_request(io_request);
 
-	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 out:
+	pqi_ctrl_unbusy(ctrl_info);
 	up(&ctrl_info->sync_request_sem);
 
 	return rc;
@@ -4281,8 +4281,7 @@ static int pqi_submit_admin_request_synchronous(
 	rc = pqi_poll_for_admin_response(ctrl_info, response);
 
 	if (rc == 0)
-		rc = pqi_validate_admin_response(response,
-			request->function_code);
+		rc = pqi_validate_admin_response(response, request->function_code);
 
 	return rc;
 }
@@ -4652,7 +4651,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+		0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev,
 		request.data.report_event_configuration.sg_descriptors, 1,
@@ -4688,7 +4687,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0,
-		NULL, NO_TIMEOUT);
+		NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev,
 		request.data.report_event_configuration.sg_descriptors, 1,
@@ -5208,12 +5207,6 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
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
@@ -5230,7 +5223,7 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 		return false;
 
 	device = scmd->device->hostdata;
-	if (pqi_device_offline(device))
+	if (pqi_device_offline(device) || pqi_device_in_remove(device))
 		return false;
 
 	ctrl_info = shost_to_hba(scmd->device->host);
@@ -5240,155 +5233,26 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
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
+static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	void *context)
 {
 	struct scsi_cmnd *scmd;
 
 	scmd = io_request->scmd;
+	scsi_dma_unmap(scmd);
+	if (io_request->status == -EAGAIN ||
+		pqi_raid_bypass_retry_needed(io_request))
+			set_host_byte(scmd, DID_IMM_RETRY);
 	pqi_free_io_request(io_request);
 	pqi_scsi_done(scmd);
 }
 
-static void pqi_queue_raid_bypass_retry(struct pqi_io_request *io_request)
+static inline int pqi_aio_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
+	struct pqi_queue_group *queue_group)
 {
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
-static void pqi_aio_io_complete(struct pqi_io_request *io_request,
-	void *context)
-{
-	struct scsi_cmnd *scmd;
-
-	scmd = io_request->scmd;
-	scsi_dma_unmap(scmd);
-	if (io_request->status == -EAGAIN)
-		set_host_byte(scmd, DID_IMM_RETRY);
-	else if (pqi_raid_bypass_retry_needed(io_request)) {
-		pqi_queue_raid_bypass_retry(io_request);
-		return;
-	}
-	pqi_free_io_request(io_request);
-	pqi_scsi_done(scmd);
-}
-
-static inline int pqi_aio_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
-	struct pqi_queue_group *queue_group)
-{
-	return pqi_aio_submit_io(ctrl_info, scmd, device->aio_handle,
-		scmd->cmnd, scmd->cmd_len, queue_group, NULL, false);
+	return pqi_aio_submit_io(ctrl_info, scmd, device->aio_handle,
+		scmd->cmnd, scmd->cmd_len, queue_group, NULL, false);
 }
 
 static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
@@ -5629,6 +5493,14 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 	return hw_queue;
 }
 
+static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
+{
+	if (blk_rq_is_passthrough(scmd->request))
+		return false;
+
+	return scmd->retries == 0;
+}
+
 /*
  * This function gets called just before we hand the completed SCSI request
  * back to the SML.
@@ -5737,7 +5609,6 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	bool raid_bypassed;
 
 	device = scmd->device->hostdata;
-	ctrl_info = shost_to_hba(shost);
 
 	if (!device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5747,15 +5618,15 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 
 	atomic_inc(&device->scsi_cmds_outstanding);
 
+	ctrl_info = shost_to_hba(shost);
+
 	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		pqi_scsi_done(scmd);
 		return 0;
 	}
 
-	pqi_ctrl_busy(ctrl_info);
-	if (pqi_ctrl_blocked(ctrl_info) || pqi_device_in_reset(device) ||
-	    pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info)) {
+	if (pqi_ctrl_blocked(ctrl_info)) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -5772,13 +5643,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
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
@@ -5791,7 +5661,6 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	pqi_ctrl_unbusy(ctrl_info);
 	if (rc)
 		atomic_dec(&device->scsi_cmds_outstanding);
 
@@ -5901,100 +5770,22 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 	}
 }
 
-static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned int i;
-	unsigned int path;
-	struct pqi_queue_group *queue_group;
-	unsigned long flags;
-	struct pqi_io_request *io_request;
-	struct pqi_io_request *next;
-	struct scsi_cmnd *scmd;
-
-	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
-		queue_group = &ctrl_info->queue_groups[i];
-
-		for (path = 0; path < 2; path++) {
-			spin_lock_irqsave(&queue_group->submit_lock[path],
-						flags);
-
-			list_for_each_entry_safe(io_request, next,
-				&queue_group->request_list[path],
-				request_list_entry) {
-
-				scmd = io_request->scmd;
-				if (!scmd)
-					continue;
-
-				list_del(&io_request->request_list_entry);
-				set_host_byte(scmd, DID_RESET);
-				pqi_scsi_done(scmd);
-			}
-
-			spin_unlock_irqrestore(
-				&queue_group->submit_lock[path], flags);
-		}
-	}
-}
-
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, unsigned long timeout_secs)
 {
 	unsigned long timeout;
 
-	timeout = (timeout_secs * PQI_HZ) + jiffies;
-
-	while (atomic_read(&device->scsi_cmds_outstanding)) {
-		pqi_check_ctrl_health(ctrl_info);
-		if (pqi_ctrl_offline(ctrl_info))
-			return -ENXIO;
-		if (timeout_secs != NO_TIMEOUT) {
-			if (time_after(jiffies, timeout)) {
-				dev_err(&ctrl_info->pci_dev->dev,
-					"timed out waiting for pending IO\n");
-				return -ETIMEDOUT;
-			}
-		}
-		usleep_range(1000, 2000);
-	}
-
-	return 0;
-}
-
-static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	unsigned long timeout_secs)
-{
-	bool io_pending;
-	unsigned long flags;
-	unsigned long timeout;
-	struct pqi_scsi_dev *device;
 
 	timeout = (timeout_secs * PQI_HZ) + jiffies;
-	while (1) {
-		io_pending = false;
-
-		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-		list_for_each_entry(device, &ctrl_info->scsi_device_list,
-			scsi_device_list_entry) {
-			if (atomic_read(&device->scsi_cmds_outstanding)) {
-				io_pending = true;
-				break;
-			}
-		}
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-					flags);
-
-		if (!io_pending)
-			break;
 
+	while (atomic_read(&device->scsi_cmds_outstanding)) {
 		pqi_check_ctrl_health(ctrl_info);
 		if (pqi_ctrl_offline(ctrl_info))
 			return -ENXIO;
-
 		if (timeout_secs != NO_TIMEOUT) {
 			if (time_after(jiffies, timeout)) {
 				dev_err(&ctrl_info->pci_dev->dev,
-					"timed out waiting for pending IO\n");
+					"timed out waiting for pending I/O\n");
 				return -ETIMEDOUT;
 			}
 		}
@@ -6004,18 +5795,6 @@ static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
-static int pqi_ctrl_wait_for_pending_sync_cmds(struct pqi_ctrl_info *ctrl_info)
-{
-	while (atomic_read(&ctrl_info->sync_cmds_outstanding)) {
-		pqi_check_ctrl_health(ctrl_info);
-		if (pqi_ctrl_offline(ctrl_info))
-			return -ENXIO;
-		usleep_range(1000, 2000);
-	}
-
-	return 0;
-}
-
 static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 	void *context)
 {
@@ -6087,13 +5866,11 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-/* Performs a reset at the LUN level. */
-
 #define PQI_LUN_RESET_RETRIES			3
 #define PQI_LUN_RESET_RETRY_INTERVAL_MSECS	10000
 #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS	120
 
-static int _pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
+static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
 	int rc;
@@ -6119,23 +5896,15 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 {
 	int rc;
 
-	mutex_lock(&ctrl_info->lun_reset_mutex);
-
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_io_queued_for_device(ctrl_info, device);
 	rc = pqi_wait_until_inbound_queues_empty(ctrl_info);
-	pqi_device_reset_start(device);
-	pqi_ctrl_unblock_requests(ctrl_info);
-
 	if (rc)
 		rc = FAILED;
 	else
-		rc = _pqi_device_reset(ctrl_info, device);
-
-	pqi_device_reset_done(device);
-
-	mutex_unlock(&ctrl_info->lun_reset_mutex);
+		rc = pqi_lun_reset_with_retries(ctrl_info, device);
+	pqi_ctrl_unblock_requests(ctrl_info);
 
 	return rc;
 }
@@ -6151,29 +5920,25 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	ctrl_info = shost_to_hba(shost);
 	device = scmd->device->hostdata;
 
+	mutex_lock(&ctrl_info->lun_reset_mutex);
+
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%d\n",
 		shost->host_no, device->bus, device->target, device->lun);
 
 	pqi_check_ctrl_health(ctrl_info);
-	if (pqi_ctrl_offline(ctrl_info) ||
-		pqi_device_reset_blocked(ctrl_info)) {
+	if (pqi_ctrl_offline(ctrl_info))
 		rc = FAILED;
-		goto out;
-	}
-
-	pqi_wait_until_ofa_finished(ctrl_info);
-
-	atomic_inc(&ctrl_info->sync_cmds_outstanding);
-	rc = pqi_device_reset(ctrl_info, device);
-	atomic_dec(&ctrl_info->sync_cmds_outstanding);
+	else
+		rc = pqi_device_reset(ctrl_info, device);
 
-out:
 	dev_err(&ctrl_info->pci_dev->dev,
 		"reset of scsi %d:%d:%d:%d: %s\n",
 		shost->host_no, device->bus, device->target, device->lun,
 		rc == SUCCESS ? "SUCCESS" : "FAILED");
 
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
+
 	return rc;
 }
 
@@ -6475,7 +6240,7 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 		put_unaligned_le32(iocommand.Request.Timeout, &request.timeout);
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info, NO_TIMEOUT);
+		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info);
 
 	if (iocommand.buf_size > 0)
 		pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
@@ -6527,9 +6292,6 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 
 	ctrl_info = shost_to_hba(sdev->host);
 
-	if (pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info))
-		return -EBUSY;
-
 	switch (cmd) {
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWDISK:
@@ -7076,9 +6838,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 
 	shost = scsi_host_alloc(&pqi_driver_template, sizeof(ctrl_info));
 	if (!shost) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"scsi_host_alloc failed for controller %u\n",
-			ctrl_info->ctrl_id);
+		dev_err(&ctrl_info->pci_dev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -7336,7 +7096,7 @@ static int pqi_config_table_update(struct pqi_ctrl_info *ctrl_info,
 		&request.data.config_table_update.last_section);
 
 	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+		0, NULL);
 }
 
 static int pqi_enable_firmware_features(struct pqi_ctrl_info *ctrl_info,
@@ -7414,7 +7174,8 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		break;
 	case PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE:
 		ctrl_info->soft_reset_handshake_supported =
-			firmware_feature->enabled;
+			firmware_feature->enabled &&
+			ctrl_info->soft_reset_status;
 		break;
 	case PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT:
 		ctrl_info->raid_iu_timeout_supported = firmware_feature->enabled;
@@ -7422,6 +7183,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 	case PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT:
 		ctrl_info->tmf_iu_timeout_supported = firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN:
+		ctrl_info->unique_wwid_in_report_phys_lun_supported =
+			firmware_feature->enabled;
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7512,6 +7277,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME,
 		.feature_status = pqi_firmware_feature_status,
 	},
+	{
+		.feature_name = "Unique WWID in Report Physical LUN",
+		.feature_bit = PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -7596,14 +7366,34 @@ static void pqi_process_firmware_features_section(
 	mutex_unlock(&pqi_firmware_features_mutex);
 }
 
+/*
+ * Reset all controller settings that can be initialized during the processing
+ * of the PQI Configuration Table.
+ */
+
+static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->heartbeat_counter = NULL;
+	ctrl_info->soft_reset_status = NULL;
+	ctrl_info->soft_reset_handshake_supported = false;
+	ctrl_info->enable_r1_writes = false;
+	ctrl_info->enable_r5_writes = false;
+	ctrl_info->enable_r6_writes = false;
+	ctrl_info->raid_iu_timeout_supported = false;
+	ctrl_info->tmf_iu_timeout_supported = false;
+	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
+}
+
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 {
 	u32 table_length;
 	u32 section_offset;
+	bool firmware_feature_section_present;
 	void __iomem *table_iomem_addr;
 	struct pqi_config_table *config_table;
 	struct pqi_config_table_section_header *section;
 	struct pqi_config_table_section_info section_info;
+	struct pqi_config_table_section_info feature_section_info;
 
 	table_length = ctrl_info->config_table_length;
 	if (table_length == 0)
@@ -7623,6 +7413,7 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 	table_iomem_addr = ctrl_info->iomem_base + ctrl_info->config_table_offset;
 	memcpy_fromio(config_table, table_iomem_addr, table_length);
 
+	firmware_feature_section_present = false;
 	section_info.ctrl_info = ctrl_info;
 	section_offset = get_unaligned_le32(&config_table->first_section_offset);
 
@@ -7635,7 +7426,8 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 
 		switch (get_unaligned_le16(&section->section_id)) {
 		case PQI_CONFIG_TABLE_SECTION_FIRMWARE_FEATURES:
-			pqi_process_firmware_features_section(&section_info);
+			firmware_feature_section_present = true;
+			feature_section_info = section_info;
 			break;
 		case PQI_CONFIG_TABLE_SECTION_HEARTBEAT:
 			if (pqi_disable_heartbeat)
@@ -7653,13 +7445,21 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 				table_iomem_addr +
 				section_offset +
 				offsetof(struct pqi_config_table_soft_reset,
-						soft_reset_status);
+					soft_reset_status);
 			break;
 		}
 
 		section_offset = get_unaligned_le16(&section->next_section_offset);
 	}
 
+	/*
+	 * We process the firmware feature section after all other sections
+	 * have been processed so that the feature bit callbacks can take
+	 * into account the settings configured by other sections.
+	 */
+	if (firmware_feature_section_present)
+		pqi_process_firmware_features_section(&feature_section_info);
+
 	kfree(config_table);
 
 	return 0;
@@ -7707,8 +7507,6 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
-#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
-
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -7716,7 +7514,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	if (reset_devices) {
 		sis_soft_reset(ctrl_info);
-		msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
 	} else {
 		rc = pqi_force_sis_mode(ctrl_info);
 		if (rc)
@@ -8026,6 +7824,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->controller_online = true;
 	pqi_ctrl_unblock_requests(ctrl_info);
 
+	pqi_ctrl_reset_config(ctrl_info);
+
 	rc = pqi_process_config_table(ctrl_info);
 	if (rc)
 		return rc;
@@ -8071,7 +7871,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
-	pqi_schedule_update_time_worker(ctrl_info);
+	if (pqi_ofa_in_progress(ctrl_info))
+		pqi_ctrl_unblock_scan(ctrl_info);
 
 	pqi_scan_scsi_devices(ctrl_info);
 
@@ -8184,7 +7985,6 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
-	atomic_set(&ctrl_info->sync_cmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
@@ -8192,15 +7992,13 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	timer_setup(&ctrl_info->heartbeat_timer, pqi_heartbeat_timer_handler, 0);
 	INIT_WORK(&ctrl_info->ctrl_offline_work, pqi_ctrl_offline_worker);
 
+	INIT_WORK(&ctrl_info->ofa_memory_alloc_work, pqi_ofa_memory_alloc_worker);
+	INIT_WORK(&ctrl_info->ofa_quiesce_work, pqi_ofa_quiesce_worker);
+
 	sema_init(&ctrl_info->sync_request_sem,
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
@@ -8265,81 +8063,57 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 
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
-	pqi_ctrl_wait_for_pending_io(ctrl_info, PQI_PENDING_IO_TIMEOUT_SECS);
-	pqi_fail_io_queued_for_all_devices(ctrl_info);
-	pqi_wait_until_inbound_queues_empty(ctrl_info);
 	pqi_stop_heartbeat_timer(ctrl_info);
-	ctrl_info->pqi_mode_enabled = false;
-	pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 }
 
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_ofa_free_host_buffer(ctrl_info);
-	ctrl_info->pqi_mode_enabled = true;
-	pqi_save_ctrl_mode(ctrl_info, PQI_MODE);
-	ctrl_info->controller_online = true;
-	pqi_ctrl_unblock_requests(ctrl_info);
 	pqi_start_heartbeat_timer(ctrl_info);
-	pqi_schedule_update_time_worker(ctrl_info);
-	pqi_clear_soft_reset_status(ctrl_info,
-		PQI_SOFT_RESET_ABORT);
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
 
@@ -8347,82 +8121,87 @@ static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info,
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
 
-	for (chunk_sz = total_size; chunk_sz >= min_chunk_size; chunk_sz /= 2)
-		if (!pqi_ofa_alloc_mem(ctrl_info, total_size, chunk_sz))
+	total_size = PAGE_ALIGN(ctrl_info->ofa_bytes_requested);
+	min_chunk_size = DIV_ROUND_UP(total_size, PQI_OFA_MAX_SG_DESCRIPTORS);
+	min_chunk_size = PAGE_ALIGN(min_chunk_size);
+
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
@@ -8430,47 +8209,46 @@ static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
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
 
 	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+		0, NULL);
 }
 
-static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info)
+static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs)
 {
-	msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+	ssleep(delay_secs);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
@@ -8528,7 +8306,6 @@ static void pqi_take_ctrl_offline_deferred(struct pqi_ctrl_info *ctrl_info)
 	pqi_cancel_update_time_worker(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_all_outstanding_requests(ctrl_info);
-	pqi_clear_all_queued_raid_bypass_retries(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
 }
 
@@ -8661,24 +8438,12 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 		return;
 	}
 
-	pqi_disable_events(ctrl_info);
 	pqi_wait_until_ofa_finished(ctrl_info);
-	pqi_cancel_update_time_worker(ctrl_info);
-	pqi_cancel_rescan_worker(ctrl_info);
-	pqi_cancel_event_worker(ctrl_info);
-
-	pqi_ctrl_shutdown_start(ctrl_info);
-	pqi_ctrl_wait_until_quiesced(ctrl_info);
-
-	rc = pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
-	if (rc) {
-		dev_err(&pci_dev->dev,
-			"wait for pending I/O failed\n");
-		return;
-	}
 
+	pqi_scsi_block_requests(ctrl_info);
 	pqi_ctrl_block_device_reset(ctrl_info);
-	pqi_wait_until_lun_reset_finished(ctrl_info);
+	pqi_ctrl_block_requests(ctrl_info);
+	pqi_ctrl_wait_until_quiesced(ctrl_info);
 
 	/*
 	 * Write all data in the controller's battery-backed cache to
@@ -8689,15 +8454,6 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 		dev_err(&pci_dev->dev,
 			"unable to flush controller cache\n");
 
-	pqi_ctrl_block_requests(ctrl_info);
-
-	rc = pqi_ctrl_wait_for_pending_sync_cmds(ctrl_info);
-	if (rc) {
-		dev_err(&pci_dev->dev,
-			"wait for pending sync cmds failed\n");
-		return;
-	}
-
 	pqi_crash_if_pending_command(ctrl_info);
 	pqi_reset(ctrl_info);
 }
@@ -8732,19 +8488,18 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 
 	ctrl_info = pci_get_drvdata(pci_dev);
 
-	pqi_disable_events(ctrl_info);
-	pqi_cancel_update_time_worker(ctrl_info);
-	pqi_cancel_rescan_worker(ctrl_info);
-	pqi_wait_until_scan_finished(ctrl_info);
-	pqi_wait_until_lun_reset_finished(ctrl_info);
 	pqi_wait_until_ofa_finished(ctrl_info);
-	pqi_flush_cache(ctrl_info, SUSPEND);
+
+	pqi_ctrl_block_scan(ctrl_info);
+	pqi_scsi_block_requests(ctrl_info);
+	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
-	pqi_wait_until_inbound_queues_empty(ctrl_info);
-	pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
+	pqi_flush_cache(ctrl_info, SUSPEND);
 	pqi_stop_heartbeat_timer(ctrl_info);
 
+	pqi_crash_if_pending_command(ctrl_info);
+
 	if (state.event == PM_EVENT_FREEZE)
 		return 0;
 
@@ -8777,8 +8532,10 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 				pci_dev->irq, rc);
 			return rc;
 		}
-		pqi_start_heartbeat_timer(ctrl_info);
+		pqi_ctrl_unblock_device_reset(ctrl_info);
 		pqi_ctrl_unblock_requests(ctrl_info);
+		pqi_scsi_unblock_requests(ctrl_info);
+		pqi_ctrl_unblock_scan(ctrl_info);
 		return 0;
 	}
 
@@ -9219,7 +8976,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
 		response_queue_id) != 0x4);
 	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		work_area) != 0x6);
+		driver_flags) != 0x6);
 	BUILD_BUG_ON(sizeof(struct pqi_iu_header) != 0x8);
 
 	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
@@ -9317,7 +9074,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
 		header.iu_length) != 2);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
@@ -9373,7 +9130,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
 		header.iu_length) != 2);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
@@ -9397,7 +9154,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		header.response_queue_id) != 4);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
@@ -9426,7 +9183,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
 		header.response_queue_id) != 4);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,

