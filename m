Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4CF1F874C
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2025 02:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765162427; cv=none; b=Tf76haLnspLHvHLN/5PQh+SuAhZwIAeKvCkug4a7YrGBTpeiGNcAegUsT5WtlfcIRYmI03jkm0to3nRqsBEMofQifH7hokBTW4LEY2XssdNjsp65aFyr2HaFWMZdsVMUrn2nW6Cs9m+J4ixyxLnb5wLxkEYrptNS4hD3RrEv8N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765162427; c=relaxed/simple;
	bh=ZpWZDhkk+7rWx7ICEOZReOYbr+Pt63KR9LXvM+11gFE=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=SFipDR54pFl6sxXdyPS+Qpp6MZB1DpUT0+Pq1Ob31LtSZ1PrhlOnTHX2SRv+PU8mSRVUuVyzkHjFO1suV7ew0c3bd3D0FRcdwcxwK+0QzGJ0tri/q/zb5rqsVr3yAW5kYp2b5uip+kt6jEvH4X+NVrrzWRbWH/dm13Mt8p9Mwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DN6UuvNL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DN6UuvNL"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34740cc80d5so7980934a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2025 18:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765162425; x=1765767225; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bxUo58ZCKYrBDXm2pU0qHMkvU2xylaPbcjw+LEaUZ+Y=;
        b=DN6UuvNLCdv5aod8icvmQt0upfRcxn0zbARDikUBfMOj1n2YAAI7DgfRvnsoiQm79Q
         QByVn6/Uyyv1tcbhyX5SFqwhJpsaRyzSyuY5Dc5VdXEn1xylEv18cy+qA+/7JRg9mIZV
         miSwFugVHOSv66DundGaZZl34F/fIx9yjOKHvnYpN2YTpmq5O+e4QjvVZbaRNCmdYZw6
         QngjOPd+keBujuX52os3Le41umBrspC3fO+h8xhYSnwkcbgb+kWr0AJrfODJX/ZLZnDT
         lc1oiNts9EkKS49RT/RdhTaLxJRwQSwdpoDoPrpYb1PLL7dR534MppVCHTLKdEQhLaA/
         b/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765162425; x=1765767225;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bxUo58ZCKYrBDXm2pU0qHMkvU2xylaPbcjw+LEaUZ+Y=;
        b=So/tXktY1+nKVsWJBFz9R3tg8omqhFv4HvIoZyCbQapjoaAhfTHCuaXT69S/p7xr5q
         ZHr7DlNdRnv8uacQqXGrubxIxUUElSsyw6+riw2YpwfXW/+W8gk8WCe8W9kBRQkMn7ln
         s/wQoFL0gpZYC4/2uZL71wxNuOPU7o5hTUcRQtmHyKymM+A9WZzZowV0cSadtKboknrN
         yZXI99wLb6NvCUQCkhS5/fqdZ4o1XmwgshER+cDFdEbsT1IBdC6d9su/HTfdDr2pVa6Z
         T1kXwThbBV50N2ua2ojCUbbL/Bk48DF94OiHUIAesByf2xmXH96pKoVNxaWWwNBUWxEw
         Ydcg==
X-Forwarded-Encrypted: i=1; AJvYcCXpfNavS3Iq9ojOuqOHyiEfXYtpfyIfuKG7BfKgiL95P6gx13+w9f5h0gaUdbr2kbDroNvmY9YEK4/m@vger.kernel.org
X-Gm-Message-State: AOJu0YzANQxXEeau592gk8HSp2meLoF8qGU/CF2Vto4wGgBexGMpOOE5
	LKbWj6o9b24mOQYW+4csrRZ0Y+ctMWxUIGx01pnARddaQxEuXQZfavieREN3GDhTHjUKGds+D44
	yGFCtmEotOn306g==
X-Google-Smtp-Source: AGHT+IH8E/s73JksrRT/edTOWaGPyf+3c563oPKWpaMDulDhGCZ6z+1fc5ggXHc0btqo4hA/Nwlu/ZGMqTcNJQ==
X-Received: from pgdn16.prod.google.com ([2002:a63:8f10:0:b0:bc7:da10:b2c8])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:999f:b0:35d:d477:a7d6 with SMTP id adf61e73a8af0-36617e37c5fmr6500063637.13.1765162425270;
 Sun, 07 Dec 2025 18:53:45 -0800 (PST)
Date: Mon,  8 Dec 2025 02:52:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208025232.4068621-1-powenkao@google.com>
Subject: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
From: Po-Wen Kao <powenkao@google.com>
Cc: Brian Kao <powenkao@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

The UFS driver utilizes block layer crypto fields, such as
rq->crypt_keyslot and rq->crypt_ctx, to configure hardware for inline
encryption. However, the SCSI error handler (EH) reuses the
Protocol Data Unit (PDU) from the original failing request when issuing
EH commands (e.g., TEST UNIT READY, START STOP UNIT).

This can lead to issues if the original request of reused PDU contains
stale cryptographic configurations, which are not applicable for
the simple EH commands. These commands should not involve data
encryption.

This patch fixes this by checking if the command was submitted by the
SCSI error handler. If so, it bypasses the cryptographic setup for
the request, ensuring UTRDs are not inadvertently
configured with potentially incorrect encryption parameters.

Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufshcd-crypto.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index c148a5194378..26a0699c8412 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -16,7 +16,12 @@
 static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 					      struct ufshcd_lrb *lrbp)
 {
-	if (!rq || !rq->crypt_keyslot) {
+	/*
+	 * Do not use the crypto settings if the SCSI error handler has replaced
+	 * the SCSI command
+	 */
+	if (!rq || !rq->crypt_keyslot ||
+	    unlikely(lrbp->cmd->submitter == SUBMITTED_BY_SCSI_ERROR_HANDLER)) {
 		lrbp->crypto_key_slot = -1;
 		return;
 	}
-- 
2.52.0.223.gf5cc29aaa4-goog

