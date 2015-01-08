From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v4] virtio-scsi: Fix the race condition in virtscsi_handle_event
Date: Thu, 8 Jan 2015 08:36:32 -0800
Message-ID: <CAHdzE-_cEQ4=Dg1BBewD4QR+ph4GDorXTq5dr9iJm2uCWQ+K4w@mail.gmail.com>
References: <1420685852-5078-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:51368 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbAHQge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 11:36:34 -0500
Received: by mail-vc0-f169.google.com with SMTP id hy10so1472867vcb.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2015 08:36:33 -0800 (PST)
In-Reply-To: <1420685852-5078-1-git-send-email-famz@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>

On Wed, Jan 7, 2015 at 6:57 PM, Fam Zheng <famz@redhat.com> wrote:
>
> There is a race condition in virtscsi_handle_event, when many device
> hotplug/unplug events flush in quickly.
>
> The scsi_remove_device in virtscsi_handle_transport_reset may trigger
> the BUG_ON in scsi_target_reap, because the state is altered behind it,
> probably by scsi_scan_host of another event. I'm able to reproduce it by
> repeatedly plugging and unplugging a scsi disk with the same lun number.
>
> To fix this, a single thread workqueue (local to the module) is added,
> which makes the scan work serialized. With this change, the panic goes
> away.
>
> Signed-off-by: Fam Zheng <famz@redhat.com>

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

> ---
>
> v4: Addressing MST's comments:
>     Use ordered workqueue, with WQ_FREEZABLE and WQ_MEM_RECLAIM flags.
>     Coding style fixes.
>
> v3: Fix spacing and destroy order. (MST)
> ---
>  drivers/scsi/virtio_scsi.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c52bb5d..0db63b5 100644
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
>         struct virtio_scsi_event_node *event_node = buf;
>
>         if (!vscsi->stop_events)
> -               queue_work(system_freezable_wq, &event_node->work);
> +               queue_work(virtscsi_scan_wq, &event_node->work);
>  }
>
>  static void virtscsi_event_done(struct virtqueue *vq)
> @@ -1119,6 +1120,14 @@ static int __init init(void)
>                 pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
>                 goto error;
>         }
> +
> +       virtscsi_scan_wq =
> +               alloc_ordered_workqueue("virtscsi-scan", WQ_FREEZABLE | WQ_MEM_RECLAIM);
> +       if (!virtscsi_scan_wq) {
> +               pr_err("create_singlethread_workqueue() for virtscsi_scan_wq failed\n");
> +               goto error;
> +       }
> +
>         ret = register_virtio_driver(&virtio_scsi_driver);
>         if (ret < 0)
>                 goto error;
> @@ -1126,6 +1135,8 @@ static int __init init(void)
>         return 0;
>
>  error:
> +       if (virtscsi_scan_wq)
> +               destroy_workqueue(virtscsi_scan_wq);
>         if (virtscsi_cmd_pool) {
>                 mempool_destroy(virtscsi_cmd_pool);
>                 virtscsi_cmd_pool = NULL;
> @@ -1140,6 +1151,7 @@ error:
>  static void __exit fini(void)
>  {
>         unregister_virtio_driver(&virtio_scsi_driver);
> +       destroy_workqueue(virtscsi_scan_wq);
>         mempool_destroy(virtscsi_cmd_pool);
>         kmem_cache_destroy(virtscsi_cmd_cache);
>  }
> --
> 1.9.3
>
