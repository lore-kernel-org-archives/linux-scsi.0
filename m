Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9AEECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DD1217F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfJOGSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:18:43 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60356 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfJOGSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2019 02:18:42 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=balsundar.p@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  balsundar.p@microsemi.com designates 208.19.100.22 as
  permitted sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="balsundar.p@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: w89t9P4Zs9JI/HjmNORJqfP57/F0fFxdOicnIbhYrAhJSmZeEuuT67C85Q6SD4DJAYnWWsGtfI
 294tw+DpZxtDZCJIyvBIkL15UnAhjvSCKv+E7zaxZkaJWlA0sNSk1yBA21FI6t2Hr/JribYyCb
 dxcEW82EWh7f3wqztObsjFuX5NRyy/nwuExREIMe+IvnJaLxTEWleZt/AUf9tRkKFVc5dINwSR
 tVTZd6Wl1qTE/LeaLD79Wo86S7AYD7TsGR+Z5jlUi/H52qMZxEJgQ//9T9PALtZjK4WpgfgMyQ
 MBc=
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="51480661"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 23:18:42 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 14 Oct
 2019 23:18:41 -0700
Received: from localhost (10.41.130.77) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1713.5 via Frontend Transport; Mon, 14 Oct
 2019 23:18:40 -0700
From:   <balsundar.p@microsemi.com>
To:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>
CC:     <aacraid@microsemi.com>
Subject: [PATCH 6/7] scsi: aacraid: send AIF request post IOP RESET
Date:   Tue, 15 Oct 2019 11:52:03 +0530
Message-ID: <1571120524-6037-7-git-send-email-balsundar.p@microsemi.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
References: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

After IOP reset completion AIF request command is not issued to the
controller. Driver schedules a worker thread to issue a AIF request
command after IOP reset completion.

Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h | 18 +++++++++++++-----
 drivers/scsi/aacraid/commsup.c | 20 +++++++++++++++++++-
 drivers/scsi/aacraid/linit.c   | 21 ++++++++++++++++++---
 3 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index f76a33cb0259..17a4e8b8bd00 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1330,7 +1330,7 @@ struct fib {
 #define AAC_DEVTYPE_ARC_RAW		2
 #define AAC_DEVTYPE_NATIVE_RAW		3
 
-#define AAC_SAFW_RESCAN_DELAY		(10 * HZ)
+#define AAC_RESCAN_DELAY		(10 * HZ)
 
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
@@ -1603,6 +1603,7 @@ struct aac_dev
 	struct fsa_dev_info	*fsa_dev;
 	struct task_struct	*thread;
 	struct delayed_work	safw_rescan_work;
+	struct delayed_work	src_reinit_aif_worker;
 	int			cardtype;
 	/*
 	 *This lock will protect the two 32-bit
@@ -2647,7 +2648,12 @@ int aac_scan_host(struct aac_dev *dev);
 
 static inline void aac_schedule_safw_scan_worker(struct aac_dev *dev)
 {
-	schedule_delayed_work(&dev->safw_rescan_work, AAC_SAFW_RESCAN_DELAY);
+	schedule_delayed_work(&dev->safw_rescan_work, AAC_RESCAN_DELAY);
+}
+
+static inline void aac_schedule_src_reinit_aif_worker(struct aac_dev *dev)
+{
+	schedule_delayed_work(&dev->src_reinit_aif_worker, AAC_RESCAN_DELAY);
 }
 
 static inline void aac_safw_rescan_worker(struct work_struct *work)
@@ -2661,10 +2667,10 @@ static inline void aac_safw_rescan_worker(struct work_struct *work)
 	aac_scan_host(dev);
 }
 
-static inline void aac_cancel_safw_rescan_worker(struct aac_dev *dev)
+static inline void aac_cancel_rescan_worker(struct aac_dev *dev)
 {
-	if (dev->sa_firmware)
-		cancel_delayed_work_sync(&dev->safw_rescan_work);
+	cancel_delayed_work_sync(&dev->safw_rescan_work);
+	cancel_delayed_work_sync(&dev->src_reinit_aif_worker);
 }
 
 /* SCp.phase values */
@@ -2674,6 +2680,7 @@ static inline void aac_cancel_safw_rescan_worker(struct aac_dev *dev)
 #define AAC_OWNER_FIRMWARE	0x106
 
 void aac_safw_rescan_worker(struct work_struct *work);
+void aac_src_reinit_aif_worker(struct work_struct *work);
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
 int aac_setup_safw_adapter(struct aac_dev *dev);
@@ -2731,6 +2738,7 @@ int aac_probe_container(struct aac_dev *dev, int cid);
 int _aac_rx_init(struct aac_dev *dev);
 int aac_rx_select_comm(struct aac_dev *dev, int comm);
 int aac_rx_deliver_producer(struct fib * fib);
+void aac_reinit_aif(struct aac_dev *aac, unsigned int index);
 
 static inline int aac_is_src(struct aac_dev *dev)
 {
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 3f268f669cc3..1c3beea2b3c5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1464,6 +1464,14 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 	}
 }
 
+void aac_schedule_bus_scan(struct aac_dev *aac)
+{
+	if (aac->sa_firmware)
+		aac_schedule_safw_scan_worker(aac);
+	else
+		aac_schedule_src_reinit_aif_worker(aac);
+}
+
 static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	int index, quirks;
@@ -1639,7 +1647,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 */
 	if (!retval && !is_kdump_kernel()) {
 		dev_info(&aac->pdev->dev, "Scheduling bus rescan\n");
-		aac_schedule_safw_scan_worker(aac);
+		aac_schedule_bus_scan(aac);
 	}
 
 	if (jafo) {
@@ -1960,6 +1968,16 @@ int aac_scan_host(struct aac_dev *dev)
 	return rcode;
 }
 
+void aac_src_reinit_aif_worker(struct work_struct *work)
+{
+	struct aac_dev *dev = container_of(to_delayed_work(work),
+				struct aac_dev, src_reinit_aif_worker);
+
+	wait_event(dev->scsi_host_ptr->host_wait,
+			!scsi_host_in_recovery(dev->scsi_host_ptr));
+	aac_reinit_aif(dev, dev->cardtype);
+}
+
 /**
  *	aac_handle_sa_aif	Handle a message from the firmware
  *	@dev: Which adapter this fib is from
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2055307f4f3d..128ab1af5b7f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1594,6 +1594,19 @@ static void aac_init_char(void)
 	}
 }
 
+void aac_reinit_aif(struct aac_dev *aac, unsigned int index)
+{
+	/*
+	 * Firmware may send a AIF messages very early and the Driver may had
+	 * ignored as it is not fully ready to process the messages. so send
+	 * AIF to firmware so that if there is any unprocessed events then it
+	 * can be processed now.
+	 */
+	if (aac_drivers[index].quirks & AAC_QUIRK_SRC)
+		aac_intr_normal(aac, 0, 2, 0, NULL);
+
+}
+
 static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	unsigned index = id->driver_data;
@@ -1691,6 +1704,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&aac->scan_mutex);
 
 	INIT_DELAYED_WORK(&aac->safw_rescan_work, aac_safw_rescan_worker);
+	INIT_DELAYED_WORK(&aac->src_reinit_aif_worker,
+				aac_src_reinit_aif_worker);
 	/*
 	 *	Map in the registers from the adapter.
 	 */
@@ -1881,7 +1896,7 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	scsi_block_requests(shost);
-	aac_cancel_safw_rescan_worker(aac);
+	aac_cancel_rescan_worker(aac);
 	aac_send_shutdown(aac);
 
 	aac_release_resources(aac);
@@ -1940,7 +1955,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
-	aac_cancel_safw_rescan_worker(aac);
+	aac_cancel_rescan_worker(aac);
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
@@ -1998,7 +2013,7 @@ static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 		aac->handle_pci_error = 1;
 
 		scsi_block_requests(aac->scsi_host_ptr);
-		aac_cancel_safw_rescan_worker(aac);
+		aac_cancel_rescan_worker(aac);
 		aac_flush_ios(aac);
 		aac_release_resources(aac);
 
-- 
2.18.1

