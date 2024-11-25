Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9AA161328
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732564555; cv=none; b=mJTxzJolZjHrIc+4WDAGMfEhbQcZoarDOMV1B9JQLct/Qycj9fHwev/CabmrdOEXnQRSCraUJ6S07FBiVA4O7n6tk/OcXfrewBDx9b9iEHMR6q6EeRez69hyDZbNWi0qZr4ot2lj61CyKqJ85B4OHutoDzwpyqBzryHA+6Z8TGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732564555; c=relaxed/simple;
	bh=x35fYX6EBxynIXjOCPDEyzKRMyMwLVWlNDbbcR9mwFs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Pk/jz4CxYaZ4FvrOIrai9NwU+qXE9QC3R36BTzRkEuRMdOjayPDxpzJKFZWXYS/v6KQvtk+s0HZUR+m55ieLAPj8ZPcTpX5gg71J80Kl2qHR1wX0aWpnBB2z3FI1S4DlhtmmDuyneSXHCpjxK46iLjHHy5MN49pCU0EOvmQKGsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id C60F092009C; Mon, 25 Nov 2024 20:55:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id C3DD992009B;
	Mon, 25 Nov 2024 19:55:50 +0000 (GMT)
Date: Mon, 25 Nov 2024 19:55:50 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2411251925410.44939@angie.orcam.me.uk>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis>
 <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com> <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com> <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
 <Zyh6tP-eWlABiBG7@infradead.org> <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com> <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com> <20241105093416.773fb59e@samweis>
 <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk> <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com> <20241112145253.7aa5c2ab@samweis> <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 16 Nov 2024, Magnus Lindholm wrote:

> Thanks for taking the time to test this on sgi/octane. I guess the
> results of your test means that only relying on the chip revision is
> not going to do it.

 I had hoped for full `lspci -xxx' dumps actually, which could reveal 
differences perhaps in the device-specific range of config registers.

> I've put my ISP1040 rev B into a HPZ440 (x86_64) with 128GB RAM. When
> booting the system I get
>  "PCI Configuration error" when BIOS configures the card. I also see
> this in the kernel message log:
> 
> "DMAR: [DMA Read NO_PASID] Request device [09:00.0] fault addr
> 0xfebba000 [fault reason 0x06] PTE Read access is not set"

 It looks like an IOMMU fault to me and might mean that the device has 
requested access to a memory location it may not have permission for.  It 
could or could not be a result of address truncation to 32 bits.

> I've used the standard qla1280 driver and hence enabled full 64-bit
> DMA_MASK. Even if I got some generic errors when booting,
> the card works and I can mount a drive, format a partition and
> copy/paste files without any filesystem corruption.
> However, when I enable the debug output I notice that the driver never
> uses bus-addresses for DMA transfers that go any
> higher than 32-bit. So using DMA_BIT_MASK of 64 or 32 bits does not
> have any effect on the actual addresses generated.
> The address always stays within a 32-bit mask in both cases.

 Given that your HPZ440 system appears to have an IOMMU chances are it's
used such as to squeeze all PCI-side DMA mappings into the low 32-bit 
range for the very purpose of avoiding issues with odd devices.

  Maciej
