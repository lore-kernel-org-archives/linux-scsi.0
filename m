Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63D1C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C8764FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhCJUCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22685 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhCJUCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406557; x=1646942557;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XSMr/GwdNwxL3TdTX8qCSXa8opMZrbBYbrOSJBpmJFY=;
  b=Dv/HiDHPWPoini+OK1OE4RAZEIRXMC1QiOqwKpAuMdTe3bsb4mHgcwYz
   AaaG/4A7LO8fo2aDTLTUaNr4V3QfDP+PopLAzkZZPnuw0ad0p+hkjzmnk
   mMIDQuP3tr7xswtn8vgT78Dar3DjRTmaJclfQgf9dJuZlVyBBENcH3amC
   xfvBaV7ti6XkJeIFUv1AmRUhRj0WMIgDzRA+39FxXM7da7Q6y0vrgvy57
   mChcAE7jY3NSGRXn/LbKAlbJgC+4LcYpg0M8F6tX7ZoMc7Lv3CXQ/Lne/
   ibdxZX8ShVdnynZ8JWIznOuqNRVjDDZxuJj9LHKkuX8qwkzgNNrfnkM+4
   g==;
IronPort-SDR: BZ7iDYazZYLkzLkIUvC98ILLmx2Tw00/xclcK3llmQ/fviCt2+90Z3O7+wFPdoZHPo1PvbebYO
 MqvdLXbQM9L4I7tjwZO/R366UEHIRxqhOKrrL4glsVJeFls/us2dxYhT30sBOhsq+Ygb0RdsMa
 R6jnlg06FcoNdjb41uLdJib64LL4U0bJUluEktn425FPNcOZUvnOxNTAa2uFDYSkyA40IdKVmr
 hsjC0z4lLhehNjEL/Xy5VcofyAiHGjGLlUHfl61YUF/kIW9DA+SKfOZY76CeIYofZPVi1h6CgS
 fnI=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389626"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:36 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:36 -0700
Subject: [PATCH V4 19/31] smartpqi: update suspend resume and shutdown
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:36 -0600
Message-ID: <161540655598.19430.10529142061323286687.stgit@brunhilda>
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
index 7436df0d55f2..7d0ab509c2c5 100644
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
 

