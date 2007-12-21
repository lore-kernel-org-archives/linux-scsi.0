From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer
	in scsi_cmnd
Date: Sat, 22 Dec 2007 08:27:34 +1100
Message-ID: <1198272454.6737.15.camel@pasglop>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	 <20071221103326.7ce1bc4f@the-village.bc.nu>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:42281 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969AbXLUVaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 16:30:13 -0500
In-Reply-To: <20071221103326.7ce1bc4f@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org


On Fri, 2007-12-21 at 10:33 +0000, Alan Cox wrote:
> On Fri, 21 Dec 2007 13:30:08 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
> > by some low level drivers (that typically happens with USB mass
> > storage).
> 
> Should that not be fixed in USB storage by using pci_alloc_coherent on the
> PCI device of the hub not peeing directly into kernel space ?

All "dumb" SCSI drivers have this problem, USB storage is just one of
them. This would also allow to remove bounce buffering that some
non-dumb ones are doing in fact.

There's another solution jejb was talking about involving reworking the
allocation of the sense buffer to make it always under driver control
etc... but that's the kind of SCSI surgery that I'm not prepared to do
especially not for .25 and without much HW to test with.

> It's also incomplete as a fix because I don't see what guarantees the
> buffer size will always exceed cache line size

How is that a problem ? The annotation will make sure the buffer doesn't
share cache lines. It forces alignmenet before and pads after.

Ben.


