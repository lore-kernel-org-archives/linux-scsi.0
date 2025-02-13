Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511D920E034;
	Thu, 13 Feb 2025 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739485837; cv=none; b=MrwV85K3j5uLjUnDDqXKp4qlHxC08eb6VjDFznoALswE6XR/SdRPjhGTWoIxIqhdey4OiR0B+ZjhV8k63LSfCcoAWIPUCY5/Jg4FNuP7GuULFclkPOgQJvpZpAD+RphpE2pEq7qiW+Al2X/4rGGBfR7D4RULWkZNpbgG61Co04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739485837; c=relaxed/simple;
	bh=L7zfqJC4MpmnmDeMNG6teF//B8o8peRzpXrtxlAsFQc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSTeAWfcJXNeIdUSonSb4MkR7AxrXuXJR40TUfPidIKyFGAkZUJmIujmORdJq9vzDzE8HzEK2G6H/5g+mEQ0kG4+0F7A4M0oLA22SpSHdUngE0d62j7ELZ0X+uy1gsMQXqv6f1GBf8b3NC6dfO971qx0udpxyyieP2KybIIW9Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/TXPIke; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/TXPIke"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso9203075e9.1;
        Thu, 13 Feb 2025 14:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739485833; x=1740090633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/iLgtKEagKiKrbu9N5uMGOzCeVNeqgYEIjWrTZEUX8=;
        b=i/TXPIkeu3AcQspAiexZcolxBqlQpA9d2Jnvkbqqu+SlsE0vscc9U/f1h3n4PPR1Ow
         HiVLHVLnSK8Ma/JMFjwLwGMykFns5DtWh50nrR+xSklxW0XN4I0WN8Qbuuo5e3b80yOa
         cpZQ47wfe4wQNcsxgjkhpSpvFw1Rt92+OXWQENrmhJcw4bgp5nRSfJ95KDlG1FAbxoaO
         bFcneNrkpzWf7VIgzz92c8TLsrc74AbV8HNAQWWt4CV6KrlOFuU0mGj9LB9M+TKoXspP
         HyVx0DDk/vA74h43QnS+0Lp8YmZJeV+BOZxg68QecNwduhRKJR5FHEOapATR3M47ZSdC
         38HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739485833; x=1740090633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/iLgtKEagKiKrbu9N5uMGOzCeVNeqgYEIjWrTZEUX8=;
        b=DU8Qrpu+spiAz7x/vHopxhgIMpC/M/BV3YSYlvjQSP1WX81X8deP2NvFevbnwctFjz
         HSvzW4gVbK2uyh4+PsQZsPNMn4eula1YK28EMk7eeogw4x2/emQ7E9huP1eY+73IJ9wl
         GF0JWCaSrVQZo8F33hf3Zh0M1EhLuXRURpqRvpPc9kJlcnz5m4LXnXm/6oSS0BihHFSD
         OAcGL1vyV4GMHfCppFA/0FGDkgQGF0T7bKAfg5IFtexD6UZAuV0MqmREjel0B4u+h40z
         DjNU0Zkp36phItcagPzwZ28L5BYpW2JkktjAOTN9heyd+kn9BUazhtbcZdaeuFi1xRq6
         ir3g==
X-Forwarded-Encrypted: i=1; AJvYcCUqW/ZGb/bOO5TwkBmnKIF6hIoz9M/J2g4rBOyeMgYVnjD6cJb+UTuwqtgN9/9Px5OklqFcn4C7WaZhXtZhZ2g=@vger.kernel.org, AJvYcCXjNvJXn2s/biBOCoohavfMWqrsDUpwiyvPjPczm5PruQrrhWA3l7yUxJ9BI1m0wbdErYCA95fJJGNpRg==@vger.kernel.org, AJvYcCXkqFLTXLF2ETRFPafU9CO6Sri8gS1MA0nZXU4s9WfQV+Ypq1pU4dYjIySDGMrG6VHCat3rti4vSCI/OHy5@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbeb08Ykiyxjhnmfe+LH/0DzPJjUeit3ydJijHKu+DqhVorhsG
	EpVavYst8aahF95manNjpiJLFGh6URJxsIUqGgVoDSwEyxk8wpVY
X-Gm-Gg: ASbGncsVNT9xpXb5HXSO0TdJIC+HFOgWZiTksrze3RvqB4vOZM8KEox1VNvXAQkAOrg
	DWGUpxt5COubcd5b1FUctr4Vi3TC/IcGXV7S+sZ0zx0XJK/ErBNendbIJ7X322xoepNtXBeN5os
	AcjIfFhXkCFls1ELwKdxxBhxW4OUPF+zDcVwraVP7tzpYsBoVNCfIJwO9yZ42X2GPPoWCJOIzja
	eXNdFAgyXjSjMtfJMza/4sRy7QsyPXmCGChfTkopPAMjfDnSRFrfh8sHPV3aEB7bt72hNqpmGAH
	nfRpYHdBeRksgf9U4empf7WgtcSot1oGTI0LkwPzrpRAWpTH2KP4qw==
X-Google-Smtp-Source: AGHT+IGSJiMq9waWnU3twHfZdxNULB2eXCgTc8OLciDMxrLkg9MtHaBVnOEtNQVIOSUY+JHzU2kSig==
X-Received: by 2002:a05:600c:1c1c:b0:439:3ef1:fc36 with SMTP id 5b1f17b1804b1-4395818fdfemr104530195e9.18.1739485833325;
        Thu, 13 Feb 2025 14:30:33 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5d8bsm2959370f8f.70.2025.02.13.14.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 14:30:32 -0800 (PST)
Date: Thu, 13 Feb 2025 22:30:32 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Don Brace
 <don.brace@microchip.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-hardening@vger.kernel.org,
 storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy()
Message-ID: <20250213223032.20d64851@pumpkin>
In-Reply-To: <065b6317-8da8-42ec-8084-1a5058c0798a@acm.org>
References: <20250213195332.1464-3-thorsten.blum@linux.dev>
	<065b6317-8da8-42ec-8084-1a5058c0798a@acm.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Feb 2025 12:34:55 -0800
Bart Van Assche <bvanassche@acm.org> wrote:

> On 2/13/25 11:53 AM, Thorsten Blum wrote:
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 84d8de07b7ae..c7ebae24b09f 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -460,9 +460,8 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
> >   
> >   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> >   		return -EACCES;
> > -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> > -	strncpy(tmpbuf, buf, len);
> > -	tmpbuf[len] = '\0';
> > +	len = min(count + 1, sizeof(tmpbuf));
> > +	strscpy(tmpbuf, buf, len);
> >   	if (sscanf(tmpbuf, "%d", &status) != 1)
> >   		return -EINVAL;
> >   	h = shost_to_hba(shost);
> > @@ -484,9 +483,8 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
> >   
> >   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> >   		return -EACCES;
> > -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> > -	strncpy(tmpbuf, buf, len);
> > -	tmpbuf[len] = '\0';
> > +	len = min(count + 1, sizeof(tmpbuf));
> > +	strscpy(tmpbuf, buf, len);
> >   	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
> >   		return -EINVAL;
> >   	if (debug_level < 0)  
> 
> Something I should have noticed earlier: this code occurs inside sysfs
> write callbacks. The strings passed to sysfs write callbacks are
> 0-terminated. Hence, 'buf' can be passed directly to sscanf() and
> tmpbuf[] can be removed. From kernfs_fop_write_iter() in fs/kernfs.c:
> 
> 	buf[len] = '\0';	/* guarantee string termination */

You might also want to use one of the stroul() family rather than sscanf().

	David.

> 
> Thanks,
> 
> Bart.
> 

