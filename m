From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 0/2] genirq: support multiple IRQ notifier.
Date: Fri, 25 Mar 2016 12:32:43 -0700
Message-ID: <20160325193243.GA30485@infradead.org>
References: <cover.1458920770.git.weongyo.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1458920770.git.weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 25, 2016 at 08:51:51AM -0700, Weongyo Jeong wrote:
> Each irq_desc only supports one IRQ affinity notifier at current
> implementation so when we try to register another notifier, it silently
> unregister previous entry and register new one.
> 
> However the problem is that if CONFIG_RFS_ACCEL is set, at current
> implementation no way to set additional IRQ affinity notifier for
> some NIC cards RFS enabled because it already used for RFS.
> With this patch we can register multiple IRQ affinity notifiers.

The whole concept of these irq affinity notifiers seems wrong to me.

If a device supports MSI-X it should simply request per-cpu or per-node
vectors and we should prevent affinity changes for them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
