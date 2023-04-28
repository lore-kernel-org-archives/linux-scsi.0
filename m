Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5BC77B7E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346477AbjD1PiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346351AbjD1PiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A468F2109
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696264; x=1714232264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C3hHDJkr7G7T2bxN0isLxFSOObjeLS5EGCZeIIrjawo=;
  b=fK0LCmHCFvWWfnGsCKU2wf0xxqQAm/IpTuJgkWeZXLr6eRHpkIXK6g8Y
   zkHBxLzEGSxMtijWCNvWpeFBUHyHyHuCkZHMJst41VJISRIiR4HmuregX
   klKoTdV5gdkipbtfEajEXCbwaQZQ2jwbQbWwb6M56XWkgQd/fsDJIaHsx
   i86ZL7PE9+lkDDxLEwnHGxJlimXDI23NzejgICKAqpdsDPKkf9G840opQ
   87g7/aEcK9x+S3VwYouAxoH8c8HZSVW0x0EcY0sWEm5ClMBceHOJE49xJ
   B62TBflVnsUYQnxDqjInDEGSSUI4tfk+zVtp8DkgcwX2Nh44P+Qe3P0O8
   w==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="223049417"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:36:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:36:57 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:36:56 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 02/12] smartpqi: Add new controller PCI IDs
Date:   Fri, 28 Apr 2023 10:37:02 -0500
Message-ID: <20230428153712.297638-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Strahan <David.Strahan@microchip.com>

All PCI ID entries in Hex.

Add PCI IDs for ZTE controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    ZTE SmartROC3200 RS344-16i 4G           9005 / 028f / 1cf2 / 0804
    ZTE SmartROC3200 RS345-16i 8G           9005 / 028f / 1cf2 / 0805
    ZTE SmartIOC2200 RS346-16i              9005 / 028f / 1cf2 / 0806
    ZTE SmartROC3200 RM344-16i 4G           9005 / 028f / 1cf2 / 54da
    ZTE SmartROC3200 RM345-16i 8G           9005 / 028f / 1cf2 / 54db
    ZTE SmartIOC2200 RM346-16i              9005 / 028f / 1cf2 / 54dc

Add PCI IDs for ByteDance controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    ByteHBA JGH43014-8                      9005 / 028f / 1e93 / 1005

Add PCI IDs for IBM controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    IBM 4-Port 24G SAS                      9005 / 028f / 1014 / 0718

Add PCI IDs for Cloudnine controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    SmartHBA P6600-8i                       9005 / 028f / 1f51 / 1001
    SmartRAID P7604-8i                      9005 / 028f / 1f51 / 1002
    SmartHBA P6600-8e                       9005 / 028f / 1f51 / 1003
    SmartRAID P7604-8e                      9005 / 028f / 1f51 / 1004
    SmartHBA P6600-16i                      9005 / 028f / 1f51 / 1005
    SmartRAID P7608-16i                     9005 / 028f / 1f51 / 1006
    SmartHBA P6600-8i8e                     9005 / 028f / 1f51 / 1007
    SmartRAID P7608-8i8e                    9005 / 028f / 1f51 / 1008
    SmartHBA P6600-16e                      9005 / 028f / 1f51 / 1009
    SmartRAID P7608-16e                     9005 / 028f / 1f51 / 100a

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 72 +++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 29370757b07b..3daad878bafa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9927,6 +9927,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f0c, 0x3161)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0804)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0805)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0806)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x5445)
@@ -9963,6 +9975,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x544f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x54da)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x54db)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x54dc)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x0b27)
@@ -10015,6 +10039,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0623)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1014, 0x0718)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
@@ -10027,6 +10055,50 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1002)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1005)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1001)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1002)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1003)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1004)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1005)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1006)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1007)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1008)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x1009)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x100a)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.40.1.375.g9ce9dea4e1

