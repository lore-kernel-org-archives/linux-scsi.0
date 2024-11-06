Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDBC71EF0A4
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 12:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897345; cv=none; b=plDrxXIN9oK9DZwM0r9M/EQQfZlOGmKHMKsM0MamO1JuKWTyP1EEypY7sUepyCZRxtO9JiHWcB4x66r4vQvl+ItbXqUsq4LAZZ+jzP/5FrF/TZ2wwofKwgWOVsNIAXt8KPwwps5zL3FrzdgWzkfvbW1iRiV1smDXjM/ozRHi/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897345; c=relaxed/simple;
	bh=XuBrk/EyG95u/xWuf7dNFJ4jzzPH5TlwHktReoE6kRk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NTr0YmSZMwXPl4MmyOg9+Tt4MAL2v3w3V4NcBqJVm40iNCNF6b7RHP6SjVRaI2eGNUa/3aXz7oCe6AbgwrwlNKEmONp+5zMQZ0MrqpE4b/aVziC3F5QzB2+yoxwHxgg1neRimOuHr9zgT91pqheUjqfGWk5rTOBDkvNjBd9gB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id E25BE92009C; Wed,  6 Nov 2024 13:48:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id DD40692009B;
	Wed,  6 Nov 2024 12:48:54 +0000 (GMT)
Date: Wed, 6 Nov 2024 12:48:54 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
cc: Magnus Lindholm <linmag7@gmail.com>, linux-scsi@vger.kernel.org, 
    James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: qla1280.c
In-Reply-To: <20241105093321.3ad1c1a7@samweis>
Message-ID: <alpine.DEB.2.21.2411061156030.9262@angie.orcam.me.uk>
References: <20241104204845.1785-1-linmag7@gmail.com> <alpine.DEB.2.21.2411042134240.9262@angie.orcam.me.uk> <20241105093321.3ad1c1a7@samweis>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Thomas Bogendoerfer wrote:

> On Mon, 4 Nov 2024 21:52:36 +0000 (GMT)
> "Maciej W. Rozycki" <macro@orcam.me.uk> wrote:
> 
> > On Mon, 4 Nov 2024, Magnus Lindholm wrote:
> > 
> > >  Use dma_get_required_mask() to determine an acceptable DMA_BIT_MASK 
> > >  since on some platforms, qla1040 cards do not work with a 64-bit
> > >  mask. For example, on alpha systems with more than 2GB ram a 64-bit DMA mask
> > >  will result in filesystem corruption, but a 64-bit mask is required on
> > >  IP30/MIPS.  
> > 
> >  This is missing the point, you get filesystem corruption because *your 
> > card* does not support 64-bit DMA addressing and not because your Alpha 
> > system has an issue with it.
> 
> I've checked one of my Octane boards and there are ISP1040B chips on
> the board, so even ISP1040B is able to address 64bits.
> 
> How does the memory map look for more and 2GB ram on the ES40 ?

 Memory is added linearly from 0 up to 32GiB in the host address space, 
but that that's not how it's addressed from the PCI side by DMA masters.  
Here's how Linux sets up PCI DMA decoding windows with the Tsunami/Typhoon 
chipset:

	 * Note: Window 3 is scatter-gather only
	 *
	 * Window 0 is scatter-gather 8MB at 8MB (for isa)
	 * Window 1 is scatter-gather (up to) 1GB at 1GB
	 * Window 2 is direct access 2GB at 2GB

(window 3 is not enabled by Linux).  Windows 0-2 decode up to 2GiB each 
anywhere in the 32-bit PCI DMA address space and map to memory anywhere in 
the host 32GiB address space (SG requests do this via IOMMU).  Window 3 
can work the same as windows 0-2 or decode 4GiB anywhere in the low 32GiB 
of the PCI DMA address space.  The monster window previously mentioned 
maps 32GiB of host address space directly at 1TiB in the PCI DMA address 
space.

  Maciej
