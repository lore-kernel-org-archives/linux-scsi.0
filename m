Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710F17FF
	for <linux-scsi@vger.kernel.org>; Fri,  5 Apr 2024 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275985; cv=none; b=D+8Dgv2yn4jpXZEwj6OxuVwVvVrZ/4hSmcMsYLkrsGExQPa/kZqm18L2zQi02yZjAORR6d5xsz5l6ad6g1jyzO3oF7lUXteKLtyK/rTUG4mduvF8XY61CE8R6tKPqndWMs2mQ9szrUkfIgNpZvhO5pkDB63Dm74v0hK6OQMVjqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275985; c=relaxed/simple;
	bh=jaEB2m3Izex++oFpTAOJg3C2CKQblnEFr8EX5gQqcyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+jqsko8YWApvQYvT0hJk5SURgUkLFO+zLFfHMXjLlxhnnpWyNqwqpgeTmA6kErwnyCkqkI0TNtYL/41y1Qdnd5PqRFKUATjkmtvg4fyd+AqEgrOsKi/HZ5DpOCQ8mCmv1aJ/ISLv1FIwbRBKGhDOwfhnASht4NgaLaOnZrZ47Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EfBr4TOz; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EfBr4TOz"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5684db9147dso1943485a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 17:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712275982; x=1712880782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzGNANyd2JgE46JNXRqvYAAFlF/aLuTGS5xMsj3juog=;
        b=EfBr4TOzgxatZw7FfEpckucQEYUGSpszOoI276Dksq8FjrVnuqc/MZPJE2RXAHeVWj
         /BOZkCV8HEv6FOv6qYyIuEoQY7PGz8GQxdLNT0A5oQqRrwuiziMhHoFTh92h8Y44bt68
         UKtg6EDWJqHcQ0pceU0UVRjZQTMoi9kAD2DrxEtsa7x7K6uzx58sa+sN/rYOH8oyODOm
         ReAyNER8BN7aHLICHIKKevdGnWgFr9lm3zqFkZHeJDOa9g69/jFH0H0Tga//WAmdGeve
         dvUQtsVOK49TndMW9u5ByhRGzSmXPV/FIQpQo/6kq06nKqSxnWxv36LMVEQPFwC7TZZM
         i9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712275982; x=1712880782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nzGNANyd2JgE46JNXRqvYAAFlF/aLuTGS5xMsj3juog=;
        b=jBOZStZJIfr9/vYdgOQ9wR6ApKQOGk+togPIcrc2TdR6E5WMinZtjR9oBEBggd4LHe
         KoXuTTuxNf3RmoL0bfj2ve8z22dSetHojAf59DB0VAIUxs0oTezGYLhP8VncX4s69QKO
         jIhB+RZslMfkAIUbliGEecoRddY7pNDXxnN1I8+jScQjbGrLwHjyWQdxe/suU3e8d8rU
         esVtPHfcQ1mjEGlfOn9pkZmzri5BS7GJEI1Raocx5inZ3nPsakslzKpHMXuz6+YuIE6f
         kgc+EQnoovA2wJFQbapTVq1mahFEG6N4Ltbl7lona8o7YRXKPIzIohfRlwp1PmE+k1Mx
         pTaA==
X-Forwarded-Encrypted: i=1; AJvYcCV/Adz55G9bMvD8nLphtNQLBAtCtfHQGBZ/LTXgzju73R94KoVfdO+u5UTA78v7nVuFIgAT8dEVm49UQo4OgvGx/LZFP0u7N6cpUg==
X-Gm-Message-State: AOJu0Yxo0Pp5+K1wOsd/vD0YFy3E+BNaYkYbNdnWzVzA+m0Bd97UU+KF
	vnHIUtCLKBw+cbi3yiVwLhSL/HuNGNnLdS7bk2ypAmMvzOzQyERMwIqz872BNDuiQdXDmisC4B6
	H132aEfvIZJehNYkl495PjkwYu9wduzaUERg7
X-Google-Smtp-Source: AGHT+IGw375tpf/l/T78ij60a3HWHKbxzd3UBqDYf4pegBmKtv40l/GV5Kb5L8mfBvhqJPFZJpNv9Cn8FfkZcppI298=
X-Received: by 2002:a50:ccd5:0:b0:56d:f47c:5308 with SMTP id
 b21-20020a50ccd5000000b0056df47c5308mr2622547edj.34.1712275981747; Thu, 04
 Apr 2024 17:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
 <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
 <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
 <CAFhGd8r1gGCAbsebK-4fD+cPeUCMgUG_XTx5fKa3cqJwNEEM8Q@mail.gmail.com>
 <202404041629.D23DC8F7@keescook> <CAFhGd8pkXKvFfRpoG=e6k9u3VvC6p38p-z9NMidYyKvZ5EYXLQ@mail.gmail.com>
In-Reply-To: <CAFhGd8pkXKvFfRpoG=e6k9u3VvC6p38p-z9NMidYyKvZ5EYXLQ@mail.gmail.com>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 17:12:50 -0700
Message-ID: <CAFhGd8oe_MN6GCEsPgBHWhka9+bD3mKmcWThG=whY8cGYNsnPw@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Kees Cook <keescook@chromium.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Agh, typo.

On Thu, Apr 4, 2024 at 5:10=E2=80=AFPM Justin Stitt <justinstitt@google.com=
> wrote:
>
> On Thu, Apr 4, 2024 at 4:39=E2=80=AFPM Kees Cook <keescook@chromium.org> =
wrote:
> >
> > On Thu, Apr 04, 2024 at 03:47:05PM -0700, Justin Stitt wrote:
> > > Cc'ing Kees.
> > >
> > > On Thu, Apr 4, 2024 at 3:33=E2=80=AFPM James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > But additionally this is a common pattern in SCSI: using strncpy to
> > > > zero terminate fields that may be unterminated in the exchange prot=
ocol
> > > > so we can send them to sysfs or otherwise treat them as strings.  T=
hat
> > > > means we might have this problem in other drivers you've converted =
...
> >
> > That's why we've been doing these one at a time and getting maintainers
> > to review them. :) Justin (and the reviewers) have been trying to be
> > careful with these, and documenting the rationales, etc, but this is
> > kind of why we're doing the conversion: using strncpy is really
> > ambiguous as far as showing what an author intended to be happening.
> >
> > > Correct. Although certain conditions must be met:
> > >
> > > 1) length argument is larger than source but less than or equal to de=
stination
> > > 2) source is not NUL-terminated
> > > 3) sizes known at compile-time
> > >
> > > I think fortified strscpy needs to be a bit more lenient towards
> > > source buffer overreads when we know strscpy should just truncate and
> > > NUL-terminate.
> >
> > Okay, so the problem here is that the _source_ fields aren't NUL
> > terminated?
> >
> > struct sas_expander_device {
> >         ...
> >         #define SAS_EXPANDER_VENDOR_ID_LEN      8
> >         char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
> >         ...
> > };
> >
> > struct rep_manu_reply {
> >         ...
> >         u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
> >         ...
> > };
> >
> > Okay, so struct rep_manu_reply needs __nonstring markings, and the
> > strscpy()s need to be memcpy()s.
> >
>
> rep_manu_reply->xyz is the source, sure we can mark those as
> __nonstring but don't we want the source to be potentially
> NUL-terminated (says James). Are you suggesting a memcpy() followed by
> a manual NUL-byte assignment?

... don't we want the DESTINATION to be ...

>
> > We've done those kinds of conversions in the past; it just looks like w=
e
> > made an analysis mistake here. Sorry about that!
> >
> > -Kees
> >
> > --
> > Kees Cook
