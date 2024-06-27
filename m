Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987841E480;
	Thu, 27 Jun 2024 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719491531; cv=none; b=Iu8XEHZtDjJOid2zDr6cWAwUBkwjHE9Hd9gO9IZfmRVAdk9lkEjBJ1kLA90JWOyZnRc5iZk0KwLEPuSxuAx79XBw41OLMZO+67A6Kr3AbNnmgx7b1m9wo3S232I1C12DtpxmEEXvjvZ9kC8CV6fFMRjAGhOWu9HOcVdSTdwZAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719491531; c=relaxed/simple;
	bh=EL7HVlB7zXAW8gTbENW09D8qFmZ3iorNW6nPJC62H7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIjUGxOItIZTmweQI1WXL0dRTi/glPuxsshvzMXyD+fLS0Xhsup1oHoq56ylNSFj6J/MeQX3+RQt3o+OJ7n6diMBTIwCE+j1h9KEGHxQ0ZJBiK8UYm8xOkk/nNd0K/aRF2xnMCrtmPXfstYWnMMGirKZnXuNVRmSvdP5ebaPt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIb3CL8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIb3CL8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687B6C32786;
	Thu, 27 Jun 2024 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719491531;
	bh=EL7HVlB7zXAW8gTbENW09D8qFmZ3iorNW6nPJC62H7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dIb3CL8GTE/BQzVCTKyTLur2fpnImVc0Ujp3ejSdtRP+KFUN4vAnePda3RI8ia0iY
	 qLB23aBnDYKD5NBiPb2JPOfSypmrdW0rbZStrY/sIIzOICg/nsL1plWhAKokhIkCXk
	 WVJWUxeVyaiRZh/wsfBy61X2cS6+taRi9nzN5cEj2yNmJQcJUy63xbRfvBYSg6mY53
	 hMQ6Vliau4k3p5odqVJJeY6eAWKdzKS3ubtXQHQ+l66b3mjk13oQyFLI8ns33CAHIX
	 wmQlyAOgcxiCaqtRedUakdJCzCDMkyBZ77wgY7+XDedj/GFhmAMwPtv+/KvpdfLJVz
	 VtMsmiwhAVfgg==
Date: Thu, 27 Jun 2024 14:32:05 +0200
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
Message-ID: <Zn1bxRbAml-HjWKb@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>

On Thu, Jun 27, 2024 at 01:26:04PM +0100, John Garry wrote:
> On 26/06/2024 19:00, Niklas Cassel wrote:
> > Hello all,
> > 
> > This patch series was orginally meant to simply assign a unique id used
> > for printing earlier (ap->print_id), but has since grown to also include
> > cleanups related to ata_port_alloc() (since ap->print_id is now assigned
> > in ata_port_alloc()).
> > 
> 
> There's no real problem statement wrt print_id, telling how and why things
> are like they are, how it is a problem, and how it is improved in this
> series.

You are right, it is missing from the cover-letter.

It was there in v1:
https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/

"""
This series moves the assignment of ap->print_id, which is used as a
unique id for each port, earlier, such that we can use the ata_port_*
print functions even before the ata_host has been registered.
"""

Will re-add it in v3.


Kind regards,
Niklas
