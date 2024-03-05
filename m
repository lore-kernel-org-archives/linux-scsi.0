Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B1D1095C
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599880; cv=none; b=Koano7Gh+YY+f84IRBL8N1SubOWeont7xOy8oJ9D2ODe1x1mqJjPry6eQ820ZA3SDak9wF/uymysqh8qlrtd1iRaEnUV5jCNX6RmNrSBVnJUczp+o8BNjS8s+k9octc9M0t3vglClrk2cbzdBrUXaavSS/CV80h7mTHuoPJEa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599880; c=relaxed/simple;
	bh=OT0sYnaxo68fwSHaMwnL2hKn2Ef03StrkDYOYiAnOZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PtXnLG6Nd+yxDCXvh2dIRlh1+TSguGob/5Y5i+CDf2FYrB+sZAU/2vFpr2PhUumVxXmLXQnuUvT9tKWWvywabdwt1ztLJwWwAuMi4zynTtJRgqGrwzC64iqj5jZjTFGnbRpH7UYwyvoCkeJMVizZzGzYroyBK7Yxbu4Ta7bqmLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vuUL+kKM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vuUL+kKM"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dce775fa8adso9028863276.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 16:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709599878; x=1710204678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N68FGvP0mTMlTYCB47N23MbfsmIOzAcUrBUD9J/J0rI=;
        b=vuUL+kKMTWCSKu8wgxMV6bhdGgD8wgo13IAS+PYUzIbITKmHOppd5JNW5kNThf+sdg
         C/TOVUyNKdlAk18BWqkAn3iqvEhDvl/Ci49nTLVRP2amLLxTs1qrTExflTQLLbF0t/g0
         Zh20E8MzIx5BBgpTxvmDvVnzIxESJuh8y0enycwR7CHc5737aMBrcQc5Bi5BlH2n2WY2
         GDzkTdCh/yaUTdPIr1mWnDixY/+WkhFakvhJlUByJY7Eq6LHJDCpewvR9xv1JvQC3Ve7
         lt4qLjdxkxbtrWD3Sy9y+ZGMLoz2bJw1yGg6rHldyxkzVjDsYi2u0/yzLK3jV2xgO+6j
         Au2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709599878; x=1710204678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N68FGvP0mTMlTYCB47N23MbfsmIOzAcUrBUD9J/J0rI=;
        b=wqLSyl8B0dehzIokpyGrD9FEfjylOzQIOFK5y0uFi6Jj9vN3lmqR0AVBTVh0/95/8c
         iMLw7h22Uf/TRAckHSsWXD2x3xGVIGGhtKVKBxXnxk5Ruh3JW4m+sEnFryh/KeHWFOhY
         Q3tOWcYwMNGiOuZaMSTkv2gIOk2k0DdWgbO7nFa1imTdWOhm2xWx+075z18chfwYmMbT
         cq6GFcGcO0Qj7n85WtR3eLTJqQpf29Bb885+dTFQAI1sgoEuqF/yATWBqFQhW1K0V3Vg
         pM7H/0P27Hgy2auqEJq6KpMugP+jPyHQzj4GSLsSmp+CAoFzRRnW4CdjW6qvHweL240X
         gatQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe4ly2X/xehTU814qq6kOCVK1tbkw3a1FfdQW2HtRHk75+wfEGig2ytSe+rZVozyHIc8kWJZuiRAF8FgfGMPF+TWzQRZVU7Hizkw==
X-Gm-Message-State: AOJu0YxO3tXpzuLOCWTRji9JsGKu7BzXFGCA1Puj8LJOXjSaAahNQSWf
	5f6FAG6M4GDJV63M6VhPHE+JV5m4cpviphOZ1j08gbCmBTjmUfsZpZDIGhBrLO2kaDSLVdBM2Wc
	aAq9bBifybQ==
X-Google-Smtp-Source: AGHT+IEifz6iQ1XIfSyfq986HxT9PrXO9y0tP1HA/K2Izo+X7mbBAMA6q5VgAVEkRE6I0se5mkm5O2wOX543Lg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1004:b0:dc2:3441:897f with SMTP
 id w4-20020a056902100400b00dc23441897fmr2682137ybt.6.1709599877900; Mon, 04
 Mar 2024 16:51:17 -0800 (PST)
Date: Mon,  4 Mar 2024 16:51:01 -0800
In-Reply-To: <20240305005103.1849325-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305005103.1849325-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305005103.1849325-6-ipylypiv@google.com>
Subject: [PATCH v5 5/7] scsi: hisi_sas: Add libsas SATA sysfs attributes group
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
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 73b378837da7..b5d379ebe05d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3544,6 +3544,11 @@ static struct attribute *host_v2_hw_attrs[] = {
 
 ATTRIBUTE_GROUPS(host_v2_hw);
 
+static const struct attribute_group *sdev_groups_v2_hw[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static void map_queues_v2_hw(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
@@ -3585,6 +3590,7 @@ static const struct scsi_host_template sht_v2_hw = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= host_v2_hw_groups,
+	.sdev_groups		= sdev_groups_v2_hw,
 	.host_reset		= hisi_sas_host_reset,
 	.map_queues		= map_queues_v2_hw,
 	.host_tagset		= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b56fbc61a15a..9b69ea16a1e6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2929,6 +2929,11 @@ static struct attribute *host_v3_hw_attrs[] = {
 
 ATTRIBUTE_GROUPS(host_v3_hw);
 
+static const struct attribute_group *sdev_groups_v3_hw[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 #define HISI_SAS_DEBUGFS_REG(x) {#x, x}
 
 struct hisi_sas_debugfs_reg_lu {
@@ -3340,6 +3345,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= host_v3_hw_groups,
+	.sdev_groups		= sdev_groups_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
 	.host_tagset		= 1,
-- 
2.44.0.278.ge034bb2e1d-goog

