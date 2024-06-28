Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86651C9EA4
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592673; cv=none; b=pxmlwV2ZnOQfMW8dzYqhVrke9dt1G5S7FvpAEgMzjgO4fHzeS5L6G8UckN6m+bF/0R6eZSRXn7HawGN4l9FinShkegMYQ4GUW9y27TglmRL5SpIIqWmj0GtM+XNwLqbEeYVnavinUT/TSPdFP9r2wePHfb1guy99YqFZnuH5hhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592673; c=relaxed/simple;
	bh=eqZHn54iQb40cy0Pb/UOewdYk6A3w5LjQ6HMF5x3i2A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dwjidIpt0vRwUHnIZ7zdBO9cGQ4nM9F115aw+lr/BcoxkjDSO7F39dSm2EIC119bBw2fFDOknm9+qVqxnwPKyXrCaz4cp/FOL1+sPbPmu5fWRcqMNp15wCcEPKF5wHmMwkDjrDcc5Fsd76vCrhIw5KMDpat69lMNtpJNivYgRX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uXdeGjYl; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uXdeGjYl"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3d5633d08b4so52688b6e.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 09:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719592670; x=1720197470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoyK0ZTBrcLbYx9IyVvFe1bmHndOJZFTfbANvFNQbV0=;
        b=uXdeGjYlFcVATTzkdhlJvIbmc2FVWUkgGhRUfJXWXaxZVj+bj3b/UX5HOqORkZtSba
         23camUUcujX+4WPE0lSwqJprWZzPMPrjITK6f2uZOLdHIXkM4D0A+LkiizD5QV0cOpYs
         nKMgfenzjGMKfFfYxhFjDC2UmmRiAQ8c5uuPJcsVk3Ib0hpmMiX/z5jTlafa+1LYdgqh
         CXszIZxLCUf5p8OqLOsAGWvl8XqdAQbC0JJ4GyrjRYt5POc4pOV4jyqlsOSB5dmY1dZI
         rZrcTzYc4w6bDD8wWrUGnsoblKS/f1Rdi5e3Vkg5XANVxm4zfEIZ7jNFfgmFcYDD/Axj
         jNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719592670; x=1720197470;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LoyK0ZTBrcLbYx9IyVvFe1bmHndOJZFTfbANvFNQbV0=;
        b=lxy2QFO91T+mDv9hqk42n/xUDEv7U7P9+uR/rn7DxHD9wQUa3K9jqPvacEi8oXT7Kx
         a2r/EFH5faK2lapN7fAl7EsVTR0khsnqhDDre3eQIkb8EbhdydFwApPTnVCLMXwmgd+i
         RWqtNvSKbcEQuctQR/FcmOp/hkbLwKXlcHIZZPItAl867yFTqG+VlBLCpX0Sup5tdkQC
         /put/c1hP0f3KaANis44aE2dJ+v/oioq/LzbRjcGOlvWDLyh5YY+VbdTQkexAZg6Vc/8
         t0n8ONekww1f5Ew999oumK2oCwUlHezfsW6yE/JOYWlMuKIBonsUMAZ6nM+g63pRUv35
         lDdw==
X-Forwarded-Encrypted: i=1; AJvYcCU09MjYEpvdY3r+bIw4hF7LesCw6wdTzWSkRdcegkHwuwGBYne01+6DwCmiXns1NTqP3LkFVWlXwW+p5KgAU0XbzD5Df3e5eZ9+xA==
X-Gm-Message-State: AOJu0Yx8pWdABxP53j7R2UGHjWDACdFdn/wnidFEXNfQgnyL2qQz+fmY
	Y9VHmK4a0s2lqe01tmCNncGBLL5wtB5x0/yWl3l0puJl34G5eEQVFhQsez6z7VU=
X-Google-Smtp-Source: AGHT+IE/KifkR6rNZ1+mh549HbVui6zgKDkL1OMxLvSTa54ChNIoGd7uQTsLpwD4eNCB+90Dy9yudw==
X-Received: by 2002:a05:6808:1484:b0:3d5:4213:82dd with SMTP id 5614622812f47-3d542139c8fmr20550673b6e.4.1719592668883;
        Fri, 28 Jun 2024 09:37:48 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d62fb3fa01sm354938b6e.47.2024.06.28.09.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:37:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, 
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 linux-block@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
In-Reply-To: <20240627124926.512662-1-hch@lst.de>
References: <20240627124926.512662-1-hch@lst.de>
Subject: Re: get drivers out of setting queue flags
Message-Id: <171959266746.888157.61361280434306955.b4-ty@kernel.dk>
Date: Fri, 28 Jun 2024 10:37:47 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Thu, 27 Jun 2024 14:49:10 +0200, Christoph Hellwig wrote:
> now that driver features have been moved out of the queue flags,
> the abuses where drivers set random internal queue flags stand out
> even more.  This series fixes them up.
> 
> Diffstat:
>  block/loop.c                      |   15 ++-------------
>  block/rnbd/rnbd-clt.c             |    2 --
>  scsi/megaraid/megaraid_sas_base.c |    2 --
>  scsi/mpt3sas/mpt3sas_scsih.c      |    6 ------
>  4 files changed, 2 insertions(+), 23 deletions(-)
> 
> [...]

Applied, thanks!

[1/5] loop: don't set QUEUE_FLAG_NOMERGES
      commit: 667ea36378cf7f669044b27871c496e1559c872a
[2/5] megaraid_sas: don't set QUEUE_FLAG_NOMERGES
      commit: aa57abe6a7f91fafe53fb98d0f1e74db951bce24
[3/5] mpt3sas_scsih: don't set QUEUE_FLAG_NOMERGES
      commit: 8b77f23fadcbb030a898f168bebe74f465e5d5a2
[4/5] rnbd: don't set QUEUE_FLAG_SAME_COMP
      commit: 40988f15907baee227d3b83bd4d8f8fdfeb95dd3
[5/5] rnbd-cnt: don't set QUEUE_FLAG_SAME_FORCE
      commit: caffa7cdce47718a0c2e3195c9a1bcf786d655a4

Best regards,
-- 
Jens Axboe



