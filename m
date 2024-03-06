Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCEB1759F
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709688161; cv=none; b=pTB4M3EDUO9Ois2Z7E0vq3a7cR7tmCciHGWY62DRwuX4/SifDosbPpJusVb2Cs7DCtV1EspVNnmp7O1JwJIWdYPJ1zAGj3uF2EFf91UhhuTEReQgOo0HEIiA1SoVt/+MgT4fgoNnrW4Dpl6WjSHgedxf/S3hMeQe/wONueJQxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709688161; c=relaxed/simple;
	bh=wcg4s+VBRSyuqCYnMen4yuigKnSiE8NtEjtig8qUC2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CoYwTGIpOWwD6E7Q35BlVFboPUjzqjbioLkcRPRsHxkHWNjQmKlQ5Nn9A6bRE4UPDuV3GdGEpddA/3v8fZSzclQKNxlNra8ex6gbNNvz4FJ1JQpoOumGQckyBonfLNW1nHsNkNLuudaG3Qk2/Xn+pqaEV54bGLy8+VF4OnWVUlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mroJrfGy; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mroJrfGy"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcf22e5b70bso10986146276.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 17:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709688158; x=1710292958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xvuQ4kezab1KlrTxoR3eIfXTgSjXQ9ZPEoqhGuVUIVQ=;
        b=mroJrfGyyEw0InFhfjPw6H4li267zjABJNkx4asSKDHCLlYGmazQQMdXZ42j4fnS+e
         +JOtE6KxovlBawr+yzBahaDx5mzghMSexEyPiJMR8LrzDK1tHuPwJPFnOeQYrhSW9HDW
         3hsqucdPShK+iNw+YxMgbd8+txfQ3BcxIRP4/jxBBIi//noGuUqgoqhBG1K5y05MXm96
         LPu32UoVScy08MR1c6arGd6thA78Fo1lPGi6Lq47Q4459P9Mx9/Yzr0ZISaCtq0GmN0h
         /OjtJFgBElSoLz1OkKVlGpyLfwkyytgk2+CTRn0qlFpoY44CKTzhgCzZUp3qbIRopK9O
         0jgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709688158; x=1710292958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvuQ4kezab1KlrTxoR3eIfXTgSjXQ9ZPEoqhGuVUIVQ=;
        b=VwslGh9CEebD6QpEOXWP8qObh7dy77pjFyhUrKQYnwuOpGtSx0pkS3axy7BKyWveS6
         cEeIIP+eRPj6Saq1Sgk5AQNcnGeLoofzlPwzDassHpmhlyh5oXS+PoBnnP+9DTWOzUmX
         1zJVfe3mWdK89i5AO7IiWDYXYKbGHyJfXu3YI3Fhi9LSCD9ilzadcZz1jwoYvUarj9sB
         B/plHhUzUeENfzJSjrEg6rkC7i/7VJFlEjFTX8X9+wfNoPA3Dl5lcOl7qnSiwA/Yx4Tx
         Ues0DJsjGrxJaix7SLmnTqRpGQDH+iD8laWMK24lfWJ5PGT8U+8cW5iemE3+G9a9EZCZ
         OTjw==
X-Forwarded-Encrypted: i=1; AJvYcCXwruqd48FMAw1ackgWEER6SiPBpBexX5pZ4+tieJB06JIeyLN9Q1LZ5uoFTHtwdV3YpKApPkjLQPOsJLKh78e12eKHdvOPYaR46A==
X-Gm-Message-State: AOJu0Yz/DBT28kgj1LwTcZg2Aii2cPLoKwhTQMoVHumRyn3de0/zCyDs
	U3F46fXJVPgGD9oTK/ujT9c0//et6IgJ82lx4s+17c2OmzGTagd0oy2Xs3j3AeTPFwWRWUk3JnC
	v+umOtbNmcA==
X-Google-Smtp-Source: AGHT+IHtVVDAQr0HlC7Y5wW7LyESC5hemfsg9S9HuZaVvIMxC3e30XENP7rU5kXxBG6Pcf0SSGSVZruuEt/ECw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a25:c585:0:b0:dc2:2ace:860 with SMTP id
 v127-20020a25c585000000b00dc22ace0860mr493435ybe.2.1709688158684; Tue, 05 Mar
 2024 17:22:38 -0800 (PST)
Date: Tue,  5 Mar 2024 17:22:23 -0800
In-Reply-To: <20240306012226.3398927-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306012226.3398927-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306012226.3398927-5-ipylypiv@google.com>
Subject: [PATCH v7 4/7] scsi: mvsas: Add libsas SATA sysfs attributes group
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

