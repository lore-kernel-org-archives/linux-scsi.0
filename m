Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484485;
	b=fZ5fPvCLAKH0DNRfCZx+5s9IFp9E8MhlWe/w0lDmi4ajr8M9KNdqMdYHPocbXJ//iIfw
	 51xIuMQ75mNrk6mOkdIezvn6NrXw6Prb6vHio+bO9qSS9ysNgPIsWbO9PEqEH+rdO6eHJ
	 MpAP4QzCstHGGjDBcTeg0dN31JEooQzDnRgnPnS5cLmzPTJ8OLA+TorlFyBm8vkloCQdB
	 2fCz5nt1BpAgisfXgVnuFp7AOnO612+sZX5ymx8dmkQ7qwETLXpMPp/vPvsUCZgxGxwwj
	 auxHX10TBrfb2fRgD+QSiqBJSuSra2tQOs2NGl21+FL0sV8iiXI/gt6QNcVqMbeIBDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=hbR4VFV5Nch4/QGCypxNBgz7f6sFPq76eP9tBsWnbEY=;
	b=IzbdwKAfpFQnMaVE9j58l2eGK62xZ6R99dtVAdeyXJiNBv1Pn/oBoxtk2ZPkwpfZGrKE
	 ERzzjIFX6rqwKVy43UK0NvgXzQQxD2jeOoDaCiPAli73eejl4E1xxrK8Ki7nRlDQAWs95
	 hLWI7r/Wh50dZRnjM4nTImXj2sFQZLWwf9rX8+1rmta4AiTE91Vq7c7yQN5ZQUNLBTQtF
	 Rx8OotFmrr2X6se96MYOBDKnsL762XGPzWk8EpWe4mlpZxXi2qaPj8iRjigD7mHQlxGWh
	 rKEjRk+PxHZ2PI5cbVTtkOuO31NsyCCXpOLtm0dhXuDZgj3PY8SLNtR7Bhn1lGEfCaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=O0YPHe+1;
	arc=none smtp.remote-ip=209.85.216.69
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0A2606A325
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B0A2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=O0YPHe+1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3acd21ba24eso2469961a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484485; x=1793089285; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hbR4VFV5Nch4/QGCypxNBgz7f6sFPq76eP9tBsWnbEY=;
        b=O0YPHe+1x6qt9TY5oiAGsoXpN/mMmo/xHdL4NCdgd896fcTSq7RPoG8oZM4xah9peo
         /igpeGsV2Lq6LzX+Jpz4Yw5WYFVmdnd0dR8ieZ+cbnPjtJZYhAhSeTVlqaM/eNxycJ7m
         pBUAMdkkGBDFozH4cRSMiOhkyJdObEvAIXgKB2NdyhDMHgL7nqcUIy6OqBgp0IvO2JFH
         UP8pGwJHcD3JDvJk0yJC3kT2TEiC8ktzPKfPdKAjJAYQZRUDFLpelxNl+og3NOTbaRJU
         7cX4e6kPn33Zg7s05xIoqIpnC4s1ccxN9BUi9lQQTZqjY6QbNeojnAvALxdiQy+pVwWN
         TLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484485; x=1793089285;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hbR4VFV5Nch4/QGCypxNBgz7f6sFPq76eP9tBsWnbEY=;
        b=RufB4XMbLbubs25A68da1eQfesSMzdTDlyRDcOd19x9Gvr7ML6Hmd0EOScrgIJSdWu
         TqkJNnPn5bJqAVkM+qq555k2DSMqrWh8cPR2O/vfrwih+U5bGj80YBnOrgFN8qst9Coy
         P4malGfrovPTG/xm58LlO8CpyKve6d6r9xBA2FTD1glcLwrOw7SKtz6t1fNVZxD5cXen
         E8RPRtYdJmnYMgcMeFsXrhmP2GNaIQDZLKqBQWhg7yrN3q9Do+ftx8EtgGyQpl8cmF2F
         AzM2f+oFZ+6kCh2DReLcoUAu7xprxd2v/767A7/xNpMx2Ore3o1RRde5TrxHvY9El5w/
         wnWg==
X-Forwarded-Encrypted: i=1; AKwUvBzB3gZoY+ZcwAhjiYRFEbNxhDkFZfopFaKPCV2uuEpm9mjOa/6wFNMvWqLSjNb22wVCVvMfS0YNHBiW@vger.kernel.org
X-Gm-Message-State: AFq9FYLZoYHoY7FluxnKx4T38qgWJbKFR9o0b479Upn5CMtACEBaIE1c
	9IBd6dhg2seWwotxxdKbNI7/hb69bpuBdHTmNW+cjOkG1g+S1k4RWcsphyyKOYeI/okv9C2Xq/a
	mUUPWVKWraFSB6nCTRiyPQA==
X-Received: from pgq2.prod.google.com ([2002:a63:1042:0:b0:cc7:e8ee:9777])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3b8f:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3acef3dc9e5mr8054564a91.43.1792484484540;
 Tue, 20 Oct 2026 01:21:24 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:09 +0800
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
Message-ID: <20261020082110.3511797-7-stanleyjhu@google.com>
Subject: [PATCH v3 6/7] scsi: ufs: core: Fix double release in ufshcd_abort()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, a timed-out command whose completion interrupt has not
been handled yet can be released twice:

1. The command times out and scsi_timeout() schedules ufshcd_abort().
2. The command finishes in hardware. Its doorbell bit is clear, but the
   completion interrupt has not been handled, so BIT(tag) is still set
   in hba->outstanding_reqs.
3. ufshcd_abort() sees the doorbell bit clear and calls
   __ufshcd_transfer_req_compl(). That releases the command but leaves
   BIT(tag) set in hba->outstanding_reqs. ufshcd_abort() returns
   FAILED.
4. The next ufshcd_poll() call, or the logical unit reset that follows
   the FAILED, sees BIT(tag) set in hba->outstanding_reqs and releases
   the same command again.

Claim BIT(tag) in hba->outstanding_reqs with
ufshcd_clear_outstanding_reqs() and release the command only if
ufshcd_abort() claimed it and it is a SCSI command.

Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de
Suggested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 111f5805f178..ee898f4a5bb1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8176,7 +8176,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
+		    ufshcd_is_scsi_cmd(cmd))
+			ufshcd_release_scsi_cmd(hba, cmd);
 		goto release;
 	}
 
-- 
2.56.0.212.g129ede20d9-goog

