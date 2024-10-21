Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBF01CF7C3
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729541921; cv=none; b=JzFj+tAAbdu1WFX7kuMdIf8oow3aIzGpmRTtG+uv/r3vfj2Dpz9ESxNzIZbWEw+w//in8w7DCYgKGINJHMqtn+6pYXleZEYvvAkSpXuFuHF7tOslfQVzzCCiiUEWyDF60+vW28uLKRLPpdK55EznjbrfE/1dG4H4rysB7XvimVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729541921; c=relaxed/simple;
	bh=9Gj/jW1MB+dyTX+ZFqtjWJywSQcP6u5NAgXUWiH8RL0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nDjSMtUrTpkMpuqAmlqEMCIlRRvG0X8nX/m9d32U7U4msv1BmJO/U7eNhC2APt6xZWBLF/kKdaXnt3JEONDOI0gr8trUaWM4y0kQbhqiXs+v6oLd2eUL36AegNViH6156d8ARR18DuKetrBFOHBW8TFkMHuzSifqAyhONXtDOeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FRzObLMc; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FRzObLMc"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e35d1d8c82so76988707b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 13:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729541919; x=1730146719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tnh2nzSdhlx2y3A9xhxtGt0QYxcm3xF/mRsViTfWQlQ=;
        b=FRzObLMcAW6FWC/jVk7RHEru50/ziu5/naMH4VG4PTVyI4V251+CM0lFs0WlZp4GcC
         s+D4x+RRj2v5U7DwZ9iNH4TtkDw9fqWmfsEfJsW2XhB4FWBTQLuYsFHCKXS34GA3jX90
         owKWZMeGNe0Q4SAnE8xGJOaLgEJ2l7BgpubOluywEWsGGXaB3BizFhLYMu4Bhw0vgZ+x
         Xao1m6KGAwIh3OkjL4xXwKtdpwYbiHzQMSuo2nyEAkLKWYBU76oM+eqLsTd+6FPTs1NJ
         pM4qu5qpSvOHCl+17KJXBii8dEGsbi52xPtQrwoTZAVziyopJTZtdjlLP5QLZocedxyt
         ng4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729541919; x=1730146719;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tnh2nzSdhlx2y3A9xhxtGt0QYxcm3xF/mRsViTfWQlQ=;
        b=MOHtwEY5GQTeRlFheMW9I9u3PyMSnE7kAVzXfSfT9C+0kj1c72RAc9MwNFhCL/gZZt
         k+W+UEB/AZvNbuI8yxhTCVpLheRQn/Tgi3lStTx2VhUDMh6bulWtY0pSf/XaQyfC38rr
         HBuaDzLnlVyc3x24Qz+xT0kpnx9nTayxH8QY5bnHn0Q2KeYRGuRq/LV5b5d4ullvkiML
         99DTBWwJDs4zlKLIyoYoXbt749ulBEAUfjKvsGlsOshOacgZC0NPiFV8zkNkp6shTzEm
         qONKb92kZ7+IR/iaCv2jeL961iuD8X2KbpmaEXVub4UxV4aqWuMQ39pHADGh+zFz3aZD
         Amig==
X-Gm-Message-State: AOJu0YxNcXP6R11M7n4y/Zjww0scj8duzue1SIE3crZ6tG5PF9eCT0lt
	1d3f9gYS+gz0mezOHUl9+dm6h9jGWARe+gUiSRhDaPMIFSoky33QULGRwjPfjuCyWMJHXwCRyDG
	Ra5ufhARQsA==
X-Google-Smtp-Source: AGHT+IF066Si3BOFxjLkWn+rMxHThsNuEv9DNgP2bpLiRq/sQMSkJEEP7mYtUIpakSK7wQYaE+awk/7RByL2KQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:13f:f798:ac1c:499f])
 (user=tadamsjr job=sendgmr) by 2002:a05:690c:6902:b0:6db:c6eb:bae9 with SMTP
 id 00721157ae682-6e5bfb868e1mr3110627b3.2.1729541919388; Mon, 21 Oct 2024
 13:18:39 -0700 (PDT)
Date: Mon, 21 Oct 2024 13:18:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241021201828.1378858-1-tadamsjr@google.com>
Subject: [PATCH] scsi: pm8001: Initialize devices in pm8001_alloc_dev()
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

Devices can be allocated and freed at runtime. For example during
a soft reset all devices are freed and reallocated upon discovery.

Currently driver fully initializes devices once in pm8001_alloc().
This commit allows initialization steps to happen during runtime,
avoiding any leftover states from the device being freed.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c |  3 ---
 drivers/scsi/pm8001/pm8001_sas.c  | 17 ++++++++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 33e1eba62ca1..ab961ab3224a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -447,9 +447,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	}
 	for (i = 0; i < PM8001_MAX_DEVICES; i++) {
 		pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
-		pm8001_ha->devices[i].id = i;
-		pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
-		atomic_set(&pm8001_ha->devices[i].running_req, 0);
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
 	return 0;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ee2da8e49d4c..d80cffd25a6e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -572,6 +572,13 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 	pm8001_ccb_free(pm8001_ha, ccb);
 }
 
+static void pm8001_init_dev(struct pm8001_device *pm8001_dev, int id)
+{
+	pm8001_dev->id = id;
+	pm8001_dev->device_id = PM8001_MAX_DEVICES;
+	atomic_set(&pm8001_dev->running_req, 0);
+}
+
 /**
  * pm8001_alloc_dev - find a empty pm8001_device
  * @pm8001_ha: our hba card information
@@ -580,9 +587,11 @@ static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 dev;
 	for (dev = 0; dev < PM8001_MAX_DEVICES; dev++) {
-		if (pm8001_ha->devices[dev].dev_type == SAS_PHY_UNUSED) {
-			pm8001_ha->devices[dev].id = dev;
-			return &pm8001_ha->devices[dev];
+		struct pm8001_device *pm8001_dev = &pm8001_ha->devices[dev];
+
+		if (pm8001_dev->dev_type == SAS_PHY_UNUSED) {
+			pm8001_init_dev(pm8001_dev, dev);
+			return pm8001_dev;
 		}
 	}
 	if (dev == PM8001_MAX_DEVICES) {
@@ -613,9 +622,7 @@ struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
 
 void pm8001_free_dev(struct pm8001_device *pm8001_dev)
 {
-	u32 id = pm8001_dev->id;
 	memset(pm8001_dev, 0, sizeof(*pm8001_dev));
-	pm8001_dev->id = id;
 	pm8001_dev->dev_type = SAS_PHY_UNUSED;
 	pm8001_dev->device_id = PM8001_MAX_DEVICES;
 	pm8001_dev->sas_device = NULL;
-- 
2.47.0.105.g07ac214952-goog

