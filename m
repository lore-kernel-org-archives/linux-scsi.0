Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082A5C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B004164EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhBXQKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:10:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45563 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhBXPuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614181797; x=1645717797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=w+I8785vdoQ0HwGDTReBpi2ApzBHVLlsCl7k/uGKiKE=;
  b=PUBZiWwEKCP+XYXtMIaCkEpnZTgdEKqqumM4EG6c4apY/qyKLGhMQcZ1
   GS1yUUbIdJY5RSHsuKZXpNQK0fftmB3y1CeBrSzO0z/SAQX7klIupSyIL
   L30jR3VYSYrBTxjsx646kenwKUcEXum2DUce8piPXnbYhzFJg1qWicv0f
   u7/UQLAwY/VCoQhxhDFCHgANUnCwahCHq9ephxIsg92bYX6ZFOP6U76g9
   EQC1anAf8diPjOUhusYDmNlHmdQisEy0I6ybCN/YymuZ/8ugY4SwnhSUv
   0Db+5WHRS776jtWkGB/4QaY2eWiuz+y7NwxlXUuqOZFidj0MqoXcKJGKk
   A==;
IronPort-SDR: uPFPlMm169ePeR8r0q8EREzg5o7yjxsrzApVJ3OO/OyDouRZ3Vcjsa4mNVB+QfcX3ZOagv774Z
 rZRyWbpLgI2pu5h+LuFhy5hM46Bgx6uP7GSLvYC5NYr5mgoa0RGhwzQoh1rrPIbSN3sIPnb22D
 2jsaNfNTNRXqAHCfmDb2/xduSpXT3byc1lQhWzAt9ckMGiVv7XmjhUhIG8inMSMw7P5TKimhVt
 H4mY9iiETcGjgDlHnrNZFkcI/ABwJ7lUpcWd+hSrVydJfb/1CMFtG+U5wngerAzmzL96DGuI0k
 DM4=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="110474144"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:27 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
Date:   Wed, 24 Feb 2021 21:28:01 +0530
Message-ID: <20210224155802.13292-7-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210224155802.13292-1-Viswas.G@microchip.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Producer index(PI) outbound queue and consumer index(CI)
for Outbound queue are in DMA memory. These values should
be reset to 0 during driver reinitialization.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
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

