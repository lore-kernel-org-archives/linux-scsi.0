Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E9D27A;
	Mon, 20 May 2024 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716218143; cv=none; b=cDtZR+FkHK3HyNrqNB13wl/EgF58hSvilkxuMTQmmqRK0CeJHGjtEdYIxMDu6HAm+Ig97AEIi1wknME5oC7Syv52LK2HPRLxMJX93fwAOkXD8pEsGRUQ1HaBpmnCQly1tBAYKTumz/a6r1XUtYXU7rnXNbEAXXSCRYZn9qDGW8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716218143; c=relaxed/simple;
	bh=qNzvvr/egYIqxDFMWzX9Y/DNoTmf4i3vbl+lIDIrBJM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=FlT7Z8afzKHmmO23M8Zl1Cy0wxZhe5WjyAa5MOt+8+GKp87Jz422meLVwaw3gTEZVhxIjG6w6eoVrSaD1zwmU1HlYsv+leF55X1Zc7jul36WIG+GwRjTtOpylAW4rAoVZkypCIY0ZknaX9hARYEvSj8R6GiGsCZOwMrKz/RtXMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1542168AFE; Mon, 20 May 2024 17:15:37 +0200 (CEST)
Date: Mon, 20 May 2024 17:15:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
Message-ID: <20240520151536.GA32532@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08beb913-f525-49e2-8ef2-f62e9d466e53@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

Adding ben and the linuxppc list.

Context: pata_macio initialization now fails as we enforce that the
segment size is set properly.

On Wed, May 15, 2024 at 04:52:29PM -0700, Guenter Roeck wrote:
> pata_macio_common_init() Calling ata_host_activate() with limit 65280
> ...
> max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 65536
> WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 blk_validate_limits+0x2d4/0x364
> ...
>
> This is with PPC_BOOK3S_64 which selects a default page size of 64k.

Yeah.  Did you actually manage to use pata macio previously?  Or is
it just used because it's part of the pmac default config?

> Looking at the old code, I think it did what you suggested above,

> but assuming that the driver requested a lower limit on purpose that
> may not be the best solution.

> Never mind, though - I updated my test configuration to explicitly
> configure the page size to 4k to work around the problem. With that,
> please consider this report a note in case someone hits the problem
> on a real system (and sorry for the noise).

Yes, the idea behind this change was to catch such errors.  So far
most errors have been drivers setting lower limits than what the
hardware can actually handle, but I'd love to track this down.

If the hardware can't actually handle the lower limit we should
probably just fail the probe gracefully with a well comment if
statement instead.
