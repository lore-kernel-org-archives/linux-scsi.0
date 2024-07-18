Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04B878C7E
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721290105; cv=none; b=s1tU5TnkJdYmQ3v0/d6N/uHV/dioMGJzCNArtCxv4Z+Jn0/gHVqkEz9lzPiU+8eXgsA2X1QCQKx8fJgwuLsTfVNtWhXaJFowPq20r1H7FiUX/lo4ceJ1XqKb3esBU/3pbHUICyrNTRvYIC2WbqMWMLiq3izqNR4Q0qW6X5ogSTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721290105; c=relaxed/simple;
	bh=stIAApLHsv13L2+WlRqAXQuJPOPJT4+musbzWj6h73Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dRrXNcehsL/Iy05WTyHQ06SKy3S2CTSN2KbHtfdBc9nkJ2gOA3RzbT+Fkv606O2bNz45qBKSKiq0/Q+ih0M4Md6LYuAoBpzA7aR4/MlULscR1gIwXl/S68o64G9xWg1GT3O/XRvEJS9ZoNLPJyskmGcwoi0Bem5ql1MZO8jUffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=e41d7O0M; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="e41d7O0M"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70b05260c39so405431b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 01:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1721290102; x=1721894902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SL2KhlCSShY0ltqGwzoWJU5urIFwQY8SPKFX14sWSc0=;
        b=e41d7O0MsDxQW+zruB0nEKBohm2SxO8sCUL/M5D/24/m2U/UatcqbBfSTpC4Fq7SJ/
         lsTD1FlVaiVrYIekKMwoxssxmhnnLmm/uYusiW9r0jTnw5Iz+L2gl+N6+IouLrY0aA59
         jgc8Q+RD5zgB6WeIS2w0Hz1irYvgteM9XaCgi+cdsaNzg/hmhH99S+No4LGsnIqv535a
         b8QumOf7Qsun0Nnk8E7ZvguBLj72eOruIsF7zkdhAfg/21NNx2aYSiWri8zwvBqCzRO0
         OWcjVLJiG0wqLjD7R2YwK78mU671PeX0+ImqB7jRyMMapIGUl0tnEnHgiAcwOWIpWZrd
         ot+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721290102; x=1721894902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SL2KhlCSShY0ltqGwzoWJU5urIFwQY8SPKFX14sWSc0=;
        b=xPxTiK3EjDKkHv+Cs+iS08lDbo6K2Ey8xIdcQUcwlE802D1TrA5+bkQyiefxGkXN6O
         BBlIuRRCvH5zOBcqpXSECg3cKv/TDyYRSrBBMhqGd7XK03WpRJN5UbmToXLJa8sUpbeb
         Pi8skmTj+rv9rjK+VlUcYJBXK3tVo93pFE24V9oCN33RDUIE/O/qLR7uG7bfUZkX238J
         kMoVkoGthKbSZ0miGOdj9KrTZNAOwE3MtvXyHv1xpIjQ5k7aVg/YqePt/B4d/zO4Wzwy
         hqoPiFqPFLYj0oBq6VHjfhKRxlewve9tQ6uVRnr5/vBFRQV2hoFF6zfOjZfC6LeBFIzL
         fsmA==
X-Forwarded-Encrypted: i=1; AJvYcCVTUFuK6+sUIl4hMRepDWzDc2rpaCVnz3yluZBRR3vjRPh3IClf1F7LTrPNRdl55/buiuyjYg3sF1BRkrXFiGzPlOZSDumisMrjcA==
X-Gm-Message-State: AOJu0Yx1aePzvcxSZEyhBNg1E+LTSjsJZx4D4CjV9e4hSWDaeJhvbAzr
	w8WCRTLbpU3/39QMHcZWz1ZkfNT4HZ5EuWsfLJyFtvXw0F/b6FGk9ny4lRkmjec=
X-Google-Smtp-Source: AGHT+IGWp7a/4CKcmDOndp+K3rVQWgNFjYmK4qQZAtiVYwy6rZx/wzfXNJ0BvsLjioBoer7jFnyauQ==
X-Received: by 2002:aa7:8887:0:b0:704:1c78:4f8a with SMTP id d2e1a72fcca58-70ce4f1fea2mr4813895b3a.21.1721290101544;
        Thu, 18 Jul 2024 01:08:21 -0700 (PDT)
Received: from localhost.localdomain.gitgo.cc (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-78e34d2c4d3sm7385958a12.48.2024.07.18.01.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 01:08:21 -0700 (PDT)
From: Li Feng <fengli@smartx.com>
To: Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v3 0/2] scsi discard fix
Date: Thu, 18 Jul 2024 16:07:21 +0800
Message-ID: <20240718080751.313102-1-fengli@smartx.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

These two patches have been reviewed but have not been merged into
linux-next. Can they be merged into 6.11?

Thanks,

v3:
- rebased to the latest linux-next branch;
- put the separate patch2 in this patchset;
- add reviewed-by tag.

v2:
- rewrite the patch.

Haoqian He (1):
  scsi: sd: remove some redundant initialization code

Li Feng (1):
  scsi: sd: Keep the discard mode stable

 drivers/scsi/sd.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

-- 
2.45.2

