Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955E16D9B3
	for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 12:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901049; cv=none; b=SDXlrWmifK9O2jYWfyCFO06zJ/gYaE4BfHGb16MrpKyxXh5SqAhLuvzBi4E7iQct8m/4b1g5GPMY9m89jxqIyz5FMsE0EY6UqLkvks7WpCO7CymztpA8VACHddWfK0JMQvKxmLPMnLot/CYsOs1ViXQ/fdvBbnmt0EBdRyCfYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901049; c=relaxed/simple;
	bh=xckvGxOTg/lK5cif/dlUPP7K75rJd5o/fYmUcMKFews=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ckt/9P8cqGvg4bMiPqx4fvjQiRTpcPTnVhsPBKYbwzPeNSSSoe7dc6gQB3IngEbGZh+SQeiVVpCKhFqCEPGZdRpngKpQbcC4t+ESpNQhXyES48yOIZrpbubzKiWDWqSgczj5JBraVcQCuZSsIBe6ZvGxtGubCh9Ivzots11B470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iMpW2Gen; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iMpW2Gen"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f32696c112so325945ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 05:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716901046; x=1717505846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYN+y0FKjMiFfxNxeNcv+kisab5C54aEhDjwsKNvTjI=;
        b=iMpW2Gen0gHodQ7rui4bO9NiUyi4lixuOCHjIRMXBfAXcm49XBC2iUhJYpt/tBQV+8
         jLt4Dc1Ga1wu6FnvaEd89kVQwotiVafgINMeq/uciA2mKq+PBJS6aMLekXbU29wV2sr1
         Mw8XPvFdnpOo8FDVTdefj/i5WgqUZ1S8RZlUlIczPd6aIG75zz7KZa/O6RwK9S0GbZAc
         Hv9h2Abr2x+7Q9IogG5er9iL9ZVa6bkrL5+SWG45/CLCMvVeeb0B9PPXBTiv08dWHJzt
         A/xk9eVjOR2IeZ0/74ygyfxoQekLku23jHLDpQJocAdWd/ZSk37xQbbLyoNcYwzbF+A3
         QFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901046; x=1717505846;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYN+y0FKjMiFfxNxeNcv+kisab5C54aEhDjwsKNvTjI=;
        b=gHVs5FecSXB23hb0oiCh+tuVvnQH8EEI8eHsWMlLc0i8bnMzhK3/M2vt4EgKB/W9z/
         AvLqg8qwzum2WxNeUq+XdNXwH8audpZQY1yWbekEDOgtTRCsE/4FQCndIA4S/6c3Xsw+
         kJqsf0fSBckOp6Eh/8BSbdksB9wd1MeX7+b8ozFnE55OrOjpZR3huYA8UKRTUGB6wlca
         wDGiL9nvXGRBsmTOnIqPcGPVcrlhbEwlORynyvMwQSr20VrC99e62c+dXOwgdi2NhAA8
         5li7aCc6D14uIlTJdWxPhg+eKaf+EG1lQa4YmdSXkniytaAUZm+gBxwTg0Pys9FJ0/xN
         JE/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW74V9GuvnMYbbR8ci5GYdB+2u88ooRHyoFBOrz9mcGsX8iYvP5liUUNRv8VVPctA9K/zUPxfwUiuS3QI1FxzlP3j6aDKaY2389Xg==
X-Gm-Message-State: AOJu0YyS/byLqM6KWu9JsbDCyJt9/pmfg439UsRwr8T7/k8grnmhgNrX
	oo8Eti5FtQYMPYsrc+DazEaISsiYhrp/2XqpoG5xkYLQGlFH0oK599B0WJqAbAzDFnCdlurAKMr
	5
X-Google-Smtp-Source: AGHT+IHfg7PaOLjhcyBQZnYo0OBle297wmr0EK1KJxoXRsP4bx7sQyTPNGJnYx5ffb4QKpYXTHjyxw==
X-Received: by 2002:a17:903:2347:b0:1f2:ff65:d2e6 with SMTP id d9443c01a7336-1f4483e93e8mr136790545ad.0.1716901046335;
        Tue, 28 May 2024 05:57:26 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c967ac0sm79255505ad.180.2024.05.28.05.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 05:57:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
 linux-scsi@vger.kernel.org
In-Reply-To: <20240523182618.602003-1-hch@lst.de>
References: <20240523182618.602003-1-hch@lst.de>
Subject: Re: fix stacking of sd-imposed max_sectors
Message-Id: <171690104393.274292.7885096310356049183.b4-ty@kernel.dk>
Date: Tue, 28 May 2024 06:57:23 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 23 May 2024 20:26:12 +0200, Christoph Hellwig wrote:
> this series fixes a regression in 6.10-rc report by Mike when using
> device mapper multipath on top of SCSI disks.  It is due the sd
> driver not only setting the hard max_dev_sectors limit but also
> pre-setting a potentially lower max_sectors value.
> 
> Diffstat:
>  block/blk-settings.c |    2 ++
>  drivers/scsi/sd.c    |    4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> [...]

Applied, thanks!

[1/2] sd: also set max_user_sectors when setting max_sectors
      commit: bafea1c58b24be594d97841ced1b7ae0347bf6e3
[2/2] block: stack max_user_sectors
      commit: e528bede6f4e6822afdf0fa80be46ea9199f0911

Best regards,
-- 
Jens Axboe



