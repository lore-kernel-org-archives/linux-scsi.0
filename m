Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6CD3C4562
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889168; cv=none; b=QQtSdldf4rRLZxG/30aan24VxaqVpogwK9cjGikx21mvyx0Al4kOMsw2S6p+qXlKMG3OqmJ2U6RCmVHf5ho07vQSfL0VeaRCvfjHD3z9AnLW8HMGHabDhK331ZldnwTWvOkVdqMlzbXq8Vv9FGrGr9R5udOVcZ0aDvnyzaKZl1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889168; c=relaxed/simple;
	bh=PhDrJAQAVX8FW0CnLamXQEIUBi4Qr8fYBW4tpgcZ3X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZPa4yLrfWlaIRFqJfAfaAzOjvX/Cg4nCdADjtM3ZNvdte7+um7cugfqhqCLGkBaGXLkdXbUKL8lTntls9n7Ufw0zpd3yCxpPEHxsbwadRXn7MY3JbiHmhEXBfamqGOx9SORzO/wOvN/8tpXSpJlCiP5FKQSBfR2AuCvCymdB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ergYI7Yp; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ergYI7Yp"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cbb973e6749so329573a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889166; x=1785493966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KZ/AKRmI6rrPrcFfREOJXiLlWN8dQP5gLQNdo0i14Z8=;
        b=U5QJgN3d7x7n/toZOU8pgRlTCpvvpiytZLvyyltrZ66O9gyY3+WPnM9d7OkhkU8yHa
         zokD4HJngFehqa83B1X4bH7kCvCiVGBBGBME/Mw+1ZREYQVGaB3iWMH/Rw0tde8PwX3m
         uyB3uARyQqbAkWLyjwq9D7BEQbTHgSCZsKgiU1Komcez1pDE//GW4MccnkONc7Y3y0cX
         rjauFtNJ3+yUTxHk7gOOEA3NtZX4oD7rYGs50fEkImXX/bnIxKjthSwoMo9fCnFjtUHz
         d4nIj3D+CVb3DgXowmxJcN6SFR9id4crPvuSk+og1I3//8PdGkCXPqZNvzOa5MkXWbc6
         gAlQ==
X-Gm-Message-State: AOJu0Yzqowgd1o/+WXAjSxI12amWGdsuRvMp1tjVOiCrv3zAEsf21mZd
	ih/EvzgCJTgKmHou28tqxK5UXqv1IPAPihRbmp6ntR1lulY1qriV4wXyif5XdamZ2cYdx/UOcLZ
	n3sQWf14j2rRPXnjJIto/0mMkH/DuMOnUERXqNSEbDjw39OoYKLv2AyA05WaHVmTATBVcylwNuM
	nb5oPLCqs5qJvvsXjEyeLSFBLUUe5Ww0DDYc2VjYozZ6eKRZ29Q0JGyRZ2rSFYd7efPPzJ+PFUh
	Vhadjm75Ir81lFE
X-Gm-Gg: AR+sD11VMCKeW6tI02LysIDzTD6VqgFr56/CH3QK48Yq6hcRgfTLMaUIAbCFZOfNQO4
	aCJsfT21613OW/aHAK+ziJWoJ/X7CMGavbRY4X4rPsB1s7O/C4Qa0ZcbTw23bVWder0wYy+euts
	fwyZyiUg+8chpTQfFuHrMDbo8tGKcbo1RIQt5vO0wW1+NCHIfn77kJaDl35f4Hq1wGSA+/oWVzZ
	Owgub+yVA0E9AANb2zPjO+iqlIjPI8vnadB9B6mRXP/HkfpK33JMH/YBoxPbrNDBSyiRI+VqtsK
	iYT5Wtb/5/oghQ2bbN0BM2Fy5Eky3PInydhMvUOo6e3wvefei+/NsQ6dVCnCOaZzZ088xtcY6rX
	+yXPhE1rE+KojNPvHao7PbaNR6QpJ1uDsRUr93RC49ZFlW2QFkumJS4U/ECkEHhn30N+aE3N6aR
	mBIIumUz3maJG21kPu1sdH5UOHJPQOYwRGPVs=
X-Received: by 2002:a05:6a21:1519:b0:3c3:890f:6d7e with SMTP id adf61e73a8af0-3c44b18ac93mr8604614637.47.1784889166083;
        Fri, 24 Jul 2026 03:32:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-3147df06694sm502231eec.15.2026.07.24.03.32.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2caf4173b1cso5737305ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889164; x=1785493964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KZ/AKRmI6rrPrcFfREOJXiLlWN8dQP5gLQNdo0i14Z8=;
        b=ergYI7Yp7kuGUJMht2vDqV9WXQEg+mt0bLYSTSSKgdWP7s8OpHEzstc3OGXxc7S3gi
         x12ajXGYi7q+mH6KHcIhj7FHXPW9SeT3VXdvO3Xd3jeodwNYhwbXyUzwYvbcH03E8rWm
         NxhA8E9jvKi290UfwvuT2QiMmz7cbyoEl3V34=
X-Received: by 2002:a05:6a20:e290:b0:3b4:8f57:3205 with SMTP id adf61e73a8af0-3c44b18a0bfmr7390236637.36.1784889164175;
        Fri, 24 Jul 2026 03:32:44 -0700 (PDT)
X-Received: by 2002:a05:6a20:e290:b0:3b4:8f57:3205 with SMTP id adf61e73a8af0-3c44b18a0bfmr7390212637.36.1784889163667;
        Fri, 24 Jul 2026 03:32:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:43 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 04/10] mpi3mr: Fix NVMe page size caching for non-operational devices
Date: Fri, 24 Jul 2026 15:54:59 +0530
Message-ID: <20260724102505.115136-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

For NVMe devices in an error state, the cached PCIe page size remains
unset. This causes management IOCTL validation to fail, preventing
requests from reaching firmware and returning incorrect errors to
userspace. Populate the page size attribute irrespective of
device access status so firmware can process IOCTLs and report
appropriate errors.

Additionally, harden the device initialization path against invalid
firmware data for non-operational devices:
1. Add bounds checking for page_size, falling back to 4096 bytes (shift
   exponent 12) to prevent undefined shift behavior and kernel panics.
2. Initialize reset_to and abort_to timeouts with default values to
   prevent IOCTLs from failing instantly and triggering unintended full
   controller resets.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=4
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d2a20f2721db..7b86152922ba 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1354,12 +1354,16 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
-		/* 2^12 = 4096 */
-		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		tgtdev->dev_spec.pcie_inf.reset_to = MPI3MR_INTADMCMD_TIMEOUT;
+		tgtdev->dev_spec.pcie_inf.abort_to = MPI3MR_INTADMCMD_TIMEOUT;
+		/* Validate firmware page size to prevent undefined shift behavior */
+		if (pcieinf->page_size > 0 && pcieinf->page_size < 31)
+			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
+		else
+			tgtdev->dev_spec.pcie_inf.pgsz = 12; /* Default to 4096 (2^12) */
 		if (dev_pg0->access_status == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
 			tgtdev->dev_spec.pcie_inf.mdts =
 			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
-			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
 			tgtdev->dev_spec.pcie_inf.reset_to =
 			    max_t(u8, pcieinf->controller_reset_to,
 			     MPI3MR_INTADMCMD_TIMEOUT);
-- 
2.47.3

