Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685DC4EF158
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995313; cv=none; b=fjCLkw0iLrcU8K+7eJfkmXM5RRzvk8ArcYBIIMp2Ud/KOlpplmnU5IFJnkDaLPK+XuHuDjcY6Sfo2Uu4GLWB1rtatpvgwpSYB7jBaegfsJDARnDczcvOZrvttbuDCvGIQqiiZDOV3DLc3D/56ZMcn1yXX0zYnawuvPxNGSX2MJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995313; c=relaxed/simple;
	bh=yPehagrcDiSo/RPxpFDGlChD/sFaJFFXbcf24P4/SZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDyV6jRW9+iNQyv/nMCrlUQk5PaUtWNxh8pPA69jjav9e7Qp+u23X0SCwnwKSQvFo9IDFUcrPx/E36KPhYMbTBfNd5/aGIKEMMcvBuYOdC70do08gC6oJLUHXod+JUw2Bb8Y31s0I4LBahpbrWB2T80+fxhiBf0EqpHVLZhCdsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=lIRYVvwC; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="lIRYVvwC"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so157206a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 09:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791995312; x=1792600112; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yPehagrcDiSo/RPxpFDGlChD/sFaJFFXbcf24P4/SZQ=;
        b=lIRYVvwCOSB2o6vXGaZ8hE9lYCM4YxgmSpYD5ifRiWsoLelYQcOxudtPE+/Z377njL
         Hd9H/tzcAJSFxeaHTH0wgE/KIZi43UDkWF15h86S3hhYPa2CgVbzgxw/GAWcRfaO0Q8b
         +KUr/5aKFIS/uQtXGj3ATpC9ZdRjGv3qhYKtb2TqWqI435vBuLmYGkpqrwMzDVUIossl
         PHg4KbXiroeZq5+jctCfPUaR/uH6dGpN2b2Kqw0UVdLuQInviKgdBxv0zwR6tb5vzO8x
         hLjZC2DH2VvXIv4Q/sKnJEkcAd8szuwpDpr7qth8Dq3ItVM0H/qH0PwWxk7HvijAsb6x
         nqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995312; x=1792600112;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yPehagrcDiSo/RPxpFDGlChD/sFaJFFXbcf24P4/SZQ=;
        b=wDBn/YXeQO+bLkGTXkrud88u5YqTseqcWV+KjAAB7wL15ZsVkEComiepcad+sTdG9s
         /JkDUnBgBayDRy+RMXSmZyyRJ0PFWQbPdOkYZ5ix20WR0hAKaH8PUujVEI6gkxwlBuzX
         yL23KenCswLkF+Tpnrs3lvFk4HI+9SD8G85sC4eg21zVz7R4FgVug52ipz1RW/DP93an
         KW/T+rPDuGlyGQ8Q63Kv4YqxvHEMXLcrPa25vR/w0rMMUYh7jDA1aDcTy7/9wxmoj4os
         4v7dRGf6/pFK7dCCZgEHndls3R/Ph9Qe3RurxrlutLK60A92Tq3GiCkbvfzog3GkfeaT
         9lrA==
X-Gm-Message-State: AFq9FYKJLJjREI6aumcn/C8xRzgp7vDmI9V9L4TcKDAbBlqyB/TjdM3Q
	Um9cBvMBczvusuOfAzig90WddYpqPQCe8u/pjqoeiFVo7H8/ZIkCtuG86wnKytPk+tE=
X-Gm-Gg: AYBFou1bJ+Pb406x3bAVeijFTH7G6szNadSdXarH+L5rRYsYkeYFpN8/lrPtdYC1sjj
	/8mxKLYbyHuZG5+RLD1t+Ex+jv08SUx8QLg67bKhLaTyE750RNW+eMq2Mo/lKhidYM+fjiNAbqO
	oLhLfocHKvi2gkh1klA3yXqQbA/NLvyWE8rvaC+O6RpK3oYPZNlTKqZxZURfY4IoEaVSmk2p21g
	98TG/EsGPvEAORe4BYRTLMTpxRxUAMojQ11VV36O6QzesLXhMNodXxvwYqBw53I3qV5fevDt56g
	u+qcigWGa6XvqIZlPulA31ssCi3QMx6bf9s7t+9Kt5XgZVyxBJEYF2Vli2/wHPuBDH7gw4PzV+2
	67k1JLvnjZnMfhs/E/Fbk9MW0go73bv3fadrFx95IYBtsCbOmzIEujdcfsVp5PKQQjQzhu6wRLk
	5l6g7e+mbs4Gm2PSL7hY3iep+ZsJf2cSOZJzlfY04oGuNeEufy6zQ0A6y+8OBwwNkjLanquGYte
	NW+xSo+p6DNltFGg/6O
X-Received: by 2002:a17:90b:2681:b0:3aa:ff61:9504 with SMTP id 98e67ed59e1d1-3ab3a9127f1mr12794263a91.20.1791995311706;
        Wed, 14 Oct 2026 09:28:31 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94798212sm114910a91.14.2026.10.14.09.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:28:31 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
Date: Thu, 15 Oct 2026 01:28:18 +0900
Message-ID: <20261014162818.3650987-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Superseded by [PATCH v6 0/5],
<20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>.

The real defects the reviews on this series found are fixed there: the
target/LUN alias from 6/6 is now a device-count bound in 4/5, the shift
counts 4/5 checks are read with READ_ONCE() so the checked value is the
shifted one, the hotplug bitmap is bounded by the transfer length rather
than the buffer, and the response frame tag is validated where it is used.

The rest I did not change, and the v6 cover letter says why: the driver has
no device-to-host endianness conversion anywhere, so converting one field
would be inconsistent; the bitmap alignment, the size >> 3 overlap and the
truncating shift in mvumi_delete_internal_cmd() are pre-existing and want
their own patches; keeping the sizes across a shrinking reset is correct
because the driver is what publishes them; and there is no ordering pair
for a dma_rmb() to protect.
