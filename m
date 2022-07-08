Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D8CCCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbiGHSqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiGHSq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4A44D4DC
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305987; x=1688841987;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xoyTNq9cQ+ffsbxWEKJXE2wNbi6j//aDlBORSxlcXS8=;
  b=Sm0gACc3kU9fkOR7eP3JrYTy6WiWS46y8MEtQoILcr0t0BDgkPrxPzED
   /xN/muxjeuddSetGRjKzAvioilmLSzD3RWo3+du7FqqQMuai3eCf6QTw/
   ok8P4+bM0SvLn5HedEJL3bE0+WUdeNZGhBId8yVFxKmOA4glZZMnZeAPt
   5LdrdjvAA5+2uqZEbtTr7j578yZYKoNWMCavlP9T09q1KLYaGMSIKg0m1
   Cj8H7aojoiMPX4RfPwMKL1Vge9I3WPkTbzbTBnY7u5XbQEo/+UIUClCu9
   MmzBJp6gliCXa2aP3tDzFnFLOMl6Uu8ZuOHpli5tSKaDOeV5iWRmoOI4i
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="167050653"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:18 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:18 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlQvQ177401;
        Fri, 8 Jul 2022 13:47:26 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlQFM177400;
        Fri, 8 Jul 2022 13:47:26 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 08/16] smartpqi: add PCI-IDs for Lenovo controllers
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:26 -0500
Message-ID: <165730604598.177165.9910276232981721083.stgit@brunhilda>
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

Add PCI IDs for Lenovo controllers (values in hex):

                                        VID  / DID  / SVID / SDID
                                        ----   ----   ----   ----
Lenovo 4350-8i HBA                      9005 / 028f / 1d49 / 0220
Lenovo 4350-16i HBA                     9005 / 028f / 1d49 / 0221
Lenovo 5350-8i RAID                     9005 / 028f / 1d49 / 0520
Lenovo 5350-8i Internal RAID            9005 / 028f / 1d49 / 0522
Lenovo 9350-8i RAID                     9005 / 028f / 1d49 / 0620
Lenovo 9350-8i Internal RAID            9005 / 028f / 1d49 / 0621
Lenovo 9350-16i RAID                    9005 / 028f / 1d49 / 0622
Lenovo 9350-16i Internal RAID           9005 / 028f / 1d49 / 0623

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 99f9fc834a69..77a8e0ed91a8 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9828,6 +9828,38 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cc4, 0x0201)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0220)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0221)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0520)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0522)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0620)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0621)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0622)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0623)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)

