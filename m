Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9421B86D5
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386848; cv=none; b=YqF85A4AZ04s+JYwdCWWKA+BhTe5G0mQuiYboPmK4aMmnbrfqaaozX1tZNnyOBJWIiCLqwBFiivcM/2ByDtUTHej73DrFLnCS+6vtAQP31j5PmEwHoXz2Sr1TgWOWwuSeRVoLdFdNv+DlE/jo8c71b6QkNJXLWOX7cLNCiRFypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386848; c=relaxed/simple;
	bh=FSTQzgStkDk9VUc+gsKO61mfM9QA+iMwJ9eF0K091kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJUcxQonLvU951vj6lRkQ83EpNd4lzhcEOTQWNJ1V7jw4yTVTpN7JRvlIRqNJjwLnAtozzNiAhbFiK7SuaHaa61eSUyTlyh3I3suwZSrfzg3ty/Nlu5K0zDA3phKkp6QdcSEyfoGLgavUmMCc/m1SSw/wOXBhFqGX7HE7OIXnTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jG331kOG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jG331kOG"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so9360555e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386845; x=1730991645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HABtOu8vBnUR430AFYIUSUDi3ELEcFC5jVUmm0tB11Y=;
        b=jG331kOGlx7cm18wCCreGTLG/dtm9oJFI6eVCYPVG6HfwIOB0dgY9XuOwICZBUJESS
         XWPUy2Y1XPRsz4qwRUAEnJOSMWe9Od7iC7ahbrD1PznW62WKmevBa+2MI6gtE/hRXiQr
         28z4/cpK65ienqBNxDwdXOARtcd+rprysMKvS4f43vX6l7c/EG9R+2Sj0upKinY+HmPN
         qDhmxXEQaOIy2faNFVVrZ5MufmxeEylrRn1Lu1S7vSK3EcJWqH6cqZCeIF3FHsd/uZz9
         WXSU+1q6ng8a008gLYDeW/3t8V01Z2m3c1xOhucW4R5NoHuvmRjPLNDJD0jUeUArn9FV
         CBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386845; x=1730991645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HABtOu8vBnUR430AFYIUSUDi3ELEcFC5jVUmm0tB11Y=;
        b=Hd77rWuieeWIQzICRcIM55T0xCZMeBtk/T9rY1e7CNsAqva6Q0UHK8VH083F+sAba+
         oVPXX4QgI0v49BBepb05Uvz6LkGV79FsbcxySsjStKFC12EHntUkB6L2Shp7tWQwKXwf
         TIsYVHBDOsHcrXULVuqbPTY8+P+BExqSxDW0VSo05xPiVf3UPoIkp+fpFMSjhKshPw8A
         3VQEB0GKTtaNPdrfDlBJSmm9ph35XJpQ2b3zzde2tX5CF9MsdYYidfpZFwgqWTifIu0D
         NYc21R0NSQCmg114lDdv/w9YmoxqMkYx7oV6U4pezjd2h9O1zfs40WvMa3B/SdvR8DlG
         0jfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9cwUf8bNBk3FzhB1CgR1aMwxVkI4ad1rZ9eu70+Cd8dmH7bXec8dgivlKvUw+ao4zI0i2ibZ7bl8L@vger.kernel.org
X-Gm-Message-State: AOJu0YwiLcMbGqe6yWinyG8UsYn5FH2JYa03S6oLQIxlWhRV3KiqR2/P
	qKmWdy8UJzxxdzDmKFoqVpjs5o3xoj+kp/o8F1xfTW7OftNZz5LkG5dL/F23imk=
X-Google-Smtp-Source: AGHT+IHrOUYyAxFC1VJUc6y5oX3ddkyV0eSXyUdqL+WEdAPlUpCNJwf8n2c1O5ZakYFeCDJkSDGQIQ==
X-Received: by 2002:a5d:64a1:0:b0:37d:4fe9:b6a7 with SMTP id ffacd0b85a97d-381bea1c1f4mr3210183f8f.36.1730386844715;
        Thu, 31 Oct 2024 08:00:44 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:44 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	krzk@kernel.org
Cc: tudor.ambarus@linaro.org,
	ebiggers@kernel.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v3 06/14] scsi: ufs: exynos: Add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR check
Date: Thu, 31 Oct 2024 15:00:25 +0000
Message-ID: <20241031150033.3440894-7-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
In-Reply-To: <20241031150033.3440894-1-peter.griffin@linaro.org>
References: <20241031150033.3440894-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The values calculated in exynos_ufs_specify_phy_time_attr() are only
used in exynos_ufs_config_phy_time_attr() which is only called if the
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR flag is not set.

Add a check for this flag to exynos_ufs_specify_phy_time_attr() and
return for platforms that don't set it.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
v3: update commit message (Tudor)
---
 drivers/ufs/host/ufs-exynos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 2c2fed691b95..0ac940690a15 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -541,6 +541,9 @@ static void exynos_ufs_specify_phy_time_attr(struct exynos_ufs *ufs)
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
 	struct ufs_phy_time_cfg *t_cfg = &ufs->t_cfg;
 
+	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)
+		return;
+
 	t_cfg->tx_linereset_p =
 		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_p_nsec);
 	t_cfg->tx_linereset_n =
-- 
2.47.0.163.g1226f6d8fa-goog

