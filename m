Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F0727F751;
	Sat, 12 Jul 2025 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752330492; cv=none; b=FmdaRuErOBWBvdf9kh13he4I08Lg5zuyMbxOfjMF7lCO4wpVGP27wWQNnh9xYBho7zmhzBtkhM7fWs2V+03JNFHdoqkaXAPi9ZXclfIvK/2vzSHKdRqiL1xy/57NuOxDjZpER4BV2546z1M3Qg4y0Wi507js9pMBult2t/KW+3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752330492; c=relaxed/simple;
	bh=mfJj0mxIXjnqzDfwlQsTgEOe1NZBpZ9DDzkiqanQElI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cXvM3oqIh8ALymar83m8XBreFbijEq8MqK0wCtWdB2cVanf0pbxAghjyKtIYloc6LyT/5co+rDdgYunXEEXX4hZtRAiBoq9fQp0BzelAaCTNnWnDEfnAM0WJjEaijqV4T+TEQeTjQeYj7aejmv9GZTY8PEJa1rzdBImj8N37HQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vr1XVaus; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vr1XVaus"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a51481a598so1622017f8f.3;
        Sat, 12 Jul 2025 07:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752330489; x=1752935289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vKO+RdbPOJHVDRjTSXIDaC42JXuaUA/QuGjWq2fHQQ0=;
        b=Vr1XVaus0qp+b9LC0eGunrh4G6zSSuYGay4ZsqFdx0a22O063yH9jA9rvJysf7oUBU
         sCSeYzss8/hwLq3y3Pz2st6rL3ku8o3T5/HAEJs2jnbbVkuf0gLwiuZBOTeyWt6mu/8w
         J6s9ZQTL/+AGuUfrxHfJNHAKbg+WDBLWh8DcH5ys9pO7mVGdi+ZLhIleQdC3l6wH+YqU
         dodvujvlBaUDzPSf+UGOz3wl0D98z6bQZy1nddovWhFmL5Fm6MEqJ3Z36b8S0m8yqWFY
         1unLSAWPz1qlNjr7tWA+IA3+MiT1cNhzNZFMAlBT1R+/rxnoH8zUl8HMzn9CKT+7jEKL
         fqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752330489; x=1752935289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKO+RdbPOJHVDRjTSXIDaC42JXuaUA/QuGjWq2fHQQ0=;
        b=jaHdGsqvm+3qRMdyb/8o0F04AHQO33PadFffjtjZP6k9dcjPoooXk6ixCvNMhh5/3I
         u3JTCMzEGfv4cdmY2B/EYWYw5unfLEr27109ioZY5pW0UlaksxdVqfcPtFHgCAcxeQOr
         tV6wu+F5jtJ8o4Lgrt5bu8pNLjBTlHAaepx2U5PDV0f9S7aT8/LlwGHF14AMHkCj8Bbz
         q9Kmkp0gDfwhbTHNOcxma9Kt9IwIhGXpYEHm1G6QWoJzBSm0Qh3L5uRyOMBnAFjTxknw
         2vrru7+2chB960CQgL5RUXNRiMa29TF2HuID/2KHfPK9FHULaBWl6GxO7ksrZ6Jg0J9A
         pr3A==
X-Forwarded-Encrypted: i=1; AJvYcCUGptA0UVqTdT9POdLM3nlMUdzXsNi5FK/sFaniLkv8L8xTjgeJiR7jBrrDDoeJUUtkirsuyIO0I4dd3M0=@vger.kernel.org, AJvYcCWnbxusv3RVjGduqU2UKlFhLSPCTr5RTyxsafLr1YsE71AVB59DwFkX1ZYLwak7rE4ezr9R5z+OUPA5FQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYxdz3nuHfBm1ItCA1MjbrmRclmYJ26Ro8KLj5TpRqcLFWoZok
	qwEXxEtT08sa/lHRr8NxpMNOrI7BNlQLTfmPpLoKFTnX1Q74iDmAdESJ
X-Gm-Gg: ASbGncuW7+Sqi35B4lctpc5qneRz87lKnJ7eQ1CuEYUptoNbwNxCOprxWpRcV1QzcJV
	dy8KUEnNUkdZS2SVmNmqLh9mP3VhLL06bsPWUwltmAjdCJGwYvl8DInEXrVd4Eq5jepAODLDEsd
	81RB3glvgvtc4vPHLj9ywchMcVLYYN600N1ieCG5CjjL/JfXJK8EzPvF+SnroH65h9dsITSxfn3
	bv59qgQ3YlgLIFl7yUeOSgrI5c7WWh+wCdN0Mx3Me5Z3IcW9D9QkiejD/Vuzy7hLQk72UIHWBi2
	oB6X/Cj6qqHeW1bSCVqzLrFsyfXAm6aHpL19b9WTHGm6yutF03Ioe0ST8xW9x1vP4M5drVQlvIT
	322T2f7AEcnUwyutVJN8DhKOmaMZgTgqfFxe8z9wZMNeUxzc=
X-Google-Smtp-Source: AGHT+IHxg/G8bJsXW2Lq+V/p8vKXWydJIxg0pHkVofJfHd8FkPrdkd7tp9DGRP70quCAzNfuK6z55g==
X-Received: by 2002:a05:6000:2c0e:b0:3a4:dc93:1e87 with SMTP id ffacd0b85a97d-3b5f2db159fmr5579245f8f.1.1752330488660;
        Sat, 12 Jul 2025 07:28:08 -0700 (PDT)
Received: from localhost.localdomain ([154.183.63.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cdb549absm105569565e9.1.2025.07.12.07.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jul 2025 07:28:08 -0700 (PDT)
From: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>
To: liyihang9@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>,
	linux-kernel-mentees@lists.linux.dev,
	shuah@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hisi_sas: use sysfs_emit() in v3 hw show() functions
Date: Sat, 12 Jul 2025 17:28:03 +0300
Message-ID: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace scnprintf() with sysfs_emit() in several sysfs show()
callbacks in hisi_sas_v3_hw.c. This is recommended in
Documentation/filesystems/sysfs.rst for formatting values returned to
userspace.

Signed-off-by: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bc5d5356dd00..84bc02f7da27 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2849,7 +2849,7 @@ static void wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
 static ssize_t intr_conv_v3_hw_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%u\n", hisi_sas_intr_conv);
+	return sysfs_emit(buf, "%u\n", hisi_sas_intr_conv);
 }
 static DEVICE_ATTR_RO(intr_conv_v3_hw);
 
@@ -2881,8 +2881,7 @@ static ssize_t intr_coal_ticks_v3_hw_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n",
-			 hisi_hba->intr_coal_ticks);
+	return sysfs_emit(buf, "%u\n", hisi_hba->intr_coal_ticks);
 }
 
 static ssize_t intr_coal_ticks_v3_hw_store(struct device *dev,
@@ -2920,8 +2919,7 @@ static ssize_t intr_coal_count_v3_hw_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n",
-			 hisi_hba->intr_coal_count);
+	return sysfs_emit(buf, "%u\n", hisi_hba->intr_coal_count);
 }
 
 static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
@@ -2959,8 +2957,7 @@ static ssize_t iopoll_q_cnt_v3_hw_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n",
-			 hisi_hba->iopoll_q_cnt);
+	return sysfs_emit(buf, "%u\n", hisi_hba->iopoll_q_cnt);
 }
 static DEVICE_ATTR_RO(iopoll_q_cnt_v3_hw);
 
-- 
2.47.2

