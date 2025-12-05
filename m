Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB0D272801
	for <linux-scsi@vger.kernel.org>; Fri,  5 Dec 2025 23:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764979095; cv=none; b=HwmylOtloBaeK8g2ZUEFSDyVxRLq2a3IpASkBYfjPG6uIKFnUB2gtLm5iuFOQlTdoI2nOkaDeAgtgrUkrfE8Zpw9nCecX5FYN+75a4r4jmgfzQBQH/Szs07QwTOe0DJyI0957C8zEDh1s+fFNGc3mvLxNPiMHwmiwlg2ivKp/Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764979095; c=relaxed/simple;
	bh=6eXmvFRyk7c0S5Z8owqZR1SIcLC19Pl4Ruv0fhYJByk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m0s+nM6Q1pBRjXLBPFhHDyFvad/nvmaLETb2ZDpVtJckghhz8ugKGq/SOwtMCGiJMrJ9hB57egjueaPKLyMdPlICjrS6vY6VeASv4tfSR7n9zB6l9a0cubHUmXwK9oEoj4C+sm1LKx+I4IBrfxOjJlk14NqLrdulfHXkTV4Bz30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=joqTKcFG; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="joqTKcFG"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6442e2dd8bbso2102979d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2025 15:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764979090; x=1765583890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cPgQOdtl/tU0gJp0Qps8kqZujLmXDZbYPgzwk6SilGM=;
        b=joqTKcFGmhs3//4kC1kHuGSmV3Mcuy2EnB69U9jbFbq9h7wQtOZKPxWhQEN6rHiudk
         U3pqYOWf+EYcHCD1K7Rs+DMB2ZuXihh2/qS0qx3wc0QYZtLBE2QjMlLIc06n7Mh27rzG
         t4BdTLNbatcrzcOgHcuMPRL4Y0dduK6f2AujkmfB84iyBqXler6CHZ9PkfkFVp8ok5d6
         dTh5TVP9PXj3lU+Y8L+ap6jBdGZqoybLVo6mBhHte4hX4DQ4lIZyOU1opNK/ltfgWGD6
         LUElpC7K/+5VKrIL0B/e3REduXysmAUnnDIQD6dB7uTmRvGSZB4jKhkYMuLsEck7YEu/
         0KOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764979090; x=1765583890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPgQOdtl/tU0gJp0Qps8kqZujLmXDZbYPgzwk6SilGM=;
        b=a5CdmMC6WXeo4DxCLFJihnd+lrTrCQKYQ1yzaThi4WqfiwKw92fDCIDK7RIs+MhKqW
         c25Mn2G2Fm2SpzqOC+cjE641orKHtZFYj8V/z0xRTt9o01ZNggUavIJwOadw3jnOYQoJ
         +vKpXRP7llfyj9fMRgaH2hFOVl3hzB01x41XYstnFTx6wFpvai5GggwZ3N13KzIN+crT
         fra7uWO6HwZ35jaTQL2YjeeNDfUurLBW8KNxWUNv+8C75HEwrS+VD6VMQJXPXYWlEL7K
         +SPU0CYHNzt8Oa1BtSiMSreNavark7qMvE4wA0tz3wwwBOeO+9guJ6SaPPo7h6SDyCWe
         4xWA==
X-Forwarded-Encrypted: i=1; AJvYcCXgM5O/RRtBY2Wi30rInCfF6Riajtvn1+7BE+4w6AlSCzuwYWzqrz5beQ0IJ7F4Uj+3I+t2raH8q2Ud@vger.kernel.org
X-Gm-Message-State: AOJu0YzTDsueHz3ClElFK4i6eCw9AG4ZSAx1Zt3jxWp5pWIY3KaIW2Yu
	34RaivwxUjk4RME4NrmpMXMaEUiIYXY2lHd7OqSAnGYlki7/N3/SmiG+
X-Gm-Gg: ASbGncsAtnBPwBmwcZKkqBZriNBbDkUk+fB67alohx9SjGn8Giv3sQyuDasDVVKqTlZ
	AFY8mdomTT05kBUfluQf80HaEECa2jrUxLpLAQUG7fuRR+zitdSCad0Ji4XsFf0572u3vCnvmiY
	Fcq+RiLjt/E7clvk5nlYZlbe+Y15Ra75HcaB6fuFm/SNBDJnG7qAaSWiLpDzMzEfkqPseSL649R
	KKrLx0GeYNd812ONfzrk/YhigZief3EKhTbuHfAF/tWLxJa8d9kLFZnahHehMTGc5OunRwOslMg
	2Eu+uNDF0zpcYt8sDPfTaTssJUWFfAf1yKeeLP+97nmI/NGzUVoW2Qk0k2Gh8jhTpB7q9sI32o+
	jtwe1yWtbGyzGq64DhgXY9Qe5VtiPtsGZ6meVMcQjgOWxyL4HMv7ZRTxS/jOCbKnRXzl00iHY5z
	fKpGyoOw==
X-Google-Smtp-Source: AGHT+IHQX3by7qUEucqLqlHVgdeo4lBeXWo2mpPEuAMYSDC6NV5CkJ3jE4tMh3tjLdeQoEyI4ORbGg==
X-Received: by 2002:a05:690e:434a:b0:644:472d:daf2 with SMTP id 956f58d0204a3-6444e7b93fcmr499956d50.53.1764979090366;
        Fri, 05 Dec 2025 15:58:10 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:be2a:7e4d:3bf:3fbc])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b78e5f5sm22031307b3.41.2025.12.05.15.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:58:10 -0800 (PST)
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justintee8345@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: [PATCH v2] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
Date: Fri,  5 Dec 2025 18:58:08 -0500
Message-ID: <20251205235808.358258-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function opencodes for_each_set_bit_wrap(). Use it, and while there
switch from goto-driven codeflow to more high-level constructions.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
v1: https://lore.kernel.org/all/20250917141806.661826-1-yury.norov@gmail.com/
v2: tweak check against LPFC_FCF_FLOGI_FAILED flag (Justin);

 drivers/scsi/lpfc/lpfc_sli.c | 62 +++++++++++-------------------------
 1 file changed, 18 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7ea7c4245c69..c330db3e54dc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20361,62 +20361,36 @@ lpfc_check_next_fcf_pri_level(struct lpfc_hba *phba)
 uint16_t
 lpfc_sli4_fcf_rr_next_index_get(struct lpfc_hba *phba)
 {
-	uint16_t next_fcf_index;
+	uint16_t next;
 
-initial_priority:
-	/* Search start from next bit of currently registered FCF index */
-	next_fcf_index = phba->fcf.current_rec.fcf_indx;
-
-next_priority:
-	/* Determine the next fcf index to check */
-	next_fcf_index = (next_fcf_index + 1) % LPFC_SLI4_FCF_TBL_INDX_MAX;
-	next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
-				       LPFC_SLI4_FCF_TBL_INDX_MAX,
-				       next_fcf_index);
+	do {
+		for_each_set_bit_wrap(next, phba->fcf.fcf_rr_bmask,
+				LPFC_SLI4_FCF_TBL_INDX_MAX, phba->fcf.current_rec.fcf_indx) {
+			if (next == phba->fcf.current_rec.fcf_indx)
+				continue;
 
-	/* Wrap around condition on phba->fcf.fcf_rr_bmask */
-	if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX) {
-		/*
-		 * If we have wrapped then we need to clear the bits that
-		 * have been tested so that we can detect when we should
-		 * change the priority level.
-		 */
-		next_fcf_index = find_first_bit(phba->fcf.fcf_rr_bmask,
-					       LPFC_SLI4_FCF_TBL_INDX_MAX);
-	}
+			if (!(phba->fcf.fcf_pri[next].fcf_rec.flag & LPFC_FCF_FLOGI_FAILED)) {
+				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2845 Get next roundrobin failover FCF (x%x)\n", next);
+				return next;
+			}
 
+			if (list_is_singular(&phba->fcf.fcf_pri_list))
+				return LPFC_FCOE_FCF_NEXT_NONE;
+		}
 
-	/* Check roundrobin failover list empty condition */
-	if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX ||
-		next_fcf_index == phba->fcf.current_rec.fcf_indx) {
 		/*
 		 * If next fcf index is not found check if there are lower
 		 * Priority level fcf's in the fcf_priority list.
 		 * Set up the rr_bmask with all of the avaiable fcf bits
 		 * at that level and continue the selection process.
 		 */
-		if (lpfc_check_next_fcf_pri_level(phba))
-			goto initial_priority;
-		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
-				"2844 No roundrobin failover FCF available\n");
-
-		return LPFC_FCOE_FCF_NEXT_NONE;
-	}
-
-	if (next_fcf_index < LPFC_SLI4_FCF_TBL_INDX_MAX &&
-		phba->fcf.fcf_pri[next_fcf_index].fcf_rec.flag &
-		LPFC_FCF_FLOGI_FAILED) {
-		if (list_is_singular(&phba->fcf.fcf_pri_list))
-			return LPFC_FCOE_FCF_NEXT_NONE;
+	} while (lpfc_check_next_fcf_pri_level(phba));
 
-		goto next_priority;
-	}
-
-	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
-			"2845 Get next roundrobin failover FCF (x%x)\n",
-			next_fcf_index);
+	lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+			"2844 No roundrobin failover FCF available\n");
 
-	return next_fcf_index;
+	return LPFC_FCOE_FCF_NEXT_NONE;
 }
 
 /**
-- 
2.43.0

