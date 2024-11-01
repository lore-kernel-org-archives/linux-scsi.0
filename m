Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A771369B4
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 02:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730428596; cv=none; b=f8+z4R4XCIp6k8AmdyQwL/US9vatdBaKtp3ippYl9JGJmt5rdwBGPtAcUqZg6vWsMHMePwn0u2JUMZXzi5vi+Ptz4hHCf+CdwT+9Fo3yC4XqV4pYOLGylKwQZ3ttLisGQquJh2PhgXlEqpxOayF3ZD1asbjOp1diC6xjIjtBPbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730428596; c=relaxed/simple;
	bh=K0xR3hXbhWTbyCQS9/X0KLYKUrLzpYgg/WyX2NGIIXA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=b+93CFINjQzDLkAVOg+C2V9GCWOMF4lXRAreBagKjaOMZGFnZM4Z73w0jmD3PWgiruUT8qQIGqYBAOeXMgRNGzAJIPBEn5JGoUXwX/Yd0R9EOOHPU71TW8BNnei3c7fLdl7F02O6uXOj4oeXUrDFG6TucHoD44WyjsHzmSui8fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 399D392009C; Fri,  1 Nov 2024 03:36:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 3333E92009B;
	Fri,  1 Nov 2024 02:36:25 +0000 (GMT)
Date: Fri, 1 Nov 2024 02:36:25 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    Christoph Hellwig <hch@infradead.org>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5T5okj3ntmWgYB-509xE7kfoDUUcBGorfroqGpJTNyRoA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2411010230470.40463@angie.orcam.me.uk>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com> <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com> <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <CA+=Fv5T5okj3ntmWgYB-509xE7kfoDUUcBGorfroqGpJTNyRoA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 31 Oct 2024, Magnus Lindholm wrote:

> >  I think Thomas will be unhappy about disabling DAC completely for the
> > 1040: as I infer from his response it is indeed required for his Octane to
> > operate correctly, and which also presumably implies he does have revision
> > C of the chip to verify your fix with.  Thomas?
> 
> 
> >From the Tsunami paper:
> 
> "The DMA monster window is enabled by PCTL<MWIN>. If enabled, this
> window lies from 100.0000.0000 to
> 100.FFFF.FFFF, which requires a dual-address cycle (DAC) access from
> the PCI bus. This window maps to system memory as defined in Section
> 10.1.4"
> 
> When I run the qla1280.c driver with some debugging enabled I see this
> output after a while:
> 
> es40 kernel: S/G Segment Cont. phys_addr=100 7fff8000, len=0x10000
> es40 kernel: S/G Segment Cont. phys_addr=100 80008000, len=0x10000
> es40 kernel: S/G Segment Cont. phys_addr=100 8011e000, len=0x10000
> 
> Right after the above messages in log files I see failed read/writes
> on the drive attached to the qla1040B. So as soon as I hit the
> "monster window" in DMA-addressing my files get messed up.  I guess
> this never happens if I don't have enough memory in the system, or if
> I set the DMA_BIT_MASK. I'll try to enable some more debug logs from
> DMA and IOMMU stuff.

 So it is as I expected.  Please do coordinate with Thomas and implement 
the DMA mask on a per-revision basis as I suggested.

> > > Which is consistent with how NetBSD does things in their ISP driver.
> > > Also, in this case the HWMSK actually works for filtering out the
> > > hardware revision part of the CFG0 register, since it would actually
> > > require a 6-bit mask to match the current definitions in qla1280.c,
> > > right?
> >
> 
> Thanks! I guess changing these definitions in the header file should
> be safe, I don't think they are really used anywhere in the code as of
> now. Would make a patch for reporting on the hardware revisions of
> 1040/1020 more consistent with the headers.

 Well ISP_CFG0_1040A does get used as I also noted.  I do hope Christoph 
chimes in on the erratum concerned.

  Maciej
