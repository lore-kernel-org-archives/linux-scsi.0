Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484488;
	b=clsFlCDJJIo3EPJ/7NG2Ks+7/ClsVcKfE0Os1t7SMpND9abLf8fNHgqul6CTB6slJtzF
	 ifkr1f2UPFoiz/cUU6KljceZdTm0NKIHaMzlpXQfwzEjRWyISLMBFm3hXVaLKC+UqzrDC
	 BMKmCBJom+XXwdgdSIMzTJc0znzosrbD9vWLQWG7k2p1L7UEWamldHaUeonJEeMK3gEii
	 yQsuqtbCpFkrDvxOOPl8c8roHKnQriRc/2cXfUPNyPPfXZ4tEaADMvQkepRxSIjUedFv6
	 nzXKChxB0x4IbqbfQcxT1uBeqGwHNa/omxCdQngILi3KhYNBYsOkmGNJRlfJWVoI+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=QfQksp9PS41+54skybmXZINJknlp8A4XjgUEvLqvE94=;
	b=JNWXuBOglRjdruiqfqDPCjiKidl+RpWQnYjKp4o8N2ayDJDmKM18gqp42NzAJE0p0J+t
	 oUryP5pVJU2KTNwhuAvnDhumItZl6+ZmV1WO/IDRfOlovqEguDNd82hcApB0S6kwRjUIE
	 s68vzKs9AAbQK2kahiOaQCTGhTQkqnJK2VbJhRL7fRukZjmdi1KknMsJ7eQdd3dcBJup9
	 F98LEl11wTYCIRVtZzc6ljxmjC85IjWdRH6bW8wtgKjSU8UXG5xgxfWgl8pTkuWcJ6PCy
	 Zphkbg0qt9tm1nM3RzSX9B3gT2dGeqA6XQ6cx7tI66unBmdVFH3DzAKnKFqAob1QcVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PmQHgmD+;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007060A3829
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8007060A3829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PmQHgmD+
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88b9d8c9e55so419313b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484487; x=1793089287; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QfQksp9PS41+54skybmXZINJknlp8A4XjgUEvLqvE94=;
        b=PmQHgmD+RqZPhVAOnU2H3tMW2LkFO9svX6eoS+4EC7M7uqAk8qUV3dTdTzhlGGA4Pl
         YYzBw5jxwM/Efc/YE5q03OBcZ/nmIWn7foyyZNnz08SspN2xur0GIFAkHzsa8J5OUXA3
         /B4jT4o8dE62YvvQcwCTlmjiIlbKvbiX9QozO64GDl3HD0OEVPGNaogecCdcencAFQ+N
         eMMTbrfxGmdwSRbFiSZT+ygGdI6RBBqOTCFZ2JG6aE7B84Ivl7HknKNIOK0tiIkivHcQ
         uIRh87+RNHSsu4V1dRzZ1FfGdblGh6/D+k4UjE3qGmFFXatVfeCD7vGIsU59pqwFJCcI
         egBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484487; x=1793089287;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QfQksp9PS41+54skybmXZINJknlp8A4XjgUEvLqvE94=;
        b=WWEHa+j8tDCFpQxsjD0n06+nLmjgY9oZK4k3lliRiP5qM9B4LeZ7CWgLV+r67/0tu5
         4PPZpMCIQXejPdXDY8+XLQMdKN3BsoQxw/xMqoFtQaYNTkLmI1snE5rT1LuKLRId8N+v
         O1jje/7v8vYH4Rab/ctYnaZ9imA/j1nm7jUR95ccx/NskblXVO4D26SjOqZ7vkwi9nt1
         wUNaQpkYUvWEgboSCnEXaht3+9H1Ik1sAPk56iPVQgb8sWJnBQd+Sfy4BxZuDH0reibO
         7tnOgM0pxZYTJKHrCV92N8nLeS8zuHFeiSVqy2UZp/ZhYlaq+IE2AUaF947ulAteiRId
         aMSw==
X-Forwarded-Encrypted: i=1; AKwUvBxIR94+bID2Ilp5Zxi/Q/2jjZUwD49fygmfguOAVaPBIUz+mbwlXEM8R47i3/ow93HcrqA43Nc8OVzD@vger.kernel.org
X-Gm-Message-State: AFq9FYJhit2fe+qfRtp7IfqXmZyDO2jPagdXy685N3nPKLy2CI8Cam0H
	hH9vdSzOPb4yGhNnxsLj79TiGiugy3IIFK9AmhXEQp/3DCFOca6Sl+GU7OTeZUlURLJauuoqjqH
	5QBM2/Bk9VaCz0yXMgLr60Q==
X-Received: from pfnj7.prod.google.com ([2002:aa7:83c7:0:b0:898:802d:e5fa])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3d0b:b0:89f:1b32:29ba with SMTP id d2e1a72fcca58-8a07bfad6damr870764b3a.13.1792484486558;
 Tue, 20 Oct 2026 01:21:26 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:10 +0800
In-Reply-To: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261020082110.3511797-8-stanleyjhu@google.com>
Subject: [PATCH v3 7/7] scsi: ufs: core: Do not release a reserved request in ufshcd_abort()
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
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee898f4a5bb1..5d1a9b4e9b8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8228,7 +8228,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
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

