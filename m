Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF82205ABA;
	Wed,  2 Apr 2025 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743615804; cv=none; b=Bf7fxA+2qADiu23aKVT2LLr2JpwsgvG1undL7i84aCxF1LMqf4P74gN3zAbI8VQxY2rLnlS2gWhrNrt49ASxFICTr1cUAEAcHF8bCsJwPOkArc0TvDLzidG2/Db2ijJoi/QuvT4fe6yNLDMfVVfau4s5WZ/Vk5jMi7OgbmxUQjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743615804; c=relaxed/simple;
	bh=EdEVmmkX+S4GMM0uG7YW19UqaiTt/5KBZ0AUymRBHvo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IPPIecklp6BNWSu9OKf7p5Q9rcnWdi125Vz02FXYvZxcaQiGpIZb3skGcsJWz4LyBnnPFbcV5T4PSItkGApORDsttWHTPZE53qM0JxmjkQ8PcjMj+Oj+xR+wMIS1qnGhfhgzHbgpI675vDerRqDuXhEu5JPgJByK1rW78Gf8aVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RN14Bfu8; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RN14Bfu8"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c1efc4577so49134f8f.0;
        Wed, 02 Apr 2025 10:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743615801; x=1744220601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=85BXoAka61PsKzqS2du3Xktdbs8BPrJV0lx84vuPwX0=;
        b=RN14Bfu8q8sCldYFZok/gsGQiybnsymLWZ8xe8bms1OQwUPcUbuWjz3uV8ouhf/f8T
         hM1MQ5vEXgsba0seob5UsqRKRrP/axdlyyBfkui6gGN7W0GpDQyyGqmoJzA/qmR/vgZV
         vRuUNgQrkyJs28x4tVN5OOUeGIRFLsxuVjCXv9+sxubrk5NO2/LaF1e8iA3Pwq35UjEM
         a2sDkkZi76l0R5cGJ+v0HezrQ0TtPpGOGwQsAPDyPgQeeA2YOxFjNGYL6KBfhLS/6Ua1
         JcSF9Yi62lDgkC8ML6MVBBkfUNyVjO4qigwqN9YqkX1IjlNPpAw5Bi7by7wjIDQRXWeD
         UBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743615801; x=1744220601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=85BXoAka61PsKzqS2du3Xktdbs8BPrJV0lx84vuPwX0=;
        b=onyaYkabyD+MkheRKOc+ELO0Bh6r1GdE4AOIwXVneBoVkIeCSnMpExyVOxIifQwG2J
         6+qBcVwxBpOo3mdd0jdgpa4h/f/y1vqoKsFeAD1+guWCHlmwgqTXejSoj1cvpMK1/DoX
         xv7dPx3uOXQ2P6cgc9VHAUks5GRivKxohT7z7ZjwlgA/qvn0rpJj4Rpn4Ej8jm2tsAXA
         C/W5CuSADENfZLcCrZnZFAV3NctK3ODSGPqiMDoPGmatbrWMD3J/pCsScxgJJBnKLcKH
         aMa6JBWLsanHdEUrvJSgPoWqUuKvT3S7DcXGujosLzMNYG1AwbeACgduNmlLLy0U35qK
         UPVA==
X-Forwarded-Encrypted: i=1; AJvYcCVYtMLcXhF/xNBuN1jvVgT371aEp84VTGmc7pqAFRj/0XOHqxodDbuvOwFaJkXh9WnHgMw6JXY8RaXpCo9d@vger.kernel.org, AJvYcCWbs+9ZBLrzBXTN/QGiZKUaqTz9I6i0Tt3BHQWuoV2bDQsU8Z0Dy0d2jnFE09YqjXP/BFWF82wefg4HIU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP78kANpVavePOwDD3FSf2Xqaw39iWoLTHY7TRJl074VN5F8tc
	2kTqGSeXnJOB5zT4xFGLKhJR8sV1DsZarOEmNzX0RvYJummLWX+y
X-Gm-Gg: ASbGncvTwO/doLm20dIW2lEUQ3hgbviQ7K1d9bvyynVMLrZl+lvi+Uh58nnGpKKLlJ8
	IQn2uNK5lUgnuNvXd4D6mx85NVPF5iaj5WwtppidSaEwYqYEg8+VRW18aeUFku9CauBeN5AiPHD
	C2bb8mTVaguIigV2Gcg+ZX9FJtjGjyfklfS66NqibuZZkFeR9pNShkZYg70zHHPvtU1ER3/92gE
	lMdvE7Vnc8QMq0SZ6lglL8jplzzYCMvCrTd77/VeKHxebXzmHgS3vNm1aCq+4x6hWq9yunmQHyL
	ClxpuHpISCz9orOTIx7yIZ8F45JBicehYIyMGWk6wx67oei6qUY4aZFokqo=
X-Google-Smtp-Source: AGHT+IG9DUifRlG9+hsS76jvaP6M4UBq35TMncCzYo6w9ipzl12h0GydswQHYbtTi42HbfpSVPpG/Q==
X-Received: by 2002:a05:6000:4387:b0:394:d0c3:da5e with SMTP id ffacd0b85a97d-39c2366aeaemr6560810f8f.47.1743615800796;
        Wed, 02 Apr 2025 10:43:20 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c266c132fsm4819700f8f.13.2025.04.02.10.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 10:43:20 -0700 (PDT)
From: goralbaris <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	goralbaris <goralbaris@gmail.com>
Subject: [PATCH] change strncpy to strscpy strncpy is now depricated. It may not NUL-terminate the destination string, resulting in potential memory content exposures, unbounded reads, or crashes. Link: https://github.com/KSPP/linux/issues/90
Date: Wed,  2 Apr 2025 20:33:09 +0300
Message-Id: <20250402173308.102487-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strncpy is depricated. 
It may not NUL-terminate the destination string, resulting in potential memory
content exposures, unbounded reads, or crashes. Link: https://github.com/KSPP/linux/issues/90
Signed-off-by: goralbaris <goralbaris@gmail.com>
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

