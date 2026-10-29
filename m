Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257732;
	b=S1UFvOeldwhRbC0xc7cayFBAn4B/FO/y87w17x4/chX9DUsZUDTVKnLsCFMVXj/dN6rl
	 XRvlZ+SM+0ZNevNq7QvfsvMJ/fwTUS5pKxSzb+BHDat6DQZKMD/DqW75sZL/2OTHg14s2
	 TFAdU6G3hBAHg6KRpnv70uheAX4YsAKNB1EsIQlsqIWcLq/bmBxy/c4SzKW6GzTBznfkm
	 ioKCD3E3rsUYDweUNDdWdv13Q8xV+DrW+A58DfLM3lH1nQKwSAmjFOUQVCMId53vcJ+IB
	 Z2npdULQLjjzln+l8PeG2aVO8OegxYz5c28SWjMdrEjJDXuKNRvUqacOO3BjsyT5hAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257732;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Uif8SUPiQxvyHMNjuvXHHFnBYtEULndqqGbcF57aROM=;
	b=MHNR36BAAHVa5be1SIrqdIk5IgdunisY47j9AxHznw4Xz3oDSg5KiEe0cY8OaOVID3eA
	 l8aprIS6xwcMUp6Hkm0zfmP+gfiD7l8kwgkVqXNK6+QRcJdZQlTeX9USr29thPArbAYEz
	 GIwv2+CIWdT6RJYaCWlHCGSlpDm4S78utF3fZjPmenYAn7WjtLzsLaa+l6Ovj3JZcrf+m
	 D7yVy2M/AOB88FJiieSov4qfgZAieW3fMRWRSfpVVlVeQnwghOZVcxC6+02+9jKmN7/PJ
	 sicT6P5NTBD3oI67h3NzbFYcMMZerPPO1FnEy1ySSRcGyYPJC1bAYWTGS+0wY9ByjDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="F/h5VAaW";
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205E4606A332
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 205E4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=F/h5VAaW
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd67e98f68fso1739260a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257730; x=1793862530; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uif8SUPiQxvyHMNjuvXHHFnBYtEULndqqGbcF57aROM=;
        b=F/h5VAaWMxiH+za1B5Ex14pfj2Q3R2j5BfA5jvwvwgh7NU1VdN23MnxXbbaQcIA80Z
         NYyYanIIBoOQeQBBnLySKyy18thxfRn6fK7RyQxH1LxnNVW/eebRhoMUeKp4yHRSwLfB
         QFz8vjnPnbdJk9DNp6vokaehhxuP8aeOkmIweJLwi+Cp3vzD52cYPwrptjtebPoIztJq
         rTjYOl4Akuzv/koMaTxFO3FxHAHl400hl+3F1OVHb55tsvue8UdyDNiWXG6/9PFwEf2a
         5DwJ5j/OsgaNrXmy5ab1An9qfGp1yqkeLCY3nN7GgWn0n4ngs2mG2fuuRS+J6+3aD2w4
         uyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257730; x=1793862530;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uif8SUPiQxvyHMNjuvXHHFnBYtEULndqqGbcF57aROM=;
        b=EOxGnEjSB4G7U6CR2OYQT7rbWumiYFHuglrxXx87bARF4AUiRYhZaQ+juZH01/DMJN
         CjkcLbyGV9mbxkBgNQjIm4zAErCStxw8Y/03WAQFLroDH9WuSLeHqe4aPw4A1QsqcjcH
         LeBfXO9yCdZ40wlDnlGJcAz9JBayZcugkh7pb5IqIde/bUixfCq3Q7Ig3E9jExtKzg89
         uk88Lb/NRODLxwjtEaDY5ZGAgfNodgE8ABWXRImGpXUpjg0z2MvVIHOhYsYShI67TxN4
         YZtMyUrL3tXtO3i/xKawJGWV/slsmtK9FGiD+TKGUEn4IjC/3SDBsCBrFFxC+4idZKsU
         Zqsw==
X-Forwarded-Encrypted: i=1; AKwUvBzWvHvbzR5Ou8bX3zWQ7dtSdgJymBlfbwhk/N5UUN6v7zS3DUR4C6rOnUIzug3MvmcwZ01kEphqDVEm@vger.kernel.org
X-Gm-Message-State: AFq9FYIpOrF2vrto1quolGpCkJhDqtTc8/inzbUY2zSMYRM6U8fixViX
	t/6c1bxeYBAGHUf8OkgSqjVznbO5ikQxCLggAGF5DqKJ/OdLRoqMKZ4Q6muR/ucUQnC8oXCHCl0
	5NlxTDZ/hLeCWcwQ778r5Nw==
X-Received: from pgbj18-n2.prod.google.com ([2002:a05:6a02:61d2:20b0:cd8:c6c2:d403])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:49a:b0:3d3:ae50:97c7 with SMTP id adf61e73a8af0-3e90226ce3amr3469934637.20.1793257730310;
 Thu, 29 Oct 2026 00:08:50 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:08:39 +0800
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029040003.2100003-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029040003.2100003-5-stanleyjhu@google.com>
Subject: [PATCH v2 4/5] scsi: ufs: bsg: Abort ufs_bsg_request() when runtime
 resume fails
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>
Cc: Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufs_bsg_request() resumes the UFS device W-LUN with
ufshcd_rpm_get_sync() and ignores its return value:

1. The W-LUN is runtime suspended.
2. User space submits a BSG request.
3. ufs_bsg_request() calls ufshcd_rpm_get_sync().
4. The W-LUN runtime resume fails and the W-LUN stays suspended.
5. ufshcd_rpm_get_sync() returns a negative errno, which is ignored.
6. ufs_bsg_request() dispatches the BSG command while the W-LUN is
   still suspended.

Use ufshcd_rpm_resume_and_get() and jump to out_complete on error so
the BSG job is completed via bsg_job_done() with the failure code
without dropping an unacquired runtime PM reference.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: stable@vger.kernel.org # needs "scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper"
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs_bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index baf6ae917d36..8df1a2c6abf6 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -150,7 +150,9 @@ static int ufs_bsg_request(struct bsg_job *job)
 		goto out_complete;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out_complete;
 
 	msgcode = bsg_request->msgcode;
 	switch (msgcode) {
-- 
2.56.0.313.g2479322e68-goog

