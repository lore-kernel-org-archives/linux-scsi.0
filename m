Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47E9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiBAVtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:49:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38057 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiBAVtJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752150; x=1675288150;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D55vFEb7A8d2RxkfexGl1WSonCqbu4+XImcJ91asw9w=;
  b=l3AiXahygd1V7qk1MGoI2msbwZUI52uKJ0qR8vuqq8jA6nt7Tc7mIgUY
   RPfZkGxN2GE8GxpNck1VTSlFr8B8gzQQjSzUPMZ7N2i7EpDHc8Z5pEcxj
   8wP2FSooubmaRUGEP3TmwWSOlwcvHCB2OSEKjkavuCuTjodZecdtpDumS
   3w1d1TTIQdnoJdAw0C4c33klaMIPUQZymIZZJ1q1GqlfW5eNNQH4NRRB2
   bcfU2qHhsPnVSvQUAIiyZMTE9H0j34lc8KEvaS4zutbMTql/yUhBEWzXF
   IsiVI15/LsqE5+UdsqwgeGbT4nur2itbd5FNB1kSBq8rSYl6Joc57mzBo
   A==;
IronPort-SDR: g1uR+kUglifg5ZP7rFaOpB0MBkvytqrTlXkVajm+Iu7rJun6ylzL1PIshXDCxVTL/4zyK73Nek
 UtSTKSO2Nw6k3RgrphLVgBwm486o8OLI5ici4zv6tDjD0YvrTa9wySGu3fLGUfRi7QpnWDg9RA
 aqHP70iaBjJQZrUiTaz5lEuT6vaGE/Sj4vLDErxOQ5QJ87GuaFMubMkOzhft8DGZDw0eqa6YSI
 Etza+MVGMiAwy235zuPZ16m9AIk3YoogJFJ48mKAP6Fof/5+RwsfnENWK9OHbiGBcQNFHAddG4
 AF/4pxYXjOMQNINWJQPXLYLm
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="147312742"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:49:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:49:08 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:49:08 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 9A0DF70236E;
        Tue,  1 Feb 2022 15:49:08 -0600 (CST)
Subject: [PATCH 16/18] smartpqi: fix hibernate and suspend
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:49:08 -0600
Message-ID: <164375214859.440833.14683009064111314948.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Restructure the hibernate/suspend code to allow work-arounds for the
controller boot differences.

Newer controllers have subtle differences in the way that they bootup.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  116 +++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 29cef682bde9..3c3749fcb78c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8955,15 +8955,16 @@ static inline enum bmic_flush_cache_shutdown_event pqi_get_flush_cache_shutdown_
 {
 	if (pci_dev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2 && pci_dev->subsystem_device == 0x1304)
 		return RESTART;
+
 	return SUSPEND;
 }
 
-static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
 {
+	struct pci_dev *pci_dev;
 	struct pqi_ctrl_info *ctrl_info;
-	enum bmic_flush_cache_shutdown_event shutdown_event;
 
-	shutdown_event = pqi_get_flush_cache_shutdown_event(pci_dev);
+	pci_dev = to_pci_dev(dev);
 	ctrl_info = pci_get_drvdata(pci_dev);
 
 	pqi_wait_until_ofa_finished(ctrl_info);
@@ -8973,16 +8974,17 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
-	pqi_flush_cache(ctrl_info, shutdown_event);
-	pqi_stop_heartbeat_timer(ctrl_info);
 
-	pqi_crash_if_pending_command(ctrl_info);
+	if (suspend) {
+		enum bmic_flush_cache_shutdown_event shutdown_event;
 
-	if (state.event == PM_EVENT_FREEZE)
-		return 0;
+		shutdown_event = pqi_get_flush_cache_shutdown_event(pci_dev);
+		pqi_flush_cache(ctrl_info, shutdown_event);
+	}
 
-	pci_save_state(pci_dev);
-	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
+	pqi_stop_heartbeat_timer(ctrl_info);
+	pqi_crash_if_pending_command(ctrl_info);
+	pqi_free_irqs(ctrl_info);
 
 	ctrl_info->controller_online = false;
 	ctrl_info->pqi_mode_enabled = false;
@@ -8990,44 +8992,87 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	return 0;
 }
 
-static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
+static __maybe_unused int pqi_suspend(struct device *dev)
+{
+	return pqi_suspend_or_freeze(dev, true);
+}
+
+static int pqi_resume_or_restore(struct device *dev)
 {
 	int rc;
+	struct pci_dev *pci_dev;
 	struct pqi_ctrl_info *ctrl_info;
 
+	pci_dev = to_pci_dev(dev);
 	ctrl_info = pci_get_drvdata(pci_dev);
 
-	if (pci_dev->current_state != PCI_D0) {
-		ctrl_info->max_hw_queue_index = 0;
-		pqi_free_interrupts(ctrl_info);
-		pqi_change_irq_mode(ctrl_info, IRQ_MODE_INTX);
-		rc = request_irq(pci_irq_vector(pci_dev, 0), pqi_irq_handler,
-			IRQF_SHARED, DRIVER_NAME_SHORT,
-			&ctrl_info->queue_groups[0]);
-		if (rc) {
-			dev_err(&ctrl_info->pci_dev->dev,
-				"irq %u init failed with error %d\n",
-				pci_dev->irq, rc);
-			return rc;
-		}
-		pqi_ctrl_unblock_device_reset(ctrl_info);
-		pqi_ctrl_unblock_requests(ctrl_info);
-		pqi_scsi_unblock_requests(ctrl_info);
-		pqi_ctrl_unblock_scan(ctrl_info);
-		return 0;
-	}
-
-	pci_set_power_state(pci_dev, PCI_D0);
-	pci_restore_state(pci_dev);
+	rc = pqi_request_irqs(ctrl_info);
+	if (rc)
+		return rc;
 
 	pqi_ctrl_unblock_device_reset(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
 	pqi_scsi_unblock_requests(ctrl_info);
 	pqi_ctrl_unblock_scan(ctrl_info);
 
+	ssleep(PQI_POST_RESET_DELAY_SECS);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
+static int pqi_freeze(struct device *dev)
+{
+	return pqi_suspend_or_freeze(dev, false);
+}
+
+static int pqi_thaw(struct device *dev)
+{
+	int rc;
+	struct pci_dev *pci_dev;
+	struct pqi_ctrl_info *ctrl_info;
+
+	pci_dev = to_pci_dev(dev);
+	ctrl_info = pci_get_drvdata(pci_dev);
+
+	rc = pqi_request_irqs(ctrl_info);
+	if (rc)
+		return rc;
+
+	ctrl_info->controller_online = true;
+	ctrl_info->pqi_mode_enabled = true;
+
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
+
+	return 0;
+}
+
+static int pqi_poweroff(struct device *dev)
+{
+	struct pci_dev *pci_dev;
+	struct pqi_ctrl_info *ctrl_info;
+	enum bmic_flush_cache_shutdown_event shutdown_event;
+
+	pci_dev = to_pci_dev(dev);
+	ctrl_info = pci_get_drvdata(pci_dev);
+
+	shutdown_event = pqi_get_flush_cache_shutdown_event(pci_dev);
+	pqi_flush_cache(ctrl_info, shutdown_event);
+
+	return 0;
+}
+
+static const struct dev_pm_ops pqi_pm_ops = {
+	.suspend = pqi_suspend,
+	.resume = pqi_resume_or_restore,
+	.freeze = pqi_freeze,
+	.thaw = pqi_thaw,
+	.poweroff = pqi_poweroff,
+	.restore = pqi_resume_or_restore,
+};
+
 /* Define the PCI IDs for the controllers that we support. */
 static const struct pci_device_id pqi_pci_id_table[] = {
 	{
@@ -9694,8 +9739,9 @@ static struct pci_driver pqi_pci_driver = {
 	.remove = pqi_pci_remove,
 	.shutdown = pqi_shutdown,
 #if defined(CONFIG_PM)
-	.suspend = pqi_suspend,
-	.resume = pqi_resume,
+	.driver = {
+		.pm = &pqi_pm_ops
+	},
 #endif
 };
 


