Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EC015AF6
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268098; cv=none; b=ARqlrsVGnG8dShD1Xf4B82Bx7xu9fBIQuzUfuivoWDBH8RMHuoly/xls0QwmhYJcB+7G+PLtWtwws+Rju/Ldj17xMi27JR6ABSoobt/4nG3mPJGU7ZONBCCgb5UUC1qo9Jm0dX/WOHxza1ulldIY3i19smI1Q+sBskKbMmOsQs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268098; c=relaxed/simple;
	bh=G3yrRIzvT94I4V2BES/ds3KmUu9J7GH2WmDcheXKNCM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X9lzrZ9jVRCOyjtpjy+M+GL/4R3wjMP/voqCKJe1eO5Fy9nYHwNdBqcEiBjYEx6Sx6+2Wi1rDedkkuW05S0UN4YkPIUwuQZ6pE30fJAOyBmAg3aTNpAfvF/3pd9yr6CPlD2jSjEOXERJCdZvilrYG/qdkdHqt1/5AtmAWBYhEIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X+CVzPPP; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X+CVzPPP"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e2eb9dde40so3129263a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268096; x=1731872896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUgcLbf0wPXFxCR0F5IBMVuJGXazgSWCkI+Kie/ubw0=;
        b=X+CVzPPPyUxqOxFSJM/BTComi2v8PYjJGzmk+sYZnHlFa9juatDcfqZ5ghV40zi1P5
         WYz+zd9jXUvJ1i3ZJJIvL1f+mXg4fcrjlVYpFBkIDLglNoFSLS+KwFtJlwNHzBw1wRpv
         E3pXPplDHf7USVGAnQGhaFYV/q+TwNTLzg/Ic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268096; x=1731872896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUgcLbf0wPXFxCR0F5IBMVuJGXazgSWCkI+Kie/ubw0=;
        b=q8ZnTXHmHaNUYl8Lx485h42eZ8hzCkCYtOzguT2sVzDehwgQud8o4C7sFMkE2AItDP
         uWcKqdcUgvER+nXdfAPBuXOG6e3M2B730Z9aekAmHncPkH77KCqjcOC+ZGgc4XVwYAtP
         EEIjR6Bik6eb8WXRlUbFnlavKchINlHRchZioD8SaZFvvSsdVXKojzYStEkPmkftwHxb
         Vxks3st2XlYGMT7rFefTMvZJ+cslfb9KLFOmOk9P+LlrjKw51sVuXa1Yob9qIwRh90p2
         nDNaCncSVLdm945tpNKS+v/Atsd1CE5jExcuzmoX2dRJDDmodqQ+FYKleUkQGxSBnt6J
         z/kw==
X-Gm-Message-State: AOJu0Yz4a6t45cpMAkhKVkIuZKq0SBr49Z4TgVPjdmG8Q0G2Ci/MbEL2
	hp8BkXBiB1kXJqr+OJBdOptZ5gqGLWkcuDmZx4sURbqRfoBKiupsUFJ/EoLGWCkydPIN7HXn46d
	QNMUtAQw7pa06I7h2VQj44Wpsr8middh+TDDZUx6ujx79qQUGpwsercJa4MWr8w8ydjjnRcB27m
	U9jGphSmJNDU8e476jCNZv+AAwAgkEE8uvZ98hEaeHzo78lA==
X-Google-Smtp-Source: AGHT+IEFGdtW9Hzfd8XSakKrr6NtIJx0hITvqW+bHVMA5hJyBdw3OX3zNncDDdHDt6gw1hOBI/Hakw==
X-Received: by 2002:a17:90b:4acb:b0:2e2:be64:488f with SMTP id 98e67ed59e1d1-2e9b1655945mr14387889a91.6.1731268096298;
        Sun, 10 Nov 2024 11:48:16 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:15 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/5] mpi3mr: mpi3mr: Start controller indexing from 0 in the driver
Date: Mon, 11 Nov 2024 01:14:03 +0530
Message-Id: <20241110194405.10108-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
References: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of displaying the controller index starting from '1',
the driver should display the controller index starting from '0'.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f2f67acf8bf..1bef88130d0c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5215,7 +5215,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	retval = ida_alloc_range(&mrioc_ida, 0, U8_MAX, GFP_KERNEL);
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
-- 
2.31.1

