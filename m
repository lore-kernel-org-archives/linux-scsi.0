Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADDF18C32C
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719416276; cv=none; b=D0sg3Oq5a7VF/964FZvPEOL4y0zqYQcyu3+Lii8WWZ/59K/yI5fLEg2KCLN8t7yvQDYXsMQW9B45+cFn9IiGHDZCWhrlJKDqVexMiHawEytmbLPdz5MWGtSGEbLapySpVjHsJIXw2EAW7aUbmvSfr4NJaI9WzPocM9PNCrpGgiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719416276; c=relaxed/simple;
	bh=qswXWhuzIZ+h28u39X/TbxoZXcqH/jfAdkbI/EQrJp8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k7lrAQz1Hrfyiejj3CJwnrW6Geh/Puk28snZ2IDh41ol9tpJkhOgPYnARbzr18ZJnj6xDbY1dAtROg+ugnqw69PnbEKm97zoaIXrwANvOfOXJyCrRw7ebrCizAnaKycIG9bOnIyNx63higIbMaibTjl+exk4p0YRQ5vvTVMf+0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h/BAZk0+; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h/BAZk0+"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70675c617e7so167814b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 08:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719416274; x=1720021074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8625LYB5aaVg0lsF/zrXcJOla9BjQc91ZD1HdTRXaQc=;
        b=h/BAZk0+ipeRczd8YfGYreu3scYDtUUB0/+ovRSG061NGdQMfWvvh8VWm2ieG9IHl6
         7SJ6IFPU19Y7rRYxvoyn8FFJMPfyWLBGJ52EFkngH4OfzE2FGIsRpzs4G1pycnCyaWrW
         E1NMaZ0LVKbcTSvz3bbcfdRJsfkfPAsR33QIlsqIM4uY67ZiPhAHgw5GBxs305KKVmfx
         qBu7mKFjtKEMtsGFFcjtlSI1hhq+fpmqiXDTv+YLpezCIsiTSk8a7dP5D7fYdiaoXqAj
         1T/tGZhcyKEuFCHgNJER+q/9QKrkx5Mjj3hMM84sBXlfMDad1rmK5zIIWFXmQxZrFzej
         e4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719416274; x=1720021074;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8625LYB5aaVg0lsF/zrXcJOla9BjQc91ZD1HdTRXaQc=;
        b=kLzYF5jJ9c8v9t/vOTnp2N7S4PZlb0W77veL+yNkYOkPG91WfemOdR+iYi18wO83KO
         G2MAj7JiNvbi4QixUbRuiPKKqB+JHpNc404umfQNpQXbN34/n1JS3RKKHIz3NsfQ10pu
         y5cX/i4dOp+vNWjmKFTjIgZTzyas8EUpoeadgicAo1//3IDr+s3qu+j/4FtzraNRe3r0
         MNpABUEccBpoZ+UOp+Pp/qX4B70x8Ifbyq9kZTEl0EFPpa8rENhfbElzfHs+2ZJ/mz7r
         sZsCxJmUiOS0RuZgWNQ/EC/wZBqUFNQsAzoraj6673Cj9jAVVJYyBdGNFw6TLyk6d388
         cb9A==
X-Forwarded-Encrypted: i=1; AJvYcCX4edXOBR6i/jkCyxM74hLCIfDkgwqk2Hhu5Ys1wOnIHG2We++Z4Uw0V/SXJlhSelpNavr6PPLpJ11JOoRd5oKuLb5mdChlg+2fsw==
X-Gm-Message-State: AOJu0YzmJoGWIW/efCF/vcrA35eO1EAIqaDZ+vFxi8qOyeNWovcP13fn
	u8Z+wDmorhEC1GTR5GoaMj0Kz/toI6aizNn1N9DqtCW+whu46v0xBYOm6+oJgGU=
X-Google-Smtp-Source: AGHT+IE1B3Foc1AGbVxgYLJqURuiVuiq4RlkiwEooUHzwNaoAi0MxEgooHMiiE1u87mf4aGEOgty8g==
X-Received: by 2002:a05:6a20:158e:b0:1bc:eebe:cc82 with SMTP id adf61e73a8af0-1bceebecd89mr13899066637.3.1719416274580;
        Wed, 26 Jun 2024 08:37:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706a9842478sm1340538b3a.117.2024.06.26.08.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 08:37:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, 
 linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-scsi@vger.kernel.org
In-Reply-To: <20240626142637.300624-1-hch@lst.de>
References: <20240626142637.300624-1-hch@lst.de>
Subject: Re: queue_limits fixups and tidyups v3
Message-Id: <171941627257.837674.361966910045628144.b4-ty@kernel.dk>
Date: Wed, 26 Jun 2024 09:37:52 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 26 Jun 2024 16:26:21 +0200, Christoph Hellwig wrote:
> this series has a few fixes for the queue_limits conversion in the first
> few patches and then has a bunch more cleanups and improvements in that
> area.
> 
> Changes since v2:
>  - export md_init_stacking_limits
>  - use blk_queue_write_cache instead of open coding it
>  - various spelling fixes
>  - document a new paramter in ufshcd
> 
> [...]

Applied, thanks!

[1/8] md: set md-specific flags for all queue limits
      commit: 573d5abf3df00c879fbd25774e4cf3e22c9cabd0
[2/8] block: correctly report cache type
      commit: 78887d004fb2bb03233122a048eaf46e850dabf4
[3/8] block: rename BLK_FEAT_MISALIGNED
      commit: ec9b1cf0b0ebfb52274971a8a0e74e0a133f64fb
[4/8] block: convert features and flags to __bitwise types
      commit: fcf865e357f80285af12c0c9a49f89d71acb7f4b
[5/8] block: conding style fixup for blk_queue_max_guaranteed_bio
      commit: 3302f6f09052274945f877beeb83f74641de2418
[6/8] block: remove disk_update_readahead
      commit: 73781b3b81e76583708a652c853d54d03dce031d
[7/8] block: remove the fallback case in queue_dma_alignment
      commit: abfc9d810926dfbf5645c7755c8d5ab96273f27d
[8/8] block: move dma_pad_mask into queue_limits
      commit: e94b45d08b5d1c230c0f59c3eed758d28658851e

Best regards,
-- 
Jens Axboe



