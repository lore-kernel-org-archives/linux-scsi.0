Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90430446D5
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 20:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709410620; cv=none; b=UxaOUcoOKshePt2682j2NXWUSHhQgRcMiosYwZO6a47Nc8UEgzBULNEEcVY05orBWAw6GQRnDi1/7EAMYrY5H9eX7/qNNaOZU9C0LX7264PbFtyPgS/j94Bzvbe7/vzC+SId7svaAJqxTPCb34ht2rKgCUus/0Mswllz5+T7+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709410620; c=relaxed/simple;
	bh=BVc9AZZs/RVfi8UbrJKJ/9aeH5efGDemJUyaiD8CbnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lRO+cmgwfT1ZsyKz9hyhS1qTpvi7VhSzUZhophxHMUDSmoH/TxV9gZvPT4wP0syiCpfIZKNj1Wprrz26ZaAhfcQKmDdUc3DUxEwmEa8HuLFep4w0MimE1UJp4pc6hmP0suVuf76CquvZ+PqOWmi6Y4vdP0COkQNUhqTp9u87I/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=darQoFh0; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="darQoFh0"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso6186996276.3
        for <linux-scsi@vger.kernel.org>; Sat, 02 Mar 2024 12:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709410617; x=1710015417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=63IDjKZgY41/sxscATiWOYuczRuUk4XINSTCQSRn0Gw=;
        b=darQoFh0MZx3w51d+OsqEu26I7s5U/qD4kU1pPjsg/iYClzJfpRDrxtDgY6AEoKX3o
         2/5kpZ1WLAMQqaXaiPREFLFr67xAtIpjhfeCecAv+FLRUenEasbNfB5qbZAkkHY+UhyQ
         +KI9tDZ1g6Ir8RdRcyz+EhgLYG4R5Xp+pjJvgq4WohAO28uRpFg+Y7YXmYeYzwHGgkpI
         /evLyuV9gHVLEhOMS3pzYoEXfCV/DctGkRFkyyy5sZjmymdsviHEhtCFloeWC51xxbpo
         Zj4r4K+mKPXe7D9WUV8WTpd3uDTE1XFE/z0NBHJd8el4KUkfosnZ9J3zpdzsa0IYFLUH
         QvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709410617; x=1710015417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=63IDjKZgY41/sxscATiWOYuczRuUk4XINSTCQSRn0Gw=;
        b=rv56tL5kmyiDA0KCf/e3cgczfaQknJ/lOJUbLH2AGvdX29W77k90OcTEw2S6NLl/YX
         M5a8luTZQVchb5Ep4zVOJUkjBsdzttaQesYH6qD3IODmb4631YBjS1sF58oYTyKGscuP
         asyhaqVZuzeJ8VAQPSqHK6Pi5K17OC81pf2HAPxQ2276baO/PwDXLmuGBd8rLPv0aRRn
         ywlo76HegsqsTj8Dq0tW4NlOciKV7/4junasofk1dyQTPTlw7/iSG+cLdx/Kl7S2+AmQ
         j4ZrlaQ38yj+IyE5i2Hyzz1Hci55FRZgVU/oapay2U+cCXZ4zMpvrAw4oFwst7DDyxNW
         v1/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTjz10jkM+Sfb2huSP4XaNXJ7YYoMm2lBImU4JwLd/5psRITZCXrYHyfKrIbdj8hrFbsHHCd6P39qKbmJekL65JG+Klg594ADHfA==
X-Gm-Message-State: AOJu0YzIA2EzWBTeV+nVkBMEfqI/NVVr1tTTusH3kD0BQigmrPK5HTVZ
	5lzAHiAuzTbv85eWSgzYIYzYSOk62/HUbVIpIVOXV44dDhNsIJC5jCUkHc0l6QWCIIqd2oWkoaq
	SrkZOpbTBHA==
X-Google-Smtp-Source: AGHT+IEORCsCCZU3k7TPogV9jHsXNHCrge31RYXS3NSAXSIa7IhPkHGnOtO0elfir6/1uicloJv1lIQ3KmJXyQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:41a7:9019:9a7:b404])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:210b:b0:dcc:50ca:e153 with SMTP
 id dk11-20020a056902210b00b00dcc50cae153mr1370635ybb.7.1709410617704; Sat, 02
 Mar 2024 12:16:57 -0800 (PST)
Date: Sat,  2 Mar 2024 12:16:33 -0800
In-Reply-To: <20240302201636.1228331-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240302201636.1228331-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302201636.1228331-5-ipylypiv@google.com>
Subject: [PATCH v3 4/7] scsi: mvsas: Add libsas SATA sysfs attributes group
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

