Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17628231832;
	Fri, 13 Jun 2025 20:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846589; cv=none; b=Py/F2BBSexYPQDHJBA4jtr1/u73qRFnw+bhQScgQUP3187thDLFY1MBz+DkXpgsrP2BnAvFDZgWTkMxMSeOK2fCsc62UsPkBW7/dWsiSxabL/6qT6M8VRoDmawCeXxLOuJtY82BNYeKv+KAWsns6QFdbOADuj+va+kVuEBy2ju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846589; c=relaxed/simple;
	bh=itbcvkf06hHiTnVq1AuUrcdQlnPV+M8C1Bw+xbdlbmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W8bOVvIsm7q4dgwsGJF53a2K9Ex0qPKrexUWcHjPnE1tSB2AEYHNAoOSs3DrHGLg+tbB6l2+VM71EuNBFMUo5NoW79uBqd2KQBjkgY1HsRRCXSgQtZOYuFTvIJFWnC2SaXbYLJyNbbe6xz9s7tgBWLE/f/PLOZ5jVOTCd7mk6aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y45T6Xrd; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y45T6Xrd"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-476a720e806so22303041cf.0;
        Fri, 13 Jun 2025 13:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749846587; x=1750451387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4VAbAcNIfIca2fO8o6BFv8OwTPHASyEPNSWgRMV8CwE=;
        b=Y45T6XrdIsEjX2SPeh+6KC7VbwNRgeMDoGz1NVdczs0osHr9HGmJwzYf9s1X6eUjnP
         bn1HhfO5t+IgZ9cxwO40zmmXilA80cHmC+DAOH7t8k60jLajD9r/CHsxj0fR9z+ba93w
         huNUNzAqlK1MTHk/BTq6fM2B7pgvqmy9OdQIsJwM6g3Pwwl4zmdOTJ+CYldqLfw0/zHv
         eYHO2cYkoSVDFmnyYn6+xs6jm7Vr2tW85SixfvhkB/OTwRI/WgTqq1puH3ojxx50II5R
         0Fd3qvsv64sCo6B4MEgPH1rogR8JHVlpMRZim5raIjyarlDD0zSIx+zO/HvY9j3B4Zsv
         vPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846587; x=1750451387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4VAbAcNIfIca2fO8o6BFv8OwTPHASyEPNSWgRMV8CwE=;
        b=W9npPczV3pNN40j8MaUb7AQ/2zz7SDFWoaSNHXNuOMSnzcY3GMiqW8guDXB9KN2Iv8
         9fM5BLUSkKtWI4LZFEtt7Oz+1JGBJv4qJo+0IEWVxmecEeQWoCOMXj8JlJZxKsyrsUno
         gIJMdlxpmuKoF2pjgS1xt9dXCa0moUJViE0uZBV1QhRzDpiHztKZ7EObXnCH++BuTamQ
         rpW85zusQDbvCXqP7r3wTrlgTXcpAUH0dk0pe6XxgOtgwMi5iOpa43qopSJmZMvxeakS
         SqnhHVpoehBKCZ023pf8Z3rHZRxJh+sQEpfHR4SN7xp+9/lWucOM6rAzqW/fUJBspQZO
         sfYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0KvifMNC+ImFyHLHFF8nIf/6/4yNIZYTD9NvqZKFTXmnokym84bSvOYD66DtRf8tfy163+2OSvlZ7Sg==@vger.kernel.org, AJvYcCUsTw0dxG2a6ttV/jT5LIRNB4nCeLlD3Wq94LGpGwyvdi4/EVvweSvNG3ssR5vMsGuf+btxb2kMEF0WkJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxknP3wFKEqHY1Z9wwiRIVW8hPY0rW1866FoypVbMJqkom4BZT7
	+zHC5v+l+QOZNEmAJA7iDfaC5OCGGkzbGYhfMtxGz1/UdgHbxQEGSu3c
X-Gm-Gg: ASbGncu0VuhRhHskIDoa9/Cd4nKGRCu5b9ksVhGlO1VK9Lh/J+pJaMOft25xZJwprLk
	kz7QyABkyU+bY3+KzaSqVSKe8zGkxPeKuXmFN0tvUitx5BwvV/FfHHi82OikCLYmxmTbdL4ULqX
	a5RkhYK/gU1rfbi7Tl5bOs6ZsLn8+/KeasdD8vPcUnTZW1OSW4FVQdb2Y66eZafRWJ5o8H8ZvaR
	GctaTeOmJMaUJjLY5SYTjXLgIfbWKGD6+j5+QmT1FcmQur9JFKIkvr9woBEkxAjIaONN2L6gXcw
	CClzlMGHlcoO+xlHi+nqTf+/QiXSOhysg9dIXTcSAmRiFzoBEcCAB7oKOvjLFLD6d3uvaCr7sQR
	4mUSfZTBoj1lkOe3dxZm/fPab
X-Google-Smtp-Source: AGHT+IHxRiPAV0D7DboRmeFsi1aji9YCUVLyuuezxUhc5aYhotmHtvwODeGh9qZCM+rr5MHFknFXpQ==
X-Received: by 2002:ac8:570a:0:b0:4a3:6cbf:1fb7 with SMTP id d75a77b69052e-4a73c55d17fmr9961171cf.20.1749846586862;
        Fri, 13 Jun 2025 13:29:46 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a2c068esm21500411cf.1.2025.06.13.13.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 13:29:46 -0700 (PDT)
From: Steve Siwinski <stevensiwinski@gmail.com>
X-Google-Original-From: Steve Siwinski <ssiwinski@atto.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: gustavoars@kernel.org,
	James.Bottomley@HansenPartnership.com,
	kashyap.desai@broadcom.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	prayas.patel@broadcom.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	ssiwinski@atto.com,
	sumit.saxena@broadcom.com,
	bgrove@atto.com,
	tdoedline@atto.com
Subject: [PATCH 1/2] scsi: mpi3mr: Add ATTO vendor support and disable firmware download
Date: Fri, 13 Jun 2025 16:29:40 -0400
Message-ID: <20250613202941.62114-1-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for ATTO HBAs by defining the ATTO vendor ID and adding an
entry to the PCI device ID table for SAS4116-based ATTO devices.

Since ATTO HBAs use specialized firmware, block firmware downloads
to ATTO devices via the MPI3_FUNCTION_CI_DOWNLOAD command and return
an error.

Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 1 +
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 9 +++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c      | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 96401eb7e231..314eb058c12d 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -206,6 +206,7 @@ struct mpi3_config_page_header {
 #define MPI3_TEMP_SENSOR_LOCATION_OUTLET                (0x2)
 #define MPI3_TEMP_SENSOR_LOCATION_DRAM                  (0x3)
 #define MPI3_MFGPAGE_VENDORID_BROADCOM                  (0x1000)
+#define MPI3_MFGPAGE_VENDORID_ATTO                      (0x117C)
 #define MPI3_MFGPAGE_DEVID_SAS4116                      (0x00a5)
 #define MPI3_MFGPAGE_DEVID_SAS5116_MPI			(0x00b3)
 #define MPI3_MFGPAGE_DEVID_SAS5116_NVME			(0x00b4)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index f36663613950..7e2d23204e6c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2691,6 +2691,15 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		goto out;
 	}
 
+	if (mrioc->pdev->subsystem_vendor == MPI3_MFGPAGE_VENDORID_ATTO &&
+		mpi_header->function == MPI3_FUNCTION_CI_DOWNLOAD) {
+		dprint_bsg_err(mrioc, "%s: Firmware download not supported for ATTO HBA.\n",
+				__func__);
+		rval = -EPERM;
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		goto out;
+	}
+
 	if (mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
 		nvme_fmt = mpi3mr_get_nvme_data_fmt(
 			(struct mpi3_nvme_encapsulated_request *)mpi_req);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ce444efd859e..12914400660a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5931,6 +5931,10 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
 		    MPI3_MFGPAGE_DEVID_SAS5116_MPI_MGMT, PCI_ANY_ID, PCI_ANY_ID)
 	},
+	{
+		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_ATTO,
+		    MPI3_MFGPAGE_DEVID_SAS4116, PCI_ANY_ID, PCI_ANY_ID)
+	},
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
-- 
2.43.5

