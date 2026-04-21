Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE503D75C5
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783993; cv=none; b=Qxk0xwuR2cZHrAsH5EEAkA8ZiFr1eQ2zus/GWM6vFkyIFHNZcP1q161uULVVV1mBMOZsFu0KvfNh6tgkVCKvmQToijXxhg5VTL3hwSANPFJzHyjz5HpVySLV+kjiujZaaxT9Izc3qzCfKC6fH42dJg9pcIR+yzqTjH0NXvMUzYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783993; c=relaxed/simple;
	bh=jilRUhRHmvWuJCoyiVwTkeqntyrgIYiazzCTLNIEVTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WmNhlPxhKwcdKrlMlof8rQOD+HJ7EzzkVNejYzDkto0irAfvfTzpabwxXwZ/HarlyQt1P+Ky9jiAtbtZmvGL1CPdXS5gwq1L/hOypsoa2i09+ZDQJsi2mSdUGhgXoUOpKX15EYuotvE6lojgA6kxzcLg/WeKtYpS4cuxU+6WFRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GLdIHZuV; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GLdIHZuV"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67482e67171so6830802a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776783990; x=1777388790; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WqgWh8dfK2Y4qahlmdpm3AeC6QQaUGPJVn/5oM/lmag=;
        b=GLdIHZuVbB4OU+ZRkCcWso2NLu++z+S4ft20vSn0WvWkd5mc9Ra4cMsygp0yilum6I
         d6cnx3G6ov/rq2xQv2s3TM0JTqmmX0P7H1BbQjB4v4/dssBdFJLF6MS9oCSipd2wB074
         zauUY/esrxuFIKrqGNVrLYw4lg4BpMdX+WqMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776783990; x=1777388790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqgWh8dfK2Y4qahlmdpm3AeC6QQaUGPJVn/5oM/lmag=;
        b=fZZK1L6oTDaQAkOhb/tyaZAk0f9/Vdy52HiwnOqr40bshofqttB9upHb6nnXfl2gDf
         JLqpESpOQnm2T3S7YU17WrgB91y4AHTBK+wMS+42NTPn1CvsgwI+df5kmNFgGB1sT1xT
         Zrj57/T1/fIF1crNpAWPJcyThJ8hFTDmCraOPzTNN9KhQEwEYOeyAx/r8oqt1XIzPFGd
         Ux7Tz6UWtG+Fay2l/6aYDhEIFMGCd2LG2VjtNA8Ywb10cEgKIwf2uKGeOIN0fu6USnTa
         WkvLfxzjTPwcjWsH4UFfTNacnNC+T3T8ucmf8anEI7MU4vFqUSG15U6O+QNAuBwnG8Lg
         RjoA==
X-Forwarded-Encrypted: i=1; AFNElJ+D1DamZdYTkMJ1FJoNw1/iXHC+6EJ9Knkaa2DV1Ct9ZcdpDnyROBrVMXHWNZWgkycdgwp7V9OMSiHw@vger.kernel.org
X-Gm-Message-State: AOJu0YyTXuCbTpoSI7EqlOWR4SGTVuce7bwApf4M4Yp9/L9Au6cMK31/
	mWyRGn9UVZJkuu4GFN/u8pIJUEEyd2lL7rkVVutxMV5Z/L3ZBoo0VOzkU86QJRbShpAwIRJRUHo
	RObmZR+Y=
X-Gm-Gg: AeBDievxM1q2rkfLXrWQEeqNDvHKld4tckB/jQ/6pHLt6zuat9D1gYA70FZBUhmb5Qg
	OkNUlB3Gm85SKzoV1uhGHJa7i8whjNWuPXV50jHtYThRySNRmU8K1MCSk3Xy0raNDtRQ6t2p+Gk
	N5Tt17ziR5H0vkrmTG0xKr4ehia9g+NBiYHv9JbPJ8n+dOgLwjVyC+8kbcQERB2x+gcVw5a6EcY
	ivOV5I3Gr06FRv4+AzD0JZglY8NNFlgwxW7ZvuYm348nm4SmuUDqMF6LRUdo1xtSyCRc6RlHc7E
	4xb4dolE81baJCbEeGyw2RhSNLgkvCNeZO2e0u3Zooi4QTckp9UJWfRriY/3tQuV6O88dUodN3q
	40l4osCbeZ8iI+a2U/kUjrXs7rek7odWiukKicjfUmVBUZAkLNcQobfNypXFprnoIND9Mb/Ybu4
	YDPsanzogs+tTdvCP91yg3Gmi34Zfgk6Ju90M6OiQyhu+vnoNhY8kYJp0RR2k1L/fGGv7STUTNM
	Jvmbw9nz8zhJwLLPKRgRg==
X-Received: by 2002:a17:907:3f27:b0:ba4:e5e5:58b4 with SMTP id a640c23a62f3a-ba4e5e55b50mr837883266b.20.1776783989900;
        Tue, 21 Apr 2026 08:06:29 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba451211010sm471872466b.1.2026.04.21.08.06.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 08:06:29 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-671d60ef9c6so5599953a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:06:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8tG5B0LTJFSqbxUChiCJ7hUej7VkAr5r1DzCW/aQlCxMjkt+b5jQ0ZEqy3QRgHyqax0sbmTLpjAnPL@vger.kernel.org
X-Received: by 2002:a05:6402:13cf:b0:66b:e8e5:4628 with SMTP id
 4fb4d7f45d1cf-672bfdd8b9emr8662307a12.20.1776783989121; Tue, 21 Apr 2026
 08:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420165721.21651-1-James.Bottomley@HansenPartnership.com>
In-Reply-To: <20260420165721.21651-1-James.Bottomley@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Apr 2026 08:06:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgW9wRVQ29zBjDXvLPZV2F_qTwf7D=uQV4ZmbvbmGOT2g@mail.gmail.com>
X-Gm-Features: AQROBzBmd_CI59Mz968Z9HkrFgigp-DN4oPZaeLKr0-LA-Pq2HXyXMFEIxI5JaA
Message-ID: <CAHk-=wgW9wRVQ29zBjDXvLPZV2F_qTwf7D=uQV4ZmbvbmGOT2g@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI updates for the 7.0+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Apr 2026 at 09:57, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Nope, nothing there. That tag is from the 7.0 merge window.

And you didn't use a proper full git pull-request, so I don't know
what SHA1 you expected top-of-tree to be in case it's there with a
different name, and I'm not going to start guessing.

                Linus
