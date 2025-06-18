Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B772F5470
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272976; cv=none; b=Rv+clMFdDL8M6Z0J3jMzJcBn+rLEnVhbmgkA3A7sUehvTtGR75XKNqHiwWNrzucL9IlF1JKjx06/KAm6VbAjsyvjldRmP5G9ZCOrWpTGfbj4m/UyrFYVPXHodECXUCK5S7zApvW0/xNSU1RfXEYHDdxChXnX4FHwoK2ks8avbow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272976; c=relaxed/simple;
	bh=MmJWZTWRELZWKicHxIRGCDwFh0pdtdn81+esg7RM8II=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wq0yvdx8RqWOJNLE9kG1e6APSnNiR89c7uwsUy6i5P/D2d9uTRDifhYiibxePhc1ASt5wnneaSDhbu5fli16v4Yu15reXzo6PISlx4475elBSwqnPZFm0HXUOa2Ho4dFSPjAQL2ti3Op4UctZQ094ObsfBqN0o3FGeMYHV3PqxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P02oSv4V; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P02oSv4V"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b271f3ae786so21803a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272974; x=1750877774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4pJ2/TYr66pKWSvZFpcVFC2nhS2o71CRUOiJqjuq4Y=;
        b=P02oSv4VIAZQ3R2cr0qd3RtT8qLIicgotOCROPNzjC/sx07oVn9CtPBEwL4Q5RRujB
         1XTaJ+JMQh3tsmAvJ4FHnM7VIL/+r+xcqnJIk+hW1o+rAzg3Yw5J6O4MeLQF2Yur5cTE
         piKD0rccZUkwu4X4f1QVqdYnc0NZRL6SUuuqrwalTsQ3tH2HE+XIZTo3cq0454E7U5+s
         WmxyQ5tqDjveSgWEdSxgLfz0kh7DeWtnmh22vizPjU5wFWc/ZH7L3CnsQLXbaZoY9J5I
         liV6+ajxW6C8BFhlxzwQL7T6MJnrGcuvIM+XjcQao3g+BQgEyPHLDrr5ZO5tTmHQpwex
         OE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272974; x=1750877774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4pJ2/TYr66pKWSvZFpcVFC2nhS2o71CRUOiJqjuq4Y=;
        b=B6Ja1V+XuzWKuZhUNpeKCXZF6EvHMQ7alEuqi1HXTdeAYOkoSyPC6nk2uHvsQFxBtx
         7ZU4ZR/QF3dtOyNoVwpFz/BuTCvfOQLW0AJYRVR8vXaDnyWaQsAy/qtjEFUtJTjaHye9
         Tt4/j4FKLnuHKzoXg5kb29kr50D6EPktbNQ2/ZnL45uqspiqCDN0phcY7XvP0r3B5CVt
         UOkGleawR+PRkIua6UScLzIOcT/khh8VYRofqZy5p3I2Qj+wbtbIwSafANjIU09JsUdu
         KJKbBLWBaM9PFikeIVMUNtZHUyxsOUqSewkYBvpnrlgIWrYFZYCgboN09K9MqG02AhP8
         J/+Q==
X-Gm-Message-State: AOJu0YxUxtAL+a2Ci/ROquAs/GkJMBh+65NZngJbDsm91t5iQRi30VYR
	D48giTumZ7uErlveuKs83UUE48tlSGge/gnU1s00A1/Gic/Isylz1E8RAYpBXw==
X-Gm-Gg: ASbGncuJtkf2sqBuCQJ3/BG2ptuS44JYBQd1TVuyGVXYVdDSW2DwqJPfWek5rJ9ZPFX
	VSgYxAluSmx2HkX0MW4CI1ePbGDjyqHOXrwFMm+fvyjtUC5kEAHroxuz+UHMhtkNsDGoDJJbMbZ
	YtcdmNccB6AdPi/hZRBWNEsPfqMYtSLcvtZ0NSuin7vK1R/ob9UqRFrNEqS2YuVWxPpBesnrOoa
	WMJW4/zAEpKJRew3dwFe2tm/XqYzFJkZtA7hMa1Als89Cu8UlZ/4pbTFEOUzB0QFdiUsuhEiug1
	PMtmObgRGhJwYccKmeyf46KOpDv/An4Xiqh1/J65fiZktPJDOYP8FRx4861g0Xev1NKbR9zs9KQ
	1UCMZsqhkGIqdzePfBx/min96ZNjb+zJuxNZA1umh06IEtNo=
X-Google-Smtp-Source: AGHT+IFMyXttJTlhcStF7GWf/HrVeFy7DJ+zR2Q5eVCBv/Iu2Km12WrgmGs0a4+qCx6d6xPmlx0SzQ==
X-Received: by 2002:a05:6a20:9f8b:b0:21c:e488:29fa with SMTP id adf61e73a8af0-21fbd57d7bfmr27196631637.29.1750272973825;
        Wed, 18 Jun 2025 11:56:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:13 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/13] lpfc: Simplify error handling for failed lpfc_get_sli4_parameters cmd
Date: Wed, 18 Jun 2025 12:21:31 -0700
Message-Id: <20250618192138.124116-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are unnecessary checks on an HBA's interface type and family before
erroring out a failed lpfc_get_sli4_parameters mailbox command.  Simplify
the error handling by logging a message and proceeding to memory free
labels.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 20fa450def03..7695a815de7a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7919,8 +7919,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	int longs;
 	int extra;
 	uint64_t wwn;
-	u32 if_type;
-	u32 if_fam;
 
 	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
 	phba->sli4_hba.num_possible_cpu = cpumask_last(cpu_possible_mask) + 1;
@@ -8180,28 +8178,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 	rc = lpfc_get_sli4_parameters(phba, mboxq);
 	if (rc) {
-		if_type = bf_get(lpfc_sli_intf_if_type,
-				 &phba->sli4_hba.sli_intf);
-		if_fam = bf_get(lpfc_sli_intf_sli_family,
-				&phba->sli4_hba.sli_intf);
-		if (phba->sli4_hba.extents_in_use &&
-		    phba->sli4_hba.rpi_hdrs_in_use) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"2999 Unsupported SLI4 Parameters "
-					"Extents and RPI headers enabled.\n");
-			if (if_type == LPFC_SLI_INTF_IF_TYPE_0 &&
-			    if_fam ==  LPFC_SLI_INTF_FAMILY_BE2) {
-				mempool_free(mboxq, phba->mbox_mem_pool);
-				rc = -EIO;
-				goto out_free_bsmbx;
-			}
-		}
-		if (!(if_type == LPFC_SLI_INTF_IF_TYPE_0 &&
-		      if_fam == LPFC_SLI_INTF_FAMILY_BE2)) {
-			mempool_free(mboxq, phba->mbox_mem_pool);
-			rc = -EIO;
-			goto out_free_bsmbx;
-		}
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "2999 Could not get SLI4 parameters\n");
+		rc = -EIO;
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		goto out_free_bsmbx;
 	}
 
 	/*
-- 
2.38.0

