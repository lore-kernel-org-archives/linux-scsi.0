Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25C1339B1
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683122; cv=none; b=ebZEC/xuBOeIpuSyNRlUSPLHc5XR+U2wcY21SWthJSr7CqcgwNCkwgvm+Qa1L3U/PlzaJ2yNR0rlLfjZiWIx4mwJk83NAGKkrsXXQ7FyWpsTvDKioBRI2aHhgANRxazFbx8MDAdF8l74R9NEbxW8GNRLUzSTvHGlG1fMZmJuk0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683122; c=relaxed/simple;
	bh=maF5o+8NzF6pdVwJjN4aGBE4hXXZ0tcVypbGypFOmGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WIWJo65BaxL2cnTSi3dvw7f1BPBg10PMvseNVShbst+JQB6tnlGTnwic6QFXF9KSLQEghNLmyOCRjJ8B8QbM9SypPNoJTwTvln3A6d46B6Ku5WJ/GiIBJyF5mDOUBeeZ1aAmDyQc/8eTVKPZZAR6hPWYuXc0pvvIilAJ6umoDTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jCp0S8X3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jCp0S8X3"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60804b369c7so17994927b3.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683120; x=1710287920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9D3wwHTaGXoUxTIIC0KnLIe431yjbfic0tFZoCaTHSU=;
        b=jCp0S8X3jV5Lg50a9vWe6OJgOTTJ6EwUYuswLsLlR8xvQW96O82khoeYtHREYeN9cX
         2YUXEYrWm+rGxlU93htoNICPi8piYw4t7eFnqsq5Hj4G3iWfwkWoA1/M8WN2J61vDq6B
         h7Vdd9fG1KzmX+iy1RTK4LFeE4/ZRYhs5879ygIH4YMphhyKBm0wvF/paHY/OmROt2LH
         UKZBp05oidfKiZRXnnNfaWVJsuR72eRZpHd+wMGSknaG2inCkkpgF8g1VIv1tVH5avMb
         7g0WU0op1ZxU9vRy2wKr2UlwK2L/pXtqQdySsEuRnjsxudlMapPSEv3bqHrKKwVYZ2ui
         2Gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683120; x=1710287920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9D3wwHTaGXoUxTIIC0KnLIe431yjbfic0tFZoCaTHSU=;
        b=sE0vjbk3Jzb1hdEBz2bUMRRFKy27P7V9U82r0ShDd18bgIrZtunpR6eXTYcknsBF51
         LdwVrOuAbw6gKTPqMtX2xgSgCkzLGv4HqJ6nwhRG16iTsdl6HCu5nW+cAEMFZwyijFFR
         rY7cYOL8gYjXramWlsPrvGZB34H1sJYsmTbZFb/Wmk1hMWeW9KJgHNlcsnjdQkWsprXP
         Gq7nkhvZ7sFxy1Cj8f31QHeuipsXyXtISgp6F3WEUaLwi0Swx1HJUIJhTZEg9fG7jthr
         MYkJgMFkzo7ImXbIIKdw4ayh5p7CsUGL3TjMoKgek+zkU0KYz6dfq4cFfmit4We+X5nL
         D/Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXzR5hT2WQXdn4LTCU277Xi4TQuLwfScdJ9FEJksfhFuHxSIxi/gGxhZDkzy7mGoOvGEzyT68iQ238VXhu4YYfBdu5Y+y3e9DGQuw==
X-Gm-Message-State: AOJu0YxBwWtSCOIDQUcw4hH0vne54wjVPM4ckYhFt7YhPmlIhfdE5pl+
	Ps7WIoKTxfJgy7QOwOWiyp5/qK3+ESg/UdKQmXW+ZSTVG7J808cSKWj8LFHPx40tCJV7CCNGi/B
	CVC9XdH9NLw==
X-Google-Smtp-Source: AGHT+IEh4EOkCQAW7SnanA8bB430w4xh23BQshDhLIDYxxe1IBICBWObTrhgrFis2i70uNCJX6d2c6KwUnqvMg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:150d:b0:dc6:fa35:b42 with SMTP
 id q13-20020a056902150d00b00dc6fa350b42mr3669159ybu.2.1709683119712; Tue, 05
 Mar 2024 15:58:39 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:20 -0800
In-Reply-To: <20240305235823.3308225-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305235823.3308225-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-6-ipylypiv@google.com>
Subject: [PATCH v6 5/7] scsi: hisi_sas: Add libsas SATA sysfs attributes group
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

