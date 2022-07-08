Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2744CCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbiGHSqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiGHSqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AB0796BF
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306002; x=1688842002;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XfK1ZJ94igatQoWQfCRlJxtxEamYvKP8YVvIaEkA4iU=;
  b=Wy3txGi6iI7Hcv7ci54+3fTVQEFnLRYpN7Hs0h6e+/Q/1gSwL7t01t48
   g8P4Ex4F2iefXATunFeD2YECPbqOfWR5yzs/Ab3b8U5D3fgeHP0oBGJyT
   pjO1lCDCXA0Uvpkpr2LB+HDBtmmKgqkyVZh80n5390YbkXafi7O8JsIHa
   AY4UnLCyftHXUx+q4T0QoEVxSuoIcrDc2GZkJTkOBX81iriD3CWZWNYjx
   YC+WpWMnfniQSKV5U6epFE3SygKITHTfJoqrC6C++C295mjwyXkss7e8K
   ZtQh6Zxk11Jku4+FVHmnRurEtcisdIrdC0pDY8e21npvzFHWFCj7GwPdx
   A==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="181377329"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:39 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:39 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Ilkuj177479;
        Fri, 8 Jul 2022 13:47:46 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlkpN177478;
        Fri, 8 Jul 2022 13:47:46 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 12/16] smartpqi: add module param to disable managed ints
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:46 -0500
Message-ID: <165730606638.177165.12846020942931640329.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Allow SMP affinity to be changeable by disabling managed interrupts.

On distributions where the driver is enabled for multi-queue support the
driver utilizes kernel managed interrupts, which automatically distributes
interrupts to all available CPUs and assigns SMP affinity.

On most distributions, the affinity can not be changed by the user.

This change will allow managed interrupts to be disabled by the user via a
module parameter while still allowing multi-queue support to function
properly.

Use the module parameter disable_managed_interrupts=1

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index f1145ded843e..49d3a8a275f3 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1351,7 +1351,7 @@ struct pqi_ctrl_info {
 	u8		enable_r6_writes : 1;
 	u8		lv_drive_type_mix_valid : 1;
 	u8		enable_stream_detection : 1;
-
+	u8		disable_managed_interrupts : 1;
 	u8		ciss_report_log_flags;
 	u32		max_transfer_encrypted_sas_sata;
 	u32		max_transfer_encrypted_nvme;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e07282ed0f34..2df1e8453029 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -175,6 +175,12 @@ module_param_named(hide_vsep,
 	pqi_hide_vsep, int, 0644);
 MODULE_PARM_DESC(hide_vsep, "Hide the virtual SEP for direct attached drives.");
 
+static int pqi_disable_managed_interrupts;
+module_param_named(disable_managed_interrupts,
+	pqi_disable_managed_interrupts, int, 0644);
+MODULE_PARM_DESC(disable_managed_interrupts,
+	"Disable the kernel automatically assigning SMP affinity to IRQs.");
+
 static char *raid_levels[] = {
 	"RAID-0",
 	"RAID-4",
@@ -4039,10 +4045,14 @@ static void pqi_free_irqs(struct pqi_ctrl_info *ctrl_info)
 static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
 	int num_vectors_enabled;
+	unsigned int flags = PCI_IRQ_MSIX;
+
+	if (!pqi_disable_managed_interrupts)
+		flags |= PCI_IRQ_AFFINITY;
 
 	num_vectors_enabled = pci_alloc_irq_vectors(ctrl_info->pci_dev,
 			PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
-			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+			flags);
 	if (num_vectors_enabled < 0) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"MSI-X init failed with error %d\n",
@@ -8588,6 +8598,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	ctrl_info->max_write_raid_5_6 = PQI_DEFAULT_MAX_WRITE_RAID_5_6;
 	ctrl_info->max_write_raid_1_10_2drive = ~0;
 	ctrl_info->max_write_raid_1_10_3drive = ~0;
+	ctrl_info->disable_managed_interrupts = pqi_disable_managed_interrupts;
 
 	return ctrl_info;
 }

