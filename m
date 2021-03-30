Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A173C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16AE261996
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhC3GbK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:31:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15336 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhC3Gam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085843; x=1648621843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=F7U3hSyJpp0WrlWE++luXzDfhrubQye8Sbqy2vCVHwY=;
  b=aO7zXLe/tpqmKmw3EhiPvywxCYe0OGrpZ9nRaMp1GeCtGthPiAww9ehj
   qGWP/l3YJaT2qvhZ2jsOEfJTV4wLr55GJbK565PVqcBeqL1cMmaz722xX
   +0Z1k8pDZTzJqq7VIrvylm23h7KS/8+9hV1tOvvyp1TVGNDvgyuqeBBgc
   yVnniIm5g0KyHxucaGMoIL8hTBLtZwPRQTZcSzMJnSZg6taQ1K+4y8N8O
   Kx+cp87who+woyxHWPL0KWX7qGRR6ds6qu2pQtSdeafOij6E+EYZVqQ8M
   1oxjoTGfMesAEglDU4geGB0JOMbN96FdWeSp+tCIf9KZ09+ttDtdWc+la
   Q==;
IronPort-SDR: cc3z073Nf7hNL5CUj8ro309CasooXYqsa0UIpcovRjhJUidtkqrqSEboVEwpWJLj5EGlxvlayK
 LF4NGW3M6zaXn2KaQpu/ZN2Vi5MUz/ZDpSI6ViBhydQodiNy//o2dDaph+kpb96C4TE8M+fBBP
 55UVn9mmjvE0fqwgyDo58sXb1jVVHVewA6H4evRvWru1KzzXq4ATQ4eMN9TKJRgciiYExkVJPj
 JpuAXI2UkTNXmIQkb0varyd21MUWQ2KKWtckAcj144d2hQscw/nUQJ/bRu45e+vVZZmPoqb9KH
 m5M=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="114635647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:41 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 6/7] pm80xx: Reset PI and CI memory during re-initialize
Date:   Tue, 30 Mar 2021 12:10:07 +0530
Message-ID: <20210330064008.9666-7-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
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

