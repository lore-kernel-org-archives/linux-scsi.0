Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C354D2EC9
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536040; cv=none; b=ECmhZauSQcKQSwNEZ9C7HA08SLwoFRQFPE9JFv1LTwI7ClfExuv5dOd0s0P7NgCqzd/7WOjb2fSCLAWN/DJw5kFJqNFhj5lcCFbWoKzDeeRnh8yij/D5It+gpN+jXOv6tcDqvtPrj106seiMQW723Pv5I5taCZmkyvCAhETdlIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536040; c=relaxed/simple;
	bh=bL6GZfx6UTubTcEzLyIqseMhoYZQbkuR7s1EzzNbf6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7sTvLc03PC+sD10jxi1vBgkPdrMBWpVsE6WyXCWqutnpoReJNyWjGDB1nuf/CFiy1924HDnyRIpoqxxN17Q/9oZgeBHBH0i4fU1Ua4jtjhbEaO1yYYizZy6ken/kLjTHZmpH2DFuFvtqOk4mIYn6qXFWnQypExSm8cfbTnUruM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KBcASSFE; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KBcASSFE"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2c7cfa17fedso11571145ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536038; x=1784140838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uG/LgOddo79527I5ewTqybf625TfZNLE1GUR11MXTKk=;
        b=XpgBP4LJLNvxBeviw/oKn7n6XXx14LCkQZhglnvZZH6NL/oQ9y0d4IbsvorxVX3+fd
         c3i/WVW129Qb+/2aNEAhQrqvhUbzChV4YyEEHwSYrK4E3vk+Bz83x3EJQDwBMc1vip/L
         zMgbVa+E9gK8a4XIXtRdpOSethVeWYVbqD6T8QgGpSs4sNbWXYHQ6wbEBo58JHFlAEnB
         I6tcfHGEeOpQoODOcWwze3QSd8gxd91QZ5bWaInKX9/PpouYFBqOMfQnaN98kad0g7/1
         hWAbC5MVoSBz0QRO7PZWNd+RzoPb6frqpAEBVN1431qPMZpTEF8h4Vgu860rII0j6lqX
         Efew==
X-Gm-Message-State: AOJu0YzadiV56IhqgEN/HGjSCAy5l4REYJoQRyRzqPvJs/OBaM9uDyKU
	GJnkJ9KahlC37pisTR06Fry6woHXHXDCbIRBq0Flc8fjyeCHkWLaMXUR8Ul3QmYkaQoscTk/v+g
	N5tIxzS1wY9PlHtLp6nVQSYFV752Gus7JeGSLMC655rkW6SyxUVkQc5haFnkFwUj/DyNgm/R5m/
	STAzGAKEtajjylLYs/EaABeqr1s8NP7Tasz+5ZLbKgjTJ1+U7Sb7M0QFib/SfQ+7aWxdLNHBPBO
	/bpsh30xQnhUArC
X-Gm-Gg: AfdE7cmxB5s0XCsqqtA2OQtBKl7JTU/n0VtYHA7ESPIfTGkNl+3EpVq7Ua/6dYfO7ba
	anEv05nn/93s7ThddZyiEmoBzVYxLPy6HTbDzCjcmGP3JGNl5IwKFUu5kEvDsRHRWl98wKbzOxR
	OMM+2794/rAEnURGwjEqjUZIStdbi8qHf/1sblGBMhhASWui6DT7kCJLzOwfMEaVPlwRUXF8M0k
	s4Tml/GKEHFSI0yMuOuY4LOoMhrjuivQjRKBIfrM+Vk84Au/APNPp8FVsLvoiU6gA90n5V10ZXk
	FdQwnrbAocH2ptmJJ7V8HhoDfT3LGrQW815c9SBsyX227SokfssfgIOxuROXyBYUXcZj2FWsyE5
	AK26xf0FVGASoMTILAYq3CDjZnZXrcAghXMSjUhR+UGzXbnAMsl87R1aFjkkD+lOcOGYOHbktTh
	XPrM4iz6dRyFzZcyf/2BMQaqaInPASj9o3dAbUbn+QM+rMNw==
X-Received: by 2002:a05:6a20:9595:b0:3bf:a9cb:b799 with SMTP id adf61e73a8af0-3c0bd2ea824mr4521529637.54.1783536037787;
        Wed, 08 Jul 2026 11:40:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-31174a0ae6csm351476eec.18.2026.07.08.11.40.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88fc985a65so1471227a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536036; x=1784140836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uG/LgOddo79527I5ewTqybf625TfZNLE1GUR11MXTKk=;
        b=KBcASSFE6AYQpeBru8cXTsPbNOLxBQxh97PNb4bO4JFY9ijwVKCuHbI5UF6V+6lQNr
         Kqjm12YNLmT5h8L+plFEpy4iYNvKbKbU8bfLD6q7ewCqlaqtuZbzEpFZpeNXxsVf/GEN
         RN/OaJsAWAc6ETewK4WlaH2BbwpGyPwKhKUdc=
X-Received: by 2002:a05:6a21:62c6:b0:398:837a:7af0 with SMTP id adf61e73a8af0-3c0bd04207cmr4167765637.30.1783536035784;
        Wed, 08 Jul 2026 11:40:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:62c6:b0:398:837a:7af0 with SMTP id adf61e73a8af0-3c0bd04207cmr4167731637.30.1783536035200;
        Wed, 08 Jul 2026 11:40:35 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:34 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 04/10] mpi3mr: Fix NVMe page size caching for non-operational devices
Date: Thu,  9 Jul 2026 00:02:59 +0530
Message-ID: <20260708183305.244485-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

For NVMe devices reported with an error access status,
the cached PCIe page size may remain unset during device discovery.
This causes management IOCTL validation to fail, preventing requests
from reaching firmware and resulting in an incorrect error
being returned to user space.

Populate the page size attribute irrespective of device access status
so that management IOCTLs are processed by firmware and the appropriate
device-specific error is reported.

Additionally, add bounds checking for the firmware-provided page_size.
If the device is in an error state, the firmware might return invalid
data. Unvalidated values could lead to undefined behavior or kernel
panics during later bitwise shift operations. Fall back to a default
page size of 4096 bytes (shift exponent 12) if the value is invalid.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=4
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d2a20f2721db..df7365d19b44 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1354,12 +1354,14 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
-		/* 2^12 = 4096 */
-		tgtdev->dev_spec.pcie_inf.pgsz = 12;
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

