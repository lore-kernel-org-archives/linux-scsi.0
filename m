Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4C358379
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 13:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887740; cv=none; b=HiKRSXIaRW1VeNB4wMQ2wTth+h2ihU5VgfDidYFgsFPFaqNNW85pDqrhZ/XsVXSYaloaUdVIxD51k8aYj7ICj/LlhfwP9nZxNAxYnpiV6vDcZvrg3kTg6RNMp8om3IOdXYsBmQaA9xnvZ4o4x1wdakgPgM7CLQaahyNW60tNZrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887740; c=relaxed/simple;
	bh=L4LMy3/5PcD6JOd8qFsTzkz6YlTgBQwkJtsYILkNLkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ltZs3yRLJa1NWWsZpcz5odvu8xDW8DJJtIjEaE7kAj09YRVHJ6xqh0zSNpsOG8I7R82eEznQu5IRFCcFWmNcl92WBsb2/x7wiueWiUYZhNnHfr5geNIeSn+ERd4WCiE1ygzw68RvIj9KPwennoNQiYtBEI4mFwuE/D6907sKJYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-56f70865797so7335522e0c.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779887738; x=1780492538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mhuosztxaYqV9SvM0bBA8kuIl21DSYO1vCjtfXxvD04=;
        b=s4wg7hqBgX/YkXHXyHJ94CbuvteBdgKYeiNGOJzxT44a3XqUC1f3vHV1BsJh4ePwlx
         bkw2z2l0fVjs6yi4pUBaR2NsSf5wZ2NiXOPBLJWxLUy/wZbAvEjmYMA93+oVl8hxq4Xf
         MNCJDvAiDJHJTLOnH2grbk1ENSb1mbkYnJkFYZKs3m/cg2arqnf/0fAnnNff6hGsOgPO
         sQEcIC6rYJHZNcrMrIvXYKHHw/zreEX7xuocrPqNt5ER9gh+jR+4j8GvUnzDevOuIBki
         pTN0AUfAAfLM6F6fNcHvr7ZtoDOb3D/xcO+vdd2fpSAeRWu5gVIse3+4SDYegq0XZpwi
         sijQ==
X-Forwarded-Encrypted: i=1; AFNElJ8eKZ9vzkT0kJqxyhL1K8D6nEzrnw9+QMGFqIVZK619K92XMP8hxFLN/6tgg/oC6rLkscss6xCZSx9g@vger.kernel.org
X-Gm-Message-State: AOJu0YxgMe7QaDZjQX6yE6qxh5DSed0IEVHkTvUJpliShPjw4KIVof4B
	KMylfdgIUk+r1imV4FDay0PjDeuft4N+xKleEDkHeAR2IElvRpMpQNkv0KhIbg8RE8U=
X-Gm-Gg: Acq92OE6h3if2Ejiz3lXLiq2PKYVFfoQ0JzN+iMsCbB905+jqmniZVIzBqzll6CrpgK
	tX8cCqlvDkk6wLotq+25ohFXWPlLR7j0dJx3jBxY+FrXbiJqWJg+2TX7Ksl71VdMAHCLk1xj04I
	Re/tLLFfkQ4ePUdNBACtgiUEBdiLJNgSU/aSQrxstClZ67GPoay3cNvvIIrS4ykKHYkcs39SO/g
	KtGk8l3RfRwGV3Ti9KgCsW6wrEVxRStKpmYk2SmjIBgRC0jumPkrsLTkJqtCeFRA84kcCA4ScBN
	kzyG00g4dSP75SNUjKIPRNEavk9P6Z5NkrXKURYRNec8uzIVbLw3NG5x88Ad/27ffKtFHGwUQi+
	JFDpjxM8mWNYoIW0FdZ25yf5wlMFG+igOgo/X3y/YDfbBFoqNwHVYpngPaIfHwoI2aFWjKwx7aY
	C52k1lC3MOG32TzsboBSrAWvpyIvCbadY5fElkNnpvq2dXa5hhSBpAjbQbLJRQ
X-Received: by 2002:a05:6122:2203:b0:56e:e80c:bb25 with SMTP id 71dfb90a1353d-586649efacfmr13068544e0c.13.1779887737885;
        Wed, 27 May 2026 06:15:37 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-586f791f70esm19930390e0c.10.2026.05.27.06.15.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 06:15:35 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-95d04f205beso8249941241.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:15:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/sWBe9nr2VyeQwMIVp3LvMKm5+GCcZL6aqn1a1ZaUv9fw6uYWbaNyclAOaxF/Sd/pEehfnkAOXZjcg@vger.kernel.org
X-Received: by 2002:a05:6122:1310:b0:56b:1eb:d396 with SMTP id
 71dfb90a1353d-58664ddc313mr12044467e0c.14.1779887734873; Wed, 27 May 2026
 06:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com> <9602004a447b474b15ca1e110d6d3c277f669e20.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <9602004a447b474b15ca1e110d6d3c277f669e20.1779803053.git.u.kleine-koenig@baylibre.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 May 2026 15:15:23 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUWUHRBT-MmHv6bKH5arNZu7MvpxykkHs2Y_VFY=YUnUg@mail.gmail.com>
X-Gm-Features: AVHnY4LQIVhtSrsik3alzJbVavFB4QDxiPF_aBdmr6zoiQVhz2g6cNLGL9_4zEw
Message-ID: <CAMuHMdUWUHRBT-MmHv6bKH5arNZu7MvpxykkHs2Y_VFY=YUnUg@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] scsi: Use named initializer for zorro_device_id
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>, "Christian A. Ehrhardt" <lk@c--e.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2026 at 16:18, Uwe Kleine-K=C3=B6nig (The Capable Hub)
<u.kleine-koenig@baylibre.com> wrote:
> Using named initializers is more explicit and thus easier to parse for a
> human.
>
> It's also more robust to changes in the struct definition. This robustnes=
s
> is relevant for a planned change to struct zorro_device_id that replaces
> .driver_data by an anonymous union.
>
> While touching these arrays, drop explicit zeros from the list terminator=
.
>
> This change doesn't introduce changes to the compiled zorro_device_id
> arrays.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@b=
aylibre.com>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
