Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69197DDA7
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599875; cv=none; b=iXsSRycnAtcyVng8jPMSBTQ00AMvZQCsQNl/QSFxbRVZ7oS3ykBlaHRIKu30KEO/7ILNW6ppVkk0WimHICyse+Cw9hHMD06zsRZ4V6ZJtCPTKA7L5UbSmoWSSPOpipKPZPxYYvCunxFQQws36k5//nKqw4WXGgqd/1AUyCJdqYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599875; c=relaxed/simple;
	bh=x2hilrY6KpOzbV02gq6hK1kGpEZfvE2peqVvFcuy54o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QKrTOLHdVzuSPC/32zaXlwGtFjb+jWn4LMmns0ORbf1NIiiSO5p+TpPdG9NAN1sVqQBZBZYSKsx66uLVKw9BxtcAuszumKmWCt3paS8Z2ElfPiLWZedE+ZVJyWvVDe7u0Ddc7SAiathWExNn23BrTuA3dbdy1NtdWeU9kndX4RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lpnhucVh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lpnhucVh"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso8701292276.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 16:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709599873; x=1710204673; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lC7LnbzAeSHiH+Q2OB99L1Wy9pJ7fHavEqwaSfllwSM=;
        b=lpnhucVh3uqp+iAk90K17N6Xzme5PLZQYEG5LVyx5icpMABjqQFj3oJXv6kTd3O4h3
         CfnGU/uWrbK/jwnuG3XvzXV2N/1rykgMXHJ3afE0BMnI3rA5n2+pXxW24ON4m8LtoZ3M
         bgyNOXpVIQbrkvy2HcEn8HLJOmK8J8ki3VAuOTUgbPfgz9klw0HQyrAzilzMUiABu9wD
         W4Ad1T2cYpkBXeqUoCQ+zCVMGJCUGA+mLHT/Kj3XNy+srgWJe1Zqg7u79wZdhV7JEJcU
         m4RmIdeeUUlSqjI5ZslZtXulkTKMnmb0uehL6DiryEeBQu/D1Igb7XWzTIip58jMGOdz
         vlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709599873; x=1710204673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lC7LnbzAeSHiH+Q2OB99L1Wy9pJ7fHavEqwaSfllwSM=;
        b=dV675e91Zfwboj7GCtDlpNrh/DNdIM5qWihwtoBvCrr84+KkgnHO3JsCp4M1lkV3dI
         LLFUUw1S/GYcl/QQ5BkbaBC3+5mgDcXj3H1Ko0S/w3Y0kTHZqTkZWFD2t1m+66T8GQ/j
         g52yvGcFZ36xYw6DTykqQbdOOsDrBYeGGJZG33flgzDjkt+0n2xL7CxJ1ey/4o/fIZfI
         KI/SbKowCUDiElLjZWL/v1dnkheGe22up/PdILZFdE+QCci6AJ3DqMvveS/TJntNwq+r
         NY4YZS2+EpF1jhadRqCKJga+EtWJQMg4/paO3WW7aqvYruIEkzXrQU4eURA6CXiFlC54
         UZ/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1eoVimgMXt3lUi/vwf424D2rYagKh6zTuD8Vztm44RpHebCCSzRFPincivpuVbWXlHupLcbRVODWZVC9eMZwT0fOLWw66rvEaTA==
X-Gm-Message-State: AOJu0YynDeFyxkv3KPj51imt8RLPDHSd++7OFGN6hQqocsIsDuv11ApH
	CdaWJN63zF5OXJx3VEtZZDGHj7x8odspZw4HkIVyTEctwN7hGsl8VUjhDwhgEHSza6t8E/1msag
	8pGkZe9F2sg==
X-Google-Smtp-Source: AGHT+IHkvvrou4Sz7eyD4ve2xHQ0fzUP9Va/aVVoMDauBZqMVhzlZCI+ssSFGnQhQ9fD64bXbprrz0Tv/s/FQw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a25:e095:0:b0:dc6:4bf5:5a74 with SMTP id
 x143-20020a25e095000000b00dc64bf55a74mr406631ybg.11.1709599873516; Mon, 04
 Mar 2024 16:51:13 -0800 (PST)
Date: Mon,  4 Mar 2024 16:50:59 -0800
In-Reply-To: <20240305005103.1849325-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305005103.1849325-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305005103.1849325-4-ipylypiv@google.com>
Subject: [PATCH v5 3/7] scsi: pm80xx: Add libsas SATA sysfs attributes group
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

