Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294F03603DF;
	Sun, 11 Oct 2026 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745967; cv=none; b=FfhSbeHQJQbMtf5MMMyRf9YDlUUXteGAz2I3nQgHlVrHn7uvBnGOVNmqj+DHfQ/Ld203EPlq/5gRX3TDyGpp28P/2+bMCHceUIWoujyIaqO8NuO+vD2TPmNAgxtY6aSnI1fjODFCJKUsC3ei8rOOHWBveikYQfX/dcOzFx/ovsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745967; c=relaxed/simple;
	bh=OQ3Ons5C4nXRejjkrqjlX03EQybliEVrD2V7Jur59GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dag0DGx0GDGDKqa7tZriVF2kTiVF/j/uoTmSii0cPxsms+PT9E8s40CuhvG2U2hE4mIU28VZnzwFaUvc5wYH+vxzFn5+LFfjs1P8pMPtc1IlXUO0qDcadMxCoyNhNHuFYJeHy+DvKVTaJMwOF8phzNGChvgx5pQomWyBdpQzOKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBZOLXeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBZOLXeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5621F0089B;
	Sun, 11 Oct 2026 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745966;
	bh=OQ3Ons5C4nXRejjkrqjlX03EQybliEVrD2V7Jur59GI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hBZOLXeV2GPe3X4p/lGyLnfgdaxytnYqKN756Ccb4ePXzTA4To2qJ4OM2Fspt3G5o
	 sWF9rxxkE5sTSJ/A0wvYAAhQX54ftchJfJVV5uuPmCzIroN+R0Pbu6c+ZzykPGTMH3
	 JcioYzSnc6SbibeVR9tZxsCLQ4+ylo/2QnkLq4sa+qAfOO7dPeBzd9uYazZXT32KvF
	 GaDhGE2styLQc5WbJdERsCvqT0dSwtpgVOGddvoYcLKZbux5CPCu5AlUIdOicBGumv
	 aIatsM3/AM186A4lLH5G5Sg8bCD1XZDDnDJfT9sTSk8zlCNnz063J8RZUpHGn1mFCh
	 qgw1XwGKYg76g==
Date: Sun, 11 Oct 2026 21:12:35 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lee Duncan <lduncan@suse.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
Message-ID: <20261011191235.GA22483@quark>
References: <20261001044857.169487-1-ebiggers@kernel.org>
 <20261011233600.5bb5d6c9.ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011233600.5bb5d6c9.ddiss@suse.de>

On Sun, Oct 11, 2026 at 11:36:00PM +1100, David Disseldorp wrote:
> Could e.g. SHA1 also require fips filtering here in future?

It might.

> If so, would it make sense to track the fips compat status (preferably
> at build time) in chap_digest_algs?

Let's wait until there's actually more than one before generalizing it.

- Eric
