Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAD3112AB
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388447; cv=pass; b=LXb57uWyst/1+J7fOemMpM+jCTY54XlaM4NRu0n38rubbDekmciZ3TAnklZXGXBDlw2rNVwLOiKOlYRcH8Ho9NhWdE5o3HeTElkDph7i5ALzBAO1KHmBnwjegSn3rvxxgThmTd5Udduwdj320JxYH7Ngl1HNCH3Ly2syKMlIPEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388447; c=relaxed/simple;
	bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GejdyHAlvORf0rUH5uFXyVDLTiDaH7OScg/M3IoqGdVacuzxWPumpX5GE4x2FDXo6F3kD32a2bIjK1UZnB0xPAPx+/c5psVBRSe6/78VCgUWxxe1TyTOJ0LGYOAF40sMT8CQHHkvaSIAl7HYD6uDE80T2C5d9O3LTmqI9dSoDsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p5+LLAB0; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p5+LLAB0"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-66ee02e2c55so293227a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388445; cv=none;
        d=google.com; s=arc-20240605;
        b=BA2DEdgDIV/T+zE1bzm/y/L66VN3xoqrDUcITmX/1P1ZDnd5VwqFl5VokbYOzyJDHE
         0XPgZ6Sr3CewTZaZSar0k2GE2hQK4C5IHIyO1o0MelcTreaaa4vkJiQEVev2Gpxkk9k3
         sAnA3etIueRkEqH6nQ+Ka+CZlouHkYZZTD5Vo2Ylv72XA3SOUOusBnIDoB/yNh3Ec8IH
         OZTnqoVn0UpXiqv+wn4yXYQ/K2TRTlaeEw24MgfkXTrSN+LPcvlJTd22XTKStuWIzBRC
         VlPrWevYceJOJpIAgd+Vcwij64XjsAft3c5d6iZBl4isCi6DdC5vYUPG+qlHcqMtQ+Q1
         pUmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        fh=22MNjLCWqAH5dF8zHNluLK+0qSxR77rUsJM3n5cyqqk=;
        b=KJ/4hQS8G7lzX7YfJD0hBSmSbhbZemED+m7q/mOYwXERz+tjvhCIrh8XM9belm7xx4
         DDY+alw018T2d1Xk8C1gRm2AuP+1J38XmMkPLu/DPKkQJfXo+Npx4hbi5CsmzYJwAZcr
         ctkDk6kMxC3FiGwlRgob4dZLXzmLdpwsQjPO5oMtC/Uqs9tLA2P2WH6lP30gt9sCUevw
         UwxkY0iMHWaM1NEELUUDBG4PJVXDRRRs+b2+yYj8b0cefE9VquBStdEsgHvAv/3j0V0T
         2kaYDcfs17EcfAEr1o70gMEAGXyY9Mdm4C0QQQNCKNKcruAnjZC7Abj/qRO07dO7YZEo
         tGJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388445; x=1775993245; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        b=p5+LLAB0cpEJCu6nFFEj6V8s+vMqQYkWqDAi7A4D6IwaVMw4vKZPtn0G6/DHa48Z8V
         V7w+KongZq9iS/kHDIjna1ZlvaPyLryFtAiCmIHNXYPKZm8akE6joXvGFOxe2RSSD6T4
         hS6fDiJgWHTV2yJn/egDu9orrvyCmXRgVATn9hcvNwFDwczBMdlpo7Pb+kL6zLT+5Omi
         7UMDGcJutJXOxhKaTdYvgLt78p77slExTu2vdGuLJdcwiPdpdgrB2nSJrB2P60BuKa79
         ZbTYC8gJr25mghT7whieK2vboiv5bOdrJzy/RBawF9pTwqmEtso2+wc2TvPOlg/r1cwe
         LNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388445; x=1775993245;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        b=FHpZwycnZ1LaNUDokffpngKZYQXYkTUIZ8FP97cBrJkzcZ9rPc1z6YqcCpMaZGCzmA
         gjwp5PlLNfZQoHlm32zci2QWL1WoqYXqxvhm4MEdFtKJr2UtvcmQfyGHzYo8smYWL5Yg
         OgTcqX7+n/cTNeKLrB9IgopWkrtHaxCAlomOkYlG4BxY2KpiTVgpKRM2WindGQpcmQku
         LP0ww35KWZEVVnfXFMbDWd/+zxH5T0re3l0l5eAiu/l2yew5WYycyphENHqjIMThy7E2
         3xfHGgBEG4g/hmJ2jiiImrghNnOQF9h5YCroYcfQFKV27H+dztIDR4llE07SWCa8yIzG
         8CbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgkA5X8GZCymT0mU4qfWT9pCurMx7DKpNrl3Fsqd6dOYSl+Ojs4FE/YPdWLQVAkmokX/cbuTjqnDJ/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+eCc7nfNZSrnWY8qnoQWG7DV13sV/nW+viTyyO6gumtiX1LEM
	+YmTDL4bNFXnHajy+roiEY87FA4Ptolsv7A6tbQeQM2MpfeZUD4TCGRV5swY6tPe8NMaQTzAQwo
	0993t8EJ6kEPgEgviQuuxmOXmNc9g1A==
X-Gm-Gg: AeBDies+8qykFYT+MaoDy+5vi6W7OH7f/k1pNQZjInn8eRL8HyKVBh281b6jBWqHtDK
	9VDOiILGPnhlVchgHD0oGXlucVpQy6XjW31lsR6FzSZo5bshaUDb5EDGqySjv3lg5sLfUZofISN
	wLQLEIeH3bMW01vAFrsMbZHRst2IrWeaFtXBvIgWrRIcnhws+fY4QAZ2ZQ+yjQKuVrFMTOidZvk
	TP9sDHw1/CeurTD4OI7FVJx8E5+RUqU5iSPFmRA/2fVFFiMRnJUAMLFBgUWsKjxW9NNnEIwH68P
	NhxcubCl3k4HebUWt2zJC3UUuzzR4DGpZwWI5HtT8qEfVVgeb8iGiV0fu4ZO94ZKm9zNXQ==
X-Received: by 2002:a05:6402:274e:b0:66e:dfdf:cf1e with SMTP id
 4fb4d7f45d1cf-66edfdfcfa5mr545956a12.27.1775388444505; Sun, 05 Apr 2026
 04:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-1-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:56:46 +0530
X-Gm-Features: AQROBzDs0E7EbtHWRnG-_oRVFkR49Vyn1zNqbc_cUv_MF4CXocoxU69uiac_8Sw
Message-ID: <CACzX3AvwQ87hL4GOBmpiGDYGqvb9O_HVjkS_e+-jLiJGgA7HPg@mail.gmail.com>
Subject: Re: [PATCH 0/6] block: fix integrity offset/length conversions
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> The block layer's integrity code currently sets the seed (initial
> reference tag) in units of 512-byte sectors but increments it in units
> of integrity intervals. Not only do the T10 DIF formats require ref tags
> to be the lower bits of the logical block address, but mixing the two
> units means the ref tags used for a particular logical block vary based
> on its offset within a read/write request. This looks to be a
> longstanding bug affecting block devices that support integrity with
> block sizes > 512 bytes; I'm surprised it wasn't noticed before.
>
This likely went unnoticed because the remap path compensates for it:
blk_integrity_prepare() rewrites the host-side sector-based ref tag to
the correct device-visible interval/LBA value, and
blk_integrity_complete() rewrites it back on reads. So for block-auto
PI, and for the FS-PI path that goes through the same remap, the
device-facing ref tag still comes out correct even though the host-side
seed is semantically wrong.
