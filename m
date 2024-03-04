Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4387E105
	for <linux-scsi@vger.kernel.org>; Mon,  4 Mar 2024 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590117; cv=none; b=fwU98qsKkMmegkWdKIqgidQAIXRne9mlQMB1VN5E29f3wY/YAiVlxB2MouuBaYtNknzIlfsUECOpTAYT6ymwjqpe3J2pJuPhZFSH1pgmjEvPRbnGe6ld6kuVpQisIR2JmP0UzC5F26fRyXFUvS3Sk19FLxWM85EQkmtiik11Ueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590117; c=relaxed/simple;
	bh=SbjbdjZWUXBzT2LxbKT4DNqotCfdqsZJ3zhnbS10R1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ilPlkgJBteSbmeXwJA1JT04at663s7DlUJdPoYywbG1bxfIrKPlUrkLN/d+qFXIm24AcvXZS3j5CqCzAINHhagv0vMVgrqru3iL2KhS9XKG9Ej3l2Eu4uNmPNy6y4zGQpknGhxholztvh67kKZ5Rq+a5xB8VJ8uE54jt/pSvIx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YFF2GFFk; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YFF2GFFk"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60942936e31so89101337b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 14:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709590114; x=1710194914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u66W4yA8M+KF0Llg68xH23MwaMjWX70CKgHvWJ3oECY=;
        b=YFF2GFFkect0CcmJBk6glB9KZUeLUXgxIcsgpYgUr8T2Vq4vqlCF+bQLvgOP1ZTmtO
         GF7PseOy70CcoeozA+NodicCvjCi+rtuVIy6j9QTUlHIRgzSNRCJOK6jHc+/GfpgvGJr
         FerfHqQupkyZadxBDohuqNYYH6jGkcZUKDuRO6pZfTCt4UoPI+siEvXAz2ud89LpsCOg
         D8zyHD20UKBwW7Ow458+3eBrPUp7ryWU81E7SPRMPXM/Jw6gh+L8yxnLl1KGi/nDI0mj
         IHxLHI710sjYLhN/TsbzlWye5+YAH5no1nS5CdLpcpLiSMzXtUvCJAH1thNdKgRp27yL
         sRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590114; x=1710194914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u66W4yA8M+KF0Llg68xH23MwaMjWX70CKgHvWJ3oECY=;
        b=u25wP7yX8H0+Z+DhXSoC6H97KGcYcZotlOtIguOIqRFVyUMYuFpSFJetcS5k1uFyOW
         VhmxZjdbykjSyH8Wv8P2iLwosp/kFb5SVSkge3hgAhqC4bjZpNNwIX7EfB2kGITuhhaG
         BQag68raNyZwnEwr5RQPBBzw8Kl9DNmZ1gOfFggXREQWSg9KZbEm5OlottYZX8Zqlpep
         WtdDS0+JpzsOjVlrIDlB6SG5DHVwqTkqQKLpiMdwOjsdzwch7m7cPRqnqbBtJxXEHfbI
         +W2NFtoWnxis6AuStAHh5pr8P93oAnvF60Lzs8W2siD3nD55AbqWrmDJgJNPpDwdVAwc
         1iPw==
X-Forwarded-Encrypted: i=1; AJvYcCXgR41TlnnctYN/0CNfXQ+DnnDV8bD9WnCzdIF3yr1Oqbo4RYLimfyAoQPtmnKG+myE2m86j0ZCKUiQcIPrnf6bVMEgQCPjgMkogg==
X-Gm-Message-State: AOJu0Yw4jp34YwTnWVUcs4SPlHf3E0UgqOl+gzV6yRqHFtSU+KkrvoAV
	eLiwS/ZX1tHLv1J6akkygPnegsLIWLaEU49Ph1BK0kaaU1/E8vKHafDRQet/EDmTC28v9iTbqth
	9J444Jjt8iw==
X-Google-Smtp-Source: AGHT+IFZfyS+uFwGZLzMHFOeD5UY68eEdzKNnsQfushZQwAV/48zAAnVPGQYWTjxCo6N90NONLdqyIYTRFvRSQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a25:abc2:0:b0:dc6:e5e9:f3af with SMTP id
 v60-20020a25abc2000000b00dc6e5e9f3afmr2651172ybi.9.1709590114389; Mon, 04 Mar
 2024 14:08:34 -0800 (PST)
Date: Mon,  4 Mar 2024 14:08:13 -0800
In-Reply-To: <20240304220815.1766285-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240304220815.1766285-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240304220815.1766285-6-ipylypiv@google.com>
Subject: [PATCH v4 5/7] scsi: hisi_sas: Add libsas SATA sysfs attributes group
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

