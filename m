From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/11]  lpfc 8.1.1 : Add support for more members of the Light Pulse 11xxx (4Gb) family
Date: Mon, 12 Dec 2005 10:12:44 -0700
Message-ID: <20051212171244.GE9286@parisc-linux.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B73@xbl3.emulex.com> <20051128174936.GD13338@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:29585 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751268AbVLLRMr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 12:12:47 -0500
Content-Disposition: inline
In-Reply-To: <20051128174936.GD13338@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 10:49:36AM -0700, Matthew Wilcox wrote:
> On Mon, Nov 28, 2005 at 12:08:46PM -0500, James.Smart@Emulex.Com wrote:
> > Please note: there will be 2 other areas where we will still be accessing
> > config space:
> >   - We need the bar value, as the hardware sees it, to program a base
> >     address it can decode to keep ring accesses on-chip. The current pci
> >     infrastructure doesn't provide this. (we've talked about this on this
> >     reflector before).
> 
> sym2 has the same need for pretty much the same reason.  It has a
> private function called pci_get_base_address() right now.  I believe the
> correct thing to do (but haven't got round to trying it yet) is to call
> pcibios_resource_to_bus().

Done, and tested on ia64 and parisc.  Here's the patch that does it for
sym2, hopefully your code will be similar:

http://hera.kernel.org/git/?p=linux/kernel/git/willy/sym2.git;a=blobdiff;h=e6ff89a8524c74f93971715a762b8c64d18176e1;hp=ec9d93aa160d89a256aee7e92b17493205149fca;hb=b5d641b0098e2ae2263f6fa8f24fa18fcbe831ef;f=drivers/scsi/sym53c8xx_2/sym_glue.c

> >   - If we reset the card, there were hardware-isms that may erroneously
> >     drive perr/serr. So, we need to temporarily turn them off while we
> >     reset. (I believe we went through this as well on this list early on).
> 
> That's certainly a reasonable need.

I wonder if it's functionality that should be provided by the PCI layer.
I don't think yours is the only card with this issue.
