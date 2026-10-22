Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792705482;
	b=3aF97JCalImYEX7fB4qEqK9AzBsOXKPqBVEr4JaSsgwF03zFGnUnLHFKK/qV04jwV1o/
	 89/MGFKBtOqVnwXyCt5GI8Z3ruI5u+VQWxH0d8Ob8NNyi5mPg09qgLhr56nDGf/iRBjQK
	 Augh/Ma5Ye7/vrtqGpc9ORJp+J2+b3GvoxKXnwvxtdt2zHlbaTQPdVrNHiWtInKdeWC2X
	 CRG8gFtNvNLVWHyv3n/Wka6/Zo3pq3QyJ74Lt8kyCJ+pqo/Z8jIBUyUijF7Yean85faM1
	 x2N0+BW209Vt9DRngn5VF7GngGJ95gkhqg1KdqBYdTE0JPnUGxQYy8KyRZElVsHgS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792705482;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=Woe6xHcsEP+dAFnzYb9P6peVQw4vpnrcC8v3BR/2jnE=;
	b=fhteExr8hcREUrCm8IGS20B3J9/NmOMDfeSTHRuKkyqVKFeL3thLx5DB9qfxeRgH5rFL
	 znx8GFsENbFLUgoudxg2PE/CCaPgxkx4YuF+iKL+MR/u5RA5iVf2DJK/b2KReoTh2Stgo
	 8hM2XB2irZMIzSjDhAqrzFu/Hh4q+62tW0WrHxlxXQJvfMk9F0EUTaMTga/TQPhH48Aga
	 gY4+Hk/F3Crdjcr4TWvBP/q3OddwrNt2mOr1B8dct5YDgB/xankCdaXS8YZGNwkD9SkM7
	 B9bcsZ+ffiD27R45KXizSRcj82NSYkfCpvsBIQ0OVjimCuLl6CNRE5TfMMktr5v2Iyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=lhJJsOrJ;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A9606A31A;
	Thu, 22 Oct 2026 21:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA8A9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=lhJJsOrJ
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D63E8408F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792705481; bh=Woe6xHcsEP+dAFnzYb9P6peVQw4vpnrcC8v3BR/2jnE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lhJJsOrJHzLb6hn6bv7VHV2+mYFyaQtqk92z4rf3sxZo/TyHcTlvOfRjkRsCZIrF0
	 Nip8jdgWVfzcS5qQI+OMAL+VtSulUBFCWcXY7gA8o/jOsJQsrstXMFjBdxeJfnxw9u
	 5wJdFCNdvqkzNXjHfSnYt93QL8pkpmOBk6cOJ0/N/5f3M6MHxTIjb7KxIyxwiL3gqZ
	 eG8q9GbK58WGOoVPrjX3IaLo2gcnl9GFu9fn8NRI2Ejut7IYXkXkh45XCpYhNNTgiz
	 h8WveE+lhUaTo/m2YMOszMhQ417gK5tNzbqnqVBrp7v1kgVKLoOtQV+68J6yOnW5dH
	 /1Q9GqWTslmNg==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id D63E8408F6;
	Thu, 22 Oct 2026 21:44:40 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Breno Rodrigues Alves <breno3011alves@gmail.com>, linux@armlinux.org.uk
Cc: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Breno Rodrigues Alves
 <breno3011alves@gmail.com>
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
In-Reply-To: <20261022210252.80844-1-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022210252.80844-1-breno3011alves@gmail.com>
Date: Thu, 22 Oct 2026 15:44:40 -0600
Message-ID: <871p9h1kc7.fsf@trenco.lwn.net>
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

> The Acorn SCSI expansion card presents each 16-bit SCSI data halfword
> on the low half of a 32-bit card access.  The hand-written assembly
> in acornscsi-io.S implements the two directions of the data path:
>
>   - __acornscsi_in()  : packs pairs of 16-bit card reads into 32-bit
>                         memory words
>   - __acornscsi_out() : expands 16-bit memory halfwords into 32-bit
>                         card writes (duplicating the halfword in both
>                         halves for the bulk of the transfer)
>
> Both routines are simple pointer walks that a modern compiler handles
> just as well as hand-written assembly, so replace the .S file with an
> equivalent C implementation.

How have you tested this change?

jon
