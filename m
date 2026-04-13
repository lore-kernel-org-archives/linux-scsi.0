Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B2B3E1D1C
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103621; cv=none; b=NrSbJTNHpLynlbk9vo5XtSkvgBWNLMKvJ78zsQhj6+C1MMRQhzPwxdRVGOhd5y+FCi71hHjEJrtvq/EzNFySVu+la3u5YTBVEKA15zX7n2Ld19A2pacayncukGmpr8Tm57n0WFoE6lFESK4C8pWE8MBZYJ7q83MYVRJFIF/ZTN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103621; c=relaxed/simple;
	bh=VvPCJrCu9g1gV35wvay8Nk4+QLcK6/BTdVZ5dBMrklo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z5Oq3PFSLZuyNYtRlFzMYHFOSeFHLQ6uy2+d5UBme+dVBp/YZH6wiLc6qCsIjZtgYTB6SNXlLabNRaNm8rkxvZtzquORBweY6up2lwaFD+fBTo2WouOWj3FdUjlTj8t19F6KwIsxXdo01MX3SSelutMge4lCDaGpQGDL1/97XTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=G5a6PSnZ; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G5a6PSnZ"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-8acb856a674so6441166d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 11:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776103619; x=1776708419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwgfxPI0WEDEHbvM++fZKw+bBfmjMpf8y09VlIGHZCs=;
        b=POHTpXIfQNlUs8GICUbtaDTsHlnG25ljFjqDzDe+4hKFqEUD4nvz+TVpBivRCOlp/r
         I4yN24TNxeH4GbN2wdFmt5H9cvgdVQw0LyIFi3Zr6BbpgjF5NHtZGxteCLOyteMtXJsp
         MvHfdfZPNEwww8xSD0VoQ5mi4e3qQJ0+aQEu3H5zIbRPkEQSs3xETkDm/D34GGb9TGpb
         ptXH8szVBuzkWc62Nwlit8NHutauaY98EnviXq0ZZBw8hMNkYyYd4Kd15if2iui8kR2J
         YQg7R056/yAg8/ww/d/0MC3hMmIXeTRcU40qfo9I23DQoga/okeFY81yyoJ5NHXii9rU
         ITmA==
X-Gm-Message-State: AOJu0YzDIbxIk89ekbClwbdX1I4iyuy32va8XPHoFMlwbM5bbATmWNuM
	F13sAfgTNkF6FOBnKJx1rfU30PlRddRc0cGZlJiF3gkt02mUg+E1K00ztLARewNqCueDwy+w9OD
	hi13kpr08DNXAAEzlqTM4BKj8gqEAe0gkyKkGVHKFpB4qyqquC4mfiZ58bJZPG06CfFGmf1aUzI
	9DkkDcgX7fqGK+3CN5N866EwObitj4bO3BVFHS9gaKmAGgM4TL8RdSalnIq5l9uETpWBrFFbsrX
	EbpwfN+KyJGK/QD
X-Gm-Gg: AeBDievSbRg2uI5pIPamKPipRg9GgftJ7St82zNnJx9ITR1ppfqMlaZrQmJdiO680kN
	YCP84STwFjx1jSGY4RVzeDEr48+5qLbzgyks74NqtToLtVV51r6KbBHcQqXs816YN0EH721lrgp
	xCuOLaG4ORJ8qZ3F2GC/CCgWvKE3v6u9BedKRU2dWhDr5I62Cac3gYHY5BInqpg6B77lfEAk/ys
	MeWkppj6c+em/rvz0K9dS54MbyoU3pioaLuhSTMKv1S0Hb4b9WComZYLfOmJucDjLit807cT3dD
	hnFyVDfP4RcGmA7b+pHeqcUPAYozzmzvLscFV0Nu3i4ijXngpiKMgz0X3Fy21PFymk2m5RrkI4G
	iKxVUe6xWCD9linJlZljW4C0v349aVrSIhg0Wrney00Iuxp8Lvo45v0sAojTj0CpOPCi3TCFF78
	x6apqXdgtpZqntDq/lu0yp6oYiudTTj6VzI8Ga+IutzELTiwkimut/DEvw
X-Received: by 2002:ad4:5dcf:0:b0:89c:5a3f:15a4 with SMTP id 6a1803df08f44-8ac7469df80mr267430906d6.24.1776103618767;
        Mon, 13 Apr 2026 11:06:58 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8acb5964b6dsm1641246d6.15.2026.04.13.11.06.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2026 11:06:58 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b2497cc190so22784735ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 11:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776103616; x=1776708416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nwgfxPI0WEDEHbvM++fZKw+bBfmjMpf8y09VlIGHZCs=;
        b=G5a6PSnZ6kiaEcFSr82gajItucgSOANAxJ8jIQNqHe+nwPBEu8gly+ZjEvZAt5ZRVp
         LDIFt1SdMZinzT08AwJ3Bi2xoeUX4lq+WiaqKIJp667Ernt67CkJS9KwdI/E8VqbZoHr
         pu/jvpxu/T+Rlc5lkcR4QfTM182n/rn1D7J1Q=
X-Received: by 2002:a17:903:2acb:b0:2b2:5070:8b with SMTP id d9443c01a7336-2b2d5c54ec4mr110543975ad.1.1776103616076;
        Mon, 13 Apr 2026 11:06:56 -0700 (PDT)
X-Received: by 2002:a17:903:2acb:b0:2b2:5070:8b with SMTP id d9443c01a7336-2b2d5c54ec4mr110543695ad.1.1776103615470;
        Mon, 13 Apr 2026 11:06:55 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b45e949464sm52648855ad.24.2026.04.13.11.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:06:55 -0700 (PDT)
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
Subject: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
Date: Mon, 13 Apr 2026 23:30:03 +0530
Message-ID: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
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
capability. However, due to the 4K PRP page size and a limit of
512 entries, the driver supports a maximum I/O transfer size of 2 MiB.

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
index 6ff788557294..44dd439e6f17 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
 
+		/*
+		 * The HBA firmware passes the NVMe drive's MDTS
+		 * (Maximum Data Transfer Size) up to the driver. However,
+		 * the driver hardcodes a 4K page size for the PRP list,
+		 * accommodating at most 512 entries. This strictly limits
+		 * the maximum supported NVMe I/O transfer to 2 MiB.
+		 *
+		 * Cap max_hw_sectors to the smaller of the drive's reported
+		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
+		 */
+		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
+					pcie_device->nvme_mdts >> SECTOR_SHIFT);
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-- 
2.47.3

