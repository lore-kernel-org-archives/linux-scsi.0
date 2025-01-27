Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAEE17D2;
	Mon, 27 Jan 2025 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737937741; cv=none; b=ICFGzyEgrpaXFPst3KZ1yOQZdwjTZobQtRPHfFdTgYdRV2ogWSx5CDDU1trvYVIo2V61Sd9CxOEJMKRiR+VZBFikHvf3XATbC26bT2JJLRQd0C2oRR9EuCBokP2UBqeWYJE+tfWDDctGBICg8amZgzpumZIlngzLALG0FydSNw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737937741; c=relaxed/simple;
	bh=J1gHFXec4k9NYnun4JQSkNCLi1jidMCbfWh6Yy6iDXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uEu78PuYQEHJbB/3aKwWSeLTtwGqZ/Aic6U7/oZrvKjlZzZrowQp43b7xj+XgrF2bi5N/MFrJfG0WEnwhBrPcpet+fNiRmgZPmCf0nzeEM0Q7UV/oHuNRvj7h2g2z7SQ9aCNMgFOCNFhCFjPCEs+g4h9yzsxZ5rMynCWuZ4Vud8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Hf/rdxXg; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Hf/rdxXg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=v1GLcctXV4mZNKYy6wReyvmyFMezFCC4Mx8j8S94Ls0=; b=Hf/rdxXgBNtTiOqg
	rxM1M1sSyGpcVvn23sCoh6WNmh6Rwq+vL0y9tolg1u8e2GX1oJ7WG7GPnNjUK400WPOzlZv8JpfMv
	ZpoBytU2CF4wWOjUDyKQECqArhwMnBXxPE/x143A1H8tHECrsxh1ja2nMERncsbSMobIEAP55vqq8
	90+XaJrkSF4rfNIMC90EjmqN6DWfwqEm5B+BauMA/FQPtQtCTJZ9S+s8eketjy7sAsdRDyIAlQNO0
	awfdJBWhnVYwFIVdQLKEgQehkos2V+sPLFR/JoEeCPamANZqVV45vybb/8gKKgSx33XT6hGAh4VOT
	d6ueS+zsDygr6HbcdA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tcCzk-00CDwe-1y;
	Mon, 27 Jan 2025 00:28:52 +0000
From: linux@treblig.org
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: mpt3sas: Remove unused config functions
Date: Mon, 27 Jan 2025 00:28:51 +0000
Message-ID: <20250127002851.113711-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

mpt3sas_config_get_manufacturing_pg7() and
mpt3sas_config_get_sas_device_pg1() were added as part of 2012's
commit f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
but haven't been used.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  6 --
 drivers/scsi/mpt3sas/mpt3sas_config.c | 79 ---------------------------
 2 files changed, 85 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d8d1a64b4764..85aed2147aac 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1858,9 +1858,6 @@ int mpt3sas_config_get_manufacturing_pg0(struct MPT3SAS_ADAPTER *ioc,
 int mpt3sas_config_get_manufacturing_pg1(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage1_t *config_page);
 
-int mpt3sas_config_get_manufacturing_pg7(struct MPT3SAS_ADAPTER *ioc,
-	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage7_t *config_page,
-	u16 sz);
 int mpt3sas_config_get_manufacturing_pg10(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply,
 	struct Mpi2ManufacturingPage10_t *config_page);
@@ -1887,9 +1884,6 @@ int mpt3sas_config_get_iounit_pg0(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 int mpt3sas_config_get_sas_device_pg0(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2SasDevicePage0_t *config_page,
 	u32 form, u32 handle);
-int mpt3sas_config_get_sas_device_pg1(struct MPT3SAS_ADAPTER *ioc,
-	Mpi2ConfigReply_t *mpi_reply, Mpi2SasDevicePage1_t *config_page,
-	u32 form, u32 handle);
 int mpt3sas_config_get_pcie_device_pg0(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26PCIeDevicePage0_t *config_page,
 	u32 form, u32 handle);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 2e88f456fc34..45ac853e1289 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -576,44 +576,6 @@ mpt3sas_config_get_manufacturing_pg1(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
-/**
- * mpt3sas_config_get_manufacturing_pg7 - obtain manufacturing page 7
- * @ioc: per adapter object
- * @mpi_reply: reply mf payload returned from firmware
- * @config_page: contents of the config page
- * @sz: size of buffer passed in config_page
- * Context: sleep.
- *
- * Return: 0 for success, non-zero for failure.
- */
-int
-mpt3sas_config_get_manufacturing_pg7(struct MPT3SAS_ADAPTER *ioc,
-	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage7_t *config_page,
-	u16 sz)
-{
-	Mpi2ConfigRequest_t mpi_request;
-	int r;
-
-	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
-	mpi_request.Function = MPI2_FUNCTION_CONFIG;
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
-	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_MANUFACTURING;
-	mpi_request.Header.PageNumber = 7;
-	mpi_request.Header.PageVersion = MPI2_MANUFACTURING7_PAGEVERSION;
-	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
-	if (r)
-		goto out;
-
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    sz);
- out:
-	return r;
-}
-
 /**
  * mpt3sas_config_get_manufacturing_pg10 - obtain manufacturing page 10
  * @ioc: per adapter object
@@ -1213,47 +1175,6 @@ mpt3sas_config_get_sas_device_pg0(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
-/**
- * mpt3sas_config_get_sas_device_pg1 - obtain sas device page 1
- * @ioc: per adapter object
- * @mpi_reply: reply mf payload returned from firmware
- * @config_page: contents of the config page
- * @form: GET_NEXT_HANDLE or HANDLE
- * @handle: device handle
- * Context: sleep.
- *
- * Return: 0 for success, non-zero for failure.
- */
-int
-mpt3sas_config_get_sas_device_pg1(struct MPT3SAS_ADAPTER *ioc,
-	Mpi2ConfigReply_t *mpi_reply, Mpi2SasDevicePage1_t *config_page,
-	u32 form, u32 handle)
-{
-	Mpi2ConfigRequest_t mpi_request;
-	int r;
-
-	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
-	mpi_request.Function = MPI2_FUNCTION_CONFIG;
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
-	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
-	mpi_request.ExtPageType = MPI2_CONFIG_EXTPAGETYPE_SAS_DEVICE;
-	mpi_request.Header.PageVersion = MPI2_SASDEVICE1_PAGEVERSION;
-	mpi_request.Header.PageNumber = 1;
-	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
-	if (r)
-		goto out;
-
-	mpi_request.PageAddress = cpu_to_le32(form | handle);
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    sizeof(*config_page));
- out:
-	return r;
-}
-
 /**
  * mpt3sas_config_get_pcie_device_pg0 - obtain pcie device page 0
  * @ioc: per adapter object
-- 
2.48.1

