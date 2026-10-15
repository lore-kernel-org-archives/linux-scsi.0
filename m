Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59746283FD9
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023543; cv=none; b=KlpNgvTBzv1QIJTsKF9OULQqva+gI2hzp3J7vyjnooUgkr99Rt4Hr9IlwYWMIKOtIlxKmch9AScVLX97v9wKHb3oC5hpvlt0Gjrh9VqC8CxmTd6BYQhjBt7rwqThCHOGxEH/p65Qq/gxxYy/0Z1z4wXLVWNxNRRRbLFm+JF+iAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023543; c=relaxed/simple;
	bh=IC2lDV9WNEqtclP/jcjJmWPLdt1/GsUvk50NXKl+4UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fJ4JWENag4S38xMumn/0NhT/I7Z7GbwhQSIAqcpyaIcnKpdZBEVmmACvFoPGfHBp/AfpTx9nTG6XyxXYb8NdebUNVtkEIz/e2U7rzQTtuUjK6wlItInsPImRZcHDMvdrznN8a5hdX+mHXulSi6feZYKa3Dv0qVi3TPhqeFzKeV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BUeyU87Q; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUeyU87Q"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8872ada18d7so723492b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023542; x=1792628342; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SRWH2GXBp6X7LfF5Fg6aMonghPEzLTm3PzIwrXZ3CQo=;
        b=BUeyU87QqQU8N+IzSpZy+SGOTssUa6844mWbJbW1sI7il+B0CICpe7qw05v0tePHLA
         IM4xNi7o6FzyNpPDGdy0zz+MBWqD9VB/mgIVF01Hb4G6BP3c0Ejf3ezPyNCs+OaFIW2v
         N6mlInPj5dhy3UL81cuu0RUiNvPH96kRmF7NRgOyXg2Ju9hs1hY/6Cyse3a6U0owiD+B
         x6u1YFsW8GB0jyyVxkhj9XnnMGCJrTzf5dkPoyukzO7jysTbESGoD6k9qy77wC1lydBm
         BYEkkLFKWrk6GPTr/QXqqhQTa9CFbiw3lBNv7igfyjgWkpTMLFDDnfzf3qVL+hNXpVsl
         LHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023542; x=1792628342;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRWH2GXBp6X7LfF5Fg6aMonghPEzLTm3PzIwrXZ3CQo=;
        b=JzWQhFa9GZ1U1WnDHh9Rc8Qi1M1Ak0hdfePvP/yA6itNbF+qEZ54dypMnRdwjbhx8H
         GN4UH2x7PCxvcA7sAbyjryq1uWkzieH6Zh7DnBdB21LeNCJVopOo5FmO5ehKb9UsfAqJ
         xnbz8CsMacqgXv5WxmfdKfZIkYUAFjSXHPCqifQpuwX8YhB6h4pIlS/pwI88OZO/L/oc
         OzB26nkDn6vf68JfqQXMM0E9LX1lWxqq65g3jNcJJc85ORw9QlS6ik6oOwkMB8jzhY/r
         g+XDMKlc+1VgwrH1G96rjXtcF9b68sJHFkJcu4UujNORkp78Ai6iviK3tdHwpaIGF7iU
         Naww==
X-Forwarded-Encrypted: i=1; AKwUvBwu/5Ev19Uf7pEwGFCWxjF+0ETcqpbG0R3ciV3zs7o96nasQBXPAY74uSmp0DKKmlj3ftNTWNaijHyB@vger.kernel.org
X-Gm-Message-State: AFq9FYI8ZU1+w39oIyL3Vf6poIsq8JqbuWgL4oduyRLI6nB+jp5HQeao
	xIJSkKbwvfHaRZiFSbaKz6PW1SAGuFdP7W//xOpmEplKdB0chta2HQjPcIQgW//qhAbt1Xv8aAI
	IncUoyooPSZyavbPh8RebAA==
X-Received: from pfblh4.prod.google.com ([2002:a05:6a00:7104:b0:87c:6ff0:4192])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:298b:b0:89e:43ee:654d with SMTP id d2e1a72fcca58-89e43ee6e5cmr818714b3a.5.1792023541357;
 Wed, 14 Oct 2026 17:19:01 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:18:52 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001855.3450573-3-stanleyjhu@google.com>
Subject: [PATCH v2 2/5] scsi: ufs: bsg: Clear the reply buffer before use
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The reply buffer is allocated once per tag and reused. Requests that
complete with a positive status do not fill all of it, so user space
receives bytes from an earlier request on the same tag.

Clear the whole reply buffer on entry to ufs_bsg_request().

Fixes: 95e34bf930ea ("scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 18c318d78122..545ef7b79ceb 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -140,7 +140,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	int ret;
 	bool rpmb = false;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.56.0.385.gd3acb90ef8-goog

