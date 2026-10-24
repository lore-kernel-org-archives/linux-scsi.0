Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792866547;
	b=aSxu9lJ+juRh56Bq/yUu4i/VClsC3w8ft1tzPVcVGgl+sgiVI0nOUBLxffjcnTwnZ3hr
	 3/6E3VEjJxMpUqPBfi+EW0ciZoYpZh26PkfS3bhe6UUEpV7SkMzjZVcUhTPDNx59Y4Njr
	 +iYiie1eELuGb/4kZPsrNc+K11yqdCv25pIN8zopgUOIvQuTsB2mflabjokxRtxLyyH2m
	 pIKCWS0KEpd8mqQkqVfttUJbwBJHTytHkF/EP62j+WWxIJvp6wt2DeOR93RFZ7XfIUIbK
	 a6CLlJQpTd4tBxJA9FoguYBQkfER9KF2DTpoiP5IYBezagDmKymZa1cYMsytpvIH+sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792866547;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vVr1Q03fycfMZCV8kgJipJemnOJP4d2IZ5ZpHZmpgVM=;
	b=Afhs4roQRWmeZAgP1dJfJjQIjhINP+5XCg8Eo8V3VgQ+r9NbaQ/P1ObX+zwtvioDJZMb
	 4m2WV2MCLsRqzbRSeLzjh5hFJtDxcUme/DZi6R8zoduQdWhyYj4eKwEscnoZwVx4Qk3ih
	 +TzCKUxU79VgQ6RhxOD98K1jBOiC6w0QMYzu3R5cz+A4x1/Sm3fkQN0Vx+iQN3LOYbxzq
	 XAyr0ZzPLyJGk7PbhIG3yTcrxXEuoOHZwVCbOVX328LwDFvAtAaYPZY8xWbtTr8oqjy+6
	 d3mNe9WWsoeK3o63HI2mcH2EkuK2p6ztR8K9ZcPQWeCfKCbLJUfr7bBs4nbW06kVGNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbuDdq8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904A606A31A;
	Sat, 24 Oct 2026 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbuDdq8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B51F01825;
	Sat, 24 Oct 2026 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792866546;
	bh=vVr1Q03fycfMZCV8kgJipJemnOJP4d2IZ5ZpHZmpgVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MbuDdq8fYUvRQySVjS8IYUr6mSZBzfjnZyN3V94pWjAZgWiMUIHL26ufnRukCs2aK
	 rVqo7NDDBUB5mW66u3lm5mAC7TJ0sGq+sTFQRNjpyUqgthJZFIZhc56qYRByzK4z8A
	 Gf2sfIa+VOEvGM2aJRYUwvhU1Fv2GrQO2GGHB9kVZGVMtNerKBbGR1LKJX+uK6rldO
	 NvjTIBmj6u8Th0FG2YrGXVv7Ful+AEPCMvYCAaqMMoQhcpw+y7HtwtvimkO/wrv0sp
	 ren6xdK0GMyZh4QRl6gHhg7C7XwgEm+JkcsufW7Ac2hFFT++1VtDeAKqSDxHybiZrd
	 Iso0g+/qhTAmA==
Date: Sat, 24 Oct 2026 11:29:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
Message-ID: <20261024182904.GD2553@quark>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
> Remove ICE enable call from CQE path, since ICE is now enabled
> during SDHCI crypto initialization only.

This change makes the low-power and "optimization" settings in
QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
correct?  Those settings never get lost at runtime?

- Eric
