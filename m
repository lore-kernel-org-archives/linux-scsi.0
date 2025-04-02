Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB97E2E3360;
	Wed,  2 Apr 2025 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743623153; cv=none; b=fYnMsFrNrxHr3ptaprqvZVtXcHoZRvBDzA1+EoUM+F60bsRtGcFd9veP8nFNZ1b3KqazyTkYc/+ganm8i871oNcI5Y9iH2tjLCqXF8qWRzkiZ3a4qJRU/vP+cbVc0pu+T4gCWssQqMEWdMSxkXSH/DRvJz5iaqBMy3RsvU+BjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743623153; c=relaxed/simple;
	bh=gn+dqD8kHKTwNOr095wyo0YLN79ewCDgi/1n3vknIDk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CQyOXMVJblOkPbp99MFZcez6XClAyMd740+sT+/S1S8a2rau/Eba4Ymi0p40rE29gQ0D+UxpG+XrXFhYU8+Gy60PNjkZs06FYrs1eA8cs5eUPLyXeaCdBPnA9cl/zXR2HGD9khKV55RE/6VK2efxC1ZmWDpTgt78BCOTOUKwdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KcoMfN0t; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcoMfN0t"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so984495e9.3;
        Wed, 02 Apr 2025 12:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743623150; x=1744227950; darn=vger.kernel.org;
        h=content-transfer-encoding:signed-off-by:link:mime-version
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5CNQtgarLi54ozXaIyLzjauBHWd3izyv2KLVPB+Zag=;
        b=KcoMfN0tc6a4FB3/NTbedgw4BxqllX/5VG5gJraLqaFXqrHyyYwLysOJ5H0E92tzg6
         AXekr3ZkBmPfxOIiLOi5t1zwL2vXgmzQevRyPsXBIyzvOPFA2RuEwyNpx8S+1zbDrlF/
         /Br/C1PX3aJkCfY7ZqnNn96w42bA5TwV0hYkYhRdHRuEso9l2LBIhfTB6qenc79A1h0O
         xWh+cyzrplpNoG3A3GJ529a5eFaN7N2FSP8+LGrqMUmnJZnPWedsDhmDMe6JzdA2eXiA
         XUtxe42IyztZy2FmFp8Quw7eDLE9Nta2NZt1zN6001wIwlDSIXaZyEziLjoqpbStjXHS
         etbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743623150; x=1744227950;
        h=content-transfer-encoding:signed-off-by:link:mime-version
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5CNQtgarLi54ozXaIyLzjauBHWd3izyv2KLVPB+Zag=;
        b=RSzNqlnbJ6Xw7CfQz95U+fNE/6s1ica2/SDd5w0xCWOlMgF8s5etw8/G/P8XJmKstL
         1pW+9I7gqOLOEdeYKGG62RfDMowwb34GCKsPs3w+4UyIoZIJ1sWZh8ZOAyfYaKdjoqr5
         A8wibKQmJk+8dXl3JWWl6kd+OK98/wGXvgZaGY6dczYxeyoiAtoQy1oZBQpdsDbioszF
         hdQZ6CtBwyI5UNFwkwz8V2ANqEQtNsrmrUAeHJnVdaa1VYswb1zupm0SG0+b5m80tlbf
         q3BJMlZd41pbf0WhmGNpNr1QVaio4Lw26cX3joTPcANu01JjD7B66XN+ym2ugNWj+m+L
         7o1w==
X-Forwarded-Encrypted: i=1; AJvYcCWIFOt0T38NV6kAKWSTjIynH3NPZGKwz4pU3DA0z3mJQQmBObhhOrb9KOMqx/j1nKZtGl9WMhOLEp5vitcY@vger.kernel.org, AJvYcCXjkTUmerhKHvZ6MhIQQNhRhAE8cstm2yT6CuFLmsLhKPZ4k5WtrJyU8LSakq3KVQHahm65vmNPIQ4lFZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0B7toMhZfJCWtZ6D+vipJ726cmNc5ARkjReZZvYPuNCXTfdeE
	2yV3Jvo4dVKQMQVDdX65oRzTOdcYZBhbDvqrdVWZzkXNjH5qSTiQ
X-Gm-Gg: ASbGncu0XxNbhHDTgjFgjuN2nbw3EqgTelUR+NjX0iT6uRKf0Pbcruyu/6JfKcemHjy
	zRE+U4fT9DobLo/7CorEp77Wx204g6Iwmu6E/O70kQWiUORJKe5MHW1OMYLgJPw2m5QNDs2x4rF
	zNqazF/bu03fpdXmsm6rp9PImwtwyRuSXjhgI1r50BPcM15dm2f4OLdsq3gbN2QzXBNyPmNuf2H
	So6ajWs5SrHcuzcixqpjqgj4PhR+hdtnNJ09o485cMD/+N1R7eb8tLDiAUiWfHrYffUiecm4T7H
	1IK1x3EKM8xV47hBl2R8UEVy2jsX4ijoUMs/ZoVT4+coKkOoV7eeUVldDsLwCstQHNL5Tg==
X-Google-Smtp-Source: AGHT+IG3x4qoJSXA6gTEIfgC39jrq+mPmuEnWmWyqOZlkJEE9EwdmcwoJH4GOTWhm3kskgzmWXFimg==
X-Received: by 2002:a05:600c:34d1:b0:43c:fffc:7855 with SMTP id 5b1f17b1804b1-43ec13ecacfmr789565e9.15.1743623150078;
        Wed, 02 Apr 2025 12:45:50 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb5fd138esm30309445e9.13.2025.04.02.12.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 12:45:49 -0700 (PDT)
From: Baris Can Goral <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Baris Can Goral <goralbaris@gmail.com>
Subject: [[PATCH v2]] transform strncpy into strscpy
Date: Wed,  2 Apr 2025 22:40:11 +0300
Message-Id: <20250402194010.194562-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Link: [1] https://github.com/KSPP/linux/issues/90 Changes from v2: -Description added -User Name corrected
Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
Content-Transfer-Encoding: 8bit

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

