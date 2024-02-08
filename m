Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD0150256
	for <linux-scsi@vger.kernel.org>; Thu,  8 Feb 2024 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707432312; cv=none; b=c2wPArHGwcn+p9DFPkFLvQG6d5bLIFkzT8wTT6ZtOYusA7niRwS9xuLF2JiHuw7u7mC1n0A4qmsAEL3vO0j0kEfvCxD6MdyBd5QG6ZeTX1dMLqIKI1q0S+Eh8gEDwSs29uTx5fY+EYC3Hy9q2uiB7DhROeKdQJjaXx199z4FbOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707432312; c=relaxed/simple;
	bh=W0JffnIev88BcC8Hl6egW1rjoWWfB2jwFQZciSPudNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cp5S5G7cjJbiHRZyo0AfRJ8Og9RSjWrMmHD7rsuYT6P8pxIpSPs1z2vkPvt41WEZx9+MGIxZET+zwhLXN5p6dA/z4DLdNLCcVzoFwopdH1qrAcZfvaHftvKrRWCYkZI7Tqg1UBrX6Wahb1oBkACkXsOql1BrCIsNqtlR0To4YXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lezzZ+tt; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lezzZ+tt"
Date: Thu, 8 Feb 2024 17:45:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707432306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W0JffnIev88BcC8Hl6egW1rjoWWfB2jwFQZciSPudNI=;
	b=lezzZ+tth1kRqJyrWGGU9sTfubrW+ImjbBA+pOL5Zyj77Jb6V2xSyYhT2JTnYLoPj+y9mr
	N18RVopOFvf0ZYMtdbC8uL3XxLfP02z43Rf0IIfpkP7D9+gXog6JghmhcFAuXNwhGvPUP2
	QPc0CxJsE0Ao+uuOmFiOydtKo77qCqQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Removing GFP_NOFS
Message-ID: <4qc7h3gun5lkv3p5piftgkhgmlbrgqteut3vxtjrme47kyn7q7@62ogk3chsrme>
References: <ZZcgXI46AinlcBDP@casper.infradead.org>
 <ZZzP6731XwZQnz0o@dread.disaster.area>
 <3ba0dffa-beea-478f-bb6e-777b6304fb69@kernel.org>
 <ZcUQfzfQ9R8X0s47@tiehlicka>
 <3aa399bb-5007-4d12-88ae-ed244e9a653f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa399bb-5007-4d12-88ae-ed244e9a653f@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 08, 2024 at 08:55:05PM +0100, Vlastimil Babka (SUSE) wrote:
> - NOWAIT - as said already, we need to make sure we're not turning an
> allocation that relied on too-small-to-fail into a null pointer exception or
> BUG_ON(!page). It's probably not feasible to audit everything that can be
> called underneath when adding a new scoped NOWAIT. Static analysis probably
> won't be powerful enough as well. Kent suggested fault injection [1]. We
> have the framework for a system-wide one but I don't know if anyone is
> running it and how successful it is.

I've also got a better fault injection library in the pipeline - I'll be
posting it after memory allocation profiling is merged, since that has
the library code needed for the new fault injection.

The new stuff gives us (via the same hooks for memory allocation
profiling), per callsite individually controllable injection points -
which means it's way easier to inject memory allocation failures into
existing tests and write tests that cover a specific codepath.

e.g. what I used to do with this code was flip on random memory
allocation failures for all code in fs/bcachefs/ after mounting, and I
had every test doing that (at one point in time, bcachefs could handle
_any_ allocation failure after startup without reporting an error to
userspace, but sadly not quite anymore).

that, plus code coverage analysis should make this pretty tractable.
