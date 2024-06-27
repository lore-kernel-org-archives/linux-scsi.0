Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F113C821;
	Thu, 27 Jun 2024 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719500869; cv=none; b=FyUHVrVQJ7JAA68C5AXkHfYFpDmV/T707i2mNDpKk/jhIUHvpjfD77/tH3k9jYM7pfA7/1DGQVqJmEZRRxyVMzy1tQWpzS7MIfOm0PEKnLkIC2ySf24y+GKbTnOhZEiuV6dlGCox/cZE3Ux1yeALUc3zN7dP0XC2zNKiOTl2zTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719500869; c=relaxed/simple;
	bh=iPGyYVEYCxQbDpNFvt8LbPKKMxJ1ovyU3eqvdr40Mz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZIew6Kmnz0c0dm6ASschZ/DJWDpuFxBF3hA4wYJGmY3cbPo1B9gsLLMy0QFIjpl3BPuwcninHxXnK8ZlTHU2nolJJso3qRZgYZRu+e8IXB3MAe8ZNEKonTQ8rULdRwHR1V3TbwL6jq/JkTnzCSqKCBLk89jsiRJ5xRx1MMPSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZavGyM6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZavGyM6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D816C2BBFC;
	Thu, 27 Jun 2024 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719500869;
	bh=iPGyYVEYCxQbDpNFvt8LbPKKMxJ1ovyU3eqvdr40Mz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZavGyM6gY2bhbA3p6HzDF3dKcHOjlhSXPNyO7g9/h+AtPvP6bFin4CzkFq5AFpcyO
	 aqZ3iWS3FDsuw+cLTWvo3LEHN4qXzwY39+Wgaj0gFcf/XlvYpd8pK59Uo0B9wdfGeA
	 z6YI20wSzxsr+I8T8JQMynAPDwEYjfAJ9Xmqycp2z633m3KYr8qTtHivob2zkDKy1i
	 SQdOOIgacXlcJ9sr/nLbmNOk859ABj5JRo0WPygOq1QXMCoW0m6pduNOYnHMS8DXnz
	 NXj1pprVy5hQAN/yi0pJUdc4M+BDCLNoTEWDBN+P5GwHHrYJM0yzna9DRlKzcDoKBP
	 nfegGQmzGbnKA==
Date: Thu, 27 Jun 2024 17:07:43 +0200
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
Message-ID: <Zn2AP6J_RGlYExw9@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>
 <Zn1bxRbAml-HjWKb@ryzen.lan>
 <cd7ff1a0-c73b-4638-be51-2a6d9de4b324@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd7ff1a0-c73b-4638-be51-2a6d9de4b324@oracle.com>

On Thu, Jun 27, 2024 at 01:54:34PM +0100, John Garry wrote:
> On 27/06/2024 13:32, Niklas Cassel wrote:
> > On Thu, Jun 27, 2024 at 01:26:04PM +0100, John Garry wrote:
> > > On 26/06/2024 19:00, Niklas Cassel wrote:
> > > > Hello all,
> > > > 
> > > > This patch series was orginally meant to simply assign a unique id used
> > > > for printing earlier (ap->print_id), but has since grown to also include
> > > > cleanups related to ata_port_alloc() (since ap->print_id is now assigned
> > > > in ata_port_alloc()).
> > > > 
> > > 
> > > There's no real problem statement wrt print_id, telling how and why things
> > > are like they are, how it is a problem, and how it is improved in this
> > > series.
> > 
> > You are right, it is missing from the cover-letter.
> > 
> > It was there in v1:
> > https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/
> > 
> > """
> > This series moves the assignment of ap->print_id, which is used as a
> > unique id for each port, earlier, such that we can use the ata_port_*
> > print functions even before the ata_host has been registered.
> > """
> 
> OK, fine.
> 
> I see code which checks vs ap->print_id, like:
> 
> static void ata_force_link_limits(struct ata_link *link)
> {
> ...
> 		if (fe->port != -1 && fe->port != link->ap->print_id)
> 			continue;
> 
> 
> Is this all ok to deal with this print_id assignment change?
> 
> To me, it seems natural to assign a valid print_id from the alloc time, so I
> can't help but wonder it was done the current way.

ap->print_id was assigned after calling ata_host_register(), because libata
allowed a driver that did not know how many ports it had, to initially call
ata_alloc_host() with a big number of ports, and then reduce the host->n_ports
variable once it knew the actually number of ports, before calling
ata_host_register(), which would then free the "excess" ports.

This feature has actually never been used by and driver, and I remove support
for this in this series:
https://lore.kernel.org/linux-ide/20240626180031.4050226-22-cassel@kernel.org/


However, you do raise a good point...
ap->print_id is just supposed to be used for printing, but it appears that
ata_force_link_limits() and some other ata_force_*() functions make use of
it for other things... sigh...

Hopefully I can just change them from:
	if (fe->port != -1 && fe->port != link->ap->print_id)
to
	if (fe->port != -1)

but I will need to look in to this further...

Thank you for noticing this (ab)use of print_id!


Kind regards,
Niklas
