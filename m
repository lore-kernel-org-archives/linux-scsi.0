From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Fri, 13 Oct 2017 10:44:39 +0200
Message-ID: <20171013084439.mgidqaygf2kbuz5u@linux-x5ow.site>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
 <20171012224550.25440-2-bart.vanassche@wdc.com>
 <ee12eeaf-9848-478d-4ebe-9d3497e248e0@kernel.dk>
 <1507849209.14112.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507849209.14112.1.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2017 at 11:00:10PM +0000, Bart Van Assche wrote:
> On Thu, 2017-10-12 at 16:52 -0600, Jens Axboe wrote:
> > On 10/12/2017 04:45 PM, Bart Van Assche wrote:
> > > +++ b/include/linux/sgl_alloc.h
> > > @@ -0,0 +1,16 @@
> > > +#ifndef _SGL_ALLOC_H_
> > > +#define _SGL_ALLOC_H_
> > > +
> > > +#include <linux/types.h> /* bool, gfp_t */
> > > +
> > > +struct scatterlist;
> > > +
> > > +struct scatterlist *sgl_alloc_order(unsigned long long length,
> > > +				    unsigned int order, unsigned int *nent_p,
> > > +				    gfp_t gfp, bool chainable);
> > > +struct scatterlist *sgl_alloc(unsigned long long length, unsigned int *nent_p,
> > > +			      gfp_t gfp);
> > > +void sgl_free_order(struct scatterlist *sgl, int order);
> > > +void sgl_free(struct scatterlist *sgl);
> > > +
> > > +#endif /* _SGL_ALLOC_H_ */
> > 
> > Should this just go into linux/scatterlist.h instead of creating a new header
> > file?
> 
> That's something I can change. I don't have a strong opinion about whether
> these declarations should go into a new header file or into linux/scatterlist.h.

Yes please do (and the implementaion should go into lib/scatterlist.c).
Additionally please get rid of the new CONFIG_SGL_ALLOC as well.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
