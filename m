From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Thu, 26 Apr 2018 22:35:56 -0700
Message-ID: <20180427053556.GB11339@infradead.org>
References: <20180426215406.GB27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180426215406.GB27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-mm@kvack.org, mhocko@kernel.org, cl@linux.com, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, linux-spi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 26, 2018 at 09:54:06PM +0000, Luis R. Rodriguez wrote:
> In practice if you don't have a floppy device on x86, you don't need ZONE_DMA,

I call BS on that, and you actually explain later why it it BS due
to some drivers using it more explicitly.  But even more importantly
we have plenty driver using it through dma_alloc_* and a small DMA
mask, and they are in use - we actually had a 4.16 regression due to
them.

> SCSI is *severely* affected:

Not really.  We have unchecked_isa_dma to support about 4 drivers,
and less than a hand ful of drivers doing stupid things, which can
be fixed easily, and just need a volunteer.

> That's the end of the review of all current explicit callers on x86.
> 
> # dma_alloc_coherent_gfp_flags() and dma_generic_alloc_coherent()
> 
> dma_alloc_coherent_gfp_flags() and dma_generic_alloc_coherent() set
> GFP_DMA if if (dma_mask <= DMA_BIT_MASK(24))

All that code is long gone and replaced with dma-direct.  Which still
uses GFP_DMA based on the dma mask, though - see above.
