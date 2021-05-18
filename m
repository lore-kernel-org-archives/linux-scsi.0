Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB56C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 05:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DADE6108B
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 05:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhERFSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 01:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbhERFS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 01:18:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C22C061761
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 22:16:48 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z4so2235827plg.8
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 22:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=etDO7OhrNjXlj5g3kNEPybFgcL/12rYoEL4iG+TRmpg=;
        b=MU5gsEnmzwJMln74h3bdRMI6kIoJO6mSNdDAu+BpUfEtyRnh6ltiFXEQ7H9R2Mda19
         y4oPPpBiVSdu2HPdncVuUhNeofXOIzjJpen8ZxIRqXLTpX8pO0nPmLq0TLmI5a3MZdbY
         tnzMmCBqUukoAX384E3AgfRGwPz5av9yyxDv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=etDO7OhrNjXlj5g3kNEPybFgcL/12rYoEL4iG+TRmpg=;
        b=oRZ4PxL+lD9r8fHMDGwN31TtWMV8ERg9fGpQ82VYG6kHMB8uM+jigUspEdVZt4oa92
         yiYTmYo8dvudRJ9MvzvXhQ7Q4LO2lbNYhLhDSZVvJHVqkge1AjbErtUhmx5ddjsF4MkT
         CTERrpAmv44nD9ZeQKbODhkf25tiA9Wz/W+9Ro8KfWj7xoBN5z1MThGSFrN+iiA6IZXJ
         IPg1yr15CmcQ5vVIvDO2sJepptXgQ7M3qcgrTrESnioL0GYo+EJzs+hyLHr9T4ulnXzC
         OxSRKv7SdRBP/AzQfpo1k2BfGCW5WkLe7NwtowEem+rE0RDV13OpsvVSqufUCpZ32jaL
         LACg==
X-Gm-Message-State: AOAM533cOIbmSj86+fZpwkNwhMvdy/pqDEnDd9ph1qYQGaKfpPd+YZTT
        ckxtaB/VindDxFLlJpFOP4mXz/tXka3L74Lk0pDzZgTg8wDSqqW7DYXuSKRMpCScp+5a3cKEsFM
        ENiIpsWhETdSkaCDOOWiviS/xsB8lNOlA7LQJJ79APL0bI8R2nQif0/+jGKtXev+HwKX1OOSfIP
        G2R6mlrapVxveu7PW4La6k
X-Google-Smtp-Source: ABdhPJyvjonk1znM4LsTc6xguWW4FH0q0ELRjQMXHMwHiyWj+zhuOycic+MXMqsZzH5RbCl+iwY+pA==
X-Received: by 2002:a17:902:9348:b029:f0:d51a:7a4c with SMTP id g8-20020a1709029348b02900f0d51a7a4cmr2554964plp.60.1621315006717;
        Mon, 17 May 2021 22:16:46 -0700 (PDT)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id hk15sm437556pjb.53.2021.05.17.22.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:16:46 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [Patch 3/3] mpt3sas: Handle FWfault while second half of IOC Init
Date:   Tue, 18 May 2021 10:46:25 +0530
Message-Id: <20210518051625.1596742-4-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
References: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000016698405c293d15b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000016698405c293d15b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if any firmware fault occurs while scanning the devices during
IOC Initialization then the driver issues the hard reset operation to
recover the IOC. But driver is not issuing Port enable request
message as part of hard reset operation during IOC initialization time.
Due to this driver won't get any device discovery related events and
hence devices won't be accessible to the users.

Through this patch, the driver gracefully handles the Firmware
fault while scanning the target devices during IOC initialization time,
by allowing the driver to issue the port enable request message as part
of hard reset operation during IOC initialization time. So that driver
receives the device discovery related events from the firmware after the
hard reset operation and target devices are added to SML.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 152 ++++++++++++++++++++++++---
 3 files changed, 145 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 97e63a5..e592b1a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7205,7 +7205,7 @@ mpt3sas_port_enable_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 		ioc->port_enable_failed = 1;
 
-	if (ioc->is_driver_loading) {
+	if (ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE_ASYNC) {
 		if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 			mpt3sas_port_enable_complete(ioc);
 			return 1;
@@ -7214,6 +7214,7 @@ mpt3sas_port_enable_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 			ioc->start_scan = 0;
 			return 1;
 		}
+		ioc->port_enable_cmds.status &= ~MPT3_CMD_COMPLETE_ASYNC;
 	}
 	complete(&ioc->port_enable_cmds.done);
 	return 1;
@@ -7308,6 +7309,7 @@ mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	}
 	ioc->drv_internal_flags |= MPT_DRV_INERNAL_FIRST_PE_ISSUED;
 	ioc->port_enable_cmds.status = MPT3_CMD_PENDING;
+	ioc->port_enable_cmds.status |= MPT3_CMD_COMPLETE_ASYNC;
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->port_enable_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2PortEnableRequest_t));
@@ -7856,7 +7858,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		return r;
 
-	if (ioc->is_driver_loading) {
+	if (!ioc->shost_recovery) {
 
 		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
 		    == 0x80) {
@@ -8276,8 +8278,6 @@ _base_clear_outstanding_mpt_commands(struct MPT3SAS_ADAPTER *ioc)
 			ioc->start_scan_failed =
 				MPI2_IOCSTATUS_INTERNAL_ERROR;
 			ioc->start_scan = 0;
-			ioc->port_enable_cmds.status =
-				MPT3_CMD_NOT_USED;
 		} else {
 			complete(&ioc->port_enable_cmds.done);
 		}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a8100a9..020f411 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -500,6 +500,7 @@ struct MPT3SAS_DEVICE {
 #define MPT3_CMD_PENDING	0x0002	/* pending */
 #define MPT3_CMD_REPLY_VALID	0x0004	/* reply is valid */
 #define MPT3_CMD_RESET		0x0008	/* host reset dropped the command */
+#define MPT3_CMD_COMPLETE_ASYNC 0x0010  /* tells whether cmd completes in same thread or not */
 
 /**
  * struct _internal_cmd - internal commands struct
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 79e34b5..0d8b2e9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -78,6 +78,7 @@ static void _scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
 static void
 _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
+static void _scsih_complete_devices_scanning(struct MPT3SAS_ADAPTER *ioc);
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
@@ -3631,8 +3632,6 @@ _scsih_error_recovery_delete_devices(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
 
-	if (ioc->is_driver_loading)
-		return;
 	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
@@ -3693,6 +3692,14 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
 	    !ioc->firmware_event_thread)
 		return;
+	/*
+	 * Set current running event as ignore, so that
+	 * current running event will be exit quickely.
+	 * As diag reset has occurred, so it is of no use
+	 * to proccess remaing stale even data enties.
+	 */
+	if (ioc->shost_recovery && ioc->current_event)
+		ioc->current_event->ignore = 1;
 
 	ioc->fw_events_cleanup = 1;
 	while ((fw_event = dequeue_next_fw_event(ioc)) ||
@@ -3719,6 +3726,19 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		}
 
+		/*
+		 * Driver has to clear ioc->start_scan flag when
+		 * it is cleanup the MPT3SAS_PORT_ENABLE_COMPLETE,
+		 * otherwise scsi_scan_host() API waits still
+		 * 5 mints timeout timer to expire. If we exit from
+		 * scsi_scan_host() quickly then we can smoothly issue
+		 * new port enable request as part of current diag reset.
+		 */
+		if (fw_event->event == MPT3SAS_PORT_ENABLE_COMPLETE) {
+			ioc->port_enable_cmds.status |= MPT3_CMD_RESET;
+			ioc->start_scan = 0;
+		}
+
 		/*
 		 * Wait on the fw_event to complete. If this returns 1, then
 		 * the event was never executed, and we need a put for the
@@ -10140,6 +10160,17 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	 * owner for the reference the list had on any object we prune.
 	 */
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+
+	/*
+	 * Cleanup the sas_device_init_list list as
+	 * driver goes for fresh scan as part of diag reset.
+	 */
+	list_for_each_entry_safe(sas_device, sas_device_next,
+	    &ioc->sas_device_init_list, list) {
+		list_del_init(&sas_device->list);
+		sas_device_put(sas_device);
+	}
+
 	list_for_each_entry_safe(sas_device, sas_device_next,
 	    &ioc->sas_device_list, list) {
 		if (!sas_device->responding)
@@ -10161,6 +10192,16 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	ioc_info(ioc, "Removing unresponding devices: pcie end-devices\n");
 	INIT_LIST_HEAD(&head);
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	/*
+	 * Cleanup the pcie_device_init_list list as
+	 * driver goes for fresh scan as part of diag reset.
+	 */
+	list_for_each_entry_safe(pcie_device, pcie_device_next,
+	    &ioc->pcie_device_init_list, list) {
+		list_del_init(&pcie_device->list);
+		pcie_device_put(pcie_device);
+	}
+
 	list_for_each_entry_safe(pcie_device, pcie_device_next,
 	    &ioc->pcie_device_list, list) {
 		if (!pcie_device->responding)
@@ -10563,8 +10604,7 @@ void
 mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 {
 	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
-	if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
-					   !ioc->sas_hba.num_phys)) {
+	if (!(disable_discovery > 0 && !ioc->sas_hba.num_phys)) {
 		if (ioc->multipath_on_hba) {
 			_scsih_sas_port_refresh(ioc);
 			_scsih_update_vphys_after_reset(ioc);
@@ -10619,6 +10659,18 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		_scsih_del_dirty_vphy(ioc);
 		_scsih_del_dirty_port_entries(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
+		/*
+		 * If diag reset has occurred during the driver load
+		 * then driver has to complete the driver load operation
+		 * by executing below items,
+		 *- Register the devices from sas_device_init_list to SML
+		 *- clear is_driver_loading flag,
+		 *- start the watchdog thread.
+		 * In happy driver load path, above things are taken care when
+		 * driver executes scsih_scan_finished().
+		 */
+		if (ioc->is_driver_loading)
+			_scsih_complete_devices_scanning(ioc);
 		_scsih_set_nvme_max_shutdown_latency(ioc);
 		break;
 	case MPT3SAS_PORT_ENABLE_COMPLETE:
@@ -10764,11 +10816,23 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		_scsih_check_topo_delete_events(ioc,
 		    (Mpi2EventDataSasTopologyChangeList_t *)
 		    mpi_reply->EventData);
+		/*
+		 * No need to add the topology change list
+		 * event to fw event work queue when
+		 * diag reset is going on. Since during diag
+		 * reset driver scan the devices by reading
+		 * sas device page0's not by processing the
+		 * events.
+		 */
+		if (ioc->shost_recovery)
+			return 1;
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 	_scsih_check_pcie_topo_remove_events(ioc,
 		    (Mpi26EventDataPCIeTopologyChangeList_t *)
 		    mpi_reply->EventData);
+		if (ioc->shost_recovery)
+			return 1;
 		break;
 	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
 		_scsih_check_ir_config_unhide_events(ioc,
@@ -11284,13 +11348,27 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 
 	if (channel == RAID_CHANNEL) {
 		raid_device = device;
+		/*
+		 * If this boot vd is already registered with SML then
+		 * no need to register it again as part of device scanning
+		 * after diag reset during driver load operation.
+		 */
+		if (raid_device->starget)
+			return;
 		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
 		    raid_device->id, 0);
 		if (rc)
 			_scsih_raid_device_remove(ioc, raid_device);
 	} else if (channel == PCIE_CHANNEL) {
-		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 		pcie_device = device;
+		/*
+		 * If this boot NVMe device is already registered with SML then
+		 * no need to register it again as part of device scanning
+		 * after diag reset during driver load operation.
+		 */
+		if (pcie_device->starget)
+			return;
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 		tid = pcie_device->id;
 		list_move_tail(&pcie_device->list, &ioc->pcie_device_list);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
@@ -11298,8 +11376,15 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 		if (rc)
 			_scsih_pcie_device_remove(ioc, pcie_device);
 	} else {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = device;
+		/*
+		 * If this boot sas/sata device is already registered with SML
+		 * then no need to register it again as part of device scanning
+		 * after diag reset during driver load operation.
+		 */
+		if (sas_device->starget)
+			return;
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		handle = sas_device->handle;
 		sas_address_parent = sas_device->sas_address_parent;
 		sas_address = sas_device->sas_address;
@@ -11597,6 +11682,25 @@ scsih_scan_start(struct Scsi_Host *shost)
 		ioc_info(ioc, "port enable: FAILED\n");
 }
 
+/**
+ * _scsih_complete_devices_scanning - add the devices to sml and
+ * complete ioc initialization.
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void _scsih_complete_devices_scanning(struct MPT3SAS_ADAPTER *ioc)
+{
+
+	if (ioc->wait_for_discovery_to_complete) {
+		ioc->wait_for_discovery_to_complete = 0;
+		_scsih_probe_devices(ioc);
+	}
+
+	mpt3sas_base_start_watchdog(ioc);
+	ioc->is_driver_loading = 0;
+}
+
 /**
  * scsih_scan_finished - scsi lld callback for .scan_finished
  * @shost: SCSI host pointer
@@ -11610,6 +11714,8 @@ static int
 scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	u32 ioc_state;
+	int issue_hard_reset = 0;
 
 	if (disable_discovery > 0) {
 		ioc->is_driver_loading = 0;
@@ -11624,9 +11730,30 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 		return 1;
 	}
 
-	if (ioc->start_scan)
+	if (ioc->start_scan) {
+		ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+		if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
+			mpt3sas_print_fault_code(ioc, ioc_state &
+			    MPI2_DOORBELL_DATA_MASK);
+			issue_hard_reset = 1;
+			goto out;
+		} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
+				MPI2_IOC_STATE_COREDUMP) {
+			mpt3sas_base_coredump_info(ioc, ioc_state &
+			    MPI2_DOORBELL_DATA_MASK);
+			mpt3sas_base_wait_for_coredump_completion(ioc, __func__);
+			issue_hard_reset = 1;
+			goto out;
+		}
 		return 0;
+	}
 
+	if (ioc->port_enable_cmds.status & MPT3_CMD_RESET) {
+		ioc_info(ioc,
+		    "port enable: aborted due to diag reset\n");
+		ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
+		goto out;
+	}
 	if (ioc->start_scan_failed) {
 		ioc_info(ioc, "port enable: FAILED with (ioc_status=0x%08x)\n",
 			 ioc->start_scan_failed);
@@ -11638,13 +11765,14 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 
 	ioc_info(ioc, "port enable: SUCCESS\n");
 	ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
+	_scsih_complete_devices_scanning(ioc);
 
-	if (ioc->wait_for_discovery_to_complete) {
-		ioc->wait_for_discovery_to_complete = 0;
-		_scsih_probe_devices(ioc);
+out:
+	if (issue_hard_reset) {
+		ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
+		if (mpt3sas_base_hard_reset_handler(ioc, SOFT_RESET))
+			ioc->is_driver_loading = 0;
 	}
-	mpt3sas_base_start_watchdog(ioc);
-	ioc->is_driver_loading = 0;
 	return 1;
 }
 
-- 
2.27.0


--00000000000016698405c293d15b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEIGfcvQ/hRXfD5voTu6TwxFugKRV+FurXdIIXlc+KR0+iMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUxODA1MTY0N1owaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAR
ZR0NG2trac9Ymj7nhelwdSfloMUM7VLZcHtdNjaxAVY6ZM2fEemH8p0r1x8MC0WsDjB3OB2haeUk
esM+++yXPmiIprQ4YmQbpla3gL9FiYOP4p6DZHaWzbzhNvLldqWqZONk1f/jkjXHotTp/T3A0wmI
bGjq0x6vNG4BmVymZVFczfPH2FCNMP6ZiUgEGNh3WrY92bJ1JB2dXddxvpjj2T2/y22O2ijs1ZD4
NVhTeaqVJYp8vG13mlzIVBrCNO8qhGyomxIYwhNHECBu7hpC8ZgpMo18Yd2uGQmszFJQ8GxNpscS
DZtGCEirSLvTxBeqFb9eGurgc1/yd90TF1My
--00000000000016698405c293d15b--
