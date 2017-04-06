From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 3/8] nvmet: Use p2pmem in nvme target
Date: Thu, 6 Apr 2017 09:52:36 -0600
Message-ID: <5f76a824-3918-b706-86bd-0ba455895185@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-4-git-send-email-logang@deltatee.com>
 <bce6b009-7756-3cf7-5053-2628b26c8d97@grimberg.me>
 <ec05b7d9-8dfd-8227-84d2-7d391df32219@deltatee.com>
 <0689e764-bf04-6da2-3b7d-2cbf0b6b94a0@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <0689e764-bf04-6da2-3b7d-2cbf0b6b94a0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hey Sagi,

On 05/04/17 11:47 PM, Sagi Grimberg wrote:
> Because the user can get it wrong, and its our job to do what we can in
> order to prevent the user from screwing itself.

Well, "screwing" themselves seems a bit strong. It wouldn't be much
different from a lot of other tunables in the system. For example, it
would be similar to the user choosing the wrong io scheduler for their
disk or workload. If you change this setting without measuring
performance you probably don't care too much about the result anyway.

> I wasn't against it that much, I'm all for making things "just work"
> with minimal configuration steps, but I'm not sure we can get it
> right without it.

Ok, well in that case I may reconsider this in the next series.

>>>> Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
>>>> save an extra PCI transfer as the NVME card could just take the data
>>>> out of it's own memory. However, at this time, cards with CMB buffers
>>>> don't seem to be available.
>>>
>>> Even if it was available, it would be hard to make real use of this
>>> given that we wouldn't know how to pre-post recv buffers (for in-capsule
>>> data). But let's leave this out of the scope entirely...
>>
>> I don't understand what you're referring to. We'd simply use the CMB
>> buffer as a p2pmem device, why does that change anything?
> 
> I'm referring to the in-capsule data buffers pre-posts that we do.
> Because we prepare a buffer that would contain in-capsule data, we have
> no knowledge to which device the incoming I/O is directed to, which
> means we can (and will) have I/O where the data lies in CMB of device
> A but it's really targeted to device B - which sorta defeats the purpose
> of what we're trying to optimize here...

Well, the way I've had it is that each port gets one p2pmem device. So
you'd only want to put NVMe devices that will work with that p2pmem
device behind that port. Though, I can see that being a difficult
restriction seeing it probably means you'll need to have one port per
nvme device if you want to use the CMB buffer of each device. I'll have
to think about that some. Also, it's worth noting that we aren't even
optimizing in-capsule data at this time.


> Still the user can get it wrong. Not sure we can get a way without
> keeping track of this as new devices join the subsystem.

Yeah, I understand. I'll have to think some more about all of this. I'm
starting to see some ways to improve thing.s

Thanks,

Logan
