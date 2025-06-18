Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467213085C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272983; cv=none; b=APXgjsJYNt/924/nilago7g/KQ5sySyksN9sKKrU1FsqVue43S/oZiVyK/mlXj3E+/M/uaWdlvjibrDOvmNzZcxKJWg0ofhf4cctZ8S1mBlxkJ0Fu5WJQcPMBltLMTgQ9wXk+59F62XbGmGPFd1z+vcg7eqHeOGIBv5SbR9sc7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272983; c=relaxed/simple;
	bh=O+KAUYhkOiez9AFyEALk4BdZily+oxamgVCzwEfU8C4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p2AnQThgBjEpfYO/qyLtnF4RJ68/Fkcclumw0EflwiPExYMcZQEUgqwuU5AcU4Pm5VxXmfORuTbR6W63ntxiizLI57gJrBlqjpIBUAt+Kiq9Fgg1ngZFu8vZ85Tzde1Sh3gJMG6Riu0YiuwEA8NBqeIu6qFJnsqVIvlkOXvIi2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrVETSBG; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrVETSBG"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b2d46760950so32190a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272981; x=1750877781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkEns+egv8M2ld/e+MFUlZWchmSHO5ZckG/2zCDtOMU=;
        b=DrVETSBG8ZFAe7HsSwJ7iDNyffTzmqKMdbTTuvSm4wSu0PT338ESSpWEakhc0NGb2U
         0TZPk4kiYS498gIs5+jYy4a2lcgy30VVGjlCS5gc7fnB1Tbcpi8TytVkQP7SHwpnAdtf
         4lp3UCE7kX0VTxbyz6+gAu2AJ+Ti7MFwkZdqdvvaa1WHfip1B/uhbhbRE6m5owOx5Tus
         ubfI4KsztnrHOSKj/NT4zSHyif1mGGJuF+z5omP7oyi5VTHQmRBfTthwG8iWiRbZ1+YW
         8mRjgwv2Lr4fW8NhJAJhInjQy90v2vd9Gb6L8DeYGeHLvkNUDz9OaEeQKt7XTgWR3NO+
         /rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272981; x=1750877781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkEns+egv8M2ld/e+MFUlZWchmSHO5ZckG/2zCDtOMU=;
        b=gqMz38cIXZTJEY65izCdz83diUAaETq1/+yG9Bfsk4iZYWxI87Ot4UdvvYjThMqNaO
         GYJB1OgayZliCKEIsI9fp9Pzv850dFVebTmbeO9fVHGled8wtyd+UWqGo9Wi5jtBPEDZ
         hlfeCqjSNumHmAhaVsC5Qm9/ZJvDB61lHpzRA8+CAp3532UhJ1EmE+oMGZCaOn8cuXj+
         uzaVgZO1ryoqIbQB/8EHoCUfBE7BuhmFqDfspSu851tmkurNLvqvAJM2qyLhiPR/cRJw
         a+KmIUH8Vl9oHYyoj1TNDTTMV76+lWfyg2JkGhCxHoI0x/fsHjsuYdX8FfhxwzSTcAE4
         J6nQ==
X-Gm-Message-State: AOJu0Yzc0FPYIHAVbOu1GE1K4lNZncOvZinXODeqnzKEBcURCcSU/qps
	Q7eEt6INx7XUeHLipZrmC+SyuaugrLeGtiroIFnoZLevvyID9sAp4S47UleEPQ==
X-Gm-Gg: ASbGncvLJ3Wn3MCCVCRqztosYNX3Hc5cWcJlzshEzVc6LlFTwvJt9cxSXfQp84yA8KD
	YsWdU54c0TbO2rYTpLRrmQiUYUBRskbg3EGLRvIumCpcd65LQrdPvCzcaSV11FqumRLuzG4s2wX
	45PoFhpRhRFPM2lq2CsvzeQFpc5j4XThOVuaUTPwt0VQezzLlvDWZ1expDjqlgc2pCp/MSyjUJ5
	ENp97O5qArtEhHI6sdztuiiPRHVF8VLve64V/IIZutZYDgx5ClaggdmWNgeg+6VO/7hFKfYgWBF
	2dKdL68hF12X5Q81YPvSq8BbBxk8WWPlOqJBQcmmlaGBXHgwEPa3U5/brIRbT9MMxLNcT/gb1tk
	coRtjN4gmZOaQSFGNmsEFXoovu/CXXbEaeerwJjPzsxZXK7k=
X-Google-Smtp-Source: AGHT+IHhcPrIMHUzudJT8Zw/Q92YzGImAi/WoEQNeQjozsXyEuzolseCrGNpO1hdxgsPoL1hBTSI6w==
X-Received: by 2002:a05:6a21:7702:b0:1f5:64fd:68ea with SMTP id adf61e73a8af0-21fbd54d5f3mr26175554637.4.1750272981432;
        Wed, 18 Jun 2025 11:56:21 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:21 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/13] lpfc: Modify end-of-life adapters' model descriptions
Date: Wed, 18 Jun 2025 12:21:36 -0700
Message-Id: <20250618192138.124116-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Obsolete adapters' model description strings are updated to indicate that
they are no longer supported.  End-of-life adapters will still remain
probed by the lpfc driver based on PCI id.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 55 +++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7695a815de7a..4081d2a358ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2627,27 +2627,33 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BMID:
-		m = (typeof(m)){"LP1150", "PCI-X2", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP1150", "PCI-X2",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BSMB:
 		m = (typeof(m)){"LP111", "PCI-X2",
 				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
-		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe11000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_SCSP:
-		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe11000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		m = (typeof(m)){"LP2105", "PCIe", "FCoE Adapter"};
+		m = (typeof(m)){"LP2105", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		GE = 1;
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		m = (typeof(m)){"LPe1150", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe1150", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		m = (typeof(m)){"LPe111", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe111", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP101:
 		m = (typeof(m)){"LP101", "PCI-X",
@@ -2666,22 +2672,28 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT:
-		m = (typeof(m)){"LPe12000", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe12000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_MID:
-		m = (typeof(m)){"LPe1250", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe1250", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_SMB:
-		m = (typeof(m)){"LPe121", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe121", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_DCSP:
-		m = (typeof(m)){"LPe12002-SP", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe12002-SP", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_SCSP:
-		m = (typeof(m)){"LPe12000-SP", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe12000-SP", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_S:
-		m = (typeof(m)){"LPe12000-S", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe12000-S", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PROTEUS_VF:
 		m = (typeof(m)){"LPev12000", "PCIe IOV",
@@ -2697,22 +2709,25 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		break;
 	case PCI_DEVICE_ID_TIGERSHARK:
 		oneConnect = 1;
-		m = (typeof(m)){"OCe10100", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe10100", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		break;
 	case PCI_DEVICE_ID_TOMCAT:
 		oneConnect = 1;
-		m = (typeof(m)){"OCe11100", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe11100", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		break;
 	case PCI_DEVICE_ID_FALCON:
 		m = (typeof(m)){"LPSe12002-ML1-E", "PCIe",
-				"EmulexSecure Fibre"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BALIUS:
 		m = (typeof(m)){"LPVe12002", "PCIe Shared I/O",
 				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FC:
-		m = (typeof(m)){"LPe16000", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe16000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FC_VF:
 		m = (typeof(m)){"LPe16000", "PCIe",
@@ -2720,12 +2735,13 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		break;
 	case PCI_DEVICE_ID_LANCER_FCOE:
 		oneConnect = 1;
-		m = (typeof(m)){"OCe15100", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe15100", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FCOE_VF:
 		oneConnect = 1;
 		m = (typeof(m)){"OCe15100", "PCIe",
-				"Obsolete, Unsupported FCoE"};
+				"Obsolete, Unsupported FCoE Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_G6_FC:
 		m = (typeof(m)){"LPe32000", "PCIe", "Fibre Channel Adapter"};
@@ -2739,7 +2755,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
-		m = (typeof(m)){"OCe14000", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe14000", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
-- 
2.38.0

