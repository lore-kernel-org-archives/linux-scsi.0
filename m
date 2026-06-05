Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF131354C
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675389; cv=pass; b=MBOZ67HJn6+hINKxbBSkpSrdLqlkf4k7mr2nvsifeihcBv1gY657fdavOAiwau+ysLwXCtb1hnJby/G6FQXs9HzHO/6/pROX28+0QxERpgtW1rEeEJ4Kpmu9R94vH25lfP5HefppvWnCCVQZ2yAJS4B9fdt3PSqzsm8zki3HdJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675389; c=relaxed/simple;
	bh=/OAVgqB1os2JKqx6E3DYW6MjnB+zs+wpoJqXzrnGQYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r50+deAa0AW/I5nvJUm9Bnlh+8uaAYPYNUlzWqPbsXuYp938JglGs/58fzlOsSRK0VL7/CJQ/gJ80HUX8IfTDoeu3N/VkM3WL4uw9612+PIeL1HcC12WY4sIhYl1Y//t9HIlLuRnR0ykVao9Sg77zg54++mkT1og29tT8tvI7IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dx8ZNviY; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dx8ZNviY"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39661f81eacso24383871fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 09:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780675386; cv=none;
        d=google.com; s=arc-20240605;
        b=OD4okdsrVuRjwwnBLD68qQXPC33cJ9eEuSDEyCoWyrFN4f/z0ubz5BlDiXj2HqGpgy
         pb75hjTVBvonER32jXErjixxTTiGW9BSMVTa6I5MWFov5dvCNWBh1gL7u+qg2VX0zzC3
         NRqjGyWlxXqBsLTNe0dDFiiW9VzKTrdqPtCId8qO+EzmZafkATLcNWwVNNJsuvHtXxqC
         q/TOmmbMq3XReVQzwMmegvGV85vbSeEsoZahVb9ESVDba4AGcIKqHTDI40FokUzhPN3L
         oSGsdsWSiW3UaKI+fSF6/3oRLWr96Yo00MT08hRfOziZtS+AORGMBCeARLwZS/yr9vUw
         XSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        fh=bJLZRHoPcnHwIzA5yj7Hj+ySw/XQ9V+RsJM28KUUyb0=;
        b=eFwxCvMC5F7fjjlh5S9E4EylVDB8PD6Q+Tnxu27KF4a73f8VXJLugg2dgnA0JyS3va
         XID4USlXzHsLoaR7DDbYWexW2W8wdQT1oobC6/+8SEh3Olmkcvo0RDoAcW3TUjQiy2l+
         jWsBPw/rKYMTGojERUQG6W4//rk5IuYYeBArT3axvFv4VwyA6eAFvdpu9dMWCyQ/mrkm
         nv+l4IitTlD6dYPCPVlf9ZUEVDTjleSGu0Nh+fncPR7Z6QO9+duEYnZyGu6NZHSvH2ea
         5VLKHPUJzFd9AVyjNfC0Ko254c7V5sBEU4PyP8DZNy3XcSM++/SduVYLxhWp6GBJ8OEN
         4MJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780675386; x=1781280186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        b=dx8ZNviY3ajZ2AJbHkxaYXWi9cY5R6CcwR8vn9mcI4Qd3td2XNFnvfLy+c1L4w5yo6
         jIu3Tt1WnJSy3HQxt5K988tAIypTv0erV1JMOv/5k2mp3mNHazq5xmECBT2XnJGI6Dkd
         HM3V7GTZJzlgHULQmOgiJ/9bPD1k58Q91L3krYh4g1hK0w1kOJ7i7YtAC/NTjlaQGs4L
         ZDE3xewFEgJRfK2Q5ijPaE/v8RsYTpT+4zBVIjO8Urub/9RIlvzgAZP+ctTD9r2SwlI9
         jayx+sk9EUPnMbxlrKav/TkzVNQ1o3onTcx8WSPEXu3nWfPn0UJE1UNYFg4oaOtbBP63
         9vIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675386; x=1781280186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        b=QLL4c8OhI9ib4QHLnWmDfoQ6WT2R3gjnGAJPVrJBMaOAiWWsuxSPam+cNB9372rPD3
         uQ98Tdxnkye8dDCjG7dRJRYMnjvW0QbbBSVeQMjqx1j/ZhsTYNnnLKjgCNgnAQh8V5yT
         Z6+V0FJM0Ib5umdqtwTmFtIqwgz3zLkxdm7RIb8ax1ZwXO2HQB3ZtS85D0F90JJXsynI
         5nFgUan6r+/SQcLu7STxQsbL5X85l70ZK5B4McY5aXW5JZ3q/goh0zOIV4dicfY3U/Z8
         TvfVTuO/dMM55cYm7vnaGmnFxrVAyCgI0SBQlHWHe734osTf7SKCwwOTl3ja8UH9NSll
         i58A==
X-Forwarded-Encrypted: i=1; AFNElJ+gN/2v+lMXLGyKUd/3KoHe2lQOvo5NSil98YpIAr70hGwHu+F8VHz6Svfhxf6J18VNWGYj2qnivZvR@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq5OGRP4QfOMugT0/IJ4E9chEdPIdPHmAL6x9fPdGLnqzx+oku
	gtotJnyPQY89Ig44aEvxCIBqwnXcwP4LQJlphQYkTs3Fntz+eh5Ja8vwtJLBjWSvjb/8kTJwmWY
	AMIkiLyt/8qkP7isM1JMS+V0nIthZ8HSQ4P3OGRGYLxnG5dZ72no6FeU=
X-Gm-Gg: Acq92OEI79HNtizaITCHjWuZVAdLOEhtoQXF5b0PUnXp/iDIUhQXVrx4CvAWpxEy1kZ
	AVuLE+ozIJ304xEOI/ypB7nz7nJGPofYjShp3H1QAIugNy0wyZlRUgiKUOtbP67vP72EM1Cu6K+
	+eKVMmnfhEFe1daVSLn2d7JPMCAhCgMZE1NiK+aW/2FqmNsokJSB2QOTPyRSqYmNHS+Vry9XTjr
	KjH4cu5jWIWMJ6tuuHZL9R6fkhgnXmceWfSkVaHnrckDz3LYZXxZfF1ca9Zqf5aYFZ5ewSKyUvc
	U8nRRCkliSXEsJtKk0Q=
X-Received: by 2002:a2e:be08:0:b0:38b:dd55:b71 with SMTP id
 38308e7fff4ca-396d2a6e020mr9460151fa.20.1780675385674; Fri, 05 Jun 2026
 09:03:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605122019.24146-1-ddiss@suse.de> <20260605122019.24146-2-ddiss@suse.de>
In-Reply-To: <20260605122019.24146-2-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 5 Jun 2026 09:02:54 -0700
X-Gm-Features: AVVi8Cf3Wv1cD6ibsG8ebHzwmFjyXOlkEFG9AwMz2g1A6Wf5XPKkHpRYsroR4vs
Message-ID: <CAPj3X_VQerGwtz2MheM9ESFe9KpZHAsy2UceADTHgJeEekyU9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: target: fix hexadecimal CHAP_I handling
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 5:37=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> A mutual CHAP handshake requires target processing of an initiator-sent
> CHAP_I identifier. The RFC 3720 specification states:
>
>   11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
>   ...
>   CHAP_A=3D<A> CHAP_I=3D<I> CHAP_C=3D<C>
>   ...
>   Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
>   Algorithm, Identifier, Challenge, and Response as defined in
>   [RFC1994], N is a text string, A,A1,A2, and I are numbers
>
> CHAP_I parsing currently calls extract_param(), which returns the
> @identifier string (stripped of any 0b/0B or 0x/0X prefix) and a
> @type which indicates DECIMAL, HEX or BASE64 encoding (based on any
> stripped prefix).
>
> Any HEX encoded CHAP_I string is further processed via:
>   ret =3D kstrtoul(&identifier[2], 0, &id);
> This is incorrect for two reasons:
> * The @identifier string has already been stripped of the 0x/0X prefix,
>   so skipping the first two bytes omits part of the number.
> * The kstrtoul() call specifies a base of 0, which will see
>   &identifier[2] parsed as a decimal, unless a '0x' or (octal) '0' is
>   erroneously present at that offset.
>
> Fix this by passing the (zero-offset) identifier string to kstrtoul()
> along with a base=3D16 parameter. Also add an explicit error handler for
> BASE64 encoding.
>
> Hex-encoded CHAP_I handling can be testing using the libiscsi EncodedI
> test linked below.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Link: https://github.com/sahlberg/libiscsi/pull/473
> Fixes: c3fb804c12bad ("scsi: target: fix hexadecimal CHAP_I handling")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index a3ad2d244dbee..5858cc3089796 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -438,9 +438,11 @@ static int chap_server_compute_hash(
>         }
>
>         if (type =3D=3D HEX)
> -               ret =3D kstrtoul(&identifier[2], 0, &id);
> +               ret =3D kstrtoul(identifier, 16, &id);
> +       else if (type =3D=3D DECIMAL)
> +               ret =3D kstrtoul(identifier, 10, &id);
>         else
> -               ret =3D kstrtoul(identifier, 0, &id);
> +               ret =3D -EINVAL;
>
>         if (ret < 0) {
>                 pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret=
);
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
