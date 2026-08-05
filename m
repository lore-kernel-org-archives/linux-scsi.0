Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDEF430CE4
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928467; cv=none; b=unt/aPYzau7X2pN4NnaVt3GOa3J0/uFHzygl2XBtN8ChIP0oVnfo+2YMYu1q/7XdeGJYjLz/VtC2f/KUbDLf8zalz/Q4vCiTpF6aACwOuo9PIyYfm00FRf+U9CmeCBpS2CPkEdG19RMRDjm37IiCYWt88nAayKn64UdzOfkXpdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928467; c=relaxed/simple;
	bh=DWN2n8sybfVevNs/2OF+Yt9TZw/YzvNNl91P9e0evrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLLWYWw+rbIk2dDBd2UUq/qx4XH5NxRoCo7tY1tz9PGZybY6CV5dZYtrgR8P4f2QZ1ojDP5V+oM6CQdGHwVWpFnZ6pPgPEF/mDlT/Bh02XqmHuonx/zwX47HKKFxQZqG6oMk39vttKrwmxgfQIs2DgLKSdwdxhMFjdilQexUPTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CyMcKYJo; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CyMcKYJo"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7eb787dec99so677720a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928465; x=1786533265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UzGpVXWTnKiw/noASSvkbeJc2JD3Jst0Fu804y+PZyY=;
        b=D/bfxwP3hcSMKyAgJ3V4TFYy00ZpCJKgkJ5A2ckSt/rg23u1F22JQ6qGUJY39F3GEV
         ugdDzQpVxVAQQDx7We+UoOjmaRDtd4Jh3pKRfIdspCbSypMSlW15b24OATNg/sd2SoTM
         3V5bdrvQ8DCPC7+HVw+aeKrfKG9jAL+Ar8iC3Oa/FXvkzpfiLSl5NI/Bqlz8wa3/xq8k
         iigtKNia/M5tSSOCqMYYIgfb7w6IIde+N+9WqgswFBtdkKokanTR9HFpNaDfb/k6g/jS
         RDMse9rUnoBhdkUFK898GL2ikXrkRpThXO1N6ArwY+AkG/9bFD0lVVxd1delbPT+pdHP
         JIcg==
X-Gm-Message-State: AOJu0YzcQ45zyv0YwFXIEb0CZ03aRHdQYKQGeStcHxp/pJzkfbpYQvyV
	yoW13VB3/PahJ57tmzuNuuVz94biXlQ18pvcUqZmCqPzh5qlWlHGgrNyXe9OjS2bOQWpSHp7lNF
	GUjyeIg/P6sUueBsls19w9TOJbvHZ6BSTJ9VQVAdMkAEjxgnqGZn9hntTXnSvlwcOm5UXKhX6zN
	Dj3d7wX5VH99Gl3Rx8C86CmzFw6fKle90WDAXLY8ezSa1/RM+vXDdGRVnSkTsFfbld7opG/S8yj
	EJ29zC8Qz4TfYD6
X-Gm-Gg: AR+sD13fW9ALahamDlnBUghADFOBKbKu4NkjYt6tPzfzGoXtCwNnsCLQwJB+VUD0/3i
	N1ih6kxkH/bLgf8kI9ZsEpRXYRT3/7RdA9J04UYVf6gqfiQn+K9JWqY0CfFO301gcjqwwl8trKy
	pVSFlS16IjiRbLMhOyEXoJmkveskIpTZ5RJMuojlbdyk1SLe4/Ms16vv2j7WNBnXzE8YrJ2CVHj
	FhuNPCNYHUAIeKZ35hO+Ld1VRqMrYQXbcR4V3sk+JhUcUvmjNTNEo7Z78OaVaQhaU8NV3ocUct0
	Z4TyEZj8ahWqMY4re/OfBAfo0Dk+9jweZa5fdrx/TYPClWyHEhxSLHi5GCQbMkp2ArFCcW4KCdb
	/8u7MOqKfAuCCZglb/kWCC9IwHEptexWsLbSt3B2CSlUTOmEC750JD5U1lHy0FJbLe9FiOV8l8m
	2Kv3cC1i3dILnF7BFOXbxyjev6a2qR7ywXLxo=
X-Received: by 2002:a05:6830:2647:b0:7dc:df37:844b with SMTP id 46e09a7af769-7f1e5cafd78mr4216065a34.4.1785928464978;
        Wed, 05 Aug 2026 04:14:24 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f1df59c11asm466763a34.6.2026.08.05.04.14.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:24 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1211903a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928463; x=1786533263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UzGpVXWTnKiw/noASSvkbeJc2JD3Jst0Fu804y+PZyY=;
        b=CyMcKYJonWi0KO+vlCxyXxYCqDT7pU8p7AGvmm4ubw2VyU63EEqhyStTTeP+paOo0/
         X9r6G1ylHnvWwgNeWyLFiecue3OzVBWFDPQBOiGYvsI4Ra6d4ticc9Qs5WTb+DQW7to1
         NYs0B/r+itAgDddh2GfMSFHHwRB20HpqT3VSg=
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr5805548a91.18.1785928462469;
        Wed, 05 Aug 2026 04:14:22 -0700 (PDT)
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr5805459a91.18.1785928461680;
        Wed, 05 Aug 2026 04:14:21 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:21 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 04/10] mpi3mr: Fix NVMe page size caching for non-operational devices
Date: Wed,  5 Aug 2026 16:36:28 +0530
Message-ID: <20260805110634.346670-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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
   The minimum valid NVMe page size shift is 12 and maximum is 27.
2. Initialize reset_to and abort_to timeouts with default values to
   prevent IOCTLs from failing instantly. To avoid race conditions
   where concurrent readers might observe these default timeouts before
   they are updated with firmware values, use local variables to
   compute the final values before writing them to the device structure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=4
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1f2f0951b560..6128b30112e2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -169,6 +169,7 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
 #define MPI3MR_DEFAULT_PGSZEXP         (12)
+#define MPI3MR_MAX_PGSZEXP             (27)
 
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d2a20f2721db..88b1d6360dac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1349,24 +1349,32 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		struct mpi3_device0_pcie_format *pcieinf =
 		    &dev_pg0->device_specific.pcie_format;
 		u16 dev_info = le16_to_cpu(pcieinf->device_info);
+		u8 pgsz = MPI3MR_DEFAULT_PGSZEXP;
+		u8 reset_to = MPI3MR_INTADMCMD_TIMEOUT;
+		u8 abort_to = MPI3MR_INTADMCMD_TIMEOUT;
 
 		tgtdev->dev_spec.pcie_inf.dev_info = dev_info;
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
-		/* 2^12 = 4096 */
-		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		/* Validate firmware page size to prevent undefined shift behavior */
+		if (pcieinf->page_size >= MPI3MR_DEFAULT_PGSZEXP &&
+		    pcieinf->page_size <= MPI3MR_MAX_PGSZEXP)
+			pgsz = pcieinf->page_size;
+
 		if (dev_pg0->access_status == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
 			tgtdev->dev_spec.pcie_inf.mdts =
 			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
-			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
-			tgtdev->dev_spec.pcie_inf.reset_to =
-			    max_t(u8, pcieinf->controller_reset_to,
-			     MPI3MR_INTADMCMD_TIMEOUT);
-			tgtdev->dev_spec.pcie_inf.abort_to =
-			    max_t(u8, pcieinf->nvme_abort_to,
+			reset_to = max_t(u8, pcieinf->controller_reset_to,
+			    MPI3MR_INTADMCMD_TIMEOUT);
+			abort_to = max_t(u8, pcieinf->nvme_abort_to,
 			    MPI3MR_INTADMCMD_TIMEOUT);
 		}
+
+		tgtdev->dev_spec.pcie_inf.pgsz = pgsz;
+		tgtdev->dev_spec.pcie_inf.reset_to = reset_to;
+		tgtdev->dev_spec.pcie_inf.abort_to = abort_to;
+
 		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
 			tgtdev->dev_spec.pcie_inf.mdts = (1024 * 1024);
 		if (((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
-- 
2.47.3

