Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC47D086
	for <linux-scsi@vger.kernel.org>; Mon,  4 Mar 2024 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590114; cv=none; b=XZMPOKoT/4FaeD9MEnKlovTZWbgX3s05Q87hYRFA8PyCN4r5s9Y0xvY6ghwFKXbBQyR3eC2eaRX4BZyu1RnVP7M6Xr8isibuARLrC5vhEONgLLzHwzerhZRjAy2VxqpQJdvr9VvXSzjMH7+GLDL28xXtIq07wqRZ2WJk/olf1vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590114; c=relaxed/simple;
	bh=7lui4HEwt3nyzuBq3kOGgxhbVfQ4kTvXlTnHRxF4y2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P88vwo5fZvUN6KG3PyIt+9XBpNXY9XbbbbM7V6vxA0Q/337rsCfrg8yHt/XpC67Pk2QOwk1w5TK8f8GG2lnL0YM16CTZUfSRpGLyC5e/vEMcV0dAhJ7MlnJCKTdEHHttWQT0N/bxzi7jKjs0n6B8t+WStaixbzDeBJkyfzWXUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OyE/bcIB; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OyE/bcIB"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dd001f821caso6144763276.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 14:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709590112; x=1710194912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fllhBTjW6GX9iEnv/LwNN/tFNgKMHmXcnmtxo/1RJIg=;
        b=OyE/bcIBE9zeJ/Bm0iuOrgXR/lfkIGCqbljW+669V6DIikYmROin9LG7goN/I+b1s2
         PBjjWjYK0kMp3ezTV6VPVPoh/rrzORxIMi8F9vCxLKOnfRM7Tien7sU/ywiYMZP+3V96
         j44FvMTXl0ojTaG9VeepmRf0cjjQneTS7A4Jpby24hqq7pY5pcY/j6zCq8NJWg16Cxn6
         B6ztXIcXrUXmWRJwBAoAguW4D0thCdddkP3KrxPHD5O1VrJ5Gc676hae7ohrCYftAb5k
         e+8Znkp0lO01iIzbFvsmjoxJAeZ9onKBgWMhuwBBq+E5/Zr4QW2w97OjpZ+xjdtFiyl8
         WP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590112; x=1710194912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fllhBTjW6GX9iEnv/LwNN/tFNgKMHmXcnmtxo/1RJIg=;
        b=TUTycutJFONJNaCrPDZwDonnCsfHZAjpgwODmc7sW7hzwxO1sf9lSSOaYemoC6QaRu
         nNOvXT55X1PwQ/MjI3u61Hgh+dljiVJmfi5PW9Y7Mj8hsj6OYFzO5uaMzYVa4jiel+Mu
         DJkDfjq0GEVqSVUft0V8hUI8EZ3+X4wqq+mBfZ1r28D2+7zxeSkkn35X0rNLn3n9Y4us
         5ErJyWXy9qinQ2LjCX2PsUx1lcVRdPptTZzss5UoHTO+TAi3bs8KuxOTHXHOU1kQyA7k
         d54/24EPybFgE3JMd1NqbSCNR2h91zeW5sqRNpR5lQ4qrZWYz41Nz/z05K6NYv8EE0zR
         oZGg==
X-Forwarded-Encrypted: i=1; AJvYcCVcyaOp1g2SXlOXMGX+m2eDo/LD9ZQF4K91Ad0eDJFn574Ga/ECxppWkK761FAklaylR0L9rSEGK0LIaCtcBriDtd6RmaAYpSjC1Q==
X-Gm-Message-State: AOJu0YwQIk1PqXEC2joKub0E0ZdWsTHykd7h0LWUt6dGbt2p45NAe1HX
	dEtWhJ67vhY60Ba5plu6WFBXykidLdxb1qu+Yq71pMoW/MMxyTeQCcsfPzHohdFvgpASIX72pKd
	HsB/OcV5u3w==
X-Google-Smtp-Source: AGHT+IHptqL+KH146p/jJHXv8G+GG/vYikPUWRaYAjtq0JMV4p7qsJi+Ner0U+3RmjBfP4O7X2Cx+gNL7fNivw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a25:8a87:0:b0:dc7:463a:46d2 with SMTP id
 h7-20020a258a87000000b00dc7463a46d2mr158322ybl.0.1709590112026; Mon, 04 Mar
 2024 14:08:32 -0800 (PST)
Date: Mon,  4 Mar 2024 14:08:12 -0800
In-Reply-To: <20240304220815.1766285-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240304220815.1766285-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240304220815.1766285-5-ipylypiv@google.com>
Subject: [PATCH v4 4/7] scsi: mvsas: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/mvsas/mv_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 43ebb331e216..f1090bb5f2c9 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -26,6 +26,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 };
 
 static const struct attribute_group *mvst_host_groups[];
+static const struct attribute_group *mvst_sdev_groups[];
 
 #define SOC_SAS_NUM 2
 
@@ -53,6 +54,7 @@ static const struct scsi_host_template mvs_sht = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= mvst_host_groups,
+	.sdev_groups		= mvst_sdev_groups,
 	.track_queue_depth	= 1,
 };
 
@@ -779,6 +781,11 @@ static struct attribute *mvst_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(mvst_host);
 
+static const struct attribute_group *mvst_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 module_init(mvs_init);
 module_exit(mvs_exit);
 
-- 
2.44.0.278.ge034bb2e1d-goog

