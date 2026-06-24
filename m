Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080B9310651
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782339380; cv=none; b=HmnBLDB4PCUSX24vLWn5uX0HlO1//qKxq1y3yP4SXoRJXJNgyQmqzysV1fLnK8h1Kat0kU3fg5vVBaB4U4mT/+xNAQznkvYhQiqRB9nQuQ4wFd8jjs5+1HmTBeXvLKGY9tdCmORwnrz1XuWWH/G1aeylP7J5QxYPvTZHvMVYVVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782339380; c=relaxed/simple;
	bh=Lj4+EHFa//OPdOZkjLaZEUguaXmLHc1lhElHfm1SGpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tvnc9kAJk9ZqHhcuPdUaE+tt9HjceIA49+ZP9FgnUIcBWb3hbavHpNLW8c3gCDyJkqHIiZp5CZde3nxJVxwr8yLCxznvYz4446HOLffGlgdNsyuOhgNz9snZiiEh9/B9vP3D5utThUKlD7/wduCER1SoeL1ieWJWIqsolOeDnnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A47U5WQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A47U5WQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0C01F00A3E;
	Wed, 24 Jun 2026 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782339379;
	bh=YZ7P6x0uVaMNQmDhu5KfMAfMzMZBFhtl1uMICs1hfBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A47U5WQmp85bx4BlCi3DS/oP6Hc0aEm9F40ZTtYyh11oDBCk7qx3nQpVhvIyYR69a
	 qlEzcz6cWqID8zMwpUw+CVMKJMfrZFTk9JbdAujrdjiUQdzdelAG5VHWJbkW5bGKg8
	 Z74uqb/ivloCpT92S5ecsAF7poEeqEOVAy1sAHzzR0Lofl+n/7F0w8qCuIrYzJNwkQ
	 8ZdvmnYFwjo6yu0dtYzbXe/5MOQu1ZiYbnXtJLH6uQHmDEN+OdWGmYAQagQS8T8vfS
	 FE8vJttCwxVUzEfJIzHVe/itoOk+1MsAiq5mdGQG0NZzN0zZGV7bwXi+3jnepSU4c5
	 5Ck3abhBjAoRQ==
Date: Wed, 24 Jun 2026 16:16:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Maurizio Lombardi <mlombard@arkamax.eu>,
	John Meneghini <jmeneghi@redhat.com>,
	Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de,
	chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <ajxXMblhuipjnbtS@kbusch-mbp>
References: <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp>
 <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
 <ajRpWLqaEyA6cwkJ@kbusch-mbp>
 <531aa19b-a9ae-44f7-82ce-3714621ceee8@suse.de>
 <ajWOWdD0P5ri9bWY@kbusch-mbp>
 <d46493a3-3c9c-4799-bd63-e8759f04463c@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d46493a3-3c9c-4799-bd63-e8759f04463c@suse.de>

On Mon, Jun 22, 2026 at 09:15:16AM +0200, Hannes Reinecke wrote:
> But then you'll have to delay the (re-)scan until the very last reference is
> gone, otherwise the nsid the scan is about to create
> will be blocked by the nsid still pending to be deleted.

It's not about the last reference. Either something changed or there was
some previous misunderstanding when that kobj name uniqueness was
introduced to this driver. We just need to wait for del_gendisk to
complete, which is usually already serialized in the same scan_work. It
doesn't appear to matter if a reference is held on a kobj waiting to be
deleted.
 
> In general I fail to see the issue here.
> Any modern distro should be using persistent device links to access
> devices, so the actual device name is pretty much irrelevant.
> We on our side haven't had any issues here since ages.

I agree there's not a real issue here. The suggestion is purely a
quality-of-life improvement to provide a visual clue that aligns with
people's expectations, reducing any surprises. There are people and
documentation that still think the "n1" in the nvme0n1 means it's NSID
1. If we can easily align to that, then why not? But I'm not exactly
needing this feature either, so if you think there are some "gotcha's"
here that may destablize the current scanning, then I have no
problem shelving this one.
