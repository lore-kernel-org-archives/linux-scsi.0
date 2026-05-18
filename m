Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17CD382F28
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779129688; cv=none; b=A6uCrL9MqaljM0W3YIAhmHp6Cy3qhB3W5niMKeQpKUNc/FN+mUNzYGLuqbsf4mj65l6EIjWgQS9P5bEVVV0zKpYHqc7nK+KChgV6xp+jbSnTy73+sHWPifiuY26NuGC6LBZGJ3JiXl4DRFNDeEl5CORPf/8Q1B8fP0gMFq5fNg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779129688; c=relaxed/simple;
	bh=Bt3my+6l00h9cgScvXgngonjEUgxY/cU8mMorKuK7Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVfVTzABrN31YWl/kPid/ih2IAENUr8yHD6pDtDdN+FrVvzwbu/hwy+m/EjY20+nlUVmKmS4XzN/ZAsGHxm2tdmxs3UZEcf7HOdQSip0qCZSvCDpxg5ZlIGdJBh7XdJ/QNVi3akOmH9pZR62kuCYha5bZWyKWbR1JIq2Tji8pbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m3ahKnax; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3ahKnax"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso30369525e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779129684; x=1779734484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8+wQM4a4tsMzXZ7biCKDr40TVU55tRrbtX6KIaXn24=;
        b=m3ahKnaxaW1Ou8SvREKiHiQ4UNGReS5iZBkWTeovQ66QE9Poyyx3zYwc2C4XrG7k86
         U8/i6uOdicL96UWoDgGr+ReQxxvRMPYW+5KkclmSqWsaS1IeoOYbeBJXW8kfo6LeG1WM
         hhzI3pnGs8L67zdyxveQDp4Vj+WogXAhWAO00tOyRm7q9y9LTov1DRHOwtPUNwwb4Gwe
         BEkPKygmL4S2WzB9XMbb50NvKEJ1Ygvy9tWru6xL65w44vI9QpJOsxL/nMdFArzHrH32
         OFYyacVT8WYzQ5v5bjvb1km+1+1NWBNDXpE4bLIjbUmkCOTkZxmE4EqPBkbYJTaAkTsE
         mjug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779129684; x=1779734484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f8+wQM4a4tsMzXZ7biCKDr40TVU55tRrbtX6KIaXn24=;
        b=C7fydWEzPhV8VjjBfgCmLvKF84TjmvfmvSwL7IdJjdZmH1WdqT2mSO8AEUGBjRo0IX
         UZG78Oyuz2yn6Xy3nFTezjSC1IbCbaZo1EXRhe76fz1c1hQDAJ1Ip9sCvsZabUAb4Q0r
         S5QZEITkF/+EN+H4Tc9STvWXRVBzwbJuQ+YxR5N9HMz0G2q6H+uuf/5lNqlaNe6Ult0M
         b7cRgU1irc9n0s3o4rNW0ARBDQkOHIOvo3I8Kodm+vD5WBBJe9vF7LJmWUzeygRa04rV
         7y3ovlF8kKxKkuw6zxYQlBcjveN6G2VBqfN//TdnPsR8Veli5oAOHOmek0pxenYIWmSx
         hNSw==
X-Forwarded-Encrypted: i=1; AFNElJ802dVYeD4R5wYDQyeb48Mc60T+faOo15/BlB4KNmhwuEhIe27aDdIrFvG2S6WyYyiHo5cOaSRHQyq1@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl3LEP3n5zzaQDerc+6mK6rxkMeVmxw28r0FFiNG1+aLqHorNt
	zhtlO2qkOKsnlpfCPhUD07fKbIIQ2W9p4BQVYa0VqSFIflARuthWO+hH
X-Gm-Gg: Acq92OHt1DvpEOvJ8Pmkv3eJj0jQPLAmmWtLphVP3eO4Kmmq1Q0/q/hQzbLIiN3h+f2
	P3HOARbxoS8UPlb3AM53JIdnD5Oj9HVYHMx6+t6way4c5g9xj7qbyVPuLwnuYpzIAZAcKoMpJfu
	bb7Uj+R6O0f6IVsApmCPylxvobj0WlAbGyPXxjYSBtyquLoZ2ZwLhq/bS8zDnseYlpNJzmy+aJZ
	6PGLIuphT+Hamx8EG0Fs9x8qly8D0Tju/BrfTKscKotMPicpYN152bzpv5OyEvTKwdMhahGbCCP
	UN7zaStyWncC/CaJIg4mdq6zuOzhr8IdG8mDpzRqVsBFGhDYlfAtVJ4yq1KVcGxTwcrQLKYdH7O
	uloYhDwkkKj/nz1lM0em73ZxdRBLtXeRNOJiS6c8KugIzy01drQsMHuwPfHQkn2c6G1CnV3upNv
	w4hF+5m1s=
X-Received: by 2002:adf:f784:0:b0:45e:7997:8b82 with SMTP id ffacd0b85a97d-45e79978bfbmr9017983f8f.16.1779129684055;
        Mon, 18 May 2026 11:41:24 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768c4fsm39305594f8f.8.2026.05.18.11.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 11:41:23 -0700 (PDT)
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
Subject: [PATCH v2 1/2] scsi: mpt3sas: add IO Unit Page 7 config accessor
Date: Mon, 18 May 2026 20:41:08 +0200
Message-ID: <20260518184109.770185-2-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260518184109.770185-1-sautier.louis@gmail.com>
References: <20260518184109.770185-1-sautier.louis@gmail.com>
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

