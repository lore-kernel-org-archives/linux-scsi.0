Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66BB52F280
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072910; cv=none; b=i0IA6PNc9EGqUNWdIStcsuyMEtTFOhTh3A6qoA7l61hTzdgUeEuP+yD3U/4n3DS+Goq6LGqqNr3B7DP/5IvJHkUt4J/Qrze28iGEeg1ndfTcLXQ/lxZgZWW1bd61XNVm8okworntFx+r20ktRkcHlA/JIp+OMKSoLn/0fihFjaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072910; c=relaxed/simple;
	bh=F9D4NtGx2BASRaM0QdP9rN+CHp9G1qOy0hyNSwDNx9k=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BEDAZu8xMbnZb+LZO6DZ/b7OyLT6iJz94gnORZLmqU9AT/QNm9v6+c/fgIte3mTBq0zZOn5TFY0RrqD+cT0tA6NJm2AlSGpQXvQ/aTmayYprhqToJWBHQdkvBu6vj9Pus15NoEqvLOnHTFaL3qzkjHBzPIxAtJvRKYm7Z+Wndsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tBsOpp9j; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBsOpp9j"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2dd76b1361dso15000715ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792072908; x=1792677708; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LY9l4g61tf1ixC3MFomKzzwAunnhCUNKSY6ylI9RPFQ=;
        b=tBsOpp9joQt+uFufsoQI0A2eWFco/4ZvcyPDHR5Pk1Hrua9gEHqzDDdRUDwlrpDV9+
         p1Lm0PJhnv/ATzusAVdOYmAXNsi9m1uYhL/a8WImsxF6sfXmAIWcbrGX2ZlEpBNaseMR
         snMh+R1O0yqc0Otuo4YjvnCx1WZ0R7NIFWIV3H5inilDOi9WJDWZJ6Ea92DfVAiMXhn5
         Stz6LPRaXWMRkZRbXjqg/hilcCz2TNRGgqbtLYtknCYnjs+3TasyPFtKu4QXFmmwU3h1
         EM+wOX8t3Ce4QVa2LVKGyHQBDKOnv0R42KXsIv1N0HETc5t0Rvo0NWCW1LpHcI4A33D9
         DBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792072908; x=1792677708;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LY9l4g61tf1ixC3MFomKzzwAunnhCUNKSY6ylI9RPFQ=;
        b=zTumGQ8CuS5CTXiVJH1S8Ls4+JoLQIjgPrV6+65nhO1AT77brB6fIlgt4AZvmiTMg4
         zBsRsSGO98oTV1FqtTEy+irc1te2kgcWy+PoC6NjTbuz7PMIhtmXJTkfTxwLwB2+PDXV
         4EHrtilDOxxXd6Bdtpb0ZxhUHuXsuL6lkes7/wk1rR56OF8yDVmOu9Misja5g8JuyM+q
         w6+LWV8Zc9X/E0mDkQdbvYj7pOYG1TTdt3UjqwJkIb1A91r811hHIoKjLH/hPb7VAQHj
         q93S5Crlc4nPSIcOuWnQrKE2KW2QhFfk6qh6/LS5SQ4YvPFp8PRbYl5C6JGGprqushc6
         CFhw==
X-Forwarded-Encrypted: i=1; AKwUvBzI6Rd+y4h6UPX66SUA4BiBXEZ+Kgs+oq1dk36ZCTHYbJ+hhvAbhTQFsFy/ivdYdOX0DvWS25gqaO9B@vger.kernel.org
X-Gm-Message-State: AFq9FYILBWNQgf5CFiOXd0gMpYe6IyJvpMx+eySfg+nfJtNrdTYO5GjL
	CzYk86/tA4jebfHmKtdaoh6+87+L8LTQWhFZDkxeG5Oi9sx+AMbgRJRs
X-Gm-Gg: AYBFou21Oi5vs+v0u//Pn1Ft/omSFIiN7AwnHB8KaVBWvXEigYNwTYHiVwhI0qwE5py
	HOBO2ykK9xemzu2R1izQFSX2criF9D84488XCP7w+dmVZdeLyCMRx6ge1ePEsGMmZzZ1Ppcu9Bm
	ehYSfq6uV2g3+DasllDdVubnNJoX0Sk+OlaIruXIGKnTOQS0jnc64s+9wepNn09B5uJxLvqYcJd
	K5WQh3nv2XJpAP91nR3sCZXO6MqFhYOnpa3MW+ppEoH1W9CJmXjUYTNekQ19uFe7K3KbBgPfYJk
	X5DUbiA0PCgTxbGBqW6P8YTpwoAK/KlIQOS9xOSLdrU4XJ8WycVApfqpK7MK1e3RPxZ6E3eqYys
	+Bufo6NAWh16vkZhZfqN+1jVrF8Xklk/oFDxlIoLNgvLtC/Hyogojw8TMr8ok/VcLejsoMuybJ3
	WZ6ylJOY1uwwZTFxIiOP3YQ1T2bE12gAr7KWPIOA5fyzPnleM/+es9Z8t+vFdVx2ZS4sN8fA==
X-Received: by 2002:a17:903:2309:b0:2e5:38bf:cb43 with SMTP id d9443c01a7336-2e8427f0c01mr176866815ad.2.1792072907655;
        Thu, 15 Oct 2026 07:01:47 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e94ba30f6asm16779985ad.57.2026.10.15.07.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:01:46 -0700 (PDT)
Message-ID: <6ad0dcca.e4f0a24b.cac3b.c1fe@mx.google.com>
Date: Thu, 15 Oct 2026 07:01:46 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
 Martin K . Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
 Marco Scardovi <scardracs@disroot.org>, sashiko-reviews@lists.linux.dev
Subject: Re: [RFC v9 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
In-Reply-To: <20261015115043.GA1863739@google.com>
References: <20260925134010.2815025-1-nbg2974@gmail.com>
 <20260925134010.2815025-2-nbg2974@gmail.com>
 <179198503855.839288.7797731903424311774@kernel.org>
 <20261015115043.GA1863739@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 15 Oct 2026, Lee Jones wrote:

> A driver source file without 'Kconfig' or 'Makefile' integration is dead co=
de in
> the tree.  Either wire it up now or hold off on submitting until the rest o=
f the
> pieces are ready.

v10 wires it up: the drivers/leds/rgb/Kconfig and Makefile entries
are in, and the series is posted as a new thread under the same
subject.

Your 25 Sep note never reached me: neither it nor the copy
kernel.org relayed on 14 Oct is in any folder of my mailbox. I
first saw its content today, quoted in this mail. The three week
gap was delivery, not silence; this is my first chance to answer
it.

> Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
> - [Low] leds: asus-aura-scsi: undefined function kzalloc_obj() causes build=
 failure
> - [Low] leds: asus-aura-scsi: blk_rq_map_kern() missing required request_qu=
eue argument
> - [Low] leds: asus-aura-scsi: strscpy() called with missing size argument
>
> Was this even tested?

Yes. The driver builds with clang (LLVM=3D1) against 7.2.4 with zero
warnings, loads on the enclosure, and was exercised today: the four
LED zones driven to independent colours and checked by eye, 60
sequential and 100 concurrent updates, the sdev deleted mid-write
(zero splats, clean detach), rmmod, and a fresh attach through a
host scan.

All three findings assume a tree older than v7.0:

- kzalloc_obj() has existed since v7.0 (Kees Cook's series,
  include/linux/slab.h).
- blk_rq_map_kern() takes four arguments on current kernels; the
  queue comes from the request itself, and scsi_execute_cmd()
  calls it the same way.
- strscpy() with two arguments is backed by __strscpy0 in
  include/linux/string.h, which infers sizeof(dst) and rejects
  non-array destinations. v10 passes the size explicitly anyway,
  since it costs nothing.

kzalloc_obj() has now been reported by the bot in all nine of
its reviews and blk_rq_map_kern() in eight, and the answer has
not changed since the first time. If sashiko could review
against a current tree, or drop those two checks, the noise
would stop.

Best regards,
Liang
