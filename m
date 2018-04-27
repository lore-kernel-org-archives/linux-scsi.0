From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Fri, 27 Apr 2018 18:37:40 +0200
Message-ID: <20180427163740.GI17484@dhcp22.suse.cz>
References: <20180426215406.GB27853@wotan.suse.de>
 <20180427053556.GB11339@infradead.org>
 <20180427071843.GB17484@dhcp22.suse.cz>
 <alpine.DEB.2.20.1804271103160.11686@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1804271103160.11686@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, linux-spi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri 27-04-18 11:07:07, Cristopher Lameter wrote:
> On Fri, 27 Apr 2018, Michal Hocko wrote:
> 
> > On Thu 26-04-18 22:35:56, Christoph Hellwig wrote:
> > > On Thu, Apr 26, 2018 at 09:54:06PM +0000, Luis R. Rodriguez wrote:
> > > > In practice if you don't have a floppy device on x86, you don't need ZONE_DMA,
> > >
> > > I call BS on that, and you actually explain later why it it BS due
> > > to some drivers using it more explicitly.  But even more importantly
> > > we have plenty driver using it through dma_alloc_* and a small DMA
> > > mask, and they are in use - we actually had a 4.16 regression due to
> > > them.
> >
> > Well, but do we need a zone for that purpose? The idea was to actually
> > replace the zone by a CMA pool (at least on x86). With the current
> > implementation of the CMA we would move the range [0-16M] pfn range into
> > zone_movable so it can be used and we would get rid of all of the
> > overhead each zone brings (a bit in page flags, kmalloc caches and who
> > knows what else)
> 
> Well it looks like what we are using it for is to force allocation from
> low physical memory if we fail to obtain proper memory through a normal
> channel.  The use of ZONE_DMA is only there for emergency purposes.
> I think we could subsitute ZONE_DMA32 on x87 without a problem.
> 
> Which means that ZONE_DMA has no purpose anymore.

We still need to make sure the low 16MB is available on request. And
that is what CMA can help with. We do not really seem to need the whole
zone infreastructure for that.

> Can we make ZONE_DMA on x86 refer to the low 32 bit physical addresses
> instead and remove ZONE_DMA32?

Why that would be an advantage? If anything I would rename ZONE_DMA32 to
ZONE_ADDR32 or something like that.

> That would actually improve the fallback because you have more memory for
> the old devices.

I do not really understand how is that related to removal ZONE_DMA. We
are really talking about the lowest 16MB...

-- 
Michal Hocko
SUSE Labs
