Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5AE199237;
	Fri,  1 Aug 2025 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754074328; cv=none; b=hcQjbFvpZc7hVz8+zMkljnsNFNppLWFCHTwmGp/weHGDSwDz3qIKenF/p6Hnuv+PcvBF2mctNW8r//kVDz/fmp0Wh5cTk+EioCiQweOLeEV34YyU04Kd5q4M5gMvN9VFwxyDIEflhUHJels+HOwnY3YVEERRMeP5xxuf/xf6aFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754074328; c=relaxed/simple;
	bh=Xp2PK/ovVd/fbBmlJEJTx+dwye2Em0IHjMJyreXtfhg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gEk9jRXO08cfM6pcfEN1iBBWmmghlUuEXNnegye7fvm1vl4v6Xcw5lc0RN02UF1I4I/nh+WygCSh50yRGLe0jEW9/zEoLRg9xbruuY61n8r/0LaU97aBLrfW5gK7Ro/Wg7hZ7HulbYMayNoi8B0Y5COcdTGR2dDoudEPToEUTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WsgTPKk5; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsgTPKk5"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-712be7e034cso20307727b3.0;
        Fri, 01 Aug 2025 11:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754074325; x=1754679125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gFoIxDRp2pfiB127p9uyJxKIANShZZkJHHrE2Rq6b24=;
        b=WsgTPKk5AiBFyCYyfXYroQyd1xSCYFOPU0q1YOhmQPnMtjVkn5Vp6vDSYmYPg1EMqg
         QfKYJeIRsw8OTyr1BewBVq/YGtpGVYR75TQz8oHNnvhdycaF0PcYc8xRTQ/96KsvqQ4r
         EGhT5uzxUmqYOXjQ0xmgya+xRpaH4iiifiIpsQK8AF3CL6p71TqbKCyuKR1ffM2IXLqe
         ZKrqDAxVRNSiQ0DFNPF2hrJOquR/CcxWKIRL6JXrzz9gb+542zVF5G5ZqQxyluvKefgx
         pHpUMnSdqwW+ZRxsa/AA1hSg+OF2R2vVJ5ZtlbshM2NqxofEeVcRLtNzuTAkmGl2R0l/
         Ly1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754074325; x=1754679125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFoIxDRp2pfiB127p9uyJxKIANShZZkJHHrE2Rq6b24=;
        b=NLJ6/HbBHIppeuELMV6IA58bvt4vIUw4LonT93WU44q/+Q6MRdRbc6Rr2Ku8O3ywpa
         yI4BovMPDaVlrPi7vdAra0g93kcmENgRHYdiQWSzARAfrzjhqHPW+i1wfwa4aCya6Z28
         qlSLU+RHK/vnPZo7lIYvi5lbrfzSgVYVk1N17oNr6cmsjmRATodSHiYzJlq0NB6r2EnU
         ODxEZdGhirREiCqgvUUHnwOFMuwNe19OTvIHPS03dGGBylQp3Q6gSaQLbPW8Jdjmo/5g
         UBUALwunw8DsxWgkcnq6c7GUM9RCQL8IER++IA21NKaISBNI6oRl1UYDAGkvp4V38DF7
         TPcg==
X-Forwarded-Encrypted: i=1; AJvYcCVIUN5EAWn9Sx3Xf13WAXdGDKW6GqoHymuFEJmB+tkxBiHt+gvGxUS4zqTfjCGkgZaKGXgErsxIDHUjhuk=@vger.kernel.org, AJvYcCX05osIQS/E2OBeuux1s51xbEnVjSNUvzGstdzMfiidQUgzAIPCujc6sMmQU8OD90LZon8Ie+YzBvYFww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAPY2yslWXBcSdOCQjN9jzobF6C3xQ5QURFARWFf9jE1Gnxmh1
	gjkKWrsRpWp/ffIDVw6amQXWk9xO7uwSmESYuPFCFw+RjUr0fgqcsMYG
X-Gm-Gg: ASbGncsQK5c7pLRtlXYLvsFeuA6AmNgAvu7aeYke7SxkHeXNwYrA6GYpVWXmEwzDuc2
	kFPzl2sP3+Sh65c5NDoliVYVFVZvTwUsx9IeqGRCHjKKNg59jmEFGl3RAfA+yqC1rl6s1UpY5oN
	GJCWBtIUfTu8PEu/JXKF5Wf2nXrXxIrN346H3BnptLuTDKjAXtgWPl9tKbyuCdrmbfMcjKOxwuT
	y8RXVrMjhjXvpwZu90I5ESE6VR0NK68Zk/VtCWo7pTGXL6rWM5wywh3fz+ykkGv9j0yYJeDVJ0h
	L++AiQTMNWat0OvKTorbI5mIjiQRcpupmZmt/Ue/WzYSNg7+WdstA6loioHL7RUktuBIYrMAQpX
	TpUJ+4Pcd+JbctqKusHImBnVWP94FTwBf/45qAsrDn9xW
X-Google-Smtp-Source: AGHT+IG11Q9HW6siAAFooyZVFBl4g+RmMYc5D7VV9HCDdBzn7WKu6WMLld0/77W2Gy7aNrJTJaGWCA==
X-Received: by 2002:a05:690c:4612:b0:71a:251e:36c5 with SMTP id 00721157ae682-71b7f87f472mr8703197b3.28.1754074325316;
        Fri, 01 Aug 2025 11:52:05 -0700 (PDT)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdde5sm11928817b3.78.2025.08.01.11.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:52:04 -0700 (PDT)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Fri,  1 Aug 2025 18:52:02 +0000
Message-Id: <20250801185202.42631-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the redundant assignment if kzalloc() succeeds to avoid memory leak.

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2db8d9529b8f..7c4d7bb3a56f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6280,7 +6280,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.25.1

