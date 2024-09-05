Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D77194090
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725532296; cv=none; b=EbwgkuEz2VcGAYNiiJ64UHHN31VE9YOAdVPNkh+9pJWrJhvQQeSPCx7cYR7pY5vo6F0bQ03qnMrNc9pm4nCupYiBRxxNWq9IrZleG+0yQ9Hmml230fj8ZZG+LxBXPccpNjFubawpUrJ2z5WVkaUB/QgwZvghPiD5diERjPeThR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725532296; c=relaxed/simple;
	bh=yfUjy0ZxJpybyv3bk4GDJOxYrralC9OeB84jT9zIpCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2IFgM6oZLetBaQPE/Es/EqK55peXIe0gNAchQjEfoBDD4QFTMtXMVfHLyTQzMP2b8VPXkWxomqb/OiDrT+pDtVMPBOKaCFRhaJ4A/IyAFRLpeHmlETdfxNa2palD4Qq4Tibp9lkPJZU5+Ls7Ek0otJEX1AcQRKceUzcPGrubjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UJNIT6Y0; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UJNIT6Y0"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7143165f23fso478975b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2024 03:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1725532293; x=1726137093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsdGn7hnTjj9m3H87AUmTjwWM5re6oA7jczc7FE8CZY=;
        b=UJNIT6Y04+EdAbQhygS0xTfkPvb6y8XiitDviQrinf5w/656bHBvJcu7F2ohKWGA1J
         N47X4dcWxPSA7gg3v5J7O6pDjSi/veohCuc4SUbCUyhrDFIIAfIOFnUGZ5Q28KB8U9kv
         VCCX4TRN1oL/i/4i2HWlZrfy1SFIqiTsUkmx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725532293; x=1726137093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CsdGn7hnTjj9m3H87AUmTjwWM5re6oA7jczc7FE8CZY=;
        b=J/kbLCC11RM7AkAWe+NgCdnjHGq/WwDsao5qgjMLsFUJY96Bhrpa3q86Ry7qKu6siM
         St83VOh9FJJ5nRaF5MAtQhPuP0u/uyg/ApIh9rE2teqf25jOtxxzCVqfMyLt3g7UZpag
         IkXlMDHxq0f2B5PEnPBDc03DVqLILK28AEhQaS/ghG4D/GMv/5Z2gwK4IFZAOUKhOQoz
         NCGSjmn5YiWPtok/OCfTag7v3wW1F0u6JhVdWVrkgVZx2Uqqvv8DETBMI67m+asAENUS
         p8DHDQj2nMHQo71DgwpEw0vg9ZC37rM6iB1gvez9UJImqiXI4kvndgDMWJaem/McLwBM
         lL3g==
X-Gm-Message-State: AOJu0YxppESITq/XEKMm3FmnX5S0wQAreMVTI9oLe2Rk6mWZZAxMFvCZ
	JHkOZcCe5mu46jWD+vZR4yzfKDPvXBDhO8lMxGWCeXHlTH7TF5w5kYR5yV0wtt1Sa0Rc7PyJIbm
	ztsGPqyG/Nd2roKFmr1i9PA0MV/E6APpztzofDPXkzbTAeKZMero0x1oAgeRgY93ZknX2Px4Cj9
	Rqqf972eyOikvUQ6Hllc9KoP4DsvNbtdm+HPHS2WZW884N7A==
X-Google-Smtp-Source: AGHT+IGAF9mcl1fBosEntRUNHrkwSRbG5yitdVAdB6UNk9GSXN6Jn7b+B8LO8gYuJHaYjs9256EjuA==
X-Received: by 2002:a05:6a00:1a93:b0:70b:1b51:b8af with SMTP id d2e1a72fcca58-7173c589968mr19924518b3a.19.1725532293308;
        Thu, 05 Sep 2024 03:31:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785364f9sm2960177b3a.87.2024.09.05.03.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 03:31:32 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/5] mpi3mr: Enhance the Enable Controller retry logic
Date: Thu,  5 Sep 2024 15:57:49 +0530
Message-Id: <20240905102753.105310-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When enabling the IOC request and polling for controller ready status,
poll for controller fault and reset history bit.
If the controller is faulted or the reset history bit is set,
retry the initialization a maximum of three times (2 retries)
or if the cumulative time taken for all retries exceeds 510 seconds.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 6eb5bcd8e757..39d7082f2305 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1362,6 +1362,10 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
+	u8 retry = 0;
+	u64 start_time, elapsed_time_sec;
+
+retry_bring_ioc_ready:
 
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
@@ -1460,6 +1464,9 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_config |= MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
+	if (retry == 0)
+		start_time = jiffies;
+
 	timeout = mrioc->ready_timeout * 10;
 	do {
 		ioc_state = mpi3mr_get_iocstate(mrioc);
@@ -1469,6 +1476,12 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			    mpi3mr_iocstate_name(ioc_state));
 			return 0;
 		}
+		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+		if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+		    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
+			mpi3mr_print_fault_info(mrioc);
+			goto out_failed;
+		}
 		if (!pci_device_is_present(mrioc->pdev)) {
 			mrioc->unrecoverable = 1;
 			ioc_err(mrioc,
@@ -1477,9 +1490,19 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			goto out_device_not_present;
 		}
 		msleep(100);
-	} while (--timeout);
+		elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
+	} while (elapsed_time_sec < mrioc->ready_timeout);
 
 out_failed:
+	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
+	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
+		retry++;
+
+		ioc_warn(mrioc, "retrying to bring IOC ready, retry_count:%d\n"
+				" elapsed time =%llu\n", retry, elapsed_time_sec);
+
+		goto retry_bring_ioc_ready;
+	}
 	ioc_state = mpi3mr_get_iocstate(mrioc);
 	ioc_err(mrioc,
 	    "failed to bring to ready state,  current state: %s\n",
-- 
2.31.1

