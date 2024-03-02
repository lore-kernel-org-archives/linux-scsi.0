Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB014653C
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 20:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709410628; cv=none; b=r/D9AWqlc/+99PbZ1GZ5i5moNE+1eWbm7KQ3okJGWmc/XQFrETTVoiqH2GCtZoKr32kxzDTwsnhONanfDgoPoW3TAZZwBrY5ehDlp3+yFeXOKdKqplFc41l+p1u6gxr5CBZtsT0+8IvxSudZ0eIt5CyGJD4gDQp5TgcG6usqPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709410628; c=relaxed/simple;
	bh=VXEBiw5sEFSk6TqQvuSqUb+O1z3+B7dY5aKYWK0IdpQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aNcSsbltSnZR5JGpba7wUun50mTDrg4OSdAIS755MvAvm1nght0FpSz1nnqia2R15ZcpGbDBTl3w0TOHAQYq93FgHLOHiIXR9BtN79MSxcv9cPchv2hLcdUXfc9XG+rYj6qU0C0uIeQ96E9UDsw9yYkrFMNfmwRCArrjVZPaoLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bUgNbILR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUgNbILR"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b2682870so5327103276.0
        for <linux-scsi@vger.kernel.org>; Sat, 02 Mar 2024 12:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709410624; x=1710015424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k7XkqJ/HwZdUVuck7Rfqg1Ng2sUDChUOthoiaoWu1uo=;
        b=bUgNbILRtQA2lzC7fCLAvsTAkdCPQqxX2v33EtkT6rsLnANLFRqRLFtP6wdQfUMLxh
         QF+w3SLDTWRf9e3XLv8YXkO2LC9y4hvz8t4gD24nSjPJVfmb0RUfgx2/drB/sv1G8KQO
         YTifr8d6zF9p1V/JCz9mhkIKT0zv6fUcVJ4RlO1M18hcjkN1NSORm11TjbHiMOw7GBfD
         yFydrD9mqNZVtdoPF605COEwkCERLtdNahduD7f4e3HJ9jVOpfjNUMPnx3S/cueDnBWd
         mnAxxfdXt1KfzOefIYGGe2ccRW852KrGpZ0VrVRcJzKEUyEEkGlBrEICO8H6DJsTnWXF
         9vPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709410624; x=1710015424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7XkqJ/HwZdUVuck7Rfqg1Ng2sUDChUOthoiaoWu1uo=;
        b=c1Qc27DzyxnqBFDZIvSDDae35a0Bj2JabI3yXnbwt5VY1i/1Y1St7VedYWQn7UbJu5
         cI9IOqhl4mocKteZoGEbkTc/qV6s/II17xNoIAD0yS3rjIvhYHirlDx/EJ7Z7q9rYvuN
         f15gcXHS7m2dnBGw7J6uxy4r8ypAE2kMilnJyP1BenmTEj3IQFAziZeEVVYnevNHnXs2
         /9l9srq1KMWNDymQANw6DeRnuYexK1m3II/ia1fyphEHIVEDjNhKNnWyCTdsCmjPnkGc
         PfOzIIohoQjPq/VYXUJHZFp+Ui5I4gB12H6vUlF04QgNf4u+kUJHG5AyOrp2Y3LmblAE
         EsjA==
X-Forwarded-Encrypted: i=1; AJvYcCUVxLiW+o84GrlgZT034MnV7x0b1Moa6CbcspDLH2lA4r8JX4Y/vXZV9ROTnJlY+ceERXxpvftXRefWgWgY2s5NGM1buVdRdp4qHA==
X-Gm-Message-State: AOJu0Yy8/e47ftFuyFiXQA46Wk9euwySwdIMZQixwY51p+BgFz1KMJnE
	r0A1zu6DADR7E7r1qHadYn4k87rej2wPcsIlxOA0TJmJWClrp2V6tk0Zt4DqpsGB2bwhSflrP5u
	Ij36ccbQLRQ==
X-Google-Smtp-Source: AGHT+IHX7OqSiXa63cn18dhN1pGhetViOJvO9X4ApnlXCMHETuDUNk3S4i+DaSUV4jKQ2huJ1mYI9OWXvify5A==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:41a7:9019:9a7:b404])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1741:b0:dc7:5c0d:f177 with SMTP
 id bz1-20020a056902174100b00dc75c0df177mr1258736ybb.6.1709410624534; Sat, 02
 Mar 2024 12:17:04 -0800 (PST)
Date: Sat,  2 Mar 2024 12:16:36 -0800
In-Reply-To: <20240302201636.1228331-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240302201636.1228331-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302201636.1228331-8-ipylypiv@google.com>
Subject: [PATCH v3 7/7] scsi: isci: Add libsas SATA sysfs attributes group
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

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/isci/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 6277162a028b..8658dcd61b87 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -149,6 +149,11 @@ static struct attribute *isci_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(isci_host);
 
+static const struct attribute_group *isci_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static const struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -176,6 +181,7 @@ static const struct scsi_host_template isci_sht = {
 	.compat_ioctl			= sas_ioctl,
 #endif
 	.shost_groups			= isci_host_groups,
+	.sdev_groups			= isci_sdev_groups,
 	.track_queue_depth		= 1,
 };
 
-- 
2.44.0.278.ge034bb2e1d-goog

