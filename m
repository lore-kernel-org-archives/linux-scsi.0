Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393AB382360
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775816099; cv=none; b=AIfmAWhhBrAS2B3TLpDdRhI2p0F6RhAd1A3HeTLXBqkSrJ8Bgzx/l8c/r+Qqfr7M+tz4YVj8CLHxrzBlzxVac5zkdZY6lk6MWR3d55rMEF1Dy08DaXWEP16ARuSEmUcUD3B09nnXnke/+WIm0YNaFlK7+KaQRDZusr3SZuaV55k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775816099; c=relaxed/simple;
	bh=IihIOiUIq6J3kKC+sZ83vzkP5vrokwK8p+1gz1V/X9A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dnwgF3zpWGTCndDC60jfM+zYP1P7yt588+aGuoSZNdXHg+bnF8D62k/adf8iDYBMWGE4Tw5YdcCYYkD/hrSBNdIWyCVm58qNoSNHrOs1G5o04BgNh7zXIKExbZiDfohmVZJMnIY4/mIe1YVbxRjmusbn979GrZmxyq9pfNgog2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdlzHwlN; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdlzHwlN"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso20002435e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 03:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775816097; x=1776420897; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ucUH4IDgpTJ1+uFHppA4Ul5fmREvzaKgT+OImbEPYwU=;
        b=kdlzHwlN+RxT5pculOX+gIL1NH1fNU4R1v4Ji1TurIHy2F0SLv9UgvHIuOYaA/7P5d
         9Ft+s4Uo/yQ4xdS3sWF9g4wYFwzYhd6PVExWVAxPxHbYURJy2W+woLmmEiDrE1NftgDq
         WInj5+5cEpxcr8YMBkFMbzidfDMqafhm1Nk1ayfg0XtXlLao6r9mm1eKdAUG7oFxRQ1N
         8S+nuNlc29FCu6oPsBI8cbmwj8ko9EC2Ax/ARA3a/JD08NMNZXFuEYHADutouSf3fHBS
         We3T0KmBdaPIDK74gydRiobQhlRp7p3Eg6A4lYccxP20xJT2Ftv7fRQW8gLwimzG7TrE
         xf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775816097; x=1776420897;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucUH4IDgpTJ1+uFHppA4Ul5fmREvzaKgT+OImbEPYwU=;
        b=cdmbnqB7WGqc4imda5Yw5mMVAg+cCLEst7FOA34lt+9JWZzurJBmQnAh3V+g8CaDhw
         jKaVjJrvWMmJfnI1sjov4EPL4f19XfFFkr7nTqrzUIIKKCCMwmBuOf10coolSTGN1z9R
         DKeoLYhpEZgNeD/l0Si2M3VduP8hwlGsdwRIqlrI+6Eh2TZ8NzcoHJ8v847pmMpbxRns
         82YiM9BeSDPYwaofljKuL12mzQdNO4QZC8BnkPu6lBlyFMmt2IzrtVshoaX6hJfFswYq
         31hX7dTIHt/WDQ43uQ/fBtXww/1HRLYAt6zWXPvYF8XIvx8vfh1ACs5sBQwv1m2563Zi
         F4jg==
X-Forwarded-Encrypted: i=1; AJvYcCXkqqU2EFC2lSwaH/qjNjstzivElOT6mBTFifSCsZUZvdFeRJNctzb6l8tjVRdvaoBNdXIwl1gJ3zPc@vger.kernel.org
X-Gm-Message-State: AOJu0YyOq4y1vvqWBG5n5o9MOKf0oWU1x5+vKqEsZVXGrr/+A4KtSx3X
	E3To0y9W+4sAXqXvBLT6U1FPImqCiE71Pmqdz8OOaF6tXAw9DtKwpSc+
X-Gm-Gg: AeBDiev3Kr8i5eOhT0iJrsQrUzL15tIvPV2TzgeKyPt0++M8EXiiBl01lrVrLuEsKtg
	LIp6nR+HW1L487QCSOYGSiX6KSUSDIX745CtpNNH8sbj6RujhHABu2LLEHwX06ZjU8kTI7KQrnL
	tTKapby+Zl0DEah8vb22qbXMh9OtIHtbN61BtnoEeP0YLXLG53tl20xFBqVb2EdbDuNwNXpVuvq
	YrdKVAfV+4Fcp0fnE2nS+8ffQOXR4UMWLyKwBf+3UPdsfdn8aOao1pdVPDQZYaH9sq5xoQV+ECY
	w/aFOibz8ht5ir6i/PL8ZfKX0LlkdSczvCBFXSSPxaMYqYMWCbhvE/9I9UyYACU1Y0BG16Y6eos
	TLoT6i74UWn17o5BnUWj8LPmRfeqtFOBSPbok6MJNLKCps2aE2q4l6hoZ74DZDgUrJd5BiCTin4
	uSOO3kJmUAlW//H3cpjxw=
X-Received: by 2002:a05:600c:c0c8:b0:488:8bdd:cfb9 with SMTP id 5b1f17b1804b1-488d67bbbf8mr22272095e9.1.1775816096505;
        Fri, 10 Apr 2026 03:14:56 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63deb904sm6833358f8f.9.2026.04.10.03.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:14:55 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:14:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] scsi: bsg: fix buffer overflow in scsi_bsg_uring_cmd()
Message-ID: <adjNnMYK7A7KMNkA@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The bounds checking in scsi_bsg_uring_cmd() does not work because
cmd->request_len is a u32 and scmd->cmd_len is a u16.  We check that
scmd->cmd_len is valid but if the cmd->request_len is more than
USHRT_MAX it would still lead to a buffer overflow when we do the
copy_from_user().

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This email is a free service from the Smatch-CI project [smatch.sf.net].

 drivers/scsi/scsi_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index c3ce497a3b94..e80dec53174e 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -137,11 +137,11 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		return PTR_ERR(req);
 
 	scmd = blk_mq_rq_to_pdu(req);
-	scmd->cmd_len = cmd->request_len;
-	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
+	if (cmd->request_len > sizeof(scmd->cmnd)) {
 		ret = -EINVAL;
 		goto out_free_req;
 	}
+	scmd->cmd_len = cmd->request_len;
 	scmd->allowed = SG_DEFAULT_RETRIES;
 
 	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
-- 
2.53.0

