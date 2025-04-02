Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696281EF092;
	Wed,  2 Apr 2025 20:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743624708; cv=none; b=ZYWqSr+zB1pcy2Ew1zDsJ7KZizLJh3C0QjLOrO+qE3yXqHAIo/WXa31Impbdql39gqY+Sd0JhjdaOyjL4F+iA0yJQRqI0jmFjBDEXe4XuytU+IR4INcg3uGGcM+Q4fCkBvJHnKdU4/j5V0Wdb6OrSjHFPN8eNfcedyGr75Jmyzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743624708; c=relaxed/simple;
	bh=C1PR5ak6BaQhI/cm5C1E9zZzBcveWm4cZ7+iHi9Dj0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I7HWjO4UGDPOep5BXb+7D7I49kuq/n+YEwmC/DthDpA3hrZ8/opvRZTLBw0ypkTHIqAqRtdvoGQItooyYcdOwMLqaSFiiupYOcmlpPJMXg2yvkUUe57su8NYqawCrYy1XyCA6P8OCIqLZo0BHGAZtRMs3bIu/rMY3wwQ60PJLvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZ0uGd4G; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZ0uGd4G"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-399749152b4so135170f8f.3;
        Wed, 02 Apr 2025 13:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743624705; x=1744229505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bQ8M1xr/N2skOjel5u1xDDMGxqw4id4IVIFe/7m2EY=;
        b=YZ0uGd4G5u9AH8XX680uX381ZxlIz5+4ocHyOOGgTAwLBgVNHYsTXV7wpLrIsMiCYS
         j5E9WJjKbtAZl3/bcv4hsQQkVBskeIOhtSc5uhQbQE+z28ebeMU361hzskzak6zhiAOv
         aN42y3mQOTDy0fBSdo8vzKjzPyqZ1eQh/u9IW8NHqfPno/aJeHHqHYx8Z+CyiTdZ7lpC
         mIfE5orMyTIvOUwRysiCU6OPo5xGL5CcSuBw9BK4+asVT+E7k34MTB2YZ+HwOueT00Tj
         GJuCg3uU7ZquO1CZ7+1QwzHTkxCD9AoDM5e1oJ/YWGlk8RiiBSIzAjgl8wCGR3xxsFlP
         QjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743624705; x=1744229505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bQ8M1xr/N2skOjel5u1xDDMGxqw4id4IVIFe/7m2EY=;
        b=vmQ3oAmGvubngjdX01J1SkvF5T/+K7jXzo1H9BMd9aeDw31pEdSZ0T0Z2Lw5yckM/T
         tA8WXoh2mBLGhQMNiQMOSNJw7NFvXq2DcvMe8jSgD+GI3Mi3rEyQIgi7mjePyEgNQvuj
         jyMIIfJWlvt3TezVxTjTRxgzzE6eEcuRq7m2B2Mg8CmmJCH6lEqITAp77RRguUqGGUkI
         8cGX39NINn8LPutUNtaFpMWYak6Bb0i1KZ+gYH0O+WXxTTQjPrOXbIzr27G2EA9/K9Qk
         +sqZPpDASjqulhtz/Z+jlLoChfWzvC/3cXt+KQo4Wd4Km1d7rhiUk7qu4FVJUgcfxF4w
         fi0g==
X-Forwarded-Encrypted: i=1; AJvYcCVwX1/I80OMY3z8rvuTJi6pljmRwFJ3pvozF4ycyG5bq30nYI0kpzfyoj4DSfRYtxdGJvXmADPOGqtRW00=@vger.kernel.org, AJvYcCWWtlEGI5x40d+l33hQxNprQsNmHPX5lAJve2h8CbacFeaAEDWydWz8xsPf37+WiqLbafWVgTQZ9mcjRWv8@vger.kernel.org
X-Gm-Message-State: AOJu0YzGf3j8Y+61dxT4TJq+b6lxbcR1Dcqe9UVZ8jnE73aPLUHb47lg
	YN7Rt8JhRw55tt5fsjKY8E/EVNokNEG/BoqFWYYY0ZfFyuY2xJBr
X-Gm-Gg: ASbGnctPFvtG20ayW9bWgNAOx378tGcZUwS8Qc15Z7uNLiAId4Fv81mekWai79rWaYO
	7ycFRsrKy+SL3u1vSbpXTcGt4JcQtQNikhud1iJwoKkVBP4gf/zM8xWTg15/0D6yS5L85C/Ckxp
	0v7GYCIsdOY8CGT52+KbT31kMo7eDG0duqL+o4dI6UtQce0UuDmES5Z8PQy5gTVZZlYy/G4x8Sb
	ST8/mj4qXzp2J0Gd4G+APmGxmkjN0Mnh40qZOBcS2aCDJk2Q5XTBzFporkQhN9pFM2QZQPAZqc9
	h5BQ99I/gNMQ7X9W0U2ZCtjSLMVbF9Lin91eb+zAwlCFfeQgANxS+VgJ80gUKFQEEgKiWA==
X-Google-Smtp-Source: AGHT+IEAwYw/iWvyS3ZlRdO2/3xlQfSJZ7j2jpAzqMmakmE1R7n7fAR+0Gy9tZS3YLwRWhN97nkH+Q==
X-Received: by 2002:a5d:5c84:0:b0:391:489a:ce12 with SMTP id ffacd0b85a97d-39c2364fbd3mr6633261f8f.26.1743624704298;
        Wed, 02 Apr 2025 13:11:44 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66ad1esm18128953f8f.52.2025.04.02.13.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 13:11:43 -0700 (PDT)
From: Baris Can Goral <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Baris Can Goral <goralbaris@gmail.com>
Subject: [[PATCH v2]] transform strncpy into strscpy
Date: Wed,  2 Apr 2025 23:11:07 +0300
Message-Id: <20250402201106.199362-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250402172504.101576-1-goralbaris@gmail.com>
References: <20250402172504.101576-1-goralbaris@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Description:
The strncpy() function is actively dangerous to use since it may not NULL-terminate the destination string,
resulting in potential memory content exposures, unbounded reads, or crashes.
Link: [1] https://github.com/KSPP/linux/issues/90
Changes from v2:
	-Description added
	-User Name corrected
Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
---
 drivers/target/target_core_configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..5c0b74e76be2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage, read_bytes);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
@@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	strscpy(db_root, db_root_stage, DB_ROOT_LEN);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
 
-- 
2.34.1

