From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 13:04:26 +0200
Message-ID: <20071017110426.GV5043@kernel.dk>
References: <20071017091629.GK5043@kernel.dk> <20071017.035441.74746708.davem@davemloft.net> <20071017105840.GT5043@kernel.dk> <20071017.040414.55507057.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934288AbXJQLFX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071017.040414.55507057.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 17 Oct 2007 12:58:40 +0200
> 
> > The problem is that you cannot zero the entire sg entry, because then
> > you'd potentially overwrite the chain pointer.
> > 
> > I'd propose just adding a
> > 
> >         sg_dma_address(sg) = 0;
> >         sg_dma_len(sg) = 0;
> > 
> > there for now, or provide an arch_clear_sg_entry() helper if we need
> > more killed.
> 
> The "chain pointer" is indicated by an sg->page with the low
> bit set, but we're explicitly initializing it here to a
> non-chain page pointer value.
> 
> What's the problem?

See next mail :-)

-- 
Jens Axboe
