Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C762D46CE
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988598; cv=none; b=U6WtqABZAxLyEqtb38OfJYpkejS7ZNo62weH513InCU656mOhjMYWS+TqlrddvPtWUyvR0XrYOMwG9F3utCoCFcoRvXjF3KriG6MGpe5cWbbNmv2uCCJmRKWJI4n/+ECXCtG/8fhg+hdBIQgNtHlbt4ZJwwYLb+o2GDJw0HuGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988598; c=relaxed/simple;
	bh=yu69Bnk77Ssy2HsyLYYPu58MEZx77ESZUz8BJpkU2yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kKaNLGFUywuzzCIYfZuUvPjN5qqjWBuWtKxWEsDYn8JZpacm4BTEVMOgeQJmETSmf5Rk4DOiuvEakS6jcSV2pXyXqewQei4zuXZsgUeVhFBoW3NbQdk/Qs+ZIMWiDA5E1JySrTNUbRMdT9D+4kN5ZlIkZ9mM1FwnmR+34TDBF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BAAYdVmu; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BAAYdVmu"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89fc349b5ceso47592216d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988596; x=1775593396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paZtgLFbA2mdeDtGTPgrxpAwURmrAuaLNXV+VKwmOgs=;
        b=BAAYdVmubIL+92guWsBub6SLutydDKcMH6739ssjsqFszLDdnyCVnHaGGpwDhHpb5J
         bY1YGdJs0gGakO/AvywMgsyn5HG7+DCH0dgD234bxbs8CX1SZ+++Bx1Gg8fQJGR/4yOr
         2wmlR+dRprdQlGHlD+DXpHHvJ/vzgZnTeSqH/PQUYt1hdswb+b/Qug+HzyQeOeqw0ngq
         Ex3lT3AM7Psx/kIDItz7uZafp+RhRh6+0Dl8Jr1kbU2jDHMZJEkEpQGVppwxFkaBg5nZ
         x78OMM1OY27EGoLkXGiuJwTmTZrQLkC5z4COMtM3i47gC7/eULYYwLM9DYfuHKvLlUo0
         OMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988596; x=1775593396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=paZtgLFbA2mdeDtGTPgrxpAwURmrAuaLNXV+VKwmOgs=;
        b=I6LMykQQeLdWKt6BIYzqvScQsj3/VSZWycCA9tIrncxba2QoeH1ZhK+kcwP2Od0JXo
         IvNnF0Y8KcfkdiOZA9ihVPhcuwTny3HLyQofxf8i+OJBn53sJ14wgkyc/uYx5zOGrLFi
         aa9l0fDK8cRA8ipO45qg3q5JLVwXdSxc+g/Pu1g6CizOCxQuvU5W+/p+JKqmZyyheIPh
         VR6kxZ+XlmcdldvFco57D4TQUdP4pR9U9uK6jL3eLf6ddsJqP+ehCi6JQ1znM4zxBk/r
         IOcvVN7p5onUGG1eOXwyS74jW2L/4oeRzMG3hjAHJ8+24pb07cviTp65W16LrgHs4SeE
         Z/Lg==
X-Gm-Message-State: AOJu0Yzx1r31lUTtJyfkBvPVTx9u0pYm5jwqehprD/mpXPG7QukCvlq6
	VME760crOQMI+q6Lo50I6YVMXeyAbN3IAWB7J0mOFH+0BiQKuV4QM35bH4Ly3g==
X-Gm-Gg: ATEYQzzey4dWSQRP5XpyA6+oGJpORt8FMDqvehevEnphyiZTRTU7MGSgfc9i66+41pS
	9HyhZtst9Yjv1g9xHYdj0/UfmdNfIaODPS8lyypv9iulW9cwhpy/zv0a2u7CPZ+WSJgZtz6tiWA
	ahVflT/UWKXSov/HNCymnF3TJVJFNVfOWndZX7kSIYGiDgkYyKaOeovoBzQr7lohasj/Gyn2HJ9
	KT/mcubJUtOCf9jXy2pL1avq2AcvQAY7nX53dAUWAmliedBFeg4xjRhQR2flW7CDD4e+Fdl+Dda
	ZnafwcmAkJh+21P/4GhYM7waUTXoj2ygvTwwTpOcglSmSUxDcaT9BdFoxEBs+cEjbhyGogt9QrJ
	toNO53xX3uC0i6Y7O2x74CQcbyz0DxuDDz5gtUIDXGJ2P+tLA+HuQkgZ0TdKtCpzNSmOcPmJRIa
	PdtLn+SG6soV9NtH/4FBiSEJqFQaDfJHz/KBJdgugtbOhqguoYaGv6OSMw0e+0dsX3mRKrtqWp3
	JgbhT+/9hx7TGSRQviTYyPv/zJ+BMac3b+mgCSeIro=
X-Received: by 2002:a05:6214:5281:b0:8a3:221d:9095 with SMTP id 6a1803df08f44-8a43720ca8cmr15309486d6.15.1774988595977;
        Tue, 31 Mar 2026 13:23:15 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:15 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/10] lpfc: Add PCI ID support for LPe42100 series adapters
Date: Tue, 31 Mar 2026 13:59:27 -0700
Message-Id: <20260331205928.119833-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Update supported pci_device_id table to include the values for the G8 ASIC
Device ID utilized by LPe42100 series of adapters.  The default reporting
string will be "LPe42100".

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw.h   | 3 ++-
 drivers/scsi/lpfc/lpfc_ids.h  | 4 +++-
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index b2e353590ebb..6326f7353dd6 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -1771,6 +1771,7 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_LANCER_G6_FC  0xe300
 #define PCI_DEVICE_ID_LANCER_G7_FC  0xf400
 #define PCI_DEVICE_ID_LANCER_G7P_FC 0xf500
+#define PCI_DEVICE_ID_LANCER_G8_FC  0xd300
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 0b1616e93cf4..a0a6e2d379b8 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -118,6 +118,8 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G7P_FC,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G8_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 70cdb039ef4e..7fb6b8e9cdf2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2757,6 +2757,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	case PCI_DEVICE_ID_LANCER_G7P_FC:
 		m = (typeof(m)){"LPe38000", "PCIe", "Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_G8_FC:
+		m = (typeof(m)){"LPe42100", "PCIe", "Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
-- 
2.38.0

