Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CD91465B4
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 07:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730360275; cv=none; b=ZmymjaPYQh4+5ncO7RqDBmANpi1yu5U2BGblYzttEuFpz+Ou5ffu+sP4SwIqPuZPVUiuNHSTtS210+o5++BSdpiVdiLtVJwPkXGKJ2Fb12wQ5YEtXhRsNdsGcV3ycJAybSLCGhS3KMIk4kJmRczjBe9Dpah49ve/Bqy5Im8Pq+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730360275; c=relaxed/simple;
	bh=3YcGY47oMdcXy6eFnarEb6lvf2g8jA56WynzKjeEuas=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QN9zYlgaEJa9D4F3tjc62Nb+ANx0JtF46nEhsvNd0WoSTO8W6XIMQ1yNMxcMm3cILoJ/BnUKO8hMp2rX373s6D99wyCv6wt9G8aCyW/anWsNQGdTCeRHwx6RASVYDLUAFjO8LswikbQPssXxnR4UgHbtlzAx18VDJsygjXXfzqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 3A8A792009C; Thu, 31 Oct 2024 08:37:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 32FBF92009B;
	Thu, 31 Oct 2024 07:37:50 +0000 (GMT)
Date: Thu, 31 Oct 2024 07:37:50 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com> <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis>
 <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 30 Oct 2024, Magnus Lindholm wrote:

> Thanks for your reply, I guess this suggests that this is an
> alpha-platform specific problem then? I can run the QL1040 card fine
> with the original qla1280.c driver ( in a 64-bit slot on the ES40 )
> just as long as I don't put more than 2GB ram in the system, this is
> when I start seeing the issues with file system corruption. As soon as
> S/G buffers are allocated on addresses above 32-bit, the QL1040 cannot
> deal with this, unless enforcing a DMA_BIT_MASK(32). The same card
> runs fine under Tru64 UNIX on the same system, however, I don't know
> how the Tru64 driver sets the DMA mask, if it enables full 64-bit
> addressing or not.

 I find this interesting.  Documentation for the Tsunami chipset indicates 
DAC support[1]:

"In case of a PCI dual-address cycle command, the high-order PCI address 
bits <63:40> are compared to the constant value 0x0000_01 (that is, bit 
<40> = 1; all other bits = 0).  If these bits match, a monster window hit 
has occurred and the low-order PCI address bits <34:0> are used unchanged 
as the system address bits <34:0>.  PCI address bits <39:35> are ignored. 
The high-order 32 PCI address bits are available on b_ad<31:0> in the 
second cycle of a DAC, and also on b_ad<63:32> in the first cycle of a DAC 
if b_req64_l is asserted."

and I can see it handled in arch/alpha/kernel/pci_iommu.c; allocations can 
be handed out with the TSUNAMI_DAC_OFFSET bit set.  You might be able to 
see if it triggers by defining DEBUG_ALLOC to 2 and checking messages from 
DMA mappings in the kernel log.

 I did a little research however and discovered that the DAC capability is 
documented in the ISP1040C datasheet, but not in the ISP1040B one.  So it 
seems to me like it's the matter of the chip revision.  I've skimmed over 
the driver and as far as I can tell there's everything supplied there to 
get this sorted now.

References:

[1] "Tsunami/Typhoon 21272 Chipset Hardware Reference Manual", Revision 
    4.0, Compaq Computer Corporation, Order Number: DS-0025A-TE, 21 
    October 1999, Section 10.1.4.4 "Monster Window DMA Address 
    Translation", p. 10-13

  Maciej
