Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93030C610
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 20:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769374684; cv=none; b=sp4DX4BY0phv0jqf/GDg9mAlmC3vtIeFYk7MsjVYtFowe/y3yLobXZcb7RWEPvQFrJPO9j7/JN26YgYq8M4/vys37jEL/ZKQfNxcoxvzx1aMk3INCBTm2jIfzXKWs+B8OwXwdQ03Jo/kPSLNoh+yfUDXvf8ClfYkn2dZ4/9RDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769374684; c=relaxed/simple;
	bh=wSeCsvRK6s+r9JK6gpOrz7n0DjZ3Xu5cnj8LTHh0Uoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1vky2prvqeqLu6pCXHPnm5N1oQPpRs9Gb/CY0dOd8TleUxSvv2GPp9CN1IAG4XYXMQGsevCF6MN0Gogiaa+SXYJHKj64+JqHa5DF2D5OiyYHQ23Tl7MzbiEYpL1aONiHLAeUiLB7d1YKkvBeYQ9QuXJLNtskIpdBH8PV4+80GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ESUdRlOp; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ESUdRlOp"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so7320552a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769374681; x=1769979481; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KDm0cb9GL+U5Thz4yMQBYQGnjxSXhpDXGN3DBqymvfg=;
        b=ESUdRlOp7bM9K+tE3LUFLE76dVV6wSQShgXhmWGfhKrBDrswh4Otyxp/rbvNJG0LdZ
         LqWPVSgboQQZxQw9AhY2LomDAvodPF+EPmM4U8JX8VG5Bzi0Es3sZIQACjM3q9+c0X43
         BkrRLOKwU1JYDzpfLVpLFF2//iy4bWnSOVfQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769374681; x=1769979481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDm0cb9GL+U5Thz4yMQBYQGnjxSXhpDXGN3DBqymvfg=;
        b=v7SbYgkR1f8NRy7Wx2wcGPi0NaqcRa0MY6rM51za8Tejmn3LD3Yh/WxLFU/JlrGfH6
         7JpSL9OAuikXn2257v6sgzh3lhHt7Q99XNTlIfGRaPPDgX7c1uUEAbjnnUOTXrUvfbsH
         7Fw9sp3dzFr4Li1SyYpq5nAH6igi5yXY6nzCiCHzTfPoRopFqnZRPR7lE6hq1O3GrLCB
         AQNagnUmJdMYfSd3F5OhlVMTLn7lXEdb9UMBEWBp4+ha16rkViJ9FIF31LNIvRKyl1b/
         sdiopAujvnV0lsCMtBdSr5aOFdRkJotFPSC9NSj3wXzA01ejMqqPsrxHTrR5XyShvzSS
         JoTg==
X-Forwarded-Encrypted: i=1; AJvYcCUGj4ZxFDTBQ0WI8TZne/AIqtsovDUkX2VjevoZLbEvXLKzXiHsAZl9mzAlz/J2/DionTFatdxDhN1n@vger.kernel.org
X-Gm-Message-State: AOJu0YwGSp5TWSWjuwY5gCajdApR2gvhKj76YTg4UTQ1If61HFewgh1T
	MGJQlkFdeG9nvxo3B4mZ6Z6ja8WkzOvi4J6Rcrfxy0ZMSUFup8N1ceI0fZlADzURjkL0Rd3c4Zq
	sMAdZ0miZIA==
X-Gm-Gg: AZuq6aKUagZvXWR8aTSNGLySDHrcQOmMZR7UMUzCwamZReWOG0miNbjLozWqqgSmynE
	DynNpXDaF6GL2KFtypHVY+hY2vBQrc3L9Y8huVqtmqdVxXcVKObs7U2ZMSrptVohMAO2AUKxPKk
	ddO5FkJ6q5lppG9V/VZTbaaPWkj3quaeoycK1AAUgfnurdvZ/g0RL6WYJjPWZM1/ln1tboB3kkc
	/nxndAFgxK6E4ShnV2nCjApTDbcMRG31wa8ioCRVNsmQxOmp/C0sVnKPIlIr3gWE6otKFFn8HY3
	05iSauZS+m/4aCs+24cLJf/vtgEIvHon34IF9NXL7XDwp6n3oSbSpOUcXZ8yjEZcnhXPZGB5T5o
	Ri/eySBu2R5iExt5jB7Oo3pQe2hHKBI7Xm3l9KQD5RGKlyhosIANM440KBlIJXbfWUdG4/EmcGi
	njpqTO5UYCr8Bvow07iOr8lflBP2wEGb9sYhHBFrBUqekicYv5YLB9l0GY2xZ108XT6uJ5kEw=
X-Received: by 2002:a17:907:968d:b0:b87:1eaf:377c with SMTP id a640c23a62f3a-b8d20e48303mr163762266b.38.1769374680901;
        Sun, 25 Jan 2026 12:58:00 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b886a249e69sm447342866b.6.2026.01.25.12.58.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 12:58:00 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b885e8c6700so438966366b.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:58:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWxBdX/gek67/cZ/waTPxuNmUXood79Ey6zB0S3spz/7FP/1OT0TdMkvnppPXqcBqq8kL5Zz9Ornny+@vger.kernel.org
X-Received: by 2002:a17:906:ef0a:b0:b88:21cd:5fcc with SMTP id
 a640c23a62f3a-b8d20e4e376mr172066466b.36.1769374680287; Sun, 25 Jan 2026
 12:58:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1a20127d291b660d4f85bb85c1dacc67c228c368.camel@HansenPartnership.com>
 <CAHk-=wg+4HjC5+qo_dKoyCt=TmVuUQqpWGAHMcRv6KKnv64v=Q@mail.gmail.com>
 <3a280502b3cb98c60ee3b514e7e27f0749c86a26.camel@HansenPartnership.com> <CAHk-=wjxH4L=On-ix4X8WNzKOSbUEbycDogfxFFJd1MD=uJtJw@mail.gmail.com>
In-Reply-To: <CAHk-=wjxH4L=On-ix4X8WNzKOSbUEbycDogfxFFJd1MD=uJtJw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Jan 2026 12:57:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wihFSDLgD26tj_Ref0Tr2eOU3Wa5OXkqLNpGv-ARVN5mg@mail.gmail.com>
X-Gm-Features: AZwV_QizbJen9JqbnrL6CCUPgqTl8GdVGNS96jn2foTYeN3VYYyT396r0V4j79U
Message-ID: <CAHk-=wihFSDLgD26tj_Ref0Tr2eOU3Wa5OXkqLNpGv-ARVN5mg@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.19-rc6
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Jan 2026 at 12:10, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 25 Jan 2026 at 11:14, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > You can either ignore the expired key warning on your end
>
> Done, and pulled.

Oh, and it looks like you're not getting a pr-tracker-bot reply.
Probably because your pull request was slightly broken, and didn't
include the top commit ID. Your pull requests don't have the normal
lines like this:

  for you to fetch changes up to 19bc5f2a6962dfaa0e32d0e0bc2271993d85d414:

    scsi: qla2xxx: Sanitize payload size to prevent member overflow

and then presumably pr-tracker-bot had the exact same problem I had,
and couldn't fetch the actual git tree, so it just didn't know what
commits you were talking about and so doesn't react to my having
pushed out the result.

              Linus
