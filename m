Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5CC3C6A56
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813447; cv=none; b=Lj1qvQVcg70bmOjpZYPJhx7WHsYEDyzW3h4vSJw5SEVxJHuH9Ok0vlvHlw3pK5YubfLarG5iY+KA4tkEuCmElK6KncaRFeUA1azsiUYa//tRn980VsLebkh4AaD5fD325sQTnCG+bI0Q7qLFZz11PZQZWKY9nWhiF5Z915MPrmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813447; c=relaxed/simple;
	bh=2EeXpqQDt+Fd1xdkcAs9Zp3fbvTTh/2xP1kDKJJar2o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IuPIZ6zIjMLPBdeFhy4CZVNyvL6eRWQOxTUK1SSsQZ2OLOp6rv9FWrDqqruURTw/HdcpYQqt1R98aeUjCxDJpsL5R+dh0pEilG5hKmV2zYKXX/bZyM9ZPB/NcakH/Nm8p7S4UpCjG1rY4U00M0DyAMjc3YiHx9xZHv376tlBtSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bhb6clff; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bhb6clff"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-439acb393f7so12078087fac.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779813445; x=1780418245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbEyVDKYB6brZVOZVveRW94ChbWHXbhuaSGALUdMmOo=;
        b=bhb6clffjPZ33hypi328fsDoxxGGzo/mTIj2rr1QZbav0ouH+QMlwrL2Mq/VWQUYoX
         JHqQWpDqmXNH5CFER7V7c5GbSVXJhhcQaFCf02ADG0aVAdh7u4NbJ03kUpZn3d/n8hPs
         ES4K3VRZpEYKe+5itpRZWP4pWnyBFudG6LvAgir0R+chrb5SXpXEZ3WZr5nVjR6esOTC
         NSIU0Jh4j+WApsL16FMACve0ZFznPxwcwpLi6gt6zCYgIm4Td4JYgTJVIT8yCt9jvagw
         yX/a66GLQzJDG+fcqAuDMlIx7v1CLaMe2oEuYOsgvG9jxRjF4XR2Z7kG/2kOW5SDeDe+
         hErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779813445; x=1780418245;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CbEyVDKYB6brZVOZVveRW94ChbWHXbhuaSGALUdMmOo=;
        b=fDLn0U24/ojq2Oz3E3SvAYdPg8om1J0C6C2cPoLrkwAIZ6wFS426URrhPZxyQC8LyL
         vXzQs7O5ECdZdcMC6KT/KVAUB9uNeJbHUrI5gtRbnHAe4qW4Ev37cSuHsE5hdxaP4KjQ
         CXdcveiUf3H9qn0/izuoQ3jQU5LmE1aYNatNkoFxnd6++vcdFjq+VDHYjTte0ivGGBBm
         Hxi8WrMMxpXG7iTwsDPUex15OaT0psNWuFITSqplyTkODxmEh5k36sc9iwu0rS0nbzrL
         cXDYUlF6okD/Si4EQl3xq8Usw5vIC6GJK+5Xizz5FvH3ZAYHr7VCAN67B23U4LROWkNJ
         2Spw==
X-Forwarded-Encrypted: i=1; AFNElJ/bwPYoBHc0bMCigjZrm2lGbbPQsCt3KEAXRzUG+2vO6kXTOCkpypp3YNa8gHtnJUPvhDkg+VQUlQTo@vger.kernel.org
X-Gm-Message-State: AOJu0YxmHTrp3NvlRWFtnLfyhaOAXd3Ad0UVkiCE8mUgfCd8M2ccoi6K
	i3gCxSD6HLdutC9yehIhRnfbD57K454S6vMfeRWuvigxHKptTC0uzk9OANc/iF/dz2E=
X-Gm-Gg: Acq92OGk6kHotPxqPrAJ1PVSrFSK5MrmLQdI06C43jxxmt1kBS7IpD2wXXu+ZpAHQvE
	C28j0BM2VNpxcH2yh4PJijnj6TAsIWK9O7LaLgHJ6adCLyn69iHQA05fUPu1L5pAbg4K+GiJiyk
	kv3oBbxrsZPKtyezdxRGv/uwy6RsfjmpooAoydOUvK+RqC3DlfVo1SLlh72wczjUyG22LVmNU2Z
	16OPLAPZ52Hv4Pc1PoibXi64Rr9/OqSBNel4PiCtFH+YC23Wrkvt63HsliyESgz1wxbqX50XXmF
	4eNozd/do9rjJu7gBOXBsUVQKH6clzc533qRgOm5PKkJuHN/vxoqYskABE78zhf4veTd3gMbaxC
	ZYpiLYpUMcUbjnumWigsixaig3HaUhNe0/WinXiCAzzhY+o0oDJgG23nwT8L7vz9+HvtqBZK9li
	2G7KcAEBrkhFOXBMljQnh/DbEWJ7AcPAEO9MWGnTHg0SvgsZCNZK9CTa9zogyRoSndBAePE+BrU
	NTcES3QzaktaYHwwHXH5VAu
X-Received: by 2002:a05:6871:289a:b0:43a:5cd0:db00 with SMTP id 586e51a60fabf-43b5adb7a25mr12258063fac.23.1779813444777;
        Tue, 26 May 2026 09:37:24 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639fd7adsm13561265fac.14.2026.05.26.09.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 09:37:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Cc: Caleb Sander Mateos <csander@purestorage.com>, 
 Sung-woo Kim <iam@sung-woo.kim>, Josef Bacik <josef@toxicpanda.com>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Ulf Hansson <ulfh@kernel.org>, 
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>, 
 Miquel Raynal <miquel.raynal@bootlin.com>, 
 Vignesh Raghavendra <vigneshr@ti.com>, Sven Peter <sven@kernel.org>, 
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Justin Tee <justin.tee@broadcom.com>, 
 Naresh Gottumukkala <nareshgottumukkala83@gmail.com>, 
 Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Fourier <fourier.thomas@gmail.com>, 
 Al Viro <viro@zeniv.linux.org.uk>, Luke Wang <ziniu.wang_1@nxp.com>, 
 Kees Cook <kees@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, nbd@other.debian.org, 
 dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org, 
 linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
 linux-scsi@vger.kernel.org
In-Reply-To: <20260523125210.272274-1-mateusz.nowicki@posteo.net>
References: <20260523125210.272274-1-mateusz.nowicki@posteo.net>
Subject: Re: [PATCH v1] block: switch numa_node to int in blk_mq_hw_ctx and
 init_request
Message-Id: <177981344077.464267.4670805396521914701.b4-ty@b4>
Date: Tue, 26 May 2026 10:37:20 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 23 May 2026 12:52:35 +0000, Mateusz Nowicki wrote:
> numa_node in blk_mq_hw_ctx and the matching argument of
> blk_mq_ops::init_request can be NUMA_NO_NODE (-1).  Declared as
> unsigned int, NUMA_NO_NODE becomes UINT_MAX and walks off
> nvme_dev::descriptor_pools[] on CONFIG_NUMA=n [1].
> 
> Switch the field and the callback prototype to int and update all
> in-tree init_request implementations.  No functional change:
> cpu_to_node(), kmalloc_node() and blk_alloc_flush_queue() already
> take int.
> 
> [...]

Applied, thanks!

[1/1] block: switch numa_node to int in blk_mq_hw_ctx and init_request
      commit: 65e1c8f96ad1a1f3b72e8a91d1341d570f91d985

Best regards,
-- 
Jens Axboe



