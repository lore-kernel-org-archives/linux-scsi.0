Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C77856476
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VgPOZI+4"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cd1ca52f31so68220141fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705013283; x=1705618083; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IVTa2Qk/zKb+/z6OaDyalzLK5VKuTWu2RGMKTC1CM0g=;
        b=VgPOZI+4f8i8Q09HOizwVMdrFwhgA5I0R7KP6rN9xZw8XQrr5ie2l3w4E7A+etrnMv
         lrUVNuYHG5Y4NZkHhAdGB/xMrsyrcqN9n0ZzOPQLVH/T6VosPVwyo/ZaFlvvHpFtQ/AY
         f0uqKaBAUTik9B/1q6i3Nbadl2AF3ZkOi9q78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705013283; x=1705618083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVTa2Qk/zKb+/z6OaDyalzLK5VKuTWu2RGMKTC1CM0g=;
        b=Cr7NyUMhdco1hW0mK2CzlLLXm2GhGH5EmaRM6Dox9/3wAchsCG0bqvmbhv/TaWbg9I
         hRB+qt5zTeciZqSB4Etvr1jD/lgOGTDp1KnGTkMLmSiU7zNjQtdsNOzIzgfvl4gJ6nI5
         etUEf1hnebzXVSoB7azS+yjYkB5RQarjQY/tefEhsiU+cNVNvAZZqfA9GR7JEz9drfWP
         hPX5gPCIJRDyXD30mLADbb+mIm4ckDTonv1ToAy69KZoQaRX4TseZG2QB+qKG9pVx6WI
         +j2k9RMqLrxyVB5+nP5dtL3VbC5oyaZnoUYAqrtrU+Fmplby+q95HKyRZbh7TZB3MXfx
         xz3w==
X-Gm-Message-State: AOJu0Yw0iJTrteyb3JOsQ/WhvcCRYtF/j2XfN3oBLU0xjWD9epPGbmDG
	j9qDn4cOj7FgVkU0m9TOztnBbt5Fc6ZZ+cZTm3c3EgJt4+0xj4RF
X-Google-Smtp-Source: AGHT+IFQPsR64uo8utx9EAe5OqqyqulrcwD/avByPq9wPwdFgZfyGq1exIYbJtbJLjWpWAipCneWQQ==
X-Received: by 2002:a2e:8754:0:b0:2cd:11f9:a628 with SMTP id q20-20020a2e8754000000b002cd11f9a628mr189156ljj.68.1705013282827;
        Thu, 11 Jan 2024 14:48:02 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id q11-20020aa7d44b000000b00555fd008741sm1094668edr.95.2024.01.11.14.48.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 14:48:02 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a2c29418ad5so197544466b.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:48:02 -0800 (PST)
X-Received: by 2002:a17:906:7212:b0:a28:b659:cc89 with SMTP id
 m18-20020a170906721200b00a28b659cc89mr182790ejk.115.1705013281951; Thu, 11
 Jan 2024 14:48:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5ac3166f35bac3a618b126dabadaddc11c8512d.camel@HansenPartnership.com>
 <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com>
In-Reply-To: <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jan 2024 14:47:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiHCkxrMCOL+rSGuPxUoX0_GSMLjgs9v5NJg6okxc1NLw@mail.gmail.com>
Message-ID: <CAHk-=wiHCkxrMCOL+rSGuPxUoX0_GSMLjgs9v5NJg6okxc1NLw@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.7+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jan 2024 at 14:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Stop making a bad pgp experience even worse - for no reason and
> absolutely zero upside.

Side note: even getting gpg to show the subkeys was just an exercise
in frustration.

For example, I'd expect that when you do

   gpg --list-key E76040DB76CA3D176708F9AAE742C94CEE98AC85

it would show the details of that key. No, it does not. It doesn't
even *mention* that key.

Because this is gpg, and the project motto was probably "pgp was
designed to be hard to use, and by golly, we'll take that to 11".

And no, adding "-vv" to get more verbose output doesn't help. That
just makes gpg show more *other* keys.

Now, obviously, in order to actually show the key I *asked* gpg to
list, I also have to use the "--with-subkey-fingerprint". OBVIOUSLY.

I can hear everybody go all Homer on me and say "Well, duh, dummy".

So yes, I realize that my frustration with pgp is because I'm just too
stupid to understand how wonderful the UX really is, but my point is
that you're really making it worse by using pointless features that
actively makes it all so much less usable than it already is.

Subkeys and expiration date make a bad experience worse.

Yes, I blame myself for thinking pgp was a good model for tag signing.
What can I say? I didn't expect people to actively try to use every
bad feature.

                Linus
