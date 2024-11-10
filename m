Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E5B83CC7
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731260534; cv=none; b=kOJjzhtPtG0M6EAAE3fHHlcpjfUSSgw/JMGLkjvEWkFKEV7s4lO5n78RzRP/etbU3LCnJfixqWa/2sVmvfVUYyEiUA+4ltCaLuGY8VAN4Z4V0JuegJH1frnpemQnTjIJQIoijnkl0qdEE2eow4DXE8GM6r/pmPCatHhWq818U5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731260534; c=relaxed/simple;
	bh=Mos41gW9zZa8aaOv9OGBi91N6PQRijzcCyvXl6gALYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doZLp01iGbL8DW/YlOcsemL6K0eIBPsTxEGmwpYjYsJTI+iPL9ZTeOZWNtUxxfihISToB/xoB5rzkGIWB60UV1zeblh6JHYKqrDx+uaw7p/p8ZS0cuxq/tRcvSBnMrG1o/puMH25XwZmeUbav3hD73TzxWvkMrbcwXE8Tfj2nZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PHS1QAWu; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PHS1QAWu"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ceca0ec4e7so4951821a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 09:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731260531; x=1731865331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XDdU4RQExPTTq4lGqkzL1Ixf9yaDmAVrOxLjoL28ROM=;
        b=PHS1QAWu2e1pbbijx2swfl9NOT0TFUjJgV/sXSrZMsPERi3nOh5ocIJExy0lQCZ/xa
         Z+kBsf7C9e8ZCvSC+FMV8sjbUH+YazH6UWciHl+iadbfgomToJQ9ujR1JJyHDavRlSWD
         B6PXnNMorMiWwt+RxLddwSrA4smXFUP4JDCp5Gnj0KfVavBwpaf27OZOgp5E1Fku85di
         c/G3PIO64oQRzYAqhQOplb/YDc2YE1r1a2m3+lwV2UywEIENQPjFboO6j9kWCJyb/QNJ
         rypyA8ijHwG/50Ves3tToPIgFFZo3mehb3MLI9NSEj/1MQ3syNjw7AWWCLD6xqZq1EQT
         50eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731260531; x=1731865331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XDdU4RQExPTTq4lGqkzL1Ixf9yaDmAVrOxLjoL28ROM=;
        b=hhNY/j8FuIDeg5ZN1wmROZcSPO0e/JHwR9EOC4fHj7mLgIkMS33LwSPEQiDMqwMwci
         eJTc2RbSeL6csw6DXl54ElAYCwbfFyUn+1hFIGDUf+WDx413SZ0fdI/rMW2Vidnj4+WC
         mhbhGLrxwm6ubrP3DFJZ/o+apkXpe03CX28eTVfbvyHtnBVqdAfxaaamgYQ3nn5UJ8H2
         twcLAR6IfthAo6YuedVKT9gb3vMz5uoJFlvy39J6MbXnYjgWiRuXXv+KL8E8CgSvyERI
         o5yDOqXgAiounN5UvNQlb0Zu8Jp9MRgeUgitb1lQFUC4ocNy1qp7qJGE0gm1hjSXwvAr
         iKTg==
X-Forwarded-Encrypted: i=1; AJvYcCUXHp01nQjHdT/8XnbldLkmWX53t5adtq2yKGZoe/v0KbjjH/amtBlmRoPDy/OhT65PRoPTGzvByJnO@vger.kernel.org
X-Gm-Message-State: AOJu0YzZp7svJwJ1qfbvXBZxPKfa0Z/TeKecw1nT7BxveuTcng/jow4S
	ui6qAjrEN4BN24bmJF17hoHqSqi0ksMBnGRVpnxkORsBOKLnFmTHo3jLI78ZSUML9M/T6nyBj35
	Xre3fwk4pOXZgplPvyMMFTKs7iE55KjdnG5Q=
X-Google-Smtp-Source: AGHT+IG7RXPojOrk1zSgkdMsH9Vp0i0ecCAeIL3mRHLYRq998XV3zulkbSJy6rDztoFgcOFefIfzlJ6sdzYAVnHTnLU=
X-Received: by 2002:aa7:cb07:0:b0:5ce:dfe7:97c8 with SMTP id
 4fb4d7f45d1cf-5cf0a4465f8mr6342768a12.31.1731260530361; Sun, 10 Nov 2024
 09:42:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
 <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
 <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
 <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com> <20241105223319.46c7563a@samweis>
 <CA+=Fv5St4uQC00KF9YtU6WCHnHDO-NeMJ6er5aB86wgq4ZDxWQ@mail.gmail.com> <alpine.DEB.2.21.2411091958520.9262@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2411091958520.9262@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 10 Nov 2024 18:41:59 +0100
Message-ID: <CA+=Fv5QjuRsqWFPfX99YPoDMyUTx52maQ=2xNmjHpu-oE8ZWnQ@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2024 at 4:59=E2=80=AFPM Maciej W. Rozycki <macro@orcam.me.u=
k> wrote:

>  It's not required for the mask returned by dma_get_required_mask() to be
> 32-bit, so unless your card does support DAC (and everything so far shows
> it does not), it will still fail on another platform where the function
> does return a mask beyond 32 bits.
>

I guess that's right, It might still break then if DMA_BIT_MASK is set
> 32bits on other platforms

>  Are you able to verify your card with a non-Alpha system that has memory
> beyond the low 32-bit DMA space?  I guess not, or you'd have done that
> already, wouldn't you?
>

No, I don't, my other systems are either PCIe or have less than 4GB RAM.
I might be able to get my hands on a HP Z440 which I've been told has
one 32-bit PCI slot.

>  If you really wanted to double-check your Alpha correctly supports DAC,
> you could try wiring your ISP1080 device temporarily via a 32-bit PCI
> riser adapter (or an external 32-bit PCI enclosure) so as to force 64-bit
> addressing via AD[31:0] lines only (assuming that ISP1080 got DAC support
> right though).


From the Tsunami paper:

"The DMA monster window is enabled by PCTL<MWIN>. If enabled, this window l=
ies
from 100.0000.0000 to 100.FFFF.FFFF, which requires a dual-address cycle (D=
AC)
access from the PCI bus. This window maps to system memory as defined
in Section 10.1.4"

I interpret this as in order to make the 1080 work DAC is actually
needed/used even when in a 64-bit slot?
Since we're using the "Monster window". From this I'm thinking DAC
works on my ES40 Alpha.

Magnus
