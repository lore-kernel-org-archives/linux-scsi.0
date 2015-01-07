From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH v3] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Date: Wed, 7 Jan 2015 08:52:18 +0800
Message-ID: <20150107005218.GA2912@fam-t430.nay.redhat.com>
References: <1420550705-22162-1-git-send-email-famz@redhat.com>
 <20150106145447.GA7787@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbbAGAvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 19:51:33 -0500
Content-Disposition: inline
In-Reply-To: <20150106145447.GA7787@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Venkatesh Srinivas <venkateshs@google.com>

On Tue, 01/06 16:54, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 09:25:05PM +0800, Fam Zheng wrote:
> > There is a race condition in virtscsi_handle_event, when many device
> > hotplug/unplug events flush in quickly.
> > 
> > The scsi_remove_device in virtscsi_handle_transport_reset may trigger
> > the BUG_ON in scsi_target_reap, because the state is altered behind it,
> > probably by scsi_scan_host of another event. I'm able to reproduce it by
> > repeatedly plugging and unplugging a scsi disk with the same lun number.
> > 
> > To fix this, a single thread workqueue (local to the module) is added,
> > which makes the scan work serialized.
> 
> All wqs are serialized:
> 
> 	Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
> 	are now non-reentrant - any work item is guaranteed to be executed by
> 	at most one worker system-wide at any given time.
> 
> 
> > With this change, the panic goes
> > away.
> 
> I think the commit log is confusing.
> serialization can not be an issue.
> 
> At a guess, what happens is two events are processed out of order,
> so unplug bypasses another event, causing use after free errors.

It's not just order, it's race. A wq item is only serialized to itself - that's
what non-reentrant means here. But when there are two events, there are *two*
wq items, which do run concurrently by system_freezable_wq.

> 
> With this in mind, your patch will indeed fix the issue, but
> a better fix would be to call alloc_ordered_workqueue.

alloc_ordered_workqueue does fix it, but still by serializing all the wq items.

By definition, create_singlethread_workqueue only adds a WQ_MEM_RECLAIM flag,
which is not related to the question. They are the same other than that.

> 
> > Signed-off-by: Fam Zheng <famz@redhat.com>
> > ---
> > 
> > v3: Fix spacing and destroy order. (MST)
> > ---
> >  drivers/scsi/virtio_scsi.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > index c52bb5d..144bb73 100644
> > --- a/drivers/scsi/virtio_scsi.c
> > +++ b/drivers/scsi/virtio_scsi.c
> > @@ -120,6 +120,7 @@ struct virtio_scsi {
> >  
> >  static struct kmem_cache *virtscsi_cmd_cache;
> >  static mempool_t *virtscsi_cmd_pool;
> > +static struct workqueue_struct *virtscsi_scan_wq;
> >  
> >  static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
> >  {
> > @@ -404,7 +405,7 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
> >  	struct virtio_scsi_event_node *event_node = buf;
> >  
> >  	if (!vscsi->stop_events)
> > -		queue_work(system_freezable_wq, &event_node->work);
> > +		queue_work(virtscsi_scan_wq, &event_node->work);
> 
> This means wq isn't freezable anymore.

Maybe add WQ_FREEZABLE back to the flags then. I'll see.

> 
> >  }
> >  
> >  static void virtscsi_event_done(struct virtqueue *vq)
> > @@ -1119,6 +1120,13 @@ static int __init init(void)
> >  		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
> >  		goto error;
> >  	}
> > +
> > +	virtscsi_scan_wq = create_singlethread_workqueue("virtscsi-scan");
> > +	if (!virtscsi_scan_wq) {
> > +		pr_err("create_singlethread_workqueue() for virtscsi_scan_wq failed\n");
> > +		goto error;
> > +	}
> > +
> 
> Documentation/workqueue.txt says:
> alloc_workqueue() allocates a wq.  The original create_*workqueue()
> functions are deprecated and scheduled for removal.  alloc_workqueue()
> takes three arguments - @name, @flags and @max_active.

OK, let's use alloc_ordered_workqueue.

> 
> 
> >  	ret = register_virtio_driver(&virtio_scsi_driver);
> >  	if (ret < 0)
> >  		goto error;
> > @@ -1126,6 +1134,9 @@ static int __init init(void)
> >  	return 0;
> >  
> >  error:
> > +	if (virtscsi_scan_wq) {
> > +		destroy_workqueue(virtscsi_scan_wq);
> > +	}
> 
> Single line, shouldn't use {} here.

OK.

Fam

> 
> >  	if (virtscsi_cmd_pool) {
> >  		mempool_destroy(virtscsi_cmd_pool);
> >  		virtscsi_cmd_pool = NULL;
> > @@ -1140,6 +1151,7 @@ error:
> >  static void __exit fini(void)
> >  {
> >  	unregister_virtio_driver(&virtio_scsi_driver);
> > +	destroy_workqueue(virtscsi_scan_wq);
> >  	mempool_destroy(virtscsi_cmd_pool);
> >  	kmem_cache_destroy(virtscsi_cmd_cache);
> >  }
> > -- 
> > 1.9.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
