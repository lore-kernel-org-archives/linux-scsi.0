Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C5214D42C;
	Tue,  2 Jul 2024 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719934992; cv=none; b=ePgBZ+fSfxECEP22MelbA5OKbFUEzHtbo3vWnuDMNAjVcSwIzr82ZPuVHmhpWUyhfRrQZzdJ4lG9G8LP6kr0wRJOWa77kbak1c5OZvHFRi1sgrD6Hd1i24Z+HytucdKJc+xhTWA49r7uaUZQcud/tjdMxccoLXK1czOAKJMdMrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719934992; c=relaxed/simple;
	bh=HLjNTwA5AGcDBz3W47x5Ip7RjCeGD9o3Yb5T6CcTeoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAVssTikZU01ZFfrcENj53hwTf8SB4xjXmLJ3RlIhCEtP/4seGDw9w5636eoHpj2dPMt/13BdGHUGhfjarUVy0Isi6PuWwH6dPbEvdQCu8Yfav7sO78hWs2wb1S5nZt7EGNSz3ATCay4bwq2nQzJ0Dijhqpq7fExIr0iswX1wKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAyju344; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAyju344"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6F2C116B1;
	Tue,  2 Jul 2024 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719934991;
	bh=HLjNTwA5AGcDBz3W47x5Ip7RjCeGD9o3Yb5T6CcTeoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GAyju344UvASfv2CnkS8dGTogNw5pdE1hbleGcEpU0vSSHK9wc7dcSS0kvtodE6eA
	 0xBMExhKxpyQ6UWptTJIYKFhhr2UGz2kRmpb32JwQroGYSikYPIitUjePCVrCfn8Vq
	 +Owm2JpVXXuPoaQpTtZtRT03RXHb+itp6eHIBu7xAb5BlD+gLU5NSpVDCSRQg7iWpA
	 txuuXAZWCiAxEiJ2Y7Zs0CpK+vxiT+0asC0XNDJUGiT509jHdQvRFXltMWG4qTnagC
	 lxonxbbvY8/gRgSi/aoUjs2rEf9syrwHT/4DzA/QV9fWYw4ZswpyGjj39EzuxIt15G
	 TIUGgkLwGPOUQ==
Date: Tue, 2 Jul 2024 17:43:05 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 00/13] ata,libsas: Assign the unique id used for
 printing earlier
Message-ID: <ZoQgCUL0H4Qzhvow@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>
 <Zn1bxRbAml-HjWKb@ryzen.lan>
 <cd7ff1a0-c73b-4638-be51-2a6d9de4b324@oracle.com>
 <Zn2AP6J_RGlYExw9@ryzen.lan>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zn2AP6J_RGlYExw9@ryzen.lan>

On Thu, Jun 27, 2024 at 05:07:43PM +0200, Niklas Cassel wrote:
> On Thu, Jun 27, 2024 at 01:54:34PM +0100, John Garry wrote:
> > On 27/06/2024 13:32, Niklas Cassel wrote:
> > > On Thu, Jun 27, 2024 at 01:26:04PM +0100, John Garry wrote:
> > > > On 26/06/2024 19:00, Niklas Cassel wrote:
> > > > > Hello all,
> > > > > 
> > > > > This patch series was orginally meant to simply assign a unique id used
> > > > > for printing earlier (ap->print_id), but has since grown to also include
> > > > > cleanups related to ata_port_alloc() (since ap->print_id is now assigned
> > > > > in ata_port_alloc()).
> > > > > 
> > > > 
> > > > There's no real problem statement wrt print_id, telling how and why things
> > > > are like they are, how it is a problem, and how it is improved in this
> > > > series.
> > > 
> > > You are right, it is missing from the cover-letter.
> > > 
> > > It was there in v1:
> > > https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/
> > > 
> > > """
> > > This series moves the assignment of ap->print_id, which is used as a
> > > unique id for each port, earlier, such that we can use the ata_port_*
> > > print functions even before the ata_host has been registered.
> > > """
> > 
> > OK, fine.
> > 
> > I see code which checks vs ap->print_id, like:
> > 
> > static void ata_force_link_limits(struct ata_link *link)
> > {
> > ...
> > 		if (fe->port != -1 && fe->port != link->ap->print_id)
> > 			continue;
> > 
> > 
> > Is this all ok to deal with this print_id assignment change?
> > 
> > To me, it seems natural to assign a valid print_id from the alloc time, so I
> > can't help but wonder it was done the current way.
> 
> ap->print_id was assigned after calling ata_host_register(), because libata
> allowed a driver that did not know how many ports it had, to initially call
> ata_alloc_host() with a big number of ports, and then reduce the host->n_ports
> variable once it knew the actually number of ports, before calling
> ata_host_register(), which would then free the "excess" ports.
> 
> This feature has actually never been used by and driver, and I remove support
> for this in this series:
> https://lore.kernel.org/linux-ide/20240626180031.4050226-22-cassel@kernel.org/
> 
> 
> However, you do raise a good point...
> ap->print_id is just supposed to be used for printing, but it appears that
> ata_force_link_limits() and some other ata_force_*() functions make use of
> it for other things... sigh...
> 
> Hopefully I can just change them from:
> 	if (fe->port != -1 && fe->port != link->ap->print_id)
> to
> 	if (fe->port != -1)
> 
> but I will need to look in to this further...

So, looking more closely at this, the code is actually not abusing print_id.

Looking at libata.force in Documentation/admin-guide/kernel-parameters.txt:

[LIBATA] Force configurations.  The format is a comma-
                        separated list of "[ID:]VAL" where ID is PORT[.DEVICE].
                        PORT and DEVICE are decimal numbers matching port, link
                        or device.  Basically, it matches the ATA ID string
                        printed on console by libata.


While this seems a bit fragile, since it relies on the probe ordering
of the SATA controller drivers, which could change, it does still work
as designed after this series:

I added the following to my kernel command line:
"libata.force=5:nolpm"

which yielded:
[    1.811464] ata3.00: FORCE: horkage modified (nolpm)
[    1.811466] ata3.00: LPM support broken, forcing max_power
[    1.811468] ata3.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    1.811470] ata3.00: 2097152 sectors, multi 16: LBA48 NCQ (depth 32)
[    1.811474] ata3.00: applying bridge limits
[    1.811535] ata3.00: LPM support broken, forcing max_power
[    1.811537] ata3.00: configured for UDMA/100

And considering that all checks against ap->print_id is for libata.force
related parameters, I think that we are all good.


Kind regards,
Niklas
