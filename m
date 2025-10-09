Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54452D3EEE;
	Thu,  9 Oct 2025 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760010113; cv=none; b=RYqPJZNXUa8KrS4ynqWdHLYN967W0W0eQTrBfkciu6D6sUXUja1an8YbgFiIIoKTwow2CkyppGtQvUUZdkLrPgPZBLcFJPhh698cRzC7Oni0JWBbO9tTMgj6jTrMT5QGiDBiMBdueMekCrWH79zwqJVFcCWwG+YXqrhFEAm7urw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760010113; c=relaxed/simple;
	bh=AcffB+LSP0u+aqjYrWd41zf5HBiFGbQxA/z5xaGx4PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RE6SH6Lr9oHSuH9Uu55G6P+8RoQXoO6xdaPeUUsQA/DigvDR7W93n1UeK5Od4CzSSDXWGnqXDuhcA71BuPJFtcnDL1oZdgSqQ6amjpQio12RlFcPTY9cU8HpkWTq3ywKbL2B/PUE+CCaer6rDzoTVPlzs5BfWrUU3grWoJpIbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtnkCy1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtnkCy1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D3EC4CEE7;
	Thu,  9 Oct 2025 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760010113;
	bh=AcffB+LSP0u+aqjYrWd41zf5HBiFGbQxA/z5xaGx4PI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WtnkCy1brH6oMLrE167uUvmCNjIOZ+Wfu6ev2XoMTqCnoIZ53WISyzzaRj3nisg9X
	 cozGRshYoRk1wrPjZe0Wsh6JVsfax80NFOcqQBatyus2Edapric7W1VHFd2ioMrvlT
	 UoG7Nnf6OxJh3cs8LD3GyUxIXkN1iHjzZaIbWMC1GniceHbnWG5BGxZwZ5XYLA00ON
	 PXUm7TYInmj57MVYAzalAmVvBt5CVG68jzEDVcWE/60bSjukxsosC78H5WXhuWimJ9
	 3ZQTBGrNHEffFT0cIIs4F5qaJnGJcF54+GNsVhSFux4dbncKDBYoI0z1YuZ5iqysuo
	 J9D+IKyYYL9Mw==
Date: Thu, 9 Oct 2025 13:41:49 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Power on ata ports defined in ACPI before probing
 ports
Message-ID: <aOeffbuAIxeuimHC@ryzen>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
 <20251005190559.1472308-1-markus.probst@posteo.de>
 <20251005190559.1472308-2-markus.probst@posteo.de>
 <aOPbLlvbfFadVQsV@ryzen>
 <64a9f3b1d96ac90efbf5879b7663e0152f38b167.camel@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64a9f3b1d96ac90efbf5879b7663e0152f38b167.camel@posteo.de>

On Mon, Oct 06, 2025 at 03:50:35PM +0000, Markus Probst wrote:
> On Mon, 2025-10-06 at 17:07 +0200, Niklas Cassel wrote:
> > On Sun, Oct 05, 2025 at 07:06:07PM +0000, Markus Probst wrote:
> > > some devices (for example every synology nas with "deep sleep"
> > > support)
> > 
> > Some devices?
> > I assume you mean the HBA and not the devices connected to the HBA.
> Embedded devices. There are 2 connectors to a sata disk. One for the
> data connection to the sata controller. Another one to the power supply
> (so the disk gets the power). This patch tells the power supply for the
> disk to give the disk power (if one is defined in acpi).

Ok, please add this to the commit message.


> Synology produces NAS devices. Some of those devices have something
> they call "deep sleep". In this case, if a sata disk gets power is
> controlled by a gpio and is *off by default*.

Please add this to the commit message.

We already have DevSleep, which is a feature implemented in the SATA
specification, where the HBA asserts a signal (DEVSLP, which on some
boards is just a GPIO), while this signal is asserted the device may
completely power down its PHY, and it may also choose to power down
other subsystems, as long as it can meet the exit latency requirements.
(The device should exit DevSleep when the DEVSLP signal is deasserted.)

For more info see e.g.
https://sata-io.org/sites/default/files/documents/SATADevSleep-and-RTD3-WP-037-20120102-2_final.pdf

Since this patch implements something similar to DevSleep, but rather,
IIUC, for the SATA power itself?

How is SATA power supplied tied to a port in ACPI? If you have a desktop
you have a PSU, and don't really know which supply is for which port.


In SATA, we also have PxSCTL (SRC2: SControl) where we can completely
disable a port and port the PHY in offline mode, see:
https://github.com/torvalds/linux/blob/v6.17/drivers/ata/libata-sata.c#L415-L419


So, considering how many ways we already have to disable/power off a port,
you might understand why I think it is extra important that you document
exactly how, and why we need yet another way to disable/power on/off a port.



Kind regards,
Niklas
