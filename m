Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342F38DC3
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 01:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709257117; cv=none; b=ifarga3mIeDnBAamU6lHK0bLcyWLdOLWZGUcDSYYb0B+ik/qx/QzmWacLndERblsxFbVXQsH0vqXbXqPabNb1E8GXQKBGnmXRZKMykUC75jj2Wo28auYvxFT4OVB4T9NvezeRB1MOq/KU8f3DBCpQkSbRmIGxSXIMbZwD4YZerU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709257117; c=relaxed/simple;
	bh=BHm3bafsiy1rPpFyzr2QCqwbYutNJj2AhwXm2Nw+tbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=igUxcg+as7+a0/Dh8mBUfu+kdBhglVeJSjrkmyat06Iw360qqcOFoqTAdsw1KQZQf/FLm/7nrlL8ZJedCLTaymx6mmMoKZOQIIzwvPrJb8oJgJWTngrOI+fH88ee0Nb2QPsdcUxBliWoMKMwztUdrkm7o2zmhTWxCloMMSng/1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5p8Jb4k; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5p8Jb4k"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6096c745c33so24026027b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 17:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709257113; x=1709861913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=avuTBfkDXK1hv1D4bL2KM6unjJu36TT8oh9Ptp0s5ao=;
        b=I5p8Jb4kUHB/kLPAWKq9jA7ke/gbWnb0Uq+9Pbk8Xztvg1Ynnmc9sa6PLKrZVe/Ana
         rhdi8bD2VD0yf5uyomkqWk0zU+W9NKANjNEInWkUuPyDHsuKLgkjv7Loxtx3Xp4UAiZt
         t2sgCv4J/Ed/YupGQLzM4RCF2krnEazj3lDGEyt99/VRxLexDffy4TJUZp5QW8VDViKu
         3BIXKQY42/mSgqdLv2URhNoY5f011FGbfwP93nlxA+JghadG7jhnoMH5cQd2rfvlWNDJ
         GDWmi3AhXuBYqnlFdqssK0+PFa1cRRNyIj7Z9zJa2QuduAtaoxcabUxKOKYbZRFbecam
         M8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709257113; x=1709861913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avuTBfkDXK1hv1D4bL2KM6unjJu36TT8oh9Ptp0s5ao=;
        b=v8NWD3aG8/miuIafUO2eAXWHc/jIGHdPxVYuY4VT4BhoZ14i8AV7b0HdJ0bBuBdHqO
         vb4FQskMz5kf0w3qS4HKHPtTAOXnDwF6sspj50lXGTkX8dT2D0mriyVdwKoxw/1cSG+j
         AxtYfwLZU77wsqnJuK27t+104XZUZz9wkygsyX8888G9als7Acdd/Z0mNz+wEVx7DiPw
         bsHg4ToUjyBmA2U05dOII52dK6a6F540QAk/rY9TjtAcWQmys+2mBRFHhHXgO61jIwqQ
         HsDQxdnH7qDg0n3v77WBKIfLCkSV8y+nMtcTkrLxq7vFdf4n9LBPkAbjgHF31hkXVbcR
         oArw==
X-Forwarded-Encrypted: i=1; AJvYcCVkr8dcYzR1A8nk4cwpxpi/7y5otD2A/Kf92H/wNmzJzuv/1h24+B8apc+5mPAIztHIdrmYpQv/Fy89Pk1AaVwyIzdGj2BqcAqzVA==
X-Gm-Message-State: AOJu0Yz7nvWd4GdjZMzsxilrSn/MLXphUaro9WNPpMpTGYqIlz0r2/Nj
	9YgxOSZGnooH/JR/8VdaMSJZDwiP4SLHjcYp4q455SZojVwt3qd6LttsEwzEBBfdMHb1elSdekO
	CV5pxZb/eQw==
X-Google-Smtp-Source: AGHT+IEC0MPeDboQHO/1B3vR+Iq5QjH11ZYMccDwztB1zAvvRbVdodFYQk+/U00WFKidW8wJFALdRMRUrASHwA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:3564:51b2:6cdf:92fb])
 (user=ipylypiv job=sendgmr) by 2002:a05:690c:e18:b0:609:247a:bdc5 with SMTP
 id cp24-20020a05690c0e1800b00609247abdc5mr59222ywb.4.1709257113724; Thu, 29
 Feb 2024 17:38:33 -0800 (PST)
Date: Thu, 29 Feb 2024 17:37:59 -0800
In-Reply-To: <20240301013759.516817-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301013759.516817-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240301013759.516817-4-ipylypiv@google.com>
Subject: [PATCH 3/3] scsi: pm80xx: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>, 
	TJ Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: TJ Adams <tadamsjr@google.com>
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

