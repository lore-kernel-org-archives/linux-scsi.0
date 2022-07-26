Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7889C00140
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 18:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiGZSDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiGZSDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 14:03:14 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BBB27B20
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 11:03:08 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id t7so11201581qvz.6
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 11:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=N9dGzeXyL0518668v3K1DTM6LhMmBXbhxLsN1YVRe7E=;
        b=kl1LqputDUzDBe66CfeOHXzOp4oM/ImEn9qdqFqo2HkcDYYwhlzC7Q5xvJkFODf1D+
         ulaZ95Y65tBSRDKSqFNKr2NbRmlkDBHJBFD6BhJeHv4u4jAh4RIvbvCC/4hvIxQmFzhy
         A/uXiCDb8it/VQf3SCuS6FJbRNB/NySSvjJhpd3q3aaSJGRLMJMt0gfkaVU0L8vM4VX3
         KrFhiov3yAO6p3yTQX8CB5g5gePetsvseTsZtV9nhzOkTNovvSkoI/vx538sND7+2bLb
         gwtYYhjaInxxO4+8skkc9YDgHBZXgaBzH4qvsyAUitieqghINMFhIo3J9z/1ar6blihA
         oaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=N9dGzeXyL0518668v3K1DTM6LhMmBXbhxLsN1YVRe7E=;
        b=aQkKFldHdeCYZbgV2Pam6z18gLMFPsuLE3ZxQ0wwpo8PBTbmt/SdGqMCSPliIGvjGR
         Oqv7BWcBOR6PzW2RUQldvbbZfTWnWgc1GzHVUeFqOpBVR42yXjTDc0eoTx1UTDc2hl/4
         pslR7lwzQJTke1dLtEOa1a6uT3CwLt/w3b1E795NbTik0urP/HbyF49bt7Wd10A2c4q8
         wSgTA3o+omn3hnab+XiswotJeayMJ8IfeYBLyqEphBpi5WtllWSv2hXQ+l/k7wa9OERS
         +ADIK2osDkP2Df3ax/Coc12h+6408Xw2aA9CbtqmTdrPu7lJ/TLpjSTfDkyPzuMyceTM
         MeQg==
X-Gm-Message-State: AJIora/MmD6BXkYC0SHqSFosEyHzeNQNruELxbjmWtebDg2UvXG9phn0
        GWn1ZfvcGIX9beIdSZkPlt8sOPtUgrqiJg==
X-Google-Smtp-Source: AGRyM1upF6aceIXHqOjgx0QDNvqet251u/GKGXq8Zvb4F0bA2xZ9oq+VMp8CrGuM8sxrki4f1g6UOA==
X-Received: by 2002:a05:6214:d0b:b0:473:6ec:7a88 with SMTP id 11-20020a0562140d0b00b0047306ec7a88mr15981023qvh.15.1658858587008;
        Tue, 26 Jul 2022 11:03:07 -0700 (PDT)
Received: from centos7-test-jenkins.localdomain (sw.attotech.com. [208.69.85.34])
        by smtp.googlemail.com with ESMTPSA id y8-20020a05620a44c800b006b5c5987ff2sm12471160qkp.96.2022.07.26.11.03.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jul 2022 11:03:06 -0700 (PDT)
From:   Bradley Grove <bradley.grove@gmail.com>
X-Google-Original-From: Bradley Grove <bgrove@attotech.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        Bradley Grove <bgrove@attotech.com>,
        Rob Crispo <rcrispo@attotech.com>
Subject: [PATCH 1/2] scsi: mpt3sas: Add support for ATTO ExpressSAS H12xx GT devices
Date:   Tue, 26 Jul 2022 14:01:02 -0400
Message-Id: <20220726180103.31575-1-bgrove@attotech.com>
X-Mailer: git-send-email 2.36.0
Reply-To: bgrove@attotech.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adds ATTO's PCI IDs and modifies the driver to handle the unique NVRAM
structure used by ATTO's devices.

Co-developed-by: Rob Crispo <rcrispo@attotech.com>
Signed-off-by: Rob Crispo <rcrispo@attotech.com>
Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h  |   1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 165 +++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  35 ++++++
 drivers/scsi/mpt3sas/mpt3sas_config.c | 124 +++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |   6 +
 5 files changed, 325 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index d00431f553e1..4d0be5ab98c1 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -534,6 +534,7 @@ typedef struct _MPI2_CONFIG_REPLY {
 ****************************************************************************/
 
 #define MPI2_MFGPAGE_VENDORID_LSI                   (0x1000)
+#define MPI2_MFGPAGE_VENDORID_ATTO                  (0x117C)
 
 /*MPI v2.0 SAS products */
 #define MPI2_MFGPAGE_DEVID_SAS2004                  (0x0070)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 37d46ae5c61d..3913f7093183 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5423,6 +5423,143 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	return rc;
 }
 
+/**
+ * mpt3sas_atto_validate_nvram - validate the ATTO nvram read from mfg pg1
+ *
+ * @ioc : per adapter object
+ * @n   : ptr to the ATTO nvram structure
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpt3sas_atto_validate_nvram(struct MPT3SAS_ADAPTER *ioc,
+			    struct ATTO_SAS_NVRAM *n)
+{
+	int r = -EINVAL;
+	union ATTO_SAS_ADDRESS *s1;
+	u32 len;
+	u8 *pb;
+	u8 ckSum;
+
+	/* validate nvram checksum */
+	pb = (u8 *) n;
+	ckSum = ATTO_SASNVR_CKSUM_SEED;
+	len = sizeof(struct ATTO_SAS_NVRAM);
+
+	while (len--)
+		ckSum = ckSum + pb[len];
+
+	if (ckSum) {
+		ioc_err(ioc, "Invalid ATTO NVRAM checksum\n");
+		return r;
+	}
+
+	s1 = (union ATTO_SAS_ADDRESS *) n->SasAddr;
+
+	if (n->Signature[0] != 'E'
+	|| n->Signature[1] != 'S'
+	|| n->Signature[2] != 'A'
+	|| n->Signature[3] != 'S')
+		ioc_err(ioc, "Invalid ATTO NVRAM signature\n");
+	else if (n->Version > ATTO_SASNVR_VERSION)
+		ioc_info(ioc, "Invalid ATTO NVRAM version");
+	else if ((n->SasAddr[7] & (ATTO_SAS_ADDR_ALIGN - 1))
+			|| s1->b[0] != 0x50
+			|| s1->b[1] != 0x01
+			|| s1->b[2] != 0x08
+			|| (s1->b[3] & 0xF0) != 0x60
+			|| ((s1->b[3] & 0x0F) | s1->d[1]) == 0) {
+		ioc_err(ioc, "Invalid ATTO SAS address\n");
+	} else
+		r = 0;
+	return r;
+}
+
+/**
+ * mpt3sas_atto_get_sas_addr - get the ATTO SAS address from mfg page 1
+ *
+ * @ioc : per adapter object
+ * @*sas_addr : return sas address
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpt3sas_atto_get_sas_addr(struct MPT3SAS_ADAPTER *ioc, u64 *sas_addr)
+{
+	Mpi2ManufacturingPage1_t mfg_pg1;
+	Mpi2ConfigReply_t mpi_reply;
+	struct ATTO_SAS_NVRAM *nvram;
+	int r;
+
+	r = mpt3sas_config_get_manufacturing_pg1(ioc, &mpi_reply, &mfg_pg1);
+	if (r) {
+		ioc_err(ioc, "Failed to read manufacturing page 1\n");
+		return r;
+	}
+
+	/* validate nvram */
+	nvram = (struct ATTO_SAS_NVRAM *) mfg_pg1.VPD;
+	r = mpt3sas_atto_validate_nvram(ioc, nvram);
+	if (r)
+		return r;
+
+	*sas_addr = be64_to_cpu(*((u64 *)nvram->SasAddr));
+	return r;
+}
+
+/**
+ * mpt3sas_atto_init - perform initializaion for ATTO branded
+ *					adapter.
+ * @ioc : per adapter object
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpt3sas_atto_init(struct MPT3SAS_ADAPTER *ioc)
+{
+	int sz = 0;
+	Mpi2BiosPage4_t *bios_pg4 = NULL;
+	Mpi2ConfigReply_t mpi_reply;
+	int r;
+	int ix;
+	u64 sas_addr;
+
+	r = mpt3sas_atto_get_sas_addr(ioc, &sas_addr);
+	if (r)
+		return r;
+
+	/* get header first to get size */
+	r = mpt3sas_config_get_bios_pg4(ioc, &mpi_reply, NULL, 0);
+	if (r) {
+		ioc_err(ioc, "Failed to read ATTO bios page 4 header.\n");
+		return r;
+	}
+
+	sz = mpi_reply.Header.PageLength * sizeof(u32);
+	bios_pg4 = kzalloc(sz, GFP_KERNEL);
+	if (!bios_pg4) {
+		ioc_err(ioc, "Failed to allocate memory for ATTO bios page.\n");
+		return -ENOMEM;
+	}
+
+	/* read bios page 4 */
+	r = mpt3sas_config_get_bios_pg4(ioc, &mpi_reply, bios_pg4, sz);
+	if (r) {
+		ioc_err(ioc, "Failed to read ATTO bios page 4\n");
+		goto out;
+	}
+
+	/* Update bios page 4 with the ATTO WWID */
+	for (ix = 0; ix < bios_pg4->NumPhys; ix++) {
+		bios_pg4->Phy[ix].ReassignmentWWID = sas_addr + ix;
+		bios_pg4->Phy[ix].ReassignmentDeviceName =
+			sas_addr + ATTO_SAS_ADDR_DEVNAME_BIAS;
+	}
+	r = mpt3sas_config_set_bios_pg4(ioc, &mpi_reply, bios_pg4, sz);
+
+out:
+	kfree(bios_pg4);
+	return r;
+}
+
 /**
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
@@ -5446,6 +5583,13 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 		if (rc)
 			return rc;
 	}
+
+	if (ioc->pdev->vendor == MPI2_MFGPAGE_VENDORID_ATTO) {
+		rc = mpt3sas_atto_init(ioc);
+		if (rc)
+			return rc;
+	}
+
 	/*
 	 * Ensure correct T10 PI operation if vendor left EEDPTagMode
 	 * flag unset in NVDATA.
@@ -5495,12 +5639,21 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	rc = _base_assign_fw_reported_qd(ioc);
 	if (rc)
 		return rc;
-	rc = mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
-	if (rc)
-		return rc;
-	rc = mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
-	if (rc)
-		return rc;
+
+	/*
+	 * ATTO doesn't use bios page 2 and 3 for bios settings.
+	 */
+	if (ioc->pdev->vendor ==  MPI2_MFGPAGE_VENDORID_ATTO)
+		ioc->bios_pg3.BiosVersion = 0;
+	else {
+		rc = mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
+		if (rc)
+			return rc;
+		rc = mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
+		if (rc)
+			return rc;
+	}
+
 	rc = mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
 	if (rc)
 		return rc;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e584cf0ffc23..c752fec5db0d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1652,6 +1652,32 @@ struct mpt3sas_debugfs_buffer {
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 
+/*
+ * struct ATTO_SAS_NVRAM - ATTO NVRAM settings stored
+ *				in Manufacturing page 1 used to get
+ *				ATTO SasAddr.
+ */
+struct ATTO_SAS_NVRAM {
+	u8		Signature[4];
+	u8		Version;
+#define ATTO_SASNVR_VERSION		0
+
+	u8		Checksum;
+#define ATTO_SASNVR_CKSUM_SEED	0x5A
+	u8		Pad[10];
+	u8		SasAddr[8];
+#define ATTO_SAS_ADDR_ALIGN		64
+	u8		Reserved[232];
+};
+
+#define ATTO_SAS_ADDR_DEVNAME_BIAS		63
+
+union ATTO_SAS_ADDRESS {
+	u8		b[8];
+	u16		w[4];
+	u32		d[2];
+	u64		q;
+};
 
 /* base shared API */
 extern struct list_head mpt3sas_ioc_list;
@@ -1828,6 +1854,9 @@ int mpt3sas_config_get_number_hba_phys(struct MPT3SAS_ADAPTER *ioc,
 	u8 *num_phys);
 int mpt3sas_config_get_manufacturing_pg0(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage0_t *config_page);
+int mpt3sas_config_get_manufacturing_pg1(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage1_t *config_page);
+
 int mpt3sas_config_get_manufacturing_pg7(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage7_t *config_page,
 	u16 sz);
@@ -1846,6 +1875,12 @@ int mpt3sas_config_get_bios_pg2(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2BiosPage2_t *config_page);
 int mpt3sas_config_get_bios_pg3(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2BiosPage3_t *config_page);
+int mpt3sas_config_set_bios_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2BiosPage4_t *config_page,
+	int sz_config_page);
+int mpt3sas_config_get_bios_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2BiosPage4_t *config_page,
+	int sz_config_page);
 int mpt3sas_config_get_iounit_pg0(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage0_t *config_page);
 int mpt3sas_config_get_sas_device_pg0(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index a8dd14c91efd..d114ef381c44 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -540,6 +540,42 @@ mpt3sas_config_get_manufacturing_pg0(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
+/**
+ * mpt3sas_config_get_manufacturing_pg1 - obtain manufacturing page 1
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_manufacturing_pg1(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage1_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_MANUFACTURING;
+	mpi_request.Header.PageNumber = 1;
+	mpi_request.Header.PageVersion = MPI2_MANUFACTURING1_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+		MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+		MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+		sizeof(*config_page));
+ out:
+	return r;
+}
+
 /**
  * mpt3sas_config_get_manufacturing_pg7 - obtain manufacturing page 7
  * @ioc: per adapter object
@@ -757,10 +793,98 @@ mpt3sas_config_get_bios_pg3(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+
  out:
 	return r;
 }
 
+/**
+ * mpt3sas_config_set_bios_pg4 - write out bios page 4
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * @sz_config_pg: sizeof the config page
+ * Context: sleep.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_set_bios_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2BiosPage4_t *config_page,
+	int sz_config_pg)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_BIOS;
+	mpi_request.Header.PageNumber = 4;
+	mpi_request.Header.PageVersion = MPI2_BIOSPAGE4_PAGEVERSION;
+
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+		MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+		MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+		sz_config_pg);
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_config_get_bios_pg4 - read bios page 4
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * @sz_config_pg: sizeof the config page
+ * Context: sleep.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_bios_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2BiosPage4_t *config_page,
+	int sz_config_pg)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_BIOS;
+	mpi_request.Header.PageNumber = 4;
+	mpi_request.Header.PageVersion =  MPI2_BIOSPAGE4_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+		MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	/*
+	 * The sizeof the page is variable. Allow for just the
+	 * size to be returned
+	 */
+	if (config_page && sz_config_pg) {
+		mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+		r = _config_request(ioc, &mpi_request, mpi_reply,
+			MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+			sz_config_pg);
+	}
+
+out:
+	return r;
+}
+
 /**
  * mpt3sas_config_get_iounit_pg0 - obtain iounit page 0
  * @ioc: per adapter object
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b519f4b59d30..57fc606a3ef8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12732,6 +12732,12 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3816,
 		PCI_ANY_ID, PCI_ANY_ID },
 
+	/*
+	 * ATTO Branded ExpressSAS H12xx GT
+	 */
+	{ MPI2_MFGPAGE_VENDORID_ATTO, MPI26_MFGPAGE_DEVID_HARD_SEC_3816,
+		PCI_ANY_ID, PCI_ANY_ID },
+
 	/*
 	 *  Sea SI –> 0x00E4 Invalid, 0x00E7 Tampered
 	 */
-- 
2.36.0

