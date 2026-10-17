Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E8D3DAAB9
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226653; cv=none; b=Wz6HDpyHyviwiC5+4pvcFKClE2wa+RhX3c0ofDd9fXFyykBULAL8xsenyxGf3zjYFvKrIn5gZqTUxqRL8VyWOvSyEEqXV/MGutsnAgeidaLX8cYWAAZpzUhDaPOycXeQ/HC2JAPw2IygG/b9iZO6ONdMLUACHzDRhKKnvny7uC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226653; c=relaxed/simple;
	bh=CeTmmB6SkjqW1kmZYTNNiYnurC63zXz4RU0lrAY19I4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sn3Zy6BG2O/LS5HHNzbA81kaAPijkKJ4O4FBFVmVtz4lGafKch8CNbZ9mV0ZO8IgVNyYhPv6ovZFyIF8O0cncRRVCXHDMBrbHwR0L2cFT1hc0M2kA0ysYp9AYllRuiaidiUJTrrDiypu/ZMPy/hRi5r9De+kfw2Utq9RqkHBfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SV4pRUAh; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SV4pRUAh"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e60770381cso4531435ad.0
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792226651; x=1792831451; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yQTu0zIoXXKNYlyq1M861vIZFFWQktsOvYVp6+FErjA=;
        b=SV4pRUAhyY2zbqldkkzE+ygjqjNUr9azyuWZsUTSpgg5/RL37EMbRZbgFM6blI3vf7
         qyVuDYWH/2IC3/w5vCa/IYf+CNHB/Ci6AZfO0NX5Oj6Vcu9jLW6If5zjr4UrNBhbfGdx
         Bp7MYtA7Sl4THkNYezv2P4d74o3IcPttkjdL7JPoQQdsWhl0TTzEdhBSt26uembVHpre
         EYY1mspHJwNO0rKUsO5ard4CDgExEPiNAcA03Y3EkV6o2ZyT7QCyycqi8+TbZZOuDeUJ
         lgiksVdA4bzDUYn2K2YQzDUTuNOeZdK6K1TjqI6mOBQIAZsG4ywUZuZItnJCsg0ya4Jg
         nsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792226651; x=1792831451;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yQTu0zIoXXKNYlyq1M861vIZFFWQktsOvYVp6+FErjA=;
        b=ykhupLngerWFuM4rvH2xZ24hUyRXOjVp4jSN5xIIH3LNdffmHNq1KoeFUbSvbmLE1r
         J0U5gfh0347Qk6+cEyVE6PHpUcCUZBRl+SpSVQcWpOIwgPiu/Cl7lZ53qgsOAVdM6/0K
         aAhZy5chAFJAW9KWtJoBOZ4X2wWSZOMNkOXGsIoFABLE0IcYNTLIf49ond1dgqRatNOl
         gj1BvNPeCCYeMIXcX/YWWRle9q0/lfaIGdZsIZx5Aa+KYB53vKBU/e3UnN+R0rcHczHr
         5G/O2u+HQUmnuRUi5KQReFBYttHTMWzqyEG/JpFyYNCHS+ZIHwp89E+riBDlAgNRCfuZ
         Pm1g==
X-Forwarded-Encrypted: i=1; AKwUvBwpgNL1/20JP94d8swRhWNqbwtycn0Kcl8et2LZfVnTKq7we8VUIu1ri1f2/FsAWN3ThyQz/yYjlilh@vger.kernel.org
X-Gm-Message-State: AFq9FYKjJuiWaFgSN80POyKoMLbs6Zso6pfrXd8I4ERz40Qq7rghW9/n
	y61XSUoPTWVEg2IJTVLF4LVZ1fny/qSt/F/t8upXi+D5mdFIDpXoEVsJoNILH41WSfaekvPFqhD
	jIkvZ7IJBWYLQKQnYIQl1bw==
X-Received: from plcj14.prod.google.com ([2002:a17:902:f24e:b0:2e8:44b9:5c18])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e550:b0:2e2:fc90:11a4 with SMTP id d9443c01a7336-2e9a6c13c67mr20677005ad.48.1792226651334;
 Sat, 17 Oct 2026 01:44:11 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:44:02 +0800
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261017084403.875420-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017084403.875420-4-stanleyjhu@google.com>
Subject: [PATCH v2 3/4] scsi: ufs: core: Use ufshcd_clear_outstanding_reqs()
 in ufshcd_eh_timed_out()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_eh_timed_out() has its own copy of the code that clears the
timed-out tag in hba->outstanding_reqs. Use
ufshcd_clear_outstanding_reqs() instead. No functional change.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 531309c7fb79..44e571757535 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9659,12 +9659,9 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	 */
 	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
 		if (!hba->mcq_enabled) {
-			unsigned long flags;
 			struct request *rq = scsi_cmd_to_rq(scmd);
 
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag));
 		}
 
 		if (ufshcd_is_scsi_cmd(scmd)) {
-- 
2.56.0.176.g3575e65682-goog

