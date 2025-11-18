Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A835CB9A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763475755; cv=none; b=IywcYdqKTbqwk0oE6iSBdqUeC6SRV5nHtJ1csdP9h8u2mZhh9LEExXjMn6Z/XBR50oS4aAYlLZz8nOErgMQHODXXhQHKWN0IgbHC8DjKNbm73qTlZl1zC8uDnDKgWL/OospQM0QuNkMok1c1+i2zyBij70wgBRhAxRkjY8f8ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763475755; c=relaxed/simple;
	bh=1bRekLSQbnogm9kiXDr6nxOYMXkbiP0m/W7fxXb9X9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roIzsMdt6v7ZdWBgGTn09sUCBkS8JLct7b6lcJDrow9zmw+bzw3cRX+xmeBY4a3fqsfvR/SzD4hG3Pqg59XDbiFMmnGuh3252ISxyvQ/wauR0gtytMuHLlEJ1zhGEevJ2hsCyi5KLrXFHJQ6Qc6RqXjw9FmLW0PF6Qxt2Zs3kv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bJHJveo6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bJHJveo6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so32689095e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 06:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763475752; x=1764080552; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cwc/mWNSnbrniQcgp/cxZONrsNTxrDETTJ3bIQ8HxWA=;
        b=bJHJveo60izp7ibOFPQDUyvsU4ksdUEyGVgClsnIjS2601Qcc0ro/rjGaQUekGK5WY
         Ln5x8aiffhIzAYCLQV03cKelmWu9FpfGJh+Fn7RxzPq6KPYH4OrcMzaUTS32MqAEDNwz
         HRMcJz6Y6rmGIy7wbStvkoN1uk9xDsxGwRuztieawuqpwEcaLPrQcV8z5pho/lmPU/Pz
         L2B5y9Nttcc2XHuq7RV6KgdJPdZVoQlVskWs9tMgqJ9ZaWyH1ye6Ydh1f1oSD6jKEElP
         734nt7GvtOk5088sdDh/uHnpmOTZcZ8Q8GFb5IlFiiQhH31p71Rh1WFV4xq7Yt1/zcYq
         du9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763475752; x=1764080552;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwc/mWNSnbrniQcgp/cxZONrsNTxrDETTJ3bIQ8HxWA=;
        b=VKoZVbzvAWMw4Wlv57jBGdRLUbAED5EJ3pa3FPN+7oWO2/ROXEYvznBLjz/1i3Zs4U
         yaxRNVXeE0irsIRc8MMwThje3V8Gjutgp8vbTYX6wjRQ5M4A9GcIJTd7dfzupLFtsOFp
         r5oeNbOXNeGiW7DRHN/B6T1YWFxQ3/YORQyNdGagWTZJYwvE24KsXNMyQDV3VYx5WSpE
         LmXjDsA7SNxDXEiYZXB7LIHf+7JzR+gUmZAg5sjR7j8UjYV+AU4pb5t2Dt88o0I3oZCJ
         TGTEiwbsMmlnfU5g9yUsOLnsGjGzVYmDI+5DU3vxXn7qYfYbl8LP06y5Sz9v+NB+N6Uv
         8v3A==
X-Forwarded-Encrypted: i=1; AJvYcCUp53a4gGan5+icvS+/2nxyVVLu4RJF/GEdvjT66zEKUiVOYvC4uv4KDruVisjweA78RekqJxjZdtAr@vger.kernel.org
X-Gm-Message-State: AOJu0YwIcYHp5FVaUNjQYd4XRg29NhSD/GEoyWONAaf+BImiE0emyCwd
	T51CEZth1Tgu/DUl8YanED75xhxKnIrfmlZ0IvDlbSDNt921fNRLOpRTRyLYaf44SOXSvg6qikh
	4RrAv
X-Gm-Gg: ASbGncurCQ8hTWH9qZw4BFcdLDXb8IjKxDBoYsH+56xBhVct2dzKcoEqDQrtWuOdV6k
	RrCheF5rE4rAtpSWzfyeinE0yeDy6UfmFE/i46jqIFObd8PKHvMK1Am6+7jtYZwXeMG36yePerC
	cWrvMyTeMsdXuTMAA4VK9ACeNS4xZb6kiKofJkDOJY34LjL/QjrOETMyz1t1C6YBtVE66zn+uIr
	F1kTh+JuxhLmvJa90i2GsrHukawpGq++IIURFHFerRsIADcPGsWFkc5vdBNYk699msFmd8b/ggB
	Or7ve31O+YUubIqIUaNlY1AZtW+dwcwF6gzDvSH4PsUMwCWz1WsepAal1RLX8hTcwrxyNuUl7Zd
	DyN8KvV+JYHhKsPDQ51g056hT1LPZoNWjl7dagfFFacZqj1P4feDyIPMjnEXrqVTG0edO7/QLwa
	jkPTotKb1+q0ZeFv6U
X-Google-Smtp-Source: AGHT+IGvnru/DiWDOXms3ALyf9g0cQrTBhkl8C4EuDcxo5HymP6Bpl6c2tIk/W3UDCJ8vjiRxsRFtA==
X-Received: by 2002:a05:600c:8b43:b0:477:561f:6fc8 with SMTP id 5b1f17b1804b1-4778fe50f6dmr160312705e9.5.1763475751966;
        Tue, 18 Nov 2025 06:22:31 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-477a9e0c802sm17414305e9.15.2025.11.18.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:22:31 -0800 (PST)
Date: Tue, 18 Nov 2025 17:22:27 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ally Heev <allyheev@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Message-ID: <aRyBI_j77mQaQxgT@stanley.mountain>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
 <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
 <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>
 <f7f26ae6-31d7-4793-8daa-331622460833@suswa.mountain>
 <bed8636bc4d036f4b2fe532e7bb4bb4b05c059fc.camel@HansenPartnership.com>
 <aRwPcgDXSE9s4jKS@stanley.mountain>
 <9c62ff497aa00bcdf213f579272d3decdd22ea34.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c62ff497aa00bcdf213f579272d3decdd22ea34.camel@HansenPartnership.com>

On Tue, Nov 18, 2025 at 08:21:16AM -0500, James Bottomley wrote:
> On Tue, 2025-11-18 at 09:17 +0300, Dan Carpenter wrote:
> > On Thu, Nov 06, 2025 at 11:06:29AM -0500, James Bottomley wrote:
> [...]
> > > However, why would we treat a __free variable any differently from
> > > one without the annotation?  The only difference is that a function
> > > gets called on it before exit, but as long as something can detect
> > > calling this on uninitialized variables their properties are
> > > definitely no different from non-__free variables so the can be
> > > treated exactly the same.
> > > 
> > > To revisit why we do this for non-__free variables: most people
> > > (although there are definitely languages where this isn't true and
> > > people who think we should follow this) think that having variables
> > > at the top of a function (or at least top of a code block) make the
> > > code easier to understand.  Additionally, keeping the variable
> > > uninitialized allows the compiler to detect any use before set
> > > scenarios, which can be somewhat helpful detecting code faults (I'm
> > > less persuaded by this, particularly given the number of false
> > > positive warnings we've seen that force us to add annotations,
> > > although this seems to be getting better).
> > > 
> > > So either we throw out the above for everything ... which I really
> > > wouldn't want, or we enforce it for *all* variables.
> > > 
> > 
> > Yeah.  You make a good point...
> > 
> > On the other hand, a bunch of maintainers are convinced that every
> > free variable should be initialized to a valid value at declaration
> > time and will reject patches which don't do that.
> 
> Which maintainers?

Here is an example where Krzysztof says "This is not recommended way of
using cleanup. You should declare it with constructor."
https://lore.kernel.org/all/a2fc02e2-d75a-43ed-8057-9b3860873ebb@kernel.org/

I know there are other people who feel this way as well but I can't
recall who.  It's in the documentation in include/linux/cleanup.h

 * Given that the "__free(...) = NULL" pattern for variables defined at
 * the top of the function poses this potential interdependency problem
 * the recommendation is to always define and assign variables in one
 * statement and not group variable definitions at the top of the
 * function when __free() is used.

regards,
dan carpenter
