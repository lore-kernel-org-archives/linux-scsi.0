Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE80F26F2AA
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447168; cv=none; b=CmscQSrOA/6r5obu/2HeET0xmRHwGsz86xmsWskEGu9VmjGI9m7rdrM6drGe3B5HPC1LP0cfviq0Qq1pDaS2H8NaiUISs4aEDNjf9P+P40kalXwuyDQDUPLdvuAGaHXilHlDhe9KZjEI5bkLq7mFsSCqe+7CvhQp/vSRdhK3hv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447168; c=relaxed/simple;
	bh=fKIIHMqS043V+7GHtqmj05Dg9pT/kcH0VLi7lVvvtSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=to4RhZXifls2mSYQhE9DVa8dPNrkX3W1SEPcKgbvM0JEA9lZU22zz8HqXys+/dD96fkjoRLl2pu89XiJ0EXMprMPzY8pmYN6ax2rKjMBFSfDgnqQgpBnsTAb8bw+LlcHOdeZr6utcJ94XYkLE7+np7bRfvDk3LI8qyY6Ip/3vCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=2pee3j+K; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="2pee3j+K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1762447167; x=1793983167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fKIIHMqS043V+7GHtqmj05Dg9pT/kcH0VLi7lVvvtSg=;
  b=2pee3j+Krh4CdSl2Vg6cK4lpNJtIBhoLwKZ3a3dCtNIOzgQQc+XcyJdd
   P1h2suvgnthYaxxWnhWVrNZpmQ5l5OiupAOtNO2C51vMjFQoWjnyjB/95
   pdPh89rtwoTjylsq1hP05MHXDKGlAs4UFhhoNYGoAU5a1S3bsZSl7uF2E
   GEydeF5jJy9PG7u/sy+23R/gsY2ZD0TWryzuqbY56ApB4on2jNIgdT6XK
   6oYRfJek9m6RGhZb3mYMREP+rKv5Tfm+Ev3yMJwzcS8bqjaHgv71gscA5
   7NoovtpuQo5lbtCDQFvmAIQyVo4eW5Sr+AW0ALHytVbPxvzNoSWZfCsJh
   A==;
X-CSE-ConnectionGUID: IZGandKFSnyP1vRZ74pa6A==
X-CSE-MsgGUID: 9rD/u/MfTPqK1WXQW4u1pg==
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="48785162"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2025 09:39:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 6 Nov 2025 09:38:28 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 6 Nov 2025 09:38:27 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
	<cameron.cumberland@suse.com>, Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/4] smartpqi: add support for Hurray Data new controller PCI device
Date: Thu, 6 Nov 2025 10:38:21 -0600
Message-ID: <20251106163823.786828-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.52.0.rc0.28.g4cf919bd7b
In-Reply-To: <20251106163823.786828-1-don.brace@microchip.com>
References: <20251106163823.786828-1-don.brace@microchip.com>
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

Add support for new Hurray Data controller.

All entries are in HEX.

Add PCI IDs for Hurray Data controllers:
                                         VID  / DID  / SVID / SDID
                                         ----   ----   ----   ----
                                         9005   028f   207d   4840

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8c4ea4dc5803..3886559a5eaa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10145,6 +10145,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4840)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
-- 
2.52.0.rc0.28.g4cf919bd7b

