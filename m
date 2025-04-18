Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC7E8C0E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 00:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744934965; cv=none; b=X4WIFMoz15uBexO10Ua4XDHeZdjezDui48yXJYms7S/RQBXgNfZz4fvv4PQeYdpHSPIQCDnpNq7kcO/fXXmjV0QUuk2xo2sIUvE4kKzhkaudbC1qNTAlF6OXTuHtvBTdXg/deIYeSLqRx8QVJkTXFggUHZQSKj8ySsLlpDV0kdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744934965; c=relaxed/simple;
	bh=1iz9cSuAyLptqR95CHj47SCbPvg7Ohoe4JgNu+5U5qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZl6rTY1AD/x2Q6ytcrPniy9pOgDggDHCAkuCwhdzOp7R4v/ukTMDnG4Ykkkf49LaTlrWzfuF4FhyvPN/iJ+R0kIao+okQFcl+WeeP7MdZvyrwE4GwAHotKb4PIAh67477lXfpbAFIiP6pTKuo9pjauqjczmW1JO4DMMOiiRfMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4nBXufVf; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4nBXufVf"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2263428c8baso92515ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 17:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744934964; x=1745539764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRMQb6QKHkmqTIiBM1Dt1HJPQdB2qTTEuCJ+2vuCv5Q=;
        b=4nBXufVf16edin5u70QmZSswWZ1rgDhrUDhZGk019WxD0uvUoGpsYxZCjShvxvvZ8Z
         wRrS6Ko7VwGi7BwfSWhPDAE3VqFqDCiuOgDWPTwXGIc+QqEJdPw5wo1HQ7+1AELo8oeK
         5Q2fDOn+uSa2w+Mc9xkDLEsGza2upiyMQ4u9lScELHegeCMZlHP3lZiW12f3hjdFx9+D
         ubatEaYfG03qO+Ayfg7IalyI+bvxA7AAFzC3j6r6Epjp8XhHJWC5pFzk/2RTjRN5LCJT
         c9lF+CK3LW+amvrweyONSkeFNIi6nabWIHEIf2DWXph4jtixkvDQs1rcjAnNTgw4hx2b
         9Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744934964; x=1745539764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRMQb6QKHkmqTIiBM1Dt1HJPQdB2qTTEuCJ+2vuCv5Q=;
        b=pRup/XeHyOJV3sdINjCCQh/DPUVpOT5FHuQ+CLHRrHPqAJ+6v3xrHfKB+f0p8M+lJg
         6BKt239+oGuH1nf4mgZLHTMOcUOWhd/Sqndvr87vIY4SCoFw7G3MDvir/5ptdlYG7G/O
         ofH4+AY6bJfJlFyXtxKlhtrlTzlSjYjUQ7OjSCkLy/qXKMZAF57S0uSM0dU3Amzn/CG6
         tXcsy4btJtr4sw0GrY+r4iSRmAo7gYLAt9L11ggZSw8wOETHzcVkdLB+6acHWG+g8XJA
         adtv8SnT11PavylBPdOKuu7RFznU0gtZVclRkUP61KfYnMTh9CoJFGk3bBCfI/y55ABV
         FQIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdwo1kCkDKotMeKojhppD+h3DmW6WNQKWfuLB3U/ljtAbd6qCk0uTmI+R+Bp9x+vfnmmQ1ni+33Eq9@vger.kernel.org
X-Gm-Message-State: AOJu0YxsQwkLrsYulIDyUYc0dYbNZhIfTdqeAvfa9QRK5/gIJRCsrRoS
	ei7npwIIps/cpTXbbdKBrhoIJqCKHKNtR6cYmkMUC7urW9E/AjdKp72B0I6ApQ==
X-Gm-Gg: ASbGncsPwCM9+gMHt9bZNfePvu27VW3zchF0SyhkHm5DzrQ7bZPnSE3flqmcswhvgyi
	h7M8UjHoX7yV8cyG+Y6KEscicVwMjFwMSVa4QJ6j7ssiGrPUvVI+nqcTVpQ1oCC4gAEaTvj+2Vu
	va2BLnnVXDYsOxTOX+uWOCEGmJGrZ4zj7Yivr2725jXlxvYw3C63lNeXiDCsRm8RqJaNaRolmAx
	FxSi39VTCmWa4xSBUtemPdgMeAWM8rAsEhBv4TkqWl73LYjBB0Agtb1OLIewGnhfE8g7D2v+0gU
	Lut67zjW/i2xIs0QKT6B/puVi+PJKtKq3O/npUnU1qKI35duAojD+S7W8fUccXxu8MqThwbomSQ
	u
X-Google-Smtp-Source: AGHT+IH/FUWHONJ58qRBe5zN9276vPde2PtlCDbwdodDOO1MF6EJkjcY5EVoILQbbQDQgKGBVq1tRw==
X-Received: by 2002:a17:902:f603:b0:229:1de5:e8c9 with SMTP id d9443c01a7336-22c54560238mr794325ad.13.1744934963329;
        Thu, 17 Apr 2025 17:09:23 -0700 (PDT)
Received: from google.com (24.21.230.35.bc.googleusercontent.com. [35.230.21.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bf5230sm6236225ad.73.2025.04.17.17.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 17:09:22 -0700 (PDT)
Date: Thu, 17 Apr 2025 17:09:18 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: Improve CDL control
Message-ID: <aAGYLkwoeMJI1s1Q@google.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-4-dlemoal@kernel.org>
 <aAB3iU7ZuQo5cH9z@google.com>
 <3c8f7e2a-ba73-4943-8372-0f322aaa3935@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c8f7e2a-ba73-4943-8372-0f322aaa3935@kernel.org>

On Thu, Apr 17, 2025 at 08:08:00PM +0900, Damien Le Moal wrote:
> On 4/17/25 12:37, Igor Pylypiv wrote:
> > On Wed, Apr 16, 2025 at 05:42:38PM +0900, Damien Le Moal wrote:
> >> With ATA devices supporting the CDL feature, using CDL requires that the
> >> feature be enabled with a SET FEATURES command. This command is issued
> >> as the translated command for the MODE SELECT command issued by
> >> scsi_cdl_enable() when the user enables CDL through the device
> >> cdl_enable sysfs attribute.
> >>
> >> However, the implementation of scsi_cdl_enable() always issues a MODE
> >> SELECT command for ATA devices when the enable argument is true, even if
> >> CDL is already enabled on the device. While this does not cause any
> >> issue with using CDL descriptors with read/write commands (the CDL
> >> feature will be enabled on the drive), issuing the MODE SELECT command
> >> even when the device CDL feature is already enabled will cause a reset
> >> of the ATA device CDL statistics log page (as defined in ACS, any CDL
> >> enable action must reset the device statistics).
> >>
> >> Avoid this needless actions (and the implied statistics log page reset)
> >> by modifying scsi_cdl_enable() to issue the MODE SELECT command to
> >> enable CDL if and only if CDL is not reported as already enabled on the
> >> device.
> > 
> > Hi Damien,
> > 
> > What happens when a drive spins up with CDL enabled? Last year you sent
> > a patch to make sure that CDL gets disabled by default. Is that still
> > the case?
> 
> Yes, that is unchanged so that we keep being consistent with the fact that the
> scsi layer starts with the sysfs cdl_enabled attribute set to false. So if an
> ATA device starts with CDL enabled, it will be disabled.
> 
> That does not cause any issue with the CDL statistics log page because that page
> is not persistent and cleared) on power-on-reset events and this change has no
> effect on that. The CDL statistics log page will always be cleared on boot/reboot.
> 

Sounds good. Thank you for confirming, Damien!

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

> 
> -- 
> Damien Le Moal
> Western Digital Research
