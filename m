Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E01B3935
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455647; cv=none; b=Tm+TWXrMirhVFTUNhzdfviv8TYR/kZSaIemJwzeXymx6zlmAS0FsNjSAxhw/PHB8Q00VpRYS24NAthS4QzlSsiDrTJVNqOW26hOwpVOh25KOc+rF37R4oklahG+TzAjDtWn6BsX1Ysg8OKF8D+4+vTYtLGYhOLJqgJE1XZfxH1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455647; c=relaxed/simple;
	bh=Ur7y09Z1+O7SAhqfU0l+0bhkFIVqiFXfGXLpvOTzEww=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IsDZIItQqr8DspwAAHnIIXyANaeQv6tWDqD3U+pVqAORYaH1Rl1T0q7nPJ4g3U5YCMeMmsNZVnJv9v3gGKkTjQiEtrB1GNuAUR1tdRChNtfb6kMv7ldDfrl1imK5yX5jWRWVN2K/KHEMnwg4KktssbQIVpuYHB8jh70or2dZGes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DkIOIGsn; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DkIOIGsn"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so1655966f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753455644; x=1754060444; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rI9LR2cRzsXcwfbvdOvrXgKHQ7vsbcB6QBNYtkHWCP4=;
        b=DkIOIGsnX57qG2z5S9FR0nuPKt9OviXOPgzqt9JwBGAXV7KD0UdXpbWWUSDEgXY7dp
         v25PoOnpmtyCUX1ITnXQngfZpQk0GoRF1rhlOgRsH4isByrn59045rGQHQYX+qhgJLfs
         wLM3MpGt1in57XR9FIe59BWIB1thT8ugpU1hOJ1DCtbXljMW5hdOPnfb55iq2QP8i86B
         W5VpQiby/hxWSszI6jKjJvJ5McYE7MFmERhw70vYmQZPX6nHnG75uvvth0B0/oTZ+mol
         f7n175VcB3kEdkyt71DQMiM9HAAEapS2sKrPM0XbO5N98ZWQPKmLGbgfi2kcR0IoL+AW
         EVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455644; x=1754060444;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rI9LR2cRzsXcwfbvdOvrXgKHQ7vsbcB6QBNYtkHWCP4=;
        b=lcP5zPzD5yx6yno16Wl00aYwBzEncRWk9ZUMpEVehJL9fdJ05vz/Og9HFXl1hyyOeA
         qKwSSNccQIxl/GWhUEleTkXUGy3LINZKTDSBXE0jV9vkZRsPKNXzOh2gqgdribx3zacA
         y28OJPeyCt35ThfRpN7gqW/ZpA6JnTnPyl6RJJE5zJo9GRfU6KobdP+t3sGG0CFdoV8w
         KfaftSME9P7FW0d3Wk0FbGlmwSbL/+7jKU3vUJOowQUwHn/ztlqEEI/lLDcZ/toSUSAU
         Trc9eApBfE0nJRk+UqFPO7qzpM+AVdlS79jWvYxe99Dp5YQYTN8m3UlQfYAl4cwT5BjC
         rr8w==
X-Forwarded-Encrypted: i=1; AJvYcCWqTWXgYC+iShZ0NMf0Z0i3LJlkzfL4LDIB6zEuegnkI62u5jcBzriyefVOv/y8qleJsDaXMnHO4XPS@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6gEzsOYF5OOZ2tlJ1iP9Pc7T2APkz3PqLOvdGTCntVwF+fE0N
	yHNbFaG75TFb8p0BihaGsCt6rlvdq5XGqk8YblOgTR14YJHALiyR7+vZtzlJ795tmKU=
X-Gm-Gg: ASbGnctJ390g+kwu2V9wYwHDoc8eDxXiKB7VaV/L37VnUf6AH5riX2Z5JZTGDz0W6K8
	ZIatwYxVPJRwsszP4i+D8ioFvHNXA6oc8brB2O0vmWQ5NT6s/Uh1G/z4yqmNStGPvr1o4P4XVlA
	AbaYIEgAFBpnhW6daUCUGNpYPZzyd4DSDrifLxKY/i4qnWnQ7xUxJzL6J2cZPZztC+oA5DLLGEJ
	s2gpz0aYcWjdJAOls8ua6ok8nRw3ZFnqd76EPuNVtLvv9bZl5P6Qt0mhxW0NIkJGLeZNfT+QeXG
	/AfOTBoXUUuOvEskaAql2v/0d5TpsXbHWlNxXOLzL0LZgjrzFrEzRORSZeF8H69jI276KwLJ44P
	stMe5nTYeiFyEySTveRiOrpAaNw==
X-Google-Smtp-Source: AGHT+IH1lZBQZz54Wo2dN2kyzN7dZPNkmJl+cdo/n5TC3R0Hp6JT1si9hRUAqGSlMvqiwpVRFDDeYA==
X-Received: by 2002:a05:6000:22c8:b0:3a4:d6ed:8e00 with SMTP id ffacd0b85a97d-3b776664d53mr2246131f8f.33.1753455644207;
        Fri, 25 Jul 2025 08:00:44 -0700 (PDT)
Received: from [10.1.1.59] ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778eb2a7asm160745f8f.1.2025.07.25.08.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 08:00:43 -0700 (PDT)
Message-ID: <bc14b93d49ee5ec022c29d5c5568c2c1d1c52ab1.camel@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: move some irq handling back to hardirq
 (with time limit)
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Avri Altman <avri.altman@wdc.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>, Neil Armstrong <neil.armstrong@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam	 <mani@kernel.org>, kernel-team@android.com,
 linux-arm-msm@vger.kernel.org, 	linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 25 Jul 2025 16:00:42 +0100
In-Reply-To: <2e7c2be8-dc58-4e18-9297-e8690565583b@acm.org>
References: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
	 <2e7c2be8-dc58-4e18-9297-e8690565583b@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-07-24 at 09:02 -0700, Bart Van Assche wrote:
> On 7/24/25 2:54 AM, Andr=C3=A9 Draszik wrote:
> > @@ -5656,19 +5689,39 @@ static int ufshcd_poll(struct Scsi_Host *shost,=
 unsigned int queue_num)
> > =C2=A0=C2=A0	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> > =C2=A0=C2=A0		=C2=A0 "completed: %#lx; outstanding: %#lx\n", completed_=
reqs,
> > =C2=A0=C2=A0		=C2=A0 hba->outstanding_reqs);
> > -	if (queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
> > -		/* Do not complete polled requests from interrupt context. */
> > +	if (time_limit) {
> > +		/* Do not complete polled requests from hardirq context. */
> > =C2=A0=C2=A0		ufshcd_clear_polled(hba, &completed_reqs);
> > =C2=A0=C2=A0	}
>=20
> This if-statement and the code inside the if-statement probably can be
> left out. This if-statement was introduced at a time when the block
> layer did not support completing polled requests from interrupt context.
> I think that commit b99182c501c3 ("bio: add pcpu caching for non-polling
> bio_put") enabled support for completing polled requests from interrupt
> context. Since this patch touches that if-statement, how about removing
> it with a separate patch that comes before this patch? Polling can be
> enabled by adding --hipri=3D1 to the fio command line and by using an I/O
> engine that supports polling, e.g. pvsync2 or io_uring.

Bart, thank you for taking the time to explain and the background info on
this, very helpful!

Cheers,
Andre'
