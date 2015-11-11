From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 07/25] mpt2sas, mpt3sas : Removed SCSI_MPTXSAS_LOGGING entry from Kconfig
Date: Wed, 11 Nov 2015 17:30:23 +0530
Message-ID: <1447243241-10912-8-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Currently there is a logging level option provided for user for each of our
drivers in the kernel configuration utility. They can enable this option to
get more verbose information. By default this is enabled.

When this option is enabled then those functions which displays the
required information will also get compiled otherwise these functions
won't be included in the compilation code and so won't get compiled.

Now as we are merging the both the driver code, so now we can't
provide these option to the user. So removing SCSI_MPTXSAS_LOGGING
entry from Kconfig files and completely enable this logging option
(by removing the #ifdef CONFIG_SCSI_MPT3SAS_LOGGING preprocessor
check conditions), so that all the functions which are defined to
display more verbos will also get compiled.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/Kconfig          |  6 ------
 drivers/scsi/mpt3sas/Kconfig          |  6 ------
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 10 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_config.c |  6 ------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 10 +--------
 drivers/scsi/mpt3sas/mpt3sas_debug.h  | 16 +-------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 39 ++++-------------------------------
 7 files changed, 10 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/mpt2sas/Kconfig b/drivers/scsi/mpt2sas/Kconfig
index 657b45c..1356a0a 100644
--- a/drivers/scsi/mpt2sas/Kconfig
+++ b/drivers/scsi/mpt2sas/Kconfig
@@ -59,9 +59,3 @@ config SCSI_MPT2SAS_MAX_SGE
 	SAFE_PHYS_SEGMENTS.  However, it may decreased down to 16.
 	Decreasing this parameter will reduce memory requirements
 	on a per controller instance.
-
-config SCSI_MPT2SAS_LOGGING
-	bool "LSI MPT Fusion logging facility"
-	depends on PCI && SCSI && SCSI_MPT2SAS
-	---help---
-	This turns on a logging facility.
diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 4d235dd..18b64bc 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -59,9 +59,3 @@ config SCSI_MPT3SAS_MAX_SGE
 	MAX_PHYS_SEGMENTS in most kernels.  However in SuSE kernels this
 	can be 256. However, it may decreased down to 16.  Decreasing this
 	parameter will reduce memory requirements on a per controller instance.
-
-config SCSI_MPT3SAS_LOGGING
-	bool "LSI MPT Fusion logging facility"
-	depends on PCI && SCSI && SCSI_MPT3SAS
-	---help---
-	This turns on a logging facility.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8a7f93e..31d0ca8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -324,7 +324,6 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
 		panic("panic in %s\n", __func__);
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _base_sas_ioc_info - verbose translation of the ioc status
  * @ioc: per adapter object
@@ -630,7 +629,6 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 
 	pr_info(MPT3SAS_FMT "%s\n", ioc->name, desc);
 }
-#endif
 
 /**
  * _base_sas_log_info - verbose translation of firmware log info
@@ -710,13 +708,13 @@ _base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		return;
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+
 	if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
 	    (ioc->logging_level & MPT_DEBUG_REPLY)) {
 		_base_sas_ioc_info(ioc , mpi_reply,
 		   mpt3sas_base_get_msg_frame(ioc, smid));
 	}
-#endif
+
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
 		loginfo = le32_to_cpu(mpi_reply->IOCLogInfo);
 		_base_sas_log_info(ioc, loginfo);
@@ -783,9 +781,9 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 		return 1;
 	if (mpi_reply->Function != MPI2_FUNCTION_EVENT_NOTIFICATION)
 		return 1;
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+
 	_base_display_event_data(ioc, mpi_reply);
-#endif
+
 	if (!(mpi_reply->AckRequired & MPI2_EVENT_NOTIFICATION_ACK_REQUIRED))
 		goto out;
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index e45c461..53eb701 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -83,7 +83,6 @@ struct config_request {
 	dma_addr_t		page_dma;
 };
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _config_display_some_debug - debug routine
  * @ioc: per adapter object
@@ -173,7 +172,6 @@ _config_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
 		    le32_to_cpu(mpi_reply->IOCLogInfo));
 }
-#endif
 
 /**
  * _config_alloc_config_dma_memory - obtain physical memory
@@ -255,9 +253,7 @@ mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		    mpi_reply->MsgLength*4);
 	}
 	ioc->config_cmds.status &= ~MPT3_CMD_PENDING;
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
-#endif
 	ioc->config_cmds.smid = USHRT_MAX;
 	complete(&ioc->config_cmds.done);
 	return 1;
@@ -387,9 +383,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	config_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->config_cmds.smid = smid;
 	memcpy(config_request, mpi_request, sizeof(Mpi2ConfigRequest_t));
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
-#endif
 	init_completion(&ioc->config_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8b46cbf..5c08d31 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -78,7 +78,6 @@ enum block_state {
 	BLOCKING,
 };
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _ctl_sas_device_find_by_handle - sas device search
  * @ioc: per adapter object
@@ -254,8 +253,6 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	}
 }
 
-#endif
-
 /**
  * mpt3sas_ctl_done - ctl module completion routine
  * @ioc: per adapter object
@@ -302,9 +299,7 @@ mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 			}
 		}
 	}
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	_ctl_display_some_debug(ioc, smid, "ctl_done", mpi_reply);
-#endif
 	ioc->ctl_cmds.status &= ~MPT3_CMD_PENDING;
 	complete(&ioc->ctl_cmds.done);
 	return 1;
@@ -759,9 +754,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	psge = (void *)request + (karg.data_sge_offset*4);
 
 	/* send command to firmware */
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	_ctl_display_some_debug(ioc, smid, "ctl_request", NULL);
-#endif
 
 	init_completion(&ioc->ctl_cmds.done);
 	switch (mpi_request->Function) {
@@ -916,7 +909,6 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	mpi_reply = ioc->ctl_cmds.reply;
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (mpi_reply->Function == MPI2_FUNCTION_SCSI_TASK_MGMT &&
 	    (ioc->logging_level & MPT_DEBUG_TM)) {
 		Mpi2SCSITaskManagementReply_t *tm_reply =
@@ -929,7 +921,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		    le32_to_cpu(tm_reply->IOCLogInfo),
 		    le32_to_cpu(tm_reply->TerminationCount));
 	}
-#endif
+
 	/* copy out xdata to user */
 	if (data_in_sz) {
 		if (copy_to_user(karg.data_in_buf_ptr, data_in,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_debug.h b/drivers/scsi/mpt3sas/mpt3sas_debug.h
index 4e8a63f..cceeb2c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debug.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_debug.h
@@ -68,20 +68,11 @@
 #define MPT_DEBUG_TRIGGER_DIAG		0x00200000
 
 
-/*
- * CONFIG_SCSI_MPT3SAS_LOGGING - enabled in Kconfig
- */
-
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 #define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
 {								\
 	if (IOC->logging_level & BITS)				\
 		CMD;						\
 }
-#else
-#define MPT_CHECK_LOGGING(IOC, CMD, BITS)
-#endif /* CONFIG_SCSI_MPT3SAS_LOGGING */
-
 
 /*
  * debug macros
@@ -153,7 +144,7 @@
 
 
 /* inline functions for dumping debug data*/
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+
 /**
  * _debug_dump_mf - print message frame contents
  * @mpi_request: pointer to message frame
@@ -211,10 +202,5 @@ _debug_dump_config(void *mpi_request, int sz)
 	}
 	pr_info("\n");
 }
-#else
-#define _debug_dump_mf(mpi_request, sz)
-#define _debug_dump_reply(mpi_request, sz)
-#define _debug_dump_config(mpi_request, sz)
-#endif /* CONFIG_SCSI_MPT3SAS_LOGGING */
 
 #endif /* MPT3SAS_DEBUG_H_INCLUDED */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 233627d..a638920 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3624,10 +3624,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	u16 smid;
 	u16 handle;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
-#endif
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
@@ -3758,7 +3756,6 @@ _scsih_normalize_sense(char *sense_buffer, struct sense_info *data)
 	}
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_scsi_ioc_info - translated non-succesfull SCSI_IO request
  * @ioc: per adapter object
@@ -3971,7 +3968,6 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		_scsih_response_code(ioc, response_bytes[0]);
 	}
 }
-#endif
 
 /**
  * _scsih_turn_on_pfa_led - illuminate PFA LED
@@ -4239,13 +4235,11 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 		if (!(ioc->logging_level & MPT_DEBUG_REPLY) &&
 		     ((scmd->sense_buffer[2] == UNIT_ATTENTION) ||
 		     (scmd->sense_buffer[2] == MEDIUM_ERROR) ||
 		     (scmd->sense_buffer[2] == HARDWARE_ERROR)))
 			_scsih_scsi_ioc_info(ioc, scmd, mpi_reply, smid);
-#endif
 	}
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_BUSY:
@@ -4352,10 +4346,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 
 	}
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (scmd->result && (ioc->logging_level & MPT_DEBUG_REPLY))
 		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
-#endif
 
  out:
 
@@ -5152,7 +5144,6 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 	kfree(sas_device);
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_sas_topology_change_event_debug - debug for topology event
  * @ioc: per adapter object
@@ -5230,7 +5221,6 @@ _scsih_sas_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 
 	}
 }
-#endif
 
 /**
  * _scsih_sas_topology_change_event - handle topology changes
@@ -5255,10 +5245,8 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 		(Mpi2EventDataSasTopologyChangeList_t *)
 		fw_event->event_data;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_topology_change_event_debug(ioc, event_data);
-#endif
 
 	if (ioc->shost_recovery || ioc->remove_host || ioc->pci_error_recovery)
 		return 0;
@@ -5364,7 +5352,6 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	return 0;
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_sas_device_status_change_event_debug - debug for device event
  * @event_data: event data payload
@@ -5432,7 +5419,6 @@ _scsih_sas_device_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		    event_data->ASC, event_data->ASCQ);
 	pr_info("\n");
 }
-#endif
 
 /**
  * _scsih_sas_device_status_change_event - handle device status change
@@ -5454,11 +5440,9 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 		(Mpi2EventDataSasDeviceStatusChange_t *)
 		fw_event->event_data;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_device_status_change_event_debug(ioc,
 		     event_data);
-#endif
 
 	/* In MPI Revision K (0xC), the internal device reset complete was
 	 * implemented, so avoid setting tm_busy flag for older firmware.
@@ -5496,7 +5480,6 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_sas_enclosure_dev_status_change_event_debug - debug for enclosure
  * event
@@ -5531,7 +5514,6 @@ _scsih_sas_enclosure_dev_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 	    (unsigned long long)le64_to_cpu(event_data->EnclosureLogicalID),
 	    le16_to_cpu(event_data->StartSlot));
 }
-#endif
 
 /**
  * _scsih_sas_enclosure_dev_status_change_event - handle enclosure events
@@ -5545,12 +5527,10 @@ static void
 _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
 		     (Mpi2EventDataSasEnclDevStatusChange_t *)
 		     fw_event->event_data);
-#endif
 }
 
 /**
@@ -5730,17 +5710,15 @@ _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventDataSasDiscovery_t *event_data =
 		(Mpi2EventDataSasDiscovery_t *) fw_event->event_data;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
 		pr_info(MPT3SAS_FMT "discovery event: (%s)", ioc->name,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
-	if (event_data->DiscoveryStatus)
-		pr_info("discovery_status(0x%08x)",
-		    le32_to_cpu(event_data->DiscoveryStatus));
-	pr_info("\n");
+		if (event_data->DiscoveryStatus)
+			pr_info("discovery_status(0x%08x)",
+			    le32_to_cpu(event_data->DiscoveryStatus));
+		pr_info("\n");
 	}
-#endif
 
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED &&
 	    !ioc->sas_hba.num_phys) {
@@ -6117,7 +6095,6 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 	_scsih_add_device(ioc, handle, 0, 1);
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_sas_ir_config_change_event_debug - debug for IR Config Change events
  * @ioc: per adapter object
@@ -6197,7 +6174,6 @@ _scsih_sas_ir_config_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		    element->PhysDiskNum);
 	}
 }
-#endif
 
 /**
  * _scsih_sas_ir_config_change_event - handle ir configuration change events
@@ -6218,12 +6194,9 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 		(Mpi2EventDataIrConfigChangeList_t *)
 		fw_event->event_data;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_ir_config_change_event_debug(ioc, event_data);
 
-#endif
-
 	foreign_config = (le32_to_cpu(event_data->Flags) &
 	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? 1 : 0;
 
@@ -6435,7 +6408,6 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 /**
  * _scsih_sas_ir_operation_status_event_debug - debug for IR op event
  * @ioc: per adapter object
@@ -6477,7 +6449,6 @@ _scsih_sas_ir_operation_status_event_debug(struct MPT3SAS_ADAPTER *ioc,
 	    le16_to_cpu(event_data->VolDevHandle),
 	    event_data->PercentComplete);
 }
-#endif
 
 /**
  * _scsih_sas_ir_operation_status_event - handle RAID operation events
@@ -6498,11 +6469,9 @@ _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
 	unsigned long flags;
 	u16 handle;
 
-#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_ir_operation_status_event_debug(ioc,
 		     event_data);
-#endif
 
 	/* code added for raid transport support */
 	if (event_data->RAIDOperation == MPI2_EVENT_IR_RAIDOP_RESYNC) {
-- 
2.0.2
