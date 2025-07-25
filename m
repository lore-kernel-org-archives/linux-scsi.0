Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2AC1A239A
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753452982; cv=none; b=EJFaUHdvZQNmS4SMkInlkt/kX5MfBOFBo346lCcbKRUyD/vqAo9TQ4TZ1pOw+qDjnzUrvzxBXfeSQcp+to0lsQyfhqTZDB45HCDAtPk0nhA++orV8OLXtGgY92cqM2LycoyNb8cPIH47pDckDmR1u84ceUlkt2sJfhHBcSdlTjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753452982; c=relaxed/simple;
	bh=8AW0wZtIdMTOecI8zEy7or/xRHq/+HDNB4Msky+fi4A=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mJ5YKti12KizofCN9hlUAwq6QKBnOeayQZjy68qqQEkLfZzv3VZaTGqgpwVM/dOSR+qiKQGprpL9T6TRRJ2YdqgeHkcpfmO9u1sYJjABt3Vl1s7bxi2jyZkMpg2T8tmHxWRgyf/+xW0RiL2q+oMp55+Mj2TTIRVOfQCuDaPDsoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pBebP9rA; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pBebP9rA"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so3538643a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753452978; x=1754057778; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0GYrZkLXVXcOZgbWnPr9ONxYHIczwht5gJlvJdmNzQk=;
        b=pBebP9rALtTAJKnpPJpllQiQY9VyHBqULO3QVOWmJ5tHTNwIFaXLluiQHWXyiL6Xy0
         PhL6Ido0qCPelByNCaLUEzqA3kJel/6i8NBKeOVLVA6tfG6fWetUM75BBKojyvH3CemT
         2aD6LpUKdXpATcx9W+fWh9va6Rdfrk+2QKO7HDcLplrwT+N4Eh6Ncv3b6qJyPOeKCoa+
         3aXEpODFl5Y5Vt/SowT0DixTR1wlN/snGgxQ5cIYPuGCXYMlUqdnjTMObT//AVbIJjNa
         ngCDvW/QKYOCyittTgnCCR7/Od/oT4wO9oTXE/PejAjzg7k/7gtTB8rV4kPMUUnkgjoj
         /zEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753452978; x=1754057778;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0GYrZkLXVXcOZgbWnPr9ONxYHIczwht5gJlvJdmNzQk=;
        b=SjM5O+9rZG6SPcpTORl8DNGJ0PBLcRinqOriD9jR6wdNoIKz2YCiz6A6UlXFQ08+yA
         wRMK9b/x6kESexKNJJtc8dNAqZ/YAdGR/E0INaWr2IkJW3ImkHSwd7lFNCMml14BrJQr
         Zx2gns1w2AMpbfWtgPRU27NmI11OUAlmeSdMXuzqTSElQII4acOdeb6ARNgAX4yS5qFy
         4cw61T5l9TeQpTLio+RXj+of0cLFIRIqeBiKnCvr4PrcQK5i8qdnmXu5s1Pcd27MyWuj
         1c60sHuQouNmWw1gP4PG8vTiQA/usxZbOJghtrC3lIrburaFH/6aC6UwnOLyQIPTQU8X
         Cbkw==
X-Forwarded-Encrypted: i=1; AJvYcCU7VXuadqPn/cdXS5s/NRQwO+dkWUkfavzY7ZLhg4aPxehR3JwgHqTHwBto8sr5xBz6lATuH91t80or@vger.kernel.org
X-Gm-Message-State: AOJu0YxRMuGHbpvkhuJHliuizbRMRPUI4zGdhYXKBXxGzX1m9nfhHPBp
	3wRFpmTNeHDrRC4NL/t6Vo4/HefjMj2iihcu/SvzVjoagXHC6IROcoJzqFyTeEwaYKU=
X-Gm-Gg: ASbGncvrnMg5SahF7tf4LPgxmJLzfsAFOMpiieP3qviu2HWqA+MeGTjmg8kpt3NZ1Lq
	vAtrbvIVLgYf3Cxf9zTMn9pRDahIfgYWYnTetlBZMd7gFe35Lq2nXplEyxRR5jLfVkhq3DL0ipk
	y9sTxeK+Xra39Q5aKgaVcJI0TM7UUsQs5yMVZF/Oj0hm/4sKooTEgiL8M9vCDuxSlGZsYxUCzMy
	IR3KYgmbIOIfQrQA+E6H6p/801raemdaK0F79YlH4764DVsad6zmqO6i1fnn/qG+XeEf4m7XQ8X
	z4lHNYZGpHfuLfqvqgG9ozu/cnf7ik5LoSbfdMvCwAdw3Enipg7OZ5IkAuc+7NtN7pMvyNRKgXl
	Sq3Stvrgq+2c1KUyXdDMW/D/NZtyxc7/X9NIJNy4wVbD0ohmWhi2N+5euOe6m01+t+WRbkS61xO
	Db8XGrZg==
X-Google-Smtp-Source: AGHT+IESxxtSVuTR7JcpPvCin5sJRXnxskX5QKzVI4SQNZf89ZEV5qKL5Ev6pflyXfFUSgm5m/ZQVA==
X-Received: by 2002:a17:907:7205:b0:ae3:bb4a:91fb with SMTP id a640c23a62f3a-af61ef2e6demr228089066b.59.1753452977655;
        Fri, 25 Jul 2025 07:16:17 -0700 (PDT)
Received: from puffmais.c.googlers.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f85e60bsm278398966b.96.2025.07.25.07.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:16:17 -0700 (PDT)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Subject: [PATCH v2 0/2] scsi: ufs: core: interrupt handling optimisations
Date: Fri, 25 Jul 2025 15:16:14 +0100
Message-Id: <20250725-ufshcd-hardirq-v2-0-884c11e0b0df@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAK6Rg2gC/13MQQrCMBCF4auUWRtpJ01aXXkP6SI0STMgjZ1oU
 Ervbiy4cfk/eN8KyTG5BOdqBXaZEsW5BB4qGIOZJyfIlgasUdUdSvH0KYxWBMOWeBFjJ1F73aJ
 TGsrpzs7TawevQ+lA6RH5vfu5+a4/qv2nciMaoeWpNwp972u83Gg2HI+RJxi2bfsAJzI6Da0AA
 AA=
X-Change-ID: 20250723-ufshcd-hardirq-c7326f642e56
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam <mani@kernel.org>, kernel-team@android.com, 
 linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.2

UFS performance for < v4 controllers has reduced quite a bit in 6.16.
This series addresses this regression and brings numbers more or less
back to the previous level.

See patch 2 for some benchmark (fio) results.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
Changes in v2:
- patch 1: new patch as suggested by Bart during v1 review
- patch 2: update commit message and some inline & kerneldoc comments
- patch 2: add missing jiffies.h include
- Link to v1: https://lore.kernel.org/r/20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org

---
André Draszik (2):
      scsi: ufs: core: complete polled requests also from interrupt context
      scsi: ufs: core: move some irq handling back to hardirq (with time limit)

 drivers/ufs/core/ufshcd.c | 211 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 152 insertions(+), 59 deletions(-)
---
base-commit: 58ba80c4740212c29a1cf9b48f588e60a7612209
change-id: 20250723-ufshcd-hardirq-c7326f642e56

Best regards,
-- 
André Draszik <andre.draszik@linaro.org>

