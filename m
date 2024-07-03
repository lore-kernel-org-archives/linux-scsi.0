Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA207135A71;
	Wed,  3 Jul 2024 08:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994031; cv=none; b=UyN5+MVxWRSK2Ww9EZWAhz4EwBaPIQ8rZmT9+9Gow3CV19ukn5mA/DKzypu8AaQHOlTddlPEN9Cv6aevsiYNfnW4ZbMJwez2X9qXh3pplfaTpb12xHKscvmvmW0PBOQc50qTtUOBFQrx8aAvF7FF1VYqZd8kRswUcG0ASVYBJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994031; c=relaxed/simple;
	bh=o/hgR8obRKqAvu07nE1lIk27U3jdcw4bc1ebYyti7mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bB5H0B+pQG/bF6e7T/uX59saDjgwGbmEgos+5h9eLJa6Z8mDVGoe0ILI+stOzO7Uvv57slhlz34OPk7btsbCSkPGQzd9w5HCP+UXazkK4rcvdewFZLc0DLN2dcldcTzM3pJ+9GBf65dBwltDwJj/we0rXbrlZIYnFc9jGCdwqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tN+Bn/nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tN+Bn/nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091DC2BD10;
	Wed,  3 Jul 2024 08:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719994030;
	bh=o/hgR8obRKqAvu07nE1lIk27U3jdcw4bc1ebYyti7mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tN+Bn/nAFIE80k8vazvoZkrY2tapMa9OVyS/QQ30UMqofH0OmVgwLUrM/as7qMVVZ
	 0W5vBuNk6fXZ0uAB/H1Jvtqil7FhlWhgJoDzrxDcWev9zrk7B1AD8XmcEYDCGdHbz6
	 JzhHM7tZ3/fmeFh1B4GqRwwgW7+6VDPQG73u6Sty8sxu5X3QfV5vmrhxb/vFbGPtFL
	 l/hltGnWkDMypekJP4MKm/U0MA7rL315ON4C5MwvDnEtDtOZ9COmxe532oFITZotcL
	 1zNkqb3n3bJTVYmWIq6+oID2vfHzWR/iRwna8EbOiKhFsfoxbrs+D5jVz6bdLqzV6i
	 Kfmg49p9Um8Hw==
Date: Wed, 3 Jul 2024 10:07:05 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 0/9] ata,libsas: Assign the unique id used for
 printing earlier
Message-ID: <ZoUGqUxVMqKQioiL@ryzen.lan>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>

On Tue, Jul 02, 2024 at 06:07:56PM +0200, Niklas Cassel wrote:

(snip)

> Niklas Cassel (9):
>   ata,scsi: Remove useless wrappers ata_sas_tport_{add,delete}()
>   ata: libata: Remove unused function declaration for ata_scsi_detect()
>   ata: libata-core: Remove support for decreasing the number of ports
>   ata: libata-sata: Remove superfluous assignment in
>     ata_sas_port_alloc()
>   ata: libata-core: Remove local_port_no struct member
>   ata: libata: Assign print_id at port allocation time
>   ata: libata-core: Reuse available ata_port print_ids
>   ata,scsi: Remove useless ata_sas_port_alloc() wrapper
>   ata: ahci: Add debug print for external port
> 
>  drivers/ata/ahci.c                 |  4 ++-
>  drivers/ata/libata-core.c          | 41 +++++++++----------------
>  drivers/ata/libata-sata.c          | 49 ------------------------------
>  drivers/ata/libata-transport.c     |  5 ++-
>  drivers/ata/libata-transport.h     |  3 --
>  drivers/ata/libata.h               |  2 --
>  drivers/scsi/libsas/sas_ata.c      | 12 ++++++--
>  drivers/scsi/libsas/sas_discover.c |  2 +-
>  include/linux/libata.h             | 11 +++----
>  9 files changed, 36 insertions(+), 93 deletions(-)

John,
could you please help out with reviews on the patches that touch libsas?
Would have to queue them latest end of the week in order for them to have
at least two weeks in -next.

Martin,
is it okay if we queue this whole series via the libata tree?
Just like the last series, the libsas changes are very small.


Kind regards,
Niklas
