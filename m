Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792707360;
	b=0W58yyn60P32CYtZ1Z+pgfakQb40j50K32Xq3rfR7Zb+l89FN/VwUnzfQsF9SZvBEDnJ
	 eQ4owavx5UaZzEzdv8W4dun2H8337BZqeGAwNhMCqOt6qcyKsOBcLflov/KX1yqQuS16b
	 jVfIDs/cjl5CB0wFj4LOrQMCZmPWAL7eR5USKC1oNmNPFQFqkkNdIQ+gnLKCnCz8vcb12
	 0Qu+KEvbA0IHATmSnGxyRN3fDCwVwYNvPgftm6GfDPNif0B8z3vpFNw2YDHrkL+VSQc6/
	 mTO0p4DS4oTlHdfI0VpBMkX35VnpwEGVU8jN4C+2jOIOspMw2/QD4RI3lq2cYnc88VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792707360;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=GaqApdBeK2bE88fSvpTgjY0Z/Eym1AprnFUqjIUjxc8=;
	b=h/W9MIpzQ46n0fQyOqV9QiAWUzUu0XYtfUQP0uju+l1LRZuzyZyX0oimKXNYEysTQXLE
	 SineSnl8rRqbGdzBR35OVmr4VGqFolZyzvayJpt/ZuNPJDiTQhY7X+ThT3lxZeSunYvrx
	 LAH9SodSv8CaqhWm9ECbyyYQpsSwelKgjDwMAeKS5Juqoi861WqSXKbB1JVgYL+pryTRB
	 2Rbap4mbngLvw+LPrJpj61EnoM6/E5k8AdRwW0RViXn0Y6siBR/eSEV1byhSWBFBrSNoA
	 ZpeOZvQBzDsA8lezw1EaVb3OtzQ5UvTJ7+0J5ZDmloWVIphjQK9aueiOK47SEa5VIRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=flz7XVfN;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1989606A319;
	Thu, 22 Oct 2026 22:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1989606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=flz7XVfN
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C71A6408F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792707358; bh=GaqApdBeK2bE88fSvpTgjY0Z/Eym1AprnFUqjIUjxc8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=flz7XVfNw5NQaqyuD4jhGyElDhAsO+p/hsA/PBKhe7yH+WBE6BEN7w/y+xJNjKJiX
	 uyDXQxeSHVbbv6vmQ3WOcNw+2r7sKeaFT5Ucj61nD6TQYS6CwgNlR9lUvcipTGK8hB
	 bdUbGkqitGYRUn0yynkd5BIEzpZtR+O5u/OjPp+EKJ2mclek1PKlB6IJhaioshkyte
	 rq9X2OgyzlhgbPMokG/WYMkc1nEQ9dVTpQhCxCBPM8v67BPJqvbFcPRBRQyWPsM1BX
	 B7UcQKSVqOc/J02VGn76H1s5+8/URo1pcYHXnC1ugjMsGhss96+txy6gWVWMq4TlQo
	 qbec06S2z/jVw==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C71A6408F6;
	Thu, 22 Oct 2026 22:15:58 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Breno Rodrigues Alves <breno3011alves@gmail.com>
Cc: linux@armlinux.org.uk, Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Breno Rodrigues Alves
 <breno3011alves@gmail.com>
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
In-Reply-To: <20261022214815.86306-1-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022185224.60700-1-breno3011alves@gmail.com>
 <20261022185224.60700-2-breno3011alves@gmail.com>
 <871p9h1kc7.fsf@trenco.lwn.net>
 <20261022214815.86306-1-breno3011alves@gmail.com>
Date: Thu, 22 Oct 2026 16:15:57 -0600
Message-ID: <87wlr9z8iq.fsf@trenco.lwn.net>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Breno Rodrigues Alves <breno3011alves@gmail.com> writes:

> What I did NOT test:
>
>  - Real hardware.  I do not have an Acorn RiscPC or the SCSI expansion
>    card.  The unit test proves equivalence with the original assembly
>    semantics, but it cannot prove that the semantics match the actual
>    hardware - only that the C version does the same thing the assembly
>    did.
>
>  - Odd transfer lengths through acornscsi.c.  All current callers pass
>    even lengths, so the trailing-byte path is only exercised by the
>    unit test, not by the driver end-to-end.
>
>  - Interrupt handling under load.  This is unchanged by the patch (the
>    IRQ path is untouched), so I did not add specific coverage.
>
> If there is a specific test or configuration you would like me to run,
> please let me know.

I guess what I *really* want to know is why you are messing with a
driver for hardware you don't have - for a computer which was
discontinued in 1998 - and translating a file that has not seen a
significant change in the entire Git era?  What benefit does this bring
to anybody?

You seem to be on a real mission to do these translations, but they are
not valuable for their own sake.  The kernel does not lack for churn as
it is.

jon
