Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A221A76BB
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118692; cv=none; b=B5vVmjI7j+WbaA5lngnZ6AIi08CGf3U2TNJQy2M30VAjCFkgn06aAoGbR1WkGP0LfLOAuXfYks60e753Dq5k6c0x4SbzLTrp3qTcIEdBv6Gs+D5RjmO3IQyli+uJRYiiRU580O/ZHRuvBYlh28yFgqG81500djdAbZWkfBJYkJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118692; c=relaxed/simple;
	bh=rijBXGyPPRI7zVY1PE5cIgzPuGwv03123CnIu1WqQ/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SE5g+ykoEw7aM8nQI1pB4A5NrmaQ6j5L5E0qvWi9ETAZn5gsxkrnIyFSplt61ioCmesStlcUoWIqifJofIS96KWvAJsWnlLfLNLBBRtK6cliBn8408YAz8vRxfGhWvVsj9yrEQNrRJZu8XA/XwSfIGziG153MjtUaTkTvGc50c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dvs2nOWu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dvs2nOWu"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-266fa7a0552so32232175ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758118690; x=1758723490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TRTCbDx6myQFWxAdWRCj4l7Pp4fnr8OTe0kIEsi/f/4=;
        b=Dvs2nOWuewo9eig8ugL9pyqkIcrBBUrd2zukXvCI+S02addnY3DPFGpGDbhyLDptoR
         g6bqOMnbk+QI49oi1OE24WPSveEYFFqYkTzlMvz6aIHf/R/k6XN+IuODlZ5FdwNehUZE
         gXrBjvB3VR1F3uNn/ByAJbRUJ+hh3yGCU81Z13rKxr6jev214yujd1ftqPlxRWviGZM/
         qqAa8STgkQ+Eed9oTQJNt24vwdcVBGvfbsw8OCJD50zcYS6rk3t+GuV5BZ+vvHWmIKAd
         aZSjjNH/MBMhKE8WXyGg7N7APw8rT6UNWHaFFXQL5oLUKuuY+Y9sOxGbr1sLDMaa3zkk
         TNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118690; x=1758723490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRTCbDx6myQFWxAdWRCj4l7Pp4fnr8OTe0kIEsi/f/4=;
        b=Rd9HDS1ykN1w53948MqWrbqhbFhqcOsTPI0z0wL9dZ8MXsyQ2QugPqC2+aktt/4Oke
         k/Di4f8kusQXPM91tCpXnJNXM+WbkI668ucsNu6FxCu2WzIfy/ut98RNYVd50OhXSEwb
         XG+CYneeCtNJIYOa3PUsDIEa7lQFuXEfRQuQYZo129gYkDf8bQ2P1CIlcaxxnS/mS4Fn
         QHFL2nABra4gcIWzd+YeVDOqkHFek+kGvaIRSifNpvHRABWg3AjOc7qE0ovPKdKo7wN+
         Lj2+eKu/vAJqogFi0DiDR0n1SbMfEtwlTgx1C1PfE2h3gRnJ5Tj0t2nczImqJq5RShU+
         60aw==
X-Forwarded-Encrypted: i=1; AJvYcCUOpvwOHJIOeoQNrZWn7eaRAzmG5SO5U/hE22zOvEmrrVqkFTULU7yZZNF3EhuGEtKfn5PyFuVO8VRx@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq/wAYKvDwwmB3HbZ9Xw1rfawMhB8KVRARTv6OCanXzPnClFFo
	bWDch8ix0a44OhFs89EYoD8ZCtotIIaIo6URxSxfEmCqVYsDQ/+FihTV52xITw==
X-Gm-Gg: ASbGncv4/MV6HkcRpmQZGw0g6c2rRCGkvaRzow1Km6B0W2hWX6B3GqaEY9g1glilkhK
	qLqbF2mHifOQc/PdtZrdbAwJSuVtEI0WQ5t4Tnj6uCSSiWZcjKJPyIW4V38ox2rmlUBX17PK4Fv
	lr77xWf69xmmY+DrxEW2AL2VV+O5nQ3ZTDrGDBEZ4c/flvLmFrl2poEB94qUUad+pFOTMJv9mEZ
	MfhzUw1weshehK/glXdB+rIPslA1eJ5hZm2iaJbpaX5DYu/lYdIF8xo98IYYSsMrw5wozefO/oT
	8F9s2LVbUWwEplHdGKB5wRrleMHRX3PASNmOoP7iRMaPvhtEwApTxzWEqDw4UceA3cM7iAXp6EX
	ROsQVMOBh7BBMBrX1XEW/pzflpqP+hfjH
X-Google-Smtp-Source: AGHT+IF+FxnnVbL96kb6pRnRNwKlX+NEALRG1IpYvbainoyd6nXRnmkIYrgpnMijmi2HscnYoH8gYg==
X-Received: by 2002:a17:902:d509:b0:24c:ea17:e322 with SMTP id d9443c01a7336-268118b3f86mr27269085ad.3.1758118689645;
        Wed, 17 Sep 2025 07:18:09 -0700 (PDT)
Received: from localhost ([216.228.125.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26f583esm2663438a91.27.2025.09.17.07.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 07:18:08 -0700 (PDT)
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: [PATCH] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
Date: Wed, 17 Sep 2025 10:18:05 -0400
Message-ID: <20250917141806.661826-1-yury.norov@gmail.com>
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
 drivers/scsi/lpfc/lpfc_sli.c | 62 +++++++++++-------------------------
 1 file changed, 18 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a8fbdf7119d8..9a2b821adfaa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20370,62 +20370,36 @@ lpfc_check_next_fcf_pri_level(struct lpfc_hba *phba)
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
+			if (phba->fcf.fcf_pri[next].fcf_rec.flag & LPFC_FCF_FLOGI_FAILED == 0) {
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

