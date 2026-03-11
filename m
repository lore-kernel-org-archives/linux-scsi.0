Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A233C1402
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 09:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221044; cv=pass; b=KIR/eZciI/eMg2LQ0ac5Hi6bOwmqsRZRFykVtFUpwmfUC3ETP/d2DsA8p1C3PDFB/xe8GNZJeQyjnOf++cV4c/woU0eZ6oCzIE8USnDrkdg88z0YxE4gG+a61NDNmdBuc4cSYCvz/Tus8X47MQz3aXkPs2iyTDEjOwMSx0fS7zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221044; c=relaxed/simple;
	bh=wrK4Ebc+SYStWqsyJG63tplrB9U5+H197FZi0IEbcuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9jxVYnKmFc+RHk5G8nLRAnsubMCxxkcVcd21dAX5MxEceaCtCnkUv3ohyPysm5BPLqWBTiN93VZRRtBSFW6+XsMCbtzYabhwJgsMJNJhnacqmiC6CrQuqH4ngncESs3k1NFklffyP+UfCJAlEqII97MmGCjOqb6bVn924kR8iA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5//4KiB; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5//4KiB"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50917e02532so41096831cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 02:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773221040; cv=none;
        d=google.com; s=arc-20240605;
        b=L8ZOjUEtmFTMJJlme9cvt48fbUdmWOxo2MsoZsYs13/UyA71M7XEmbF5CWQj17UEsG
         2jL84z6onMro/RewzMKgOn/Of+s7pC1UNG1knduPL53zTrd4mL6hoiVmnw6yy5DYiS2p
         Ged/4oJIz7BxjijaCVTS6mymWLU6Am6ftxzM7kDd2TXfg6NvQPdra5oRTfSbzPQ9SuDz
         EP8v9bRqOXh2FNh3VAg1Yzq7ayZJAp+ljY+D+jTmfowynPi/PM+qmvx6f+uib35C+eRz
         88PCziw1ZOj6TZpFbCrPfqAf0+euBNcZLC4zfevQ14ChVxFeQE3D9nK1Fc4aJyuBcUJx
         qWZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wrK4Ebc+SYStWqsyJG63tplrB9U5+H197FZi0IEbcuQ=;
        fh=0fWhybFVrfzXQ/aYaKKExK5LTU32Jovikss291PzOjo=;
        b=TFyhmM3Y1nj7IjFaE0wkDLqjlkdiOEVXPXvBqdOqHO+djl/V/SkT0sN32q65rGLaWG
         +bLBPLgr+xBc6shx6mgjM4bvsNJDWUjKDg03vNcUXpMHt0bgBucg4fvU4ZzHu2mOQ/ee
         wc7ZFkyASzk3aMiyS66pKSdaZX5R+aJUvcdMSIiqtdtBXVB7hBGWJlO6uMinPs+gIQT5
         cnKW13Y00ARexduxtbLilD5NES7mWG9uuwl2MBURBXRBGloHrsJRnXOrjssEkcSxKyz/
         xRfepZ2iJBJ5PJf8/+pZ8+KI2MaPhOPG7estxs31rCr5ZFfqsiy4qHxgXqntsvGV3ICv
         V35w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773221040; x=1773825840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wrK4Ebc+SYStWqsyJG63tplrB9U5+H197FZi0IEbcuQ=;
        b=K5//4KiB39gg9ObAffMRPzaR0c/kLCGNQjjkHS3jQJzr6Iy39nmguGnhfx/nbDz2G7
         9Fpb8+YYe30JIHkdEouq6XseRJYZZDmBTfo7Dyv2QJxYxfZFKHZUw7XKnPOb8o/6fIB6
         P1WdbRoS1lbuFMI6sYPdCH4clGOCsPjnK36CRULTHTigPNhbwg+0220egDMbqDA3okWZ
         tPfi2uGPCSPWO0QEn/K42U33FIcBtlQhTPBq/Q0om1ioinCCxF5Avb5iA9hwa217/r5T
         p2EpNEI8yEjkFtEoVkHETHx2/U0hqGLRWSHNkv0puvMWuezaRbwZSWbCs9/ybA5PKu/6
         q6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221040; x=1773825840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wrK4Ebc+SYStWqsyJG63tplrB9U5+H197FZi0IEbcuQ=;
        b=B1n4m+gpA0QI5Qom5VuunFKd95yzCITwnKrnVmNd7Ye8Z68yE+Erz2HRmcR9k+QsZw
         TYQMpLpVWo9R1vozD+SL5dozt+cUZxft5goYKmboEvwFTRhdGbK3u6ROmu3fnvO+Wp9c
         vQrUq8uG2sWrdTWwU5fCT1o5EwAWYsaCp6s1l3xXP4dqy41qBNc+/Rk4ifJxDAz1Vfjs
         TiPjThn0YD6zZgDLhXlyi0vwpkIAoPkXWn3oZxv4QHYm42QHNkM/EUxeEFIKnXN9rp1N
         oKgt1rnl+FzYO9Tjlsxa3VjsrSw2Z1VGx3HxYj7U6j6vplKPTX1yqyswuzHDjjC7Wzmr
         05dg==
X-Forwarded-Encrypted: i=1; AJvYcCWaGPl8uM7L8GOZOnovtW9hPmlFc4BL3+ELfCoe9u8X7sf0TeqrY6/BxL5FwGmsiQ7Q+h/QeEuNY3c2@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1QH2KycsPVZXnMlbKh/HGBrrHn80HGzq1GtuqynZicHcfq+hl
	oEe1nnTpDhEqgA996mvDGJebmPU8s87zC4vamPEmAdM8Rz+oh3gSPCMkoXiMIk00PB8yxXbKjn7
	ZDZ2/LZewEc5rPlInXgJrT6eHpiDmtEk=
X-Gm-Gg: ATEYQzwVTTsr8WbNTv35aTQdHTCLpGlujHtvcpcG6HOIKdQgLNwqvYWPfxGvvX3DjJh
	+dqLXMB+hvuG329qIUsAx3P3T8zvUdAo0OYiH1uGz89GFt+e3EGSqtxRc05PqN0sEESzN9DPWSM
	cvKZTSZ93/RQKxqoDPW38NCfsBRbgf1Zi0MTB8z96tsSWpXIw5TjzXeRWh3JYarc9MswChqDIAD
	hz4qBTbZ4Yz5Stj0xqqzRxQyAmQxRxJeJ2mbMeT9l/n0vhoQ+NBXsA7tSbbSyaeM3By9/SWRieV
	qTptkmDgBy8w1f0UPRJq0Q==
X-Received: by 2002:a05:622a:1193:b0:509:2a00:4283 with SMTP id
 d75a77b69052e-5093a1dbd17mr21113261cf.75.1773221040321; Wed, 11 Mar 2026
 02:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310005230.4001904-2-ed.tsai@mediatek.com> <20260310005230.4001904-4-ed.tsai@mediatek.com>
In-Reply-To: <20260310005230.4001904-4-ed.tsai@mediatek.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 11 Mar 2026 20:23:48 +1100
X-Gm-Features: AaiRm51_8cV-ZC96Wbr95oK6RdVpyL1SwORArnS0Chyc1w1UnqmozKo680oVYNs
Message-ID: <CAGRGNgV1jcBGoUzksRMANzm2Ae130zoN2HovqHkKe0Wp-P6J5A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ufs: core: Add quirks for VCC ramp-up delay
To: ed.tsai@mediatek.com
Cc: bvanassche@acm.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	wsd_upstream@mediatek.com, peter.wang@mediatek.com, alice.chao@mediatek.com, 
	naomi.chu@mediatek.com, chun-hung.wu@mediatek.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ed,

On Tue, Mar 10, 2026 at 11:55=E2=80=AFAM <ed.tsai@mediatek.com> wrote:
>
> From: Ed Tsai <ed.tsai@mediatek.com>
>
> On some platforms, the VCC regulator has a slow ramp-up time. Add a
> delay after enabling VCC to ensure voltage has fully stabilized before
> we enable the clocks.

I believe the regulator core has support for ramp delays and settling
time and all that sort of thing on regulators, so why isn't this just
some settings in the affected device's devicetree?

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
