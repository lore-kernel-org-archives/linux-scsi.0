From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V5 08/11] megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth
Date: Wed, 14 Dec 2016 17:13:05 -0500
Message-ID: <1481753588-101811-9-git-send-email-sasikumar.pc@broadcom.com>
References: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Large SEQ IO workload should sent as non fast path commands

This patch is depending on patch 7
This patch is same as V4 and there is no specific update for V5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  8 +++++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 48 +++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  6 ++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 20 +++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +-
 5 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 6ddf994..0696903 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
 #define MFI_1068_FW_HANDSHAKE_OFFSET		0x64
 #define MFI_1068_FW_READY			0xDDDD0000
 
+#define MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL HZ
+
 #define MR_MAX_REPLY_QUEUES_OFFSET              0X0000001F
 #define MR_MAX_REPLY_QUEUES_EXT_OFFSET          0X003FC000
 #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
@@ -2101,6 +2103,10 @@ struct megasas_instance {
 	atomic_t ldio_outstanding;
 	atomic_t fw_reset_no_pci_access;
 
+	atomic64_t bytes_wrote; /* used for raid1 fast path enable or disable */
+	atomic_t r1_write_fp_capable;
+
+
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
 	struct work_struct work_init;
@@ -2142,6 +2148,7 @@ struct megasas_instance {
 	long reset_flags;
 	struct mutex reset_mutex;
 	struct timer_list sriov_heartbeat_timer;
+	struct timer_list r1_fp_hold_timer;
 	char skip_heartbeat_timer_del;
 	u8 requestorId;
 	char PlasmaFW111;
@@ -2158,6 +2165,7 @@ struct megasas_instance {
 	bool is_ventura;
 	bool msix_combined;
 	u16 max_raid_mapsize;
+	u64 pci_threshold_bandwidth; /* used to control the fp writes */
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4518ffc..15a894b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1940,6 +1940,9 @@ void megaraid_sas_kill_hba(struct megasas_instance *instance)
 	}
 	/* Complete outstanding ioctls when adapter is killed */
 	megasas_complete_outstanding_ioctls(instance);
+	if (instance->is_ventura)
+		del_timer_sync(&instance->r1_fp_hold_timer);
+
 }
 
  /**
@@ -2438,6 +2441,24 @@ void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
 	}
 }
 
+/*Handler for disabling/enabling raid 1 fast paths*/
+void megasas_change_r1_fp_status(unsigned long instance_addr)
+{
+	struct megasas_instance *instance =
+			(struct megasas_instance *)instance_addr;
+	if (atomic64_read(&instance->bytes_wrote) >=
+					instance->pci_threshold_bandwidth) {
+
+		atomic64_set(&instance->bytes_wrote, 0);
+		atomic_set(&instance->r1_write_fp_capable, 0);
+	} else {
+		atomic64_set(&instance->bytes_wrote, 0);
+		atomic_set(&instance->r1_write_fp_capable, 1);
+	}
+	mod_timer(&instance->r1_fp_hold_timer,
+	 jiffies + MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
+}
+
 /**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
@@ -5357,6 +5378,17 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			instance->skip_heartbeat_timer_del = 1;
 	}
 
+	if (instance->is_ventura) {
+		atomic64_set(&instance->bytes_wrote, 0);
+		atomic_set(&instance->r1_write_fp_capable, 1);
+		megasas_start_timer(instance,
+			    &instance->r1_fp_hold_timer,
+			    megasas_change_r1_fp_status,
+			    MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
+				dev_info(&instance->pdev->dev, "starting the raid 1 fp timer with interval %d\n",
+				MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
+	}
+
 	return 0;
 
 fail_get_ld_pd_list:
@@ -6147,6 +6179,9 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 
+	if (instance->is_ventura)
+		del_timer_sync(&instance->r1_fp_hold_timer);
+
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
 
@@ -6273,6 +6308,16 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	megasas_setup_jbod_map(instance);
 	instance->unload = 0;
 
+	if (instance->is_ventura) {
+		atomic64_set(&instance->bytes_wrote, 0);
+		atomic_set(&instance->r1_write_fp_capable, 1);
+		megasas_start_timer(instance,
+			    &instance->r1_fp_hold_timer,
+			    megasas_change_r1_fp_status,
+			    MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
+	}
+
+
 	/*
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
@@ -6361,6 +6406,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 
+	if (instance->is_ventura)
+		del_timer_sync(&instance->r1_fp_hold_timer);
+
 	if (instance->fw_crash_state != UNAVAILABLE)
 		megasas_free_host_crash_buffer(instance);
 	scsi_remove_host(instance->host);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index dd9639b..6db892a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -197,9 +197,13 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 
 	if (instance->max_raid_mapsize) {
 		fw_map_dyn = fusion->ld_map[(instance->map_id & 1)];
+		if (fw_map_dyn->pci_threshold_bandwidth)
+			instance->pci_threshold_bandwidth =
+			le64_to_cpu(fw_map_dyn->pci_threshold_bandwidth);
 #if VD_EXT_DEBUG
 		dev_dbg(&instance->pdev->dev, "raidMapSize 0x%x fw_map_dyn->descTableOffset 0x%x\n", le32_to_cpu(fw_map_dyn->raid_map_size), le32_to_cpu(fw_map_dyn->desc_table_offset));
 		dev_dbg(&instance->pdev->dev, "descTableSize 0x%x descTableNumElements 0x%x\n", le32_to_cpu(fw_map_dyn->desc_table_size), le32_to_cpu(fw_map_dyn->desc_table_num_elements));
+		dev_dbg(&instance->pdev->dev, "PCIThreasholdBandwidth %llu\n", instance->pci_threshold_bandwidth);
 		dev_dbg(&instance->pdev->dev, "drv map %p ldCount %d\n", drv_map, fw_map_dyn->ld_count);
 #endif
 		desc_table =
@@ -387,6 +391,8 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			sizeof(struct MR_DEV_HANDLE_INFO) *
 			MAX_RAIDMAP_PHYSICAL_DEVICES);
 	}
+	if (instance->is_ventura && !instance->pci_threshold_bandwidth)
+		instance->pci_threshold_bandwidth = ULLONG_MAX;
 }
 
 /*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5ef35b2..9b08de7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -95,6 +95,7 @@ void megasas_start_timer(struct megasas_instance *instance,
 extern unsigned int dual_qdepth_disable;
 static void megasas_free_rdpq_fusion(struct megasas_instance *instance);
 static void megasas_free_reply_fusion(struct megasas_instance *instance);
+void megasas_change_r1_fp_status(unsigned long instance_addr);
 
 
 
@@ -2620,8 +2621,9 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 	*	to get new command
 	*/
 	if (cmd->is_raid_1_fp_write &&
-		atomic_inc_return(&instance->fw_outstanding) >
-			(instance->host->can_queue)) {
+		(atomic_inc_return(&instance->fw_outstanding) >
+			(instance->host->can_queue) ||
+		(!atomic_read(&instance->r1_write_fp_capable)))) {
 		megasas_fpio_to_ldio(instance, cmd, cmd->scmd);
 		atomic_dec(&instance->fw_outstanding);
 	} else if (cmd->is_raid_1_fp_write) {
@@ -2630,17 +2632,19 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
-
 	/*
-	 * Issue the command to the FW
-	 */
+	* Issue the command to the FW
+	*/
+	if (scmd->sc_data_direction == PCI_DMA_TODEVICE && instance->is_ventura)
+		atomic64_add(scsi_bufflen(scmd), &instance->bytes_wrote);
 
 	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
 
-	if (r1_cmd)
+	if (r1_cmd) {
+		atomic64_add(scsi_bufflen(scmd), &instance->bytes_wrote);
 		megasas_fire_cmd_fusion(instance, r1_cmd->request_desc,
-				instance->is_ventura);
-
+			instance->is_ventura);
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 1994207..915af59 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -977,7 +977,7 @@ struct MR_FW_RAID_MAP_DYNAMIC {
 	u32 desc_table_size;  /* Total Size of desc table */
 	/* Total Number of elements in the desc table */
 	u32 desc_table_num_elements;
-	u64	reserved1;
+	u64	pci_threshold_bandwidth;
 	u32	reserved2[3];	/*future use */
 	/* timeout value used by driver in FP IOs */
 	u8 fp_pd_io_timeout_sec;
-- 
1.8.3.1
