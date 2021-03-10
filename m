Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB67EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CC464FC9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCJUD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22841 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhCJUDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406622; x=1646942622;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHTqW8LEwwTZRYjHUQm3G7VLiu8nCxuJ0ishtuLixBk=;
  b=HOjK1uWAt1zw+e/GGoj/AXxzF6enWMoETMxymGILn8Y4wf8o0VHHzz9G
   3/iD0lQIrcDnfJyj0ArHzNHVlJAbcT9+J9ogIHl1FUXIztx5ZL9EhVZUJ
   WyEVLPIit1Bgs6zc5inujGKxaWEiqEj4YNS4CdVnuyX5xQZ5f3u4M++31
   sMJ2Cbngk1husW/9M3iW+Pfru1VyX6kJnVoWqvx7oAPRV/2VaddeC0JG/
   xKte2V2i3Z7/AXCUN1kF5wlXorcELq5kfM0v/kkSDuARoK268m5FMfSa+
   kTi08YI6cbr6nvU2kDkJWLMiHq77Hv9hZMTKutEJqT/dpnkHR+w3JGOkZ
   A==;
IronPort-SDR: gd3g48PV7x6UL4E20xX+ApaiH7jR7bkyxtD3otQ1Xng5fBnSEaqkikp1aNFYjXKoa6SybAkC6G
 U6HhkKnDq14/a+fQr90h4kNBlZA8ZkUaSE0Z9HpIfIiIWSZqyfpifx7psg0Qhm+7TDLySBydoT
 CgTxkKNgA5twz+muAjVebBDvxc9hvcgn/XCMK1P49oJdZ4xUgWs/hKdU7BsHAiZa5MZ4lnQ6CR
 ra7v+t4kivmho/9o5x5scsA9xlLhnRagfqkiqWi8rXNCzfIkWRVrBDtNFEKOPMht/FOx01XAWe
 bTM=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389804"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:40 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:40 -0700
Subject: [PATCH V4 30/31] smartpqi: add new pci ids
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:40 -0600
Message-ID: <161540662032.19430.6765830964779450761.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Add support for newer HW.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Acked-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  156 +++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 48eddfdf0a08..ec1859e2e420 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8699,6 +8699,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x152d, 0x8a37)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x8460)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1104)
@@ -8771,6 +8775,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x004f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0051)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0052)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0053)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0054)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -8931,6 +8951,122 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1380)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1400)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1402)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1410)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1411)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1412)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1420)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1430)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1440)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1441)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1450)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1460)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1461)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1462)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1470)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1471)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1472)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1480)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1490)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1491)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14b0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14b1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14d0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14e0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14f0)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -8995,6 +9131,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1001)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x1002)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1100)
@@ -9003,6 +9143,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1101)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x0294)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x02db)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x02dc)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x032e)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1d8d, 0x0800)

