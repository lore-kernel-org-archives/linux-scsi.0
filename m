Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B6D17D887
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719007438; cv=none; b=UKyCAVoM3U7BW4Y0ylrzAcgTR22x07rx4mILDl4BH2+7jVLTQXsFrqX14NcX9nlrUZLv9dwdBLacyVcGpVnWzr5KhDXaMa39ZXkosCeDqlNZOjOlc6UNpfDFNBxgEwwHvJLiPlpM0zXr3d65p1D/h5wvE/SzTQcif1LkH5ju5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719007438; c=relaxed/simple;
	bh=VJPBx5efPOq30t+7qwsRircNZM52T3GKxalqnCPh2ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHKIvKqBorKCiz9SYVQ/7iIvt/1luIf1VvsI4Xz+5RLhxLM199hZ96bCLtB9kxMIa4RlXuUEJV2hoL/J41bfLCdxYOs+/f2mGUbKnj8jO/2SmJhXfmrpFvuPwVVo8hI76p7+gDET6j0uqY9S69fVgnt8Qxz7+8HtISRTZpmCVm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DAE6TQs/; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DAE6TQs/"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ebe40673d8so26942051fa.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 15:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1719007434; x=1719612234; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7VevD/tun51OukWgbAoZ4Cm2u23YTJzraHYAs/IYAE=;
        b=DAE6TQs/RQCNJqTW9yXsdCcDGA3UGeh4GUOb6Y9VUM7UPPbdWo2d93fYNmp3wNIahY
         CggDgCYq7v3xH4P6IUoEBFVzOoecUhlHe0jIhOLARSM1SwxvjfV+sX3tNa8hl8SZ4+mm
         i7z7+KJStDA/UTGyELXDRuGDVoCRlsBafX25E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719007434; x=1719612234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7VevD/tun51OukWgbAoZ4Cm2u23YTJzraHYAs/IYAE=;
        b=NxxHexVOaJinep082DHZfYFERowISs6gV6ud/DycAxSe0/bBxVjZ/twn61T9poL+eJ
         aW9axbAHtYZkuPx6RlOjHhifT0ai/tPBTRPPqWXYlYcAmJibgsqeQCgz8U03fvfCRKuz
         jWEjP5OlaeXVdfdb/SMa3QWR7ZZVtG2lW9abuGfhRU6rnTekFuZrsq3sPrF0FaQFirKy
         xN/vqS7ILjAy/W6VyzroI/69BJLPpAKGqM/e3tUamXonnto6lYPHTyfEUHe34ynNibrk
         6P6gO7WCE+EYIw8xlN3D/H5HaHlZmVHpQFDmjOnAkaY/klWeG9BCBkb2D8H5xbefnvqs
         KIpg==
X-Forwarded-Encrypted: i=1; AJvYcCVs1TVJjW5AMW9o4lCun6GBd5PZfmd1j+DEiRbbDXyd4QXKOnIX6R/ZZTJ1UUHfJy09OVoWQcKUs7qrMxfWfojmRP94YqBfdCwWXA==
X-Gm-Message-State: AOJu0YwQH6YZOrOKEzEuyrgjT9qS/tTyqBOsSGy02Zdn3wj2NchOvFxX
	rU+k/Cddz54eXTA5GB+hWGiCTqa5b1t6wqTEWmU0MVD8cwgx0zUQXSo4ZSiNkKQcOhq67Rq7T1N
	Fr0y5wQ==
X-Google-Smtp-Source: AGHT+IFWLv5m1PbPZ+R+j7BdSHtTruI+2i4cZvabkk8NHR5SdCJl3+Ir4RfA+5pRfSZSJ0fiYWYrHA==
X-Received: by 2002:a2e:878f:0:b0:2ec:1890:5ec with SMTP id 38308e7fff4ca-2ec3cfe6909mr60223831fa.41.1719007433819;
        Fri, 21 Jun 2024 15:03:53 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d3056355esm1457888a12.82.2024.06.21.15.03.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 15:03:53 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57cd26347d3so2593489a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 15:03:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVEeTstP0tkojQUuDtkoReWL6u/9NMe31sHJ/ewlFKGz6dQJcl41yY3Y5pOngk4e8zv4VP1s6l+Wd62qlPr03HCK4rjiBdZcYO+kw==
X-Received: by 2002:a50:d613:0:b0:579:e7c5:1001 with SMTP id
 4fb4d7f45d1cf-57d07e6f4ecmr5627181a12.23.1719007432440; Fri, 21 Jun 2024
 15:03:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
In-Reply-To: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Jun 2024 15:03:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
Message-ID: <CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Jun 2024 at 14:16, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Two fixes: one in the ufs driver fixing an obvious memory leak and the
> other (with a core flag based update) trying to prevent USB crashes by
> stopping the core from issuing a request for the I/O Hints mode page.

Honestly, this mode page issue seems to happen every single time
somebody adds a new query.

Can we place just make the rule be that new mode pages are opt-in, and
*NOT* this kind of broken "opt-out several months later when we
noticed that it inevitably caused problems"?

Because if it isn't some mode page that we have already used for
years, it clearly isn't *that* important.

I'd like to note that the wikipedia page for SCSI mode pages doesn't
even mention 0a/05, and I had to go to some SCSI command document on
seagate.com to find it.

The only other hits on the first page of google? Linux kernel discussions.

That should give people a big heads up that "maybe this thing isn't
very common or commonly known about"?

Which in turn should be a big damn hint to not query it by default.

I've pulled this, but let's aim for this being the LAST TIME we add
some idiotic query for a magical mode page that is mentioned on page
413 in an obscure document, and that didn't exist ten years ago.

Because at this point, blaming "some USB devices" for not reacting
well to it is kind of silly. This isn't our first rodeo. You should
have known about this.

Maybe add a BIG COMMENT in sd_revalidate_disk() to not read random
code pages willy-nilly.

Not that people read comments, but maybe it will remind somebody that
we've done this before, and it never works.

I mean, we literally have this comment for just checking the read-only bit:

                 * First attempt: ask for all pages (0x3F), but only 4 bytes.
                 * We have to start carefully: some devices hang if we ask
                 * for more than is available.

and that's a mode sense command that is at least mentioned on the
wikipedia page.

(And no, I don't consider wikipedia to be somehow special or
authoritative - but it's at least a sign of "does anybody know about
this thing?")

             Linus
