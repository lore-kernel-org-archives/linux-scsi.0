Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236360;
	b=DK9IZ7klbXHI936nuq+g5sSzUSDaePxlOWARPJHpaKCpIyDgZk1KEHcA/1W3exvgVDXz
	 /YfAhGEkt8tLgx8NhBXb47Z+Ouu+otiBHM9pyDKA8qTMToHVvzY93cOyxJRmypPeFmnRz
	 91NpDMa2F+7yd9sewx3wp8OARTD84QqErgmb2jxj1A5DlDruSmikauogdavA96g963mSm
	 A7jfEJdGsTHbqGxlWi4cBFFVrbT+tFDvTobQYyXdElx/MfFqa86i2Beg4FKMlhcOL+bbs
	 hIU1pEU/uASbObK3LLZoapOtoROYNSF0hiLGudr3nQnNpg5s+dqynVaVE4WjG5w+mBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236360;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=lQ67/ivWhESzFaNxrBq65Yfx8AsyrUIpdU6WYE3N81E=;
	b=Fpouymd+LM12SBEAU8LyI9DCebiR90NzX6m1mNl6crsYXaF1qin7znfKbsOCiGD5koB2
	 UI7PTNwojpmsyIFq8YsjtZxwStTnj0nWdS0FGHp7RBSSI0DZkj+7IEyKd5+LnoHmGyXbc
	 2YuL2w0vHDwKb/5TB9iXtAjsuKtK7qv34HScaWNLliUgt+wRv5zmqiIPlznGZptfO9smZ
	 5CotAvUsONfebkTzSC7WiwZOMMMMTEbvScyvpcBunzBfQ0amYoqdml8LKiwH9NarNItOC
	 ye1PX6rfzcR+td9+B5kWyWpuNi5DmdFLYnfKMiequewcxD/oqqubEgOkEDQLMEyZ2zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f8nhawfk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E190A606A31A;
	Thu, 29 Oct 2026 01:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f8nhawfk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E6D1F01829;
	Thu, 29 Oct 2026 01:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793236359;
	bh=lQ67/ivWhESzFaNxrBq65Yfx8AsyrUIpdU6WYE3N81E=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=f8nhawfk+h0eWlm2RRePnleu0QI73EHvoK4J/b1zk9EChFp4pWHlOX3Gj3krs7Auz
	 969rX7KP3vbi8LB+TUM5qCGFSOyR4kmsBrLNo6BL6yYOaostYNbfuSn9a4FIg4IOai
	 SBuniFjdtntzUa7ickJjFsTQoyaxClvRm7IlLnpNGzdbXfZkZ85VcNq9bykR3Lc9/c
	 bAFjOaFTV/sR4jks9XgniaG/jwTT9PQLvHxVCgN/6EZ67rvVq5abozfS2LsW+e0IPQ
	 WJ87FrQGynPM281i2uPDqaKWeGQ3DeukWDCPgQ2YSTn+mwLSuVKjIMiFRHGJMxfGF4
	 Fa4/6RyBdmkCA==
To: Imre Kaloz <kaloz@kernel.org>
Cc: "Martin K. Petersen" <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Hannes Reinecke <hare@suse.com>,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Fix REQUEST SENSE allocation length on
 big-endian hosts
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261013094253.2956-1-kaloz@kernel.org>
Message-ID: <yq1jyn15myu.fsf@mail.kernel.org>
References: <20261013094253.2956-1-kaloz@kernel.org>
Date: Wed, 28 Oct 2026 21:12:38 -0400
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


Imre,

> The REQUEST SENSE length was taken from sg->len after the
> AHC_DMA_LAST_SEG flag was or-ed in and the value converted to
> little-endian, so the 8-bit field is 0x80 on big-endian hosts and the
> target is asked for 128 bytes into a 32-byte buffer. Use the buffer
> size, as aic79xx does. On an SGI O2 with a Fujitsu MAX3147NC, the
> sense data of its CHECK CONDITIONs during probe was lost.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
