From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] SCSI:STORVSC Use SCSI layer to allocate memory for
 per-command device request data
Date: Tue, 30 Dec 2014 03:36:22 +0000
Message-ID: <BY2PR0301MB0711B8732A3C245A7085A6D8A05E0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1419912309-13518-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:52353
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751555AbaL3DgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2014 22:36:24 -0500
In-Reply-To: <1419912309-13518-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Haiyang Zhang <haiyangz@microsoft.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Long Li <longli@microsoft.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Monday, December 29, 2014 8:05 PM
> To: KY Srinivasan; Haiyang Zhang; JBottomley@parallels.com
> Cc: linux-scsi@vger.kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Long Li; Christoph Hellwig
> Subject: [PATCH] SCSI:STORVSC Use SCSI layer to allocate memory for per-
> command device request data
> 
> STORVSC uses its own momory pool to manage device request data.
> However, SCSI layer already has a mechanisim for allocating additional
> memory for each command issued to device driver. This patch removes the
> memory pool in STORVSC and makes it use SCSI layer to allocate memory for
> device request data.
> 
> Reviewed-by: Long Li <longli@microsoft.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/scsi/storvsc_drv.c | 119 +++------------------------------------------
>  1 file changed, 8 insertions(+), 111 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 4cff0dd..14ee98e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -32,7 +32,6 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/hyperv.h>
> -#include <linux/mempool.h>
>  #include <linux/blkdev.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -309,14 +308,6 @@ enum storvsc_request_type {
>   * This is the end of Protocol specific defines.
>   */
> 
> -
> -/*
> - * We setup a mempool to allocate request structures for this driver
> - * on a per-lun basis. The following define specifies the number of
> - * elements in the pool.
> - */
> -
> -#define STORVSC_MIN_BUF_NR				64
>  static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
> 
>  module_param(storvsc_ringbuffer_size, int, S_IRUGO); @@ -346,7 +337,6
> @@ static void storvsc_on_channel_callback(void *context);
>  #define STORVSC_IDE_MAX_CHANNELS			1
> 
>  struct storvsc_cmd_request {
> -	struct list_head entry;
>  	struct scsi_cmnd *cmd;
> 
>  	unsigned int bounce_sgl_count;
> @@ -357,7 +347,6 @@ struct storvsc_cmd_request {
>  	/* Synchronize the request/response if needed */
>  	struct completion wait_event;
> 
> -	unsigned char *sense_buffer;
>  	struct hv_multipage_buffer data_buffer;
>  	struct vstor_packet vstor_packet;
>  };
> @@ -389,11 +378,6 @@ struct storvsc_device {
>  	struct storvsc_cmd_request reset_request;  };
> 
> -struct stor_mem_pools {
> -	struct kmem_cache *request_pool;
> -	mempool_t *request_mempool;
> -};
> -
>  struct hv_host_device {
>  	struct hv_device *dev;
>  	unsigned int port;
> @@ -1070,10 +1054,8 @@ static void storvsc_command_completion(struct
> storvsc_cmd_request *cmd_request)  {
>  	struct scsi_cmnd *scmnd = cmd_request->cmd;
>  	struct hv_host_device *host_dev = shost_priv(scmnd->device-
> >host);
> -	void (*scsi_done_fn)(struct scsi_cmnd *);
>  	struct scsi_sense_hdr sense_hdr;
>  	struct vmscsi_request *vm_srb;
> -	struct stor_mem_pools *memp = scmnd->device->hostdata;
>  	struct Scsi_Host *host;
>  	struct storvsc_device *stor_dev;
>  	struct hv_device *dev = host_dev->dev; @@ -1109,14 +1091,7 @@
> static void storvsc_command_completion(struct storvsc_cmd_request
> *cmd_request)
>  		cmd_request->data_buffer.len -
>  		vm_srb->data_transfer_length);
> 
> -	scsi_done_fn = scmnd->scsi_done;
> -
> -	scmnd->host_scribble = NULL;
> -	scmnd->scsi_done = NULL;
> -
> -	scsi_done_fn(scmnd);
> -
> -	mempool_free(cmd_request, memp->request_mempool);
> +	scmnd->scsi_done(scmnd);
>  }
> 
>  static void storvsc_on_io_completion(struct hv_device *device, @@ -1160,7
> +1135,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
>  			SRB_STATUS_AUTOSENSE_VALID) {
>  			/* autosense data available */
> 
> -			memcpy(request->sense_buffer,
> +			memcpy(request->cmd->sense_buffer,
>  			       vstor_packet->vm_srb.sense_data,
>  			       vstor_packet->vm_srb.sense_info_length);
> 
> @@ -1378,55 +1353,6 @@ static int storvsc_do_io(struct hv_device *device,
>  	return ret;
>  }
> 
> -static int storvsc_device_alloc(struct scsi_device *sdevice) -{
> -	struct stor_mem_pools *memp;
> -	int number = STORVSC_MIN_BUF_NR;
> -
> -	memp = kzalloc(sizeof(struct stor_mem_pools), GFP_KERNEL);
> -	if (!memp)
> -		return -ENOMEM;
> -
> -	memp->request_pool =
> -		kmem_cache_create(dev_name(&sdevice->sdev_dev),
> -				sizeof(struct storvsc_cmd_request), 0,
> -				SLAB_HWCACHE_ALIGN, NULL);
> -
> -	if (!memp->request_pool)
> -		goto err0;
> -
> -	memp->request_mempool = mempool_create(number,
> mempool_alloc_slab,
> -						mempool_free_slab,
> -						memp->request_pool);
> -
> -	if (!memp->request_mempool)
> -		goto err1;
> -
> -	sdevice->hostdata = memp;
> -
> -	return 0;
> -
> -err1:
> -	kmem_cache_destroy(memp->request_pool);
> -
> -err0:
> -	kfree(memp);
> -	return -ENOMEM;
> -}
> -
> -static void storvsc_device_destroy(struct scsi_device *sdevice) -{
> -	struct stor_mem_pools *memp = sdevice->hostdata;
> -
> -	if (!memp)
> -		return;
> -
> -	mempool_destroy(memp->request_mempool);
> -	kmem_cache_destroy(memp->request_pool);
> -	kfree(memp);
> -	sdevice->hostdata = NULL;
> -}
> -
>  static int storvsc_device_configure(struct scsi_device *sdevice)  {
>  	scsi_change_queue_depth(sdevice, STORVSC_MAX_IO_REQUESTS);
> @@ -1561,13 +1487,11 @@ static int storvsc_queuecommand(struct
> Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	int ret;
>  	struct hv_host_device *host_dev = shost_priv(host);
>  	struct hv_device *dev = host_dev->dev;
> -	struct storvsc_cmd_request *cmd_request;
> -	unsigned int request_size = 0;
> +	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
>  	int i;
>  	struct scatterlist *sgl;
>  	unsigned int sg_count = 0;
>  	struct vmscsi_request *vm_srb;
> -	struct stor_mem_pools *memp = scmnd->device->hostdata;
> 
>  	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
>  		/*
> @@ -1584,25 +1508,9 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  		}
>  	}
> 
> -	request_size = sizeof(struct storvsc_cmd_request);
> -
> -	cmd_request = mempool_alloc(memp->request_mempool,
> -				       GFP_ATOMIC);
> -
> -	/*
> -	 * We might be invoked in an interrupt context; hence
> -	 * mempool_alloc() can fail.
> -	 */
> -	if (!cmd_request)
> -		return SCSI_MLQUEUE_DEVICE_BUSY;
> -
> -	memset(cmd_request, 0, sizeof(struct storvsc_cmd_request));
> -
>  	/* Setup the cmd request */
>  	cmd_request->cmd = scmnd;
> 
> -	scmnd->host_scribble = (unsigned char *)cmd_request;
> -
>  	vm_srb = &cmd_request->vstor_packet.vm_srb;
>  	vm_srb->win8_extension.time_out_value = 60;
> 
> @@ -1637,9 +1545,6 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
> 
>  	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
> 
> -	cmd_request->sense_buffer = scmnd->sense_buffer;
> -
> -
>  	cmd_request->data_buffer.len = scsi_bufflen(scmnd);
>  	if (scsi_sg_count(scmnd)) {
>  		sgl = (struct scatterlist *)scsi_sglist(scmnd); @@ -1651,10
> +1556,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct
> scsi_cmnd *scmnd)
>  				create_bounce_buffer(sgl,
> scsi_sg_count(scmnd),
>  						     scsi_bufflen(scmnd),
>  						     vm_srb->data_in);
> -			if (!cmd_request->bounce_sgl) {
> -				ret = SCSI_MLQUEUE_HOST_BUSY;
> -				goto queue_error;
> -			}
> +			if (!cmd_request->bounce_sgl)
> +				return SCSI_MLQUEUE_HOST_BUSY;
> 
>  			cmd_request->bounce_sgl_count =
>  				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
> @@ -1692,27 +1595,21 @@ static int storvsc_queuecommand(struct
> Scsi_Host *host, struct scsi_cmnd *scmnd)
>  			destroy_bounce_buffer(cmd_request->bounce_sgl,
>  					cmd_request->bounce_sgl_count);
> 
> -		ret = SCSI_MLQUEUE_DEVICE_BUSY;
> -		goto queue_error;
> +		return SCSI_MLQUEUE_DEVICE_BUSY;
>  	}
> 
>  	return 0;
> -
> -queue_error:
> -	mempool_free(cmd_request, memp->request_mempool);
> -	scmnd->host_scribble = NULL;
> -	return ret;
>  }
> 
>  static struct scsi_host_template scsi_driver = {
>  	.module	=		THIS_MODULE,
>  	.name =			"storvsc_host_t",
> +	.cmd_size =             sizeof(struct storvsc_cmd_request),
>  	.bios_param =		storvsc_get_chs,
>  	.queuecommand =		storvsc_queuecommand,
>  	.eh_host_reset_handler =	storvsc_host_reset_handler,
> +	.proc_name =		"storvsc_host",
>  	.eh_timed_out =		storvsc_eh_timed_out,
> -	.slave_alloc =		storvsc_device_alloc,
> -	.slave_destroy =	storvsc_device_destroy,
>  	.slave_configure =	storvsc_device_configure,
>  	.cmd_per_lun =		255,
>  	.can_queue =
> 	STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
> --
> 2.1.0

