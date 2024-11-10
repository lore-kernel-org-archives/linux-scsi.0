Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80214CDEC
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731254372; cv=none; b=cNxAEKow2Yeb0dmHzcQl+CGcNyY+MGQzFSesiNCrJ4r8MBFuwJlNnBngmJ/X5pVTTAi85rWnWyVYDnXodr4BkCSi++rw9GNlVAGQ5qQXjqQxcnKsdSUI2S7hs0uALwLgRYH9FxadwRdyuvGyFR0rTwk9udBy0Tpt7xUTz3Q3x/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731254372; c=relaxed/simple;
	bh=iQJNfQi44JTW3bEWuJFRmPHx8RfhW7j/u6TM92GTk8k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g3dKqrzQpqQaYJvPCFyVwX+p5TxWZcV41q6PxUcs76MgQwmTtL7pcaZTFb6d7OOdkGlTEvp9Wvs8qcVZsySESr5AFe8UWUL/A1QRzpvWu0sts3zoNk6dvAS/7QOt3vuU3DF/nP7HECopb8a+nHtwnP9Jjyf5hpVPy+2Vy2cnHlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 5A30392009C; Sun, 10 Nov 2024 16:59:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4FE8292009B;
	Sun, 10 Nov 2024 15:59:22 +0000 (GMT)
Date: Sun, 10 Nov 2024 15:59:22 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5St4uQC00KF9YtU6WCHnHDO-NeMJ6er5aB86wgq4ZDxWQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2411091958520.9262@angie.orcam.me.uk>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com> <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org> <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com> <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk> <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com> <20241105223319.46c7563a@samweis> <CA+=Fv5St4uQC00KF9YtU6WCHnHDO-NeMJ6er5aB86wgq4ZDxWQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 9 Nov 2024, Magnus Lindholm wrote:

> What's your thoughts on his approach:
> 
> if    (card is ISP1040 and revision less than C) then use
> dma_get_required_mask()
> else
>      do as before
> 
> Assuming dma_get_required_mask() works it should return a
> 64-something-bit mask on IP30/MIPS but only 32-bits on Alpha.

 It's not required for the mask returned by dma_get_required_mask() to be 
32-bit, so unless your card does support DAC (and everything so far shows 
it does not), it will still fail on another platform where the function 
does return a mask beyond 32 bits.

 Are you able to verify your card with a non-Alpha system that has memory
beyond the low 32-bit DMA space?  I guess not, or you'd have done that 
already, wouldn't you?

 If you really wanted to double-check your Alpha correctly supports DAC, 
you could try wiring your ISP1080 device temporarily via a 32-bit PCI 
riser adapter (or an external 32-bit PCI enclosure) so as to force 64-bit 
addressing via AD[31:0] lines only (assuming that ISP1080 got DAC support 
right though).

  Maciej
