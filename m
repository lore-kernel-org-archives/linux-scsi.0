Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81E32EBBA4
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775760553; cv=none; b=rCk9JyO6nYw1dCcNIVLNVF5smfJ0r0sfxCTYyKQuVZu057bIb46JaqZu2qZ+csqlOwjGPr60Dk163jDroF8QS/7dSUD4y1ERIfNje39yhCBOfLzSOIj4RTMFjaV0fwoaTYnD8CckOD+2CBUMm97pzXtP6/9m+W855tm5+a+m6xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775760553; c=relaxed/simple;
	bh=1snxM50mQ3FERkI06h93zUTKXN4DfAB0lfunbOt8dN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=huXbuccq2lrRsdgFfizp8NlFqpo5mZp74awteC2gSw2vWPt1ej1jTJaXSzJhEvItng19E02ZQwW/7iOXQXnstFxkDUQYT5y4DPh5fDnEuI4Bhabe3pZueqQ5DAgHzvsF6/YZN3T86jku0lg3iqAYWWdjQ6VdquaXyYEBa1Vck/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fUKWwylB; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fUKWwylB"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-79ab3e26cceso12929927b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:49:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760551; x=1776365351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOiqsKH5apPL4V8NFI4S5DMIPLrVTX5q0gWEgcgQjLU=;
        b=Up8MVAbwg9e0yRLjkgWANAVvh8WEzGr3RWq+txp2uVT2QwhDlPuOGWqjtZudmeM0kU
         khYCWy8KYHoXyLXPpS54m7x+hlgHDhlpWhh1EkHgs03gsvhYIM5P88hPVqQI4ec7bLpR
         JJao8cDAwZw3F07DGL7fw/WhgIo3u3JPocG9SHl/j8dBr3a2HaiikaZa8Gl5T0TgdXJi
         MG4qTeb8IlrcJWnCmQFMIytMOgo4dEON6KZk66MNChyuTxvbIy5mLxxJGaeczp0rJu9j
         s1+PbuXcnampzkJ6S0pR5NCF2OSc7RQdZ5FMKi6+c2kSwcSAJ2qTLEMez/spLSIWkMu1
         dDFg==
X-Gm-Message-State: AOJu0YzQXE498ccbWYwT4UClbBNzIjIGjw6G4r9t1UkCJ8/GlaR6u5QN
	SMpiU9AIxK7E+9FI95CdcBCO95//fXjBzALtFYyxvKqikrxBIXIvbf24XibSMPzQF3fD0FazHzP
	wwteX4mH6dNcHrcgzQKaGLtKkL+Dg2+oYY9uIUlAIGam0jrdu78w+5ou/DNviUhLcIBcAWexIuL
	Vdp4745gar+OZ1YbhJ6OSMnbJjbovQ/XNyztPrp3F2wtZWUew9Bw7smaN53e/rXnaA1GokulInS
	lsHG+vCwnCMjuly
X-Gm-Gg: AeBDieuu1JgH2mvfC2pCsvec6nsXBGmZ9DbSnYX8LbBocJ5o71FvmKxNQWJ8GyOV1kY
	Prtv6olibEmlGrgJd2vgjHk6G2gZwZ9mE/ifNzYRKH41FpI1kTTM+TtMx0y1E7eKUYLIC506RlO
	D7B+G6wDmA5r/l2y7Oc4VurjTtnpke2KKYLre7z4pROO39X9g/h3YBLkdeBYgG05qVjJFAFlLiA
	vpllEB/KG+1W3IIuYlRMGc99IBHobq/tJ0hk92yNkehrcwRPqszp8nhhRcCyuoxjDJJKxyijDpX
	0mfnnewbTfubS0VcN8baUkkkKPNozlJxXBsjRts7TROgDfyTZg/2JbW7RD6yAIJGILyOWW6C+Bt
	FOA4IQNahnxvyEs/Z7RbL8BXxSjN5HLMPlxnnbyyXsTDh12NtvmzMRumLqlz/k6ndu8D17zmRTI
	c64IyqdtIEsKE8nZRNV0eY17IL9FydbEdOxCaKuzdLuwg5G/QsdPTT9sAC
X-Received: by 2002:a05:690c:a005:b0:79c:c51c:7f41 with SMTP id 00721157ae682-7af7166d37bmr688537b3.29.1775760550751;
        Thu, 09 Apr 2026 11:49:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-65197a6e798sm21111d50.9.2026.04.09.11.49.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:49:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c741c4cebf3so619549a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775760548; x=1776365348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wOiqsKH5apPL4V8NFI4S5DMIPLrVTX5q0gWEgcgQjLU=;
        b=fUKWwylBUfAG2NDJ9K3uKdmcfgBGA/kZiV1of3oK3CrdGqfq2xCMCsL1iWVGd3hP30
         Na4HnUYazj90VRppNTTeog9lgC1PijFqGWE28DJEjYjxuGVks4wZ7SYdQFuQuk3wRR83
         IKjkHyN/WvROFlhNeRA0sL14ZmyrewwC9hd8E=
X-Received: by 2002:a05:6a00:1bcd:b0:824:3bd9:aac6 with SMTP id d2e1a72fcca58-82f0c1691aamr383547b3a.16.1775760548480;
        Thu, 09 Apr 2026 11:49:08 -0700 (PDT)
X-Received: by 2002:a05:6a00:1bcd:b0:824:3bd9:aac6 with SMTP id d2e1a72fcca58-82f0c1691aamr383515b3a.16.1775760547884;
        Thu, 09 Apr 2026 11:49:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c34f789sm166471b3a.19.2026.04.09.11.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 11:49:07 -0700 (PDT)
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
Subject: [PATCH v1] mpt3sas: Limit NVMe request size to 2 MiB
Date: Fri, 10 Apr 2026 00:12:17 +0530
Message-ID: <20260409184217.32992-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ff788557294..b6abc83d8121 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/raid_class.h>
 #include <linux/unaligned.h>
+#include <linux/sizes.h>
 
 #include "mpt3sas_base.h"
 
@@ -2738,8 +2739,17 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
 
+		/*
+		 * Firmware may report NVMe MDTS from the drive; values above
+		 * what the driver can handle can cause a kernel oops. Cap queue
+		 * I/O in sectors to min(MDTS, 2 MiB - 4096 B).
+		 */
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min_t(u32,
+					pcie_device->nvme_mdts / 512,
+					(SZ_2M / 512) - 8);
+		else
+			lim->max_hw_sectors = (SZ_2M / 512) - 8;
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-- 
2.47.3

