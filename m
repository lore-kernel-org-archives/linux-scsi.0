Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A478122A4EE
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140851; cv=none; b=LVf6JGNlOYF7MZ/7IgJaS1W5yz14gWHCOE2HrsK6tJiVHq6IZrpsaYfeLsMFEFTtMgdfrv7EIyfwVOExHHUj2tXqvkYB/T2YGp2H4tgsSuH3t/4XjVHjotHkU1ikyuB4R3/93MAuCkQJTzT4uo38g8eV3YUCf4FE8mwu1PFnTrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140851; c=relaxed/simple;
	bh=ckYyMbA5qrVV29KoZnji8oimJR4kycs/+N+sm5Vfj7M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=b7QAebz4zhrPQ5V0nlgZQDbMvTXpCBl2xapsvevvCTolIvgcsHuks8YN/yKuU39KReoj/HdiUCTcZS+hgBeRimJSaqA5heTb1R5CU3bUYRc7CUnZXpbHRT4s63CPCjyKLzOWkdKYjUL622p8p4//hxNrNlbfi4wgsiLTd5MAqa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtOwfF3j; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtOwfF3j"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso6506139a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792140847; x=1792745647; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Myy+1U6pBdwhlVNx/zaVSdE77IqnEToPWj67mGod4c=;
        b=NtOwfF3jbw8AwnNPVP0Q3vsRLg36kAtjWFMEsB76rL8zp42lezQ8qEmpDWe+ZjKFDE
         M9W7TajUuUa9dSOOuw9hnL+5EDY+4/br/PtKJ1w3aNxNLTr9C+k26bWVgcM68HD0Sv30
         BPqpasmvkijamfom9gZSoZ+xDALWecd9nL3/dA1PhBy80WesYCxo218GaxopbfIQgar5
         oYwrXxHoyAq97FFus3n+2IhYe8roXBv0MtXga3BzoVBAQcneoqGalk8uo6zzSUaWRorE
         KhkzJRw6cUFv9hqSxjhosubi8jrfsDgxbucVGFozf4bdd4tVO6lpSttAMByiCskdeQoT
         z69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792140847; x=1792745647;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Myy+1U6pBdwhlVNx/zaVSdE77IqnEToPWj67mGod4c=;
        b=yJnL2Alai9nDf6V353B8pqxknXx0oJU3oXDUPItRPRcdE0lpJNVQWHAAObQRCvly4m
         ObBdXo7s+4L4DVeYT4WzI6Sf3pwwbJS1QbE+DgM18t2LmiU0aZUIvKGRmniJ0rXf/lsM
         FTrNhShtEnxBbv70kg9FbBcDriHqVcQZAWGzKvP2SzkjpNHVWt+U71+exrpYLiiJ+6ku
         j48iydMWfs9w9WsGicstKJpsl/KWBXvlsp5CSUEI97LC8SSqSAR8viMaOk5RfJrri2pD
         3wuMzy4/Lm3GLAa06+rA19dBoiSYdCAzFzsRUwv0V2Tsi54o+uPVt1yA47VMoT433gCI
         7E4w==
X-Forwarded-Encrypted: i=1; AKwUvBzrH12AlwYqN5rgRlIV+WzyNIU//SbxR7cx7p1F1/Vy++H1F0pX5Vd/P61PCmM+jSwJnptFfSTOu63U@vger.kernel.org
X-Gm-Message-State: AFq9FYL32KxU3laeDLrq8VEb9YpcfpxgQKFQnu2mTCSf/iZDT3i1qcyI
	aV06rAbqOU1mpilpZundDcnNLEQFybPd+xZkrOog/uLMoh3hZlKiZ/NWuL1m7VjFzSiMWO2GdCd
	ytKSb84ujyqjpS8DKZJJB/A==
X-Received: from pgbj21-n1.prod.google.com ([2002:a05:6a02:61d5:10b0:cc7:a1dc:d7e4])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3284:b0:3e0:c346:7344 with SMTP id adf61e73a8af0-3e16befe897mr19741849637.64.1792140845040;
 Fri, 16 Oct 2026 01:54:05 -0700 (PDT)
Date: Fri, 16 Oct 2026 16:54:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016085403.1711740-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, ufshcd_clear_lu_cmds() completes a cleared request
without clearing its bit in hba->outstanding_reqs. A later
ufshcd_poll() sees the stale bit and completes the request again,
causing a double DMA unmap.

Test and clear the bit under hba->outstanding_lock before completing
the request, as ufshcd_abort() does.

Fixes: f18fac1e2b72 ("scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..1ae63d123ef0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7943,6 +7943,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 	struct ufs_hba *hba = shost_priv(shost);
 	const u64 lun = *(u64 *)priv;
 	const u32 tag = req->tag;
+	unsigned long flags;
+	bool outstanding;
 
 	if (blk_mq_is_reserved_rq(req) || sdev->lun != lun)
 		return true;
@@ -7961,7 +7963,12 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (outstanding)
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.56.0.385.gd3acb90ef8-goog

