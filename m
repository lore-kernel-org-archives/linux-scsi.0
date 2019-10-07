Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40708C47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03B45206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfJGWb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:31:29 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17255 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:31:29 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: lEkc5XJKUGFARBgLWvSOH5/pEq1GF+xhLpfXRu+0uviHp+g45rU+rxVcwnhU/QNmmE7ddmIQcj
 zLhLJtrOilC3j5EZk61mdO4GgaSQgDkc51yX9ZYfMBiPXwuN77QScZxenCBU57+a3YOQzwZ8dw
 D0HsjYanQvpyMzw2EimNaSnCieul/4LkuezOXEVtSYB8ACbqOi/wb7zlCd2d/sIZ9pSoupEDCF
 Bugg66ecH4Ead2nXyTAZx9It/NxEtpcvpRzQq5nyXQmxuIvmLa8AW1XdPuaayLezDQqDQOcsHh
 uoc=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="49125613"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:31:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:23 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:23 -0700
Subject: [PATCH 01/10] smartpqi: fix controller lockup observed during force
 reboot
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:23 -0500
Message-ID: <157048748297.11757.3872221216800537383.stgit@brunhilda>
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda>
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    9 ++
 drivers/scsi/smartpqi/smartpqi_init.c |  126 ++++++++++++++++++++++++++++-----
 2 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 79d2af36f655..2aa81b22f269 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1130,8 +1130,9 @@ struct pqi_ctrl_info {
 	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
-	bool		in_shutdown;
+	bool		block_device_reset;
 	bool		in_ofa;
+	bool		in_shutdown;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
@@ -1173,6 +1174,7 @@ struct pqi_ctrl_info {
 	struct          pqi_ofa_memory *pqi_ofa_mem_virt_addr;
 	dma_addr_t      pqi_ofa_mem_dma_handle;
 	void            **pqi_ofa_chunk_virt_addr;
+	atomic_t	sync_cmds_outstanding;
 };
 
 enum pqi_ctrl_mode {
@@ -1423,6 +1425,11 @@ static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 	return ctrl_info->block_requests;
 }
 
+static inline bool pqi_device_reset_blocked(struct pqi_ctrl_info *ctrl_info)
+{
+	return ctrl_info->block_device_reset;
+}
+
 void pqi_sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	struct sas_rphy *rphy);
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ea5409bebf57..793793343950 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -249,6 +249,11 @@ static inline void pqi_ctrl_unblock_requests(struct pqi_ctrl_info *ctrl_info)
 	scsi_unblock_requests(ctrl_info->scsi_host);
 }
 
+static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->block_device_reset = true;
+}
+
 static unsigned long pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info,
 	unsigned long timeout_msecs)
 {
@@ -331,6 +336,16 @@ static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
 	return device->in_remove && !ctrl_info->in_shutdown;
 }
 
+static inline void pqi_ctrl_shutdown_start(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->in_shutdown = true;
+}
+
+static inline bool pqi_ctrl_in_shutdown(struct pqi_ctrl_info *ctrl_info)
+{
+	return ctrl_info->in_shutdown;
+}
+
 static inline void pqi_schedule_rescan_worker_with_delay(
 	struct pqi_ctrl_info *ctrl_info, unsigned long delay)
 {
@@ -360,6 +375,11 @@ static inline void pqi_cancel_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 	cancel_delayed_work_sync(&ctrl_info->rescan_work);
 }
 
+static inline void pqi_cancel_event_worker(struct pqi_ctrl_info *ctrl_info)
+{
+	cancel_work_sync(&ctrl_info->event_work);
+}
+
 static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 {
 	if (!ctrl_info->heartbeat_counter)
@@ -4122,6 +4142,8 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 	}
 
+	atomic_inc(&ctrl_info->sync_cmds_outstanding);
+
 	io_request = pqi_alloc_io_request(ctrl_info);
 
 	put_unaligned_le16(io_request->index,
@@ -4168,6 +4190,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_free_io_request(io_request);
 
+	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 out:
 	up(&ctrl_info->sync_request_sem);
 
@@ -5402,7 +5425,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 
 	pqi_ctrl_busy(ctrl_info);
 	if (pqi_ctrl_blocked(ctrl_info) || pqi_device_in_reset(device) ||
-	    pqi_ctrl_in_ofa(ctrl_info)) {
+	    pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info)) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -5650,6 +5673,18 @@ static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static int pqi_ctrl_wait_for_pending_sync_cmds(struct pqi_ctrl_info *ctrl_info)
+{
+	while (atomic_read(&ctrl_info->sync_cmds_outstanding)) {
+		pqi_check_ctrl_health(ctrl_info);
+		if (pqi_ctrl_offline(ctrl_info))
+			return -ENXIO;
+		usleep_range(1000, 2000);
+	}
+
+	return 0;
+}
+
 static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 	void *context)
 {
@@ -5787,17 +5822,17 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 		shost->host_no, device->bus, device->target, device->lun);
 
 	pqi_check_ctrl_health(ctrl_info);
-	if (pqi_ctrl_offline(ctrl_info)) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"controller %u offlined - cannot send device reset\n",
-			ctrl_info->ctrl_id);
+	if (pqi_ctrl_offline(ctrl_info) ||
+		pqi_device_reset_blocked(ctrl_info)) {
 		rc = FAILED;
 		goto out;
 	}
 
 	pqi_wait_until_ofa_finished(ctrl_info);
 
+	atomic_inc(&ctrl_info->sync_cmds_outstanding);
 	rc = pqi_device_reset(ctrl_info, device);
+	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 
 out:
 	dev_err(&ctrl_info->pci_dev->dev,
@@ -6119,7 +6154,8 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 
 	ctrl_info = shost_to_hba(sdev->host);
 
-	if (pqi_ctrl_in_ofa(ctrl_info))
+	if (pqi_ctrl_in_ofa(ctrl_info) ||
+		pqi_ctrl_in_shutdown(ctrl_info))
 		return -EBUSY;
 
 	switch (cmd) {
@@ -7074,13 +7110,20 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
+#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
 
-	rc = pqi_force_sis_mode(ctrl_info);
-	if (rc)
-		return rc;
+	if (reset_devices) {
+		sis_soft_reset(ctrl_info);
+		msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+	} else {
+		rc = pqi_force_sis_mode(ctrl_info);
+		if (rc)
+			return rc;
+	}
 
 	/*
 	 * Wait until the controller is ready to start accepting SIS
@@ -7514,6 +7557,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
+	atomic_set(&ctrl_info->sync_cmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
@@ -7787,8 +7831,6 @@ static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
 		0, NULL, NO_TIMEOUT);
 }
 
-#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
-
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info)
 {
 	msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
@@ -7956,28 +7998,74 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 	pqi_remove_ctrl(ctrl_info);
 }
 
+static void pqi_crash_if_pending_command(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned int i;
+	struct pqi_io_request *io_request;
+	struct scsi_cmnd *scmd;
+
+	for (i = 0; i < ctrl_info->max_io_slots; i++) {
+		io_request = &ctrl_info->io_request_pool[i];
+		if (atomic_read(&io_request->refcount) == 0)
+			continue;
+		scmd = io_request->scmd;
+		WARN_ON(scmd != NULL); /* IO command from SML */
+		WARN_ON(scmd == NULL); /* Non-IO cmd or driver initiated*/
+	}
+}
+
 static void pqi_shutdown(struct pci_dev *pci_dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
 
 	ctrl_info = pci_get_drvdata(pci_dev);
-	if (!ctrl_info)
-		goto error;
+	if (!ctrl_info) {
+		dev_err(&pci_dev->dev,
+			"cache could not be flushed\n");
+		return;
+	}
+
+	pqi_disable_events(ctrl_info);
+	pqi_wait_until_ofa_finished(ctrl_info);
+	pqi_cancel_update_time_worker(ctrl_info);
+	pqi_cancel_rescan_worker(ctrl_info);
+	pqi_cancel_event_worker(ctrl_info);
+
+	pqi_ctrl_shutdown_start(ctrl_info);
+	pqi_ctrl_wait_until_quiesced(ctrl_info);
+
+	rc = pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"wait for pending I/O failed\n");
+		return;
+	}
+
+	pqi_ctrl_block_device_reset(ctrl_info);
+	pqi_wait_until_lun_reset_finished(ctrl_info);
 
 	/*
 	 * Write all data in the controller's battery-backed cache to
 	 * storage.
 	 */
 	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
-	pqi_free_interrupts(ctrl_info);
-	pqi_reset(ctrl_info);
-	if (rc == 0)
+	if (rc)
+		dev_err(&pci_dev->dev,
+			"unable to flush controller cache\n");
+
+	pqi_ctrl_block_requests(ctrl_info);
+
+	rc = pqi_ctrl_wait_for_pending_sync_cmds(ctrl_info);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"wait for pending sync cmds failed\n");
 		return;
+	}
+
+	pqi_crash_if_pending_command(ctrl_info);
+	pqi_reset(ctrl_info);
 
-error:
-	dev_warn(&pci_dev->dev,
-		"unable to flush controller cache\n");
 }
 
 static void pqi_process_lockup_action_param(void)

