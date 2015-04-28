From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scatterlist: enable sg chaining for all architectures
Date: Tue, 28 Apr 2015 15:16:59 -0700
Message-ID: <1430259419.2181.26.camel@HansenPartnership.com>
References: <1429973776-7499-1-git-send-email-akinobu.mita@gmail.com>
	 <20150428142743.578d1c930aca013b596d7546@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150428142743.578d1c930aca013b596d7546@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-04-28 at 14:27 -0700, Andrew Morton wrote:
> On Sat, 25 Apr 2015 23:56:16 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > Some architectures enable sg chaining option while others do not.
> > 
> > The requirement to enable sg chaining is that pages must be aligned
> > at a 32-bit boundary in order to overload the LSB of the pointer.
> > Regardless of whether ARCH_HAS_SG_CHAIN is defined or not, the above
> > requirement is always chacked by BUG_ON() in sg_assign_page.  So
> > all architectures can enable sg chaining.
> > 
> > As you can see from the changes in drivers/target/target_core_rd.c,
> > enabling SG chaining for all architectures allows us to allocate
> > discontiguous scatterlist tables which can be traversed throughout
> > by sg_next() without a special handling for some architectures.
> 
> Thanks, I'll grab this.  If anyone has concerns, speak now or hold both
> pieces!

It breaks a host of architectures doesn't it?  I can specifically speak
for PARISC:  The problem is the way our iommus are consuming
scatterlists.  They're assuming we can dereference the scatterlist as an
array (like this code in ccio-dma.c):

static int
ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents, 
	    enum dma_data_direction direction)
[...]
	for(i = 0; i < nents; i++)
		prev_len += sglist[i].length;

If you turn on sg chaining on our architecture, we'll run off the end of
that array dereference and crash.

This can all be fixed by making our architecture dma mapping code use
iterators instead of array lists, but that needs more code than this
patch provides.  I assume there are similar issues on a lot of other
architectures, so before you can contemplate a patch like this, surely
all the architecture consumers have to be converted to iterator instead
of array format?

The first place to start would be a survey of who's still using the
array format.

James
