Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457623126BE
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763664255; cv=none; b=LiYE6XCJKaifG0BlVVyFdHGtAt0zy861ds8CZ8+hjmtxWybRKYkQQaMfU07dEpOejziuD/ci+MaNBbDHU2J+gmgK21UgIoQSAgjTMPAo5V+DkPI+7auFZB5gu9cnldLCkbOtMRz9tge7cDRnK4lv+EV1TdNlPJq0G7wciGY07GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763664255; c=relaxed/simple;
	bh=SunlJMvK0tyBG6whiOj5I5BfxX+8Ug6mB6PQyLzlpvc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYAS4zk9oCeAnCoE1fVI/fi62sCiz1cyhRgqu4H6G2MOArBzpQ8CSDfBX3S34XWYt6zwuzAPSdYg2RNYcWferMdSnBFg6Cr4uJFsS/j1ut7ZD0+ZrOG5r95VsaqodzXsn16iB7hDJy0V57B2YluWZesDj4ZzF6bF1/rLrGvoM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhHrrvXu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhHrrvXu"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso7794595e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763664252; x=1764269052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJrNo+cJlndHtNF8NwuBKA7UXHtMtDYUWgFt+UVPwaI=;
        b=YhHrrvXud1KLS1kSl/bXJRsWjVG7fz6U8gJXyIgsHUoo5t9tY4enfBT5DncvxecvHU
         orj4ZbOt/SdnBb4J/cAwXOZFos3AQ52+YFA67V3TKO4h7xjzAh0AEMMkZEcw59Y2/T+C
         eQuaYQ+iRFJ1acGeYcyIK/oLLOkuLlVGrW9K4l0oXXvBH8/fUBuQHNpM2hhUjWmRO4qz
         MIFxgk/AVxhtetWXjNRdRafNurBcHhknmP+BCUJNZq0u9E85c3HqeM83JNOsz5ZaTKWv
         ffrgFkQCUk2Cnd3pR99YzlzwlqLGyDOiiXzBHCCaKoudtmqwvSGlyJyeaImS6Vsx06Ts
         Vl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763664252; x=1764269052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qJrNo+cJlndHtNF8NwuBKA7UXHtMtDYUWgFt+UVPwaI=;
        b=M9im8pP8CG/vVcrnrWRb7VkEiEtmR9hv+8XAmimUOHYr7nzqKhjKDcFAtWuszOCfd/
         tc5X8jK52j3Y1rc89zCu/EpDQfxVO/aJeINzt/N2nf7D6DA9SfYvgt5OqQlnL0tYw2wO
         XNPV1VQZ3HWSFCB0Q1Ba4uN1fKYzYZT1AVPtmSDB2y30AJTlE/mdeYEhH51sipkzOkEj
         O3qm3E99HF+LyJA0LGMFc3zdxUDzSUQhfNtaQI22w9z3pXc9iBfqImu7Ixqqk6j4hm6Y
         p6g6Ku1fGLd/VI1NBg8aHWtXnWzooZzsziM/9bbd1rv9IM5M/McEOX721DtV8C+xU3n5
         uEQw==
X-Forwarded-Encrypted: i=1; AJvYcCVYj99OPuirrXnO242H3Q0+Kyyva0pbjd82vFhK7ZmWkJTMQEsL3E94tqOxlJ/zQ27dV5MPvN4Lyweg@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv7YIf44UVUeniA1Rr/Hfv27ZG4bH2V9tguJP7ATcbzDqVU05x
	AktoYH2k8E78YS284G93wATdzaRqyovLAb9KxqWNboWqxa4ajC4gP007
X-Gm-Gg: ASbGncsvUvMdemV06DR8rfbZMk3WFDxuQ2sme9Tc0s54hYcxdNgqIlzfwFCXBce6U6z
	WLr6Q7m99pyCZLdBpqpzsuS5lQoQtZ9ULKOLhQoam6xJdUzCiZrfDRjtpXV3xdppMYX4RFmuNZ2
	KWALKjs8vjwMJUWahp17k03IkmIyhnemdE2e6A6gPbbGArZNeRSTj0cSsWMCOcFo4o57q3CdBtX
	LIsOxZVRqvuxSMWfpWWDiv5Nc4iRXSVcmiauelZTtjVV0hb2euiN9OsYZ4jfCm83Nx7HqeX69Q6
	RgkKc/dRF0dpScRg3AAbU5dTx+hNYvwfWOHAAWpj9AWjnOpvw0nzcZnd7Zc0m/5o2HJz1zozsQX
	a7D2jQBjvALX+5cpP39tu8ZSolQKfoq4ZxeZ512UlrBnLJUOVSF7Q3QcQq5nGrS0J39+oMjJ65/
	73jZqvSHv6cJEWo9BEf7uDuFCTzsAinAcwDJAR+sHgFK91pMiPkG/N
X-Google-Smtp-Source: AGHT+IHqiDIShzRl9eiBzv/oh34eETw7hMAfWyuJU1Icj3jPbD0hWbvPaXLWF9dLvccDmwZ9sDVLTw==
X-Received: by 2002:a05:600c:4ecd:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477b8a9b267mr34598365e9.25.1763664251610;
        Thu, 20 Nov 2025 10:44:11 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1f365fsm3763665e9.8.2025.11.20.10.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 10:44:11 -0800 (PST)
Date: Thu, 20 Nov 2025 18:44:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH 26/44] drivers/scsi: use min() instead of min_t()
Message-ID: <20251120184409.67db1c25@pumpkin>
In-Reply-To: <2a8c62e1-6e29-4ac6-b661-7b5ec1763288@acm.org>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-27-david.laight.linux@gmail.com>
	<2a8c62e1-6e29-4ac6-b661-7b5ec1763288@acm.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 15:09:02 -0800
Bart Van Assche <bvanassche@acm.org> wrote:

> On 11/19/25 2:41 PM, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > and so cannot discard significant bits.
> > 
> > In this case the 'unsigned long' value is small enough that the result
> > is ok.
> > 
> > Detected by an extra check added to min_t().
> > 
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >   drivers/scsi/hosts.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 17173239301e..b15896560cf6 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -247,7 +247,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >   	shost->dma_dev = dma_dev;
> >   
> >   	if (dma_dev->dma_mask) {
> > -		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> > +		shost->max_sectors = min(shost->max_sectors,
> >   				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
> >   	}  
> 
> So instead of the type cast performed by min_t() potentially discarding
> bits, the assignment potentially discards bits. I'm not sure this is an
> improvement.

The assignment cant discard bits because shost->max_sectors is also on the RHS.
In any case you'd need a 2TB mapping size to get an error.
That probably cant happen for other reasons.

The patch is remove a false positive for a check added to min_t(T, a, b)
that sizeof (b) <= sizeof (T).

	David

> 
> Thanks,
> 
> Bart.
> 

