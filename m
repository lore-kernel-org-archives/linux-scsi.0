Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794190350;
	b=C6RlbXWrxzoKN/aeUQ7zi/tDIjfitwJjGIeouYRxFovytyZsQp6UCYP/+mmxx6wAKyvl
	 rb/BsJq3IqnuAWGLqztqnjXGM74zEQQzbx7iX44qTFaQH8XMFldRFV8Z/cLYk87FnnlMp
	 CWfy0l8/WVtFzzSrTz/1d/3GUVJAf0+VjDsIHbHI+Lj2WXLG2pwH0YMPczKknaFY43vXy
	 I47ptivrjf51IKjbGd5kXI7Akqwywv6pe27gT0QqFV02lvYEiKlr+tD2a0ZJj/Z4khsQz
	 u4/v6wxVLzxPteLKkSECmncFm04OQQBPQkhQ8tAVuNMktxYjHPrvG5i7ed4W19jOevg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794190350;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=P8u6no19UxlrYcE0nbIhvrVnEC8G1CSQ+bktg70D7k8=;
	b=DH6NawdQLCmchpj4+wMeKTR2gCVSqFaJmbT2PSbqP0jiJCGQ9QttYS4kLiALJq3g85Gu
	 ZNVzC4+7rayKXZYviF9Pq2yKANPHx7zHkygGena9VWM9DCfqxA3+DmiIStXjixbL8RAHm
	 eDLV9D3YO3RZNzeG/jTLV+VX8neLf4CDvMlDbkLvS3aFTrNEeEPJGhnvL+jxzIDN+wssR
	 3q3Rd2QvNxxkKYXnjNh14E0XOs5InEZyX3IzBfYFy3a629ZyiVMKfbmP4kxeP3nHWAyUi
	 h0tx4rRW2wMInIkr9AFgsH/B0L/uPZX6xSQeOVlN6zR9LJxaAxjEBIvYszLAdzs+hrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ElHb3PQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D70F606A31C;
	Mon,  9 Nov 2026 02:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ElHb3PQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFBB1F0089F;
	Mon,  9 Nov 2026 02:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794190350;
	bh=P8u6no19UxlrYcE0nbIhvrVnEC8G1CSQ+bktg70D7k8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ElHb3PQmXlk8Iq7kTN9uZcyh354p2USnWSfvdiCfWXTQyDD7b0PO0hHq4i4HGeRPf
	 2aTD9akTB/8IcvzdtHtyq0uk40e8FnihibcY24pQs8g0xM1wc0681i0hX+zzojG9F4
	 S7rJxA7A904t23rEMLebzYIuAMlow3g59J3trFpmpRyi2AQE3mF96VJb0nvmcZJ9hn
	 3rXje54QAk9MLE5QpsopHFpnLM39k9I3zr0bOVljsiFJWVEToOG3bDm+ssXnPfUvZA
	 eQwtGFMQroQhUuoDpNnXHqvdB6KzyZl7YfpYb7Cl5Y81Rr0bIYAGP8UKsw4yTnQyKb
	 zPV7hs36kfxeg==
To: Denis Ahrens <denis@h3q.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] scsi: mvme16x: enable 53c710 burst-8 hardware transfer
 mode
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <733CA975-51A9-4687-BBD5-1FB4171FA3FE@h3q.com>
Message-ID: <yq133taycrz.fsf@mail.kernel.org>
References: <733CA975-51A9-4687-BBD5-1FB4171FA3FE@h3q.com>
Date: Sun, 08 Nov 2026 21:12:28 -0500
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


Denis,

> The shared 53c700.c backend runs the 53c710 with burst mode disabled
> when hostdata->burst_length is left unset: NCR_700_chip_setup() falls
> through to BURST_DISABLE in CTEST7 and a 1-byte burst length in
> DMODE_710_REG, so the chip delivers one byte per transfer period. The
> other 53c710 hosts in-tree already use it: sim710 and lasi700 pick
> burst 8, sni_53c710 burst 4.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
