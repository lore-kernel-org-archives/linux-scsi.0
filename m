Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CE121481E;
	Wed,  9 Apr 2025 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231543; cv=none; b=U1+HZw7xF/5eEqoP8coISf3Js5hqcpgnkn4PpjePP9qpRR3BTgS4cB52ee4oT6EKMOv7Be/iHBkhhzpbf2bmPKcnFJPzUL/hznV39vPJMRoQofdTLiZLCTg9QX8bZQ0+lMvO2Kd5WYgTNWZCDm7f62agSx8JWaZjub/3c4EPcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231543; c=relaxed/simple;
	bh=cUenJzwspzcZC4iAhVtPGZ5Qjcu2yzhoR4F6Li2MW38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H7wowL1jPtXKdk3E2esW7QAktZQEsYhrQQ4rT5kpKhS3yNmgnG2a778dqHfb+GPW2/WdUogvNRaHJJaQOdDhzVx+vgp4KuDp0swoxhIBjLf7LA2uk9NjOcFNGHyaj8n/AMWJZ3ZfQEfmySB8cpXmfRv1jl3dF7o6fJaJu5QACuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+aWfhdD; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+aWfhdD"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6ef0537741dso41226d6.2;
        Wed, 09 Apr 2025 13:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744231540; x=1744836340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3gPzZ56otu+n0Q0EQ494VJkh4lNvsg4X22Kcyvv+XGE=;
        b=O+aWfhdD+yA2JFh04G+/UnIUvTab0ccJQNc7kA5UFWCYCTOPaNloI+O1twsdusv6Tf
         9LNnK7Q0MvQgs4cnmol343xQTECAnJ9nEp+XmSf5b1BPqWD0l5IZsYFgWCHGkzVbfCpT
         nJ/qxoIXigLfvAyGFg0V29w45xF+FoFXtBhkY6MLct3PgwjOoH/oizCC4bK61Zp4Xv4W
         Vme8EKgc0HNq9hlYmWMwx5yPHocahb5OHJcctikl3o7WGI5HoPHxuiWWZK286pQYWQRR
         zK9qGUXEgGYAKYyjml0LwibaJ/nJuImEtsZnYOkMhMy8SEsKx0ltssrBUUAWXbRgkugB
         6CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744231540; x=1744836340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3gPzZ56otu+n0Q0EQ494VJkh4lNvsg4X22Kcyvv+XGE=;
        b=otdlq4nbeEdiZs9fLi93IxyVIT6PS4Kbevj2lqBTu7TY1cnfgiWBN+s9c3iPuMhCeD
         J4zogRu8/biz0nzsbokB67SFdx4NLvKMTYj5leNVnum7aQqpHZrGKZa8781DcuU0WGXl
         GQKSYzFX2YqHS3dP46zlklASjJXaTqxq7GzJ/lngw7B+HwHJkNPLxwP7cd7TrgAgSG1l
         1tXEDWmlm9+4xXbIrUb54wiSMj+f7vFlVQ0930xyGp5WF97FLvHq3sqCCqjXHQttyjp5
         5mIpep3NfHjNSydM8IoW1Fx0aIg4vXHXirDwfxBcYlT+fLdVNDzKt4j+BaPfVjC7ESUM
         zVxw==
X-Forwarded-Encrypted: i=1; AJvYcCVl8FGQL/YUQGfm+78i6v0bYgOsT7S76jZxwlJTWJjRw7ewN6u3f/qKiRh4CmHP4rWmemNGiXEWIGeWtQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgGISxNM8Tj1GbOlie+YqcP/tGDh2sSQw2C//MC0Gv3bOeVSzw
	DVBRc+aDQtsGocrTaVi2BGWnJYo+mWS4CsTsxjgk/rbleg/GFV8=
X-Gm-Gg: ASbGncsfYq52P/H52fW/eUkix2LDReOyukps4z1ozhoJSh1967G9BHadmZwQJiDEU+I
	+Eh9xdlMXl/n6GpXHXBVJsZ5cQcF9WnAOEK8O52c4jkSnySo+9FHC2snn22DaWiC9usEGRzPbZA
	vvw47aSoVH4UL9yeyyy2ezGTzwS2flaqHkY1MRX1/i27ajopbwhfZ9uAQikCfCVxThi2eJgU9Tx
	qt68nMSJsVkKU6lSwoh9SZ0/TzDPmW07x7mm0T7zYbDzwfMFmj2wrN07UukLt6s3SX/UC5AOqar
	zUWUdhmvKk+tCRh/5qqDi5Ce5a3EIk0TQIj2Pw==
X-Google-Smtp-Source: AGHT+IGjE+VUOBEomw6CWFpbs+MXDUxnnAMARCBc5reoVD4E6+JG/HZ5PAKx4OvSTQtZPDMy9pGM1w==
X-Received: by 2002:a05:6214:2486:b0:6e8:f4f9:40e1 with SMTP id 6a1803df08f44-6f0dba2463amr27327886d6.0.1744231540275;
        Wed, 09 Apr 2025 13:45:40 -0700 (PDT)
Received: from ise-alpha.. ([2620:0:e00:550a:642:1aff:fee8:511b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f0de95fdfbsm11499706d6.1.2025.04.09.13.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 13:45:39 -0700 (PDT)
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
Subject: [PATCH] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Wed,  9 Apr 2025 15:45:37 -0500
Message-Id: <20250409204537.3566793-1-chenyuan0y@gmail.com>
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

This is similar to the fix in commit 74736103fb41
("scsi: ufs: core: Fix ufshcd_abort_one racing issue").

This is found by our static analysis tool KNighter.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
---
 drivers/ufs/core/ufs-mcq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 240ce135bbfb..2c8792911616 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -692,6 +692,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+	if (!hwq) {
+		dev_err(hba->dev, "%s: failed to get hwq for tag %d\n",
+			__func__, tag);
+		return FAILED;
+	}
 
 	if (ufshcd_mcq_sqe_search(hba, hwq, tag)) {
 		/*
-- 
2.34.1

