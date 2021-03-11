Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928EEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F3864F87
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCKUR0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49147 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhCKUQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493814; x=1647029814;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YUQ3Z7wOfq06a/p5NZmUmzakJdn77qOCA3ZKoJ7ZQ0o=;
  b=xV/C1NRYZslyZ2ldoBUdYpCqoTFxUbHhstKGoJ9t9Z5hzkZjoS5OT0pi
   cApacKg7ijE+cUIk5fJcLMmWFfUjxtbULdK5wxA4W5Av5kzyGF0+wADoz
   LKKz+GiGPxloQA2hGJmWQhZq/PRcxMWMoxDL8ZdNWto2Kym4ykEGcEewP
   v3oOdiM2ehnpPgtIiGnY5TRUAlfydchz+wRRzGnm7nX20L4GJk63Yd+3G
   XqcpIq6MoQ0Z2UKyomBFDvyQZJ0Y7MpdE/6CTPe4gcDLCR/PTqT9g/EOw
   ykXIovd66YPG/1vmH1RvvnKG4HiabHAp5rN15MRVFWNspYpL3/Cp3l+j0
   g==;
IronPort-SDR: /VswlSjTIg0IX+76XIJhw2pOu1BbWlKuMI+g6alkR91w7KB28Ut/l3a4o1kDroKNHysjvzd+Rw
 ax1bdXDmKt8+6a/4uDuBaZbCYsSlVY55Jt+VpKTr/Xa2cOCe4PQ09Yji+GFDk1Y41nNPkosUM8
 w53lA1TLMvTHUjJ3tdiM+kpqxVH34JLj5y4e/eDFGmHjajumHuaugGIlIYJqaak9caYy5PrNF5
 4xSKi0pr8eMeKTDVH4G1ZAUc+Bxnxn738RGR/CZlQuKDfBNDVdBPfA/AEm5+TZEjv6aWo/00+Q
 vHw=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="118559068"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:44 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:44 -0700
Subject: [PATCH V5 19/31] smartpqi: update suspend resume and shutdown
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:44 -0600
Message-ID: <161549380398.25025.12266769502766103580.stgit@brunhilda>
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

For suspend/resume and shutdown prevent
   * Controller events.
   * Any new I/O requests.
   * Controller requests.
   * REGNEWD
   * Reset operations
   * Wait for any pending completions from the controller
     to complete to avoid controller NMI events.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   11 ---
 drivers/scsi/smartpqi/smartpqi_init.c |  113 ++++++++++++++++++---------------
 2 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index ba7d26364b84..fa1ebeea777d 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1295,6 +1295,7 @@ struct pqi_ctrl_info {
 	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
+	bool		scan_blocked;
 	bool		in_ofa;
 	bool		in_shutdown;
 	u8		inbound_spanning_supported : 1;
@@ -1624,16 +1625,6 @@ struct bmic_diag_options {
 
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
index cc2b29a67ba0..4f7a38b96356 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,7 +54,6 @@ MODULE_LICENSE("GPL");
 
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
-static void pqi_retry_raid_bypass_requests(struct pqi_ctrl_info *ctrl_info);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
 static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
@@ -245,6 +244,23 @@ static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
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
 	mutex_lock(&ctrl_info->lun_reset_mutex);
@@ -255,6 +271,41 @@ static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info *ctrl_info
 	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
 
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
+}
+
+static inline void pqi_ctrl_unbusy(struct pqi_ctrl_info *ctrl_info)
+{
+	atomic_dec(&ctrl_info->num_busy_threads);
+}
+
 static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 {
 	return ctrl_info->block_requests;
@@ -263,15 +314,12 @@ static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
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
 
 static void pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
@@ -5999,18 +6047,6 @@ static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
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
@@ -8208,7 +8244,6 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
-	atomic_set(&ctrl_info->sync_cmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
@@ -8683,24 +8718,12 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
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
@@ -8711,15 +8734,6 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
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
@@ -8754,19 +8768,18 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 
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
 
@@ -8799,8 +8812,8 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 				pci_dev->irq, rc);
 			return rc;
 		}
-		pqi_start_heartbeat_timer(ctrl_info);
 		pqi_ctrl_unblock_requests(ctrl_info);
+		pqi_scsi_unblock_requests(ctrl_info);
 		return 0;
 	}
 

