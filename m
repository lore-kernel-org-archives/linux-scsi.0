Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42BC19E7F3
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727256; cv=none; b=UsCPAmRUQGomWWcPdBOycSNryG5yba94WRFuHEPBDK08sK+huFxVOsm4Gx4BnXaP7UB0a/w8SD1RYCW0nBEGVErV9N+zQY6GkQ/zFyB6uoMR6O+NtNZ9+P08HuXNfTJM5GIWkJ+TNMFxJcQwuI2B6eIlmbIoogL6l62s8/MLR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727256; c=relaxed/simple;
	bh=hVNqxAR8I2y+Q2opg/Mi4CyC86GcRp8uzkOEikAOozo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pz+M1NJcMTBhMb/21nlMGraxe4vwwcZrpsj0kWNMuVS9m/jfiuCp7vMp7NaNow3yTVVoGPb1/ntHrcESAiE7jTEA1NomFfyGQZKb7vctyI8SYpT0O2DJuxkkJJq/HUjq7AiQX1f2q+ypFclOIKHcitSHD+4DVr5IJpO6Uu9Pd3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=HwDpDySr; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="HwDpDySr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727253; x=1752263253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hVNqxAR8I2y+Q2opg/Mi4CyC86GcRp8uzkOEikAOozo=;
  b=HwDpDySrqgk8hBVuX8JmDLYdccuZipHKLkEX0zWXgbJLRVJlPOKT9B0L
   sSvtXsg5EqorViaf3Y+uNpxu9pwtvje3o/gxzSjCGRtoJF7swmXw4snpo
   eHfF7NVRRn/qIi8G07FCxH/esyTPIffLL8xeOp/AYJHK/YrO6SoxgCsZx
   RxwMWvluLv2SoCT3wkvH1/vt+nQjetmXoeFRZDXhGECUPN5S3UMTL7x8G
   DrUjyE0d9pHz8naQinIgkE/rXeB9qGyQALvAPC0mq2n1HTgWNcoTIKs0a
   M0WG7Hy5h/2qQaei1pRf4fY2G8SmJrZ1qbP8VH3dBNphJ4shZoEYgQtw8
   A==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: 561ybA73TDqg5ml6O3tMMw==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106953"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:06 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 11 Jul 2024 12:47:05 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/5] smartpqi: add new controller PCI IDs
Date: Thu, 11 Jul 2024 14:47:00 -0500
Message-ID: <20240711194704.982400-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.45.2.827.g557ae147e6
In-Reply-To: <20240711194704.982400-1-don.brace@microchip.com>
References: <20240711194704.982400-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: David Strahan <David.Strahan@microchip.com>

All PCI ID entries in Hex.

Add new inagile pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            SMART-HBA 8242-24i               9005 / 028f / 1ff9 / 0045
            RAID 8236-16i                    9005 / 028f / 1ff9 / 0046
            RAID 8240-24i                    9005 / 028f / 1ff9 / 0047
            SMART-HBA 8238-16i               9005 / 028f / 1ff9 / 0048
            PM8222-SHBA                      9005 / 028f / 1ff9 / 004a
            RAID PM8204-2GB                  9005 / 028f / 1ff9 / 004b
            RAID PM8204-4GB                  9005 / 028f / 1ff9 / 004c
            PM8222-HBA                       9005 / 028f / 1ff9 / 004f
            MT0804M6R                        9005 / 028f / 1ff9 / 0051
            MT0801M6E                        9005 / 028f / 1ff9 / 0052
            MT0808M6R                        9005 / 028f / 1ff9 / 0053
            MT0800M6H                        9005 / 028f / 1ff9 / 0054
            RS0800M5H24i                     9005 / 028f / 1ff9 / 006b
            RS0800M5E8i                      9005 / 028f / 1ff9 / 006c
            RS0800M5H8i                      9005 / 028f / 1ff9 / 006d
            RS0804M5R16i                     9005 / 028f / 1ff9 / 006f
            RS0800M5E24i                     9005 / 028f / 1ff9 / 0070
            RS0800M5H16i                     9005 / 028f / 1ff9 / 0071
            RS0800M5E16i                     9005 / 028f / 1ff9 / 0072
            RT0800M7E                        9005 / 028f / 1ff9 / 0086
            RT0800M7H                        9005 / 028f / 1ff9 / 0087
            RT0804M7R                        9005 / 028f / 1ff9 / 0088
            RT0808M7R                        9005 / 028f / 1ff9 / 0089
            RT1608M6R16i                     9005 / 028f / 1ff9 / 00a1

Add new h3c pci_id:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            UN RAID P4408-Mr-2               9005 / 028f / 193d / 1110

Add new powerleader pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            PL SmartROC PM8204               9005 / 028f / 1f3a / 0104

---

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 104 ++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 24c7cb285dca..9166dfa1fedc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9472,6 +9472,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x110b)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1110)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
@@ -9588,6 +9592,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0089)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x00a1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3a, 0x0104)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -10180,6 +10192,98 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x02fa)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0045)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0046)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0047)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0048)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004a)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0051)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0052)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0053)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0054)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006d)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0070)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0071)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0072)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0086)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0087)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0088)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0089)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
-- 
2.45.2.827.g557ae147e6

