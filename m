Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161E134DE
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 00:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709338627; cv=none; b=d/vC7EAgNhw4DM6ANkr7M9pE1QZfLPLD+RQUOS/wyY6MJGjCCaK3xyJ3cSvJKyAPMm53pCxEbFqWVx/zMrjqyu3AQtfZc7/i4dQJ00NbMex6CdSQ8U8yCe6bgnJcyhV1OdlM8hq+i3tzO1bayBfqx6ADFYyz3QP5zVXqWCNkbf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709338627; c=relaxed/simple;
	bh=oCEOlszWbRebAJRFgYlHh9o1ZpJRj0ce/17rkZ3A3M8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V520abw8mtFRt408K06VoOEo6vq4LFXOa+dN5zJ1p0UNzQv5UqMw6H91/7m3XPT7matsFKOsc38rN+4Y9nFrQ0Dq6sYoY9gkU6kaWl3KQGqSXpi389twVWmB6gwVptOdJP3i1KLsnKvd8NLAgQmMAiaYEcYuQUoQqodOuXNaWEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYVAZdBK; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYVAZdBK"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so4871973276.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 16:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709338625; x=1709943425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUX3zhIus5O92bJYySj4+GAcqh6w/58AkwOdnSqPEQ8=;
        b=jYVAZdBKuXRtcp4BjBWfmc5UDZO96hwuu7bUwh+4e/ozYcVOBeE0yUhlatuICmexaR
         BL3rGl6HsgBqVKrB+MqxxcTwmo4qCZsv6aSA4/Tb4r1gLOOfdzCc45r0bmVaPwDMeXyy
         cd6pKDsC5vyHpFXQ0EpPcwMTtUP6iftDzMP9wDKX1BZcoepB90aKJMZJV6Cf7imyJPWE
         u4RDK1vYJn0Ca0PXvbKMVbCzsJVl06PhL8y9Qho92KAjibmuXYKqMb87lftrISsQNNXu
         OfLw4dIpo+tywywhLbYXmcdTHJnGaPqm+vXQC12rdBspVUFKlAwIK3U19QC288L6YXx6
         4M7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709338625; x=1709943425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUX3zhIus5O92bJYySj4+GAcqh6w/58AkwOdnSqPEQ8=;
        b=QJ1MZg4b28qFwpVAzYurY/n7CfsQDElmWe6OgQGpKVBnYDXNtTU0/dTg4k6eaKTmXt
         lxETKDDyT7vBe4qcuCRlSi0vlSlEwMGxmHkYbFLdsYJKrRj29geuDsSiIoHuRIfSBAgA
         8B8qneJOOP34HktRXCe4k1G0KYUTROL0SHRNfIdP43JmCXLbmcpiGnDtswUO3awYwV8S
         FBu3fIAuvCYeftVlRf4JUevgTdVd2/Gn7TrJWagQ+lzStAzbXH9f4hy/ydXEmR8e1xT7
         YcOY5AgT1R52RDb4m5ZPptFr9WaSO3nSczeZ8u3nRnHZSkEsAZKTV7imgZ19foMjfj+h
         oKog==
X-Forwarded-Encrypted: i=1; AJvYcCW4mjIN9BxENNG3/1RrytwlMwsoQfOa3+po6mdLJkCfYCqXsEgJ+T9scuabd8AaNogZMOGGasJSQzpPfuBz0/FTvKpn34HkQG/oXQ==
X-Gm-Message-State: AOJu0YwpkKXy2aA4vT4ySTmymMEKeoOOrWeV25LsgtrwLorcBV30V9mV
	IhhfTgtDdIA/D1k9JF9eC5v8WzeQ7xwiRpQSOc6N6HRc0fG81StlUymhXfGeSv4A0xJWR0hrH0f
	Qz/chDLalpg==
X-Google-Smtp-Source: AGHT+IGpYFdkSZO93d6Cb08S6RbmCk+UgL9HtoRDFxC19PmO95Bu0m/cSiB1RLQRMZ3KLzRi+Dc+F4zpVgTKYw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:2afe:1a8e:f846:999f])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:2492:b0:dcb:b9d7:2760 with SMTP
 id ds18-20020a056902249200b00dcbb9d72760mr751756ybb.13.1709338624882; Fri, 01
 Mar 2024 16:17:04 -0800 (PST)
Date: Fri,  1 Mar 2024 16:16:02 -0800
In-Reply-To: <20240302001603.1012084-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240302001603.1012084-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302001603.1012084-6-ipylypiv@google.com>
Subject: [PATCH v2 5/5] scsi: hisi_sas: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3c555579f9a1..97864b56a71f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1734,6 +1734,11 @@ static struct attribute *host_v1_hw_attrs[] = {
 
 ATTRIBUTE_GROUPS(host_v1_hw);
 
+static const struct attribute_group *sdev_groups_v1_hw[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static const struct scsi_host_template sht_v1_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
@@ -1758,6 +1763,7 @@ static const struct scsi_host_template sht_v1_hw = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= host_v1_hw_groups,
+	.sdev_groups		= sdev_groups_v1_hw,
 	.host_reset             = hisi_sas_host_reset,
 };
 
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

