Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207131F986
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599062; cv=none; b=MV1ypwhyoIGSYh4agcNPygAAHVz4zfVmcoDkYr6fcRi5wqDWEQV3I32bmshUG5AlMFrfVyBP10QNOLPzrsPP0zO4uRCCFeZ7HP7Yp6cf5ZJyr+lNVwWVbIDNVmFj30PzVkz1CtVd0T4bP7c+cm1q0BP0n+c2/VowBrBsWnm3+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599062; c=relaxed/simple;
	bh=LCrHk0mXmBoxqijlXX61kg8RAalLQLRHE4JPG4lfKDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GczzmgCyE3S4mcZDilkOsC+Y75YrmZO4ecY7ryGsyjiw91E5q28CiLqiK30pb7Mas7z6dOuT/a4BwZzt93CYkzj+bJvaTDhwGBrvvgNIPRY/DcY3irOUCa/GhFGNdspbtr6wLzMpGDBICPUIFicfG7b27dQqmhQkIOCGPZ26RHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ct+w7jnr; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ct+w7jnr"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9158629a220so120856585a.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599060; x=1781203860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ad6xz+bi/Z+3fCS3JOxccp7lrZfKAVizkwzbCWI1elc=;
        b=Ct+w7jnrw2595EsitRh61rCqT61PbPGNSOcDigqQeW+0FTHUgkmkzPyLbbInC2eam7
         AHXN2x5nLVUpX3VpxZjyhziJXlzz851VSo20NWO9MULqfpL4RLIrOxp1yOlV12wjyIVE
         b6+oyYfW3dRlnKZw7by20W+sesu0TupzIaJC2zm9zufPHf15x/KWViI/Hqza2uVmgKXg
         Ydwc5CJFJ5KgE9LEmIArcNhTZERPpV2CZyAgIjrx7EJ1AhD1bSfELTcPhefsJ2zq+aMA
         iLl2+vgxDCgsGv/tJHklNKXGmS0ac46Ixa5ua68GAmUolTDsGT5ernwUxJfsmhnwipww
         vpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599060; x=1781203860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ad6xz+bi/Z+3fCS3JOxccp7lrZfKAVizkwzbCWI1elc=;
        b=TtiixFL+xkyrW7dlRyzEAW9er49tbbzNwflZDW2eYjf6styxbP4v+mJejz5TSPvRig
         /cakNxHtcJSKYwCrSVTZYTwKi4X5lK8/+/XsQmEGvtt66iKAi/cooKN2jMjayjBVltNq
         49XA5wTKn9aN4Vzl48noe0IjvpfBHhq0d8Y4QMCLx0v4hUZLsRBOF9ruqTTXaaqUicCD
         zwc/Cpxa4IosoZM2KZjMnSUpTbZ5bDxSqjeZyU84FASPDSHb8Q0ElqbNCo4nV52K9Uqg
         hXOAsipyHRFbaBaHCOOcAb/KZscLPYK3mTHcZqnIcc2AaN1YX6i1tIU5T7T+d20eCmsH
         /G9A==
X-Gm-Message-State: AOJu0YzGjqE9A4DdQ8D8fvJ4EeFHJBI8avvPoQGLZYNjjxryt5Ty9nVr
	6pBqbO6tPOrtpHqmqfhDRySPgkAPCtwSHQkhwUJaO7wtL295Og4/v/RQuDmUJUct
X-Gm-Gg: Acq92OHGtQW+4/ZWUmYjoNKFy4wFdRzICZ4nzUV4h9YRSFhTqi8dnmOHJ94ko7W7o5D
	HTDuxybOdqWCiTgWN3Z6WuCZqb0vVe34rXPR90KvMV7CXUjq3k3PyB12wG3UiRKNoPQ3MDUfdsh
	p9n6ga5fIW88W6jl8iP7H+6MFhpr5mxcs43Q5hfNrxkeHLEmdLKmhQiOisrLaCRCp7rQV41qEQU
	x9kVD62Ll7ygNLznl92YCFYXzX+Twgrc/Aw/gs6Qe2DcHqxzkcwckwe577oEAxXTQTPhjrbzQq+
	xn93yYKM0AfLQ8i4XBwLPS0wHCCVqCMHdsB638XpcRDVpzQCctpxYHp8EgBiusj5LHhT78VcqSs
	ZaKgwQQIHohdkkLSO9ylZ9pVb2u5cwaf22dnhaC9Csw9Xg9DMGz0SQtc1txU0Abg3MN7QewSBSg
	AZzYvpzfOwJFYL/TqUWTWmxaCkscYRgHWP6NQ0jZwK3VA2daqpoxItuKdeetJAZX9wf4TM/wdlm
	F08mjemIyR7Qf+MX80zLZrUS7YYLh1czuQ8W94HlpfzhyTZYugNgg==
X-Received: by 2002:a05:620a:29d0:b0:915:9fba:8794 with SMTP id af79cd13be357-915a9c4869amr70450485a.6.1780599060453;
        Thu, 04 Jun 2026 11:51:00 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:51:00 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/14] lpfc: Remove slowpath cqe process limiter in slow ring event handler
Date: Thu,  4 Jun 2026 12:29:33 -0700
Message-Id: <20260604192937.65605-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a cqe process limit of 64 cqes in
lpfc_sli_handle_slow_ring_event_s4.  The HBA_SP_QUEUE_EVT flag is not set
nor the worker thread rescheduled when reaching this 64 limit.  This means
a burst of over 64 cqes can incur a delayed processing penalty, which can
be problematic in large SAN configurations waiting for rediscovery after a
link perturbation.

Remove the slowpath cqe process limiter in
lpfc_sli_handle_slow_ring_event_s4 to ensure the slow path CQ is drained.
Add log messages to notify when the 64 cqe count is reached.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 31ab72cbee95..5c559cec9f55 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4527,7 +4527,7 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 	struct hbq_dmabuf *dmabuf;
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
-	int count = 0;
+	u32 count = 0;
 
 	clear_bit(HBA_SP_QUEUE_EVT, &phba->hba_flag);
 	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
@@ -4547,22 +4547,39 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 			if (irspiocbq)
 				lpfc_sli_sp_handle_rspiocb(phba, pring,
 							   irspiocbq);
-			count++;
 			break;
 		case CQE_CODE_RECEIVE:
 		case CQE_CODE_RECEIVE_V1:
 			dmabuf = container_of(cq_event, struct hbq_dmabuf,
 					      cq_event);
 			lpfc_sli4_handle_received_buffer(phba, dmabuf);
-			count++;
 			break;
 		default:
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7771 Unknown WCQE completion code "
+					"x%x, ignoring.\n",
+					bf_get(lpfc_wcqe_c_code,
+					       &cq_event->cqe.wcqe_cmpl));
 			break;
 		}
 
-		/* Limit the number of events to 64 to avoid soft lockups */
-		if (count == 64)
-			break;
+		/* This loop runs until the ELS/CT CQ is empty.  Post a one
+		 * time message for debug support when ELS WQ ecount
+		 * completions are processed - this represent 1 full ELS WQ
+		 * wrap.
+		 */
+		if (++count == LPFC_WQE_DEF_COUNT) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7772 %s SP CQE count %d\n",
+					__func__, count);
+		}
+	}
+
+	/* Log a final message to note how many CQEs were processed. */
+	if (count > LPFC_WQE_DEF_COUNT) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				"7773 %s SP CQEs complete, count %d\n",
+				__func__, count);
 	}
 }
 
-- 
2.38.0

