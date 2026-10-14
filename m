Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9009E560ADC;
	Wed, 14 Oct 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996554; cv=none; b=qlFsRp7836DHk0oBu85PobQ59M+945XP4Nis1A+1T+3KMpPBI7uBModzT2I9YnShabJaZweWD/DdIBqUvgRIxB8Pltr26lIVsBy6QDaGuiDZ/dnpTQQ9wfUWbNSld9mi/e+7e6FHD+I+NrZz58KHafe7/B1YfWyEnpt3YdXOUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996554; c=relaxed/simple;
	bh=C53tTLJWTyHWnWBkyZ9ktjD1WatOsvqzEK3xKknkDek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVTvYzwyAF9QRh6sVnMyCJmaGtPB46gyreRg64rVv8yvWy9fMSa7n0OuF2TE7P5Ohi1o9kYETLkuGTtlXBjCkj+wv2ar1yrB65w1IKMn1v5mvVNDW/1f/jQfACFQmH6dY/GsKOEOySk5yj2qLD01w94TMyWLd72+angwpMejJ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iw2Y3JwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iw2Y3JwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477621F000C6;
	Wed, 14 Oct 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996553;
	bh=r07MWRD3rjMgkoq39ACj6B3bHrOEJAWnVqYX+7pA4LM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iw2Y3JwT1IxnGF3RddpEpcN1m0nOo0n+4qtv+4oG8PU4pZwLQ4Ms4vevuFNNdhceW
	 FBX+qXqKu+n14UQHCjHs8iVLfVoLu1Rmq9+ERdrZIwEHC3ua5ZE4Heeq+TNnUutu58
	 WGu5sWN5mtiPkY7yAkhnpeRUIacICekpyZSm0valeNXz136OHYxXKqffmjPA+rPTOT
	 Vt/kuReUlERpvjoHLk0P8kJHjZoevvjysaYo0yp4T8zMPrAordw1c01QuxbqhI5Lps
	 IFqEUisWlr9xCCiqfpA4q3YdX1GYx07Hit1Dn9UevfWkFuw72ZrMELc9CwkiZ+2mY5
	 e1QD1meRScRqw==
Date: Wed, 14 Oct 2026 18:48:55 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>, Lee Duncan <lduncan@suse.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
Message-ID: <20261014164855.GB327771@quark>
References: <20261001044857.169487-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001044857.169487-1-ebiggers@kernel.org>

On Wed, Sep 30, 2026 at 09:48:57PM -0700, Eric Biggers wrote:
> Make iscsi_target_auth.c call into the crypto library directly instead
> of going through crypto_shash.  This is simpler and much more efficient,
> as it avoids overhead of the crypto_shash layer.  The hash computation
> itself also no longer has error codes that need to be checked.
> 
> For simplicity, still do a memory allocation per operation to buffer the
> data (which is typically less than 50 bytes here) so that the one-shot
> digest functions can be used.  It's still much more efficient than doing
> the super slow crypto_alloc_shash().
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Martin, could you take this via the scsi tree?

Thanks,

- Eric
