Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EE9C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BB46126A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbhHWH31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:29:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:54379 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbhHWH3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 03:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629703721; x=1661239721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=060Dhv7IuOizRGJJO8tDLdaMuNZhQYqgfS6ul2ndlOg=;
  b=10QQ9ykHwqcpY1aILIZXK5jKrEHde0ITixung8vBgVftNQoZzl2c21UQ
   kwK9uX519fJnCby3aEaK1JGluUD37cjavkQ6XRAMzau8yfpDtPyQkUvcn
   9I2D6ZEchUUXRUi/dB8NGmUXGkEiC3c3zINuk0+S47yoP45uJV97001ex
   7eOO2Jp4siWx1iAMyMpc1GKSKStTZH2qO2H0MbUVV9AA2x5lSYDWs+v3Q
   0sdGrlx7yHB5fjDFBa218ssTH119JO5aPU1qO1t6Sr6TX8QWfn3BEYxZN
   nPSBphbFKHyduj/YeDcfUP5jBsiHGOAp3jTG4x0Py3630MiClq2I+oxDb
   A==;
IronPort-SDR: Wjur5/VO900WlRviWPbi3RYYnJhBxEXBT/JaciRUU5mYNaqd0FljjnusG3P3vrgYq9LPYNgW2F
 bQigf6VqKwVFmOi9t07Z2KdEQhpWee2P4uE25A9oEkOvopFxtVjvn6zbM0gm1A/vBRHS+iaGS5
 QcpnGUXoRP/vFCk+9WeRttY4E3u1tou9KVgveREt3Uv8GQrxRhb+NJ3eVlyj1FacjEeqgCN1/i
 fkMACWc4kV9qeSPEY+YcJG1UcGAorW2mvUu1sD9MVHuTA4MQs5XsU+cNwKmh03tBQtAo2Jx9SH
 QkZK1cWmqbbUj+V59BlY1ylm
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="126720700"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2021 00:28:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 23 Aug 2021 00:28:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 23 Aug 2021 00:28:39 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 3/4] scsi: pm80xx: Corrected Inbound and Outbound queue logging
Date:   Mon, 23 Aug 2021 13:53:37 +0530
Message-ID: <20210823082338.67309-4-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Corrected inbound queue and outbound queue size in 'ib_log'
and 'ob_log' sysfs entries.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index ec05c42e8ee6..b25e447aa3bd 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -409,6 +409,7 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
 	char *str = buf;
 	int start = 0;
 	u32 ib_offset = pm8001_ha->ib_offset;
+	u32 queue_size = pm8001_ha->max_q_num * PM8001_MPI_QUEUE * 128;
 #define IB_MEMMAP(c)	\
 		(*(u32 *)((u8 *)pm8001_ha->	\
 		memoryMap.region[ib_offset].virt_ptr +	\
@@ -419,7 +420,7 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
 		start = start + 4;
 	}
 	pm8001_ha->evtlog_ib_offset += SYSFS_OFFSET;
-	if (((pm8001_ha->evtlog_ib_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
+	if (((pm8001_ha->evtlog_ib_offset) % queue_size) == 0)
 		pm8001_ha->evtlog_ib_offset = 0;
 
 	return str - buf;
@@ -445,6 +446,7 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
 	char *str = buf;
 	int start = 0;
 	u32 ob_offset = pm8001_ha->ob_offset;
+	u32 queue_size = pm8001_ha->max_q_num * PM8001_MPI_QUEUE * 128;
 #define OB_MEMMAP(c)	\
 		(*(u32 *)((u8 *)pm8001_ha->	\
 		memoryMap.region[ob_offset].virt_ptr +	\
@@ -455,7 +457,7 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
 		start = start + 4;
 	}
 	pm8001_ha->evtlog_ob_offset += SYSFS_OFFSET;
-	if (((pm8001_ha->evtlog_ob_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
+	if (((pm8001_ha->evtlog_ob_offset) % queue_size) == 0)
 		pm8001_ha->evtlog_ob_offset = 0;
 
 	return str - buf;
-- 
2.27.0

