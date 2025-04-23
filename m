Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90954266B4E
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433163; cv=none; b=f+dp8p5H/n72sXEsBoj3KUa5rU1VwPba8ZRaSaGyJggt64kbrywWJ3d9ZHdGfMBIUCSpwDHat281WeNIdJ5rciQyPIJlaU/+T01Apd/Nu5PPXumceCZWi9MaygubqM7GilWbHOfvVdGdVr43ReLGbsXn0riuZFOKBt8LxUs0JNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433163; c=relaxed/simple;
	bh=sKdI9FBvDGNwNh15EOOLq4L2vmiU8Q+Th1XJGhRD6SE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nhaq/n4wK/lQBPT6g9ysJybYNij7211YeSOHcWeIuMf9jEkPDDqA7hdbhaFNEmLgfP7p3fdj/kB+NvExdpMBL2JLYiSOPslTCa2zYssb1mJK1R5EjNwMpUvzlYwxLRDUd0kxnR0AulfVZbTO/kN7X5+iAnQNnljiICHaQR0/6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=pt4mwMwA; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="pt4mwMwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433161; x=1776969161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sKdI9FBvDGNwNh15EOOLq4L2vmiU8Q+Th1XJGhRD6SE=;
  b=pt4mwMwA9+bMHDGi6LqMWwVM67Ga8/tKUNl+2wmQUsVzAaWQc5jvdLNC
   iSRhw8aAUAJHj+VMdsSq4P9zmjxdrVA4m8hpRTGmwhF8PUG1S3WI/dPY4
   nYxoe9X9OO/axbImN7ttzkyxXbVuRimjnv84Lrm7Lqxsg/JUvkNgO90/D
   jc1L5gl7O5f0AB0FxYrWaWRYSDXM5B08THi2YcQSLnjJ0RO5IB2WZQ8vD
   axLNVEDJSeCE/CEHAZ4pCM+VZCKLQPSBFe2e0NBirvxDYB0YJBP7j54Gp
   zaFrmuGsix7fLFvxAzGQng5O4iBxfO7RYALBUgzdosxvo7k14CBx5/otO
   Q==;
X-CSE-ConnectionGUID: Vsy3DPLGRV+QHyOkpBwADA==
X-CSE-MsgGUID: xs6VSAsWSN2idKjAMb6ODw==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="208323915"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:32:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:33 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:32 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
	Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/5] smartpqi: add new pci ids
Date: Wed, 23 Apr 2025 13:32:26 -0500
Message-ID: <20250423183229.538572-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.49.0.391.g4bbb303af6
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: David Strahan <david.strahan@microchip.com>

Add in support for more PCI devices.

All PCI ID entries in Hex.

Add PCI IDs for Ramaxel controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      Ramaxel SmartHBA RX8238-16i 9005   028f   1018   8238
                      Ramaxel SSSRAID card        9005   028f   1f3f   0610

Add PCI ID for Alibaba controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      HBA AS1340                  9005   028f   1ded   3301

Add PCI IDs for Inspur controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      RT0800M6E2i                 9005   028f   1bd4   00a3

Add PCI IDs for Delta controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
ThinkSystem 4450-8i SAS/SATA/NVMe PCIe Gen4       9005   028f   1d49   0222
24Gb HBA
ThinkSystem 4450-16i SAS/SATA/NVMe PCIe Gen4      9005   028f   1d49   0223
24Gb HBA
ThinkSystem 4450-8e SAS/SATA PCIe Gen4            9005   028f   1d49   0224
24Gb HBA
ThinkSystem RAID 4450-16e PCIe Gen4 24Gb          9005   028f   1d49   0225
Adapter HBA
ThinkSystem RAID 5450-16i PCIe Gen4 24Gb Adapter  9005   028f   1d49   0521
ThinkSystem RAID 9450-8i 4GB Flash PCIe Gen4      9005   028f   1d49   0624
24Gb Adapter
ThinkSystem RAID 9450-16i 4GB Flash PCIe Gen4     9005   028f   1d49   0625
24Gb Adapter
ThinkSystem RAID 9450-16i 4GB Flash PCIe Gen4     9005   028f   1d49   0626
24Gb Adapter
ThinkSystem RAID 9450-32i 8GB Flash PCIe Gen4     9005   028f   1d49   0627
24Gb Adapter
ThinkSystem RAID 9450-16e 4GB Flash PCIe Gen4     9005   028f   1d49   0628
24Gb Adapter

Add PCI ID for Cloudnine Controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      SmartHBA P6600-24i          9005   028f   1f51   100b

Add PCI IDs for Hurraydata Controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      HRDT TrustHBA H4100-8i      9005   028f   207d   4044
                      HRDT TrustHBA H4100-8e      9005   028f   207d   4054
                      HRDT TrustHBA H4100-16i     9005   028f   207d   4084
                      HRDT TrustHBA H4100-16e     9005   028f   207d   4094
                      HRDT TrustRAID D3152s-8i    9005   028f   207d   4140
                      HRDT TrustRAID D3154s-8i    9005   028f   207d   4240

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 84 +++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 73f576ccf511..3cb8619e9ce9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9731,6 +9731,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0089)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1bd4, 0x00a3)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x00a1)
@@ -10067,6 +10071,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14f0)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4044)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4054)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4084)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4094)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4140)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4240)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10283,6 +10311,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cc4, 0x0201)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1018, 0x8238)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0610)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
@@ -10291,10 +10327,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0221)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0222)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0223)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0224)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0225)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0520)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0521)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0522)
@@ -10315,6 +10371,26 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0623)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0624)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0625)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0626)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0627)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0628)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1014, 0x0718)
@@ -10343,6 +10419,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x0300)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1ded, 0x3301)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x0045)
@@ -10491,6 +10571,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1f51, 0x100a)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x100b)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f51, 0x100e)
-- 
2.49.0.391.g4bbb303af6

