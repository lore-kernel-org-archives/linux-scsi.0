Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C026277CA9
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750416842; cv=none; b=cXsQfX1sddTFsq5Ac9yO4xsX1EmTqM7Jh9hdqoIwNFPOdXlwy6WsMBht9wYBx7HyMNXbHX++58EFMsXYMUVMaW6xqJObmhVKnD8+skqu5ShmCV8n2jbmEG6gZbzPMlxC7XuifOrHFaliJBxhsrdNznHVNbhefn/3pc4MTUHiY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750416842; c=relaxed/simple;
	bh=QRTWIyGgOAAKEJ0OgD2IzCvLBts70+f98D/alGUzt0s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IpyXY80WX0d1xbE9zTuVp1ZgKxMEkuuT1JHSyHBLJPsV2IpIenxQ/0G5M98Iz5o8M1HGvT2lLhG0sHXZfEuApt9KbULU5RdSeAYZCbnTvoZ7cLQI7gNLLHMCvkF4GzCtSwkc0tkhA1A3tbgGJOnATSboi06kjBjaKssqwqfeuU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aegp7+or; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aegp7+or"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-23508d30142so22925015ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 03:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750416840; x=1751021640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7lxX2jMIKqvJLKZnjXMFlZJTCoMffWFRvd7plldskzI=;
        b=aegp7+orWi1wF5MVsM5/5UQ0irnLZXOywsjyJCapSZ8ScdfT/t5ZH1jlrlxCnPs8pK
         m6tIENGmwJejfyl0rHxKY/5GkpLMpDEpZkGQ6AFFLVRBBhLFvK4+5wktDDST8NByQxa3
         qwNdQWDL4NmT8nF7395peXTb0ZhdUhxuNWbdwLn9ZJz1HMq5bjE7Qg3+K3zMzjMPaGWS
         WPNG2kDvGpPFmZDax40W6E3XNq/oQX/CXPSc44Ey8r9fj6Uji9YLb+vxvKoZ40f3+3En
         6JdUtuyATxupIZ5x9sm8EDf8xvwfhV0J4ziF3RIy1852aij+5A7aQs3ikh4vT4bQe8cK
         2FsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750416840; x=1751021640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7lxX2jMIKqvJLKZnjXMFlZJTCoMffWFRvd7plldskzI=;
        b=Sheh9S6JA6yHH2kW33tJqDeFpibzoKHdDl9iaQtG9QCde+FJ9lBW2T1uGEkh2vO70k
         vt8dd8FwOsBRcu6hQostxdhUJDWBxr6l3WZrJQW5/TFcctM5IQnv7EJRPsoLq71tuzhh
         U567GHl8RmOJuxF/LMD8G5pRGMPSdATe7SVFDrnKO7jYvOPBAPydfcQTMgNPG9UgQvDt
         5SeMt9QdXXVEisoDzYIvIYFSJINBvnvy7dbwzj7c2DrzI7vORyg23plJOxFwysLjLC4W
         OylcUgJ+vmrr0YqeC0A5hYHbU8akpzxdMCTFez9Ii+7hrAo+U5d31Onsu5+9eA7yQSq2
         D+uQ==
X-Gm-Message-State: AOJu0YxYmpCngwy8ZF8fZ52JFsv9Iz5vE0dDfhtd12xn4zV0D5E5kI/a
	46qjIr4arF741kRAKn1Ux81B8fkU21yixhsYZgrccrs70bE8doxQ1EGjSC7ZbqIR
X-Gm-Gg: ASbGncuuFB+Q0YnuMFPYX+YUGO90nqGPt7xfahzjILQbJVSOi8+EyT3x63tulHP3StC
	KM8qgcye1m5NKG48Zu2yypNktLYma1VJGQYm/3Y4+EizOUjV4vfLexsSel2WBPc+rfeKis/fWdv
	N07ulV98Luz4azpHwSqeLcL1iBs86esPzQ9MNoR/4JA3z7D59fm6Vi18HOLYT71yMuOVQeeReMr
	d4JEKSKImdeu4tm/S1n/KtTSy4uvbhjKnfImp4ruEUMUilbJEOuEnyHRK75v5Rhl7LBGat6nuyQ
	gOLatR/YR4pkUg0Fij8Wm8lLcsGHB4d3IF1Jv/OAjioiXojV6nIzuQcnKB2/3Nz0/ANq+XS6HHc
	/ERX5Pw==
X-Google-Smtp-Source: AGHT+IE4m1yne/Uqgn11e6fV2HYdTX8S7810B90ITpDDZ37Vz2Pse8Pqfo8EszkXKZWfKkvllRDQKg==
X-Received: by 2002:a17:902:e5c9:b0:235:ea29:28da with SMTP id d9443c01a7336-237d991f9e1mr42960285ad.17.1750416840381;
        Fri, 20 Jun 2025 03:54:00 -0700 (PDT)
Received: from shankari-IdeaPad.. ([2409:4080:e3d:e62b:23a4:8d99:ee1f:652a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d866b5b7sm15467175ad.161.2025.06.20.03.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 03:53:59 -0700 (PDT)
From: Shankari Anand <shankari.ak0208@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Shankari Anand <shankari.ak0208@gmail.com>
Subject: [PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in sdev_show_blacklist()
Date: Fri, 20 Jun 2025 16:23:44 +0530
Message-Id: <20250620105344.455283-1-shankari.ak0208@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Documentation/filesystems/sysfs.rst mentions that show() should only
use sysfs_emit() or sysfs_emit_at() when formating the value to be
returned to user space. So replace scnprintf() with sysfs_emit().

Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
---
 drivers/scsi/scsi_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d772258e29ad..074b02e4cf9e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1095,14 +1095,14 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
 			name = sdev_bflags_name[i];
 
 		if (name)
-			len += scnprintf(buf + len, PAGE_SIZE - len,
+			len += sysfs_emit(buf + len,
 					 "%s%s", len ? " " : "", name);
 		else
-			len += scnprintf(buf + len, PAGE_SIZE - len,
+			len += sysfs_emit(buf + len,
 					 "%sINVALID_BIT(%d)", len ? " " : "", i);
 	}
 	if (len)
-		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
+		len += sysfs_emit(buf + len, "\n");
 	return len;
 }
 static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
-- 
2.34.1

