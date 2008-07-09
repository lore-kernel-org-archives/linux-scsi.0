From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 20:49:41 +0200
Message-ID: <1215629381.18506.6.camel@localhost.localdomain>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	 <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	 <4561.1215612914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755551AbYGISv5@vger.kernel.org>
In-Reply-To: <4561.1215612914@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(apologies for the bouncing mail earlier today, somebody [who _will_ buy
us all sushi tomorrow] broke our mail setup ...)

On Wed, 2008-07-09 at 15:15 +0100, David Howells wrote:
> Miquel van Smoorenburg <miquels@cistron.nl> wrote:
>
> > second, compiling it gives warnings, but it works, and I bet people are
> > using it.
> 
> Maybe, but have you looked at i2o_cfg_passthru()?  Take this, for example:
> 
> 			/* Allocate memory for the transfer */
> 			p = kmalloc(sg_size, GFP_KERNEL);
> 			...
> 			//TODO 64bit fix
> 			sg[i].addr_bus = virt_to_bus(p);
> 
> That looks distinctly dodgy.  virt_to_bus() returns a 64-bit address, and as
> far as I know you may not assume that it will return a 32-bit address.  You're
> taking the bus-address of a piece of RAM, but there may be more than 4GB of
> RAM in the system.

Oh dear, that's indeed bad. Looks like that should use i2o_dma_alloc()
instead. (drivers/scsi/dpt_i2o.c gets this right).

(and what's with the (unlocked!) pci_set_dma_mask() flipping in
i2o_dma_alloc() ? )

Mike.
