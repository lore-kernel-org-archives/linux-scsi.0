Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3F031E826
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774120664; cv=none; b=TvyzMRAYoTiZ0qSB3vMAgjHWz8PhFSNrI/8v+4EBYRWVKfEJWYxWbK7496EKnUw1WtAhIdiP2/46UUXY3E86a7EFF47HhaxXGrzLcWl7v0AsLXNB2hWLtAVLTuqGHhtJ7Ehu9bAP3y/otqRboPQfR4nLwVwjoQ2BvuyRV/Fi2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774120664; c=relaxed/simple;
	bh=AQohWIPdx6o7olSCZG8FkfZL18WDcqfud6RonHxb344=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iR/LVxziAY9pUDwh5EvZOHo74inOsU0VCRMl4BPCNJ5GwqxzXh1buvc3bXQyaPFYxctaeLupXtaA7qvg62GVdVLiEOnlkfl94TpPj1y2hv03TyYMf1ujJlzQousA3RsxEuUdfZrQZF2G6e6vuV1jIvbuHzXaEz7RJL06Z/rLfSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DHWtSNRF; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHWtSNRF"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82c2239140aso479324b3a.0
        for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 12:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774120662; x=1774725462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfhTSNbMCa18G8KLItlOBWL7f74p2rCgKRxLJUa+eaQ=;
        b=DHWtSNRFHGjX50z+QniAoDPqz3RJHnWyX+fvi24jWqQoRdPJGeBV40JQeYmrEDIsJV
         hWhkr//qbZn4xVW1b1/NpSa9B76KJxMMGxtWvr8bPUPQPT2e2UEP/Jyk7RnOK2koETwe
         Yu6XxaFj5TzmgscUUDa/EMwflgYLz7hx/M8zYwkhUPFvBnsXwUqJtAnPpaTCP5V4t+rk
         hdvPXBXLNElww/zb48UEaugRRQHY+PrMfpW0FYawA+fVk0pHzKH5lqk7hgIGHVr9Ntx1
         v4/WetbnMcPkWrexwDbEbkJxkshwCu7n13550/zVXzR5beBWDn5h9h052+5newXdGXNE
         B7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774120662; x=1774725462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WfhTSNbMCa18G8KLItlOBWL7f74p2rCgKRxLJUa+eaQ=;
        b=s6heyDcVsoZKA2vHyZvyoRbNOr2UDyZLaDEpCdintat4lj49QzD6FeboxEypYpDw7r
         ElfxcW3P+7Niu0NadGc7LLKDH+v0y3Yd9GzHQ/mcPILScP7U1NxtMY0MPXNSq04q58FA
         5j7wdTZVCfK58jgTOLPMw2RtJQ3Dhk67gkmYLI9wHIjS4X+ilDc96WLEhoGwC4FLW4QE
         3vUY9FbON8AEJpA9Wm2ukMlD+3rZicHtUsun6BOsVd7cRlUxNumU7Lti0+4DGgjDZ7WD
         1sYDMzznLKmZoDhaI74Dvidk+wL1M96NT6Ld8oSr2uZSye+E4HSGUYot+naLOOEoDZNG
         Rwpg==
X-Gm-Message-State: AOJu0YxtP5m+p/MhHwZD+04HcjEkcFAlB11mYge++ZalGiiiONB/sXhc
	ygWa2rWQ3l1KLmEQUXJACArYakpsCRqNRs8qugBT4QbMsxLxSVJPG9rNydlpyvHv
X-Gm-Gg: ATEYQzwN9t56HwktdmntSdy9QnO3lX5LFg/AGOAKqBOzA3Mqa63Khpb9jB+nN9Gdedb
	ZlzmoJ79Kg5Sz+lzAvqvFL7g8jtpbTpLeGGFOqCpzSdWcQUL3lRFnDdmqVZAcLlDOU3oE16bBhG
	W6vJnMXP1AGD98kTOWOIFsNKO4kah7eVS6MMOWG1lO0ISzzr9X7DtGNcYGMoly0djTrxGGgd+MB
	R25zhUZEzcQCveTM+ipT391eh4zgxjBTzfBvti6XCNIwZtQnevRcuWd7NojjnkU5qfux+ChRMSH
	5Y8U/0MC44FxvJCWF/OHBltI+MnTrbiOg/2eSJHrqiQwq069OMMKTgtV8zwXRylTg6qyHSDkQOr
	arhoU9KCzKWVkdyp/PX4pFVAYBSuMR0ZlmhQ1K+PTtgyCDnvvlhG+Ub8vvHIfXHLH781CqBhnW6
	PcAJHurgodZ3qXDfmpT04KTrCOzw0jIerrNDnc1pVGSl5LeH4/94cC3ZU=
X-Received: by 2002:a05:6a21:9981:b0:39b:c469:6c81 with SMTP id adf61e73a8af0-39bceb20ca0mr6375833637.33.1774120661821;
        Sat, 21 Mar 2026 12:17:41 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc9edsm4319968a12.23.2026.03.21.12.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 12:17:41 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH 1/2] scsi: be2iscsi: simplify cid_array allocation
Date: Sat, 21 Mar 2026 12:17:21 -0700
Message-ID: <20260321191722.19235-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321191722.19235-1-rosenp@gmail.com>
References: <20260321191722.19235-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use kzalloc_flex to allocate cid_array to allocate cid_array as part of
the overall struct.

Add __counted_by for extra runtime analysis.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 17 ++---------------
 drivers/scsi/be2iscsi/be_main.h |  2 +-
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..aa5320535c1f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3992,25 +3992,14 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
-			ptr_cid_info = kzalloc_obj(struct ulp_cid_info);
+			ptr_cid_info = kzalloc_flex(*ptr_cid_info, cid_array,
+						    BEISCSI_GET_CID_COUNT(phba, ulp_num));
 
 			if (!ptr_cid_info) {
 				ret = -ENOMEM;
 				goto free_memory;
 			}
 
-			/* Allocate memory for CID array */
-			ptr_cid_info->cid_array =
-				kcalloc(BEISCSI_GET_CID_COUNT(phba, ulp_num),
-					sizeof(*ptr_cid_info->cid_array),
-					GFP_KERNEL);
-			if (!ptr_cid_info->cid_array) {
-				kfree(ptr_cid_info);
-				ptr_cid_info = NULL;
-				ret = -ENOMEM;
-
-				goto free_memory;
-			}
 			ptr_cid_info->avlbl_cids = BEISCSI_GET_CID_COUNT(
 						   phba, ulp_num);
 
@@ -4061,7 +4050,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 			ptr_cid_info = phba->cid_array_info[ulp_num];
 
 			if (ptr_cid_info) {
-				kfree(ptr_cid_info->cid_array);
 				kfree(ptr_cid_info);
 				phba->cid_array_info[ulp_num] = NULL;
 			}
@@ -4175,7 +4163,6 @@ static void beiscsi_cleanup_port(struct beiscsi_hba *phba)
 			ptr_cid_info = phba->cid_array_info[ulp_num];
 
 			if (ptr_cid_info) {
-				kfree(ptr_cid_info->cid_array);
 				kfree(ptr_cid_info);
 				phba->cid_array_info[ulp_num] = NULL;
 			}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 71c95d144560..b5f8e746deab 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -241,10 +241,10 @@ struct hwi_wrb_context {
 };
 
 struct ulp_cid_info {
-	unsigned short *cid_array;
 	unsigned short avlbl_cids;
 	unsigned short cid_alloc;
 	unsigned short cid_free;
+	unsigned short cid_array[] __counted_by(avlbl_cids);
 };
 
 #include "be.h"
-- 
2.53.0

