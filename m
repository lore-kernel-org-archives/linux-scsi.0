Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE433D9048
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165307; cv=none; b=ugdPERP+iKbctN9aElZ7k+5BZT0uNtWEE5c5c2WlMK/mJ0pCtcsw8TNp4z0QKweq8sKUpCCZxwhHmt701ny5n26kqit+qWfOYzU5a5Egge1Ho7sandSC/4ACYZK10r7st/NORJ3MnPm0H1bc8J3Die+FZp4HLozePCfTR+rnftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165307; c=relaxed/simple;
	bh=iXwYiToNDzVFSYqHR9hmBiK6ONF7EQLGiFPMcdUmh20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aOaURW9v52i5TTchtHQi+dU1JkKBeCfZzgfdD7zzB1vWNqOATKODScsa7Jh+4KrN33sMLj2M7yATgO5UCHBY2zQxKUSx4pC27Rj/QIENJKan8/Wuo02md2yhEMfTs06Y1atarqB6UraS7ELigBFEwV5jkzCJez1AviCQTTAYg5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hbcH5sjM; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hbcH5sjM"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2b45cb89f7eso14336355ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 04:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776165306; x=1776770106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBJhofTzUvusJZHQm/kAL1AM7X3RPqZ3DbYLT/nOXsE=;
        b=bTRhhEsFOb5FsMViwdYYQJ7fMyYnRaiCh5Sm6puHYiYaKf6Lm/JtFRispQWYQs6ANp
         J6VTqF7KCS9scLXZs0fmWqGaqSjMKcvbYebpev9pLA+yaK64Kr52IMcfSuZwJIDa6lJg
         x+Lfvv/FtNM1jR+4md/ibfIKMrhsBTXxYkWDoMV2qlTgkQysGn8Q5272d5cw//MG3Ecg
         chrGY8a+C/nr10fSmHdAzdM16ftpTf6v2+9OItB4RgIjh73a3APrL2KQkY5f4q0HCFR3
         +M00ySGfhzFc7i+Qf9ai93Y7Ukjs4cnLPHjaOGBA+0MgO2qbHRBJNXCD3ys3iqFF6ogI
         HOEQ==
X-Gm-Message-State: AOJu0YxmZrOM0bNR9idX7mtJhFjBLAt0/QCLUwZjLEQ0PLG3VneatROn
	wl1vXfswzaHCT1Oj6lqcqDURyYOUiAO97ATvvm52uIXPmTAxdeAdjJKvM3yNrocotlkfueOlCsf
	4BT1upzTfxPJVowLfSJvkbEHHMz8lqHops9gyuKAuojjhLAxkEA2qh+kc0oZR/+bMYYD1SEHzoJ
	yxcj1hldS6EPWsaS114E1zvj0w4DKOSpWSvsEeATiiuMi1GfTSF3tP2BGOKO1ntF6q910m7j3X5
	rNciwkwHoq/hTrg
X-Gm-Gg: AeBDiescVl0wKkC8RlZ99PyuE/u+l2GNirrMWQzYBvYfYXxUaAyMeQcSHzURsEPJTPo
	xuieNT4/JNxPnzYOYE3Ybx4q8zpb72poAXWuLO6/MqPEfD8E8gRgNEgXrm75MX79uU7Q2+vedlY
	vfIYYATqYPljbsyxDyQi52VzLBGtmhq7hXGnTGUZ30JJMrcMfoAafh1jLwwCWQLDPSr3wWC9SqZ
	ZDFOIlcaZLzABjzK2N0OVd/lfFzKd18uxdPYDVktElcR/y41QKUSMVU72qPV6XOrZetKvNR9DL4
	plTk3CbnMXGxfCVQtLd+SCzsp/S3GpU1iShzGp1DQiVxl2yFpqVHzpcYsgkfRTIribsmf2WOhxH
	53ZOaSHNvb9Xg3Y5hS+782R7L/bFLQwpDfw4upqbYQP3SfJvZ/f/87RD/PKkf6mFX9xuRwhlR1R
	tvfm6TxdIxaSjwqIyaz6nD0j4SzI0u9/k7EtYj/s5DsDpYKZzBXsH9VtBk
X-Received: by 2002:a17:902:a70e:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b2d5a1cbfemr116475325ad.27.1776165305564;
        Tue, 14 Apr 2026 04:15:05 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b2d4f364b0sm10505935ad.45.2026.04.14.04.15.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Apr 2026 04:15:05 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2adef9d486bso49996065ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 04:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776165303; x=1776770103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wBJhofTzUvusJZHQm/kAL1AM7X3RPqZ3DbYLT/nOXsE=;
        b=hbcH5sjMI3mmIYvVY+VS5AkLpZVYzJyYbHdCrQ/VdaRh68eUpMQ95urFeglLG3k4gP
         h0WNr9ztb2oAirpT0wzQBjwzqDNxRedqRqRNyPTat2UmKwDA8I+p2mMpA/TKFNC1nEYI
         b4psyxFt68tuw4gtAepLLJSq78ciPAXk7Kp7E=
X-Received: by 2002:a17:903:2acb:b0:2b2:527d:103 with SMTP id d9443c01a7336-2b2d5a5dcc0mr160781355ad.43.1776165303054;
        Tue, 14 Apr 2026 04:15:03 -0700 (PDT)
X-Received: by 2002:a17:903:2acb:b0:2b2:527d:103 with SMTP id d9443c01a7336-2b2d5a5dcc0mr160780975ad.43.1776165302502;
        Tue, 14 Apr 2026 04:15:02 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f39ccbsm179722255ad.77.2026.04.14.04.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 04:15:01 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	dlemoal@kernel.org,
	david.laight.linux@gmail.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4] mpt3sas: Limit NVMe request size to 2 MiB
Date: Tue, 14 Apr 2026 16:38:11 +0530
Message-ID: <20260414110811.85156-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The HBA firmware reports NVMe MDTS values based on the underlying drive
capability. However, because the driver allocates a fixed 4K buffer for
the PRP list, accommodating at most 512 entries, the driver supports a
maximum I/O transfer size of 2 MiB.

Limit max_hw_sectors to the smaller of the reported MDTS and the
2 MiB driver limit to prevent issuing oversized I/O that may lead
to a kernel oops.

Cc: stable@vger.kernel.org
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ff788557294..12caffeed3a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
 
+		/*
+		 * The HBA firmware passes the NVMe drive's MDTS
+		 * (Maximum Data Transfer Size) up to the driver. However,
+		 * the driver hardcodes a 4K buffer size for the PRP list,
+		 * accommodating at most 512 entries. This strictly limits
+		 * the maximum supported NVMe I/O transfer to 2 MiB.
+		 *
+		 * Cap max_hw_sectors to the smaller of the drive's reported
+		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
+		 */
+		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min(lim->max_hw_sectors,
+					pcie_device->nvme_mdts >> SECTOR_SHIFT);
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-- 
2.47.3

