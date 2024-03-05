Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEA2134CD3
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683124; cv=none; b=nHwk5a3X08WNxa69bhsdnEG2qKAG1YdAI/auyB02mp0xKiT+2BveevR3ATGC3Np97kgg7zKWQ4i52M0AhoJw/vlRVZskheN32Yvl+KzGMtrSH5jWVc5HSIycm5mZaYr3t/M11+MEKMNy7y1T0TYa0tL1C07zGHBlXjGbcDlvNC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683124; c=relaxed/simple;
	bh=G9sVD8mPANACI8XvBa42u5K2t+gtYc3kf7MUNETx/FI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A0Xaw3Hz5oPC5SD/BxfEbSafmUAl+M4ZqKS6HrbKO+7i7OjjC25hyU04Pb17JzgGs0zD2BrCCcFPDS6eOU+Laj42P9PM9OKznRY2Vn3AJV9R9xf7yuA5Ahb+Nl+uAIzb+efL8+N0hLDc0IK7EV4Kw/LnRBNchSuv1p0fcALojOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=obb3hSn9; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="obb3hSn9"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047fed0132so95639267b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683122; x=1710287922; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQNseeqHGtqWgtmESvK7C+bOjnnAotGHLghFADtiiV8=;
        b=obb3hSn9jvFIgJFV1G9xQmFb1V+ziNTojM59NIGGUk1cQSUwePPY/dx6w7R0FgHKg7
         pFZt4/iggdytxHt560AMymqfzpUCG8TnyB5rE0illMmA6Pz2orJQL5Jj30w2urKyiJ6o
         GEiiS2OiAo6fbRlW01D2E77hplwRiABs1H0JjZ7Rr+vAlz4epZ2VYoQJ5Vs6LR5wjgUo
         p00xCOmkdvSTKbmfb9mzvvdKILenz9chanMjtCqChTPewCukNWkQpVOMT+ELYPA5n9w5
         DWKSgfB4OokSyqa1sJegGLoC+wxQPYTcg+dzecGvOh/1iejLQJOt1EHXmnNRAIALaBpq
         C/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683122; x=1710287922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQNseeqHGtqWgtmESvK7C+bOjnnAotGHLghFADtiiV8=;
        b=f8a1hzR2s+ZV8oMHXEldduhXpx1lvu9v3s2cPajxLFwYJb6u3iYTengCCKzLWZtkI8
         0faXQKy26I8Hcyj8U8Q0HDqbct6sZ35KUEX1G+O3z0EGSRwJu10SecYQ21RFpf1G/RUd
         Uzy8YHPyzb3zsNbAZnOQJ5hIYA9nDbvT7SzLLmIm3S6LI6xz9cWTYrta6Zlljbl077Qq
         mYLH0XSstHTJkHaVDVvLZVa8YEE34PoIw8SFkScZXjczkbdTOTOuO2lfbwfpptCxH5ma
         SiKEu3haxMGiTjzt/fXK90mjZfasJz3ubDr8/iA0lZ++fECWdIGEQfg6RQbAYc/qMdtL
         t7tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYiVVQb2xlxKKBbwCwHNWvvg+1LiOmgwgcfkksw0LTWK7crbk/p9rmQOc/gihbI+YZw3Y2X/OwPWZHVobpEFqOF6sRNn42b+AHpw==
X-Gm-Message-State: AOJu0YwpOINF3R5qIC+tZmPRs3fg2qonveDUQ8xtM4KKSdIxnYXCjt98
	f7q+rYLsx2h+U4A1yZ51Cn1czpHbpkE7rljgaTjMiq894ZOwKqzwfPO/YZwKTdYeuJ/o9VSOWY3
	X2Y+/KlhucQ==
X-Google-Smtp-Source: AGHT+IHaquBcMiTxzYXCHsL6kDeJ0KhsQhgDryCyWCWhVsJvol4BTI3/dpyBoM2x0YMxdYD9SKzVxCeFdg6qVw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a25:dc4c:0:b0:dc6:d1d7:d03e with SMTP id
 y73-20020a25dc4c000000b00dc6d1d7d03emr586973ybe.8.1709683122054; Tue, 05 Mar
 2024 15:58:42 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:21 -0800
In-Reply-To: <20240305235823.3308225-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305235823.3308225-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-7-ipylypiv@google.com>
Subject: [PATCH v6 6/7] scsi: aic94xx: Add libsas SATA sysfs attributes group
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 8a3340d8d7ad..ccccd0eb6275 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -14,6 +14,7 @@
 #include <linux/firmware.h>
 #include <linux/slab.h>
 
+#include <scsi/sas_ata.h>
 #include <scsi/scsi_host.h>
 
 #include "aic94xx.h"
@@ -34,6 +35,7 @@ MODULE_PARM_DESC(use_msi, "\n"
 static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
+static const struct attribute_group *asd_sdev_groups[];
 
 static const struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
@@ -60,6 +62,7 @@ static const struct scsi_host_template aic94xx_sht = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.track_queue_depth	= 1,
+	.sdev_groups		= asd_sdev_groups,
 };
 
 static int asd_map_memio(struct asd_ha_struct *asd_ha)
@@ -951,6 +954,11 @@ static void asd_remove_driver_attrs(struct device_driver *driver)
 	driver_remove_file(driver, &driver_attr_version);
 }
 
+static const struct attribute_group *asd_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_dev_found		= asd_dev_found,
 	.lldd_dev_gone		= asd_dev_gone,
-- 
2.44.0.278.ge034bb2e1d-goog

