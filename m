Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53364221DAE
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784855441; cv=pass; b=lu11fL7GuESUJf6m5yL5aipFypQpj6DpVDpx1GPN+hU8W2xIel7W77ORUVJn7J0lzGMNYbD0ht2apMjvpr96mYgyWzMzSWzXP6bwBPvxpgf4bDD+sEyizPm8l6LsRycoIJ43snvroRMMd554aO/wWGgBiKSl5c9Aa9WqVoLeiK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784855441; c=relaxed/simple;
	bh=cBMihjtfnzn8xCdItbkni5HmOZKExq/gd6xSmOtgIxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HV1+SXQxIPtCLklZvKv7zlgyq7+s9vYC2vpNzGQWVTvyg/3/qT1kmwy+MGlymIKfxYxF/T0lkEAvDHI1X4uWAQhaObZMDt7r/6/yONP0Eygp6Xj+sZSvSftryMVYAfX2Ihz4zdhvTCsNh6/oxa8meutkK2IqVjQOAEx+Eu4HqbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PcOXBiIV; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PcOXBiIV"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7ee35c08c3cso194234a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784855438; cv=none;
        d=google.com; s=arc-20260327;
        b=rxlwg/M/X3PhKBFLVFCJkueNDMLp3cNbsAzBVpGPxXdtbcJKkv9kdaK2S3ef+xZ7xl
         OG6DVzzEY1Q0aj1A0xyNnGxPzIACoT3QX5D6KVZ4Q9KElHUGwxIr7Kds9u7oXC5+hnk5
         /hrQ8U7t8P48a9h0N5RSWt1f0c5tQloIiHqVYxGF0f48twjIJmHNN0moOMUL9OhvHf11
         0/wdMVkS6wlIzLR/sLBUnHQORCC5VZtSFGxFZQ+rrMd/ko5FpATs+3ZDLtYWAAC6TOZD
         4DDgU4bIeD1OmtMqx9tVVBDCjkoMOvu1Li6AgvgVa6vaKEaodnSwuSQFAJionk1nkhwR
         gHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YjEvrw98k2bIS+MXJKjl1OOCntzqCiFfo9x9NFJokR8=;
        fh=4ky2sVChZWTqZZx8vnlAx/m4VYl3KVFENqmL0yG0cgY=;
        b=M07uSq0Cl8S+wWip9Z0jqF3PkD3FkrCZLI5KRNgDUEeDt9IHUOgGNyJxeHp+YRsrDt
         KIX557YjRYo9qm3AiB/b7EskHKI+Dd/wLYXk6Pc4N8voxfXxoJ9si8oYGmzFGcp2wnc5
         iUVTRJy38s814CjGAVWkLtvKERSpa4CQ1gSVmBYScM/h7vD1KwjHPoek36Ckx8u3GVSM
         n1hNpjsBxhf2vKEu3IWq77Obfz9+n6W6zJdsHvO8lRgA8G8tqP8XCQNPil9JOrHJV9if
         /KTHRd9aFYR0kr/UXutaGqGwBWJy2DzaULWhTmaSVrbneF/GcNg5MK0wayEXA1kP/mVx
         nNUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1784855438; x=1785460238; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YjEvrw98k2bIS+MXJKjl1OOCntzqCiFfo9x9NFJokR8=;
        b=PcOXBiIVNanJ2SeRbAJAvB2WeJSTfNHdJfeocsPPmkH0hCwgEY5acewlbR+rMhBsd2
         vWAS6HR/H1wQNJCAZqUBC/OOBKCqGIuOvbXmiVdDVkoPkSuLq+8PzpqHqTu/L+uj4y+R
         lFpXz0YJG5hLU5OMOoZ+VPZIA2FkOQazlKsLpqBSavMeCWUyTrT29fbtCoUNVKJ9AAdW
         pbulT0pW70tSvWSze1kt+7aaVX792sh1PcZXR119t3sSyGSQz1aXbhBXiGH+apf+ivJo
         k8fBgFEep0NRb32kqXrpV1xsKk0FSsd9YyF8EEjq8+DvQm7p/Z27jXse1/wH3JmA2v5H
         fTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784855438; x=1785460238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YjEvrw98k2bIS+MXJKjl1OOCntzqCiFfo9x9NFJokR8=;
        b=oEzfwBLIUxLZwI5fQ3316zbWciZHPL7xo7fjx6bMqLFEott05wuGdD+iYugkOk4Pdy
         Zylpez3gzXfP91pujajdjYYA4WI3OZecxlAs3yT6CcCF5eOCkjQy7DAfTUq+9OC1fmGy
         3pinzICjx8AfW+U9DWGhzlPsvZDAosFuzBF4e+dCcpS/lHAdwInnbaFsH7YsrEJFZN2R
         Y2GpDIQZ09UbhT1XHuvewSm04r2Rc0vZfshRrzJexJK0qey//UFnE/hNfxsSsR00yOME
         I095X2TXG5/Gc8xFZXpK4WuupH7vkW2IBYbLRXxIcm6ezhdvJbu/I4vERTN7H8HEY5zG
         GQcQ==
X-Forwarded-Encrypted: i=1; AHgh+RqpptOncJufV8FkaqXcw2VsqrUdHIwaSubPa7XdSWRnWuGZFEwtgvKPyCXN/yT2ktRh55ABUUpVm68e@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz9D1Ll0maM9zrqFWst9F25K8XQfw+YiTI8OwGJg4RNWASxR04
	YzzM1FuYnE08RpkrP6MCLsVDby0SoxJSgyNhY8Wk9YbpaViemdn8lQDginPh3OAiKjFjAR/wEhm
	KkVlpqei+HnViXw0+jscxFoNPAQc+YYIF3W0uyfSTfA==
X-Gm-Gg: AR+sD103hCk+uL6QOw25cTHnfyh1x38S7dSKt4ODxOF08tdX1EGn7ig5Y7wiWj5bIBb
	Vl4FsICXlhzQ75KKCZNtbIvxhhPSE3CdviylHEtw/s/sQpbw4k0dZPaQOEEY1+v3oImAe2CMXgD
	jLZzP+wlG5W7Vc4lElNOIa0k1QoMFWV9OiZqBldR2eMMj6E/XDeeI0/t3/3U0pb/aIJE55Op5TE
	f/X1waLi5KXt9J2eFAqtzGep8pDy4rGrP7h+6z6KMyuz8W9bFwIH4kGQyVIzgU=
X-Received: by 2002:a05:6808:120c:b0:4a4:866:c1c5 with SMTP id
 5614622812f47-4ab487a32e4mr763595b6e.2.1784855438121; Thu, 23 Jul 2026
 18:10:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
 <20260720032338.461681-2-yangxiuwei@kylinos.cn> <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com>
 <20260724004907.2742329-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20260724004907.2742329-1-yangxiuwei@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 23 Jul 2026 18:10:27 -0700
X-Gm-Features: AUfX_mzxjwAB-owwzf9zzBMmhMb1g2JJjyr46qdZmeRBMmcP4vb96w1zCZX3oAo
Message-ID: <CADUfDZpsTH7zU4gyVE11R9GxdadjbcrcGVX+btoEjRYS-tBiGQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	rc@rexion.ai, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, 
	bvanassche@acm.org, linux-scsi@vger.kernel.org, io-uring@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 5:50=E2=80=AFPM Yang Xiuwei <yangxiuwei@kylinos.cn>=
 wrote:
>
> Hi Caleb,
>
> On Thu, Jul 23, 2026 at 09:56:08AM -0700, Caleb Sander Mateos wrote:
> > cmd->max_response_len is passed through here, shouldn't it be accessed
> > using READ_ONCE() too? Omitting READ_ONCE() only seems safe for values
> > that are ignored (except for a possible check that they match a fixed
> > value).
> >
> > Ditto for cmd->timeout_ms later in this function.
>
> timeout_ms is the example Jens already called out as not mattering if
> userspace rewrites the SQE:
>
>   https://lore.kernel.org/r/55f36cc5-a013-4960-8787-fbdf4b4d0c20@kernel.d=
k
>
> max_response_len is similar here: we clamp with
> min(..., SCSI_SENSE_BUFFERSIZE), so it cannot overflow the sense
> buffer. Same idea for response.

I don't think that's true. Without READ_ONCE(), the compiler can
assume no other thread will concurrently write cmd->max_response_len
(else it would be UB). So it's allowed to load it multiple times:
cmd->max_response_len ? min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE)
                      : SCSI_SENSE_BUFFERSIZE
becomes
cmd->max_response_len ? (cmd->max_response_len < SCSI_SENSE_BUFFERSIZE ?
                         cmd->max_response_len : SCSI_SENSE_BUFFERSIZE)
                      : SCSI_SENSE_BUFFERSIZE
And if cmd->max_response_len changes between the second and third
loads, this could definitely evaluate to a value greater than
SCSI_SENSE_BUFFERSIZE.

Best,
Caleb
