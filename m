From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 5/8] scatterlist: Modify SG copy functions to support io
 memory.
Date: Mon, 3 Apr 2017 17:12:38 -0600
Message-ID: <22930db3-a194-8b60-5aab-4a8add1ddc55@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
 <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
 <CAPcyv4g=MHbjbY0GFPoLq3wAGwhcC7813O7iLUWGEChWh0M7Dw@mail.gmail.com>
 <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50@deltatee.com>
 <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 03/04/17 04:47 PM, Dan Williams wrote:
> I wouldn't necessarily conflate supporting pfn_t in the scatterlist
> with the stalled stuct-page-less DMA effor. A pfn_t_to_page()
> conversion will still work and be required. However you're right, the
> minute we use pfn_t for this we're into the realm of special case
> drivers that understand scatterlists with special "I/O-pfn_t" entries.

Well yes, it would certainly be possible to convert the scatterlist code
from page_link to pfn_t. (The only slightly tricky thing is that
scatterlist uses extra chaining bits and pfn_t uses extra flag bits so
they'd have to be harmonized somehow). But if we aren't moving toward
struct-page-less DMA, I fail to see the point of the conversion.

I'll definitely need IO scatterlists of some form or another and I like
pfn_t but right now it just seems like extra work with unclear benefit.
(Though, if someone told me that I can't use a third bit in the
page_link field then maybe that would be a good reason to move to pfn_t.)

> However, maybe that's what we want? I think peer-to-peer DMA is not a
> general purpose feature unless/until we get it standardized in PCI. So
> maybe drivers with special case scatterlist support is exactly what we
> want for now.

Well, I think this should be completely independent from PCI code. I see
no reason why we can't have infrastructure for DMA on iomem from any
bus. Largely all the work I've done in this area is completely agnostic
to the bus in use. (Except for any kind of white/black list when it is
used.)

The "special case scatterlist" is essentially what I'm proposing in the
patch I sent upthread, it just stores the flag in the page_link instead
of in a pfn_t.

Logan
