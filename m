Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E155222590
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023541; cv=none; b=fo8+HxL0ZVag/RVeO/lPp983AKoeBKPmZ1oHeRgFiWwc7XrZvWqW7fEXg2Ks3DUpRWwqAX3oz26UJj8WZ1oLwXv1+1JXJ8xw45r0qPAHednWrPDNKn5/VJp2IIlniA94SfpFMXqq0gsdRi7tPZeQ4lor5qkiX/Y3i1hwubqaM3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023541; c=relaxed/simple;
	bh=Oa6DKBEOWcc6NZrqXpNDeEpEQpAnjHTPekC4mM7WXS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RD2XB/V4LJObOxGl2Vu1T8bFou9z/hSP7gOH9Ffo6ojXERrzY2S0RZEU1tBIdywtcNazmmcC9rPE2j2VUghDeGRx1PdD4sp5EGC5nwhMI4kCcHMtKFIUXkXfWJZwUqsnTVS9d9OvZofp5fck27iQnt3kv9NjYll2i8Hbn+esM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mKwaXUt+; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mKwaXUt+"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-89b52a188c1so381313b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023540; x=1792628340; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2Mfy71LuLbWREZHLP0IgSgPeFKB66XB6GrmxfTzA1A=;
        b=mKwaXUt+QiaF9T4xKa0ylXdvTnI+Bfu5KUBX7pWX9CAKLMQUrU1Fd2thYFvPzoaidK
         HGIDLBSV8Betz43T9rPqK+DuRFy/YCOKElqgH3SFsh7+kbvOdVN+SRcwjrp9WCEY0VfW
         VI4MS1sKbBJhCb3Q3I+YIpL0rTtOTB+t/QhCpEgIn/Qap2BPNNSMX4fMezf6BQQucs5z
         Ir63dLMbZKkPDTFe/zWRzLNMfQObeVt8bdNejO+JgV/FyOtyNddAVIFSYfWdWn0EXTSH
         NdposWKiFuR6P4bPQwJRGG3p3/7GEwiMn8tbG5WV9bTGp+x2K69ene0itDzt55wy57p5
         DKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023540; x=1792628340;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L2Mfy71LuLbWREZHLP0IgSgPeFKB66XB6GrmxfTzA1A=;
        b=ZznXKpVAAj51wgGsckHsppckwVDtSUdEe9UJG0vKdor8yQ7SrE3B9U/N4ga/gSCBh9
         RPZPiXoew8mzUQq/5IBqQeiD4qaWEIp7ggyHZen2Gb2iwb+g4tz96CL0W4CsVdNb1WGR
         AojWOUttu6Sb1OSRWu1YNUNiyHeVc9UHSq507/mgPsPTQjwCchX/I5SBZbPff6HihuoN
         3SaHv1Ii81emY4F0sDZKiVgmA6G9SAY+/3vhjI0aMwmDnA9tszxJuF/crqgU7uqlM5My
         5DO0GojiSqzOAEZxqNj4Eo7dVHkvC74FxXy6ybyZ5TA97MYpWtGfJX92zkdD6g25dAi6
         TELQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLkQvZgV2OaeHbGF0cv2TjmNVI3C77D755ZBXDqi+cS4atNb0hnz0tG0ApoR3PMa7Fx7JaUX1FqXGz@vger.kernel.org
X-Gm-Message-State: AFq9FYK8Rg7mKiRnQ9uU1qqYMmUQkwLD8xHjkLHyOsSjZDmxAtgRX9Mm
	FVT56rJTg5YJ4J9KccY8kspgOGZb8fPqeHxGlYTf1mjhrW9lvQmMELAwKX5bxMWcsSyvNvwR2/D
	u8mnJRw4Etunz+BMauAdNDg==
X-Received: from pfgu38.prod.google.com ([2002:a05:6a00:9a6:b0:897:f0ad:ea58])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4209:b0:886:ead5:6d22 with SMTP id d2e1a72fcca58-897c71067damr14391894b3a.12.1792023539385;
 Wed, 14 Oct 2026 17:18:59 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:18:51 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001855.3450573-2-stanleyjhu@google.com>
Subject: [PATCH v2 1/5] scsi: ufs: bsg: Complete the job on error
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When ufs_bsg_request() fails, it returns a non-zero status without
calling bsg_job_done(). bsg_queue_rq() then ends the request with
BLK_STS_IOERR without running bsg_complete(), leaking the job's device
reference and mapped scatterlists.

Always complete the job via bsg_job_done() and return 0, matching other
BSG transports. Requests failing with a negative errno now return it
from SG_IO with the 4-byte result in the reply, while positive status
codes still return 0 from SG_IO with the reply header.

Fixes: b13a3539eb2a ("scsi: ufs-bsg: complete ufs-bsg job only if no error")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs_bsg.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 7a66917b3fc0..18c318d78122 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -195,14 +195,12 @@ static int ufs_bsg_request(struct bsg_job *job)
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
 	bsg_reply->result = ret;
-	/* complete the job here only if no error */
-	if (ret == 0) {
+	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
 					sizeof(struct ufs_bsg_reply);
-		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
-	}
+	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.56.0.385.gd3acb90ef8-goog

