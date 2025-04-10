Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268B17E;
	Thu, 10 Apr 2025 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744244014; cv=none; b=gOV32fczK7mv9M4g4AqZwx2wTith1qpFIwCHiQdkKgq5XcX1rDleez1QEgn8CE1ZHx6Adfzw4Fthe3H2lXPm7UOXUUzUfLZZ7OzkChtXDN+DjcENzHaHGi1q0uKWCVcLzQsPqs8LiXjeFUwXmWhFqcaIEO1V0v6Mi4pujQDqSLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744244014; c=relaxed/simple;
	bh=e6UtL03AqTb46WVie2q/s4Q6R8PrE2sN0zSsryk9PMY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MiFU8YUG7Hec5oHYQGESXuXelSOF9chaqmiy8BEdG2FE5zeyL9J061Ls+3LlGUw3T3viVyMhH0NiVnuHjHovQaF/ScJqrWCzm604eEUy64Hf81Ihlkm8ADcKzknt2Fdo+2zEJ/CZmyaKNfbjeqGrak4GpUyLJF8F3p0WxbhRfF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mrCZZ+IO; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mrCZZ+IO"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47680c117fdso313181cf.2;
        Wed, 09 Apr 2025 17:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744244008; x=1744848808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2bR1iNSd26LsyVAfQnMDeAzm0mvI+86sfNL5U5ZYzn4=;
        b=mrCZZ+IO+VxJkPiDC+t3uVZDuuBy7+kkh8iUZr9lcmwwTYlV75d2LAcwQbZSbKo0mm
         kar44GoVm7iAnnlt/7CY/uMvBvgxPgaKIbT9polGkDP1FFou9LqSV1geRnrDxb0vAJ2h
         qFR12aVY9KJmGFkz4tNJTWXYkhWyNTdwoH0391Drv+CiiCpwnnXcgVz4kmN4Y22BtWYu
         l/XRUpCKBLigEmF3/BywVL/GvGlOB13/iz/twQpZJNsbmrC2DR3pSLpXGCvJcIVlpRXc
         w8R77uO29c3JghpSdFtdug066b/buTyNT7XKN/hE62VMxY9pHNK8+n4aPsdTz2qAQmPO
         BLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744244008; x=1744848808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2bR1iNSd26LsyVAfQnMDeAzm0mvI+86sfNL5U5ZYzn4=;
        b=Tk55XSt7prCJJ4aZnZXt7uqpEJQqP+L7wrbjFtWZSB1+qBbuP3a6GnXp1AZ/LbakTj
         kq+m7GyAEorBy632Nnu7TObDPsh8olhLkIZ3YVlXj0BmufN5q415VrS6/WsiMNZgcmP8
         PVegj+1VsSmcAI8WH7aHv3/w8gGm/tJiPlv/I1xvBwHSqPbUEMEwN0Khj+9vuOcSSue6
         O0q8W9/CkvClgLp1tiOb3hJVNpqxXbvQdAvzClvFNr2rt3RYDOPAt7VVO+uIXyfQZIqb
         VOcYxqenod7mDyzAFgPw+K9PhPOnPWR1kiLff+Q0PSCMspk+N0GrBkfkzN5teGiTHhxw
         v/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLlc7dLT+8AQVnmM40Vcp1omiq3bf3fH31TM0XsHHNFwQtH+uRAfyIRHHHUHsL2sipR+zO83QrrSq3Du8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwJKrJkrKfn2sdUVGSzFyR4O8TxXVf3wKjrwoBF+/OU1Dhj4bM
	GdwFpF4wz8wHY5Mb4siVBAUUIQ80OzlPUGAgkMTpAxFvPB5CFFo=
X-Gm-Gg: ASbGncsiXV8HolKZVh4NfbNfE2ugNmSP/Nnzpw3wwG1NsJBDNcPa5AzPUa5Dl3Nu2np
	9WOgse2o1Gcj8ITk7EfHlSDy/rzKH5njw/RXeaX4NXfKG2MFar+THHZP12UmnarUjrpe8Y6qVRk
	b+BwFmt+nSLHuxT3/55oOYASu8DIvcBb/PM83zyVUCYmu6wH0HpE9RpoTtAgUYENLFG6ItprNQ8
	iGsbTzVmHgx34hJEXPtFsY94nP3oGpBKeGjSssmozFND9bvZiGAFo/CuYfH/5wuYap8b/gKanZT
	6acu1fd4K9YKEHVIHRlFA129DVueDKWYx+8PbA==
X-Google-Smtp-Source: AGHT+IGlA1djH256NjZ2HBupyRtvO8BxL4JJZawQyBzNRTehtCfKJGWiym0VMS0IVHEvGR+J7yCI6Q==
X-Received: by 2002:a05:622a:19a7:b0:477:e9f:7530 with SMTP id d75a77b69052e-4795f35494amr26329261cf.12.1744244007820;
        Wed, 09 Apr 2025 17:13:27 -0700 (PDT)
Received: from ise-alpha.. ([2620:0:e00:550a:642:1aff:fee8:511b])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4796ed9bcdcsm304561cf.49.2025.04.09.17.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 17:13:27 -0700 (PDT)
From: Chenyuan Yang <chenyuan0y@gmail.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	minwoo.im@samsung.com,
	manivannan.sadhasivam@linaro.org,
	viro@zeniv.linux.org.uk,
	cw9316.lee@samsung.com,
	quic_nguyenb@quicinc.com,
	quic_cang@quicinc.com,
	stanley.chu@mediatek.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH v2] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Wed,  9 Apr 2025 19:13:20 -0500
Message-Id: <20250410001320.2219341-1-chenyuan0y@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A race can occur between the MCQ completion path and the abort handler:
once a request completes, __blk_mq_free_request() sets rq->mq_hctx to
NULL, meaning the subsequent ufshcd_mcq_req_to_hwq() call in
ufshcd_mcq_abort() can return a NULL pointer. If this NULL pointer is
dereferenced, the kernel will crash.

Add a NULL check for the returned hwq pointer. If hwq is NULL, log an
error and return FAILED, preventing a potential NULL-pointer dereference.
As suggested by Bart, the ufshcd_cmd_inflight() check is removed.

This is similar to the fix in commit 74736103fb41
("scsi: ufs: core: Fix ufshcd_abort_one racing issue").

This is found by our static analysis tool KNighter.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
---
 drivers/ufs/core/ufs-mcq.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 240ce135bbfb..f1294c29f484 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -677,13 +677,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int err;
 
-	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
-		dev_err(hba->dev,
-			"%s: skip abort. cmd at tag %d already completed.\n",
-			__func__, tag);
-		return FAILED;
-	}
-
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
@@ -692,6 +685,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+	if (!hwq) {
+		dev_err(hba->dev, "%s: skip abort. cmd at tag %d already completed.\n",
+			__func__, tag);
+		return FAILED;
+	}
 
 	if (ufshcd_mcq_sqe_search(hba, hwq, tag)) {
 		/*
-- 
2.34.1

