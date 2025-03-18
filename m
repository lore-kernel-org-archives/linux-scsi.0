Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8B41E51F9;
	Tue, 18 Mar 2025 10:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742293054; cv=none; b=c8i3UA/ThZo+kUCk90qcjP0ilb3jhSizcT0UzwlEQi5Ui6tiAemRtdNeeMNUXTnh6cx4ZxiybKhSG7uWeY8GNCnnU+Fm90o1UAYevBiWw1CwoRqR5TjWQtXFIvi+zPLW1eldfH0aNSPwkc0EWeFnkPmKRES6CoWQzRjltVjY0fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742293054; c=relaxed/simple;
	bh=v8ZgNuyaGMugV+F8ZVKn5a8JZk8CKi/1tSd5iT2jCoo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gZtW1xd2ZtO8BZi1HMgOL/HSvYLFc1DH8dmnGSu0Mw3g959iN3dQaLeiKq1RjyMQ7FcaK0DO0JtITZD6fI6N8g+j7iWxG1LXNAa31Byg9k97QbzNCz30QInFpaoKRDptiPdGGkXrngcKhdV143qQ7pAgzVx6wSf1m0E6z5mWAmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yyjv6L96; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yyjv6L96"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22548a28d0cso146908665ad.3;
        Tue, 18 Mar 2025 03:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742293048; x=1742897848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2FgtaU11zF0pRhnrSxlGHFWtRYpu795XLnDbFY7Zyq8=;
        b=Yyjv6L96/UclVaj+in1iVAt7VjK2CToFt0Bj4ItyXb/SGEQiKPZ0fzT1oCWrUeSmhv
         qCIyC0whR6HesEgNrhUb+s/fYh3nR6qXX+TdwmwBoaGuNdAHqgKY0RTZ5RVAAa/mXaKl
         6OxInzMdn2/2EbhgYreAoCZbvyAny/aYRtC1E9nTAtJJAHzmptxKmTT6JutoB44twf1/
         +OGJKS778qvz2PzgFOXqNnqjg9E4gytnUl5gahili7dsav0xFMP0qSNhVXuXTMMTxGtI
         dmFgExiS2EH/C5PgZjnxh+pGQ/2qnaXaZTnXGzEwJjhsE/9mzUlWDKXfpv/KEBYnTtlE
         wCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742293048; x=1742897848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2FgtaU11zF0pRhnrSxlGHFWtRYpu795XLnDbFY7Zyq8=;
        b=A4hF+GDfGtjWjyBToD5r0HIGVhvJgFPciz4sYWEUgyR//Lw39TKHvKwRrP45bYdxKw
         CfZMbwHPdPfL6hYGdLL3VOrSnP/kZGcDH0mC+WMc9rEwVN7/NyjC6HLCZqDXTNS/St5F
         lplsqY6/B1DitnIJQ/PJt2a5ic9BLKAq5ftLAtOgPFi0iiGzpdTPNif9B8JL7en+nkyZ
         YE1RoJqmn28Ecd/VHzbNLz2SHymt4wxRiUd3rxE+vGC4g5dWxBLxsUCiKLQom5oCN1tg
         TVyUes4ZX3AzKyCsBFwsd6sgmGwWOPy23frjdhW6q5MFIaFL5/T7u0SMKLoRQEhVeKo8
         8ckg==
X-Forwarded-Encrypted: i=1; AJvYcCWUeh3nD2cZbA7LyCarugO8RV8qXxWNyr3F5cBMkgQ1vOFs3CkQI2m3yfUwwd3NMOIZojPXcCN/64YuHQ==@vger.kernel.org, AJvYcCXxlp3LSA8seo3fcPNO3hnB2HvjhFmD9kQo628aYnwRzTqvLqLKmm7r+yNGRAj2mbc4yOUTyyylKIWcwEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsdxJQIp1O0a+ADzb0OZBGgSx7iO/BiTyeNsD+FJgKlVfULEOG
	rBnfnCcOhQAclqnjicwjSQ8WQSXL+aj44tK1GlQNhEcrDQyy59/x
X-Gm-Gg: ASbGncur5/HZv4Px1cAtX72/Zh5yY5R7dIgIdfRACIrTMy1tDUAUFXu8Rc/CFCf8Qfm
	od+6vyhYjNlEN9FOnrBzQMrm47C996ioPpRmpKTYpTPafIzb3YziZfwgFBb6oTEfzQvXj+G8sg5
	Oyo/wda7gZWyJlretila28Q6WmjW4GVfuzplHzXeRk1AXWy7MGfI8BSHPaGTqTUvNm5ayCYJKPr
	tPcwiaFuTjxKvmFapoAGJR1uvC/XfZLKQpZ/xiXNfrZC1yXYHx3Vl5S/NN0cnq655kElLnwygcp
	/hgXhoWVhxmrJJUFHmeSiSbIjEk4FTajQBoZLERwLXt+F2gqYMHEcs9m6jUu/KhJ2SM9
X-Google-Smtp-Source: AGHT+IGNpKVhF1MmjriDdQeiRkhRxstftLV1dEUJfkWqqAoBXpzEMIzh8Q/RdGeRtk63yqBNxbzoWA==
X-Received: by 2002:a17:903:3c48:b0:223:f408:c3f7 with SMTP id d9443c01a7336-225e0a363cemr215795695ad.16.1742293048229;
        Tue, 18 Mar 2025 03:17:28 -0700 (PDT)
Received: from localhost.localdomain ([114.246.238.36])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-225c68883c3sm90548725ad.20.2025.03.18.03.17.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Mar 2025 03:17:26 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Kashyap, Desai" <kashyap.desai@lsi.com>,
	James Bottomley <James.Bottomley@suse.de>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com
Subject: [PATCH] scsi: mptspi: Fix reference count leak in mptspi_write_spi_device_pg1
Date: Tue, 18 Mar 2025 18:17:15 +0800
Message-Id: <20250318101715.96586-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_device_lookup_by_target() returns a reference that needs to be
released with scsi_device_put(). Add missing scsi_device_put() before
continue.

Fixes: 19fff154e7ee ("[SCSI] mptfusion: Adding inline data padding support for TAPE drive.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/message/fusion/mptspi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index a3901fbfac4f..14b7c1d841a4 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -908,14 +908,19 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
 		/* Turn on inline data padding for TAPE when running U320 */
 		for (i = 0 ; i < 16; i++) {
 			sdev = scsi_device_lookup_by_target(starget, i);
-			if (sdev && sdev->type == TYPE_TAPE) {
+			if (!sdev)
+				continue;
+
+			if (sdev->type == TYPE_TAPE) {
 				sdev_printk(KERN_DEBUG, sdev, MYIOC_s_FMT
 					    "IDP:ON\n", ioc->name);
 				nego_parms |= MPI_SCSIDEVPAGE1_RP_IDP;
 				pg1->RequestedParameters =
 				    cpu_to_le32(nego_parms);
+				scsi_device_put(sdev);
 				break;
 			}
+			scsi_device_put(sdev);
 		}
 	}
 
-- 
2.39.5 (Apple Git-154)

