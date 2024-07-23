Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA47345E
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695070; cv=none; b=JmmZBNpsrTPaZOtf/pW49H/Ffk7HlWd+ga0VfDyS2aok+GLPYZxr3zH1D4n4BVaxh/jS1yPYuXR/8k5sM3UM8WLV7oDvrI81nOI83/BzPjuLbdBTh//k4KXsGMXOs++5FlfEI3yOf0s+2r0DfsyhpicB+3L999tRVjgdm6w0yAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695070; c=relaxed/simple;
	bh=D3a+dXiPQthlFfvcmFIw71AHdyEHZH4vd1kP4C5B44s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KCYKWJ2NBGF5aIAAtkr9Q2cTrplYuqhxAuZGQ+/uDnlk6mgLBwHe4srv2kcMVJpjQGxIaca0BcqzoJ6pG4re3J689nYBIHfYvgAk+cqX3GBcM503HMDiO/kIPoUfxbX/WNCFcblEpQGGvTs+oSTPjS933pTHSNnl3hiiAvD+nLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FHYanmM6; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FHYanmM6"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cd16900ec5so244854a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2024 17:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721695067; x=1722299867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtcUJ3RWleMldUajMj+zej3Jpt0/SjlD8RirhRbH+6s=;
        b=FHYanmM6o5iaI90/hbcpBY0MX60hXEPGLHYyoE1d9Lz3fuhW8NsySBnD60dIKAud1/
         JFyFcRY1R/a5H6QKVT3/xkFEXquRfAC/0nlNqikd2Iy9+c05WAAb+xX1T6SPJ6d7d0vE
         RTMd1IHaRGJbkZt3FxhuO0JXJK3dJfbfhoq3QbkPVdAhBUT4RvIlU4E29dYXJBxHX3/p
         xDQtjaHgpbeboe+bd8IGKqGlll3C2RjLauymsWTwbBE1os8/PrrLFjyx7UxEgW3jnpKq
         Ev99GzHARFkBkOhu4Dm5OLFKzsVa8l1ZZyT5h3zkPwrXSuQZx9RsZMFcXb44Vbn8D8Eb
         eDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721695067; x=1722299867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtcUJ3RWleMldUajMj+zej3Jpt0/SjlD8RirhRbH+6s=;
        b=et/fYfmB+xFwmC/z6lYTf9frkgYIe6Ptc4ikuOn0SdlhXRa2oZ035E9ekJt9XykS7n
         uHVzncfPAqcThI0C6W6sgn0vJNKxSsjrDS98frkQQQOwPAXpz2adn/+sYNDkngbVDVtp
         wsD1uJrjM8zdNMHcDm5ZaM6eZoEuFSnlUZW6g6nyhkO2OrtDVGaXgJQ3dbqmwaRbfXsU
         I1Twcu+5R8z3akBb58qukdq4avmnCloDsCaBIxbmEB+ewLf4NVKW2qUX555NzUQEjXP+
         v3jwl4OuixAKBiWlm/xBkodOVD8NmxlcF/fQgLg7TppB36S0AdJ8UfGUlbeoHVZRZEvg
         MKUg==
X-Forwarded-Encrypted: i=1; AJvYcCXRjlbsjZRdZ9XDFSXt4tb7uKProUiSntN8YQj6mPd5jiBn1MKIIdcq0uUDaReKcVEIIJ52btmgf665+Oc2O7x1bxjGCMmkceaKGQ==
X-Gm-Message-State: AOJu0YxV5eApIzY6jIm3fDVIhH3dSZcyKjWLFJCboFe9sKItjtQsFnkb
	KU+Ua5qfR5nB/vmtDBzCz+waHDmzctxDG/57WwD73m+rRHlQiKan4Tg2I3/FAIo=
X-Google-Smtp-Source: AGHT+IHBUsV3UF5T08jKSUPDiyfiD6ZXVUR2DV7PF7MqUJc5LLKo4T7ZP31NDftyu6cLa5jJqrrM2A==
X-Received: by 2002:a17:903:24f:b0:1fb:1ae6:6aa7 with SMTP id d9443c01a7336-1fd7455cac9mr74649405ad.3.1721695067484;
        Mon, 22 Jul 2024 17:37:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f47c828sm61173635ad.276.2024.07.22.17.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 17:37:46 -0700 (PDT)
Message-ID: <55d9f47b-5833-4e3c-9e56-f56a30083607@kernel.dk>
Date: Mon, 22 Jul 2024 18:37:45 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] scsi discard fix
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Feng <fengli@smartx.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>
References: <20240718080751.313102-1-fengli@smartx.com>
 <c1b47037-4754-459f-9e8f-ae4debd3fcf2@kernel.dk>
 <yq1o76pdltx.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <yq1o76pdltx.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/24 5:55 PM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> They can, but is there some dependency that means they should go
>> through the block tree? Would seem more logical that Martin picked
>> them up.
> 
> I'll get to them. Busy with a couple of hardware-related regressions
> right now.

All good, just wanted to ensure they weren't waiting on me, as the
cover letter seemed to indicate.

Thanks!

-- 
Jens Axboe


