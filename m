Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C75512FF78
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683118; cv=none; b=N278F1RaIkvhOuPvqyJqFYlyXAtEk4i38P/XtrAVVGh5lEvWqdIKNXakR+cYO9GiAFir8nbKQ+u529WvWK5hJ1c/+9y0xOMSkYeYKS9LIluQfmC4TeciyLAJxftQRcZuICMs+WlmkLBQPZEcc9emLP6eqGurbziqgYfPrqhbeiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683118; c=relaxed/simple;
	bh=eNWF6foC4RAjM/7mIBIDm6Ws+q1aoKRiMrqNZ34dkrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UVEBA1DsAGJq843e1sAkkpf0qy+yEdi4Cz+nS3oVtSdpqnyxI46ZVMP8DcBA+SkApCAujc5baOVmrU3TbfwbSMzS9QRYSkNB9QOc71ad70eo6gJ1CiGEIdFvgU9gWCEANybs74lG8TCbIB9SBteIGd3UPlD/SKDjvwmO4JSz6Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IqN1Tz+T; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IqN1Tz+T"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6099e707622so23292347b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683115; x=1710287915; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=djrkg2o6GYfOpuFfrfroOSUyfmqyZMD72kLam/QnMds=;
        b=IqN1Tz+Th0zlG2zBpaT3KhC4plYBPUY2bUj/kHTI+J7lHDzIrAm8zX7l0cppi2D2Nr
         OSB0Ehf2daZHEVGdc8xvJea/tzHQD79/zXYzP3SN8494Y2bbO4G9ndTGTFjgfBY9QwUw
         Tq132MDnkd8L//LwKFc2SIq1+vVeOOkquiLebv5naBoeo8kKQQmzy+hVOaYCW+/xLsQc
         B/QnC1s6YluANwwWSoh7vjQJtqZJNjAv/5SioL4dEZztDTOcDCw7l2oxinEH5ND4Iqqe
         PAXmBgoRtLWtQhO4dvZiIdBT0ZZLPxkT0sJ9GRZL+FXfKNJcf2JivPG4BuV5dVQoy740
         JeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683115; x=1710287915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djrkg2o6GYfOpuFfrfroOSUyfmqyZMD72kLam/QnMds=;
        b=S1H3vazTGmeCLKsUONzV1QFPNyCnqqC7xifn6a6aOp8yHpFLu8GsK3vt4aDvtJRykw
         qKzy6nuulGpYpdgbDvw6c+hq0UtUr8Vc9oYa2NtryhwXGtbjeE4RbBjWoJUytl+3iTCV
         9oY0FwVcoc7DByMwI4EsJ86/94x6OOporFbZGFeyH9iVNsZXV889qUwm/bFhqiWJsXrl
         mBF5oiAqMqJFGdZvryrPwHnCA0ZhtUXns+0nLuZ3GnkB37Lh3YiAyF54snd6HiAxhlwt
         f1quf2Hbh+adt87tirQoCYGWFuAP8WqFuCBEX30NDtBsV3xMX8XoJ+ti71yl/iJiG/NE
         N+BA==
X-Forwarded-Encrypted: i=1; AJvYcCX3va7omc5UAmk7uUjvZlaXS01veMAEANrLieSH53mzgU0+dNgcB//lwdtGEO2UrHyj9YyCBxJGhw/GCkJ2kMLtg4acqx2u402Ldg==
X-Gm-Message-State: AOJu0YzOAXi0bAQWxYVKoI3iiWeMnYTTeCNM14vC0uXq50nmVep8vtb6
	LBnAKPergPGnDlhF/9XIY2wL0ANQvTWH3iFWIfr2biHwL7iztpaKC1KykqFUM3DUOAi6Sp6blbp
	0leUxb8jMYg==
X-Google-Smtp-Source: AGHT+IEGRE78DRGidpai8zoLT+qXHBTo746+ICXMSaJINQRusZb3EuPG16i9dA++aY4fqmbiHtlbI26s1cfbWQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a81:7908:0:b0:609:2cab:1bd7 with SMTP id
 u8-20020a817908000000b006092cab1bd7mr3874602ywc.1.1709683115682; Tue, 05 Mar
 2024 15:58:35 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:18 -0800
In-Reply-To: <20240305235823.3308225-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305235823.3308225-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-4-ipylypiv@google.com>
Subject: [PATCH v6 3/7] scsi: pm80xx: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Jack Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 5 +++++
 drivers/scsi/pm8001/pm8001_init.c | 1 +
 drivers/scsi/pm8001/pm8001_sas.h  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 5c26a13ffbd2..9ffe1a868d0f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1039,3 +1039,8 @@ const struct attribute_group *pm8001_host_groups[] = {
 	&pm8001_host_attr_group,
 	NULL
 };
+
+const struct attribute_group *pm8001_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index ed6b7d954dda..e6b1108f6117 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -134,6 +134,7 @@ static const struct scsi_host_template pm8001_sht = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= pm8001_host_groups,
+	.sdev_groups		= pm8001_sdev_groups,
 	.track_queue_depth	= 1,
 	.cmd_per_lun		= 32,
 	.map_queues		= pm8001_map_queues,
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 3ccb7371902f..ced6721380a8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -717,6 +717,7 @@ int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
+extern const struct attribute_group *pm8001_sdev_groups[];
 
 #define PM8001_INVALID_TAG	((u32)-1)
 
-- 
2.44.0.278.ge034bb2e1d-goog

