Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A627AFBF7
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599878; cv=none; b=UJZmzloiqTZfFwANeTfXAySo95jnIZ929W9pdzzxABYFUGnrpnyKlFwJMILbeuWejYjaurnAFyrNDffisH3uOI0XVssLzQsuUBV292lIaHBC24yidBx+d7eGXxIp5bP0MCCp09A20TL6ymLcpqy02+CrdQDfJV8fPWISrLUki2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599878; c=relaxed/simple;
	bh=aLtlNr+1l6B3hxzUR9P9kYxIKT0n3xMBf3jWVQlgYvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eVgVjMfqLbNO863oRnm9mQVtvtMRireSC2hSTlMwS8m97z8TIhDBrZBdawfxQ1tcXPH+yQHKxAOIapvK7vZTVdKb5LibinjTXFLeEHyD8eLsvXQaRtfQrgW8KN2u8YN92X7Ob+SPKhCUovWlTOsqgE5lLYPLCZ8e844Y+/awIdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oxGUfsj+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oxGUfsj+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608ab197437so79596277b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 16:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709599876; x=1710204676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnc29GOaNlgSeW09Vh8SN3Fp8isMCFvcbYSFbDWlfBM=;
        b=oxGUfsj+QYXgE92OqVw+J7XKAvJJxIWlBczs0LmObEqvHI6GaHZDaO23wfXpIZ6gVh
         3w7hiAMtU2YEP5KVl/BmOS/Cf7AevdMlqD9estfdBJYOzlJu7PIDz+GP0VcxkVp6WWWf
         Bx0kNiisaeBo3bAFC6amsEvNfqu3T27E5ECbIPR9iDseoQmYhyg6UM84o7Vj9Mfk3PAb
         IAwXSWWe/LZ+YDeNOfI7viycluTff1IhK0UsBDq5eFAsM5GG2mMVik1z/+Z5W12nyLjX
         NSQMTQ236q36ld7Fb1s5lNQO9XxWkbb6DyK0kBxYCgnbumhT5eOEtKT1sQ+ExzSqte07
         fh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709599876; x=1710204676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnc29GOaNlgSeW09Vh8SN3Fp8isMCFvcbYSFbDWlfBM=;
        b=WfPBuvB2HsquTRn0iXMsNwxA4+H3NGyXyTmr1VrX2m2FONM1ZmNhzsltEBlD2dNYF+
         k/ThMifR5Ht5fjS3dkAwCsr2eeRC8BSfK4mQnsG86J7z3uHGuKWSLzqHM214apPix59T
         +zsZiV50u2Dlno+3qpi8AlXWv4h7tljX/CiUXPlEDgVsgNtEyn5j8p6onMPQxa5InhBZ
         LnND4v+QI2Plg3NLL7sLNyOl6H5nHED52yOOorqDb3SblYCL/kb2GCp92Bw6rxmVqm7m
         qo5KKIWYXodUZkLeqlNRksxZBPUqhWf6KvCv5k3nQ0a4y+68pZaY8imCu3j/6Endtk7A
         CpWA==
X-Forwarded-Encrypted: i=1; AJvYcCVXcJE7PKel+Y+PAo2lKZ6X8vOCbLZYznj/1fQ7uSGbGTf/GPzsf+xeoX1FCUk9LGgV36aDHSNjZCkjd0Cwk8waJ1A63alLGkKg9Q==
X-Gm-Message-State: AOJu0YyB/PTkL5svgrype+X7FvLTnmsI0AmD3qa62tQicvoaPNvGEsCP
	wWMvLKCDwChcrJxVP8Vffc7INq2DbBmyEWy/qLgQMu6UkQKbt2WEZ9Bv6sqpMbq7uZoye0/NnQz
	Pqm0hGJ6U3g==
X-Google-Smtp-Source: AGHT+IGZSbdF2pSwc+4EzWStbZeghU2//j/2zWX2HQSKUA0vm+Yo3YKGSF39AsfdaP2nXqgALpckPtLnyivnaA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a05:690c:fcd:b0:609:33af:cca8 with SMTP
 id dg13-20020a05690c0fcd00b0060933afcca8mr3011166ywb.2.1709599875824; Mon, 04
 Mar 2024 16:51:15 -0800 (PST)
Date: Mon,  4 Mar 2024 16:51:00 -0800
In-Reply-To: <20240305005103.1849325-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305005103.1849325-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305005103.1849325-5-ipylypiv@google.com>
Subject: [PATCH v5 4/7] scsi: mvsas: Add libsas SATA sysfs attributes group
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

