Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D21A238F
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781894749; cv=none; b=my2ZCRKzS4druqN/cwrrXJHn2hXIWhB6lsuFODqC7wslW2cPj0TGefV5KdNFxUz+JnI6PR0rh23WxSm1Tdnepn4+WSOIOHKvG0uVQ9qa7o3WN64RO91H4txwHx3HfJggMuWwV80/Y5+/RFuv2Od+H/MBos3F3/QqBBWYhIx5cWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781894749; c=relaxed/simple;
	bh=FBa36oetGM98CKDff4iQR1LHwkI39+FDS5gJw9MMV/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khYPMPyB/PE8cIT9jkMRfIJeJ6EwTkuvCP8u0GpNdsV4P2wt6ZrqDZXnBa4naP99vjOFKYIT1CjhKY+2N9tCHZTdLn8xztGnt6VDiuQlgMEz8DXbW7jSfOK9S2cGU9DuYieQtte9Nc2u3E5k9JfNMsC3EPKebSOp/cLHdjuZ1sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUvuJba0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUvuJba0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C901F000E9;
	Fri, 19 Jun 2026 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781894747;
	bh=FBa36oetGM98CKDff4iQR1LHwkI39+FDS5gJw9MMV/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUvuJba0n1qxs8+Uo/JYny0hhls3tq1Y9GEi5Y5BlP96op/MYpnRgKOndu6FYHi9p
	 ABMyNUidg9ZUeKtxwIyX+ypGg9a2ESByu1BxCI3ItMixPtxnBeZJw3otEoeBlOymHP
	 nJKbT094QZpe5NIyzMtWXEyONLLlnBtUTrzKJ8BQHpMkpdmXLKGCZpmNwJtnTNcbTr
	 CT91PJ9TI6MdWbzC/y0vlzzi4L8L9691gtQt/qCaleyMtpsb0d28E+HQj6DfUgTyUd
	 JXEVI5zHj3vXY5ToHQF+HxE9OIfv6m7j2rL5m7zspSuDE+COyN+MQ53P5T7R1goQjQ
	 dok0tsokqXqdQ==
Date: Fri, 19 Jun 2026 12:45:45 -0600
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
Message-ID: <ajWOWdD0P5ri9bWY@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
 <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp>
 <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
 <ajRpWLqaEyA6cwkJ@kbusch-mbp>
 <531aa19b-a9ae-44f7-82ce-3714621ceee8@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531aa19b-a9ae-44f7-82ce-3714621ceee8@suse.de>

On Fri, Jun 19, 2026 at 07:59:43AM +0200, Hannes Reinecke wrote:
> The problem here is namespace lifetime. The ns_ida is only ever released
> at the very last step, so the 'number' of the namespace will only be freed
> once all references to the namespace are dropped.
> So if you were trying to keep the namespace number ordered you would
> have to delay the creation of the namespace until that point, and you
> would induce a serialization between deletion and creation.

Under the proposed scheme, there is no ns_ida. You just use the NSID of
the namespace, and that's it. You have to ensure that del_gendisk
completed on all heads and paths that was using it prior to bringing up
the next one, but that's not really a problem.

The problem I recall has something to do with the nsid not being a
consistent value when migrating a namespace to another array or
something like that. Not that we currently have proper support for such
a thing...
