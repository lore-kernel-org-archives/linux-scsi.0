From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 08:51:41 -0600
Message-ID: <1203346301.3324.3.camel@localhost.localdomain>
References: <47B48CAE.2020705@panasas.com> <47B864CB.4040604@panasas.com>
	 <20080218045736.d35d5408.akpm@linux-foundation.org>
	 <20080218140258.GB6606@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51737 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbYBROvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 09:51:49 -0500
In-Reply-To: <20080218140258.GB6606@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>

On Mon, 2008-02-18 at 14:02 +0000, Russell King wrote:
> Another solution jejb suggested was to make dma_free_coherent() lazy,
> but (a) I'm unconvinced that this'll work with drivers which
> constantly
> alloc+free in IRQ context since there's generally only 2MB of VM space
> for such mappings, and it probably won't take long to eat through that
> limited space with such a scheme.

I didn't say make the alloc/free lazy, I said make the mapping setup
teardown lazy.  So on alloc, you first look for existing space, if none,
you map some more.  On free you *don't* teardown the mappings (which is
what requires the IPI) but simply free to the existing space pool ready
for reuse.  You map and free in page size chunks, since the coherent
memory users that want > PAGE_SIZE usually all do boot time allocation
(and don't free until release time).

The reuse of the pages should keep even the drivers that do persistent
alloc/free of dma coherent memory happy, and it should reach a steady
state fairly quickly.

James


