Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484479;
	b=pazStz3dNytiVyoWma+d0mEOeScQpKSx9Fy9MYyECOkAfb0Dveg2GnKJJgq+LPWUcR8B
	 r6Z+l++wKPhjwgzFRtXSee46VzJ4OQhlRdulQzjYDZCdqXr65MSP091Fke9CPVlr6PnHk
	 KJPg8H8WaDAjUHuWvBQQDABOaqvo32OMaHPS3GF0gJb4FkLJdziJfYJMmoGnB7KDOmy6W
	 ZKcVVKGCZKklCfXMm8tswVoUqv2HrFV/EMioME1KOWewmWS7MxnnhliUXxzTO7yKcY0Dd
	 cLyrTTlBnUnF6bxgeXJs+b8O2CargK5P1wQ8FoHcZ3f8RqE9pMKmGGoFJxMvCblC7gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=YxDpnFYtRSSmHdlBVXg/Qu2h8PYtM96rKGEWJhj/F1M=;
	b=hjcOx2aabWngLgg8j+Wu7MTTZxEgshpQ9h85igfbT5qem+te6V1l36Cf4nNzs0vFCp+G
	 XfpiIwLP4FcTfZz+oqB7cG1p1VJsM1vTGBLArPqIQAijF00bn8mPwWw80whN6E/LZuW4E
	 Vdl9w3HK80sXnyYDW2VmSKgHICuWLhlc02EixT/7G8C0UAvTuul2m3w5a1HBst4KmMuuK
	 9iJ1bwdO0TpylI2wXj5nMuiPq+J3KoPiTj5EcpmWOjCqXOj3aOCjc0M4YPngr6k/Lmrer
	 A03mzqR3xLXIKk55AguHsAUgCuYyOx3QqSmHhcnCjjJ01Wn6CGbFieE3ZSRLZsZY/WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JMxk7x4c;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9A460A261A
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A9A460A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JMxk7x4c
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfc52ddc55so30832545ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484479; x=1793089279; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YxDpnFYtRSSmHdlBVXg/Qu2h8PYtM96rKGEWJhj/F1M=;
        b=JMxk7x4c9c13EkDJWGRjjv5Gq7Zfra+v3x5MhbLQWSxCXqQ8ABlF8YxsYbmBe3UhPv
         qjC+91LhNCVmh+7jo+6q0YyDGc/Vf2F2g5gUOa2aFSgJmSzzpxBlQ8AXGIYKl/3PFBer
         mUb9vmRaktrIs1bwzZaVIUxERDwuEw+uHGd+Y+KDct25eneb68P7tW8JkeVwXrHzSZEy
         +9S7oO02mR0S8G9fWbBqaHCANT/SaV7Z1r4oGKClaElCmq673K/wM8i1/3j24qbnyJOY
         PYKmquKHTWoQBb97UNb2WYDpLAaXodFreO2VqBSe1YPB4BngMgo5UMG/hlemW4IXI5yi
         3uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484479; x=1793089279;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YxDpnFYtRSSmHdlBVXg/Qu2h8PYtM96rKGEWJhj/F1M=;
        b=LasfWu06C9Ja0HamheyeZ4NSASDKSCO6c+7EXSnODOHiRLwTVx0vVV/Sx4Ath2/YTE
         lbE9zhewQkT8Q9meIVtjOQ+XSNGVRd/lgjYzV8Ejbrh8lBQk/fiW0mKZS3FBX+27ggm7
         RWy5u8Bb4Wt3SnDB+Dfd3vO99hWUZJ4uxjkQT8XlX+eXodomKvnN/HLwdss1P6XlVNRe
         8CD/dUeRNSSptmP6+EA6phlx3VNiQo2ixAjkzrCE9sPGDpmZluzwpVUJ7N/O0ArYp3XU
         DhIS1mZfgsnyqEsyP22ELEE24uQEuzwaou329Ft6zsv54Q6RigP9TaoFAE0EKNKKoeck
         9lVA==
X-Forwarded-Encrypted: i=1; AKwUvBzZLvgm4pAfB9Ki3zLx/WUxqr5svSvouyneenfcTaD7olJuOVQ/7AaeWSEWAc9TX6HDL/bKUZZH/IO+@vger.kernel.org
X-Gm-Message-State: AFq9FYKBIlBVv8TyRWfFqRKffnUAYHmj6n63KCCBnjIPXRPbjxOrXYSR
	JFK0dk72pq7JVjamOFz+xX6NugIFFgRcUKrhjdWcNE6TPHIKUy4dFZFqrDspHNROeAbu+0oDVLo
	z7/i1CUGTNz+bOUoNsi99Nw==
X-Received: from plot23.prod.google.com ([2002:a17:902:8c97:b0:2e5:82f1:b868])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1d1:b0:2dd:c100:80ba with SMTP id d9443c01a7336-2e9a6d36004mr84600175ad.53.1792484478330;
 Tue, 20 Oct 2026 01:21:18 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:06 +0800
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
Message-ID: <20261020082110.3511797-4-stanleyjhu@google.com>
Subject: [PATCH v3 3/7] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
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
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b28dbba03a9..778932298e27 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7978,7 +7978,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.56.0.212.g129ede20d9-goog

