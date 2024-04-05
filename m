Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1924C7B
	for <linux-scsi@vger.kernel.org>; Fri,  5 Apr 2024 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275825; cv=none; b=o5T60xdkh8wOYsbW/QJhVEVNN6Mt50yEuCmqAuRNjzWisFDeZBwGOOvu6imbZbmNwVxZ8t/HPrzb4wPxIp00Z5ncf75BCKB5y1eMnu8YI5B8dtm3jxdDw/VI6yw9o1twN2CoSlFtFy5mHx55RUc++uFp7CF+5Unp/Ze1QFhCCu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275825; c=relaxed/simple;
	bh=CvKRJxJvnsQaZbQ6/ZEjQAhvRzs6O9yTG2B3M3N+Z5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1aDCR2Ow/HTB++CB5WMECYICAzCzRB+6hBdtsm9BPyFeHbIJ40Rw/tJPr+PI0fM8HLVaTGCgLWl2WNVw1CM4+4acCN06BkoFf7YjceZot272ClgpBGOxPxjGgBLASWqxm7L76yFEJONurYYgQ6EEJrDvDrSNdotIAzgaDjSnFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pj3YwFKC; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pj3YwFKC"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d4360ab3daso18097861fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 17:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712275821; x=1712880621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btHAIV7gnk8Qa3S//otNhslegOZzuKlhLZSOeIJx9Ec=;
        b=pj3YwFKCBPK6GLHr2jSKmCg8BPDr6UUlkvACyY1dQvtwi+Cs3Q5Isma0Ze/k1aGoHP
         yqth8G2uIyi1A8jHLajf4pWe6iNhyv9GMqLiJdexA/+jhCSi/Z7jzXFhpv90H3Pfi8XJ
         IAtVvGDY30bm4z3ZzADrKbLdo62m/YqrlbQJMmVO7/fNedoBYnPL6iM5/a3KjBthAj0A
         ucIObcNMNqpB5osCJTsdecaycqj2HYZGPSm0Y2YEhjIbGmMWjqiZOP/MA1NpdZ8LrJFU
         8SvZsqVeCmcSKj0JBaVcf79v4Q8h/HYC6iy/uHHVwub5ho3Em/hLxLDaX7QVZV7RFyog
         NRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712275821; x=1712880621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btHAIV7gnk8Qa3S//otNhslegOZzuKlhLZSOeIJx9Ec=;
        b=VENRh4gYO+r5VDywF1qpNg0puiDsNzTCI9uyol1apdh7Vs8Axd6yXB3iDdMrosu1al
         C77lteY42tOKkDDoLkqDAjNscIm2POzztmIB1Jez2A9/PSyW2xgTaPrFRAVf7fDT5YjW
         nHPOTjBPC+Dfc4Vrx5BK2uyRyxaxeircV9pGMNigMD865hhi7lQrKFJGdXy+u9jwFblj
         EAfeLsuKnMFgKowNRM+6V6Qzrg+6DNgd1dirSuSA71QHcWUNKgvPQF/iNGxqonjCAbaC
         +7hiz96j9JKjT7LIG/xlCxL6BHZO98g6rd74RtTGQY9YWcDR8wbGIgaeWpBmRbxJyqq0
         YerQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOAq7OGCY2/5nIYgOTCbSKrIDFhAWyDRCGaPHgq3bAVffXxB1TR8Dn0cQg2ddPyRBKtajH+/D81txwTOWbvXD29AXJTzQxRUcIbg==
X-Gm-Message-State: AOJu0YyCeDf7RLfluFs9WrmlkFiLvJbcx+jjIlGsk3EWRXObdXDL/Rby
	IfnThooBPX7ZRL0q1mZDqUMf81LMOaApGEzywQCVhXNfISXfJxRay+WzAqTrRy3QiPKUh1m2JSs
	JE1kQyPnNr1l7Hy9NLpc5FdV0onicqOduQoKm
X-Google-Smtp-Source: AGHT+IEI+1t+tzTt0Iq3kIy3/whN+TgpKdyCKMuNS5yDGMmCjtMA5UG533YyIxXFWVm9Pu4jQC8J7JDVemPuYiJ1APc=
X-Received: by 2002:a05:6512:462:b0:516:bea8:f46e with SMTP id
 x2-20020a056512046200b00516bea8f46emr567951lfd.61.1712275820887; Thu, 04 Apr
 2024 17:10:20 -0700 (PDT)
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
 <CAFhGd8r1gGCAbsebK-4fD+cPeUCMgUG_XTx5fKa3cqJwNEEM8Q@mail.gmail.com> <202404041629.D23DC8F7@keescook>
In-Reply-To: <202404041629.D23DC8F7@keescook>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 17:10:08 -0700
Message-ID: <CAFhGd8pkXKvFfRpoG=e6k9u3VvC6p38p-z9NMidYyKvZ5EYXLQ@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Kees Cook <keescook@chromium.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 4, 2024 at 4:39=E2=80=AFPM Kees Cook <keescook@chromium.org> wr=
ote:
>
> On Thu, Apr 04, 2024 at 03:47:05PM -0700, Justin Stitt wrote:
> > Cc'ing Kees.
> >
> > On Thu, Apr 4, 2024 at 3:33=E2=80=AFPM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > > But additionally this is a common pattern in SCSI: using strncpy to
> > > zero terminate fields that may be unterminated in the exchange protoc=
ol
> > > so we can send them to sysfs or otherwise treat them as strings.  Tha=
t
> > > means we might have this problem in other drivers you've converted ..=
.
>
> That's why we've been doing these one at a time and getting maintainers
> to review them. :) Justin (and the reviewers) have been trying to be
> careful with these, and documenting the rationales, etc, but this is
> kind of why we're doing the conversion: using strncpy is really
> ambiguous as far as showing what an author intended to be happening.
>
> > Correct. Although certain conditions must be met:
> >
> > 1) length argument is larger than source but less than or equal to dest=
ination
> > 2) source is not NUL-terminated
> > 3) sizes known at compile-time
> >
> > I think fortified strscpy needs to be a bit more lenient towards
> > source buffer overreads when we know strscpy should just truncate and
> > NUL-terminate.
>
> Okay, so the problem here is that the _source_ fields aren't NUL
> terminated?
>
> struct sas_expander_device {
>         ...
>         #define SAS_EXPANDER_VENDOR_ID_LEN      8
>         char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
>         ...
> };
>
> struct rep_manu_reply {
>         ...
>         u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
>         ...
> };
>
> Okay, so struct rep_manu_reply needs __nonstring markings, and the
> strscpy()s need to be memcpy()s.
>

rep_manu_reply->xyz is the source, sure we can mark those as
__nonstring but don't we want the source to be potentially
NUL-terminated (says James). Are you suggesting a memcpy() followed by
a manual NUL-byte assignment?

> We've done those kinds of conversions in the past; it just looks like we
> made an analysis mistake here. Sorry about that!
>
> -Kees
>
> --
> Kees Cook
