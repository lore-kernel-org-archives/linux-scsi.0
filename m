From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 5/8] scatterlist: Modify SG copy functions to support io
 memory.
Date: Mon, 3 Apr 2017 15:47:09 -0700
Message-ID: <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
 <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
 <CAPcyv4g=MHbjbY0GFPoLq3wAGwhcC7813O7iLUWGEChWh0M7Dw@mail.gmail.com>
 <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 3, 2017 at 3:10 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>
>
> On 03/04/17 03:44 PM, Dan Williams wrote:
>> On Mon, Apr 3, 2017 at 2:20 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>>> Hi Christoph,
>>>
>>> What are your thoughts on an approach like the following untested
>>> draft patch.
>>>
>>> The patch (if fleshed out) makes it so iomem can be used in an sgl
>>> and WARN_ONs will occur in places where drivers attempt to access
>>> iomem directly through the sgl.
>>>
>>> I'd also probably create a p2pmem_alloc_sgl helper function so driver
>>> writers wouldn't have to mess with sg_set_iomem_page.
>>>
>>> With all that in place, it should be relatively safe for drivers to
>>> implement p2pmem even though we'd still technically be violating the
>>> __iomem boundary in some places.
>>
>> Just reacting to this mail, I still haven't had a chance to take a
>> look at the rest of the series.
>>
>> The pfn_t type was invented to carry extra type and page lookup
>> information about the memory behind a given pfn. At first glance that
>> seems a more natural place to carry an indication that this is an
>> "I/O" pfn.
>
> I agree... But what are the plans for pfn_t? Is anyone working on using
> it in the scatterlist code? Currently it's not there yet and given the
> assertion that we will continue to be using struct page for DMA is that
> a direction we'd want to go?
>

I wouldn't necessarily conflate supporting pfn_t in the scatterlist
with the stalled stuct-page-less DMA effor. A pfn_t_to_page()
conversion will still work and be required. However you're right, the
minute we use pfn_t for this we're into the realm of special case
drivers that understand scatterlists with special "I/O-pfn_t" entries.
However, maybe that's what we want? I think peer-to-peer DMA is not a
general purpose feature unless/until we get it standardized in PCI. So
maybe drivers with special case scatterlist support is exactly what we
want for now.

Thoughts?
