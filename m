Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF526CE1E;
	Fri, 25 Jul 2025 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753432302; cv=none; b=GMpwtWShHVTkg3mPjigZ7G+RAE937TjCMqtA1MnmcLZnHdfe1823dr4ZhbOHFDz85PnQhRZKGvHCccej/gvi8MlAIbzs/Z1eMzmI5Acfi1MtzMv6TXyShJnhuMeLoGuFN8HAUSJavN0vDwnTa9Iejj3ds/NYJZ15s6g8sxprDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753432302; c=relaxed/simple;
	bh=ivhXIbABxUmVWmuSBfZ4S+86S4+6Ku5NPkVeEHZEQjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lai5pD/SQ+eZ3e1MrxN9PqMDDS2+mk5GpmEld761yt/Xc3woFIQ6VcLzLMN56J5nuss+e1HDV82TML4ME9teVUtIF0X/CIbSWNDXzy1m6QtYJ3iFgUh+K8Pf1JnEfYUSpGgJHvTQBkge9+9NsENB2lsVeE0th21Ub/RAf3OEbBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kVXeFUWm; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVXeFUWm"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-455f151fe61so1652895e9.0;
        Fri, 25 Jul 2025 01:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753432299; x=1754037099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=26QkGEtwmh9ZUTsBkB+2VC4/FaLAroMl+urGGhMcl5E=;
        b=kVXeFUWmeoWIOaatD4VAq2J7PxRMo8MFD5XhhiUApuZ4FeD52tVLAKQoL6pYDI+Xy3
         oi3LjNvuISknNAlqplcn2DJGzPzSomBAhBM/1HSyxoRCoNPn2uL6LZAS/BlD+DcKfIPR
         nmf6lSybl5Pr4yhD/WA8ibMjLuOnuyI2mlbkHxJXLHuDvnrGXqPeKqaBjbE2ENFS+xOK
         26q5uPa316wFqB+hXgedM+KXbjYt0VhNOpYMk5QUkv2ctVnzWW5U7asg4By7pBAtrdw4
         kLMZN/oFbw6kWk9b7dsimdw/8T50f709vyeZZ30UOEJEqtXFhoxMC8tFO70CYkx9yXm0
         MteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753432299; x=1754037099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26QkGEtwmh9ZUTsBkB+2VC4/FaLAroMl+urGGhMcl5E=;
        b=lOqnU4JAyJmKWdDGViooGNHiOuE4R9wrrwnAUXhZgYjCovks3s9n0DH+yKLN6KzFYr
         RQ6xktXeG7doruQvw8beXGa0o+qyk6m4L/6H1ir712YbAllA305BB7EDtlQEX6VJqH/D
         N1HxVFv3SUZWCrzq3ahXIdejJVJp7x2LiFvwZ7ovxTnUUfgt8hwp4HSjYZWO7TcZ4KAE
         7VavzDpQnokgd0iOUFGv1+cybemJG1juX1sspjqdQPz/YEr7wRo56hIsIWDpEfjDXkEi
         XZZfGa3K/eD05RnCkxLCINYRqnq8GCQ4rV3XLDXhBR4aZiTxEvFnjm+KgmsaVxilMc2u
         9xZA==
X-Forwarded-Encrypted: i=1; AJvYcCW8EeFhPy+lI9QQDW4uBmrT3WOIM/sH54wcYQx+nnthGN/HmGoW77IapfvVn4/4LsSiZYquiaa2BUN1qrA=@vger.kernel.org, AJvYcCWDZXHgY/ut2YdYXSUhepHbeCUV9WzSPSMW/zg3geoXUyuiMSnO1dktc/cwP4ce1GWWqe2INzY0xfQmfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIlNHvJGbeZZPA0Re9cO29eH2+N9dvBL82VU1L50b5uD7mObdo
	SQcxRpagtbdf0iTQOhc1/qSz3DLVw0Y3TPXCbrUwpIpwKbh0sL1baDdT
X-Gm-Gg: ASbGncv44K5d+etzgqzLcvYCv4YuLp76BdltHgwdsoD2trDmJckKiGicDL7oC2vxG85
	GMrVEFMPVXqH7C1MuH3fspKSbwVu9IxA1WhJ3QPQmGf1RyVkAlSGpWOfEYC05sVe/5NywDMp7cy
	/gWgalVJ+IqwP3qdoSDqRUo5CYFAUJ6eAOcAxJL+yDkViGNBM+G5uohnbkjzfmapkweonsKmZKW
	5Xc8DDqCSMHg4dCZupiwEwFy5meImPDehL4upn6n/wD0WQWL6lBYQq63JxZsHt1E60UCr2l1mcB
	LoVTKmtOIBHnZU0AOLtMxb/R54em+oWGQxQP5FCWxwNjxbdfQu5oHxaK7yJNYp+rgmPs7YCTFdn
	IosaKrxpD2/i/5pMFaolwwAtP6B1K1IFQYtakRn5eU6gPQZ0=
X-Google-Smtp-Source: AGHT+IHVEWzBjPMff/OaA/+sht/QRx8KNGSMgQ5Yq2suojEuB9vMMALI9ZlRTNr3W7vV3J/BSuZXqQ==
X-Received: by 2002:a05:6000:1acd:b0:3b5:f908:2374 with SMTP id ffacd0b85a97d-3b77657dd23mr346317f8f.0.1753432299136;
        Fri, 25 Jul 2025 01:31:39 -0700 (PDT)
Received: from thomas-precision3591.. ([2a0d:e487:31ff:1e66:d79d:18fa:7b96:a238])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b76fc6e5e1sm4532521f8f.28.2025.07.25.01.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 01:31:38 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: myrs: Fix dma_alloc_coherent error check
Date: Fri, 25 Jul 2025 10:31:06 +0200
Message-ID: <20250725083112.43975-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for NULL return value with dma_alloc_coherent, because
DMA address is not always set by dma_alloc_coherent on failure.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/myrs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 95af3bb03834..a58abd796603 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -498,14 +498,14 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	/* Temporary dma mapping, used only in the scope of this function */
 	mbox = dma_alloc_coherent(&pdev->dev, sizeof(union myrs_cmd_mbox),
 				  &mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, mbox_addr))
+	if (!mbox)
 		return false;
 
 	/* These are the base addresses for the command memory mailbox array */
 	cs->cmd_mbox_size = MYRS_MAX_CMD_MBOX * sizeof(union myrs_cmd_mbox);
 	cmd_mbox = dma_alloc_coherent(&pdev->dev, cs->cmd_mbox_size,
 				      &cs->cmd_mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->cmd_mbox_addr)) {
+	if (!cmd_mbox) {
 		dev_err(&pdev->dev, "Failed to map command mailbox\n");
 		goto out_free;
 	}
@@ -520,7 +520,7 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	cs->stat_mbox_size = MYRS_MAX_STAT_MBOX * sizeof(struct myrs_stat_mbox);
 	stat_mbox = dma_alloc_coherent(&pdev->dev, cs->stat_mbox_size,
 				       &cs->stat_mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->stat_mbox_addr)) {
+	if (!stat_mbox) {
 		dev_err(&pdev->dev, "Failed to map status mailbox\n");
 		goto out_free;
 	}
@@ -533,7 +533,7 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	cs->fwstat_buf = dma_alloc_coherent(&pdev->dev,
 					    sizeof(struct myrs_fwstat),
 					    &cs->fwstat_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->fwstat_addr)) {
+	if (!cs->fwstat_buf) {
 		dev_err(&pdev->dev, "Failed to map firmware health buffer\n");
 		cs->fwstat_buf = NULL;
 		goto out_free;
-- 
2.43.0

