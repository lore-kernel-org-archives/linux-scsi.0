Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C24015D5B3;
	Tue,  2 Jul 2024 15:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719935008; cv=none; b=eOTKZzyNSdKIb07iN4b9Avou6+eswzxOtx9xS92PDdeheczoEEETtZ36339JvqnWPVfYXWjCuTLCvjbGu4lGtAhe7RsHazVr99nmhb+bW9RiEzMF1rzoUPA1CTKMsDx7kSesSlfGEOS6wYceqhR/dV3bVlnzs7iHT9eWwGrxZ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719935008; c=relaxed/simple;
	bh=ztoyBVx1RliditdEcK8GDR2wus22s80Sv/3hM8P8l9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlZ13jxBp90ubSbhDH8G/csu7RgW52d0IgpkJc4BS+gyhZeqK5S5MHimSNpMVTZVB9XybAtN40tHdCGHk7x/xT7G1hdZgk3qYRqBqr2zL8HZrtNtME1eVqpXGoRL/JXFXYETt0CZ6NoXXLUdS84vcV5fcTIaqmWJkbQ9s8cPPiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEt62yeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEt62yeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA67C116B1;
	Tue,  2 Jul 2024 15:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719935008;
	bh=ztoyBVx1RliditdEcK8GDR2wus22s80Sv/3hM8P8l9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEt62yeZS+nczfgLUve/oiLEAW7QDccc4dwVfUxJuLH+lhSXBKCbDJxZibP+iaZms
	 p2+h11MMywbDiUKtbE4+sSkjhv4BjlJGeM6UhYCaunamwbJlvQ8wutMwu4xZSwWdMj
	 +hQu7CgRPT6V6yDBOrll+IdBM5+jz/JJvA3uPd8d0+QjFCp1qpRYnH2ts3hqkwekFt
	 r9cAcG53qtO+YLvp+7dwhpAdjZ/+vc5ZfAusF4wBcShsgL5q0Rqkg4O2YIyLkblRnO
	 iOENR3vwqHTixiotjlP0zLNhhvCNGrEeUKRyCLBYw6GjV54w/OOjM7L8mTOKh1s5FO
	 VAGR4fPqIKzCA==
Date: Tue, 2 Jul 2024 17:43:23 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port
 print_ids
Message-ID: <ZoQgG98TBYx3Q4FL@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-26-cassel@kernel.org>
 <3672b5e6-4842-4ffc-b55b-352359aa39a9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3672b5e6-4842-4ffc-b55b-352359aa39a9@kernel.org>

On Thu, Jun 27, 2024 at 10:37:40AM +0900, Damien Le Moal wrote:
> On 6/27/24 03:00, Niklas Cassel wrote:
> > Currently, the ata_port print_ids are increased indefinitely, even when
> > there are lower ids available.
> > 
> > E.g. on first boot you will have ata1-ata6 assigned.
> > After a rmmod + modprobe, you will instead have ata7-ata12 assigned.
> > 
> > Move to use the ida_alloc() API, such that print_ids will get reused.
> > This means that even after a rmmod + modprobe, the ports will be assigned
> > print_ids ata1-ata6.
> > 
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> Looks good. But maybe it would make sense to squash this together with patch 10 ?

Patch 10 initializes the print_ids earlier (which is a perfectly
fine change on its own, even with the old way to assign print_ids),
while this patch changes for the print_ids to be reusable.
I think that logically, it is two different logical changes
so I will keep them as separate patches in v3.


Kind regards,
Niklas
