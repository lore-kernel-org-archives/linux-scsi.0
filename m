From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Date: Tue, 6 Jan 2015 16:54:47 +0200
Message-ID: <20150106145447.GA7787@redhat.com>
References: <1420550705-22162-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbbAFOy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 09:54:59 -0500
Content-Disposition: inline
In-Reply-To: <1420550705-22162-1-git-send-email-famz@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Venkatesh Srinivas <venkateshs@google.com>

On Tue, Jan 06, 2015 at 09:25:05PM +0800, Fam Zheng wrote:
> There is a race condition in virtscsi_handle_event, when many device
> hotplug/unplug events flush in quickly.
> 
> The scsi_remove_device in virtscsi_handle_transport_reset may trigger
> the BUG_ON in scsi_target_reap, because the state is altered behind it,
> probably by scsi_scan_host of another event. I'm able to reproduce it by
> repeatedly plugging and unplugging a scsi disk with the same lun number.
> 
> To fix this, a single thread workqueue (local to the module) is added,
> which makes the scan work serialized.

All wqs are serialized:

	Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
	are now non-reentrant - any work item is guaranteed to be executed by
	at most one worker system-wide at any given time.


> With this change, the panic goes
> away.

I think the commit log is confusing.
serialization can not be an issue.

At a guess, what happens is two events are processed out of order,
so unplug bypasses another event, causing use after free errors.

With this in mind, your patch will indeed fix the issue, but
a better fix would be to call alloc_ordered_workqueue.

> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
> 
> v3: Fix spacing and destroy order. (MST)
> ---
>  drivers/scsi/virtio_scsi.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c52bb5d..144bb73 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -120,6 +120,7 @@ struct virtio_scsi {
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
>  static mempool_t *virtscsi_cmd_pool;
> +static struct workqueue_struct *virtscsi_scan_wq;
>  
>  static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
>  {
> @@ -404,7 +405,7 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
>  	struct virtio_scsi_event_node *event_node = buf;
>  
>  	if (!vscsi->stop_events)
> -		queue_work(system_freezable_wq, &event_node->work);
> +		queue_work(virtscsi_scan_wq, &event_node->work);

This means wq isn't freezable anymore.

>  }
>  
>  static void virtscsi_event_done(struct virtqueue *vq)
> @@ -1119,6 +1120,13 @@ static int __init init(void)
>  		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
>  		goto error;
>  	}
> +
> +	virtscsi_scan_wq = create_singlethread_workqueue("virtscsi-scan");
> +	if (!virtscsi_scan_wq) {
> +		pr_err("create_singlethread_workqueue() for virtscsi_scan_wq failed\n");
> +		goto error;
> +	}
> +

Documentation/workqueue.txt says:
alloc_workqueue() allocates a wq.  The original create_*workqueue()
functions are deprecated and scheduled for removal.  alloc_workqueue()
takes three arguments - @name, @flags and @max_active.


>  	ret = register_virtio_driver(&virtio_scsi_driver);
>  	if (ret < 0)
>  		goto error;
> @@ -1126,6 +1134,9 @@ static int __init init(void)
>  	return 0;
>  
>  error:
> +	if (virtscsi_scan_wq) {
> +		destroy_workqueue(virtscsi_scan_wq);
> +	}

Single line, shouldn't use {} here.

>  	if (virtscsi_cmd_pool) {
>  		mempool_destroy(virtscsi_cmd_pool);
>  		virtscsi_cmd_pool = NULL;
> @@ -1140,6 +1151,7 @@ error:
>  static void __exit fini(void)
>  {
>  	unregister_virtio_driver(&virtio_scsi_driver);
> +	destroy_workqueue(virtscsi_scan_wq);
>  	mempool_destroy(virtscsi_cmd_pool);
>  	kmem_cache_destroy(virtscsi_cmd_cache);
>  }
> -- 
> 1.9.3
