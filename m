Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554895;
	b=gWQgYXxqRzsXcIxn3bVt1SAlmOrNiFaASJaacefhniXb3MaqtDBcjYvUFbmPH5dnYbEm
	 PjhYbObENHokOmVIl2nhRDsdC/fON+uzsiJ6pfD8oOowThRd+R2BXrgTA8/0FcW6ZRG0r
	 9Us8wTtH7vFt7jaHI3Sum88SIL2p9f40MGTTIboDhbUnP+2mqQX8eNsORkiJoP2bk2Qp+
	 pu3RDD0tjN3ia3Zx4riPVOucuc3STvq9y3nbNzZHWWAn/w+1SGbuF+ml5JQ68ihwPb2uN
	 zp/W3vSnStW3XWgKrD3eq/W+uMAuQgAhv60Oqy4oBt0A64iOqHGLyoZGS5JROZOQvBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554895;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=9paoukZlfMxNYNsrD2iQm9b4wSqYDltUgKwGmmCVVPQ=;
	b=Zgq374ZKuB6+OFbqNc5k1024sWHJCx6AUeQqwSkkGhHLdjhNYc3xhwzx2OHrsLj4TCfi
	 JUp+2b6GY3LG84mpJUFB5IXsjiy5ergVW+oquqoNQhWyt+r446wbtDAUl6/n/uweRSUAE
	 ib6/9Q2Gkpov/ScSTphKdQTrf1+X4K24/XvpgzlnWmdKxNLRb3BSswo/b2L11Vz608745
	 AospwSOwEAq9HO5PCsXLCtdB/YikGovtjCfftqZEziFBbrZterZal/JKMK5xpgvym+pwQ
	 0ZJkqRjO1tcE0GRiu234+s1oPQm3yPvo/4ddeRfkJ3Q7hUF/1aFx44L5H3WRRbLno0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=BshX87k7;
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13854606A339
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 03:54:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13854606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=BshX87k7
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so260678a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 20:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792554894; x=1793159694; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9paoukZlfMxNYNsrD2iQm9b4wSqYDltUgKwGmmCVVPQ=;
        b=BshX87k7UqcGhUCcykiPVLuDGUEcyg5uEbcP5dUO8wf/WFnE21oXH99/kzrHsuiVbG
         sti91SiziNuYdhkprKmZGYXWq2XG9M63sjOZ/wKq8WPNQcUY3SlfMj3+gIPYrXD3Lm5I
         GxCzwGu6STyDEiiJR7XgTZCeeAnB51JvIuceU1fpSplKkgsB6goxY8CBVaG63Mlhx6ro
         yHvp7U8MVSK1UPjbEpwQZ6TZlx1R0L/afCEYL23h5BV/1hCB7Tk1C7ypZC+JxpNK62hG
         TTaksVtX4A8I55BgyQUvZb8eeuffjDytCSdurjOmNK8qbobHRhEM2UFuOhG6uNxtphjr
         /52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792554894; x=1793159694;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9paoukZlfMxNYNsrD2iQm9b4wSqYDltUgKwGmmCVVPQ=;
        b=yx7rD3rdBvDE7ZWLNg2MJrC1371tJZfgqU2+b8t65b9UMCMyGC9O/p3qDa7jdBEDCs
         b+yuvnTXlbOkp4/9jn3LWkj2n0G0syVWDY3JNjzM4HZ43sELEqB5m3LYtbwSPDP0OIK+
         zZiZX3v3QBtIUPeXq+fVVFdNv3G9DLeaRv3qrif88whQcK0Epb5JnnUv12pkp6N1W0L8
         z3Q2nQDgy7rXYFJpiX76VHCAcdtLwer2rkRnS5r8QJL6Q6oD59UX4nKLLp0t5vOFoLKY
         6ZlFVyxYh7UdUgAeWfUyF7aYSFJ+TfJrhWVJDKn6ECJzxdAlexBZf4MwclqwnUtPBcKH
         AGsQ==
X-Forwarded-Encrypted: i=1; AKwUvBwNviqoWTdnSQNqHdQc2PwmYC4b5M/qYgmXA496BvyQrTCZu8uGO/wRxZiqy9I930/s3eeLxZgKmLK6@vger.kernel.org
X-Gm-Message-State: AFq9FYJwbBB7t02+ku9jW9atEDOCmjFXpxC8Pgk0WLEDiwCwl58SfLlY
	cs1wneF/w1/DFGhqs+GoSJu3qXFaiKYPOr0N+r94cwk1WE3rfwPjv4mNJlyK7Xjff6RHkMNmvLu
	8jjyYnGgn6xcZ8MnlaldNng==
X-Received: from pge2.prod.google.com ([2002:a05:6a02:2d02:b0:cc7:81a1:7ffa])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3a42:b0:3e1:73d6:692d with SMTP id adf61e73a8af0-3e287bb4274mr725097637.10.1792554894165;
 Tue, 20 Oct 2026 20:54:54 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:54:45 +0800
In-Reply-To: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021035450.3488805-2-stanleyjhu@google.com>
Subject: [PATCH v4 1/6] scsi: ufs: core: Remove an always-false WARN_ONCE()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set
to ~tr_doorbell & hba->outstanding_reqs on the line above, and
hba->outstanding_reqs cannot change in between because ufshcd_poll()
holds hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs
is always zero. Remove it. No functional change.

Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..12aafcf1f9b3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6072,9 +6072,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.56.0.212.g129ede20d9-goog

