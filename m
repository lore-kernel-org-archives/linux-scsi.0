Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48464968F6
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023521; cv=none; b=acQ/sxnbe/mIRaLQYhAy55+tPHWAcj4WratzNlbibKxLGzGFFOxSzJVSWCe3cu8/Ao1n/wHNzo9+Fjkrj8eVQCLcs5lqBeLRH+0HIRxzHHZWLP6Hg6SbTgCPzn6bA1RAgxjJ0/HgSO7bM1R8NcGBAb9Fx9n86GdNWih41NhnSj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023521; c=relaxed/simple;
	bh=Bt3my+6l00h9cgScvXgngonjEUgxY/cU8mMorKuK7Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvfT8D79GLqkhAnCcnP+dKcRpjQ4p6NZXTUnbbN8vHWEnlm1hj+/JgDUm9d7EQS/By7ox/o/30twewA00rsIz2HpxPsmy0+uro7e+0oU7eUlYF82O3tB6lN4mvNdNPQyY2N3/JYPwK8NVIA3dTxJ2hcQmz61XIiMyT0aOpjw6W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipv7P6bs; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipv7P6bs"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45fd464d51fso3170578f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 09:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781023518; x=1781628318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8+wQM4a4tsMzXZ7biCKDr40TVU55tRrbtX6KIaXn24=;
        b=ipv7P6bsCl1k3+tGBJNpnueRBwvupjARxEUtiQqpaaCWycSmApY4JFYk0d1xNHP6Fq
         6foz0HThZbLOAIRMc62+5DPGWvlzGEdfvoaBvWmlbSSD9ZJO4UXUykpy1GzOtTNr0sCv
         AMQXlpw0eXQeTHwKwy2DeU4hrofJSzjcQMy1KPZeK55JZR6fOK4Q0d9RecPp4ftEgwwp
         qQv8I2yF7SdM8ZMmEgC4aD9nLrLInTehHw1B/JEC5tIZp5bDZ89fJ1vH4C5XErFtiWFy
         xOcXjpivC+D2+HROGCylR/t5cyyP8RvQtjwrArLRpMp64XqiIyeTB3fjjMusOiK3ECNi
         jgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781023518; x=1781628318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f8+wQM4a4tsMzXZ7biCKDr40TVU55tRrbtX6KIaXn24=;
        b=Gjsz9KofwYF9s+yRpOf1wOo5yjqo4mk6RaheqpXX/IM6W40RTFYM+fV9XHpJy4Hiw/
         PsPEICK8irH28sA2wAVrmf282syp8wSD9MFRLFkkplpq8Hn4/ueQcEBc5b+2CnVuUNN6
         +LES8WeRBTWfkjPOf0bA5uqaACZZOInsbCxenrkaNx6D9c5JinJS7YNhBoIzhn/m/dNU
         KF0rHGXIRR0/ZFwINjUkS7CCZuUlEalOjbAB6EkLnZCJjlznwvzOd1YDaLKwX06iWQ+W
         zpGT41Hm4zEAZ1t6EgjcbMImq2kl2csYxCEpx0rPU07c916TlaODbx2Ltv1c/8Em0Nv+
         eXbw==
X-Forwarded-Encrypted: i=1; AFNElJ9glifxaTFQjg0nl0gcGDkZp8Lrz9Th2hriuSg9ZyweYBWOlpQxgJ4KF2wgC11U0twNmN6T7nP1egXP@vger.kernel.org
X-Gm-Message-State: AOJu0YwErISZlX/YrPEUkl00ZbmDiM0tyyVmFpV17u94893+O5uZ7bpy
	naNj7Y3mS+W+Lh9/pe0F/dGPhoQ9XMvJcSdK4G/3teacgcx7l0JDQHrg
X-Gm-Gg: Acq92OG5ByNRrntTolcyJzHwYDTp+KIJgWiT256QluCUGt/vqCD2ICcHD2oSSGBLs1a
	hBkxhtehGnS+xMHlrjlVV3u5yeBX0rKwrNzbfiaX3rG98NGySNuSlJqO2w40MU0ED/sVLTDMpuZ
	1Did57Lls8as299I8Qx6dEfvdx6/A3KxXd1jBvqNzaC8FyMAbZoFl84bqP1tafQehdlpPh1gLLu
	A/bLDPnnkTmCiM1EjsFckqpQ9siIIjrqaAEFoU/RorObXJtGgV+gZPycCVV9ufAr6OMDtEPyE9U
	Xe2Z1uEC2FQm3eKI6xoqmbDweTorUei5ErM3ApyH3oRFWqPYKY6t0Vunbvub1gfc3rgSB0UiD32
	IQCkS2jFJ71KZbgN8LK1/wsbF/JGVPOxDS56OGtYY0QOUQHWNPr7b+6BDI8Juff/saYiORfqcbp
	WrBEIqthmn6MyXqgJ/
X-Received: by 2002:a5d:4a4e:0:b0:452:75ca:3fab with SMTP id ffacd0b85a97d-4603063a3c1mr19456027f8f.38.1781023518076;
        Tue, 09 Jun 2026 09:45:18 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcbe3sm59351635f8f.8.2026.06.09.09.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:45:16 -0700 (PDT)
From: Louis Sautier <sautier.louis@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 RESEND 1/2] scsi: mpt3sas: add IO Unit Page 7 config accessor
Date: Tue,  9 Jun 2026 18:44:22 +0200
Message-ID: <20260609164423.2829699-2-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260609164423.2829699-1-sautier.louis@gmail.com>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mpt3sas_config_get_iounit_pg7(), mirroring the existing iounit
page accessors. Used by the hwmon driver added in the following patch
to read the IOC and board temperatures.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Louis Sautier <sautier.louis@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_config.c | 36 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d4597d058705..c655742d0dde 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1904,6 +1904,8 @@ int mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz);
 int mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
+int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page);
 int mpt3sas_config_get_iounit_pg8(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage8_t *config_page);
 int mpt3sas_config_get_sas_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 45ac853e1289..ef07825046bc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -991,6 +991,42 @@ mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
+/**
+ * mpt3sas_config_get_iounit_pg7 - obtain iounit page 7
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_IO_UNIT;
+	mpi_request.Header.PageNumber = 7;
+	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE7_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
 /**
  * mpt3sas_config_get_iounit_pg8 - obtain iounit page 8
  * @ioc: per adapter object
-- 
2.54.0

