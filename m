Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076041A238F;
	Wed,  2 Apr 2025 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743614714; cv=none; b=qxiJXrzQ08wrA3wpUTOec9DhsI3LA/pNvUlFIUZKtfI/y5XW8hkDT+gbGvd3d0WMbnX32SNKjbBzIzyLwq3lG66UiEC61n3G9juKj4cGiwu0vt1QfkGPf+uXOinES1/Wlf79N+4kh3gPSsrNzC+2wdsk7L0SG34qoh0ofZM/s78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743614714; c=relaxed/simple;
	bh=0I4gf4qOzqd/dz3inFosaXWL+uusZbW4kRowm48cadc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QyJD3UnYgtUhl+RKCk4B54LgSueWrDW9TpmZADDQqUSGQ3wFyEDY/l4bs517j2hrI5WLA9vJ08yUqYl44It/clrE+0FWu1gg06vgz5YtQPh9QuSN5kWrcYhaE+gGq0HaQ3vQH0a5xzIf04WgE6oek1x2fxYGA0lHTS0+rM0gJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUtoo639; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUtoo639"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43948021a45so70863735e9.1;
        Wed, 02 Apr 2025 10:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743614711; x=1744219511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VFKKbFIB0gA4Lwa0ZRTmZZ0kPFvmHe9B0sAjPCWOPmI=;
        b=FUtoo639ATBvmct0wFF9rZZ9PUwUeUQEaOQHmXvgBzU+Oth9xtYY9EJiIBMxXNdXBT
         iovPYiAYS29GY6MeYgFW0rADU8gZ2KHnQb9wvwewHxU4ujLx4zXjF+0HUGNb/VYR3cVl
         YncOQXrbbmFB2+ulbit0rZX7ziZ4jzYVloMYq0liVA2Q+WYJPxB37KjjIXaOtQlDPDMQ
         /Nclz8tzIVcywI2ELBfZQoEAkpVQy5slMZqA7w69nZWHfWF7/c5Qm7cXz1wf283WXjhI
         /eR795DuUH4RDLZSd8C5PPza6ziw2gzidxdjYbxgsTYiR0jd2d+3V3tiNaUMG9/Lwo7X
         hxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743614711; x=1744219511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VFKKbFIB0gA4Lwa0ZRTmZZ0kPFvmHe9B0sAjPCWOPmI=;
        b=U2KLxb3dUuMefpZVHEkTvIssqiIntMPqEsii+3zYCTJY6iKEyf4+plXDzpyJZHzm4r
         O+bPh0L9gAdIEpUjskp6lpPlF9WBn8541Z2YB3gcOVxcCUopWrhV7AcEJGl/xjbHJ72f
         uq1bpGa3GhN1QGY/Mwyp9cdJ8wj3/aFCHc/Ala4YMGoCDpO5AyuR6fq7k63F/ybG8laB
         KXSgVZBVXnW3448DIao5/KZMc22FmFmPw7SIntYsIR0td9bLDPUdBsUOMHeqvWBwMHoS
         gZhrlTXNE6+MarPHTpGSJUEefCypF0dLTPkKtuKSTOgruVj/PfEPml6RbYTQ8D7EJ3Vt
         AiSw==
X-Forwarded-Encrypted: i=1; AJvYcCUaCo24DBHxdWG+j77Jkk1zPG/kDj+hmxMEoVzxhY2/+XWt+oOsHdyQfNAe4Jc/WgVa+dnSEPzHAW0PPso=@vger.kernel.org, AJvYcCXHq9oUkDvtfX6NNur1Z1eVQdxJbBuXrpHM0PiLEXj7V37mEXz35Y/oQJE7IcCaEYucVvJVItiOetRK8IBP@vger.kernel.org
X-Gm-Message-State: AOJu0Yze78N8RGU8UvNuRJBFi94Gp0qkPMYDozHngUr2zqWoEtaKl1cC
	LFPPdWU8qHEJN6rX8kvLTKnMlNl2sqYvEs/6Dfoc9yKW1GILnDol
X-Gm-Gg: ASbGnctwtCGovhzOYu2k4Q5GFb5Ce5rJWismIlLSvjFgCb8GxFejDY/65Qz/sfM7nFh
	jdRODcoML13DdYAjlr0ufMVJsY0SriULdpVFOL/4uLzGgC+U/vRl+BgnEzCkACOEGW8cQgN1ej8
	SgpEXC782t09JH3HDUqGP8/qLUJaktrBs4xwhUztAoDkZMap9Efdw6cnSaJMectvnHt6NA26U6f
	EgBNgv5MGFA5VFIw8CdJSlSqqi42o9PSXSCCvpHzPROv6oxxTW3kYtrrmhtquR9+pyNme8y8d34
	QA0vyOraQCRD2OcVs/Phksb78vLuo0B1t8692BHlHgJGQ80qe7PRVvsy4IA=
X-Google-Smtp-Source: AGHT+IFoN9OKQZvEAPW0TgURl/4JHMogdjPbJRS9b++IQ3ngDtteLtDe+TYiljYQr3uSBN5W86+M1Q==
X-Received: by 2002:a5d:64c3:0:b0:38f:2a32:abbb with SMTP id ffacd0b85a97d-39c120cb586mr12147320f8f.4.1743614711132;
        Wed, 02 Apr 2025 10:25:11 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e0basm17854445f8f.63.2025.04.02.10.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 10:25:10 -0700 (PDT)
From: goralbaris <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	goralbaris <goralbaris@gmail.com>
Subject: [PATCH] change strncpy to strscpy strncpy is now depricated. It may not NUL-terminate the destination string, resulting in potential memory content exposures, unbounded reads, or crashes. Link: https://github.com/KSPP/linux/issues/90
Date: Wed,  2 Apr 2025 20:25:04 +0300
Message-Id: <20250402172504.101576-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

