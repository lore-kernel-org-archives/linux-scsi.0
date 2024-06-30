Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C6639855;
	Sun, 30 Jun 2024 21:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719781353; cv=none; b=oYDAHOTP1ZZIfNlEVc1xsMLK4v4Q2AQef8eC5oexGZdRcyAxRYsRBvlLUvqMda8+hceyGz9S6TinwCU3vf+Cb7DR9jYUUcRTDzm9z+YSyxYVj2CojGKaYZzWU4p6VX0C6/AcYagVar4h701HjwQrrXQk2H4M0p8pBgKPt/v8Io0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719781353; c=relaxed/simple;
	bh=089eDc9zyjGT3Wa6FdBkDwVbU/8kdk+qXH2Zva7N2HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/eItvdLxJHOo639FVJu0l5NWoAY0PeWxTN/1UKoaVAjd1N8Y/HqNR7R5WtQ9PeJerUAbAEpIkml1ztQsMsdxkPBYiCi8+hdCs4zLt1O2Twc2I7nQATdqmluZQKNROFb8Uq7KVz2cwZWuq/AYDyc7s9sB5EzU1VYjkeGu0n8QEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4BYuO3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4BYuO3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDFBC2BD10;
	Sun, 30 Jun 2024 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719781353;
	bh=089eDc9zyjGT3Wa6FdBkDwVbU/8kdk+qXH2Zva7N2HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4BYuO3tYwuYfrJAyGGixOsXMOpTlnoWuFR73BILUOtN5pDiuF3tfgnOm2Z+4lBpG
	 hdD4m4NtWYJb8DHhnYbxcddW11TJuhz/HgspMLYa4RHIAt0g+pDB79wyfgCskOeCV+
	 47pJHjCkJh4aAjulbh9T8Ptgcf1R7Xz50oAhzEB1w+N106Cd72+3Dv3cQ+51M5yCQM
	 aGvJzIt0Usk1Ib6oXj2o0txunp5HV7+L2bUfgQMLGHINsnAhYhmMRSUZD4rb13v0R2
	 3jnqbjbdEyPJDatBeYJJfz1q9xajiNt6svHqNNXoVJv8yq6FY4q0WvlhEy5yjSs5Jl
	 AdDt0srEE2i1g==
Date: Sun, 30 Jun 2024 23:02:27 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Colin Ian King <colin.i.king@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/4] libata/libsas cleanup fixes
Message-ID: <ZoHH47jc5E-a8iV6@ryzen.lan>
References: <20240629124210.181537-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>

On Sat, Jun 29, 2024 at 02:42:10PM +0200, Niklas Cassel wrote:
> Hello there,
> 
> This series takes the patches that are -stable material from this series:
> https://lore.kernel.org/linux-ide/20240626180031.4050226-15-cassel@kernel.org/
> 
> Changes since series above:
> -Fixed minor review comments for the four patches included in the series.
> -Picked up tags.
> 
> 
> Kind regards,
> Niklas
> 
> 
> Niklas Cassel (4):
>   ata: libata-core: Fix null pointer dereference on error
>   ata,scsi: libata-core: Do not leak memory for ata_port struct members
>   ata: libata-core: Fix double free on error
>   ata: ahci: Clean up sysfs file on error
> 
>  drivers/ata/ahci.c                 | 17 ++++++++++++-----
>  drivers/ata/libata-core.c          | 29 ++++++++++++++++++-----------
>  drivers/scsi/libsas/sas_ata.c      |  2 +-
>  drivers/scsi/libsas/sas_discover.c |  2 +-
>  include/linux/libata.h             |  1 +
>  5 files changed, 33 insertions(+), 18 deletions(-)

Martin, James,

considering that the libsas change is extremely trivial,
and that the libsas maintainer (John) has added his R-b tag,
I will simply take this via the libata tree.

Please tell me if you have a problem with this, and it will
never happen again. (I would never do this for something that
wasn't extremely trivial.)


Kind regards,
Niklas
