Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9BB440A14;
	Wed, 22 Jul 2026 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735706; cv=none; b=jL5HEOLh10pUSg/klkUm2O4XEmAifFBxDb0Bb7Q1jh6cuA0ylSRiyz+Cmvq/6weg0eIDHAXSFwAm5meB4xQpVB7R28pr/TqUDb1Yv3IXW0oo4eRi7SEE/3gNh2QInZCTj+rmjJTsVM1EfPXKCET43iqBufv45hRTwvg66ajpuJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735706; c=relaxed/simple;
	bh=YPKhwWO802/GmIbTLQGnSCOFY+Uc1vnrgsuJrxJTi3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebmaFT2TCsW4EnY5rQfJWZeARRshptbbCxvV23J+6sCUjASwcVxfep+WNjH/+iIXZYZBcANTjN5L/ftOJyOj8UFDcowXaMtRSWcP58MRROD9j+puu20jf1jSQSd6gurPXjprw1XNjB5gfr3co1R6KSwaADNUYicgoi483nCCeNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6yCtvDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6yCtvDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCE1F000E9;
	Wed, 22 Jul 2026 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735703;
	bh=iXDTj3woG/NllBahyAcs2WE6waBesyddMI6X4UkYOsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c6yCtvDn/Oavoqi+HS1NzSkYKdbS2Af+cI7Ll3ssd2AP/5OtfwvE7RcjzT/8SVtzm
	 bzmtrrJ/6rnGRWnI6SxGogMRpWoMSRTw/UzchNLo7JIRpDiYh555mZtMceYly1vKgC
	 OTFjHoFwv5ZEWfdn82uUkgmxijxSg74KeEk+1yQf4oqB6y576X8Ba6EYKHs6bLi3Ks
	 Xmh/njyuyrfo5z3ezhKKOcreQuyBbZeknTIew0BylOtZYgoEQgu+f2e1/34uVV8ImE
	 2IXkM7qvO4OVR+5j0etADet+YqkU34CXr9hrcIcPW74YpZXBpFdaKM5stQYOFR9ChF
	 f8JsvtZj4+ARw==
Date: Wed, 22 Jul 2026 12:54:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <amDn0zh-fsrlGLoD@x1>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
 <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
 <2026072224-moisture-gonad-409f@gregkh>
 <f2eb5423-b5e8-4b8a-9d28-974dc0eef892@roeck-us.net>
 <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>

On Wed, Jul 22, 2026 at 11:10:45AM -0400, James Bottomley wrote:
> On Wed, 2026-07-22 at 06:43 -0700, Guenter Roeck wrote:
> [...]
> > For Sashiko, fork and clone
> > https://github.com/sashiko-dev/sashiko.git,
> > submit your changes into the clone, and send a pull request. Or at
> > least that is how I do it.

> > In the Sashiko source, per-subsystem prompts are located in directory
> > third_party/prompts/kernel/subsystem.

> OK, now I'm confused.  I thought

> https://github.com/masoncl/review-prompts

> was the source of truth for this, but that project seems to have been
> copied into sashiko rather than pulled in as a module.  If you want to
> improve the review prompts do you now have to submit to both (which is
> getting to be a bit wasteful)?

My experience is you submit to Chris's and it eventually gets pulled
into Roman's:

June 12
prompts: sync recent changes from review-prompts
https://github.com/sashiko-dev/sashiko/commit/07223d03b2657d809156b46c0b980725184f81e8

But from what I saw while searching for the above commit there are
updates to prompts in sashiko, not going first thru review-prompts.

- Arnaldo
