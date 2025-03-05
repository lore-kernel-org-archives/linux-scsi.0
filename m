Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9A28E0F;
	Wed,  5 Mar 2025 02:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741142423; cv=none; b=DyIM64TZ6tPhvhlpdYLk1HKoQZ2rivXHSoVtDP9ZScBOHgXxOun0RBt/GI3T9dhLm0b/wlCcvCcTK3Vfq5+/CGCwDkPyH/+y6AZ2UP+oVWsGQCHrG6Bm3ejyILoQJuCFekkaBaiPNgCbr+Pl6DluRH15QjP+eGyiZVjay/W1a/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741142423; c=relaxed/simple;
	bh=8+OFgPo6b9+9XBbw+hWdHGjxyyYbUhWhivUtycenzYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7WGPLQ8oHc1pK49FQkjbYb9tXhWo6c79gzBxRBvUcIheSMk44/DubsfKI/4JoaxRviPgpwit3F9eus361B9dTvJwp7rRm+W1I7bwfqyHSm7fRiOilFJcfgprSB8Km7qZpFzDllF7vP3/xQ/CB1I3fzT0wJyLwsIOBHTl1pbCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhkTQQI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhkTQQI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D47C4CEE5;
	Wed,  5 Mar 2025 02:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741142422;
	bh=8+OFgPo6b9+9XBbw+hWdHGjxyyYbUhWhivUtycenzYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhkTQQI9ODCRNJfQgTWoHfxNqzQUcCKh7yXkkD+KnAe/jpWRRpWGHlz8AZIbmQH6s
	 L+w/BwR/QDKer4xZliHwtjiJM+vBDRCuFXb8Wn2AwDrvKwncT1h5e3N5djv6MQjEp0
	 0bzAf5hfptsuqXiLGcGQfWi+srCrpJ4F1EJdAqoaF6eSpU8ayXnGkKd7MuiMuhXYHz
	 zLlPvVVUKoGiR1mqQjOo9bOmmWVcGV4rT+j3WBVIa92AcY/jR+V5iGywiISyi3iB0t
	 9Jjh1s+pTWsA7ApHMdmL7isYOa7tyS/U8zK9yNUu5hBYkU1zWcdp4oq93QaIqpqgoC
	 +JKeDuvMiPtzA==
Date: Tue, 4 Mar 2025 18:40:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, krzk@kernel.org,
	linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	willmcvicker@google.com, tudor.ambarus@linaro.org,
	andre.draszik@linaro.org, bvanassche@acm.org,
	kernel-team@android.com
Subject: Re: [PATCH 4/6] scsi: ufs: exynos: Enable PRDT pre-fetching with
 UFSHCD_CAP_CRYPTO
Message-ID: <20250305024020.GC20133@sol.localdomain>
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-5-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226220414.343659-5-peter.griffin@linaro.org>

On Wed, Feb 26, 2025 at 10:04:12PM +0000, Peter Griffin wrote:
> PRDT_PREFETCH_ENABLE[31] bit should be set when desctype field of
> fmpsecurity0 register is type2 (double file encryption) or type3
> (file and disk excryption). Setting this bit enables PRDT
> pre-fetching on both TXPRDT and RXPRDT.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

I assume you mean that desctype 3 provides "support for file and disk
encryption"?  The driver does use desctype 3, but it only uses the "file
encryption".  So this confused me a bit.  (BTW, in FMP terminology, "file
encryption" seems to mean "use the key provided in the I/O request", and "disk
encryption" seems to mean "use some key the firmware provided somehow".  They
can be cascaded, and the intended use cases are clearly file and disk encryption
respectively, but they don't necessarily have to be used that way.)

- Eric
