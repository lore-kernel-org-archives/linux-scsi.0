Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA39C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8486D613B1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhDOKZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:25:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32596 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhDOKZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482280; x=1650018280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=XUJD/hLB45soD0T1luoqpQsXxCfhnCkNgM49CXPWkCQ=;
  b=z4Cbu3bQRbpv/Be7KAd/3tkfHbxrDCFEmBhU456bz+u7h1Hsxla9F0GP
   m8+W1YUd5NqffBKv4983IMtnBYJNcyvOWnJT+beVEudeuucL8jaQTLpw5
   RF+UhcJSy2nKRbHw+ACk5c6gsrKlPjP2Srapv3tWQsf7jj1Y6qvb2Ymuk
   F/f8y+JIZkaPB+LEBSpoQT8ud3DYfgnoazeSPxA9l7K63yVkeEQG086rQ
   Gn3SeXS5LmocPXsHqqW1RMJAb6y1s46aWiG/3fuposMexPNMsXXYrjEIb
   biW4LWV6KTh8aLDQ+2w/Bm4xYRGfLRzY2nqX5qCWb6yzS8k54ps3iozuc
   Q==;
IronPort-SDR: v3XbvVpyvI8wNe8KTksIzAgglYE1yRKiriSq/+vkUlaFjblx0TJhOchcpiLpBjAKs5wQxXkeBS
 HUWZ/kFkcEwbZ9qXQvGkax1nuYFRomlHs3CsleibMNFz7b3iPQF8kkDTy0lltIRkv95z0g0gQK
 Sj7Z3i/81JNfPjQoUqab/FrgXmbDzd4g3ppKKEMxBAcB8f5corGOyNBd2wSLfin9QgI+ggYGNj
 h2yaT+A0aE7fp3VAoNsNaol7L8//0Fzy1lJ3tB1gVCj+KBytuQ1Vhaecv7VilMZkfj6wDXG3Sj
 LKk=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="117118815"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:31 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 7/8] pm80xx: Reset PI and CI memory during re-initialize
Date:   Thu, 15 Apr 2021 16:03:51 +0530
Message-ID: <20210415103352.3580-8-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
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
index 4e97075d2ad8..42e8a2e1e284 100644
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

