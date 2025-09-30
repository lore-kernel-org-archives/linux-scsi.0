Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3FC1A9F94
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 01:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759194628; cv=none; b=ceHuM2FVwWtjqvD0thJE3x8n6cqd20I0KnXgXne7hp2bGeEeENt5oFY0eWNr7kzaUhJ1eHo8ZGHxg8E6g+J6VorIQQpNs5w+kZTajmC/p4Lb4zk7cy5YChFL1tKSRLb5FVetTQPGi4hLMJqiuk8z996i03g+z3h7Ky1hE1GALlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759194628; c=relaxed/simple;
	bh=7LfUqoPrLO9qCwlhm7y//hUUQAHFcarEp+BWoazyJfI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fpSxezdU5oUoKmP0lMdGyPYOlZdBK8F+8f9f7dbD1VN+TOjp2CCz1y8gKuWXDE6c3ixA0QyGKRnEelhDPsW15I/Cg734QfmsuZyJ27KQE0fhlsyL0b6jWWi2l9L1Mf1SJRPQcvmbwBwz/ekt6YR20ZlaGqL+FQHDAEsrHv7JTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chullee.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ix5UB5YB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chullee.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ix5UB5YB"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2699ebc0319so53358495ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 18:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759194625; x=1759799425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=80u6rkudPcVgnnfy4DP1MjiFrTknBhOmZzqsn6OIdPk=;
        b=Ix5UB5YBpKnWK3GoTVY8ZARSk/aaP6vv9pywsRPRfoL//uHf8wmmda6Y8GgfIQ66Or
         Q4nGNVZub493Im2QUu/xVUhTASWcUFgyAy12TIZSu6GX02utsn9HG/MuHq3wq7CRewuV
         IfJc/NH7Udv4wpmoRw0KfkxzAtc1BF2LyIMR7no6JubrGiMOFnKWCrzS5jDTfTx1c24X
         mufWaCJeb0MvtPSRWSfAx7RQIHPeiKLcum1MDb/b/xbU2a/WqDmqKKaH3fiHQc0sdGSK
         RO44umw0FCXYsN2+OiqaCpfBQ5t7ucQusbpsPUvlNficlR1N6WMBjvrzwVPPM1K67cxt
         JXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759194625; x=1759799425;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80u6rkudPcVgnnfy4DP1MjiFrTknBhOmZzqsn6OIdPk=;
        b=cu2LqFPpVyNrX4FC2um2bJ8iSQmxyUJHenPXQV4kGWVixuomIZp3lEsopoCOYrnjK7
         5Gdyx3ZOGHcEyWli/yC6zYwUjs07Fgu4L5H+/0x7Qi0F1wsTiKsp+cUi7zDFaRz2aj9I
         kqcr1GeiEKIGh6MSdlmribt36nFfRla/Ld+n0bWsjBv/P4jTt3IcdY0QgM67Nxd7D9xa
         LzyFwDux/f0/5lzeJzyGZthyxrlTaHmwU/XZk37fM1vLJVgZMUyEUKMWAGGMzF98ctCg
         NPhvaQouYmv3+geN+3W6aaclhZrdLjQ6qh2gtUKl6TcImsx5rZhE5KzjKNOBuxCBRyfk
         4K6g==
X-Forwarded-Encrypted: i=1; AJvYcCWV52BraM6LA7/l7mg8MvlmzSx/nBUazcvDu+FWFMSKMxxtpy5Olz2mASgWj2XeJ0PXZdvdkOo/FW6f@vger.kernel.org
X-Gm-Message-State: AOJu0YzIw33E/ohszo66acJ39dYsFJyq6o4YMwwDLM41+lQOfuDjpit2
	JFqBkGiPK04DqiDBpspW/0NAcMJIyrhSSDcfUB1JqXG27/1I1E/tOhz7ktYihvI6LsSXtPhroUy
	tJ67eHO9TSQ==
X-Google-Smtp-Source: AGHT+IFwgklFzHea8pOr2Teh5M0o9w8YRN5GnSBNloszNq8B9b72knZQ084e/G5NQtg8g9Ce/pFmRlM37eA0
X-Received: from ploz24.prod.google.com ([2002:a17:902:8f98:b0:269:640c:8d42])
 (user=chullee job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:90d:b0:268:baa6:94ba
 with SMTP id d9443c01a7336-27ed4ab65b8mr161837335ad.53.1759194625608; Mon, 29
 Sep 2025 18:10:25 -0700 (PDT)
Date: Mon, 29 Sep 2025 18:09:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930010939.3520325-1-chullee@google.com>
Subject: [PATCH] scsi: ufs: sysfs: Make HID attributes visible
From: Daniel Lee <chullee@google.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	tanghuan@vivo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Daniel Lee <chullee@google.com>
Content-Type: text/plain; charset="UTF-8"

Call sysfs_update_group() after reading the device descriptor
to ensure the HID sysfs attributes are visible when the feature
is supported.

Fixes: ae7795a8c258 ("scsi: ufs: core: Add HID support")
Signed-off-by: Daniel Lee <chullee@google.com>
---
 drivers/ufs/core/ufs-sysfs.c | 2 +-
 drivers/ufs/core/ufs-sysfs.h | 1 +
 drivers/ufs/core/ufshcd.c    | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0086816b27cd..c040afc6668e 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
 
-static const struct attribute_group ufs_sysfs_hid_group = {
+const struct attribute_group ufs_sysfs_hid_group = {
 	.name = "hid",
 	.attrs = ufs_sysfs_hid,
 	.is_visible = ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 8d94af3b8077..6efb82a082fd 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,5 +14,6 @@ void ufs_sysfs_remove_nodes(struct device *dev);
 
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
+extern const struct attribute_group ufs_sysfs_hid_group;
 
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b2e103aa4e62..bace5112e095 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8472,6 +8472,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
 
+	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
-- 
2.51.0.618.g983fd99d29-goog

