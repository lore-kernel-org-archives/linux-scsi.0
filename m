Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237612;
	b=qaduW6lv+MKXQn3aG2SC1kGpTh6PipnL/YztmjJwABAW6URHtTX3Jez3ME92nqBP0ngl
	 /Yv/Uq0bNNv6lgeIavZabhnDw6qHyoXgSob84d9WR4cHUZMA9Scq+3Bsc1OekkAEckZze
	 4LXU8h/CTjmOQ4wY/n4JYfH+MkWuDfeca2ZAqesuAKiLRfaoMQNPkhJoW5/mySBUlYsUz
	 Ium5uoUmF8RQh0nDcNSMIAu0k0ToOkF4RXdm0QXbBEheWvyr0jX2bANsM4LOQ42q3hsfC
	 HT637I0PqFIK1qEyHDvP2c0pUsplOTVRVuz/EFIrwv+JL+JCjP/hKaa2coe7S6nh96Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237612;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=T5EDiDybKTR5BUxLZVM+JKGIurr97tQCzsH9fmn+UCc=;
	b=K1hrh0bljdVMeF2BRkQqiaciNnHIZyOFOf1G2mitrAwl9LJYDgiwdTsTlvncEVz/BBKq
	 zmvuan8H9NsJtjIB3MaDdPYcq0ai+O3mEVGmDU0SFGp5KU6nMhmK015IJJd5Np0OW76d9
	 V0qGAsyKkmQU0T/iagU2Tr1GRL9IrzbGtDCPlMzmvhz3ufzmzcqWevXUJxnQARGCYttss
	 tUoPJl67rC5qbr/gGmd3PD67mpnkn+Zo557LCYVZS2bdUUiKm0f88hRe5ay3xSEGAd37M
	 F1ipUc2f19Ilxf/zhzsM5llW650+tNyCRRhTSIS/lci1ducLPrdKBQHHRxLdjNsJ3+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EovunwIa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D6A606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EovunwIa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874B41F01828;
	Thu, 29 Oct 2026 01:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793237611;
	bh=T5EDiDybKTR5BUxLZVM+JKGIurr97tQCzsH9fmn+UCc=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=EovunwIaa86//hrxc4UtQtc792xJgpLswYhGqcrvLz0xzDu6vRCrc1OnfqNKlJdwB
	 B60QWs52zFT2aybNYXRrQDm20MwF+RCivH8CIkP0lcYFLg9+7kqps39FrsAxSAPXtx
	 Op17sYfP0KoIUteNalj/yoitIxAzMaTUQ2HVADshICMr/G/Q8wsWOZBkkfdqNdvaz4
	 4eERxJe7fT+b3m54Erqp7KEClr4ryLACitzcYa8nCkKhurH9MfDTMaKfKVDAcgdmdH
	 Op2xoEmzwG+u0pysGW9LsD07FlcSg05rZMwTpohF1CqRuP8nL7j9jptj1X6Gf5Y2/S
	 3ywo0BibJY6vA==
To: khalid@gonehiking.org
Cc: Bart Van Assche <bvanassche@acm.org>,  "Martin K . Petersen"
 <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <10f06b90-1012-401b-93b5-331d487973ab@gonehiking.org>
Message-ID: <yq1ld7h47g4.fsf@mail.kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
	<09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
	<10f06b90-1012-401b-93b5-331d487973ab@gonehiking.org>
Date: Wed, 28 Oct 2026 21:33:30 -0400
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


Khalid,

> I looked at a few other ways of accomplishing what you are trying to
> do and those result in more code churn than I would like. This might
> be the least disruptive. I found that MPT Fusion and FCoE drivers also
> define their queuecommand functions without using DEF_SCSI_QCMD().
> These are very commonly used drivers so that makes me feel more
> comfortable with the change you are proposing. I am ok with this
> change:

Applied #4 + #5 to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
