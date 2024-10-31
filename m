Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CA61C7B63
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730395837; cv=none; b=hxUMCLbWMWx4QKMnvv9Lc9wHJjez72NGZA4TQQojtDaRidVLBXhiF4KQFbhwOlATchJdvYEPQfGg3ky6ju1qKRoqtZf+GPqvjUQvIFYCKVxNQtnxT4CgGhvVU02cvpXPzvL4DrW+zWtLGSsKP1q0ZnpFkt3fQ4o2wY3JXLhwjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730395837; c=relaxed/simple;
	bh=PeeC/E8gh5pFVS/oT6SE/Jg4w5ccFOO1+KRqKp/oUzw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Yqae+3YR785QaR30wXuwNFT/wjZbfledG7Pd0rG7qBcjwPQcpQlvaxX5Lwi4ynO/QxRa8+osAvj3PlIjSYxk5rKZUcFhdt9ihhSCQm8MN4wDHxLYj5p8mi5BXQEUcgfYpDGpmQqLYhLEHcXPF7Y++qVTHaBsk2kEAwntl/fEk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 0A05992009C; Thu, 31 Oct 2024 18:30:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 0443692009B;
	Thu, 31 Oct 2024 17:30:31 +0000 (GMT)
Date: Thu, 31 Oct 2024 17:30:31 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>, 
    Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    Christoph Hellwig <hch@infradead.org>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com> <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 31 Oct 2024, Magnus Lindholm wrote:

> I don't have a QLA1040 revC to test with, but I've put together a much
> smaller patch which just limits the DMA_BIT_MASK to 32-bit on
> 1020/1040 cards this should at least not break anything while fixing
> the most urgent problems with file system corruption on some
> combination of hardware/memory. Thanks for the pointers to tsunami
> chipsets though, I'll try to enable some debugging to see what's going
> on when I hit this problem with the qlogic card.

 I think Thomas will be unhappy about disabling DAC completely for the 
1040: as I infer from his response it is indeed required for his Octane to 
operate correctly, and which also presumably implies he does have revision 
C of the chip to verify your fix with.  Thomas?

> I'll clean up the chip revision reporting code to see if I can improve
> things there, this will be as a separate patch then.

 Great!

> I have one question regarding the hardware revision on 1040 chips,
> according to qla1280.h we have this:
> 
> #define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
> #define ISP_CFG0_1020    BIT_0  /* ISP1020 */
> #define ISP_CFG0_1020A   BIT_1  /* ISP1020A */
> #define ISP_CFG0_1040    BIT_2  /* ISP1040 */
> #define ISP_CFG0_1040A   BIT_3  /* ISP1040A */
> #define ISP_CFG0_1040B   BIT_4  /* ISP1040B */
> #define ISP_CFG0_1040C   BIT_5  /* ISP1040C */
> 
> 
> But when I examine the register it looks more like:
> 
> #define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
> #define ISP_CFG0_1020     1  /* ISP1020 *
> #define ISP_CFG0_1020A   2  /* ISP1020A */
> #define ISP_CFG0_1040     3  /* ISP1040 */
> #define ISP_CFG0_1040A   4  /* ISP1040A */
> #define ISP_CFG0_1040B   5  /* ISP1040B */
> #define ISP_CFG0_1040C   6  /* ISP1040C */
> 
> Which is consistent with how NetBSD does things in their ISP driver.
> Also, in this case the HWMSK actually works for filtering out the
> hardware revision part of the CFG0 register, since it would actually
> require a 6-bit mask to match the current definitions in qla1280.c,
> right?

 Well spotted!  This predates kernel.org git history, but I was able to 
track the origin down with a copy of the LMO git tree, and it has always 
been like this since the introduction of these macros in 2.6.9 with 
<https://lore.kernel.org/r/20040606125728.GB31063@lst.de/>.

 This also means that the ISP_CFG0_1040A check also added in 2.6.9 with 
<https://lore.kernel.org/r/20040606125825.GE31063@lst.de/> will never 
match, possibly meaning that this code wasn't actually ever verified with 
affected 1040A hardware.  This might also explain why a later change made 
with commit 0888f4c33128 ("[SCSI] qla1280: don't use bitfields for 
hardware access in isp_config") went unnoticed that changed the semantics 
of the workaround from keeping bursts unconditionally disabled with the 
1040A to making them enabled in the absence of NVRAM.

 NB comments for the FIFO threshold surely are suspicious too.

 Christoph can you please have a look into it?  It seems like something 
you ought to be quite familiar with if not for the passage of time.

  Maciej
