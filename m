Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C2818AFD
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766487225; cv=none; b=KW4BU8ytOAKXD6Mpdm3d2gajkikNs6ha0tHIWbW8N3LP3BaMkoTRjgV43rugVvmxyJfCKsau8QoLdDyLBJAxn+DYY3Nqkx94JtiPTKV1SnWThb/18jN1FnC0g9uXkzTeloH1UfzRgrcNY1LbKDPOcRJSESh/gIrh41R/QD1m0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766487225; c=relaxed/simple;
	bh=1YQlwo3epzK+lqjwW+Ck+t/d5ls1D68zR9Q9/WITAvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iw1mE1/p3XhgszQjmCOTNx9OkPc584XeCKjF8nUf/xX4ElxO0bY4oHupBf6KYXMeTGYh3Mi1d9Ojtn5439uZ371VojZSPqOKI4jVvzElNmLq3JMzGdRemr4Lfb999yzIQzpp8B+7vI8dZYeCclii/sg1p9U8pH/MketDhX72LXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=S9dx5e39; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="S9dx5e39"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so4582448b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 02:53:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766487223; x=1767092023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSADuZb2Xhzr7xWD9AGh7UxP+1tASxe4kKodk/Zso2Q=;
        b=e/wjiIMrq8xEYoSs4MwTIsNGWsHHrysRAFgerXCL56glAm75P8BOPuLLT3/6BGZyhg
         Y3Thi7zvO3l6pDpDLCFUjKU0Z3X3FwCnZBx2JwQArsOUIWcMuF+c9HoF9rvxGtl4dcAI
         y6Y1NcS6uUgyUtoYCEDfU0luM/2JUH69pxW5ZlZP5kh/hozdc1SyeFxid5kA7Tw01Xfu
         gfgZ7cQAk5/GKpR2qkOjnGJErY/XwTZURNg5JtXSFkNBdUF7j8v7yUlN/5Zfm18qQ8EK
         QDo7u+0Ud8rlNOxqhFVMvLL1r/Sr37n+YN+20dW1sKs/rh8VFeIiTb/GBugBu1d6GYAJ
         xqow==
X-Gm-Message-State: AOJu0Yw0XmkY2KanJr0Qsnnniwukl3r/bbylGzvz6QfxSxvrXsNZhWXw
	f20xnKpHS9uo8k3ILr7QciH3ZehuEFZB1qxRdv88kIuzNmXNUtP2Zq7fsDxahuX1NJmdpT60S6y
	MSMTunEwt8xDNd+ar0kXK8lj7CcJ63FxEDm2IslzPxao8NiwU/4SG+GRKOVR7Iga9zcFP+2ZIff
	DV7WDvN3YzxdLn842nkRWbXTHNgY4EsY3sQMFXRipJmnbKgG2LkpPwsCEjMo4nggixLPqQxZdTe
	1HfU11OeeS8X2K/
X-Gm-Gg: AY/fxX4kicbc1CG6dr4of8X9uixlygItVLcd5C7tZjMQhgGJf1x2GmGBmwzA/c77lXY
	utbuLatV0kIaNkRXyt89MtwujOfjEqcuCOeVBVLKogriQ2MQtrF/V4CaJbgg8qqp1UIOl0BzlyJ
	416rRNOgPbv40XfS1iHG4kbIVb/brFNmqrMMapOYOWM1TafDXhSUqrKLBfMHKSTqLULDVx7RKeV
	Q3FImgOAepJzUNuD+k0TVJv0vETC5PdO/ITOd2G8KQR9/RZhhTgY3VzKbnylfLKmEOLh8K7Vbtq
	UKmT1Jf+ncOF3h5YNctsQapG+0OHkOMkdXWCsW9iV5lAEd3Arc9nrlshMSCA8gP/mYHhMa+/B/5
	go1J2JQ2owyUPqfbsL8dbgEiQB8L6PBkjzG3KnYw2HkGe8ArfIEpyp/hpWFLEqSSfDeufD2U7cj
	gYtzHU8nQFvBWCctUcwO2MGgeUGCm0ZGb16+46OdYtpQ==
X-Google-Smtp-Source: AGHT+IGxPYy26ZxE8ZkdNRplSDhcG/Q85WVMYc12Qky3bCJaG0TULArDmqar8zAlwrvVHXBEyKTXEGvp5ExF
X-Received: by 2002:a05:6a20:6a08:b0:35b:c903:1db3 with SMTP id adf61e73a8af0-376a88c8d5fmr11978736637.6.1766487223524;
        Tue, 23 Dec 2025 02:53:43 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-c1e7b784812sm988953a12.9.2025.12.23.02.53.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Dec 2025 02:53:43 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso8424588b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 02:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1766487221; x=1767092021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mSADuZb2Xhzr7xWD9AGh7UxP+1tASxe4kKodk/Zso2Q=;
        b=S9dx5e3965spfqGAKogN0vMrDeur5wsJevJjfPuJ9/jFyqM8kYVEpq2V+yKNRUW/wX
         TLttCYBbkLpUzM9tlgnt647k8sTlEz5QQ9NJnyuT3UB/mAjj/Q8Fm/RMbKdqKhWDyscY
         nqA78D5q1kb5D/U+cCnUHctDKzyCo89mNXkIA=
X-Received: by 2002:a05:6a00:1f03:b0:7f0:57db:7a59 with SMTP id d2e1a72fcca58-7ff67966bd9mr13889215b3a.53.1766487221379;
        Tue, 23 Dec 2025 02:53:41 -0800 (PST)
X-Received: by 2002:a05:6a00:1f03:b0:7f0:57db:7a59 with SMTP id d2e1a72fcca58-7ff67966bd9mr13889200b3a.53.1766487220906;
        Tue, 23 Dec 2025 02:53:40 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e797787sm13301802b3a.60.2025.12.23.02.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 02:53:40 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpt3sas: Revision of Maintainer List
Date: Tue, 23 Dec 2025 16:17:21 +0530
Message-ID: <20251223104721.16882-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

As an active participant in the development of the mpt3sas driver.
Added myself to the maintainers list.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a4dd7ee4648..70199ad98d6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14673,6 +14673,7 @@ LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 M:	Sathya Prakash <sathya.prakash@broadcom.com>
 M:	Sreekanth Reddy <sreekanth.reddy@broadcom.com>
 M:	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
+M:	Ranjan Kumar <ranjan.kumar@broadcom.com>
 L:	MPT-FusionLinux.pdl@broadcom.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.47.3

