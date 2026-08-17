Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62B9353A63
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 22:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787007540; cv=pass; b=M2AacpW6UqQ5Ucd/V7tRgiT+b9zdxmnU1nnabOZZjGplFBE+wdk+JcoJ2bcG4ESHlnfXfIuYwtPyNDOb6u16mnNaQlyNuMFfngJUF0UL3dU1ZVxWiwuPPVxkMPe9iF2oraIppJwg/yX6O7WKX9dfGHJDPTznad/g3WFxAeaQURY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787007540; c=relaxed/simple;
	bh=mbqS/mAU1bR2Kxs9F24hgnXZe/yIjrw6IATOoVHj7qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUiOWQCVzWbYmCiR7lsLrvDPrFGDMz9aQ+2EGcX+td8lGi5KAVrsRsFKVIL3tzbd3TpLmH5DR0vP6wL1zXmWqvZpkPaHCG3CkrGPlZIqQjSmzCUpfMnOSxgrUUahAWxao/uYF9tZK5qHu7Nc8YHEORY/myDnBxCqcFd8TughQkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dDmPhysb; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDmPhysb"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so3396543a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 15:58:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787007538; cv=none;
        d=google.com; s=arc-20260327;
        b=D1rIuEOWvLoufJUsRd/8rZJHgr8IqJiT2BZkKGIIdFP36bLkqvWhaNVkf1IwTXKWtz
         KcA+j+EfXrR3qL2Yapb5xkCOdCMAjqZHHTx7rmx6VgbNhHx2d7gV+uKt3r2VVHS/YR/L
         5nep06rgOTpoOHxBA3p1fVZrrL3BtJKFaD+qWWJ9YFayC0Y/yJFCW/eTo88HA/NeP1Bb
         +DChK+ZJtIMgZ/tA+ySILkaK2/93j+GqRq7N/EG4SEcr67Mr4Uokjp8hKNpM1g0qrn6W
         UOHNFR8oEfL/SuEdt6SdmBvcykjV3syGMTD7rmhn0AxijTN3Yd9lJnipBcs4x/GYHbSn
         3zdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mbqS/mAU1bR2Kxs9F24hgnXZe/yIjrw6IATOoVHj7qo=;
        fh=K44nSVQ3wxJtTiOMRVSq7ozqNXz6JoAVQ8obUqnYZAw=;
        b=L2JyT3MWegmfFNHU1Sga0cM2BQF9wJfK3Sk1YT0nq9adwNvHIhxAkdi+P4EH4/KjhJ
         sYMe1OL30tnUdKjh11hH9hnaysbFey030aMJITuHxr15jhlBkdOwJ3mjz3J3ssiIQxBs
         ORWlL29nVGewmytnhGO29cLzPFyYRITrthcDLXrTt9zTv6l8Ig4HpBPRdFWUZCjOpwHB
         A8e67ncXvPM3Ih71zHqcONDsIen6dintoZZWYrTRYZnNJbuwJatVBgEfi38GxOqRzCcY
         0i7aLVJi7woGMbU4pWSLlb5jzgVr3joYkHc+bO+t+8+5vXuZnyCojgYylsKB864npD4L
         wWVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787007538; x=1787612338; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbqS/mAU1bR2Kxs9F24hgnXZe/yIjrw6IATOoVHj7qo=;
        b=dDmPhysbF6GykK54o8NbjnPObJy+SAPjPoGmH08cW43oHy5WvFCGBwvLguEQMfBx37
         nZ+ZldU3Cen+G0WIRxCobqt7UPUAIm4sXEr2FkANijsqcByGhv28rGFA+dIWQOBEXftz
         Mh6suoBMv6fvM2b3fAClJN1TkIiqV89toi3/dR/RKW2QHFiwuMzZZzQUgVeI5SR0g8CH
         UeYOhMcDxbthSVyyTTtCdjpaWtJZxjvpFyTRdbcUgf46A49j06oigy+06xSI78M+2OcO
         QPwy4c/3vdWh6ZuKoDOpEN7YMN2M0RultpfPE/W929UIkNUfrYGnx82eQGest5uvpf4z
         0dOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787007538; x=1787612338;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mbqS/mAU1bR2Kxs9F24hgnXZe/yIjrw6IATOoVHj7qo=;
        b=PKnSavBjYZ1FgMgtPRNdoJZCvK4tUUAcRk+uWwTw8icLUPJbtzlq5l+4uqLHfYL4Jf
         tCVOkgzikq+8anNCZ9lIkebNaf5ZpbPgsf00N40qiwFgHRqy/qdys6wgn0WRAT7TNQ7U
         18nsjwm8xCqFjZATL6VdpBaHAQpos79jQUCdq60vQGWX3VMXCDpCOKbgix5IEZWSr2F5
         E5ykPIPuJdN6sFBMu/ZOVITUe3X5UMxBlCdLB/z+C5xoYStdwVlOvNbK8qsW8sui1VaJ
         ppll4FmB5MWGuEZ3+JAi4RhrF1TfqlcwYaQTniFzRiLKdaWTrdnbvMZis+l6HXmcWz+R
         AWGA==
X-Forwarded-Encrypted: i=1; AHgh+RrIm6yl/qSutsr0OCe+WDNOqFsp23FCunnfvw2MyXcBw+AHx58kFON+MDO7ErUE3QxMw5ekLYwPA8Ln@vger.kernel.org
X-Gm-Message-State: AOJu0YyJamm1UJoJOrXuJj41raxkOEeCLnO/ka1PcoRdQSXJ+NuTlsbx
	FHyKksZXYBGZbDn60y1QdTUERCVYVUN0yZmD1m1WYwiqQI5BmI+KHsry0+jBH/h04XLAwV3Vptn
	e8aCRfl/KZqvlc3KM+uOghNQ7tE6QIIeXzWNjGDSt
X-Gm-Gg: AR+sD10rMwVuGvMGL3BTp58oVE1YK5wJW5JmA+V822H5bwyFGyNoqvss575fgFWqyeO
	6NiCYjeWinSNjyhCoAfqnh84h0RQYbB+XwqgvsVkoIP4G6kcSsFz7P6TEjNASWf/NYr+446mgje
	hU27PtZmgZH/ZmxqkenTOB3him6W9oy/pWFkvEIAMGaAU8/Qh8Lbg5Mr4qazaGT+E+1YhEinKyy
	eOaEZ3X0TC/45hschtOltthaIme4Yq8xBgOYOA6wkm5Gcaf+F7xkelYgmy2UQ1/SrQJYGE4Fc5r
	VXja4ZWsRRwuB2n+l9v4My2tad13xXgla3oWyaPzdfVZ+tS8ZyKphLp08qzJW4hoCEIfOtcA5aO
	XNlqXXzHYAHk=
X-Received: by 2002:a17:90b:2891:b0:38e:7168:281 with SMTP id
 98e67ed59e1d1-3933b916f3fmr27812839a91.10.1787007537680; Mon, 17 Aug 2026
 15:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786142946.git.bvanassche@acm.org> <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
 <3731591a-f495-488a-bbe6-96f4ec2acb78@oracle.com> <f91c7df9-3534-4ec8-a6b6-417577bc22ad@acm.org>
In-Reply-To: <f91c7df9-3534-4ec8-a6b6-417577bc22ad@acm.org>
From: Marco Elver <elver@google.com>
Date: Tue, 18 Aug 2026 00:58:20 +0200
X-Gm-Features: AcwNN1WubrHfcMBFmwLwWirJqMnbdkYXSqvm0wD01Sr0p_pWxy8gudrhD6zp8Og
Message-ID: <CANpmjNPkMtx4GGvU9iQzOLp2wa850Hxx1FHeMQr04SrfEYzESA@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Jianzhou Zhao <luckd0g@163.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Dongdong Hao <doubled@leap-io-kernel.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Aug 2026 at 17:41, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/14/26 7:59 AM, John Garry wrote:
> > with my changes in https://lore.kernel.org/linux-scsi/
> > yq15x1dtp3r.fsf@mail.kernel.org/T/
> > #m064c12513575565cc08afa15738215b98bcca142 on top of this series, I
> > notice that the following 2x forms of annotation are compliant for the
> > context analysis checking:
> >
> > __must_hold(shost->host_lock)
> > __must_hold(&shost->host_lock)
>
> This is consistent with my observations - it seems like Clang accepts
> both forms. Marco, do you perhaps know whether this is a bug or a
> feature? I couldn't find the answer to this question in
> https://clang.llvm.org/docs/ThreadSafetyAnalysis.html.

Both forms are accepted by design: annotations model abstract
capability identity rather than runtime memory access, so Clang
uniquely identifies the underlying lock either way (internally, & and
* are treated as no-ops when building capability expressions).

Since [1], the one case where in C the & was required was also fixed
and both forms work for pointer-to-member annotations.

[1] https://github.com/llvm/llvm-project/pull/194457

But I've stuck to using pointers in annotations: kernel locking APIs
always operate on pointers (e.g. spin_lock(&lock)), and sticking to
the pointer-to-lock form in annotations is consistent with that. But
nothing enforces that, so it's more of a style and readability
question.
