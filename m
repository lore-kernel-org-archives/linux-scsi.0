Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FB8615A
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731260269; cv=none; b=OzPcHy32oo3Jow320mFUg8x8qt7qh0SKKSW8yORk3BnJ7X6WzFdvMW9BljCv+B/fZ+WEtxY71t9ElAbaoxXLZpRNMzJJsztaIXoUTP3rph7EHtYd0PDdntK9MG1scfVVlOImHwuwXqNXpz5PdischMxqI+BTNbgj6cZUu26efNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731260269; c=relaxed/simple;
	bh=90sUhsQvoF2GTKodkb8Xn8Uvo9/wCPYRkJzEl/H2+6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=asKkP8SoOAHt5ovxN/W6WsES+xzeCLy7AszEV82Ad03cni9QpL5pL3/8AbAn5ohOAvpyRflNgxoEV2xMFmhHk6w/0eRuvyEwEEtOSvtmYOKnZvGyekxTJ6a9qwZq6W/5/qEFzDkFrFeGznqOrzHokfqmciW7nT1dQGBRKsN+rR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OUPOLtpJ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OUPOLtpJ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20c8c50fdd9so32654475ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 09:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731260267; x=1731865067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ul5sJQvLKhfAHWeRn4NzJgwdS/Jt4hdE61XZYFeULrI=;
        b=OUPOLtpJvZpMjjUgn6cYFXwo3VbvR+2ySRantcXf0JeLsOoUZ9Vyet4JqGXQUGpLhh
         84KWFCpPmyTea03LPkRzCOkFHWsWDvTLNFlGtzc8I7W3cbnihE7Gbh1EdgvwJ0JT00+v
         MiMHIQjFI8RiRRFJ3QSvowqKLDLb2exg3boRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731260267; x=1731865067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ul5sJQvLKhfAHWeRn4NzJgwdS/Jt4hdE61XZYFeULrI=;
        b=Sav+ZUT+GS19OZ+Jt8YtUArjhj5sKeBhr5PAgFHMCH5nop/XLfBS3W20tbjfEMjtpZ
         zcAsTErtmaE05vAIA6oGMbhB1N/HH1J13G9yI4YSZ6uCjECV6qTGP+Ajm2Aak46Elk2A
         Z+sJEvnojEIaebOTOEGpDZEaeqA4AXLZjAKp8HonawRpoLoBlP/zPptgtf+AmGlAcMMo
         FmyLDdRIAPNQAvuxM7QhjjF/YUjbX3+MQT5T+nkZy9uorP6FVlxfG9lYwDOE+LJDblNb
         eE/oB/JjrjcuR1gVLj8I789tuWW6HJ72ebjRIgZxu9K31ElHnQWYLwkzWFQfTh4aHZEt
         5t4w==
X-Gm-Message-State: AOJu0YwglZoXgBJt2nSpXw0FzBDVBaFXl4ZAxinPzfJYQ8j8YvlisjT1
	Z92SP/bl3BsipwNLxpbpGEd/CuxQgZ342I8ZOaw1xGogepZdfh6+e63qRUG1fr31hUzF4xsdaXm
	IApkU2Le+VGJA6laSKJv4hAkEikvcJCuD4kfCsudHqOMVpqbFc16Zhs8lpsqjzzQZmsPgt5mBOR
	hm9W2Gzq/HZ/dgfVLYNbghjCIHH+ML1LHJt6AyORoqQhTw4g==
X-Google-Smtp-Source: AGHT+IFb55Hdulb3wGPSquhkn9F7pPet6dZ7wnPpRjCE92/+LIDgH/8+2HFYN6pgsVwbJZBjFvz1TQ==
X-Received: by 2002:a17:902:ec88:b0:20b:4d50:e4c7 with SMTP id d9443c01a7336-21183554ad9mr157283765ad.0.1731260266732;
        Sun, 10 Nov 2024 09:37:46 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177de0447sm62314465ad.109.2024.11.10.09.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:37:46 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/2] mpt3sas: Update driver version to 51.100.00.00
Date: Sun, 10 Nov 2024 23:03:41 +0530
Message-Id: <20241110173341.11595-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
References: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version to 51.100.00.00

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index eceb5eeb4651..d8d1a64b4764 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,11 +77,11 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"48.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		48
+#define MPT3SAS_DRIVER_VERSION		"51.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		51
 #define MPT3SAS_MINOR_VERSION		100
-#define MPT3SAS_BUILD_VERSION		0
-#define MPT3SAS_RELEASE_VERSION	00
+#define MPT3SAS_BUILD_VERSION		00
+#define MPT3SAS_RELEASE_VERSION		00
 
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-- 
2.31.1

