Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7A8745F4;
	Fri, 31 May 2024 08:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717142794; cv=none; b=ENwcTK9QBAjziuRzLYVEZLFGhPib5rRWrzpO6dGB0yNk17nTC5Vy1B+hNx3/cKvYFi+LEV+5rMKtWN2LpPt6fhCdbz0GHneaT0P1GXAmZdTmLNTSOrxdIMFT+BbTqx6y7MpaJE9+E1e1mhRCPhtyxDXPPafqbEK5jS1oWXyE4jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717142794; c=relaxed/simple;
	bh=VPUioJ9IncgAwqbCt6ppxEi5MBR+Hh4+6TY5inBUiPA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fCOyrglM3Y7r8r9rPapAunm12ukWDMWNeDgUbyT/ys0Y4LuQ+a8NnWGGeK2VSvIwCyyB7V1wtnmgQWwSkihfw/1eZXEvUGmga0y9EGgjJZwnVXbjqZZA+WP1yVkOC3a1QU3lxndpM5FD1GUZXvqSPT9GbKxJt5FpxKUtAgXDXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=D4JcyVTt; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="D4JcyVTt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717142790;
	bh=FYUiRJCdcnCVjMOkEnGgfbId1LsBcdzYwyyPQhPx3DE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=D4JcyVTtiYxOq8Zi6clWE/K+RQvgcOoOcksTd+TGoBTn6QqgfD0G3Y+8vnqGe53w5
	 ihbPLxd2u8e1mibwi3NIqIbhPqqH+5s43bD7wz3LReLwcgZxdGl/JUlV44vrqwc9us
	 tadf7bLnJyxZusxHqjaS9V5h87dZB0ysq5dThakJ0dbh6+HVn2fQJg6etSDzwhlT19
	 kbdE60JlKyhWoSRR/ebuxz6/JcIrH8Tt2llmKTeQg6LjxV1ssegJgz5/OMkPDFIms/
	 haKV7w1yx+taUZDjOve+jaQn7guhicMOMaffYrEgPZNWXL1+dS/z3ykXnLWmpJfKSY
	 B3Qa5khAO1AvQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VrG0h2Df2z4wqM;
	Fri, 31 May 2024 18:06:28 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Christoph Hellwig <hch@lst.de>
Cc: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>, John Garry <john.g.garry@oracle.com>, Jens
 Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Damien Le Moal <dlemoal@kernel.org>, Niklas
 Cassel <cassel@kernel.org>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, Guenter Roeck
 <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>, Linux kernel
 regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
In-Reply-To: <20240531060827.GA17723@lst.de>
References: <20240520151536.GA32532@lst.de>
 <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
 <8734pz4gdh.fsf@mail.lhotse> <87wmnb2x2y.fsf@mail.lhotse>
 <20240531060827.GA17723@lst.de>
Date: Fri, 31 May 2024 18:06:25 +1000
Message-ID: <87sexy2yny.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Christoph Hellwig <hch@lst.de> writes:
> On Fri, May 31, 2024 at 12:28:21AM +1000, Michael Ellerman wrote:
>> No that's wrong. The actual hardware page size is 4K, but
>> CONFIG_PAGE_SIZE and PAGE_SHIFT etc. is 64K.
>> 
>> So at least for this user the driver used to work with 64K pages, and
>> now doesn't.
>
> Which suggested that the communicated max_hw_sectors is wrong, and
> previously we were saved by the block layer increasing it to
> PAGE_SIZE after a warning.  Should we just increment it to 64k?

It looks like that user actually only has the CDROM hanging off
pata_macio, so it's possible it has been broken previously and they
didn't notice. I'll see if they can confirm the CDROM has been working
up until now.

I can test the CDROM on my G5 next week.

cheers
