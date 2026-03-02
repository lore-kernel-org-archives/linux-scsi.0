Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DEE1A9FA7
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772471526; cv=none; b=Jyg0WnphcJZ6T5o0CYelZ/pELcl1psv/t7uUGCyUxODIzydCMA7io0wqz9JlKPcFqsAUlGmgn0o3oREa6wOdBeZmkAE7re7/1jKhV6rZIPUjCbRhrgT5H9he9D1yEjYZf4JkSDCcmSNGXuEA3P0ZpHcTGdUe8NdITI4zc0idSHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772471526; c=relaxed/simple;
	bh=lPUJZhW0yrGl3ZI7H6Eu4afjawhu8PsPLJY8ch8v4KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdQqac66rto8u9nYI0mhBSmAr9jZIkttMZ6MMxB0RAflRvPeoqU/CyrGlH53YqAYDjE0qQOcVCeF53tRvmwIyZbpSK08fI0kl//xe4skRKvSRDiirBI/gQuGO4uPBAeiCIO2nvlnMYrz8D6LBh6Dt/CgRGRu5+dGjMBWMmg7Eb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPzyL4Mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPzyL4Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39725C19423;
	Mon,  2 Mar 2026 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772471526;
	bh=lPUJZhW0yrGl3ZI7H6Eu4afjawhu8PsPLJY8ch8v4KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EPzyL4Mhv+GSZ5WSflCo5kC+u83yOZpQt28v3vNo3gjVE6MC8tv+vi0pot0HC4GOh
	 +azdFiMw7UYL4FXx7Nq5tHzriQ2DmKA7+zRPbmXY/yFOVTxqVQblhn4wk9qgQKaNHL
	 SWE0Q6O5QJHcr2YBcIj/LNFtV0U5FI0HKdPJ5YK/aBpizAq2eGxEmruZcr7hb+Cw3K
	 BflO7VM6boSSArbj9Yvx4GFHNi1qEeOw7PsB/UTDfi9e4QOkZJtV0la+Rz3isL1Z9z
	 ZRWSLGA0b/TrpDVULtZQzhcKGlnkUDE9xNOJ0IsjCPwjo+ZmkFLstnWC1ioxd5xNl9
	 w/VM5o2nE6ekQ==
Date: Mon, 2 Mar 2026 10:12:02 -0700
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: John Meneghini <jmeneghi@redhat.com>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de,
	chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <aaXE4s3AT45UIAN8@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
 <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>

On Mon, Mar 02, 2026 at 08:16:19AM +0100, Hannes Reinecke wrote:
> I really would like to go with the nsid based solution from Keith.
> That would avoid quite some cumbersome code here.

I've seen various documentation that assumes the current naming
indicates the nsid, so the scheme follows at least some people's
expectations. I don't know if we can make everyone happy here, though.
:(

I've fixed up most of the multipath races that get us closer to allowing
nsid suffix, but there's one left: nvme_remove_head is called outside
the subsys lock after detaching the head from the subsystem list. That
could cause a subsequent add event to call nvme_alloc_ns() before the
mpath side has completed del_gendisk() for the old nsid.
