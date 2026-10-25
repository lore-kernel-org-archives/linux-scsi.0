Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892097;
	b=zNggq84xTpZ0RMoRRvxG5m2aIm99y8T/uURcZnkTD6Ul1GVlzrWqqaSARvGo3rAQQX6y
	 Iy6K87/FzF1kO8ZwEiK5UPWi9tl+AjjBRfqv/UMxnMxdXs/axqtiZNFXG74KUWV54wTCv
	 9ZXIyeX2zBm+CiFfVLfTcG/Kj9YPFJZ6wcGNuKivOH47jxM0Ufzyq+HwCUiqBfqyQBSBd
	 mKbUXDOjX1mfC60Dlh8Yb9IcP6qDiNxEqD69/uUu3oLeTj0rn1a7IAlIhW+01y+l5Qx8Z
	 c6fdLUH83By8SlcMB2t91aYqAUIMczpXg3YVSczfIBeXO8Ha1unSCoOrjYiEiQazMBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892097;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=AIvu/rqVnupfasFxvXjw2EGbKljTp1m69eUHoTTJV9I=;
	b=gckxjIMoUVMdINDKcjidiUIYgFiGNhiQgzfRZnsLdZ7OrC+Fzkmo+pDg1ks/wW5fuud7
	 CIerLj/KDgA0Z54uAsPpjBjbQfsTtc4u+1bFGd1jJLpLQEdD3h++VMFmmGntKqvghhI+c
	 AMap9s9I1SXKf2q3q6gJ9NpnUNEswk8w13eFS+dZE634ejc3Lq4galWWRqRfUf2UgbrNR
	 rCe6Qe+ceN4uymMHLMGktgXiOHQZl/GO504RuxabXVW0e/635orFxpx7ZqeD1FHiAbl5l
	 3XmSJk/9VchlLk647Wvv1ewAjyxI/d4cQbbKz3g2k2XYp4+k0/RAuRTtW/ScTD0VwhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=meRXun4M;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB45606A33A
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 01:34:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDB45606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=meRXun4M
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a064f294cbso1573179b3a.2
        for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 18:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792892096; x=1793496896; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AIvu/rqVnupfasFxvXjw2EGbKljTp1m69eUHoTTJV9I=;
        b=meRXun4Mmvu+G3QNS9CFBaKuexKED0W7tcQDwPMkKaA773VOQuFVheJ48D2loz/E2/
         htC8gwFFoBR5WElK9qWzOz+zWWdDZX9BUeRXxBOxKaIi1EbRjH31wlAjAmJRYV++5BD5
         uKl6P4gM03fe5S0HE2r+x3damWoopGd/rPAder1qxEvHvgjuSX76+xZuSkTHCovYEbh/
         RtHnqvYfQC5n+KbDVIvtFx37iE2Z3zGL94lsJGTAMvHZCdjoCvYyr/OnjmnqP7IL36oG
         P/XuSRvsxy7EmhVN75t1HNdviJaU+iYVSCQy2uZv08pCA1l484GcrAlWfJ6BDOq1fB/v
         aiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892096; x=1793496896;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AIvu/rqVnupfasFxvXjw2EGbKljTp1m69eUHoTTJV9I=;
        b=MljWml5iGjsOK2XM9lsT+MHpMKSTxawpXKcdRFlw+B5/xTTK2wPxM6iqs6obWdTpFA
         KtL4hV8NjkC16J4FZHmh83H+AOEjxy59cQs5VHMNo3j7O5pzetQ+7K4xhpcb2yj9Byvc
         iCl5mRHZyKfYTm9j4jTCkFHMGGMbpNh4pQUTaZX+3Obrex2dhuc1Nyrflx6WVfpABEYy
         Z25uPPWs3Je7aJzwR11SdO1xwaWNrJXIE7cL3mZJJSgenvOzfRGBRHlhRp6A7k8X/A7X
         /6ur+H+ykcwE49KLcAz/i1ZHA8iK5ekslMiN4xLr/zO8sKRdPi9pKnPIMPhm5tvoTWf/
         INew==
X-Forwarded-Encrypted: i=1; AKwUvBxe5hx/sBtWKJrnNv03Z6KGj8oVPa/j3pt2a/P3Koj3cCUl3iHUOW2B05er9/XD1oIHMGIMVZs9/g1E@vger.kernel.org
X-Gm-Message-State: AFq9FYKv462bHZw5XluFhZPeho6OoCW5gxDG+px24tcdkxD8rk/6Jb2I
	3pGitveJU7ybePn/D9Ucpx7T8xoRvSTKfLKAicd9PWV+X6H223FgyBM0SKL5epjP3/Q+xzoW075
	JUukWzltU7LhmrBJ1llwH6w==
X-Received: from pfbf9.prod.google.com ([2002:a05:6a00:ad89:b0:89d:e1ff:97f3])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3cc6:b0:883:904e:da56 with SMTP id d2e1a72fcca58-8a366f68ae7mr2652022b3a.36.1792892095863;
 Sat, 24 Oct 2026 18:34:55 -0700 (PDT)
Date: Sun, 25 Oct 2026 09:34:45 +0800
In-Reply-To: <20261025013446.345974-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261025013446.345974-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261025013446.345974-5-stanleyjhu@google.com>
Subject: [PATCH 4/5] scsi: ufs: bsg: Abort ufs_bsg_request() when runtime
 resume fails
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In ufs_bsg_request(), the return value of ufshcd_rpm_get_sync() is
ignored:

1. A user-space BSG request arrives when W-LUN runtime resume fails,
   when power.runtime_error is latched, or when W-LUN runtime PM is
   disabled while not active.
2. ufshcd_rpm_get_sync() returns a negative errno without resuming the
   device.
3. ufs_bsg_request() still dispatches raw query, NOP OUT, task
   management, UIC, or advanced RPMB commands to the unresumed host.

Use ufshcd_rpm_resume_and_get() and jump to out_complete on error so the
BSG job is completed via bsg_job_done() with the failure code without
dropping an unacquired runtime PM reference.

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
2.56.0.307.g5fe7bd680c-goog

