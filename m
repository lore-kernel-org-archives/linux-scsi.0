Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7D3368B7
	for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2026 02:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781318343; cv=none; b=Vp/DnHmqtTOL87SO4sejogT7U8clVfscKo2Nv3pIvlNKwhi+i2TsGT6zEpHUs0TMMH1cfL7EILW5j8JX5/+FymLTV7F4+QBdUJeFyYqHqTP1kdejQTqLdLVa9kzWDOq4f2ESdRR0lnjfqWP/mG+kIux6ZLgrRjfHcB+WigvoqHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781318343; c=relaxed/simple;
	bh=KHwt4VywKXahV6WokSspiyABJUFGu96lEtBUDy+TEgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpLhWdwJN/8I1pa3kCg+exFvCUzRbqqdP9b+M+EMPLKmhDvZ4d4j3eACbDNM0f/yIQtwy1k8R5s9nhvVzHbWlw5PoXk13wBBTmwYbJFmJsyb1XWbRoseJU3cCWbzq8iKNPcqe3rAPrSeH25lXlLzCRMRZgugl1A9mXtsPWyFejU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mNxLf5yT; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNxLf5yT"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45e9f4a3510so925961f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 19:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781318340; x=1781923140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XF2BPxT6RGXOvylZIStDuHxnCtiMXDzVdoPv3lbFrwE=;
        b=mNxLf5yTqYMs7RN7dVu66sIKvO60OzOTaD2us+UoP81YMfDAn9tYYkFZjePmdzZtS2
         Z6mS2RvgtUKTMlOpMM5yDewMR+vZ75WnYU/sBWlfvvAZZ4URQVFk6hhzmtsk/EER/dHa
         /+ftHiCpw3xdRkCPNRrYXCCsjkks4TBBp5pnHYOXJ8nvJ5xhAfKheszMY0evZ8184xdu
         r0yN6aonfX8HvHulGpvu8i9L+5gDP/50qVM8WgAs4/5pM7EZ6wTWE2po9eXrMD+/jOH4
         YVJW4V5RCCJ7hA3HcUDJbkR9+tS7yusyFI3YYPba68to57c2G0TRuvC3UagRgmihFsMx
         +Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781318340; x=1781923140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XF2BPxT6RGXOvylZIStDuHxnCtiMXDzVdoPv3lbFrwE=;
        b=CE5T/TiOJwXLr0P9zKqBo1dnmQXwaLk5O2ryxBN02md8A7ejWM7diI3qHswvVKYX8w
         87CHeFLZQVg1+AQRMJLf6TZmgo+DzaGm+FzpX/ScG1H2mk0NRRnxk95G8UrzXRRs9Dxs
         LroHmPatJ2TJzuKW8O5MsZd+nRQKwQV119yojh3y0eAPHLVNMt2bVoSflgL/2I9YyfrU
         0o4+RWTeiwloi6eHs6f5OsdcNNes/8xjZYla7rQhgijjxGIbQHHDyksucPq6gDjeC4u8
         c7euewWU7UNNQyNUkN6PZjza2tx7QrAjsNl35G4w9KXPxf53Xx2N5SCnnnQz+LVyjiGb
         ttSg==
X-Forwarded-Encrypted: i=1; AFNElJ+Y/5Z0Sn2WupXyMl6nwzUesBFd2aNKn5WN2WyY3Nyc27IP95Rg1jK4flDb0A/J4nxrVlGKnPH9+89U@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAsDYEg1om7iXKyndayqnyK8/ez9uXNH86TLEGvK4hGoR02MB
	V4g+0ELC0RA1occSK6TPUzPPevhbZuvNeGmY5tM+Q2dtiF8gI4qYNTHM
X-Gm-Gg: Acq92OEPDxPXGTCyhSiw/eB5wi44fQ9TOrWfXgy2z99LmBbx4L++co70WDQI48wVab+
	yqRlluwMUYz22QsHnrcHDv1fmfqHeVEJ52RCWt4S+0ka/lFkHUbLkYT0H4cXCbbg3fCaHuo7wK6
	Jg+P8/zYlGuV3McePd+Tlhv745uZ4NM6pJkIb7C9AODSkZIClNGRgH53gYz+AoXMlwGb7enKVKJ
	zYOc/8Mlpul993BOSEMv+oUvnv/hNITiV64n+FWVgfDN0pWtxAhDSCR9vUjfXCAY/Kh1/EKdNSB
	gldN4UjRsK3du/iNnO9U+CtvCJdXdvC3zRJPUPDUAZbKZf5ywcQR6UAmShpKPIDaR4RemLnd06W
	mhqX1LRy9kk9a9y5x5WePiLrQN0t1J/2yEd3FAcT5Vi2vAqPA/LFtaF3t0Lz+2J2Ow4oOZHuPvS
	lxR/3sZag=
X-Received: by 2002:a5d:5d13:0:b0:460:e2e:6e2b with SMTP id ffacd0b85a97d-46074a8a1b7mr2065810f8f.20.1781318339849;
        Fri, 12 Jun 2026 19:38:59 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm11468595f8f.28.2026.06.12.19.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 19:38:59 -0700 (PDT)
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
Subject: [PATCH v4 1/2] scsi: mpt3sas: add IO Unit Page 7 config accessor
Date: Sat, 13 Jun 2026 04:38:32 +0200
Message-ID: <20260613023833.3163507-2-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613023833.3163507-1-sautier.louis@gmail.com>
References: <20260613023833.3163507-1-sautier.louis@gmail.com>
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

