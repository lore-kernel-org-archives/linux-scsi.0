Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16009C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiBAVsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30963 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiBAVr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752080; x=1675288080;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+RBln9NHiNY8AVsTmj25PNxSX+lzxroPsWH/7v0vyA0=;
  b=zkYZThflaK7rvIETjdovzoi1ASwBFGQMQr55lVVr6IEh1XKQieyh9lhd
   w9u/FnKic/2oQ+RLHRAEkt0q2a0W4pTvqrkB9NUiL8OqS5G9U1VMy386y
   3YYboKF0bMSnBnC8aw+CIJuQsJdVfavLv+H7MaYatg6fTcZwwtwsVq/A2
   N/TWVMcbHs7dheCYGN3xgJi2Y6Mn2NeFmhiStTtF4hoBqN8CnaMLys+Sv
   N9MXtj6Qf8pyZIQrOcoKjHMS7fsh1wMr3Gi871e9RJJaYY/9uE2C7BZxv
   HMPmVEUlhblbSEZMsLNgFxjQ+FVaWSrHggxQgIgub6lrlu8f/gni/sBh8
   w==;
IronPort-SDR: E9Rb/qd8gVR6Z/qCr7/PcThHvZWra8UEIEB4heBUtw1WH913MJ8Nk2Bw6FghdVv7XhfyK5cfEj
 K8KAS8E9myesrn2ERR0RiarayZI90q3xc0p9xn/WxTOx5WmLQm9P9XRko0Exb3+Rvc67Jbw3CB
 mQl2IV35c9lXTb2TYbyb2oBd+gh8bdUvcWA07ounmeyFmyDYyIuMyo77kguA4s2AjAOgjbFMC/
 0Nnkju3dinnn5V3UmkjhDaYZD8nRi7XqMOR8yd479saE8g4w0p1GUWwtN5b2H9a5OvIBZwtyd+
 PR/0IV+CgpkSQo1F1DurPUne
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639042"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:47:58 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:47:58 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 0E06170236E;
        Tue,  1 Feb 2022 15:47:58 -0600 (CST)
Subject: [PATCH 02/18] smartpqi: add PCI IDs
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:47:58 -0600
Message-ID: <164375207802.440833.15947108153078495425.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add in new ZTE controllers:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
ZTE SmartROC3100 RS241-18i 2G       9005 / 028F / 1CF2 / 5449
ZTE SmartROC3100 RS242-18i 4G       9005 / 028F / 1CF2 / 544A
ZTE SmartIOC2100 RS243-18i          9005 / 028F / 1CF2 / 544B
ZTE SmartROC3100 RM241B-18i 2G      9005 / 028F / 1CF2 / 544D
ZTE SmartROC3100 RM242B-18i 4G      9005 / 028F / 1CF2 / 544E
ZTE SmartIOC2100 RM243B-18i         9005 / 028F / 1CF2 / 544F

Add PCI ID for 1100-24i controller:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
HBA 1100-24i                        9005 / 028F / 9005 / 1304

Add PCI IDs for HPE and Adaptec devices:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
Adaptec Smart HBA 2200-8io /e       9005 / 028F / 9005 / 1463
Adaptec Smart HBA 2200-16io /e      9005 / 028F / 9005 / 14C2
HPE SR308i-p Gen11                  9005 / 028F / 1590 / 0382
HPE SR308i-o Gen11                  9005 / 028F / 1590 / 0383
HPE SR932i-p Gen11                  9005 / 028F / 1590 / 0381

Add PCI IDs for Inspur controllers:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
INSPUR RS0800M5H24i                 9005 / 028F / 1BD4 / 006B
INSPUR RS0800M5E8I                  9005 / 028F / 1BD4 / 006C
INSPUR RS0800M5H8I                  9005 / 028F / 1BD4 / 006D
INSPUR RS0804M5R16i                 9005 / 028F / 1BD4 / 006F
INSPUR RS0800M5E16i                 9005 / 028F / 1BD4 / 0070
INSPUR RS0800M5H16i                 9005 / 028F / 1BD4 / 0071
INSPUR RS0800M5E16i                 9005 / 028F / 1BD4 / 0072
NT RAID 3100-24i                    9005 / 028F / 1F0C / 3161

Add HPE and Adaptec OROC PCI IDs:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
HPE SR216i-o Gen11                  9005 / 028F / 9005 / 036F
Adaptec SmartRAID 3284-16io /e/uC   9005 / 028F / 9005 / 1473
Adaptec SmartRAID 3254-16io /e      9005 / 028F / 9005 / 1474

Add PCI IDs for new channel controllers:
                                    VID  / DID  / SVID / SDID
                                    ----   ----   ----   ----
Adaptec SmartRAID 3254-8i /e        9005 / 028F / 9005 / 14A4
Adaptec SmartRAID 3252-8i /e        9005 / 028F / 9005 / 14A5
Adaptec SmartRAID 3204-8i /e        9005 / 028F / 9005 / 14A6

Align PCI IDs with OOB driver
Realign the PCI ID table with our Out of Box driver.
Easier to check for differences.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  108 ++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2db9f874cc51..d34e49caa3f3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8941,10 +8941,6 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x152d, 0x8a37)
 	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       0x193d, 0x8460)
-	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1104)
@@ -9041,6 +9037,34 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0054)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x006b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x006c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x006d)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x006f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0070)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0071)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0072)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -9197,6 +9221,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1303)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1304)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1380)
@@ -9257,6 +9285,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1462)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1463)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1470)
@@ -9269,6 +9301,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1472)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1473)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1474)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1480)
@@ -9293,6 +9333,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14a2)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a4)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a5)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a6)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14b0)
@@ -9309,6 +9361,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14c1)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c2)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14d0)
@@ -9413,6 +9469,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1590, 0x032e)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x036f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x0381)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x0382)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x0383)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1d8d, 0x0800)
@@ -9437,6 +9509,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1dfc, 0x3161)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f0c, 0x3161)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x5445)
@@ -9449,6 +9525,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x5447)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5449)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x544a)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x544b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x544d)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x544e)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x544f)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x0b27)


