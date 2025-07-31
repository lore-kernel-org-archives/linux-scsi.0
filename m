Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C70223DD6;
	Thu, 31 Jul 2025 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753955366; cv=none; b=NRTWDOsERqSf/He5wOR8dslDcMW4q1jkXNKgUMy0TivJ7qHZ9Of/P8R/mpBgItjm8qAnK9dQEnOV0Za1PJwYUNavZCd5IyUq//74lmlEJOD9nEHBWSbEsCXttbRLe5zhrZKViJUw1Tx+XXkBDOgrP9SSAXcXu9DdBEdB1edBtwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753955366; c=relaxed/simple;
	bh=vjvN1SaonJhbMKKt4uXmQHHCbIqO+IeGWQop9HuKB78=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UBB18lWh96s6fuqXO49JrVXFi81rFgAdQSLzHeZZrxK8cEr3rR1Mt/wE4+Y6SyuaIAj1ZeObG7yqy9ggBQ12LjkiMoTlDy/OdqAA8kgVx+NPVTKO0IpZfzEhTm1aQ2lglhwvKiL3MRO0rZ/Lum08Nh2FXv/d0oCXrKc8yPhc46w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 483BC92009C; Thu, 31 Jul 2025 11:40:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 461A592009B;
	Thu, 31 Jul 2025 10:40:49 +0100 (BST)
Date: Thu, 31 Jul 2025 10:40:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
    linux-alpha@vger.kernel.org, martin.petersen@oracle.com, 
    James.Bottomley@HansenPartnership.com, hch@infradead.org
Subject: Re: [PATCH 0/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig
 option
In-Reply-To: <20250728163752.9778-1-linmag7@gmail.com>
Message-ID: <alpine.DEB.2.21.2507291750390.5060@angie.orcam.me.uk>
References: <20250728163752.9778-1-linmag7@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 28 Jul 2025, Magnus Lindholm wrote:

> Some platforms like for example the SGI Octace2, require full 64-bit
> addressing in order for the qla1280 driver to work. On other systems,
> like the tsunami based Alpha systems, 32-bit PCI Qlogic SCSI controllers
> (like the ISP1040 series) will not work properly on systems with more
> than 2GB RAM installed. For some reason the combination of using PCI DAC
> cycles and the enabling the DMA "monster window" on the tsunami based
> alphas will result in file system corruption with the Qlogic ISP driver.
> This is not the case on other alpha systems, such as rawhide based
> systems, like the Alphaserver 4100, on this platform cards like
> the qlogic 32-bit PCI (ISP1040B) works fine with PCI DAC cycles and
> the "monster window" enabled. In order for the qla1280 driver to work
> with ISP1040 chips on tsunami based alphas the driver must be compiled
> with 32-bit DMA addressing. Most SRM firmware versions allow alphas to
> boot from Qlogic ISP1040 SCSI controllers and hence having a simple way
> to limit DMA addressing to 32-bits is relevant.

 Given the description it seems to me it will best be handled as a quirk 
in arch/alpha/kernel/pci.c, at least in the interim.

 If it turns out a generic issue with DAC handling in the Tsunami chipset, 
then a better approach would be a generic workaround for all potentially 
affected devices, but it does not appear we have existing infrastructure 
for that.  Just setting the global DMA mask would unnecessarily cripple 
64-bit option cards as well, but it seems to me there might be something 
relevant in arch/mips/pci/fixup-sb1250.c; see `quirk_sb1250_pci_dac' and 
the comments above it.

 The situation is a bit different here as the bus is a proper 64-bit one, 
but the quirk could only limit the individual DMA mask to 32 bits for 
devices that have no 64-bit memory BARs.  I suspect there are no proper 
64-bit PCI option cards that only have I/O bars and I don't think there's 
any explicit status bit to tell 32-bit and 64-bit option cards apart.

 FWIW I was able to obtain such an option card and try it with my HiFive 
Unmatched RISC-V system, which has 16GiB of RAM.  It turned out picky 
though and despite being DEC-branded it refused to talk to a number of 
SCSI 1 CCS DEC disks, which work just fine with an Adaptec host adapter 
using the same cables and with DECstation systems they came with, but also 
break with a BusLogic MultiMaster host adapter (which seems odd as these 
host adapters have been reputably very robust).

 So I could only do limited testing with a single SCSI 2 disk that works 
everywhere, and that triggered no issues.  As I wanted to retain remote 
access to said problematic disks from the Unmatched machine I have left 
them wired to the Adaptec device, but I'll see if I can do more testing at 
my next visit to the lab around the weekend after next as I'm going to 
disassemble the Unmatched system anyway.

 HTH,

  Maciej
