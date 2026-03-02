Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5003975CA
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485496; cv=none; b=s4pBWbqsuBXbEz3M3l/HFHt+COnIUKoUrZnPkeoMcJRhrFhPPzg4G93h9BOBTW2bX+SNz/5nOoCxBP6X3qAo7l8ktQnh25S1AyH7EPwsqSFUfAP+3Q+5vqWcqJ0Ut4RiS76GxNUnndPSCqYUG2oSBPKWkYzTTR+4Q8Vd2s9M5PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485496; c=relaxed/simple;
	bh=bp8MxfLVfOLDFq0aYZEWtSvDAoA1yKcF7Xeisqp8xdM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JnFGwTcCCOjyt7hUS9B5s+eNYDZgwisWz+1h5MW17vdb44SI1d2Gwd2e4chvVLOt6XejwyWZF1Le95of2Phee0+xsXt2NoUtmI/WCLqw2RwpEOPPizFjUa3UXqvGanRnZnBgoamP6cf5ICUTFtfzOBXjbd3QsYm6h3RavrZShyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EwFZJAoF; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EwFZJAoF"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-464ba2bb3aeso3891357b6e.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 13:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485494; x=1773090294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=EwFZJAoFW1Wa8eTWGw+cVu6ZnPfwxnM84odhTiQ6Duqsm2P5Y1dbp6KxVwShV+vDZs
         /k3GnrRHNpqFNe5FSIc4HsyqjV4a9R/5eSw5BxQJ6Az7XUEjKJYHT3dG25ySfAT/ao2f
         wZKRpe0x36T4T9viuR4cwDmZ+YnbgMyaO/2bEtn/DvoRc86skNGgzENgM12YBXESwe0O
         JVrTdR6zGPV734wQ+/w3Fnta4zMk4M+SfsnQiCV9VXSXMMk94F0AnD90o7wG7ETcm6fU
         4Z1F0T1FlHPvuGZkuawZgGcN14vh+yZB3Z5g+k/wMS+D+CCh1MqwxOvgk0Mg6UnR3/Wl
         45Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485494; x=1773090294;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=CB/iOETtiIbsf4F4Hk5GG/ZAnAnelnkZE/viqZSYDCe6vpGLHFt5TyzIvf9DNoeghL
         xNj3qpdAE2l4E3z6eVvQH3WixKNcJAtHXCefdu9y0aPuT6API4WYoUmXeZespwcpHN+C
         6ycOK+lIyyjtEg/K6KrR4Se1uoVU4YhAOapvFK3/7Si9Lztu2zgz6+IfJUVZ8q8A2jrs
         crLFbPoBx5NPayIK3kAtVYjZ7XCOGItMCUKTZDuVVjaYhosVo5cuL5hmmrcG+Y6HrswT
         tdNGo8r5Pmuxr4DsYzngKPmlxm6myCB1lybWLhgM66yfiKMVs4vnOqg5pVKaG0ScxMQ2
         V86w==
X-Forwarded-Encrypted: i=1; AJvYcCUGHLsfsYm+3opTXtj83LRl58xh/9v9cEo6b7W8mOfaJsnBXhZTidWp0VKzNz+zTfN88k81R2RdoxV4@vger.kernel.org
X-Gm-Message-State: AOJu0YzvKmWeg1SBlzda4W3M+5lO72/z+53mS0DtCJIJO6iysF2NddFE
	+2xAsfezJ/1ec7y0PSSC8ayV8D9guxVSeddCxDPfZg/mH/M4Z6yyH9I7HEI9P4kJsmQ=
X-Gm-Gg: ATEYQzxqkH4JNHrqHzA9OnOD3RvXEz/DZJ+zuzMj4iNxL80FYdsbPo4p5ydkQWp2fsC
	UlpIZBYHV8mE1GSU0a/whhXsKVbzWx2GtQtdGJmR29bSOIYCKwaja2EDgN8oBbtJWSMqFIDZIUh
	66r6KmeTuway6VRy9K24MWqn05MaJFxYUNaazV5/aBVeamuaaq2QwdHIoaF8kgzF3sMZtXDNq5p
	S0Q/VN1UYn0pEax4NbRisNXbqH/xkFp23McRx4gszJ6N51TbgAA29DhXGm67XqYWNtsasLmjUDt
	dVs39ZaSnQ3UBIO9INlVVNp2iDm1n+aTxgCVswm/fN7bicxxOYcx+4OWzSLjAoiruQouM+cvgLk
	li926LMsuTVRSznFdZ170n+CJWIhuC3ERtWnBYgpaPXlMuyM0WQpKlz3ZDmC1qbLX9zVyyvVOvW
	8ANUHF/FYasUnwYIaENdUsE2Ej0FFD5Fwn4wHQBvG6t20eD8NWewxS0i6ItAAy1OY3sgsHeq9Q6
	WXW
X-Received: by 2002:a05:6808:16a2:b0:451:4d80:5ab1 with SMTP id 5614622812f47-464a5f0d5e0mr10177242b6e.33.1772485494483;
        Mon, 02 Mar 2026 13:04:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm12335332fac.9.2026.03.02.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 13:04:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Subject: Re: [PATCH] block: remove bdev_nonrot()
Message-Id: <177248549254.151113.14982963467044589269.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 14:04:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 26 Feb 2026 16:54:48 +0900, Damien Le Moal wrote:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().
> 
> 

Applied, thanks!

[1/1] block: remove bdev_nonrot()
      commit: d47f7c173262bbeb09645ec72bf91755eed6b1b3

Best regards,
-- 
Jens Axboe



