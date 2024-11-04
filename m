Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EA11C4A25
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730737111; cv=none; b=LOst4R7p80lTedlHZAWc6NObB5tssSirls/pqF/5K2cLhkhtZETjO73PS/e5IDh680Iej20sOgA80BVSaHDfsJBsPaB8vLlpnnV0PvSVtUQjiZuyvhk8VGtJD0R2Ga1AWG92GCORl64k43X2a5GAJvuP5crXy5akBW0b79KwxiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730737111; c=relaxed/simple;
	bh=7RBidEejKihYPniggV1wH+TUy6g35kOUF1F5omwB2xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=su2xgO0z9Oz5Dpxf2ZYluG9Oe8Ft96cns2rPrkGoqpGAZLz9vQfc5RMgWZYkA+UGbKZW3D30iapxl/wv5RsHP+IZpuHe6urA56YRDKnbOoJ5oD5yt/4L5X0GBskygZzxKd8yYG8Tg66wQtgz2HvtaZoWskRhPLoSlf2B6ltPMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=oVO65S6t; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="oVO65S6t"
Received: from cwcc.thunk.org (pool-173-48-115-131.bstnma.fios.verizon.net [173.48.115.131])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 4A4GHeVP005285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 Nov 2024 11:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1730737064; bh=HCFNkOXlzIC4nbZOOGVRxV1kaQeAU/pJuUI7IWu3BR4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=oVO65S6tk8aYtsUJW4abfDTpafWiCHqifmtgz7vEn58onu4uTUTySA+AmGo3UVJT9
	 QQil4qEcdDh06BYYMnHWbMuOcivNKlwrUgqB3NyzeTmJfoUwy4xiEy1BNuCR4Eu++H
	 cIgfVEOfg91zv6X1OPeh48Xjg38/IEAN1zbNQgixYZCOjHc+QpUcsq2Uv1oLfNcmQE
	 Bf/CuM+o0H1XLCvkG4LX/WwoUy7Sg139hmyTTLYtv3UmNW9L59QBTLp6ud/keG4y3P
	 7O1qTZ5ZEGpzgROh+vZIYKFyf+CwYk8FneIPHXrRsfY3x1J+g1SIrG2lehvgiPVbt9
	 ijt7dTTvk4gpQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id CA48115C02FA; Mon, 04 Nov 2024 11:17:40 -0500 (EST)
Date: Mon, 4 Nov 2024 11:17:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mips@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
        sparclinux@vger.kernel.org, x86@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 16/18] jbd2: switch to using the crc32c library
Message-ID: <20241104161740.GB43869@mit.edu>
References: <20241103223154.136127-1-ebiggers@kernel.org>
 <20241103223154.136127-17-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241103223154.136127-17-ebiggers@kernel.org>

On Sun, Nov 03, 2024 at 02:31:52PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that the crc32c() library function directly takes advantage of
> architecture-specific optimizations, it is unnecessary to go through the
> crypto API.  Just use crc32c().  This is much simpler, and it improves
> performance due to eliminating the crypto API overhead.
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Theodore Ts'o <tytso@mit.edu>

