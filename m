Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C63C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0AB2075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WEff/PMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLZLN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:13:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35757 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:13:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so5861168wmb.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rXWfFP/VPTJndhViHKbRJciASeA4WEyrKwAye1f2Dhk=;
        b=WEff/PMwxnsdkjqSvvtAepcoDrqBW2QjyepiAiSN9foLLrtHxZ8CSDXSI9t8Jl/D/H
         Fyy8cqdvEVVOcYQJZQIFaOgaxFhgH5S9glLjuEpLXKwIzalbNfqIko22tAO+OxfGEFFN
         8dD4ecz7Pud44R5pfxU0kf9QFj9PTUL0sY8HU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rXWfFP/VPTJndhViHKbRJciASeA4WEyrKwAye1f2Dhk=;
        b=nXbJYKh9g+31ZECCwhntsultiIo/boDYlAantyPXm0O/0BYb82U7Fr8BKyxkEFr6ZN
         2sCIomEuu3/+qQFhFdzKxJ7a4FZlbVPSLy8AnlZ2MsAc8xXc1/gsOjc3VhXcnbwyhJD2
         8u/y9FOq0IC2Uwg2/vXYRH8SYw3PDCUYQQSCN9z+lAPfsQpoNSxjcXqCasuY5HC4sMMq
         ZoPCmN7c66vxyF0E3uCOvB7Gt/Q6ZzP3dwC2Qp4JU+xThgZYPbzqlVrVatP8Uvhs1clH
         q08zufJo7EAVwF4nNWp3OFkknMWh21NDPwAiKsHFZbetszrGBzz3ingCbTW4HFTO7kmk
         QtZQ==
X-Gm-Message-State: APjAAAUHSs53/fXhAGjQu2KBwFgLibMBbf+TQWwuK0BURKnJrgfm+TVy
        92Gz0c7ISrOu3A0bT6KtxCtoUKqlMuJ2vbuDBen0BwP+0obEytKyU1/TP7zsDW6IEDQEMSW5jgr
        mc5FR3EoiYoexRnZCuwUDYCg3GwmF2g8h/EewjNamm4BVZd5Pb4NpYA9pSkGagRTfyCFilCqNr1
        kq2wT30nuo
X-Google-Smtp-Source: APXvYqyzkhEDuJKSWNuVzZxSl1x+vgxuxrDa/TKdr9MCdfFocDdWEPBONLJivAt5aQkyUNp1W4NXkA==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr13312535wmb.81.1577358833017;
        Thu, 26 Dec 2019 03:13:53 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:13:52 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 02/10] mpt3sas: Add support for NVMe shutdown.
Date:   Thu, 26 Dec 2019 06:13:25 -0500
Message-Id: <20191226111333.26131-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce function _scsih_nvme_shutdown() to issue IO Unit Control
message to IOC firmware with operation code 'shutdown'. So that IOC
firmware issues NVMe shutdown commands to all NVMe drives attached
to it.

NVMe Shutdown:
NVMe devices need to have a specific shutdown sequence performed
before power is removed, For this IOC firmware needs to be notified
when the system is being shutdown.
So during the system shutdown time, Driver issue an
IO Unit Control request with operation code
MPI26_CTRL_OP_SHUTDOWN to inform firmware that a shutdown is
initiated.

This shutdown command is issued only if NVMe devices are
attached to the controller.

During each nvme device addition, Driver reads pcie device page2
to get shutdown latency (.e. drive's RTD3 Entry Latency) and updates
the max latency value among the added NVMe drives in
ioc->max_shutdown_latency.
This is used as the timeout value for Io Unit Control command
at the time of shutdown.

When a NVMe drive is removed and it's shutdown latency matches
which ioc->max_shutdown_latency then ioc->max_shutdown_latency is
updated to next max value (By iterating over the list of
available devices).
If the shutdown latency is 0, then default timeout is set to
six seconds.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---

v1 Change Set:
 Initializing update_latency to zero in
  _scsih_pcie_device_remove() function.

 drivers/scsi/mpt3sas/mpt3sas_base.h  |   9 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 136 +++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4ebf81e..a4f308f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -140,6 +140,7 @@
 #define MAX_CHAIN_ELEMT_SZ		16
 #define DEFAULT_NUM_FWCHAIN_ELEMTS	8
 
+#define IO_UNIT_CONTROL_SHUTDOWN_TIMEOUT 6
 #define FW_IMG_HDR_READ_TIMEOUT	15
 
 #define IOC_OPERATIONAL_WAIT_COUNT	10
@@ -589,6 +590,7 @@ static inline void sas_device_put(struct _sas_device *s)
  * @connector_name: ASCII value of the Connector's name
  * @serial_number: pointer of serial number string allocated runtime
  * @access_status: Device's Access Status
+ * @shutdown_latency: NVMe device's RTD3 Entry Latency
  * @refcount: reference count for deletion
  */
 struct _pcie_device {
@@ -611,6 +613,7 @@ struct _pcie_device {
 	u8	*serial_number;
 	u8	reset_timeout;
 	u8	access_status;
+	u16	shutdown_latency;
 	struct kref refcount;
 };
 /**
@@ -1073,6 +1076,10 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @event_context: unique id for each logged event
  * @event_log: event log pointer
  * @event_masks: events that are masked
+ * @max_shutdown_latency: timeout value for NVMe shutdown operation,
+ *			which is equal that NVMe drive's RTD3 Entry Latency
+ *			which has reported maximum RTD3 Entry Latency value
+ *			among attached NVMe drives.
  * @facts: static facts data
  * @prev_fw_facts: previous fw facts data
  * @pfacts: static port facts data
@@ -1283,7 +1290,7 @@ struct MPT3SAS_ADAPTER {
 
 	u8		tm_custom_handling;
 	u8		nvme_abort_timeout;
-
+	u16		max_shutdown_latency;
 
 	/* static config pages */
 	struct mpt3sas_facts facts;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a038be8..c451e57 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1049,6 +1049,34 @@ mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	return pcie_device;
 }
 
+/**
+ * _scsih_set_nvme_max_shutdown_latency - Update max_shutdown_latency.
+ * @ioc: per adapter object
+ * Context: This function will acquire ioc->pcie_device_lock
+ *
+ * Update ioc->max_shutdown_latency to that NVMe drives RTD3 Entry Latency
+ * which has reported maximum among all available NVMe drives.
+ * Minimum max_shutdown_latency will be six seconds.
+ */
+static void
+_scsih_set_nvme_max_shutdown_latency(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _pcie_device *pcie_device;
+	unsigned long flags;
+	u16 shutdown_latency = IO_UNIT_CONTROL_SHUTDOWN_TIMEOUT;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	list_for_each_entry(pcie_device, &ioc->pcie_device_list, list) {
+		if (pcie_device->shutdown_latency) {
+			if (shutdown_latency < pcie_device->shutdown_latency)
+				shutdown_latency =
+					pcie_device->shutdown_latency;
+		}
+	}
+	ioc->max_shutdown_latency = shutdown_latency;
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+}
+
 /**
  * _scsih_pcie_device_remove - remove pcie_device from list.
  * @ioc: per adapter object
@@ -1063,6 +1091,7 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 	int was_on_pcie_device_list = 0;
+	u8 update_latency = 0;
 
 	if (!pcie_device)
 		return;
@@ -1082,11 +1111,22 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
 		list_del_init(&pcie_device->list);
 		was_on_pcie_device_list = 1;
 	}
+	if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
+		update_latency = 1;
 	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 	if (was_on_pcie_device_list) {
 		kfree(pcie_device->serial_number);
 		pcie_device_put(pcie_device);
 	}
+
+	/*
+	 * As this device's RTD3 Entry Latency matches with
+	 * IOC's max_shutdown_latency and hence recalculate
+	 * IOC's max_shutdown_latency from the available drives
+	 * as current drive is getting removed.
+	 */
+	if (update_latency)
+		_scsih_set_nvme_max_shutdown_latency(ioc);
 }
 
 
@@ -1101,6 +1141,7 @@ _scsih_pcie_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct _pcie_device *pcie_device;
 	unsigned long flags;
 	int was_on_pcie_device_list = 0;
+	u8 update_latency = 0;
 
 	if (ioc->shost_recovery)
 		return;
@@ -1113,12 +1154,23 @@ _scsih_pcie_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			was_on_pcie_device_list = 1;
 			pcie_device_put(pcie_device);
 		}
+		if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
+			update_latency = 1;
 	}
 	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 	if (was_on_pcie_device_list) {
 		_scsih_pcie_device_remove_from_sml(ioc, pcie_device);
 		pcie_device_put(pcie_device);
 	}
+
+	/*
+	 * As this device's RTD3 Entry Latency matches with
+	 * IOC's max_shutdown_latency and hence recalculate
+	 * IOC's max_shutdown_latency from the available drives
+	 * as current drive is getting removed.
+	 */
+	if (update_latency)
+		_scsih_set_nvme_max_shutdown_latency(ioc);
 }
 
 /**
@@ -6933,6 +6985,16 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	    le32_to_cpu(pcie_device_pg0.DeviceInfo)))) {
 		pcie_device->nvme_mdts =
 		    le32_to_cpu(pcie_device_pg2.MaximumDataTransferSize);
+		pcie_device->shutdown_latency =
+			le16_to_cpu(pcie_device_pg2.ShutdownLatency);
+		/*
+		 * Set IOC's max_shutdown_latency to drive's RTD3 Entry Latency
+		 * if drive's RTD3 Entry Latency is greater then IOC's
+		 * max_shutdown_latency.
+		 */
+		if (pcie_device->shutdown_latency > ioc->max_shutdown_latency)
+			ioc->max_shutdown_latency =
+				pcie_device->shutdown_latency;
 		if (pcie_device_pg2.ControllerResetTO)
 			pcie_device->reset_timeout =
 			    pcie_device_pg2.ControllerResetTO;
@@ -9357,6 +9419,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		}
 		_scsih_remove_unresponding_devices(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
+		_scsih_set_nvme_max_shutdown_latency(ioc);
 		break;
 	case MPT3SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
@@ -9659,6 +9722,75 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	kfree(sas_expander);
 }
 
+/**
+ * _scsih_nvme_shutdown - NVMe shutdown notification
+ * @ioc: per adapter object
+ *
+ * Sending IoUnitControl request with shutdown operation code to alert IOC that
+ * the host system is shutting down. So that IOC can issue NVMe shutdown to
+ * NVMe drives attached to it.
+ */
+static void
+_scsih_nvme_shutdown(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26IoUnitControlRequest_t *mpi_request;
+	Mpi26IoUnitControlReply_t *mpi_reply;
+	u16 smid;
+
+	/* are there any NVMe devices ? */
+	if (list_empty(&ioc->pcie_device_list))
+		return;
+
+	mutex_lock(&ioc->scsih_cmds.mutex);
+
+	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
+		ioc_err(ioc, "%s: scsih_cmd in use\n", __func__);
+		goto out;
+	}
+
+	ioc->scsih_cmds.status = MPT3_CMD_PENDING;
+
+	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
+	if (!smid) {
+		ioc_err(ioc,
+		    "%s: failed obtaining a smid\n", __func__);
+		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+		goto out;
+	}
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->scsih_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi26IoUnitControlRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_IO_UNIT_CONTROL;
+	mpi_request->Operation = MPI26_CTRL_OP_SHUTDOWN;
+
+	init_completion(&ioc->scsih_cmds.done);
+	ioc->put_smid_default(ioc, smid);
+	/* Wait for max_shutdown_latency seconds */
+	ioc_info(ioc,
+		"Io Unit Control shutdown (sending), Shutdown latency %d sec\n",
+		ioc->max_shutdown_latency);
+	wait_for_completion_timeout(&ioc->scsih_cmds.done,
+			ioc->max_shutdown_latency*HZ);
+
+	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
+		ioc_err(ioc, "%s: timeout\n", __func__);
+		goto out;
+	}
+
+	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
+		mpi_reply = ioc->scsih_cmds.reply;
+		ioc_info(ioc, "Io Unit Control shutdown (complete):"
+			"ioc_status(0x%04x), loginfo(0x%08x)\n",
+			le16_to_cpu(mpi_reply->IOCStatus),
+			le32_to_cpu(mpi_reply->IOCLogInfo));
+	}
+ out:
+	ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+	mutex_unlock(&ioc->scsih_cmds.mutex);
+}
+
+
 /**
  * _scsih_ir_shutdown - IR shutdown notification
  * @ioc: per adapter object
@@ -9851,6 +9983,7 @@ scsih_shutdown(struct pci_dev *pdev)
 				&ioc->ioc_pg1_copy);
 
 	_scsih_ir_shutdown(ioc);
+	_scsih_nvme_shutdown(ioc);
 	mpt3sas_base_detach(ioc);
 }
 
@@ -10533,6 +10666,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
 	ioc->logging_level = logging_level;
 	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
+	/* Host waits for minimum of six seconds */
+	ioc->max_shutdown_latency = IO_UNIT_CONTROL_SHUTDOWN_TIMEOUT;
 	/*
 	 * Enable MEMORY MOVE support flag.
 	 */
@@ -10681,6 +10816,7 @@ scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	mpt3sas_base_stop_watchdog(ioc);
 	flush_scheduled_work();
 	scsi_block_requests(shost);
+	_scsih_nvme_shutdown(ioc);
 	device_state = pci_choose_state(pdev, state);
 	ioc_info(ioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
 		 pdev, pci_name(pdev), device_state);
-- 
2.18.1

