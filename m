Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE13BE156
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162395; cv=none; b=AHHzDDnTgo658ttuU3A1sU85XATiaZA8Gl4lXIkXw2RS7mwT0/IbLGrtAVer3FI00FTw4HP4wrDmEMBy1mQaYwqfC50JW4un0k+e6F462WosTCRffTHDdWRWI4eSsxbhj81GuUKq4LYeJ56sRlomVB3cbhJsSjRJq5lZl407obw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162395; c=relaxed/simple;
	bh=0L+s1VkLpLCjh6wDTFg0SJ6tYpQ9eOqBt93snrw7zDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=XI8rWW92RAtaNMBFY3iCZlkglJFUfPnxYVDtoCnSrzsZ2Mc/KWj0gVeGH0HD5WxYkHc4BrPmaztPTguTTgV/PI9iTZ9sfdThv6VOo/crYYbJaVVZOcLB8Fcj31C75SkIs5RTntwGhTm7fwHutpS4evu+/XeWp85lxbhoRMTsxW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JOEmWumH; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOEmWumH"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb1a990so596602a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 04:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790162393; x=1790767193; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0L+s1VkLpLCjh6wDTFg0SJ6tYpQ9eOqBt93snrw7zDk=;
        b=JOEmWumHb/3ylSLiT7rgljHgFJm+5bUKE41tD3P/eSQu8iT7MYq0tnPKdXLwkN8ZVK
         BWpQWdvSzf0I9/nyQ7gzYLnQmNEgyarE1Xb1BHr9DuFHos6NLp6egAndkj9IrXWUfpqe
         wSwmpAldoNqzW9c/dYNUk0O0J4onafz82w2Jqx1Mpzt9tFK/SiLG4eO8dGip1bqTfaWn
         Q+B/vwI43TwPc62lk9FlrBOlYCfi+WUpfq4eTztbq5AIkt3ZY0zr0mODaqBR3Gsp7AzT
         gqxjvyWy2Gs9qxaXKMAwMR44V2jDoeqkCvucys0Zuky22D7/7A4c82mRLb98W4mW/2tS
         28wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790162393; x=1790767193;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0L+s1VkLpLCjh6wDTFg0SJ6tYpQ9eOqBt93snrw7zDk=;
        b=LrwMNs5QQU4oXvQKb/oNLDwNLSrX15MYWx3NhrfE9+eq/expTDCaQ08g/yUuhd89Wh
         MPeGGW8Ukn2Vv0/NjxOUIFx59DjrhmDfxoj8YbZ/zTkuE6svs6BniL8YpAtN5syW2bts
         g+ZLkGjYQNTRvY8n3tPY+ALdYhzgx0MYnAd/TSX+CbT6APrG7BgPnxImcmOyM4PATu41
         n10BzcgaIwz8oiVTivKtU1eqom6uypMHZLmgxubfFKg3E5QOkJDYC4ik/LbobmWFOuwg
         Kdmi8yBbStVKRtlZ+r378O74EWIRyro+3yA7i6Lp9IfsL7sau4kpIIDHfAMQ5asPNVuh
         dzWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwv766EvpZt0wgMJIzoGvShuyeVLRQP8KPM9IaHKOEUNN359D/Z5L8Rg3pPOvkS2BmjDNDd14GSUfP5@vger.kernel.org
X-Gm-Message-State: AFuF++miZCnWtjc/XMu+cRXkDPxSXaE0UZfUIjS5pqBQLncdX/kgxoUx
	UFY+LWSNBR2FvUPoEvrpbyYYTA8XhPMpbbWck1PT1+sghwlgZ0xLfeYv57ZQ7vdrhng=
X-Gm-Gg: AYBFou2l5IBlVAA1edmHLYINOWPYucOP5Vl22N02EyWW2dT+uhxQPINPgCPmEcXZjMc
	+nCZILnRg2AhHn4gvXJeNK8ZbLxyTUk3St1vCKOezPAW2g+0yAIsEhg8042E/IiIkNy4q6nHMwi
	Iln+Hr9k+sKgqrKMf5CNy9b45XjH4/8BMXy+DstzafxmSVA+SZ7XvzxM8cnYgrCBuzTCAUEYc/B
	7nA6aJVazj6P8KjpnD+aIUOKUlnUwVg1KHAdHuHpHKG8/ptcog/XjiZyPvalnRobLgohvvYJW3n
	b62+clva+GUsh9JUdv/jPy4FNRb7IgBRBTduPn5WEqjb4ub+woluckJZFlMPQHOJwmRH/sDLFJQ
	EYBHMp/4Fmn1d3tBL1aP5jHpCFbrwIvJ3UKxEPpbt/vXb+AiFsupBVs0NX5uq6ln4ZdAWIZ7lGY
	UIHf5ScyS6i+TNAbzE6oYChWSh/JKL63qjkYZCBPyRVcF8co3gH4x+T+CqukT0aaNfhW052UvUD
	zA2z4gb
X-Received: by 2002:a17:90b:3d8e:b0:39e:4c80:44bb with SMTP id 98e67ed59e1d1-3a07e520a8bmr1848980a91.30.1790162393208;
        Wed, 23 Sep 2026 04:19:53 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07ddae723sm4722646a91.5.2026.09.23.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:19:52 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-reviews@lists.linux.dev
Subject: Re: [RFC v7 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Wed, 23 Sep 2026 11:19:47 -0000
Message-Id: <202609232340.ApologyLee.lhw@gmail.com>
In-Reply-To: <20260923104559.GF3864833@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <20260901145204.2BF551F000E9@smtp.kernel.org>
 <202609032000.RFCv2-0.lhw@gmail.com> <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
 <20260903161357.GX2133376@google.com> <202609042000.RFCv3-0.lhw@gmail.com>
 <202609042030.RFCv3-1.lhw@gmail.com>
 <20260904131503.355C41F00A3E@smtp.kernel.org>
 <20260910093232.GO2133376@google.com> <202609152112.RFCv4-0.lhw@gmail.com>
 <202609152112.RFCv4-1.lhw@gmail.com>
 <20260915130050.E8CDB1F000FF@smtp.kernel.org>
 <20260916104305.GM11487@google.com> <202609162015.RFCv5-0.lhw@gmail.com>
 <202609162015.RFCv5-1.lhw@gmail.com>
 <20260916122740.921E51F000FF@smtp.kernel.org>
 <20260916130602.GS11487@google.com> <202609162200.RFCv6-0.lhw@gmail.com>
 <202609162200.RFCv6-1.lhw@gmail.com>
 <20260916143832.520721F000FF@smtp.kernel.org>
 <20260917112840.GJ1605367@google.com> <202609172115.ReplyLeeR6.lhw@gmail.com>
 <20260923094539.GA3864833@google.com> <202609232015.ReplyLeeR7.lhw@gmail.com>
 <20260923102812.2353292-1-nbg2974@gmail.com>
 <20260923102812.2353292-2-nbg2974@gmail.com>
 <20260923104559.GF3864833@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

You are right, and I owe you an apology.

I submitted v7 within the hour of your review, having read only the
three comments above the diff and none of the ones you interleaved
in it. There is no excuse for that. I am very sorry for wasting
your time.

I have now read the whole mail, all 33 comments, and I am reworking
the driver against the full list. Where I think a comment rests on a
misunderstanding, or where there is a real constraint on my side, I
will answer it in the next submission instead of silently keeping
the code as it is. The next version does not go out until every
comment of yours and Ilpo's is either addressed or discussed.
