Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB13199E92
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 07:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732606665; cv=none; b=nFZ7pTNdyYFJQdvxBxCowm5BfwA6OINQ+5MmWTw68n+a2pMuh77ZtHkFYHh9iZiL5kNdK/mvjcX+E/3sB7MWZsNUP+aJ25fRwixRwBsVILUFrugTkiTAw9Z7QcXzgmltdkcd/Q9L7bj05ZtMpT+Gm/3UGW11IwecsUzgSpkfaE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732606665; c=relaxed/simple;
	bh=8jDEKxLSsx1rwZXC6X2DbXk2k8+102jufOYFQJxOPis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VGRDvXknOc6Xglct9QQQkQ2yodmNrBbOZsDY3UimueSp1RgBwfTH7zEDybDNoc/DUnE3+zDB0a0POAB/aljuitBwfp3dJVyKX+vrQiHHU4N2gduJU3XDNtMNrNAeoMki+t7WhYyVnM3HIlURggo/CwF78tIKkcpWTGFiNrlhZYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=skxwb2c6; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="skxwb2c6"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6ef0c64d75cso18717617b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 23:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732606662; x=1733211462; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzJ8y3qThHAT3ji1jGc3KKyhMYzUDWpdeImJOBfn8s8=;
        b=skxwb2c6/CfrR08MOcrKW5f7IEBEqTvCH1ZLCZ49XTPZMBcOaRhEPgP7WpbH6u0/uR
         mzwL+XA7d6hPiThiMBN6xNdatsXtH+tVrlxB+AjsLUZVi56dVqx8GYPqartCZt1/MqeJ
         M6ZX8x/8a15rQ3zcOGE9jgpGkymFiXq5aJ3XaIDVYxNXZVKQqOoxIOlXfPNoezZL9eL/
         PMUuYZRY8Zm59mzH8WTGIUUroZqwdLoaj77ps3GbpJ4Iv1ekTivd9cAmhwSEVjbyz/A0
         0kMbhp04wIwVtZq1y2GZyjkYs1aWfizScnyLflZxmEWiu+4a5fq0MEwcXCmUL3MEBdr1
         +xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732606662; x=1733211462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzJ8y3qThHAT3ji1jGc3KKyhMYzUDWpdeImJOBfn8s8=;
        b=Xj5UN5YyPHuXkZ9Anby30Q+0aEYf7Upf4AVkXIcJ0eA9mRw2tuE3FJLJ0LGe67+m1p
         6zzNai+PVuagF3IWku0CqapbTOcJl/9XvfCujENgaxPnPgjbH0MrWBRb8HEDQrkbWXBu
         GU3sUEUXOK6iVYt90SE4uFzW1OxHxzojS1sMgphJG5W45IVccwyLm9p23z8lRq0ns3Vr
         sF1McSyb01qkxwTysMZqS0G2JwauJtgYdXV8TJ/phr/3jKLPxtl1fJ5ZnnceRBbwmtAr
         d2oVymwXpmJFgHtNVxJHlnM17uQkm2AoTMTTyVdKpe5JrL+e0mm04CGu0PKbYb0ILdLF
         bRpA==
X-Forwarded-Encrypted: i=1; AJvYcCVaAq0w4NRtyj+4aOS1qyFhweYr0prgFqx8cKPQoJXOzreCKbnrVbtREPA4bbKC07JDL5Fricy+HvFZ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv1sMSAIF3J631VvyQ7lcnaPrJpzEA6VMLWg3vqliBV0H+qZyl
	47XESap+OLU4ZKBKqYsed3gS5TznRp2Sw069VjpPSJ9Olftcg7mnrn/3KCBgzpMaFLOakZoCr9t
	kQHFZdd6Zfg30/vo+QcL3WXKxNLoR8lHaOw3oxA==
X-Gm-Gg: ASbGnctgYR+0oWJ1zKgjDCLWxMoqgsnUdr3gi6Z8nRa/BUYojwkJEuWRAtkUSeRGasS
	awBEffQnYnXAixIuhlUWVjZclvmBJAwg=
X-Google-Smtp-Source: AGHT+IG25CYHixpJ7nOq5l+BobwqKzKUEHt9Mf8gk84f32pc2M+oiSy7++GIyqdSuhvD+RneIJuhEgFfvcnF51MQCdY=
X-Received: by 2002:a05:690c:3386:b0:6ee:a70c:8727 with SMTP id
 00721157ae682-6eee0a2f97cmr145845267b3.41.1732606662315; Mon, 25 Nov 2024
 23:37:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112170050.1612998-3-hch@lst.de> <20241122050419.21973-1-semen.protsenko@linaro.org>
 <20241122120444.GA25679@lst.de> <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com>
 <20241125073658.GA15834@lst.de> <CAPLW+4=kuHze3=+g80CsY6OkLno5gyjRfMWLXTFHu3N_=XcmqA@mail.gmail.com>
 <20241126065253.GB1133@lst.de>
In-Reply-To: <20241126065253.GB1133@lst.de>
From: Sam Protsenko <semen.protsenko@linaro.org>
Date: Tue, 26 Nov 2024 01:37:31 -0600
Message-ID: <CAPLW+4=0Ojg58pa7iFkgY=5S6wr-dYseJVvXL466W+ROAh0r8Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 12:52=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi Sam,
>
> please try the patch below:
>

I can confirm the patch fixes the issue on my side. Please add me to
Cc: if you're going to send the fix. And I'm always available to run
more tests on E850-96 board if you need it.

Thanks!

> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index acdc28756d9d..91b3789f710e 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -685,10 +685,9 @@ static void dd_insert_request(struct blk_mq_hw_ctx *=
hctx, struct request *rq,
>
>         prio =3D ioprio_class_to_prio[ioprio_class];
>         per_prio =3D &dd->per_prio[prio];
> -       if (!rq->elv.priv[0]) {
> +       if (!rq->elv.priv[0])
>                 per_prio->stats.inserted++;
> -               rq->elv.priv[0] =3D (void *)(uintptr_t)1;
> -       }
> +       rq->elv.priv[0] =3D per_prio;
>
>         if (blk_mq_sched_try_insert_merge(q, rq, free))
>                 return;
> @@ -753,18 +752,14 @@ static void dd_prepare_request(struct request *rq)
>   */
>  static void dd_finish_request(struct request *rq)
>  {
> -       struct request_queue *q =3D rq->q;
> -       struct deadline_data *dd =3D q->elevator->elevator_data;
> -       const u8 ioprio_class =3D dd_rq_ioclass(rq);
> -       const enum dd_prio prio =3D ioprio_class_to_prio[ioprio_class];
> -       struct dd_per_prio *per_prio =3D &dd->per_prio[prio];
> +       struct dd_per_prio *per_prio =3D rq->elv.priv[0];
>
>         /*
>          * The block layer core may call dd_finish_request() without havi=
ng
>          * called dd_insert_requests(). Skip requests that bypassed I/O
>          * scheduling. See also blk_mq_request_bypass_insert().
>          */
> -       if (rq->elv.priv[0])
> +       if (per_prio)
>                 atomic_inc(&per_prio->stats.completed);
>  }
>
