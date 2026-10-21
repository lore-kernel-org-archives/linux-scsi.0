Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555584;
	b=5IQozlajj3LYI6UpGEdG2o5kQ6y8q0l1V56Ij+tZ5dHUUiZHAkoB5/JmLsxxsjIqSPUA
	 WAiykCh06n088NOvp/Vvll1fJ03ZD0nYjYKhFNviTznyUtu7/CWnqZF+S213ND8/EZE3B
	 IP/p9wXeaeAy6soxvbFl6RppUAmK6b5olJiLRQOa3PhFPuuEMaLrDRxz2rPfAhfDo4re5
	 80QD2G9IhPzKNSHUK5J3yWKo/k9MP0tzjbT0OU3/vYrZeb09jnAS0FD1NXAdf+FLptw9u
	 9d1Vy1MnTMLIU1ZZU99grCe6z5ZgQinvFjtozXHcZTf5DW5BK6vmTDLcQAp6kh2BLIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555584;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ZjazkZwP//tIu4UQiMntOSVxBKhC31LgQF0W/o5JOFA=;
	b=KlWH4LO8I+dmTYhWYbfEUgo9qK6+/5rog9xlFoIf9Z5irZx78Zu9owMNItHk2rMG2ZzI
	 JRN0U9ZFDuSsdSBn+GxkU3iGC9x77Mors+o40LC46zh5MXMFibR9hfOnROuONKwZJ5f+S
	 +xjI0pXwXOVB4i7pHVTrar/PT1Jk2OU7M2aa6aixKNWojgqYwjyDtMBg4+q3PacEb2LG/
	 pc+UDTis6TddaYfTeu22UhTfIDnV0H6Juxfyt5pMqDd8t+o919kiEeBsrWfoh1FGz1AlE
	 vJg3Qa0sibt49w000YvpzKmsdjg9sle5kaUJkLM/2cSOA6emeNdvOF5wrzDuqIqFzKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=jUZwhXzA;
	arc=none smtp.remote-ip=209.85.214.197
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C84606A334
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 04:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C84606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=jUZwhXzA
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ea381ce04fso3807545ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792555583; x=1793160383; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZjazkZwP//tIu4UQiMntOSVxBKhC31LgQF0W/o5JOFA=;
        b=jUZwhXzAIqW/3B89QT7YFMdnfGPqNYd2mgle2ZmJ+WczqnI1TmMyBpx0RBCEBRz9xc
         4guV/oiklfCjo9nSNJ3pXW1PFv6oGnQcfiu/6NzmSj/5vIek6f3PPEjE04eqFkoUvbsb
         1Sk5OvpdLBTrZWYkgnONNyc6rkEYJXrzS0Oo3wBLVwK0iTz97GAvhYw8zuqb5R1SUNUZ
         +Kr2IuKgtRllOXVvOS5pr2Wvd5tpPCJnNUZBJv7b+iq3aB8AMUGEn3t7lR5Is1kWMF7w
         Yri6b/Kk6CBFSJ5KMu779Vw/vOFTidjEvnX6pAwKBiaQ4fyWfduFL1fYWzJbRwN9ihcq
         Q4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792555583; x=1793160383;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZjazkZwP//tIu4UQiMntOSVxBKhC31LgQF0W/o5JOFA=;
        b=H1SHcz+sCfjtU3DrbFAFX8NIfZBfkCqOVnDIvR7Z4u8ZDXF2sr+iF1JF85ZdWbDEU0
         fMk7xhJO2su2frj5+Y+jjXAECfVgZOQV49JyV8OG23CH3f41u8kSSFhGq+uQSrPexVU4
         xansJ7R1mKuS7COlD4vGB6OeuBiqQljcrnT8Hu0R44C0DwsSEeaSrfX6G2Qc+eSYNGeO
         FuPJowcUmULxOKHfsWJWZsTTNw+sVYyonrBWUuWZmr0tg68QTtUJ/eZuLNWf8u42aNLv
         b1V+33haPy9Tir0WZuVR5JJunHq+XHQp+Ht2lpb5cZFk6zYR3ad0ndR9OIqeSpwNRyhu
         5X1w==
X-Forwarded-Encrypted: i=1; AKwUvByEMJdjyiL2/EeU4r4PGNuHH5QaQcIA0TZfmVXyXzZNBExIhZ8UK7dsIVH0fNko6pfEFbKovKbmSEXZ@vger.kernel.org
X-Gm-Message-State: AFq9FYJ57sftGkRxY3vDCP2kwudoV4oPfw5OCz6vgPObe2ls1Xeosmft
	Vy/XHx417m5iEtDF0Ul1ketC6YJKh2Gu+csL5pHW30uuknsQKjOG+E3nsFZtn7anHGc0eKdBDw3
	x4VgRIgz5XP6QIO1AaYSpLw==
X-Received: from plbkh8.prod.google.com ([2002:a17:903:648:b0:2df:6366:11cc])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:324d:b0:2e9:528c:b9ea with SMTP id d9443c01a7336-2ea43dcd6c1mr5259055ad.11.1792555583209;
 Tue, 20 Oct 2026 21:06:23 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:06:15 +0800
In-Reply-To: <20261021040615.3566831-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com> <20261021040615.3566831-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021040615.3566831-4-stanleyjhu@google.com>
Subject: [PATCH v4 6/6] scsi: ufs: core: Do not release a reserved request in ufshcd_abort()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, aborting a timed-out device management request drops a
clock hold that the request never took:

1. ufshcd_dev_man_lock() takes one ufshcd_hold() for the whole device
   management command. ufshcd_queue_reserved_command() submits the
   request without taking a hold of its own.
2. The request times out and ufshcd_abort() clears its slot with
   ufshcd_clear_cmd().
3. ufshcd_abort() claims BIT(tag) in hba->outstanding_reqs and calls
   ufshcd_release_scsi_cmd(), which calls ufshcd_release() for a hold
   the request never took.
4. When ufshcd_dev_man_unlock() drops the hold from step 1,
   hba->clk_gating.active_reqs goes below zero.

Release the command only if it is a SCSI command.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2060a8da-581b-46d1-a510-779f4df716cd@acm.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4f9b34c1d112..49a981b8cc32 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8239,7 +8239,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
+	    ufshcd_is_scsi_cmd(cmd))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.56.0.212.g129ede20d9-goog

