Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640704;
	b=3rak2dZvCwu9Fz6UyjeVm264pkUXjahxjNAl0WkOjtGMywMFL0T7S5iHHnNAzAfIfVb5
	 +IKvtoOS3m7E6qga7dEnTdiyowRZkrmCjM6QPVy4m/9C8l3nfesfakYpmB8v3M2/lKBsu
	 bj2RXMHAqGoJXAxoo2QfELbqJPKYcua0FcJcZB65z+dfxq70sFUM2iZxADd2LaHHU7vxg
	 X1Z4jKJ4OPIqCHYEG1pTQrV8ZiPXccXNSPru+vlL40jD3fKTRrgIfbHVoMDiry7L8J+kL
	 rkBG5Si/yZRyvjVTzLG6ppW3YZtppd3sJlqCTrJLn3eNc7S12JDDrGIHneG6TaYjrog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640704;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=akknKNV58WXQ7nC2UkOhMmYCn/cmxofWONSsK2knhEA=;
	b=1udGCvRCrS/OdnvKXME7RbKJP3zh1LRYexLkAXIWQRzgMbyHPS4bTE6wSPkQTUaDVQ1p
	 6MALpNyL9np6sVHmRzMldvwO05tZMn2Sk3Bt+gi7tAjo//VNxahRcryj/07dcN2jFCHXc
	 WHcTrAuaiKCnf/75MQEhJPM1vb+WOqDH2+jl1XQu+xtSvl0AvRSklnA/aJFa6fwYGOZyy
	 Wq6gU5pg3ByHtc44kZ5riPiGMK7caBReIIMnWqX+Bao0E5DswOkaZYwsPtmayVD+BLxop
	 lrHoT3D6CcZROuL82oWe15XwQdKo5do1uSCcg+2y/75mZLHL5PQlbjXhi9OzI6GvZUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lgF9307k;
	arc=none smtp.remote-ip=209.85.216.69
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D814E606A323
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D814E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lgF9307k
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso1521632a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640693; x=1793245493; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=akknKNV58WXQ7nC2UkOhMmYCn/cmxofWONSsK2knhEA=;
        b=lgF9307k0B+RV6MQs78VnTvGLKvvUA0s01nSQSBIyTU6EC7geyYXyKYz7wOUCOYGsy
         50z3azXN+7BC7x+hHdZvnAlHQtoUAlUVblarpQ+DgfNMMYp2XnjnMpu5wwbekpIotQj2
         kPYE4ojxEoeOIMA4F1haw/8+fBkRVJ+HiRkKBl0+7vbYhClGUlQTZsw0wQzCS1tj3imL
         rTQxTX9IRzecAF0E8SaWjVYI2jw5cpt3VT/3ENSHFqEIuzGy/4lO8MaIQnCM1Sfnspo9
         H16yBbPJtHIqT5whr9L+g23RbdXH85KU5ZPkALD1Jl7RrC5yakrAyMibqoL0e61UCyWn
         JTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640693; x=1793245493;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=akknKNV58WXQ7nC2UkOhMmYCn/cmxofWONSsK2knhEA=;
        b=vP+XzCmMarRKpoAGuhkYXmjeAQ0ukxrJmITc9oTdf2el0vf9h84PQ1ewSrUriiOD//
         hNGvv7qUXfp49yPSWfPS+CwyUyWTZqFrjKkzDPaKz7v+YBZpqP2UGpWbzFDxzcvI86yS
         oLe8Ccs2YhK2X9bptrX3CIaM7cMBF0zVCCjThvrk0Epfqx8LQHSg/pmEEFV+nx8cCIiH
         HFt/mQJgP9Ks3fVXObk+Jb1c4VJNNBmm49hZu8GZC2ugT26F7lgkQtzMLrTt+CfvsE+L
         96yY+c1SZvGXNANKSqYP/aeVVs306QdhRRAY/HD0Rdgph8KZvaARjCAKY1tLsJVhn4N6
         pCFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTZPu/59Dki1T+AJitXTrS3KtDo2+EIFAirHkvAf8RVKVqvCRt866sNyCF+JAINwzCi8UA2ehc4sm2@vger.kernel.org
X-Gm-Message-State: AFq9FYLUhDjzFEIplPDQv2qGRnYGhM3S/fT1shIU9sMBBkvOhFfmUSJc
	2F9xqDRx0Rq1tw0DNei/o/CwBnZOapOT9EYDGb99USpDRsDDCdzTnpe46FAsE08wCq5tXBwAH6m
	iTyJhXe7fCUaIpvXHinWs8A==
X-Received: from plso12.prod.google.com ([2002:a17:902:bccc:b0:2e5:e1dc:c5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b8c:b0:3ac:7c52:faeb with SMTP id 98e67ed59e1d1-3ad86d0bc21mr3695120a91.41.1792640693097;
 Wed, 21 Oct 2026 20:44:53 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:41 +0800
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022034443.3034432-5-stanleyjhu@google.com>
Subject: [PATCH v5 4/6] scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, a command that times out during a power management
operation can be released twice:

1. The command times out while its normal completion is running.
2. The completion path clears BIT(rq->tag) in hba->outstanding_reqs and
   releases the command. It has not called scsi_done() yet, so
   SCMD_STATE_COMPLETE is still clear.
3. ufshcd_eh_timed_out() recovers the link, sees SCMD_STATE_COMPLETE
   clear, clears BIT(rq->tag) in hba->outstanding_reqs without checking
   whether it was still set, and releases the same command a second
   time.

Return SCSI_EH_DONE when ufshcd_clear_outstanding_reqs() returns 0, as
another path has already claimed the command.

Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before SCSI EH")
Cc: stable@vger.kernel.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 68b53f89f8c6..ff5977f7da68 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9660,12 +9660,10 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	 */
 	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
 		if (!hba->mcq_enabled) {
-			unsigned long flags;
 			struct request *rq = scsi_cmd_to_rq(scmd);
 
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
+				return SCSI_EH_DONE;
 		}
 
 		if (ufshcd_is_scsi_cmd(scmd)) {
-- 
2.56.0.218.g1ec904b173-goog

