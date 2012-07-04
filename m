From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] virtio-scsi: Add vdrv->scan for post
	VIRTIO_CONFIG_S_DRIVER_OK LUN scanning
Date: Wed, 04 Jul 2012 16:50:05 +0200
Message-ID: <4FF4581D.9080808@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<1341375846-27882-6-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341375846-27882-6-git-send-email-nab@linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 04/07/2012 06:24, Nicholas A. Bellinger ha scritto:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch changes virtio-scsi to use a new virtio_driver->scan() callback
> so that scsi_scan_host() can be properly invoked once virtio_dev_probe() has
> set add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK) to signal active virtio-ring
> operation, instead of from within virtscsi_probe().
> 
> This fixes a bug where SCSI LUN scanning for both virtio-scsi-raw and
> virtio-scsi/tcm_vhost setups was happening before VIRTIO_CONFIG_S_DRIVER_OK
> had been set, causing VIRTIO_SCSI_S_BAD_TARGET to occur.  This fixes a bug
> with virtio-scsi/tcm_vhost where LUN scan was not detecting LUNs.
> 
> Tested with virtio-scsi-raw + virtio-scsi/tcm_vhost w/ IBLOCK on 3.5-rc2 code.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Please send this independently.  I think we also want it in stable@vger?

Paolo

> ---
>  drivers/scsi/virtio_scsi.c |   15 ++++++++++++---
>  drivers/virtio/virtio.c    |    5 ++++-
>  include/linux/virtio.h     |    1 +
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 1b38431..391b30d 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -481,9 +481,10 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>  	err = scsi_add_host(shost, &vdev->dev);
>  	if (err)
>  		goto scsi_add_host_failed;
> -
> -	scsi_scan_host(shost);
> -
> +	/*
> +	 * scsi_scan_host() happens in virtscsi_scan() via virtio_driver->scan()
> +	 * after VIRTIO_CONFIG_S_DRIVER_OK has been set..
> +	 */
>  	return 0;
>  
>  scsi_add_host_failed:
> @@ -493,6 +494,13 @@ virtscsi_init_failed:
>  	return err;
>  }
>  
> +static void virtscsi_scan(struct virtio_device *vdev)
> +{
> +	struct Scsi_Host *shost = (struct Scsi_Host *)vdev->priv;
> +
> +	scsi_scan_host(shost);
> +}
> +
>  static void virtscsi_remove_vqs(struct virtio_device *vdev)
>  {
>  	/* Stop all the virtqueues. */
> @@ -537,6 +545,7 @@ static struct virtio_driver virtio_scsi_driver = {
>  	.driver.owner = THIS_MODULE,
>  	.id_table = id_table,
>  	.probe = virtscsi_probe,
> +	.scan = virtscsi_scan,
>  #ifdef CONFIG_PM
>  	.freeze = virtscsi_freeze,
>  	.restore = virtscsi_restore,
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index f355807..c3b3f7f 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -141,8 +141,11 @@ static int virtio_dev_probe(struct device *_d)
>  	err = drv->probe(dev);
>  	if (err)
>  		add_status(dev, VIRTIO_CONFIG_S_FAILED);
> -	else
> +	else {
>  		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
> +		if (drv->scan)
> +			drv->scan(dev);
> +	}
>  
>  	return err;
>  }
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 8efd28a..a1ba8bb 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -92,6 +92,7 @@ struct virtio_driver {
>  	const unsigned int *feature_table;
>  	unsigned int feature_table_size;
>  	int (*probe)(struct virtio_device *dev);
> +	void (*scan)(struct virtio_device *dev);
>  	void (*remove)(struct virtio_device *dev);
>  	void (*config_changed)(struct virtio_device *dev);
>  #ifdef CONFIG_PM
> 
