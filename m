From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 11:13:52 -0700
Message-ID: <570D3AE0.4040104@sandisk.com>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
 <1460470405-11673-3-git-send-email-hch@lst.de> <570D156B.7010206@sandisk.com>
 <20160412165130.GB9568@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412165130.GB9568-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/12/2016 09:51 AM, Christoph Hellwig wrote:
> On Tue, Apr 12, 2016 at 08:34:03AM -0700, Bart Van Assche wrote:
>> ib_sg_to_pages() can handle segments that are larger than mr->page_size.
>
> The interface handles it fine, but we'll still end up using a segment
> per (MR) page.
>
>> Have you considered to set queue_limits.max_hw_sectors instead of
>> max_segment_size?
>
> That's what NVMe does, but I don't think it's a good idea.  Because
> of the unaligned start into the page this means you have to set the limit
> to one lower than the actual hardware limit.

I think this means that there is a mismatch between the current block 
layer limits and what NVMe / RDMA drivers need ...

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
