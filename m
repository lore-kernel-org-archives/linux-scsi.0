Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30923B9D81
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547727; cv=none; b=uwXvHbz5wLyqz17iBgfKmzvNPJrijIMStewHSgBjDpupWiULLKna9v7bhvunkPuCJnyJFVou5qccUhvyyIRp500Bc/pLDjs6MFXGhAytKihMoGeBUSPjvSB5FKMMY8/n5MxPpGyUPneuqFp8by8NTuQ2Ib5H4DWCQzfb7YjRaDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547727; c=relaxed/simple;
	bh=GpsgnFCnYnHennh6l19FpwOqRcF+5IQBqtyEqkyRISQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBkNOMUqV3B0VG1IusCPcr5rFIeQIbd60W0tUb0/h6RUcocYX5fMJVfR9zwPvepHPaKmIPEo804oncyYb4WMdhMHeMaolDE4U5Z2thXta6jORsIusFt8lTj6lOC1/2/DoJvxBET6sGTgbrv934KciMCuWYJuyPOeRY7mOKvYoys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QzUOgyRL; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QzUOgyRL"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5c991e2b01bso541258e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547724; x=1790152524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZVySmrPXZ0aIky3P74mjaauhO/+Axngi+CWASqVHoA=;
        b=UXWudvTt5a1wVTNxsegmFptbkVPVyEzr37LGZlcgq1g606YnVNj917wRqLETD+HjQ9
         aCPPM9391bjzA6+6dXSwLxYukCOSwfIji/qZabloinh6gNHH+O9atINOxcFVLoYgH1Yk
         r4MsA8NhjBhXsIUCBbp0gLRrcSxe7khJXgQziKEQ/ZbkIsAT8MhYNGB/FVCxGkMz7md0
         tSG7tO6UokuDF7NvT1dBcFr5niaYnKVV4y+5lF0cp4vvfENHs71nZgO7me/a3yerbSUR
         v4dl7lXYZi2NozIYj24G/P9jVMBqvqRS6cBlYmNMVLCpUaWQZX0pm4p33BxTgApKk8Qt
         Iw1g==
X-Gm-Message-State: AFuF++m1XGlGly6Ua8Owr2GLyIbWkSJAEUfLH5LdPcMEVGroRq+jyeFc
	kLYepKnv8ewRhGF7GLcgJaY0X6QHyuGXp/RxcqfITNdE+r8+NRxmoQSn3iYOv0bocHXHF/CulRt
	UwEfgIPEIPjjn70Wze3C1PeszKTYvGUX96DHNBoTmoBKXX3grqHXPKBusUBlnb3lTPqECppJohC
	o56rU/Jq98fWsRZbMxeQFFKUpBsyiXva97+oGau7ZHVHEaIonyrstc9WNtkJT/Bxgb4AaijoBnh
	Tee8GdeP3HrzKHA
X-Gm-Gg: AYBFou309MYmZDQvueCgE/0Ec2fZ8yGH6gk8vlsHGS/jKlRU9YLHqOsJfdedyvtREv7
	uLo3fOhrn+Ix3Kus2Ur+eA87K4MLWXFvbQhzN4FVtGl5bHSk0L41HTgfRNJO6O4rWpJOThMQMyA
	LaMqTxnc+AMGp9Fq0uNdR65r9i0/SE3jvPBbnF++5KbD/EphcDebnag/KZD/2FP6nAQlHrMZRK5
	JufAVpeYgk3ieXJKYJYjE4w9hgJIrxNQCQ8vYNWb1P8ogjwg8GQWQ7VXo8lZRl6qxTaJeqAmyjn
	MLEe7GQ3z/KzsNQJGZ48QO8ZV6r1ODjXeRZGxoxtdevNLZg8i13WyRVdPDb5+zIgt8EW7nnDMpN
	HFhPpTanVF3jipmZOijelKkhjsi643TJvhs1433HHM3fmfL49RPYKWNZBQozElBmfQH6NOmbQdw
	xtgWlR4kO8jQceM3js/POxpdjnmPah7W1RTsM=
X-Received: by 2002:a05:6122:488c:b0:5c7:d204:db7b with SMTP id 71dfb90a1353d-5c99ac1b056mr1458840e0c.3.1789547724148;
        Wed, 16 Sep 2026 01:35:24 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c998a2b968sm965699e0c.6.2026.09.16.01.35.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:24 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4c1fc9ceaso4439190a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547722; x=1790152522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZVySmrPXZ0aIky3P74mjaauhO/+Axngi+CWASqVHoA=;
        b=QzUOgyRLZi94VpiwjKDSF3al2WGNsxtHekSiwsPqNsIwufZ7RLARWBYXQGIcfEYcpH
         MKWcutY7YkjWSbzbVSzAHi+4L3dajIPMEuLPpMzPW2+sBh0/qbsSsHTOGz19o4suh0Ke
         tQDnSudneFbkXvVABELpoMefIBYeMpUA0JIVQ=
X-Received: by 2002:a05:6300:197:b0:3d4:52bd:b89d with SMTP id adf61e73a8af0-3dd5f71c2aemr4736234637.23.1789547722227;
        Wed, 16 Sep 2026 01:35:22 -0700 (PDT)
X-Received: by 2002:a05:6300:197:b0:3d4:52bd:b89d with SMTP id adf61e73a8af0-3dd5f71c2aemr4736153637.23.1789547721618;
        Wed, 16 Sep 2026 01:35:21 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:21 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 04/10] mpi3mr: Fix NVMe page size caching for non-operational devices
Date: Wed, 16 Sep 2026 13:56:59 +0530
Message-ID: <20260916082705.44712-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
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
3. Read the firmware-provided page size once into a local variable
   before validating and using it, since it lives in memory the
   device can also write to. Using it directly in both the check and
   the assignment allowed the two to observe different values.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=4
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
index 07a2a45b4957..5506fc87f1ca 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1350,24 +1350,32 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		struct mpi3_device0_pcie_format *pcieinf =
 		    &dev_pg0->device_specific.pcie_format;
 		u16 dev_info = le16_to_cpu(pcieinf->device_info);
+		u8 pgsz = MPI3MR_DEFAULT_PGSZEXP;
+		u8 reset_to = MPI3MR_INTADMCMD_TIMEOUT;
+		u8 abort_to = MPI3MR_INTADMCMD_TIMEOUT;
+		u8 fw_pgsz = READ_ONCE(pcieinf->page_size);
 
 		tgtdev->dev_spec.pcie_inf.dev_info = dev_info;
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
-		/* 2^12 = 4096 */
-		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		/* Validate firmware page size to prevent undefined shift behavior */
+		if (fw_pgsz >= MPI3MR_DEFAULT_PGSZEXP && fw_pgsz <= MPI3MR_MAX_PGSZEXP)
+			pgsz = fw_pgsz;
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

