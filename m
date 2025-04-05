Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B36FC3;
	Sat,  5 Apr 2025 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743863839; cv=none; b=gaBI0ysq1mosEbImdz3BlRXEn97lIyjbfL9d35ebpG8V8Sk/ZOrnL+E0mFnwPKAkQJKEDa1hkXFpVMyDp/NkO6T+uvgUDYHrku4IiZNvrS4RoIrShzUdF/8P8EuXSdbjWmvB6vsd5C0zi/myFtgXLf01xrjIhOZiff7TjBety4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743863839; c=relaxed/simple;
	bh=63F5xTkitsYyHm/pyJpFkBLkPS4nsTIzUTBp3RDPaz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fu3jwB+MLklkr9ZsJ4jsN+Mk39JggcHAYJO6nke8qe8U6LlZFhIol8Tnb1H+HPbDHjIq0+XNjZbKAy6gsJedCJeRajeKlhXx138f4cIjim7NKdb6bVMH7mGQPF0ZaHiRkKh//uP8BWhyu7mysba/CBaxAmprdF6oFK9H0tpytkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKLKaFu2; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKLKaFu2"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso27363255e9.1;
        Sat, 05 Apr 2025 07:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743863836; x=1744468636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87i242gNmmnQ0/JIgcQs2sxcKZ2HnRDUKllGCKseh+0=;
        b=LKLKaFu2cjIH+fPmUKzuD2iKy+Rtn9w9v8hUrhO7wfjwluBWy7OLswGpKymvFCKkzr
         bHJNohNjzM+XMkBpiiMqrK7ONeAPUcLKWmfpP5TJtaIe2uiXIjPGNeR0GK2fstX0wLpa
         u5uQ71Z+aeTIK0eu9bXwXWJ2H/SyCuDlitC0cjxwW/oEdeLr5ij/uXvqmWnn1MkluMMX
         6bdNZ8GUPK0LJYHlxAMGR0W5pvlLPiMaf9UA2uXZkY9QaU7bDF/ymwGX2tEk2nur0YG5
         UE9F+Sz/vULdmcVpYwQhkUTPb37zUVsH+rSObJNPk3KAJ7HyyzxGwR1qNqC8jkKjRyY9
         TE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743863836; x=1744468636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87i242gNmmnQ0/JIgcQs2sxcKZ2HnRDUKllGCKseh+0=;
        b=THuQsSvO1jGi0B6/au8SntxZtYYW+91jOH/f48G4lcPDsK/Xd4XirZ64NRrOo35bLo
         9EDivRF9zYX4uQbBp72AOke8f8OyZns+j1oO+2WyaB+/ZLKh2ZbV/KijBGU+dNH7jXYi
         wxMOrJs/livgIAP1jJXudlS+vTY1VHrjCtANsx0sejBpLI99hbZ9jjFeWx1HQGhaBQpZ
         u5+/lgHamaayQpDnaPBpQ2IeBTbEuRoDTpm51HVUxiT4OvK99IUfy7Fp6cy1nbFQjQXd
         ZHzwF9CmlqQI8JFvs9IhYdBXa3CPJMEhIy/cjT8EoRVgKN46aNC4QD+rPhVOKB9/VUhC
         4c/w==
X-Forwarded-Encrypted: i=1; AJvYcCUkAtmCgS/XvPjNpHitedechDxkMgYvnSpU54oTJ+QNxtv2L83K2KHgVvGesOgITAY8mpN8VsAdKyi24LrC@vger.kernel.org, AJvYcCX0eD9+0XDcSQ5088Xd43xRPtiuePp/Wnhc7rUuaYKUgMI5U2VfhQEmhroCqHOv0Rsar+RUN1KOrqGxVSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvlKqNBpc8HksIawyu+JkdWMKVR36+u99bGCnZ9aZCJoS7T7DY
	tRkHonPjIeMzuEklutcX43hB3kPWxKTK7tE+k5U23ri6Jk18l4/5
X-Gm-Gg: ASbGnctazEHKpXqrRT2x5P1ZqhJrK2/JGbQJn8aInfk8Rf4hKLEdrh+Ef7tZ/Pi2aKY
	s+3Ly5SDKmU5A9qdPH7Ijpsb5vu+QZXNBWh/XSXcsJkzfQuotKU1nsFz6m8IpqQ2fZeuTYBYSfn
	COK0o5v8LFKNq7KxINFB6J45xZkPc5TGqOflXgh3EA6vOq0dGNuq56KEt5itjSfAr7lGIdtvtfB
	sja4CNqXbF5QlrWAUABKFd6TonMUNDU5piR4kXx+VCuM/65BPopaQ2FuUAXfB5x6ZGJUQeV28Iy
	Gb4JoLx0w/KLIxIMIpdLBGZYLf2/16YKsbQOPpNrdeefLiIWQf5oRrok51U=
X-Google-Smtp-Source: AGHT+IG/l4yCRNfI7DOPZyV8ReShUgrZ6Qt3TdLxndrrMT9p3qU8mq+mnkWp4ubxVT/SvOshXTzAcQ==
X-Received: by 2002:a05:600c:a07:b0:43c:fb95:c752 with SMTP id 5b1f17b1804b1-43ecf843e91mr75410255e9.3.1743863836147;
        Sat, 05 Apr 2025 07:37:16 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3009644dsm6964693f8f.6.2025.04.05.07.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Apr 2025 07:37:15 -0700 (PDT)
From: Baris Can Goral <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Baris Can Goral <goralbaris@gmail.com>
Subject: [PATCH v4] scsi: target: transform strncpy into strscpy
Date: Sat,  5 Apr 2025 17:36:47 +0300
Message-Id: <20250405143646.10722-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250402204554.205560-1-goralbaris@gmail.com>
References: <20250402204554.205560-1-goralbaris@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strncpy() function is actively dangerous to use since it may not
NULL-terminate the destination string,resulting in potential memory
content exposures, unbounded reads, or crashes.

Link:https://github.com/KSPP/linux/issues/90
Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
---
Changes from v4:
	-Description added
	-User name corrected
	-formatting issues.
	-commit name changed
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

