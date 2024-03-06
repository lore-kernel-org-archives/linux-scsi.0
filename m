Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F820199B8
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 01:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709688163; cv=none; b=tvtDTMBASd2drqZcM+PmkxyXAt6Sg8zs+6IPRcm/+YrDk47FVdTfPE7b4oSZmz6LhZGAbXF8IayYBA0dhs+Vq4ZsDrQid/kUg+KOgzgQo8G4iGcpcGBNBrnYsCbQtFBkH0cML0bFDb5iwuD+wfPPZsIwmT4nUHChOiE+OPRD3Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709688163; c=relaxed/simple;
	bh=maF5o+8NzF6pdVwJjN4aGBE4hXXZ0tcVypbGypFOmGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hhyfyhGDUpgCEdRQq7y+9L41LVEwGPKWix8OAezUFfyCbjHhbbW9HLDQoPZlOy8McGmQGH5HvFAfVzXxw63bfYxTjQaMHG8WXBZsjCoKCxzNnByoJs8qFv94k1EGO1RMBV8cChu3WMt8uwhX614tf5jgyGLsQNhf48oq317K2vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EOzeZQPJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EOzeZQPJ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso832300276.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 17:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709688160; x=1710292960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9D3wwHTaGXoUxTIIC0KnLIe431yjbfic0tFZoCaTHSU=;
        b=EOzeZQPJB5Y3+i9PAUfMpeIF/jgl9XXjEiQhZgn6oouhpApROH362BOIX2etaWYvDZ
         2b8SYqu21gI4lUPwzLEV5hlijNFTpy5sg7OhWKmwwTeR6XaA2X00zDs3gGB838HIP5rD
         2G3UdYmLmL+bMAo23lfrZ2BBY7Rg4D3n5LaJM8foKOdk7V+ufBg31nYcdGos3HtieJ6G
         BNqvYACdqaFmFj0LY4FVfTdNLNWLynOi7Wn4Spv8ps2Ix6CB8qgKvRtLXaGbDLx82rZS
         GW1AtVsxHK+JBOfLNaGR/dVxP8xFySX8PltjfifuZnIL+61nFsRFD7NxJAIjElInwKMi
         RpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709688160; x=1710292960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9D3wwHTaGXoUxTIIC0KnLIe431yjbfic0tFZoCaTHSU=;
        b=neYbHg4v7ki+9dAZJ70M2wJv7+v9Xh6IOrr+NWUyBCuzf3lITh2kvI0gcPU4aC9HkK
         2yu4GX26HfgGShYXS9geuWkJh5K/MUCMgb6LdZF3l4aUYPYKepy+RfW1iFpYgHrUsLhN
         I35tKxm4k0ohH29iT5MVVxGGozwY3DuC0eHLd01hIrnFFsZhhcZWkRqs4RBTWrGPSIPs
         VW29rkgXUB2+GODDA+o7n8ujWPC/suLcy09PUvetBkQtS/AQeAEi1vo03tfZFk9obvc0
         bapSh2OYeRbBzit6f85q8IPs6rxV3A+A4IkJ8MvAAnH3tRXyTeIqgKu+/rGrDwNPsh20
         UNMg==
X-Forwarded-Encrypted: i=1; AJvYcCWFbE/H5XfmRJ0Txir/0wwXvrpacwltmRFdhxByAwdhW5thIhvPmZsHYn8P1hLMW6qBUXdejNhUGTi2b97I5QS1ywBZiZuDXHrkIw==
X-Gm-Message-State: AOJu0YzlsOhi1CxoP+SAo4G00lmsxSY+7bPxxCd67jRX4f+GAiPXigF2
	AxkEW0p53+7lBh2BEWBbPyEtLG9Qx97g3BqIjjKDh4cgtd8xOvufbRbyk3/tKzw3RCn96GbgvmK
	jvPT4wrevJg==
X-Google-Smtp-Source: AGHT+IHUVYeEphfP5HL9mrtHhMSdBzXskMFsuX4hlP6MoR2AXyYRNthWw2ahxT53h1qtzX1/VYFvhVvxyPZ22w==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1004:b0:dc7:42:ecd with SMTP id
 w4-20020a056902100400b00dc700420ecdmr3434562ybt.6.1709688160545; Tue, 05 Mar
 2024 17:22:40 -0800 (PST)
Date: Tue,  5 Mar 2024 17:22:24 -0800
In-Reply-To: <20240306012226.3398927-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306012226.3398927-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306012226.3398927-6-ipylypiv@google.com>
Subject: [PATCH v7 5/7] scsi: hisi_sas: Add libsas SATA sysfs attributes group
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

