Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB512194090
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 10:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725532308; cv=none; b=rj5L/EcWZKjBZsBPMNc4ri/ZOGDl7heMTd7oYpiQHH31IASd0P8DoZ3MQHaVdl4wU7RCK/2XX+yuU/XCfgdQ+om+EKTsi8sOGemcZ/jVZ5gLQRfUS06DOwVwLR/pzj5LB50OReiwH0ds1TnlTEvB0LQCZWc9/JFRacH0drDzGoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725532308; c=relaxed/simple;
	bh=itIIGZd+KvG2Bh9eLDqCdHxwDoyF+sOdyjwdth4ukUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RJzGsJMy54EjWYlAPPCL8aDLHRguA328Wao55o+hs6gQnPGiULA8f9XsvVtk6mjaUYBDH64UZGo6YuxQrSk+Qv969kOLdv50BDmAle2+NFKe4yVOqIcsxBEgHsC/Qe7k2nGEPqvSaG/+DXdiDgreKFtSSJSNoXNf5aNHqQ/0QiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=K6GAKzoP; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K6GAKzoP"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5daa93677e1so341758eaf.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2024 03:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1725532305; x=1726137105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SmI/7v8dAGJcvAoIs+PKF3uYtbsH1rDI4Dzop6dUNwo=;
        b=K6GAKzoPvoECAyX4tjGGScJDUp4UZe3TGiilfTaM3HXMqlJ/Gn+ISYnFqQCjcY6K3y
         M4An97P6MG1RBVE2xwj7NkRJvHgNGGk8vUcB1v7w3DzF+dBbpcGrjxQkB9+6rlNK8YJb
         7f6pzdQSruz6skcB33W5jJUDUfwvQb8b58hXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725532305; x=1726137105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmI/7v8dAGJcvAoIs+PKF3uYtbsH1rDI4Dzop6dUNwo=;
        b=ft4+esKl3JnjgvLhs+vekWSHErUGOsclehF4cizBH2Urqaq4DxcKuComlWCHOAW7hc
         qgfyzG710Nf4LjJrmLGII4pSZaptiBR0vA3Kuj3lzY+EbY1dN685xPhdN7iYWB4eUGVp
         v7vuOnW/+njKaQS+GaL77nejZzL5gQnCI1t1If/Eflq8vLBUTmGPUKbLdcbrLGkxHdJN
         1C55tuLxEUzaxLo+PTOce4Xz3ArNWfwk4RNgKBITP83M/jsjj65nVAmKZZ0EAXWBxsTA
         VpfmNE40bgchJCCcNWUgmqKNM565EDq2tATCV/M5j/dq6B+V7P5Bxc+nmksRlhOxetsv
         68TQ==
X-Gm-Message-State: AOJu0Yz5VENY0BjlLwIeqTeO2TrqWM2Lpan4bjK8TGXTQe99LO/OQSVC
	EKIO6Albf/bVI7aSff5fnhcPXFWuh9cshc0lwr96e1iUvqLG2iXv8+ocXa6KyOA1iSn+qj9CGG0
	clcvbNe8HaisKCEdyaNAbZ10RDU/UYdT9Q0xjYa1tc0LhfE5PQddm5PA8Mh0nuL491fA0WxcWUr
	yDzf+p0meruE4YZKjIFLggJfQ/Lncr3JvZZoGO7A8Ear+zpQ==
X-Google-Smtp-Source: AGHT+IFYB99DgC8GWnEDIu7GASvyxLJwSWAsK7rKZxcr1r/hOMHuz0YBxJ2jsn8X2M4w9rYBRL1F9A==
X-Received: by 2002:a05:6870:eca9:b0:278:c6bf:fd34 with SMTP id 586e51a60fabf-278c6bfff00mr6229367fac.27.1725532305072;
        Thu, 05 Sep 2024 03:31:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785364f9sm2960177b3a.87.2024.09.05.03.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 03:31:44 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 5/5] mpi3mr: Update driver version to 8.12.0.0.50
Date: Thu,  5 Sep 2024 15:57:53 +0530
Message-Id: <20240905102753.105310-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version to 8.12.0.0.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9c1d10ba24be..d937505d2691 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -57,8 +57,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.10.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"08-Aug-2024"
+#define MPI3MR_DRIVER_VERSION	"8.12.0.0.50"
+#define MPI3MR_DRIVER_RELDATE	"05-Sept-2024"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

