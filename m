From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 11:43:09 -0700
Message-ID: <20160412184309.GA3333@infradead.org>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
 <1460470405-11673-3-git-send-email-hch@lst.de>
 <570D156B.7010206@sandisk.com>
 <20160412165130.GB9568@lst.de>
 <570D3AE0.4040104@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570D3AE0.4040104-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 11:13:52AM -0700, Bart Van Assche wrote:
> >That's what NVMe does, but I don't think it's a good idea.  Because
> >of the unaligned start into the page this means you have to set the limit
> >to one lower than the actual hardware limit.
> 
> I think this means that there is a mismatch between the current block layer
> limits and what NVMe / RDMA drivers need ...

If we tell the block layer that we can only handle page sized comments
using max_segent_size it should do the right thing.

Now one thing that might be useful is to force the max_segent_size
when setting the virt boundary, as they seem to be closely related.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
