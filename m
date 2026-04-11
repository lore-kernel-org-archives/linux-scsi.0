Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396951E1E04
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775894821; cv=none; b=YuUEk0P3AEnXXgm9FcduEMZvrnbqRzS+tfidGpJsQIsKdlSHoBb3znN7HoF0tElaKCifS+VkpHH67iXxK4DUVVY/4u27e0T68r5Vp9grIfPh6xssIvKc37mDTig6L7XB4e9dU195cB5EpWhbxASEeKOOvz7ouNWBCbhW+6AVUHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775894821; c=relaxed/simple;
	bh=Ln9AS63EngCFfiuHW4w5QGFza/cqFFBHSsii/NBMjNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=an7aQIB59e4ywqSNerVvpFhghZSDhWLgEZpJH0JFSh+tsfp6eo/skHVdAZQGh3Bulb3sqsz8GS0XhecbHcukzSLxeJg+C9XFGCS8R4ceFMlASyue7w55F3Ck0RJgx3NSkLGKbLrWzbgVSIpxSmVfJuFsx4drYLZosye8ZZpOO4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=C+R+jyv5; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C+R+jyv5"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2b23fcf90b2so26750305ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 01:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775894819; x=1776499619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fEU7yR5sJCU69J+H+ksKtM1IopDe6eUt21SCj44UVHI=;
        b=Q+tOiQskgvWxjpeLbNWmVTEWcCWSSuWn7iZx8edgqnezF2BeV7AQk3WRPTCqAXdp+6
         PipBG65KRFLnMQE6DweOf2q1p7U2Tva8l99wHFBIW4043617kPMenS0ldiIvQ+p49a5b
         UIHgIQWmEqXwOZAd4UsENXNIZzyD4JiFMvdZEJ7rIquYo3143FksaZy4CZpuXq0wf0cX
         JqAY3kbAGN+tNexD/TgR3xJm0uTK+Jp0YjEEk/SukAHVK1PWfTYClx85xCLwKazJ4sW7
         qWLwDJAUf/s/k1p3jbHeikEjwpjvtZZdPt1WfJnSlY46/v2bCIBh6Py3R+gG7SXNs55d
         BL1w==
X-Gm-Message-State: AOJu0YxMZJ4EnoK2KaCDy23zKmw7mzAC4iTO1YirUKi0SFlpu38JzGPs
	tHSe8PigozE6Qygp5qiLk/C8Vu4OKr+Xiw68xeewOdGN/P0X6dagrWq3JpTwiItr/tuCh29slto
	1oOMC+BlO3u207QhkwkSPkw+qV53cHuBJzp231oclAXb2egVAXGqoO55HX1dOLhyldtISV0LxxM
	unHTvzoRCfnTsdk492taJpn2Mvn2d/+ML4jwzC9p7wsLGkS386T643zmpRKokgxYoVhT6QWjRum
	2SidZG5KCR16FEd
X-Gm-Gg: AeBDiesFtnM98EeSKeziryDRNqi3ClVC1Jv1a3yo8RHCc+j/HhuncdH0J5OD1jRJ6Hn
	gYQjQw1VcLoko4pqMXtG36lnxALdU1G8vwgThI/gg4WWFNO3oZEVPK4o7tKWhOFXe33GLUutATR
	vWTw+YK4cHlo+S8bH3+E7dE4vgRyLbaa3jq5Fvs9uqXeycBEx4uF1A1/rLsrsSYxNS/dV/T0g3Y
	GsyJnPwrrQDbfiaFwPgmIZB3+7xWhkmcOdRwHLNs+nahp7Y3wVut5NTMispFMI0iZZf7Zn3Nk8U
	0sAGkuzIam1a07kmZeRK/JEndttNIGKmNNai/SND6N41es80iU/cYaN3T+LqtKlALlvoRMGgBUu
	xRhmIoSvTGpEe5U6Td9R5RNmDe/GMJyg0GvbmUk8+ucG0bI33BiHy/1dMV005q8POXwemkjuKLK
	iiejMYuexYcxyRQpBg0Ecr/T9wIHTmPBlYf4MoOn/iyeYyggtv05OIF2tM
X-Received: by 2002:a17:903:1d1:b0:2b2:5c31:24bf with SMTP id d9443c01a7336-2b2d59b838cmr70010735ad.19.1775894819403;
        Sat, 11 Apr 2026 01:06:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b2d4e568c7sm3509725ad.24.2026.04.11.01.06.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2026 01:06:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35e30bb289bso4314172a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 01:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775894817; x=1776499617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fEU7yR5sJCU69J+H+ksKtM1IopDe6eUt21SCj44UVHI=;
        b=C+R+jyv53bglT2KFHhqwTfP9DMbl7XOg9VaHYaa1kZsAKBT5V7okOJ2DEwwRQM31lY
         WKtdF85oAVltDkaIrbadzyTNhRVCdWCNc/Q4i+uCBsPzGjwJ5fi1OqJdA0otTDbQZLNF
         4ENwNYsh/5zQEY85OVGoV/RkEFjt6sQZ53g+I=
X-Received: by 2002:a05:6a00:12e6:b0:824:93df:6d86 with SMTP id d2e1a72fcca58-82f0c2f0ee0mr6626530b3a.50.1775894816896;
        Sat, 11 Apr 2026 01:06:56 -0700 (PDT)
X-Received: by 2002:a05:6a00:12e6:b0:824:93df:6d86 with SMTP id d2e1a72fcca58-82f0c2f0ee0mr6626499b3a.50.1775894816332;
        Sat, 11 Apr 2026 01:06:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b2455sm5083972b3a.35.2026.04.11.01.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 01:06:55 -0700 (PDT)
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
Date: Sat, 11 Apr 2026 13:30:05 +0530
Message-ID: <20260411080006.50010-1-ranjan.kumar@broadcom.com>
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

