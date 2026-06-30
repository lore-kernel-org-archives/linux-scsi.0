Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2147D328610
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782859886; cv=none; b=VwKuvbKeJdezF27iieAsG57V9b+XVBUSMccv97t8AAmO7KII8YELCEFbeDpjapTlVxspqOm2+zTi7ll4R/mdmXTWpWM8h7+/QAFB3T09aBKBuV9e4HnHWFJV75oesc2gZqi0vxEoFD/lIdlsd6ce0hGinQSsJzOCr5O/rh+CdAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782859886; c=relaxed/simple;
	bh=KHwt4VywKXahV6WokSspiyABJUFGu96lEtBUDy+TEgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN99J2jqxyUGknDw0ly4Q6YaCkEvSKyNDituRXTc7qOR0Rss7zkU4ZA34LBdYCGvimg3WKJZ+P274HJUsWmv7tdCKSEzhE1X5O4xUgYvxUuV3omNfuuRSrE8w+zxFvXEa750GkvouEpstDdG+fLF+T78fcy3jSpnDxgNXzVddyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Prbv6+Ea; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Prbv6+Ea"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so151395e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 15:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782859883; x=1783464683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XF2BPxT6RGXOvylZIStDuHxnCtiMXDzVdoPv3lbFrwE=;
        b=Prbv6+EaX7VpSgoXgZuyHWWr6Hseq+ye6VdpZeTaivAaeZrLMvoTpCA5Tf4kFssFGP
         wm6XjlLfMlJ3bq1hhTgGYNv9Vk0Mv92rNHn6hJAJRfPl9PYJ1LWbQ3+u4orD9C5EFSia
         QXwa+RCFQebmqvJ4kejjD/ZAIuRBJjY/9O7WMnwoNBwNDaYjDrdWv4gZof6bgSON/mrr
         Iy4WZ9RuGw+nk4QEs2WNVzBUJH4FLjdPWZpaG0+9C+qESy/6V5v/qVNk0zoE/diH/NBi
         wCnO4oiADpkxbX47ztftteaEHp6VDq2ofbIxjUOi3kwRINqY064taD3s3vM2AeyG9RDX
         eBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782859883; x=1783464683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XF2BPxT6RGXOvylZIStDuHxnCtiMXDzVdoPv3lbFrwE=;
        b=edI4qW2nRggfd1OmpsWp9Ul1SUg2soFuL/O5QH0+ozeUxDIEldfQn7PMg7xrAAdZ7U
         Q+DXMsX0cLzvBmqKyqoFVzhraoZiY9TKE6kGW2E6S/nctYg+s4P9sEmdvnCir1VInzv6
         S2jKwfGTG9PVMgbE1uS1HTY8MempNj8Ao4XJhmtFU2UlQIP//HOlbdJdpqYpmTskLVxe
         b3SPgGPdcwdiBj3l9tjWZR3cy1rmpGYDQsSUuqzlrLPrMZLM9xCsNGPi5ordB9KKUxKP
         iWKIrGTd3pn4my4IvNUhn4LfW9uCgzXU2daLyPxRLcf8uRWoAMFjYoNwx4S+gaOJPqIO
         6MOQ==
X-Forwarded-Encrypted: i=1; AFNElJ973ywtBh2NnLSK/p+mmVREpOc9ppPryF1KMkVJtQFyYGgVQI/qEo/ok321zBzN7/duutqbFWh9ATOQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Sm4gm1FteNQttd/NsPtu/h1TiexefAs7cqb2kfKo59qwLiVl
	Sp7+v4HlQxLPtgNBSrVivVxnaxJXyXWX4PrX4U4sTdFueowlLbemibIo
X-Gm-Gg: AfdE7ckgCKdpfzRWv7LgOzPNapcJpCQrsM2KNfgWXFVsQmSahC70IYIWHE9TPbUjm9J
	a+gmzk22FtEveATB5Wj5J1tOVVodj/sBtkP9jt1lXJJwtrggPlEf0TjLZdADywcbGn3KN7LQYiX
	mpw2UfzF7b2sL9qN05LkyI5weE00boZrMs94BuEdujrMuPlDmdl6I8DVa2lQzniJWIe19jzHppO
	ZDx6KEHW9EdNZgzuA+5GGa+9QQuCUr3OMZLmBDEXDNuqTiWX4mLYLUAez+nyLmFG7h5OmBBQ7Xa
	0OyyyRGlzfZR3/1pzTxFvSaeCEcpb+ZVrR188TfdWTZuGpCjGWmzYWc4EWwMgDX6+tENqR6Rqhr
	xSi26ew/w1yrhX4VcXCkN/YB45TDx2cbl0ClD+tt0KzFyAIIuSPeo8mt6HtLxL2bNFO+2c/S+
X-Received: by 2002:a05:600c:8596:b0:493:b2c1:b2f8 with SMTP id 5b1f17b1804b1-493b828166cmr72579495e9.4.1782859883383;
        Tue, 30 Jun 2026 15:51:23 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be81fca5sm31793945e9.14.2026.06.30.15.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 15:51:22 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v5 1/2] scsi: mpt3sas: add IO Unit Page 7 config accessor
Date: Wed,  1 Jul 2026 00:49:21 +0200
Message-ID: <20260630224922.2543096-2-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630224922.2543096-1-sautier.louis@gmail.com>
References: <20260630224922.2543096-1-sautier.louis@gmail.com>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_config.c | 36 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d4597d058705..fe21b0425047 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1904,6 +1904,9 @@ int mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz);
 int mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
+int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
+				  Mpi2ConfigReply_t *mpi_reply,
+				  Mpi2IOUnitPage7_t *config_page);
 int mpt3sas_config_get_iounit_pg8(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage8_t *config_page);
 int mpt3sas_config_get_sas_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 45ac853e1289..b0d5ef893600 100644
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
+int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
+				  Mpi2ConfigReply_t *mpi_reply,
+				  Mpi2IOUnitPage7_t *config_page)
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
+			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT,
+			    config_page, sizeof(*config_page));
+ out:
+	return r;
+}
+
 /**
  * mpt3sas_config_get_iounit_pg8 - obtain iounit page 8
  * @ioc: per adapter object
-- 
2.54.0

