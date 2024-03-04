Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0C87EF0F
	for <linux-scsi@vger.kernel.org>; Mon,  4 Mar 2024 22:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590121; cv=none; b=lChXoxc3UKSPtpFocagDOjDp5jGkTXRzJ8H51uZnQulduiNMT/mjvf+xQ0GoRwFdnWnnzrsino2txvDu62+4d/h37q8uS0jhFPCiKFRro6C1jooOt21M5T09TY8NW5YZ/09FrJcqY1omnbIUd9x7mL9E3kT/UmUC2r8A9ooZ3FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590121; c=relaxed/simple;
	bh=k2RsKVsqn0SP6W3+GcW/+9UaRpSxki2AedJQ+0T1tis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bvSXNh+xmNSOpVtbbJOaO17c8SOJ0V7hlLezI/Bh15Dr3BA8ieTyLScBG+EIao/B/VhP/mxA8Zgn4vx7EKhsM4BgHLqmAtLv0LBEgrfcGiQyGPn4C2O7PpnKrmdlD+2TWnGEh6oWt4HRVqRsxtYuW8ifN4fn29Jw0BHO9RAD69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rcYLe3e; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rcYLe3e"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269686aso7380606276.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 14:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709590119; x=1710194919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BOHqZcuLWtFyhT4gaG3Cu9uWAk1ebaqFWaPcojfGUM=;
        b=4rcYLe3eKUErXai23zunRAGizqBe2Zj1IhUCSk00l+gyZc6OtX7u0H78rboYT/DtD/
         vINoZT6ZkkkY2xJRReZAbBHXWymHFSRSc5+ZYtMpjD2/OV8+QIGqblDoy65c9ibp8Q6Z
         7FlS2bDBRxmCvxKQ5EzPcLkhZQQYK7zoxnTqfW7Nc14xN2hDPaYalkkEYX6+bfyYcdae
         KOlHMZhI4poYEikDdJ0zg4ZPT/kIcpsrdmvHHUkSU6QwZS35sQZZuT1TOxlMeId3HWni
         9iitkZd4xSIx5dHNVihsPKCrTrtZ6EhxZGQZ0cICF+bZ7Gs3nT5K25jo6AQPanN56T+F
         fmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590119; x=1710194919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BOHqZcuLWtFyhT4gaG3Cu9uWAk1ebaqFWaPcojfGUM=;
        b=vmIkmP2xhHpCSMw0bmF78qA9Kg0i91Xo9DOKhLaFIyiaIRBmk8md/SJqjRkKAT8fuq
         bYcNL/BcEfXz2T4iT0UVHVdQXD68zlW0U31XE0B09L+Vn4MlUwyPYBXrSaf4VKcmdr7o
         1Hmft6tpNMoCurdp0Gva3yfyVd+0+knMhd/sTdQEroilSfLnN/86l7U0yIU99KKdgm/a
         HHOiT9s84cyzpQU0dH2dn8UfB19f38FlBg78KVRqQu/tZ9ZTts9+/imyDrKs1fttNYvS
         pWsa2e/460GI2cUPMUkVoRxdWl12rtG1q9j9cDCahZGr6rkFKwgPZtKif8chxQzUGXzA
         6JfA==
X-Forwarded-Encrypted: i=1; AJvYcCXfA8yo2+FYrvMkL8iSuv2acE0tL4SAVjb+uA0PqAiQn9buNwyjOmQ8tWl+ATTGFmSXym8y9qKa6j8ENrSGVJGEDHFqs310nA4/+g==
X-Gm-Message-State: AOJu0YyafS9Joci0RpNmVisacYkNozKYiRmIKKbYrxe2xjFZ9Bm8NYi5
	5PelYLSFr6aTVUQ9i+DkG8PBJxh5A90rgLpTdUc3AEm6aMruH8mlGQjnJibNxZmT2BeJ2mSX/+S
	pG9zuxF0AXQ==
X-Google-Smtp-Source: AGHT+IFKnkpuBehKxAI5KNP9ibb1U2ESkcGB5dQvh7Jo0lfObivCLCwOiAc4Lh6eu52G+uxOMieIcl2LF17sIA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a25:dc4c:0:b0:dc6:d1d7:d03e with SMTP id
 y73-20020a25dc4c000000b00dc6d1d7d03emr444115ybe.8.1709590118871; Mon, 04 Mar
 2024 14:08:38 -0800 (PST)
Date: Mon,  4 Mar 2024 14:08:15 -0800
In-Reply-To: <20240304220815.1766285-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240304220815.1766285-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240304220815.1766285-8-ipylypiv@google.com>
Subject: [PATCH v4 7/7] scsi: isci: Add libsas SATA sysfs attributes group
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

