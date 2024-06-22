Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F254A0F
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 01:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719021427; cv=none; b=oXsIuhIRULJRDrjMh3HirCyWvUmkC0Aspof6s45OD0RWjSCieSRTRTJI1FaT6hcwpJO4qSw2oMy+N6aVzb6MfgadVsD+TvrBekUsklYf0FoEnQbskAAeTwM8Z5AttIkeKTukc9mmFB9ztW83kilNGh8xJgpHtxkVJRESs/unAuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719021427; c=relaxed/simple;
	bh=8zqEXze3fEHr+zCqxux/Dy6aUVh/dIgDy21TaXzMbTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jc2jw2THzNPsvwQc88ZYlZ81zq0CUv7MjLyL6bhswcaIjsxwOP4Fhcfu1CPDulI+SlO41Nl5r6wUs6gRmAvTS1EiNKy1zVo2T11Qzxnw2k0GH39ReRWLAt0LD+K+kY31pHU0I0k9wNidEtQQRqnLivw52N+uFY020V++YFBd9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKyxwey8; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKyxwey8"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebe6495aedso25955441fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 18:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1719021423; x=1719626223; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wKHMfbyDfNXzhbJefDVMkuCyrSXAHynzAEUW3BjE6BE=;
        b=TKyxwey8zwvJey3oinz8ysJoZLoPEWiXH+mZ2gIXmHGtPcEb7PQns/q5NKt9Br+Fxn
         1Z6sEonepPK0b3tJIUdOXHREMv6iDtqE8CtalOVyDw2yb5ylIqIYd33JZozH0xda4qan
         xzWJSyN0DxJvZdnrxxAmAyfGH5EytLKKrn2g8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719021424; x=1719626224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKHMfbyDfNXzhbJefDVMkuCyrSXAHynzAEUW3BjE6BE=;
        b=wpDebV7coYnbsacXcnwCDuTkM7En04lb7X4GNDdOsFI+pjgydTnC4GoHVnlRcqlIgx
         f1U5fWKdmIGctB6luwvy5neS/YI9JmaMwXuGsSWYWjYBfb0IOE5YC3uvDBCwCWAjoEOP
         4UbauQ2b2nVDgyeNt5XEXTeBURk0xIMDBAsQEb2RjQLosuKHWxjzxnWEYs6iS+s+aU6N
         zKFVJw+0EMLjPUn5X/ZpdZHI/spzNkG56FXTl2XIyge2PQ+I+Y+KzC26lAnCIENmNP5I
         DW+YcESXxF7ygEUjZCsjpdFj03a5m6byhVK0QvBJQxNQhlN1x7dsvFoaTxzU5mDmRcTK
         mEmA==
X-Forwarded-Encrypted: i=1; AJvYcCVY/+csGlOGDk6R/yuh9KCHO146ChVJmrZd7VF+5/g45dcI6ZCzZ14+t4ZOEiiDq7Hw5bIggp6eRYDup1tSUBb2Tpudcx3XTCvPxg==
X-Gm-Message-State: AOJu0YyX6oJfJ3g6XXCxWOpHG69G7hu6uv74VjHDqDuexw1DuT7QCHN+
	R2dBGuWUP3F27QNZU+tMKqKM4YNMfal3LXyIyBkG8A6JVAtIHUWCdoEZvJ5XzMjWfh7letHkPOH
	r7EnhlA==
X-Google-Smtp-Source: AGHT+IHAi2wo2S4LbxDTxXoiGtkKafB2l7z0qfloWKH+JhVImYCnHkyTm44hBCKC+opVOr/B3ZbC9g==
X-Received: by 2002:a05:6512:3457:b0:52c:deb8:e57c with SMTP id 2adb3069b0e04-52cdeb8e5c0mr131427e87.49.1719021423396;
        Fri, 21 Jun 2024 18:57:03 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cd63b4966sm363098e87.9.2024.06.21.18.57.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 18:57:02 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2eabd22d3f4so31900701fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 18:57:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXabo6HuWpzMJnGYNMYnoL/BF/I4c4tE4WPFF+Mtl3oS71tTqFQ3QgDJqJLyuHuW1E4YQIKrmICpyKEBrIAUtX9ntgn1ebRDQ8tSg==
X-Received: by 2002:a2e:a409:0:b0:2ec:4d98:c9d6 with SMTP id
 38308e7fff4ca-2ec4d98caa9mr19638211fa.29.1719021422276; Fri, 21 Jun 2024
 18:57:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
 <CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com> <yq15xu1oo3e.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15xu1oo3e.fsf@ca-mkp.ca.oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Jun 2024 18:56:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
Message-ID: <CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Jun 2024 at 18:48, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> The specific problem with mode pages is that there is no way to know
> whether a given page is supported without asking for it. Whereas for
> most of the other things we query at discovery time, the device provides
> a list of supported pages we can consult before we attempt to query the
> page itself.

Yes. I know.

But I also know that pretty much *EVERY* time the SCSI layer has
decided to start looking at some new piece of data, it turns out that
"Oh, look, all those devices have only ever been tested with operating
systems that did *NOT* look at that mode page or other thing, and
surprise surprise - not being tested means that it's buggy".

> It is a new feature in SCSI spearheaded by the Android folks. That's why
> there isn't a lot of information available about it elsewhere.

So no wonder random devices are buggy.

And I'm not putting down random devices. Quite the opposite. I'm
stating a well-known fact: untested things are buggy.

And no amount of "but but but it worked for me" is at all an argument.
If it hasn't been tested, it's almost certainly broken somewhere.

We've seen this over and over again.

> I am super picky about having good heuristics for when we should attempt
> to query a device for new protocol capabilities. In this case we lacked
> a reliable indicator that the feature was supported.

My argument is that things should be opt-in.

If it wasn't needed for the previous 30 years go SCSI history, it sure
as heck didn't suddenly become necessary today.

So you literally NEVER DO THIS unless the system admin has explicitly
enabled it.

That's what opt-in means.

And honestly, then the Android people can decide to opt in. Not random
other victims.

What's the advantage of just enabling random new features that have no
real use case today?

Put another way: why wasn't this an explicit opt-in from the get-go?
And why can't we make that be the rule going forward for the *NEXT*
time somebody introduces some random new mode page?

That was my ask.

           Linus
