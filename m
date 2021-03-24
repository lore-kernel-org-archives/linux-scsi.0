Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67178C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8A161A13
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhCXQyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:54:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:17505 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbhCXQya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616604870; x=1648140870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=F7U3hSyJpp0WrlWE++luXzDfhrubQye8Sbqy2vCVHwY=;
  b=NA2paaejsATSznoavFSQkx1wFsjrWgRqA87MDduLM5wN5txuwt9wvgI6
   J9gVbqNunoAmv4lCxpNlcrTHUqW6ZACh5dfhmlmxEfxXVTQU11Ec4C66G
   a/sBeznJsYmM8JHdwBk+Jcd04y0iu0pVvfch8ZMHpsVZ+cqZE6650W86t
   6yf7hZRhw2odF2/kruVvT2knfwSQipprvTY0aiRGlCGHlTV2t9GejITxK
   KRckGeT72tzcLUKXqqR8G2wIeoIs7pZnuNK5YUef+WxM0NZwfJNRk0TJb
   BXF7qWgB0JU42nUipIxWvKb+5SYKulciZtlwaEaLoJ/ZxHxtMirQ28jsS
   Q==;
IronPort-SDR: ZEynz05vWKUuqUJGmqdnJQ6M2zjUS3IgmqUQLXHemeBzak2o15MrxmuBJTXRxbaAp3g9Ct9D+/
 JNIuneAZAbNorr+v54VNvEntORY5TvMt+4IEgt2gz3qhs32+EmHqbcR6Tij4av/dMnVEnPlmMx
 1cgcYLKVfe9FCixFQqdsRjvmRcvjn3wsP5jXvVFGVQI8gMGYPsy+iJHgwTD1R9zxiBvr+Iguxu
 mU0tRdgUkpbChgXt/HEWNHLCFiOYG3aSZhf36dIamRT//Tmaq8aGwx35qV2HFRm7OUoDKArJJI
 MEI=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="111203619"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 09:54:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 09:54:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 09:54:29 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 6/7] pm80xx: Reset PI and CI memory during re-initialize
Date:   Wed, 24 Mar 2021 22:33:56 +0530
Message-ID: <20210324170357.9765-7-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210324170357.9765-1-Viswas.G@microchip.com>
References: <20210324170357.9765-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Producer index(PI) outbound queue and consumer index(CI)
for Outbound queue are in DMA memory. During resume(),
the stale PI and CI Values will leads to unexpected behavior.
These values should be reset to 0 during driver reinitialization.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 4e0ce044ac69..783149b8b127 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -240,6 +240,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 			pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
 		pm8001_ha->inbnd_q_tbl[i].ci_virt		=
 			pm8001_ha->memoryMap.region[ci_offset + i].virt_ptr;
+		pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0, 0);
 		offsetib = i * 0x20;
 		pm8001_ha->inbnd_q_tbl[i].pi_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressib,
@@ -268,6 +269,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 			0 | (10 << 16) | (i << 24);
 		pm8001_ha->outbnd_q_tbl[i].pi_virt		=
 			pm8001_ha->memoryMap.region[pi_offset + i].virt_ptr;
+		pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0, 0);
 		offsetob = i * 0x24;
 		pm8001_ha->outbnd_q_tbl[i].ci_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressob,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 1aa3a499c85a..0f2c57e054ac 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -787,6 +787,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 			pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
 		pm8001_ha->inbnd_q_tbl[i].ci_virt		=
 			pm8001_ha->memoryMap.region[ci_offset + i].virt_ptr;
+		pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0, 0);
 		offsetib = i * 0x20;
 		pm8001_ha->inbnd_q_tbl[i].pi_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressib,
@@ -820,6 +821,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->outbnd_q_tbl[i].interrup_vec_cnt_delay = (i << 24);
 		pm8001_ha->outbnd_q_tbl[i].pi_virt		=
 			pm8001_ha->memoryMap.region[pi_offset + i].virt_ptr;
+		pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0, 0);
 		offsetob = i * 0x24;
 		pm8001_ha->outbnd_q_tbl[i].ci_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressob,
-- 
2.16.3

