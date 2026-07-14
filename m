Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D60D1D130E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989476; cv=none; b=szMQKs+600CVZ8EzIiRO4PCUgBQYVKZQMtGXGqACb2Ddb9TpwtHu4eo3F2c3xnIvUL1ImYGURuRAen6d8/8kPGagQzoAxRN1hlDC4EjbjNqglRQoUeB7Zs0jwvzZ7YRXwEFGuEO8vs5s1u4PUmfA6KTFXOHPahkvslXAAJpugmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989476; c=relaxed/simple;
	bh=PktOZU4KIfxS5c1UYHqTSEzv9wdS1q7DdIISYMa2PCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hKqNaRwHYUdNPAQ+7ipEPmc6VgpFysMo80KP7Fpwb4BRT2jliXXugsdRH1jZbHlaPZhQtKVouXaOyIt07jdsG1SnHb279e6hMGGgB5qZgkwpW3C5xaLftPokWLbE3BBbZJTn2OeIH3luyCRVX57yVaBOcfzBStQILna3HYOzXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hAieX1mF; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hAieX1mF"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e533aacf2so24913985a.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989474; x=1784594274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dQfZbNBDXq4CUpgr7tptmOSURbw45sZ0u+5nUUiDbZ4=;
        b=hAieX1mFdWEI6vNTQ1YOAboRs2LcsXNf9nx6KhXTV+myj8ZcsE1ZpaY/NN6NfmcXts
         HHR5qD9fwQz9/QC9eJ2J0il3ULikYVMQqrdWxcBPn1DlDWsD1vP+l2A5kgAh+Xnc8jf9
         MjUJWUOrZKTtxM5LBupqub9DBfKHH6nMxKLXRl4WLyopo07LfGwl+N/OkVXK06HrM+pQ
         BiMeqekNfj9WcC+UXyK/1p4iI7utZ/m8o7iGyMLjnBFJn4br0aDD4r2NfW/37YHNeR2/
         p/CanVhquVnAU0283HrhYOFZXgGDyOuHgMBRUmO3uztcFR2FxcXMUIvAvb1q3ccpB5Wj
         /oPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989474; x=1784594274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dQfZbNBDXq4CUpgr7tptmOSURbw45sZ0u+5nUUiDbZ4=;
        b=Scrd4+qracHpY7H/D3w43SUnIHpm9P20HSulGKCFFgI9dYqTHqe9TG/tNqSOlsUnJV
         Hdjov0ZLCOptk5PIB/XcX7J85IjSvn+uSoLrcTVY1Akbiy9u16qZa49v5nccJ9qhg0hO
         vy6L5bo0UMSPbf4N4RbchU8d9GlcB8kQ5V7wrxxaWCFhYzVoA+riFGEXkqkJwnsaCsrH
         rSKIBgLK6AtJbUrD2t08aL1ogYTNjzgg9C69iGQ72rhQM0q4PMeLIr6ry9u4TKcqbxf8
         jJbkLKfBAK/CRmTv85LMruOJOouevzcyfdfCFGyys27GW0H46cZxiD4pbSfbWiILRvfu
         qaJA==
X-Gm-Message-State: AOJu0YznP0Af3vMVFkEcOPcgLGBXC74fiPACyG2n/i4+bYSISouQwpql
	HCqY+URDGMiKSGX555HKzXT8/f2HrAMH1QrZPQARE8W5zH4GExTWmfQKxYyGV0dtUJg=
X-Gm-Gg: AfdE7cmDeMEy7tt84BtCBW/cYjL5nRCqTJmb1SmFm76zariqET5QP1qsLouBT0BvJR8
	CliueM08alZBGSsY2QLWFra9Etk0PzpnCDwWos5FLrodp1IKdW5QKcFyf9xIKvYuqFZu0HKW8bk
	q2BMSuHnDA6v8QFARBsOghG5yGkhUKfCcnrbLF0KA5HoNlK7yimf+nfYXb0zBaXx0zKu6s3HdLE
	/UsUhHhCOvH6wX6kGGOL4HUFMXck7EF9bOgO67H9+FEfhgbzvECIuKWTnS2e5DR+oQBJf1H8G2H
	ffGoVHPI98dGuPAF1qKU7J93uOb6IJR+aLdZUePTFbJYy40lruWvSRqkQaeE6lFoHOVM+rsaUOu
	Dyc36qrbTNfD4vKxoJklSmA5YX9/uGW58DWcIuOlzg/T2cRAJORd4sw71DocczO8nz42P65+0Hx
	XpsdRncbdURdO6ABzJKXzIdLVHQLB39rgTeyBPWhVmFFfCjDXxZkgAVOOnRZM10o+/OraSIKOEJ
	WjWmL43ZS4NSGfh3GoWPK+NmmWLaPGG
X-Received: by 2002:a05:620a:4608:b0:915:fad5:90a5 with SMTP id af79cd13be357-92ef2cea53bmr1225608985a.54.1783989474332;
        Mon, 13 Jul 2026 17:37:54 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:54 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 10/14] lpfc: Remove slowpath cqe process limiter in slow ring event handler
Date: Mon, 13 Jul 2026 18:18:08 -0700
Message-Id: <20260714011812.106753-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
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
index 0a300efc9240..424ad15416ef 100644
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

