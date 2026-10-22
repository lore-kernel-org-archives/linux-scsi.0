Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640692;
	b=cAWX8Hv0iUnXah++w3DU7lFTve5s8EuVMx1s6ht1/iEkrqRIOcHnWxw9iCOuRg78rQya
	 iy5wAhe9s2k5zc8sC3idweg2AJH01QK7O9zOteU5qGDAov4creBfqnSbDcfV400EBZmYd
	 wem3Nu+G4Fb7DK+NwWlF8QQnkdy5qcRWUXA6XA7nJbS+LM6xSqC403WP5+2K5yAdzaiay
	 ncL7nlzRTtbQbaiEn2cyvDKpyFkscyngugYHNpkOqO+tS1fEu+5+7sNRJvfklWIDBQy0X
	 rUCq5duUlBg5m/NYRskkO9sG545Fiv/3LC2XaxtskTS3AqdCEyVvX8qZn3dLerPIfAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640692;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=dmUAl43GwZhqnKNGkW+S2KU6p3o9wRLHowPUl3QmkvM=;
	b=ER0JjkBdl8ChkXyF9XGxprgmmPwwXodhd9z/BFMEqLJd0r2EVCFeaCpUt+vO15Vlo5Vq
	 DrRZoUP0tbUuZCEQb1+jPJwr1919ialv2SpltsrG06EmEBRKv7jc1qsESNH5k6H9Op+KC
	 pZr7kUsamF10ll9afY+yMropV/fV0qaoLbZ6hWu+2gU2xpDw6jMT7fEoyWBCwUIgqfSXK
	 jPAm1CJlPT1tbebZh6kWQeHzCD3pstUWMlsSqUc2uPk9+wguNaSPTihGZus1HEN4WNJLU
	 ZSA8mE/G4Gi++8LQ1+y98qHiIFeQ3e+BUuY67C30zpXPLya+ctuBtgpNRUjUcaFqCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Is02QbK5;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE256606A33C
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE256606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Is02QbK5
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb92868263so689334a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640691; x=1793245491; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dmUAl43GwZhqnKNGkW+S2KU6p3o9wRLHowPUl3QmkvM=;
        b=Is02QbK5MAdnWLelVLAJTZTNDF/cK3Hq5o1cxG5ZKigyMeYidgPh0ftYpw4DSdC02j
         fiEUDX1fncegDLqO7A6fuK8c0bvfIH7fxjkiQ2la4DTrIqAied3orx7uxTxNII1OLVUn
         dQMXNQw8f/dZDXiUEnSpNsdA53wVdu5D/zk4AKeMQ6sgpx7hrxhJHRR7wpKvD/Sx8pRV
         Q91DCpWVeSn8qGkhdOvNCG7gtBBLf2zlh7qjbLy7dVecrgG69m2AEh7wM1vuQbStY24C
         oFYBx2o0zrwjhJ88BXZrgaYSGZppbOlaDDWRsCp4xog6zEPWwuMLNKmvWn/NixbLMWb5
         XYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640691; x=1793245491;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dmUAl43GwZhqnKNGkW+S2KU6p3o9wRLHowPUl3QmkvM=;
        b=OvRKsmp7fRtxloVmfTVfbulhssdTTFZ54XjUBNWvr6zezJBTFzjuSIU1KH3HmBjKWs
         cJwnUaK/d2pLK2TubiRoIq6ZHzNZiwPsbitYkArHeMul3xftDmHAsXUvI/lNZVBJ388N
         +/KlS5XaSobJjsANujB89BP7CUie1Hq7ZbBe0ikFXdRGQpQs4s2p3v66oc/NukYAGGeU
         6HQVBU8BhM3ENqKk/Bc8fXn67y+d5PyX+ktkz0+44OwqqLUicvsEBA3yqStx0eWnfefq
         Z0ypnAZWqZvQ9gOk8SS3366NiERqlaSHw+vLT5kxVJXTNLO3S/vJS8s2uKKR7mW3gN1Y
         SXhQ==
X-Forwarded-Encrypted: i=1; AKwUvBwebtad5PNqAa1CIivcrdrpqhx+6Vx/lrZgUJkeEWmQZdKUw9hEYRTNzXO7/inAaBVbwvLwRG2vSC75@vger.kernel.org
X-Gm-Message-State: AFq9FYLEFCNRAWOPo6nmdFKTyKgSDoApGyV8IqBnwAzSBKSWCWjJnMiE
	pUdeajP9s/6aHSViHXZvl0bOIt3FppsZhq6R5OOI+4ltsqjaxndejjv9pJYIPsqIIcsrdl13nwa
	ZCRIZCbUCUD5ByOS++PZEYw==
X-Received: from plcq17.prod.google.com ([2002:a17:902:e311:b0:2e8:a577:d361])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124d:b0:2e9:7dda:bfc7 with SMTP id d9443c01a7336-2ea4409f85fmr29606375ad.66.1792640691044;
 Wed, 21 Oct 2026 20:44:51 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:40 +0800
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
Message-ID: <20261022034443.3034432-4-stanleyjhu@google.com>
Subject: [PATCH v5 3/6] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, ufshcd_clear_lu_cmds() clears the request slot in the
controller and completes the request, but leaves its bit set in
hba->outstanding_reqs. ufshcd_poll() treats a request whose bit is set
in hba->outstanding_reqs and clear in the doorbell register as finished,
so the next ufshcd_poll() completes the same request again and unmaps
its DMA buffers twice.

Clear the bit with ufshcd_clear_outstanding_reqs() before completing the
request, and complete it only if the bit was still set. If ufshcd_poll()
has already completed the request, the bit is already clear and
ufshcd_clear_lu_cmds() skips it.

Fixes: f18fac1e2b72 ("scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1db572f84971..68b53f89f8c6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7987,7 +7987,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.56.0.218.g1ec904b173-goog

