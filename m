Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8570A332635
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 16:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781196000; cv=none; b=t1w3+rbvkDepZT3J5GsU9MlnceEzh1x1isA9BIW46pADo5iyTN5pLCrD3FJ1Bgw5WisnwCzPK8Xnj7Au3tSiZgBbbN1gd5BGVY43L2ZTmJXDIYWcntuzwx1ohvhLWDaAmeYwQyCLUOb9K0kHOYtXeg0/ZH3UvArg3Hz0plodduk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781196000; c=relaxed/simple;
	bh=2a9cuN712vVqrsGbJylXLw3RxwasxEHAXA5P2t2Zs2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5qyd9EJm75RR7ScJBoODsdTmc3HLdO797Vdz0VkLaXgMKVB5ydhDnoiG2hIwDx/hEeP+BGmZO2rXhZQ+2kdU7lO+Y+Ka+Qtfbjo5u94ntMiv1tR+vW6Ct+SUHrc/Ty9HsOKe5XFU+jJDAGwuS0v7oDsA+fDW/GqusgazgOaR3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7M2rIvJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7M2rIvJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b9318997so60710605e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 09:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781195998; x=1781800798; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=siXDPwMtJVGXiYb4vYM49WpVCt548BrdN6XowbmkPpY=;
        b=D7M2rIvJs2/rDqfgU9gYhfnJ3uWHThsn+nWqnyrBZxuPCeSyhLsF/AFk97I5nwDial
         rYxtHhLgShrUxGYqMlm43YOpF45jGUCgG//C07rzsSpuTVjSKyd5roNsq1LUG59pylHQ
         KZlC41plM4B9GaHTxNsmTwL4/mTyzX4iSSyNnsh0YtK4ANshplyHOQVNq+jLSFcjydL/
         2Pt0j816rKfUc5UKc8sOPup/o9yXVacm0dD6R0ubGSx9SgWqMXO4g6kTxS0zHyfW/hQi
         wTYqGvEHTL8QPZHMQ74MzRuhTTBwd1RPLjJuOWqzhrARtXXEbzHo0cyPdgvsI4z6yNmB
         XKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781195998; x=1781800798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siXDPwMtJVGXiYb4vYM49WpVCt548BrdN6XowbmkPpY=;
        b=qaFZsb0ZLUBMJaf29vdW8uB+WqP/ZDPYCc+lNQ+ShO149KboWqH4ru8vzBqnlY/JnO
         UA5NXmihGBPkjCnWAJqE48L+OTRtUVi1t6ZzJ2n5KQfRSzLBfl+/MHAgVnZvcjhfJTJw
         rDJxDa4t4uF0W7QK5XYPArNpUqM+NmcOtCjXeOWjHKYhhPBkLlADXXYZOstG2s64nGk0
         orX+8DGeM2HjyWolv85DIf4vDsDSeop+8gjvlNjo6mSgTrZ1+pjwyUeTwxudrLMFoETr
         Cw4L0emIKx/irzYfs1zghgrI1rd7V/9W/TeJL00KDpEd5KlgJ4eBvIbHWJRfX0oXeFWC
         UyTQ==
X-Forwarded-Encrypted: i=1; AFNElJ9peq5mgSfCqi4Qa9jYIdKakSjejwTVNpzzg/VqdT9I1bYt1bWCYuz3melyYPlLa8Zv30qiTxLnmvBQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyDDkTthDH+WgoOmA0Dfe5atF+x2P4fwebTAu0lcBAM6TjDveeE
	Phbn6XCHkxXeYnyNrru8xy6K0Xr7HzDZmOVIrmjNtbhjqcGuObzAlG4q
X-Gm-Gg: Acq92OG7ES8GutD7PzjDuQ/5bPPaS5JfLOA5FShbtDxjNfWl+XoExEqOs4+BzJtxID6
	3AK8P1wI+de97+gN3MFyfPjN78cVd9Jle2J1mrglICHOLRwzoRt1d3OC++ZwPIC//12fYGrPjKD
	/pna1SsAPRg41G88Tab23wK1oUuxSVNqkgqAkeNiZsaii1weHqa1lKY8OBqFZVKr4xvjY0UMJMr
	tflz5jkB2ilyR5jXgBLTq25+a2Fo71EcQw7u/nBGhDyw7y5S+wi7FSEuDMJlvxZY2aQ4rSPjlmv
	5+HKDxrrugMxR980Pfnau5H0cdonzAUcyvz4ZGTs63FI1Dbkptq0MoKNIMGLUOIwUugy/X0FiSO
	l3aGNDL12/GO5QLeHHbh306TTjnYc3C5Cgdz2mSiOJi+Frg8qgeMqLqoTmkOroXDmuLF7VtPvx+
	dV85SRdXY=
X-Received: by 2002:a05:600c:6994:b0:490:b724:5085 with SMTP id 5b1f17b1804b1-490e5619ae2mr49924405e9.33.1781195997918;
        Thu, 11 Jun 2026 09:39:57 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c907ddsm76572415e9.6.2026.06.11.09.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:39:57 -0700 (PDT)
Date: Thu, 11 Jun 2026 18:39:56 +0200
From: Louis Sautier <sautier.louis@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
Message-ID: <airk3Os03wPV0rvW@localhost>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93542109-2101-4d62-aae4-bbf058029663@kernel.org>

On Wed, 10 Jun 2026 08:22:22 +0800, Damien Le Moal wrote:
> > +config SCSI_MPT3SAS_HWMON
> > +	bool "LSI MPT Fusion SAS hwmon support"
> > +	depends on SCSI_MPT3SAS && HWMON
> > +	depends on !(SCSI_MPT3SAS=y && HWMON=m)
> > +	help
> > +	Say Y here to expose the IOC and board temperature sensors of
> > +	LSI / Broadcom SAS HBAs (such as the 9300, 9400, and 9500 series)
> > +	through hwmon.
> 
> Why do you need this ?

I was following the logic used by NVME_HWMON to prevent issues with
SCSI_MPT3SAS=y and HWMON=m.

> > +	struct mpt3sas_hwmon *hwmon;
> 
> This should be conditionally defined with "#ifdef CONFIG_HWMON". Then you can
> simply drop the config entry you added.

If I dropped SCSI_MPT3SAS_HWMON, I would use
"#if IS_REACHABLE(CONFIG_HWMON)" to match what i915_hwmon.h and
xe_hwmon.h do and properly handle the SCSI_MPT3SAS=y and HWMON=m case.
What do you think?

> > +static int
> 
> Again... Not going to comment on the others.

Noted, I will fix all of them in v4.
