From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Fri, 27 Apr 2018 09:18:43 +0200
Message-ID: <20180427071843.GB17484@dhcp22.suse.cz>
References: <20180426215406.GB27853@wotan.suse.de>
 <20180427053556.GB11339@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180427053556.GB11339@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org, cl@linux.com, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, linux-spi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu 26-04-18 22:35:56, Christoph Hellwig wrote:
> On Thu, Apr 26, 2018 at 09:54:06PM +0000, Luis R. Rodriguez wrote:
> > In practice if you don't have a floppy device on x86, you don't need ZONE_DMA,
> 
> I call BS on that, and you actually explain later why it it BS due
> to some drivers using it more explicitly.  But even more importantly
> we have plenty driver using it through dma_alloc_* and a small DMA
> mask, and they are in use - we actually had a 4.16 regression due to
> them.

Well, but do we need a zone for that purpose? The idea was to actually
replace the zone by a CMA pool (at least on x86). With the current
implementation of the CMA we would move the range [0-16M] pfn range into 
zone_movable so it can be used and we would get rid of all of the
overhead each zone brings (a bit in page flags, kmalloc caches and who
knows what else)
-- 
Michal Hocko
SUSE Labs
