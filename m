Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E766424DCE7;
	Fri, 13 Jun 2025 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846592; cv=none; b=ghQ9mlfp131yBFhHSzL1H9iRTVJKEd9NFiKn/rpXgngjojPTr8UZngGxMRFT4t6NA775OZO8wPPI3E+zaKoQp1Y4CLI+OK/6SrcG0j1ki3uPNo7Ybno5IHNfWR5y47Z36twsKnCLpCypH3GxEU6ENUxYH5lKI8/GBstO96fdwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846592; c=relaxed/simple;
	bh=2KGVYqT/gfCOhWt0pFzbq0xjb7zLZfIjGaLpQ/pxDG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzf/na/TCdcwpBqEp68ccY1dTqUD7xwG0D37SEExVC4/80vTmodeu5a/JS2KESzciZs2ckV8btsBYvfv3xNy71SqkRf8jEw9coGqdZTSzxXL15E3NRr/Ab1NihosXaUC0wlz3fRDgTl6+pmfn/+6KBDc6BAsKMteKZ5XBa0IaqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4OGxwy9; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4OGxwy9"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4a43e277198so21086931cf.1;
        Fri, 13 Jun 2025 13:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749846590; x=1750451390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzfX+a8a8S5RXERHw08wlqnrhGiHvVK3pm21dZrJp2s=;
        b=W4OGxwy9hBaLfip1VQwcVUvPk9SX7fwqPX7aqqAWZmoJlRMKHOqSIu31ktaFiQtnke
         C2FyExfoAyAa3FtJ98qQU6iWlyLVYgAl06fNOQTdGPFxOIdzLf+2coXBYIPnlVUvYbLe
         x4cRz0obrs0ARXeCX5pRpTqZFlOvnex4pAd+IFbBVDOH5OWjEAHNTtdH2E1tGePH2nrR
         FDWREkcgquRf6xvonDyRxGXouC27rU/GQLcrudhTsFLF1s9QH2YInslssVDr/VVxO60T
         T27WbzYKuW+ikw15bHnhKg5u9tv/ub9plxu3U0x47ncUpaA9XBAJGDm+uf4IW2zLyvDT
         wvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846590; x=1750451390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzfX+a8a8S5RXERHw08wlqnrhGiHvVK3pm21dZrJp2s=;
        b=VN13t+D9jNRMXKybKk8I2syAfaVV454oZpjtEL6G5gYfna3srBHncn83vxcaT+nYF6
         NLHCX3wnHxH2fgErQERcvbPzujV2IOyixFM6G1Kp7VcuRFwGcqYtIxb7i+KZbGfL6hnL
         aYzC62IqAYh0FoJhCbhTNpmq+vvvndKF3UcsTS7WPNrtJoYzrfLdpM/Li2/ieO8sWPS9
         cBOIvq1QMVhjNt9A5RmsSsSguvlcRJJSnRpTsIBToAW4EFGivXwKFl6DHH0CjS4aKMzC
         xTMU/0W/Mt7a8+NVpcpPlrU5112ZI5ylP0aXd5c4LrVSa7hBsCrss73h8N0F62o1cVlM
         78jw==
X-Forwarded-Encrypted: i=1; AJvYcCVqvOGiaMCW62pG6ohOVObBey34+fEzZgNO/JRV62/ImJSGjXxERGYNEJWtnvoBFJq0lY+dwTXUmYdrdA==@vger.kernel.org, AJvYcCWCLTjN3pK34z+vVx1ZiJIA5tSRU4tNH69aXirzlJCVZ+QQSIGeDwTo5LSPJwxiu4Pu/FGhaZ0FX0JIJO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr8ycRjGU/IHPuDL6QgCvikyV7WOyBF1YtTj8+68viRyoKNS62
	8vPxkE1NuHJiS6BylKDqQsJJ/xRr0zkpAYosi/zYcLAmP5XrpeBjvTfA
X-Gm-Gg: ASbGncuv6Gc0vkbYek8W+7558w4A0xiFj82vEx+qYRj6GsyVjdpcu5cPi6F1FexW1N8
	Lq1yyt7Zl8SEkhyYiOhkc2tj3Fr+epQ5J7/5nQWh+Kn4CZB3GxUNIIe+AS5hwNUe84IoihjMNax
	szEB4XBSSetRmA42SCbEyz/hlp3a1geyTqKany9axs9vR+qZoA1L/KK7InFPUMCs+fbGannBRDO
	uSrfTWJFJ64sNMgvxHtXjhA1+zyVEhoPiRxG1OBScwN9B/F57rV2iGnkdxQ7sRqNtR23C7Nyue+
	6hM10a/R/5simYTtKTigjuv3OJY/Ges5mRJm3ctrvUTSmXAzqIGj9f5ZnmaPMSF/0DzSgkjnjcI
	RG41U8RykvHqW6w==
X-Google-Smtp-Source: AGHT+IG4kY/2+S5wiXhPgmmf040aKH9a6yXJZ5BptOmo+ia/b0fKT36DHshxldmdxIgGsy6X/Ak3xw==
X-Received: by 2002:a05:622a:488:b0:4a4:3e89:d5c0 with SMTP id d75a77b69052e-4a73c4bec58mr8990401cf.12.1749846589722;
        Fri, 13 Jun 2025 13:29:49 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a2c068esm21500411cf.1.2025.06.13.13.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 13:29:49 -0700 (PDT)
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
Subject: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS HBAs
Date: Fri, 13 Jun 2025 16:29:41 -0400
Message-ID: <20250613202941.62114-2-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250613202941.62114-1-ssiwinski@atto.com>
References: <20250613202941.62114-1-ssiwinski@atto.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds initialization routines for ATTO 24Gb SAS HBAs.
It introduces the ATTO NVRAM structure and functions to validate
NVRAM contents.

The `mpi3mr_atto_init` function is added to handle ATTO-specific
controller initialization. This involves reading the ATTO SAS address
from Driver Page 2 and then assigning unique device names and WWIDs
to Manufacturing Page 5.

Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  35 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 310 ++++++++++++++++++++++++++++++++
 2 files changed, 345 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9bbc7cb98ca3..05583457ffaa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1438,6 +1438,35 @@ struct delayed_evt_ack_node {
 	u32 event_ctx;
 };
 
+/*
+ * struct ATTO_SAS_NVRAM - ATTO NVRAM settings
+ * @signature: ATTO NVRAM signature
+ * @version: ATTO NVRAM version
+ * @checksum: NVRAM checksum
+ * @sasaddr: ATTO SAS address
+ */
+struct ATTO_SAS_NVRAM {
+	u8		signature[4];
+	u8		version;
+#define ATTO_SASNVR_VERSION		0
+
+	u8		checksum;
+#define ATTO_SASNVR_CKSUM_SEED	0x5A
+	u8		pad[10];
+	u8		sasaddr[8];
+#define ATTO_SAS_ADDR_ALIGN		64
+	u8		reserved[232];
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
+
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
@@ -1533,10 +1562,16 @@ int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
 int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
+int mpi3mr_cfg_get_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
+int mpi3mr_cfg_set_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
 int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
 int mpi3mr_cfg_get_driver_pg2(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page2 *driver_pg2, u16 pg_sz, u8 page_type);
+int mpi3mr_cfg_get_page_size(struct mpi3mr_ioc *mrioc,
+	int page_type, int page_num);
 
 u8 mpi3mr_is_expander_device(u16 device_info);
 int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1d7901a8f0e4..c0177ad3d200 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4203,6 +4203,163 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_atto_validate_nvram - validate the ATTO nvram
+ *
+ * @mrioc:  Adapter instance reference
+ * @nvram: ptr to the ATTO nvram structure
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_atto_validate_nvram(struct mpi3mr_ioc *mrioc, struct ATTO_SAS_NVRAM *nvram)
+{
+	int r = -EINVAL;
+	union ATTO_SAS_ADDRESS *sasaddr;
+	u32 len;
+	u8 *pb;
+	u8 cksum;
+
+	/* validate nvram checksum */
+	pb = (u8 *) nvram;
+	cksum = ATTO_SASNVR_CKSUM_SEED;
+	len = sizeof(struct ATTO_SAS_NVRAM);
+
+	while (len--)
+		cksum = cksum + pb[len];
+
+	if (cksum) {
+		ioc_err(mrioc, "Invalid ATTO NVRAM checksum\n");
+		return r;
+	}
+
+	sasaddr = (union ATTO_SAS_ADDRESS *) nvram->sasaddr;
+
+	if (nvram->signature[0] != 'E'
+	|| nvram->signature[1] != 'S'
+	|| nvram->signature[2] != 'A'
+	|| nvram->signature[3] != 'S')
+		ioc_err(mrioc, "Invalid ATTO NVRAM signature\n");
+	else if (nvram->version > ATTO_SASNVR_VERSION)
+		ioc_info(mrioc, "Invalid ATTO NVRAM version");
+	else if ((nvram->sasaddr[7] & (ATTO_SAS_ADDR_ALIGN - 1))
+			|| sasaddr->b[0] != 0x50
+			|| sasaddr->b[1] != 0x01
+			|| sasaddr->b[2] != 0x08
+			|| (sasaddr->b[3] & 0xF0) != 0x60
+			|| ((sasaddr->b[3] & 0x0F) | le32_to_cpu(sasaddr->d[1])) == 0) {
+		ioc_err(mrioc, "Invalid ATTO SAS address\n");
+	} else
+		r = 0;
+	return r;
+}
+
+/**
+ * mpi3mr_atto_get_sas_addr - get the ATTO SAS address from driver page 2
+ *
+ * @mrioc: Adapter instance reference
+ * @*sas_address: return sas address
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_atto_get_sas_addr(struct mpi3mr_ioc *mrioc, union ATTO_SAS_ADDRESS *sas_address)
+{
+	struct mpi3_driver_page2 *driver_pg2 = NULL;
+	struct ATTO_SAS_NVRAM *nvram;
+	u16 sz;
+	int r;
+	__be64 addr;
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_DRIVER, 2);
+	driver_pg2 = kzalloc(sz, GFP_KERNEL);
+	if (!driver_pg2)
+		goto out;
+
+	r = mpi3mr_cfg_get_driver_pg2(mrioc, driver_pg2, sz, MPI3_CONFIG_ACTION_READ_PERSISTENT);
+	if (r)
+		goto out;
+
+	nvram = (struct ATTO_SAS_NVRAM *) &driver_pg2->trigger;
+
+	r = mpi3mr_atto_validate_nvram(mrioc, nvram);
+	if (r)
+		goto out;
+
+	addr = *((__be64 *) nvram->sasaddr);
+	sas_address->q = cpu_to_le64(be64_to_cpu(addr));
+
+out:
+	kfree(driver_pg2);
+	return r;
+}
+
+/**
+ * mpi3mr_atto_init - Initialize the controller
+ * @mrioc: Adapter instance reference
+ *
+ * This the ATTO controller initialization routine
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
+static int mpi3mr_atto_init(struct mpi3mr_ioc *mrioc)
+{
+	int i, bias = 0;
+	u16 sz;
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+	struct mpi3_man_page5 *man_pg5 = NULL;
+	union ATTO_SAS_ADDRESS base_address;
+	union ATTO_SAS_ADDRESS dev_address;
+	union ATTO_SAS_ADDRESS sas_address;
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT, 0);
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		goto out;
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_MANUFACTURING, 5);
+	man_pg5 = kzalloc(sz, GFP_KERNEL);
+	if (!man_pg5)
+		goto out;
+
+	if (mpi3mr_cfg_get_man_pg5(mrioc, man_pg5, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	mpi3mr_atto_get_sas_addr(mrioc, &base_address);
+
+	dev_address.q = base_address.q;
+	dev_address.b[0] += ATTO_SAS_ADDR_DEVNAME_BIAS;
+
+	for (i = 0; i < man_pg5->num_phys; i++) {
+		if (sas_io_unit_pg0->phy_data[i].phy_flags &
+			(MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
+			MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
+			continue;
+
+		sas_address.q = base_address.q;
+		sas_address.b[0] += bias++;
+
+		man_pg5->phy[i].device_name = dev_address.q;
+		man_pg5->phy[i].ioc_wwid = sas_address.q;
+		man_pg5->phy[i].sata_wwid = sas_address.q;
+	}
+
+	if (mpi3mr_cfg_set_man_pg5(mrioc, man_pg5, sz))
+		ioc_info(mrioc, "ATTO set manufacuring page 5 failed\n");
+
+out:
+	kfree(sas_io_unit_pg0);
+	kfree(man_pg5);
+
+	return 0;
+}
+
+
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
@@ -4376,6 +4533,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	if (mrioc->pdev->subsystem_vendor == MPI3_MFGPAGE_VENDORID_ATTO)
+		mpi3mr_atto_init(mrioc);
+
 	ioc_info(mrioc, "controller initialization completed successfully\n");
 	return retval;
 out_failed:
@@ -6293,6 +6453,118 @@ int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	return -1;
 }
 
+/**
+ * mpi3mr_cfg_get_man_pg5 - Read manufacturing page 5
+ * @mrioc: Adapter instance reference
+ * @io_unit_pg5: Pointer to the manufacturing page 5 to read
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page read of manufacturing
+ * page 5.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(man_pg5, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_MANUFACTURING;
+	cfg_req.page_number = 5;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "manufacturing page5 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, man_pg5, pg_sz)) {
+		ioc_err(mrioc, "manufacturing page5 read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_set_man_pg5 - Write manufacturing page 5
+ * @mrioc: Adapter instance reference
+ * @io_unit_pg5: Pointer to the manufacturing page 5 to write
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page write for manufacturing
+ * page 5. This will modify only the current page.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_set_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_MANUFACTURING;
+	cfg_req.page_number = 5;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "manufacturing page5 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	cfg_req.action = MPI3_CONFIG_ACTION_WRITE_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, man_pg5, pg_sz)) {
+		ioc_err(mrioc, "manufacturing page5 write failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 write failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	return 0;
+out_failed:
+	return -1;
+}
+
 /**
  * mpi3mr_cfg_get_driver_pg1 - Read current Driver page1
  * @mrioc: Adapter instance reference
@@ -6409,3 +6681,41 @@ int mpi3mr_cfg_get_driver_pg2(struct mpi3mr_ioc *mrioc,
 	return -1;
 }
 
+/**
+ * mpi3mr_cfg_get_page_size - Get the size of requested page
+ * @mrioc: Adapter instance reference
+ * @page_type: Page type (MPI3_CONFIG_PAGETYPE_XXX)
+ * @page_num: Page number
+ *
+ * Return the specified config page size in bytes.
+ *
+ * Return: Page size in bytes, -1 on failure.
+ */
+int mpi3mr_cfg_get_page_size(struct mpi3mr_ioc *mrioc, int page_type, int page_num)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = page_type;
+	cfg_req.page_number = page_num;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "header read failed\n");
+		return -1;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		return -1;
+	}
+
+	return cfg_hdr.page_length * 4;
+}
-- 
2.43.5

