Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640688;
	b=M4261L7ezjCbRSWbhe79WvDg/yg/JHd2xa7YXvSO8bY/VsPdp16hvuOKLu7nTr8U0Fws
	 3OOjVSqW4ywG7kbepcKXvYTOGW3yDSSUfTQUXvsM4J7+VddVSqD/4VnMVTcOGDEtojaYy
	 ZAaUgFNz8+Z800qMqoJrB3U6yMl/QitMNSGUNSM3ydx+JLshKGGIjaFi2Vd6uJChTnNbg
	 qLEU4xisYgUibfW0j9miFY0rzXU/I5pUJU/A6Wyf9Tck9Mvh76OQcpwWxzI4eb4YK8GkI
	 TB+Ek8ZYCqPjWqS/vLcn6Nxiwsk9lHAYf4Nxny4ZN3GTwv9ayXCq0HI6YY+B3/bGXhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=QysHKveO/DaUTR/+yTGHWsUkdc+eQUjN9l+8Og8ZM+o=;
	b=00TElbd9BiDFUUbTnfji4JV71Hu0EOWlhIcSoOsWaPahBERpXghvzLq9OwKtzrLgzZEu
	 rkhxH1yvEKrO7KLS8aSJU18Cgt8b9GujzD+qTabkUK1nLO2PAZsgTX1kRkRHy5brbBMqf
	 cuGhcbTXaP+d43KU6dtoLb/RrwOF8EZtwFVQhu09ly5s+RafdxC5PoAWE097yV3/BkXH8
	 4tj7p9wbbD6IDKgbwUz+7DQ/zQxhh6BYAbtmuspPLF4PAKXO9+FCcsHDa+FoKQJ7oGL8l
	 3VregnqMup38pW9THXCyBBr7GRD5bNqirpzxpSX9G6SPq/S5nERDvZT9BTAKRUBd1ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="fuf/+Nka";
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1636606A331
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1636606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fuf/+Nka
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd63a7cdfb3so917542a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640687; x=1793245487; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QysHKveO/DaUTR/+yTGHWsUkdc+eQUjN9l+8Og8ZM+o=;
        b=fuf/+NkaZQep/4Dm3Bg0EttWWWZKtCXjz1Bs2Hzhxd1HMvgjlfMN5iHvd/uMxBUKAG
         8gXExvEgAUfElOkB2pA4tDmZHy++9uj84uc7Iku+4Gy+YhUuUP+GSuFMxACXLmEHkBcL
         4RpxuDkr4Q5xTNduhcLTFkfmYoGWd6lAmgL2ziWsJv/HSOapfQS8KUGnBY+vYUoRcfr9
         Pk5u5YILLBrQxiqRbU2GIpPSlH9oSWgT4Bk9l7x4U5SXCq9mxKUzvaNB9RpBMwqT6Q8i
         f6VNJ3F9mUMEYLKRWXBzZ7RJZK3q/bjSkgdqgel4SOgiQGMxPz4ivRINqMoDyk54hCg6
         FzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640687; x=1793245487;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QysHKveO/DaUTR/+yTGHWsUkdc+eQUjN9l+8Og8ZM+o=;
        b=OcnzFSk24uXWa6wBByG3TwkmMFZCe+6+H1SzTMuLOQm40a9Uy4sxAcm9BM78uFUzo7
         AiXYBWukdw0EMGc3v5lc+GSsEp3iXYsfw0iJNVZ8d3Pf8GuiKkId3XUPEQKz3ckTohMg
         nE/xjGeYjNpJ7jpdOV79PV+RSSYWH2qp9r8EV3EW3wFmyD7Z33/wWd1/4EmXHiei+HEZ
         6dQn3aUPt4t83RJsVaidNbdRll4e7Y0H730f+xedfI5O8vaTkHsungtKDRejb21c6qRC
         e66NVfRw1JqZ9beojosUru9FnvHi1HcLv9guxZbUpHPLpTSbKBX4qRiQwdyKC21xD59+
         K7NQ==
X-Forwarded-Encrypted: i=1; AKwUvBzrEv4ndvYYH6aHH6BLuSu+9yOFkIO1iO7MP7wQf7NYrWA4g6kJdI0P+VmIMy/rIz1py6okJuOKmS9E@vger.kernel.org
X-Gm-Message-State: AFq9FYLqHVNcge0/NMxZKN864cHVy5N11UI2mnX6vsfJB5gIZovIBzGk
	kvpOceEOqbqPtjvIuQ7OH8mPyhZMkWjHRvt2+NMG/xwWLDr5paHZOhweSp0nWWkikZ+9pM6Aj9O
	VdUyj+Y8l8+IMXBWfFkWkLA==
X-Received: from pgbx7-n1.prod.google.com ([2002:a05:6a02:63c7:10b0:cc7:97a1:90ad])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1789:b0:3e2:1922:c13b with SMTP id adf61e73a8af0-3e287ee40d7mr2467505637.60.1792640686752;
 Wed, 21 Oct 2026 20:44:46 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:38 +0800
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
Message-ID: <20261022034443.3034432-2-stanleyjhu@google.com>
Subject: [PATCH v5 1/6] scsi: ufs: core: Remove an always-false WARN_ONCE()
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
2.56.0.218.g1ec904b173-goog

