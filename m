Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9896A1DF98F
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 05:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754890442; cv=none; b=U27oxkma4hxoXp7ixnWuC6WKLcHrKF5ahU5CscUHb51O9M5iGO4RKe58vm27maBBcnNshfQx8SnGhO+AUMnjsvdbnZN1Rgq+mTALk7zK4NSHDCwzD81ZXKxq82Jbe5MIE+M2i7kD78KdoXUGHdCqQCvNW2LjSm05XKDYCEeeRms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754890442; c=relaxed/simple;
	bh=5sIIX3QUuzaegHNd+6NUT4Vvb6PsIrXVllYiGJIz/tE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OCKLDjrg4qQ/62vtVUidLuP/hr1Ifc6k54Mh/1xNt3Spj055XTqK3JUa9EFWUnTIVmuJV5arXBzCXsh/13oBi8ls3gvIGFYWy3UyHYNEpZF3UmseUh2kZYEF7Wn323/zMLR4oCkMZiOQxNMdpibrLiAZuazJn+Xs2gIsDjlSbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YVgafQ9d; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YVgafQ9d"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-b4209a0d426so4002143a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2025 22:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754890440; x=1755495240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHnkr22dY5CgwiPLBWthXGPdFU+dhhWu46oxcV2g8cY=;
        b=oY8GQMdzI+TPztPrr7cC1RqII3fGHygXZ/p9RUZzUEQ5773zdyhB4rX4xNwaOHfvBO
         TdilOkBtea+Adq5se/vsQb5rZEcVWH25bg+nyGyX0RAz6oQvY7G4Kak2OOiLuM+7zeY6
         GXU7jL4tb79iEEyMswkS5lObkq9mLOpJRyq0Jl3ll+FMruKBipZs6FJVtsgDc51rzKU5
         mNgEqmUR9oosHNLt2LH3EVtSmAfoYd6Be2P5SF1cwYJ46wWzajym/5EuKtY5NC2ApiiU
         Vm5ubTBk2zYAoHT3YxJ3LtXpjIY/W4b9LiONnNVyN/olcLmZkvSg7/3BkIbjDPdx9ULk
         7whw==
X-Forwarded-Encrypted: i=1; AJvYcCUqQbIhy5WsdjHu4neJGB9CvEC8RDi3lkLswD00L8AcGTQEPijHpHyDOQvlND0bdJWLPsbQ403h3AMc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3lxDx909ljnD6Na2P2QeJAKhd4zHWSnSte6661Dh/7mF6oLL2
	wIY7kwa2dmB4vUrfpW1DTh4jVpZB/Ho3pUAOYR9d1VqSoyrubLDbBXLdsZJidzoYBSqo9WQq8Yq
	bWdW7qJO2oiEdojpKBhPcLOd3GSV/FwRpRSW9u0NxMLtXHQcjUpPrPqWGQIZbHGMHQKjjKNhwMc
	+TFvoyvuf+5VlLc1e3Oo9UxSs8y/vXo0UCKBjKU4/CsSbji2+MlfJkudMnzPgHSK0EmG/LNO055
	rhfpvjuxSinMyVj77eJOoU=
X-Gm-Gg: ASbGncsN7CrZQMnNfelhadVpkvVHd0WMG4pxbaf01F8KSqA4ezfRthKf+qz4ZkLQzRR
	9nNNUIJZfDPkOUa94OiIqjruP+JPUAU36ksX+7AuZrXhOLQd6a6BgtCUk9ddt89LimDoAMm4NU8
	QkNC6Y/Y4aDDyss55mIVFrVo5qHrMyjQh/tjV1W0LI6yJ8J8BHq4uV84Ue3gMkhkZv1A63Ztmev
	bEuyYuF/AX4rp5lH5JWi8GdbocUeN1hoS1LRGIHoSvV3TRQkY/2gPcJeX3WAKx6wD+rsgt/sGxF
	naFX2wa1/L+FB77YjiE1jV9FdZhSG2MQOQfrX6ZB8v/KjPprTVTSEQvIIboUQmC+DfhegoDQ8kS
	2g2leYVpzOg/4T4cF/u/bQsALT2YhZFzGEECQjru7BuM3sBibdwFbHidxTri0R1Braq9cjM0x7F
	vm
X-Google-Smtp-Source: AGHT+IHFBrNsUUdLDC3PLzF2l69Y7wDNdXeyKutlGKJk6JjkY3gc3pN4yHt1wdcF4CRrbHv5DwE8/utoGPj5
X-Received: by 2002:a17:903:1987:b0:242:abc2:7f32 with SMTP id d9443c01a7336-242c1fdc798mr154979705ad.3.1754890439784;
        Sun, 10 Aug 2025 22:33:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-241d1ef433csm15929485ad.15.2025.08.10.22.33.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Aug 2025 22:33:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7e7ffe84278so850181885a.2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2025 22:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1754890438; x=1755495238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RHnkr22dY5CgwiPLBWthXGPdFU+dhhWu46oxcV2g8cY=;
        b=YVgafQ9dJy24TVE3kDw0J/6CbufH16fDtt4Wa489IIVtriWxrR1R3FSIok7L6am0HN
         WQ2Zvlb9+MkoIlYY4Th2VJ7HfWIW1Pt9eFQQFE0uJ6HjDkAOiiSFjOhZSQDog7ve84lZ
         bkdqvkULAREXFAN4FuMm3BXpJ5OF0Z4bEEYOU=
X-Forwarded-Encrypted: i=1; AJvYcCX649dD6EFUddbRPVUn4IeZ/RM4bDRmNij67ngieq3Tb5MrAxbZR/cWOQkuPK6cly5uKMBpUbnaZI+P@vger.kernel.org
X-Received: by 2002:a05:620a:190e:b0:7e6:38ab:fd8d with SMTP id af79cd13be357-7e82c79fc28mr1849180685a.50.1754890438301;
        Sun, 10 Aug 2025 22:33:58 -0700 (PDT)
X-Received: by 2002:a05:620a:190e:b0:7e6:38ab:fd8d with SMTP id af79cd13be357-7e82c79fc28mr1849178685a.50.1754890437784;
        Sun, 10 Aug 2025 22:33:57 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e816a9a3cdsm769870885a.23.2025.08.10.22.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 22:33:57 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	jinpu.wang@cloud.ionos.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	Ajish Koshy <Ajish.Koshy@microchip.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Viswas G <Viswas.G@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v5.10] scsi: pm80xx: Fix memory leak during rmmod
Date: Sun, 10 Aug 2025 22:20:35 -0700
Message-Id: <20250811052035.145021-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit 51e6ed83bb4ade7c360551fa4ae55c4eacea354b ]

Driver failed to release all memory allocated. This would lead to memory
leak during driver removal.

Properly free memory when the module is removed.

Link: https://lore.kernel.org/r/20210906170404.5682-5-Ajish.Koshy@microchip.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f40db6f40b1d..45bffa49f876 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1166,6 +1166,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 		goto err_out;
 
 	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_count = ccb_count;
 	pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
 		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
@@ -1226,6 +1227,16 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	scsi_host_put(pm8001_ha->shost);
+
+	for (i = 0; i < pm8001_ha->ccb_count; i++) {
+		dma_free_coherent(&pm8001_ha->pdev->dev,
+			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
+			pm8001_ha->ccb_info[i].buf_prd,
+			pm8001_ha->ccb_info[i].ccb_dma_handle);
+	}
+	kfree(pm8001_ha->ccb_info);
+	kfree(pm8001_ha->devices);
+
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 5cd6fe6a7d2d..74099d82e436 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -515,6 +515,7 @@ struct pm8001_hba_info {
 	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
+	u32			ccb_count;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
-- 
2.40.4
