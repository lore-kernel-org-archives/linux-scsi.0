Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732E52E612F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440419; cv=none; b=bbKCg+jaUAbb0cX/Ey2mjWjN0TRdn+I8fAOwuDR7Qhgcut1ol4fmPT33h4FpRgiEsXY9tobe9gEYV8xa+R4RLpSjMs1/z+HVwdV0gtGPVktCd0o939Zl4Rk2qzHBVMQbrzIOhwLCYZV6qX0C9JeV+Z9B3lHDo0pP6Dprmtbqa8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440419; c=relaxed/simple;
	bh=DZ1XWRZMG/rus3+GxD8gyTLsrgLZ8TB4RSOF8k7/V+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j06bGPVRrd+uaYlaqmwkg2eXCQ6ZsIFp4nR7uFNV6E41R+lvjKzGbkp7pvG/ihg8GzOLZIHvz8ezwTBs1FnsTJAq0dTQxLurTPVeum324lZdoXjyaQyA05R54AMj3lAVaq9AxY5UF8eEk9QSX7XBr4+cChMBWscTxx4Jiju/P9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nDJCPqvF; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nDJCPqvF"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b72134a5125so95992466b.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 06:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762440416; x=1763045216; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HduGiVleo4x3CODKWMmmltGT7D7OCw+rAdg6aPlkN5E=;
        b=nDJCPqvFJW+LdeRgWtXwv/hBDf/B/acffR+qhA2mQknXIOLeoJitI/HkAmd/pZiCik
         tETNeEZFPKkiiuwQz6TUrFvSVkVhk1L7V5/iw0MqT7ZdXA/z6aU6RNhJRElOQnvukiYV
         OPEa+jypANZTI9P/aY0rZFpzaI/OcjTgBs15IHS7fn8sj+oNDb0Dws8Ls/7t+O5iTQbb
         R6Rn7uR4B2n73uBQcHPMaG3B8pRRJ9llDTSs+Tf9rFkpMe/1Kyha0Tl5/PmD+mdxumWG
         CBdbCCW+9Xvq0PSHRIzw1OKe5kJUqUWZpjSZK5iFIEdGBgJ4lvZjPUOInDIzJdx8634T
         jQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440416; x=1763045216;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HduGiVleo4x3CODKWMmmltGT7D7OCw+rAdg6aPlkN5E=;
        b=NohCK98bcjJcZoHT0c+iPBorTNug2ZzEWGHr84542byiNQDJsrZAXoIdQ3BMwojs+N
         z/5AoMaglWGrdx7OyJgq72/iUyaXl1UdufOcxp3jAQB8XIjoEvnfTaEMTfYJ9sXtboc2
         l96IceI78HU2YN08RdkPzW0jHdMseqdBadaABEv98vm60XsT7d+N8Zp1bmcT/H4BX60r
         0orlrjNB/WcDoT4I4iYYWP5a7af7tUr0H4T9PNfE2hdUgPUagBMP8HMZPWjVCdBhkwZn
         tYqZbVmLjTHy9WRn3tKOYVZTwwJWJZNt4G7mgdzPRVam6gznh9BpByuMjColHMuWx1iI
         Xyig==
X-Forwarded-Encrypted: i=1; AJvYcCXFb81zp6CC8cOiQw3l3AEXuKWgQvQVZslEC3vfhNudPjcyvZvOcOIbSuJCYmU/kBi9xAWLAL3Jb0bz@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+to7vIGUCEIXiHx2mS5dHWN5mJBm/51l2Z2njSxAlf6xfFfeB
	WQKDGB+4XmO4X5IqwFqD7tsdyklr9pReHDmWoSu7f8FZDIDGepHJfc+sD1uh4cD2GaY=
X-Gm-Gg: ASbGncszVgzXw9oL5M2uO/VZS1HMwmopzj1Ahm1egnvBGLgfjCrHE3pXrescYE/ALot
	7qfGdT5INGjuiZKgeBQOYWkEgVov1SKKd2f73sgaDVZYLufBSqsG4peFO5u3TmUojmnyiMaDtWz
	SQ1GKzDgTRWEMyHDXZmqiX9V/qe6JJWzW75C2rd4baAi+aPRDB/+BskyhmGw9TkYJQKon4wo4uw
	ctTWeBkAiPAxOSc9cyAqSJB0yQr3giSiYUAbhl3RL43onyXf1FegXdP8FXF2J3uJ8+3uRQGNxb8
	2dSZG3J0q9joAjiD/J1UJwpe4JEQlTftwCboBJ8Yxjl7BGgTuF+XYZcK/mbwlzf98SvZQkufwa2
	Tr7NFCPPJhwaUgr2Jk3l2MFO3RTkKBSkbix/pdS6+zekdOgvftsn+ynHTFBb0lhazJqTaqEk6TZ
	MzumsHR/V79Nl4rk5/DAoLKFE=
X-Google-Smtp-Source: AGHT+IGw86hMYPFdWOfs9zaI9D4V+iRGEIxPznCLyxNtZbZMWrDmTzsSFfcLKNbOfZ7cLvXixIL/BQ==
X-Received: by 2002:a17:906:794c:b0:b6d:2edf:ac5d with SMTP id a640c23a62f3a-b72655a269fmr751504566b.51.1762440415808;
        Thu, 06 Nov 2025 06:46:55 -0800 (PST)
Received: from localhost ([87.213.113.147])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b729d359360sm133796266b.37.2025.11.06.06.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 06:46:55 -0800 (PST)
Date: Thu, 6 Nov 2025 17:46:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ally Heev <allyheev@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Message-ID: <f7f26ae6-31d7-4793-8daa-331622460833@suswa.mountain>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
 <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
 <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>

On Wed, Nov 05, 2025 at 10:32:19AM -0500, James Bottomley wrote:
> > > > diff --git a/drivers/scsi/scsi_debug.c
> > > > b/drivers/scsi/scsi_debug.c
> > > > index
> > > > b2ab97be5db3d43d5a5647968623b8db72448379..89b36d65926bdd15c0ae93a
> > > > 6bd2
> > > > ea968e25c0e74 100644
> > > > --- a/drivers/scsi/scsi_debug.c
> > > > +++ b/drivers/scsi/scsi_debug.c
> > > > @@ -2961,11 +2961,11 @@ static int resp_mode_sense(struct
> > > > scsi_cmnd
> > > > *scp,
> > > >  	int target_dev_id;
> > > >  	int target = scp->device->id;
> > > >  	unsigned char *ap;
> > > > -	unsigned char *arr __free(kfree);
> > > >  	unsigned char *cmd = scp->cmnd;
> > > >  	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
> > > >  
> > > > -	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > > > +	unsigned char *arr __free(kfree) =
> > > > kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > > > +
> > > 
> > > Moving variable assignments inside code makes it way harder to
> > > read. Given that compilers will eventually detect if we do a return
> > > before initialization, can't you have smatch do the same rather
> > > than trying to force something like this?
> > 
> > This isn't a Smatch thing, it's a change to checkpatch.
> > 
> > (Smatch does work as you describe).
> 
> So why are we bothering with something like this in checkpatch if we
> can detect the true problem condition and we expect compilers to catch
> up?  Encouraging people to write code like the above isn't in anyone's
> best interest.

Initializing __free variables has been considered best practice for a
long time.  Reviewers often will complain even if it doesn't cause a
bug.

regards,
dan carpenter

