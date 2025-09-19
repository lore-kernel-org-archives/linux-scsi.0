Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16123AB81
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 02:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758247896; cv=none; b=caCtYAn3oi47TOzQ57SjclA/6MVjZzjlK1hEDQdDU7qJCDwwtWUkVQFaFPz8Yf1abUKuPruL+FF5LQc8EsaPiPlHcPFs6GEM3mdi/YLOKjU372yDPvqYqtfZuWqKn9PoufpuPL+/QKK7PQ4q7ML7tt97QHxhLiMtiv0497uY3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758247896; c=relaxed/simple;
	bh=ziXcd/mGn2ry+d/Ov28rbQ3Z8WS0immtLzwgvpIlto0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZMnCqmck3Nt5+XaAgQOSm+4hmQfFMFi5FbRdWmZHEZ+xav1asTiGf+g5/5Ex3MXD4ItIf1kiTW5Zy+ivaf+JQtSeLc1DegpyzmbLhUkL6+3WQS1cTn6Z8AjtV7O8ns5a0XQf+cqWcytAtYFTvUhECA1/MKsuMUenjyMTYEien+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnkUIm6a; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnkUIm6a"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-244580523a0so17518815ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 19:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758247894; x=1758852694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qZzkp8nCuA3tTuaf6Pt6AXsPGQNEt3CNxtrSQfVvzGo=;
        b=RnkUIm6aoS5bTEJdbZVIq91ZN9KEsN1bIt4Bf1Y4+j4OmXDYuEdYfmf5DTXf7sJPT0
         xN3lGH3WXJQ59LC01wsLdM2oIOWMBE5TvPI1CgfPyRRQy1gp+KU+xThDtgQzhbxS6v6x
         Y3MovN39rpu+jcHzw2rXM0yVG2iBSt6LYtaHyhXUKrLKQ1YJK+3VFYNf68HwoIy+G+go
         Cn00Hlc2upxJ8EMHe11nJq2TAYchXqdNLaakBd+IrKj3E8dkR7tuC8jxEH0LFiqj/V7g
         Y75ZbOzl8uZcY/fw4zuNhULI4OiUEZjoioMDu7QEULWXDbcej/VCOEicv4iBa1U18NXS
         Y1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758247894; x=1758852694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZzkp8nCuA3tTuaf6Pt6AXsPGQNEt3CNxtrSQfVvzGo=;
        b=B4yR5RlumgmuxBqhjrulWJP9bZqnOmp7aSC8XEB1Bl82La4GusqwthFOJlSrH9zoyZ
         0GdQSkTBfffUNcMDouB+7V+uvqJ/v1ZJIS3CcSxUFfdt4e7pezislIsnynEkEJ6v91w4
         0uNQ2EM6uB+3e0hezPLin85h7Jc01xiP6FFOp/ik9hMri6wpt70vgHu8/KjQ+ORTke1W
         S8LvRbeKfa2IY7NgYxdaewLq0N29ZwwkjVOyhWZxOadY5TwYLOorUCWpWoXUsWxiSGLd
         q3U+oMK7/D6iIydhc7Hre2xF2GRYhPlylxhl7gDTHUwQsTFI7DJZxd8bHyFHnI5htFPj
         qBFA==
X-Forwarded-Encrypted: i=1; AJvYcCWsBx261+C3/btDh+6HrUx3nGb1Wj2quaJft0O2bEYU5Dwck+rYIftoB6J4BuurSp+77eoOBKo/qS6X@vger.kernel.org
X-Gm-Message-State: AOJu0YyrSTrJYFoFh5nPwYmJ7BQs47ZycZT9/3VvbHVNv3jOJj00Kla5
	IDb0jpF6JGgtFtm/LWJBhMULBcJ4bmLiX51o/CdQp13XDyo8Qv/LvoLNw0mgghOgc7tDiw==
X-Gm-Gg: ASbGncsE1FGVHcAXGW35Ddj3B73/jqXcl58MkTfrFOvL0puaMs5Ut9+dqFTqtZBaYoY
	CFJx2Y7rdk3de4z7U8uCd/cB4HERwKIy0D+IYelByVxz6KRMZyFOT7mAaGrJKWmsiYWWFC5N89/
	b6WPUETQf59ACGWAHTD+txIu6neuOuBcsnVaSO3wNPQyVtq+u8EGCQ00cggNlhTkqA2zdCLNPoO
	vlX1GbFitRDbkwiRHM34yObFbq0mO5SiZ3sZJUHkPlnp0bP4wWTYfVDh3fWeNOCGRk0c/uFFMvj
	e5/SV40kr4C96Qkg7bLIU6pS2r2+V1hsKdSPkh1BkPqn88mIr7qxDV2DwDLb9FQ4D1cX8KEJ99N
	Xmcxng3RSjbA6GKJBnHAbBgvl
X-Google-Smtp-Source: AGHT+IFai2xzlAnilWh4m4u+vIgxxJ3TsFPhkwgF6XAkrIfE2ErA7mqnopPzZJz605+TwLFG1Fausw==
X-Received: by 2002:a17:902:dad1:b0:267:d772:f845 with SMTP id d9443c01a7336-269ba55f8f5mr26364635ad.52.1758247894071;
        Thu, 18 Sep 2025 19:11:34 -0700 (PDT)
Received: from lgs.. ([2408:8418:1100:9530:23e9:7ba2:72c2:e926])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802fdfdfsm38785405ad.102.2025.09.18.19.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 19:11:33 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: hptiop: Add check for device-provided context pointer in ITL callback
Date: Fri, 19 Sep 2025 10:11:04 +0800
Message-ID: <20250919021104.3726271-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An untrusted device may return a NULL context pointer in the request
header. hptiop_iop_request_callback_itl() dereferences that pointer
unconditionally to write result fields and to invoke arg->done(), which
can cause a NULL pointer dereference.

Add a NULL check for the reconstructed context pointer. If it is NULL,
acknowledge the request by writing the tag to the outbound queue and
return early.

Fixes: ede1e6f8b432 ("[SCSI] hptiop: HighPoint RocketRAID 3xxx controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/hptiop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 21f1d9871a33..2b29cd83ce5e 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -812,6 +812,11 @@ static void hptiop_iop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
 		(readl(&req->context) |
 			((u64)readl(&req->context_hi32)<<32));
 
+	if (!arg) {
+		writel(tag, &hba->u.itl.iop->outbound_queue);
+		return;
+	}
+
 	if (readl(&req->result) == IOP_RESULT_SUCCESS) {
 		arg->result = HPT_IOCTL_RESULT_OK;
 
-- 
2.43.0

