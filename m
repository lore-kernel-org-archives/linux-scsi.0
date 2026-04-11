Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112023C8C7
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 08:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775894825; cv=none; b=kI508ouoDYiQm9kA5aD7r13bEi7pUhj7TLc+TG/HcA/XnCkaG274CeaSBu2qTvsHz66+eb5/6dcAUh+6YEJLHhsv9pIvzbKlA5kz35jLKnj0O/WDGx7V+3sJz/Vuj+pnytAJlmMg4AdMQwf7tCo+U3yEtJhrQg9J+5hP5LwSbxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775894825; c=relaxed/simple;
	bh=Ln9AS63EngCFfiuHW4w5QGFza/cqFFBHSsii/NBMjNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1ujOeID0XrYmBBv31ohxYURlIjzx5DFF5QVoqt/CHuuacwb/Zs6j1DO0tYm7P4+etQAvZySJIxEjjFh2QwEm2cqe1su5kvtbK6+RIoIDbam69IcWSQOTBAL5CGxWWg9B+sLV0IoDA0ofLVyxw45ffxb7Bp0I646rP7kD0A6ufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OreN+lTa; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OreN+lTa"
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-12c25b90264so1873479c88.1
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 01:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775894824; x=1776499624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fEU7yR5sJCU69J+H+ksKtM1IopDe6eUt21SCj44UVHI=;
        b=OFeYbAzK6gq4u3dr0FDdnq9z8Flbc68ruqBOEHxUZgCkrYQwu9otZJIFLjQ1QJAX74
         03VWG547kW1leXlMbMVMOKFwFq055V4LHo6tP6QWTtJycug1MgO3p8jDNwaaJetScadQ
         WlXN2Da3hEA4RAWh5PNgBlZdhzT66PqbpMdILgSPXN1BByOKc47nlz8Fd46fv4k81Enw
         T0NzTb7HIdyv2BYLTwDp8KRmLqEcI5VwKV/GhjW3Q1/U8msNC/BFO/9UzZKxGXjm/6VB
         FnEEimtyTs0QzeYLiJ6DZMBknR4MiIkEEO7OgEeKk3wIJZkKXjbkBiyEB6GtZ+5yfCo2
         Q+XQ==
X-Gm-Message-State: AOJu0YwgFY6PF28CvLiWBYRSWsOvTm0jMHh67hJ65k75VrSXo9X1gy78
	gI37vwS5V7UWlYuhvlkGmWnzYHZZV+aKllWgPImI7r/aKuQx4qCKwHsqSi102kWFRAhF2VYIQd+
	vtXpSjNJEbX704bANnC9NzgTE+ZBec2XQ1AQuMjALFoU3WbfHTPqWf3RmonHh2hydXC9RTHbltv
	cKPgHzqmPxtmMdKTufBrIVDFTn7kukEAOpwM10kE5+8WwFDjO3Rs43beEw32UBOd8duHVgOrbYo
	W+MxogDuvTcDLer
X-Gm-Gg: AeBDievoW4kHi6d5T1anHHnPw4BxGG+yAmdG8nr9bVEBNLeG9jOj/SKc7EpK+e6/6wA
	E0cJ898oNgzHFR/Wp/VSQK3J67MO3zgNxkSHs3ct5sh6HSTi2BGUBgzwRePkG5PkobCr9pqdlJP
	O1SqmHD61R2pb556GJFQKvUMR4FArX6fdUHbErEARRVlziNX0z6N5gBimY5ngL9PnifQhiTvso1
	LoVIALA4GRaKibUMQhHVhI7IijY0C/gT+I/nMoTo9c8P4+llaADut1xtVSBzHGf/E6sViW5u55o
	9KrnDO3KePm3Zw7JArqRthWav5YShO2HnlZZExKNvEe6Au+rGWvxst6VfdMqFCz7/rWcbDtink2
	1y0z6gdXfZzmZ3Qt6RUSV7E1c6J0OUV0Dvt6GzOfFKuAfqBxDnZcUTS+q0CebKVmf9SUkXWdYaB
	VF3WMqONiTc7UrxG5fOMSmlrQDwGUVzqKNd2w6LC3p3GaSULXuHPspYe2l
X-Received: by 2002:a05:7022:419f:b0:12a:b39a:3215 with SMTP id a92af1059eb24-12c34efc031mr3435361c88.36.1775894823537;
        Sat, 11 Apr 2026 01:07:03 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2d55edf22b8sm410275eec.7.2026.04.11.01.07.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2026 01:07:03 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82ce0a9e558so2223716b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 01:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775894821; x=1776499621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEU7yR5sJCU69J+H+ksKtM1IopDe6eUt21SCj44UVHI=;
        b=OreN+lTaCeZWqPFGYB+u2ynBjihrRu7j/WjAou7n1eeiNmkCnIOU0BhGFlzbPk57PS
         5CeZRaVpPoY6A+n5zpqUqHnk3Y9MjKLChMHBHY4V8DxQ/mdBeRlMR00A27Yk1QiBosLs
         VWgqdzfkcF1XEn6cbHIArtbu6YmdGXKojF0kg=
X-Received: by 2002:aa7:9e9a:0:b0:82f:1f49:dfde with SMTP id d2e1a72fcca58-82f1f49e255mr1373916b3a.37.1775894820643;
        Sat, 11 Apr 2026 01:07:00 -0700 (PDT)
X-Received: by 2002:aa7:9e9a:0:b0:82f:1f49:dfde with SMTP id d2e1a72fcca58-82f1f49e255mr1373885b3a.37.1775894820062;
        Sat, 11 Apr 2026 01:07:00 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b2455sm5083972b3a.35.2026.04.11.01.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 01:06:59 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	dlemoal@kernel.org,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2] mpt3sas: Limit NVMe request size to 2 MiB
Date: Sat, 11 Apr 2026 13:30:06 +0530
Message-ID: <20260411080006.50010-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411080006.50010-1-ranjan.kumar@broadcom.com>
References: <20260411080006.50010-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Some firmware reports NVMe maximum transfer sizes that follow the drive
capability. When those values are very large, the block layer may build
I/O that this driver cannot handle, which can cause a kernel oops.

When an NVMe device is set up, cap how large a single transfer may be
to the smaller of the firmware-reported limit and roughly two mebibytes
with a small margin. If no valid limit is reported, apply the same
upper bound.

Cc: stable@vger.kernel.org
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ff788557294..fca9d6722fc8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/raid_class.h>
 #include <linux/unaligned.h>
+#include <linux/sizes.h>
 
 #include "mpt3sas_base.h"
 
@@ -2737,9 +2738,17 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 				"connector name( %s)\n", ds,
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
-
+		/*
+		 * Firmware may report large NVMe MDTS values on some ASICs.
+		 * Limit max_hw_sectors to the smaller of the reported MDTS
+		 * and 2 MiB to avoid issuing I/O the driver cannot handle.
+		 */
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min_t(u32,
+					pcie_device->nvme_mdts / 512,
+					(SZ_2M / 512));
+		else
+			lim->max_hw_sectors = (SZ_2M / 512);
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-- 
2.47.3

