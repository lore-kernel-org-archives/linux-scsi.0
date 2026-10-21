Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555582;
	b=iAa0PgK+VnKRJ1IeKzhStyrBM61ih7crm9NDVo2PBMgi2ZVVWZp0pPMWV5+3FN/8URNl
	 35OLXaQ+XhRW1RyL4rw98beIEFwRybIISvCAZKTfEr9LWpeOO28ed8+2VjQ0J1fmPgEfb
	 lukWMhzGEs5pK7M3AwO4/NiVd9H65ulbOv+4HI5FUN9/1QbglSCPgODHk1Bhww/pHxAzG
	 7IXlTMHDNmWueh+xtn2Vvd2SMNkYJtqi/rMsKWxaIST0CT/QGGBhKNHJGqSR4CqzpmFtt
	 Ucn8xgG3qcW5d5eov3xRxePbGjFg2wh3peBzYvMKd2yW9Aql9SuxbbJhATFd5x8kgww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nT/VS/RnRqL2ufemzKKyohkTbyAY8bWGEfnEEtY5EnY=;
	b=EVYvdV+Yon00EIUhac0G4m+AP7e4vyBFZ0D4CT2EqoQoDniWKp56MEGrER5f/8EBnmG/
	 1hEiyfbE7ZuiVri1sAT3FWh7FDK3d94idGldhD/WPE3X74opILt4/xAa36WIkVbMyQv+U
	 G9Eu/ahp9msf4OwiQft95e/I4tBk1E/wxWuDhGQHjXRlPj/ElmerTgxZBvyfC2TPYPVRS
	 Ndk4jVZe6ZrSKiASREZYcbZF69rJL5dEgGxBdGTUbhjyYBCh16Q+gBSYHOvVSzao7u7V1
	 tZAAbLkGjRpPWa85UBJgN+EDrzFIxwwPYgMy0nlPXBAs99S2O3/ZKWPogoV0ZCPDIpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EyQJZLYJ;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716560A2601
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 04:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1716560A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EyQJZLYJ
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso382394a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792555581; x=1793160381; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nT/VS/RnRqL2ufemzKKyohkTbyAY8bWGEfnEEtY5EnY=;
        b=EyQJZLYJzsyDFKbh7s/0XwlNw4P7pO2/3wcRlA3lal8CrQla4lVJB+X6QX9n6pd/KW
         dEZnRNbM1nZXMoEJAwuJuGOr/H/HlgMYRH6Lb6SI5F6SLdgIvxH//9cCYtbGCcqQ1HE/
         X6tpSRNgUnZ2W/IMmUBCCwijmuckjqh9ZwgD1jnAPYtowjbvcPmlay8a1X1pL8JXTnSp
         4BhHXCtCIJvQAkybvMEcJ+SiMraxmrVLIL++JcxRqXxuSdCbofFCeETIkK/q5/AAfzot
         2x/+K081EElQHHmk0/GckW/FMu7Iyo4uGTfJ/CiXSNaPt55c0hHcN0TBnvVld5eLb//B
         4K1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792555581; x=1793160381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nT/VS/RnRqL2ufemzKKyohkTbyAY8bWGEfnEEtY5EnY=;
        b=cpPxn71JoTtwff9YNIRjLIL1AOpyNY8XE6dEmZ910/eTe16Q5EYyp8OMhrvSuueqsB
         ij7HODDPBpF+t8h2Mbi/IhLLneeCkDdOAWG+9ztj1Uso8aRwY0ZOEx6QpDD4l3ar+0sb
         KnDpaVcthCv7dJ6si+dcfK3AYpSAqqTZuxA4kbqpu5Bi3tJIpF1fvbDmaXLowvyyhLzT
         yg7N3nmZhPwF6KiTCpp88osDJcb8yC7gcP9ykFpUEucQGO2NTGC0++isGndDOR1/mTg2
         zg3vNBWW61oiKuPcMpVgHNCn3vo+CST0O1zGtNgSnMRpLCoVWzTYeDnnaoaaAOm2N4gO
         aDKA==
X-Forwarded-Encrypted: i=1; AKwUvBz6npyIxmclozTfwun2lsO14cLK4E7KX5S5VaWP1iL6Iafs9Clhg4zSd5lqDs6SyBWXGEQK+bnZWAUv@vger.kernel.org
X-Gm-Message-State: AFq9FYLN3OMvARmyvuWvrr/Jocrj9xUtYeUG/rdsn7NtDvraNe3rAp+f
	3llls1sb1RknpXKawZs942UltHf9d0ZNQhyEb06axsv+ACNIAjWjOr/iLgB0bkhXTKFlhVnFCqw
	56Rllcz/wSODCZqFnkJqKCQ==
X-Received: from pgca10-n2.prod.google.com ([2002:a05:6a02:638a:20b0:cc8:1e94:558d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2710:b0:3ac:a7ee:6761 with SMTP id 98e67ed59e1d1-3ad86cc9140mr835137a91.21.1792555581186;
 Tue, 20 Oct 2026 21:06:21 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:06:14 +0800
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
Message-ID: <20261021040615.3566831-3-stanleyjhu@google.com>
Subject: [PATCH v4 5/6] scsi: ufs: core: Fix double release in ufshcd_abort()
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
ufshcd_clear_outstanding_reqs(), release the command if it is a SCSI
command, and return SUCCESS when ufshcd_abort() claims the bit.

Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de
Suggested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ff5977f7da68..4f9b34c1d112 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8185,7 +8185,11 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		if (ufshcd_clear_outstanding_reqs(hba, BIT(tag))) {
+			if (ufshcd_is_scsi_cmd(cmd))
+				ufshcd_release_scsi_cmd(hba, cmd);
+			err = SUCCESS;
+		}
 		goto release;
 	}
 
-- 
2.56.0.212.g129ede20d9-goog

