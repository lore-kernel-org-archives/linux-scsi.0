Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990FA7F7D7
	for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711137378; cv=none; b=VL32FdI6wYsDyu9MnERtszIiH6KAqI0wQVOBNh83tPREmaw5mZwSeMZIjStrtyL/xJIyUHBfY1Es4jXgg28D0okt7IfsC/Jj5uKu2AW5+4oz1UUYmKKlLJtj4Nd21au+zYjWuTv+4+Gdfi/qJG48lr1VfLKRPsGdRQ85qAZwnHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711137378; c=relaxed/simple;
	bh=kEPXH+l/Pa5KYbYBvhkjCAhhsDglYWMHVXWYgQs1Dss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DRZDhgh4z9ZvdQ4TuwcRnEXj1w1m1RdIvcFWAtrNziAAqnK15eHfQZuQH2TKZDtkjexMxzEZ2y/QLlTL2gSN251Gbu85fdz0r3C+cf3eGbLPlAI+cuzEG+AhxYGw1WHmGFyrNPu+y/7Ks6A/YTtfKC7Rao4WRKuP6E8KXzP6V1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EXILuZAD; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EXILuZAD"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a2f22bfb4e6so345094266b.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 12:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1711137375; x=1711742175; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ceUxvYrzPOvc3uSwb/RCsigp5k0CjOlOqglIw+EfE8A=;
        b=EXILuZADeZ4q+QOfsh6mIRJsJd4ac0zgIBggXEjzxPalBvMYeEWBagtuObkQrgPJS3
         TcdnuR0z8ReCv/JY2cN5Q8mLuHu8IeXzxO/Pevy/Q36PAUGocn4lPbRWTvDTDBV/1Qwa
         yazyB45zfzMPSyo0vudGKw5lU0330DdoarBNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711137375; x=1711742175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ceUxvYrzPOvc3uSwb/RCsigp5k0CjOlOqglIw+EfE8A=;
        b=gg1gC23CGnauq+Hzw7quvDt9s3uApGa6V5JnPMg/jJfvLUAu33BXJyP8AdJ3FizG2q
         q0+eKLIrfcShwtK/xAZnNg2JR9t6au3OWS6tSYxYGhNB+BH2FAFpf0xRhx5mdp+F9qdF
         bLlNJSKSjQTJQNU611J4Kz6gOsUzNfOgj4Sc8bIlV6r+zc7adosizfbOAQBj/xOdaOoE
         c7ztHSpB5+fTOIlc7u1ElJnTY70dTvMqLNWhwk1421qWx0N3raUhcoKeQIx5P7/XVN3l
         okf5t55YqdO7FphObHjgffWzSKFESjU/IqbKzZWRguDLWgoHeMXh01WGUuCLUXjsKzsH
         a/JA==
X-Forwarded-Encrypted: i=1; AJvYcCUUmTC3CPQjfTZyCaidN3xUPizp6xdkz28kqs21H8bOzzeGsIlylNtORxAfCokKhsy6ego0A9s+dNCH4nPedrtjPUkHInStfilquA==
X-Gm-Message-State: AOJu0YzjM5s+KCxQto9DvkwSQQy6ljttZYTmwJc1rEiuVKhOFxCZvjd1
	Mm0g9a9C7dkZhnFfHEP8ukXjWinZXIQXGexItc5WAXHWE6Y/eXPl0Ek58ACgwZJwAB/6kQZM2CN
	tfrI=
X-Google-Smtp-Source: AGHT+IG4WLp0+QNMZ5OJol4iw5Hd9yGGXPR0zsJTzzc6PK9drBwhomqUXS7v81QoEJ7N9yK+LrrpEA==
X-Received: by 2002:a17:906:aac4:b0:a45:231:9b4b with SMTP id kt4-20020a170906aac400b00a4502319b4bmr532561ejb.20.1711137374622;
        Fri, 22 Mar 2024 12:56:14 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id kt16-20020a170906aad000b00a46025483c7sm158998ejb.72.2024.03.22.12.56.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 12:56:13 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a466a27d30aso330486066b.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 12:56:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUg1dfOl/xttbaTUI5eHXdlCK35Txyau1Z7Lf3JSnuJtUXAmxJwO2mzreoLND8LFXj9fvihajI0Ka3fFUOiD8HZkdvsYqGefWmJng==
X-Received: by 2002:a17:907:7892:b0:a46:c8d5:84c8 with SMTP id
 ku18-20020a170907789200b00a46c8d584c8mr486369ejc.38.1711137373495; Fri, 22
 Mar 2024 12:56:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3b789eacddd6265921be9da6e15257908f29b186.camel@HansenPartnership.com>
In-Reply-To: <3b789eacddd6265921be9da6e15257908f29b186.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Mar 2024 12:55:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg9pvT5YEo_kGo2QGjbC-eRaaQNOZuJYCsM1zaxj+rnug@mail.gmail.com>
Message-ID: <CAHk-=wg9pvT5YEo_kGo2QGjbC-eRaaQNOZuJYCsM1zaxj+rnug@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI postmerge updates for the 6.8+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Mar 2024 at 12:12, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Eleven patches that are based on the rw_hint branch of the vfs tree
> which contained the base block and fs changes needed to support this.
> 8 patches are in the debug driver and 3 in the core.

Please people - the number of patches involved is entirely immaterial.

I want my merge messages to say what those patches *do*?

This whole "how many patches" thing is a disease. It's not even
remotely interesting. I see the size of the patch in the diffstat, and
that actually has some meaning in the sense of "how much does this
pull actually change", whether it's in one patch or a hundred.

I have absolutely *zero* idea what the above pull request actually
asks me to pull.

So I won't.

                Linus
