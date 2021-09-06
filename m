Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615E2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D8960F6B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbhIFQKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:10:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49008 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbhIFQKJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 12:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1630944545; x=1662480545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VU+xOf185gEz3/pooZ85K5cy25HT0oJ4Oy5B78KKijE=;
  b=fRKrlRh0DYQ1ljmphrrikrhFP/zLrtxDclihGa357Thag/z/uL9kabVa
   zYB1WfhWYiKL9XaPQj1gwm3rZmCfWKn8+eMq/Mrqe7G7ANgaydBQtP3bu
   f3TYSa1vDywIvWd/YQ98tQvgmTZV3I1h+fCT+zTVdRY5vtLxh/+zJOd+K
   eszoymPoRYQMSi+FAwRzZY4jR/nLNDVgFBgqCqjg+Rt4nXE6NIq7nWpcP
   nD/H5uKpVqhmwAtWmXjA6arcX0by3IfLvteWrhM0cz88tmh30Jt6ruQ0U
   TqtgXliBEfIJVr8I8AL4UnC+XKQ/Me/CFvEZDBAqhAWAnJ3W4WEWF7S73
   w==;
IronPort-SDR: Jdfh68LmSadRpe6WWvdBVekBSJXYWnRFEiQ3Pt0j4vHtgfP5i/gArOLICD8LRZYTGwQEvNSj1c
 RiQNp9lxYwHpNR8fvMlmySxnUBtequFV95lVHjQ52jzZBWQegEZkRONBQsktt4PNZvvuCzlTyl
 9YRBXQECUgBpjV4zojX9oFmPH29fZWFwN2S7BCPCOgZ2zLijhTTPQsYQ/i5VEw21RHeozoaXMS
 ABURd0za4ifx8FUMQO3EBkKpPLglp1Y+g+UXe1URDqCtSkMG+zDPpNtfh262fWG6dloT6oDAhW
 Q9/GQdc6oeJCditKRxSjPzdf
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="135544998"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2021 09:09:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 6 Sep 2021 09:09:04 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 6 Sep 2021 09:09:04 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 3/4] scsi: pm80xx: Corrected Inbound and Outbound queue logging
Date:   Mon, 6 Sep 2021 22:34:03 +0530
Message-ID: <20210906170404.5682-4-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
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
Acked-by: Jack Wang <jinpu.wang@ionos.com>
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

