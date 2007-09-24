From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] Fix ibmvscsi client for multiplatform iSeries+pSeries
 kernel
Date: Mon, 24 Sep 2007 08:34:42 -0500
Message-ID: <46F7BCF2.60108@linux.vnet.ibm.com>
References: <18164.17872.245720.767853@cargo.ozlabs.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39235 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbXIXNep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2007 09:34:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8ODYi6d004172
	for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2007 09:34:44 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8ODYite530334
	for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2007 09:34:44 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8ODYhiL019078
	for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2007 09:34:44 -0400
In-Reply-To: <18164.17872.245720.767853@cargo.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

Paul,

It looks like there is a bunch of unrelated arch powerpc bits at the end
of this patch. 

-Brian

Paul Mackerras wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> If you build a multiplatform kernel for iSeries and pSeries, with
> ibmvscsic support, the resulting client doesn't work on iSeries.
> 
> This fixes that, using the appropriate low-level operations
> for the machine detected at runtime.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Acked by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This is being submitted for inclusion in 2.6.24.
> 
> ---
> diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
> index 9c14e78..1821461 100644
> --- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
> +++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
> @@ -42,14 +42,14 @@ static unsigned int partition_number = -1;
>   * Routines for managing the command/response queue
>   */
>  /**
> - * ibmvscsi_handle_event: - Interrupt handler for crq events
> + * rpavscsi_handle_event: - Interrupt handler for crq events
>   * @irq:	number of irq to handle, not used
>   * @dev_instance: ibmvscsi_host_data of host that received interrupt
>   *
>   * Disables interrupts and schedules srp_task
>   * Always returns IRQ_HANDLED
>   */
> -static irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance)
> +static irqreturn_t rpavscsi_handle_event(int irq, void *dev_instance)
>  {
>  	struct ibmvscsi_host_data *hostdata =
>  	    (struct ibmvscsi_host_data *)dev_instance;
> @@ -66,9 +66,9 @@ static irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance)
>   * Frees irq, deallocates a page for messages, unmaps dma, and unregisters
>   * the crq with the hypervisor.
>   */
> -void ibmvscsi_release_crq_queue(struct crq_queue *queue,
> -				struct ibmvscsi_host_data *hostdata,
> -				int max_requests)
> +static void rpavscsi_release_crq_queue(struct crq_queue *queue,
> +				       struct ibmvscsi_host_data *hostdata,
> +				       int max_requests)
>  {
>  	long rc;
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> @@ -108,12 +108,13 @@ static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
>  }
> 
>  /**
> - * ibmvscsi_send_crq: - Send a CRQ
> + * rpavscsi_send_crq: - Send a CRQ
>   * @hostdata:	the adapter
>   * @word1:	the first 64 bits of the data
>   * @word2:	the second 64 bits of the data
>   */
> -int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
> +static int rpavscsi_send_crq(struct ibmvscsi_host_data *hostdata,
> +			     u64 word1, u64 word2)
>  {
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> 
> @@ -121,10 +122,10 @@ int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
>  }
> 
>  /**
> - * ibmvscsi_task: - Process srps asynchronously
> + * rpavscsi_task: - Process srps asynchronously
>   * @data:	ibmvscsi_host_data of host
>   */
> -static void ibmvscsi_task(void *data)
> +static void rpavscsi_task(void *data)
>  {
>  	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> @@ -190,6 +191,42 @@ static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
>  }
> 
>  /**
> + * reset_crq_queue: - resets a crq after a failure
> + * @queue:	crq_queue to initialize and register
> + * @hostdata:	ibmvscsi_host_data of host
> + *
> + */
> +static int rpavscsi_reset_crq_queue(struct crq_queue *queue,
> +				    struct ibmvscsi_host_data *hostdata)
> +{
> +	int rc;
> +	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> +
> +	/* Close the CRQ */
> +	do {
> +		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
> +	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
> +
> +	/* Clean out the queue */
> +	memset(queue->msgs, 0x00, PAGE_SIZE);
> +	queue->cur = 0;
> +
> +	set_adapter_info(hostdata);
> +
> +	/* And re-open it again */
> +	rc = plpar_hcall_norets(H_REG_CRQ,
> +				vdev->unit_address,
> +				queue->msg_token, PAGE_SIZE);
> +	if (rc == 2) {
> +		/* Adapter is good, but other end is not ready */
> +		dev_warn(hostdata->dev, "Partner adapter not ready\n");
> +	} else if (rc != 0) {
> +		dev_warn(hostdata->dev, "couldn't register crq--rc 0x%x\n", rc);
> +	}
> +	return rc;
> +}
> +
> +/**
>   * initialize_crq_queue: - Initializes and registers CRQ with hypervisor
>   * @queue:	crq_queue to initialize and register
>   * @hostdata:	ibmvscsi_host_data of host
> @@ -198,9 +235,9 @@ static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
>   * the crq with the hypervisor.
>   * Returns zero on success.
>   */
> -int ibmvscsi_init_crq_queue(struct crq_queue *queue,
> -			    struct ibmvscsi_host_data *hostdata,
> -			    int max_requests)
> +static int rpavscsi_init_crq_queue(struct crq_queue *queue,
> +				   struct ibmvscsi_host_data *hostdata,
> +				   int max_requests)
>  {
>  	int rc;
>  	int retrc;
> @@ -227,7 +264,7 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  				queue->msg_token, PAGE_SIZE);
>  	if (rc == H_RESOURCE)
>  		/* maybe kexecing and resource is busy. try a reset */
> -		rc = ibmvscsi_reset_crq_queue(queue,
> +		rc = rpavscsi_reset_crq_queue(queue,
>  					      hostdata);
> 
>  	if (rc == 2) {
> @@ -240,7 +277,7 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  	}
> 
>  	if (request_irq(vdev->irq,
> -			ibmvscsi_handle_event,
> +			rpavscsi_handle_event,
>  			0, "ibmvscsi", (void *)hostdata) != 0) {
>  		dev_err(hostdata->dev, "couldn't register irq 0x%x\n",
>  			vdev->irq);
> @@ -256,7 +293,7 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  	queue->cur = 0;
>  	spin_lock_init(&queue->lock);
> 
> -	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
> +	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
>  		     (unsigned long)hostdata);
> 
>  	return retrc;
> @@ -281,8 +318,8 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>   * @hostdata:	ibmvscsi_host_data of host
>   *
>   */
> -int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
> -				 struct ibmvscsi_host_data *hostdata)
> +static int rpavscsi_reenable_crq_queue(struct crq_queue *queue,
> +				       struct ibmvscsi_host_data *hostdata)
>  {
>  	int rc;
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> @@ -297,38 +334,10 @@ int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
>  	return rc;
>  }
> 
> -/**
> - * reset_crq_queue: - resets a crq after a failure
> - * @queue:	crq_queue to initialize and register
> - * @hostdata:	ibmvscsi_host_data of host
> - *
> - */
> -int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
> -			      struct ibmvscsi_host_data *hostdata)
> -{
> -	int rc;
> -	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> -
> -	/* Close the CRQ */
> -	do {
> -		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
> -	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
> -
> -	/* Clean out the queue */
> -	memset(queue->msgs, 0x00, PAGE_SIZE);
> -	queue->cur = 0;
> -
> -	set_adapter_info(hostdata);
> -
> -	/* And re-open it again */
> -	rc = plpar_hcall_norets(H_REG_CRQ,
> -				vdev->unit_address,
> -				queue->msg_token, PAGE_SIZE);
> -	if (rc == 2) {
> -		/* Adapter is good, but other end is not ready */
> -		dev_warn(hostdata->dev, "Partner adapter not ready\n");
> -	} else if (rc != 0) {
> -		dev_warn(hostdata->dev, "couldn't register crq--rc 0x%x\n", rc);
> -	}
> -	return rc;
> -}
> +struct ibmvscsi_ops rpavscsi_ops = {
> +	.init_crq_queue = rpavscsi_init_crq_queue,
> +	.release_crq_queue = rpavscsi_release_crq_queue,
> +	.reset_crq_queue = rpavscsi_reset_crq_queue,
> +	.reenable_crq_queue = rpavscsi_reenable_crq_queue,
> +	.send_crq = rpavscsi_send_crq,
> +};
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 5870866..ed9b675 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -70,6 +70,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/delay.h>
> +#include <asm/firmware.h>
>  #include <asm/vio.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -89,6 +90,8 @@ static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
> 
>  #define IBMVSCSI_VERSION "1.5.8"
> 
> +static struct ibmvscsi_ops *ibmvscsi_ops;
> +
>  MODULE_DESCRIPTION("IBM Virtual SCSI");
>  MODULE_AUTHOR("Dave Boutcher");
>  MODULE_LICENSE("GPL");
> @@ -512,8 +515,8 @@ static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
>  	atomic_set(&hostdata->request_limit, 0);
> 
>  	purge_requests(hostdata, DID_ERROR);
> -	if ((ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata)) ||
> -	    (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0)) ||
> +	if ((ibmvscsi_ops->reset_crq_queue(&hostdata->queue, hostdata)) ||
> +	    (ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0)) ||
>  	    (vio_enable_interrupts(to_vio_dev(hostdata->dev)))) {
>  		atomic_set(&hostdata->request_limit, -1);
>  		dev_err(hostdata->dev, "error after reset\n");
> @@ -618,7 +621,7 @@ static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
>  	}
> 
>  	if ((rc =
> -	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
> +	     ibmvscsi_ops->send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
>  		list_del(&evt_struct->list);
>  		del_timer(&evt_struct->timer);
> 
> @@ -1222,8 +1225,8 @@ void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  		case 0x01:	/* Initialization message */
>  			dev_info(hostdata->dev, "partner initialized\n");
>  			/* Send back a response */
> -			if ((rc = ibmvscsi_send_crq(hostdata,
> -						    0xC002000000000000LL, 0)) == 0) {
> +			if ((rc = ibmvscsi_ops->send_crq(hostdata,
> +							 0xC002000000000000LL, 0)) == 0) {
>  				/* Now login */
>  				send_srp_login(hostdata);
>  			} else {
> @@ -1248,10 +1251,10 @@ void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  			/* We need to re-setup the interpartition connection */
>  			dev_info(hostdata->dev, "Re-enabling adapter!\n");
>  			purge_requests(hostdata, DID_REQUEUE);
> -			if ((ibmvscsi_reenable_crq_queue(&hostdata->queue,
> -							hostdata)) ||
> -			    (ibmvscsi_send_crq(hostdata,
> -					       0xC001000000000000LL, 0))) {
> +			if ((ibmvscsi_ops->reenable_crq_queue(&hostdata->queue,
> +							      hostdata)) ||
> +			    (ibmvscsi_ops->send_crq(hostdata,
> +						    0xC001000000000000LL, 0))) {
>  					atomic_set(&hostdata->request_limit,
>  						   -1);
>  					dev_err(hostdata->dev, "error after enable\n");
> @@ -1261,10 +1264,10 @@ void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  				crq->format);
> 
>  			purge_requests(hostdata, DID_ERROR);
> -			if ((ibmvscsi_reset_crq_queue(&hostdata->queue,
> -							hostdata)) ||
> -			    (ibmvscsi_send_crq(hostdata,
> -					       0xC001000000000000LL, 0))) {
> +			if ((ibmvscsi_ops->reset_crq_queue(&hostdata->queue,
> +							   hostdata)) ||
> +			    (ibmvscsi_ops->send_crq(hostdata,
> +						    0xC001000000000000LL, 0))) {
>  					atomic_set(&hostdata->request_limit,
>  						   -1);
>  					dev_err(hostdata->dev, "error after reset\n");
> @@ -1590,7 +1593,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	atomic_set(&hostdata->request_limit, -1);
>  	hostdata->host->max_sectors = 32 * 8; /* default max I/O 32 pages */
> 
> -	rc = ibmvscsi_init_crq_queue(&hostdata->queue, hostdata, max_requests);
> +	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_requests);
>  	if (rc != 0 && rc != H_RESOURCE) {
>  		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
>  		goto init_crq_failed;
> @@ -1611,7 +1614,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	 * to fail if the other end is not acive.  In that case we don't
>  	 * want to scan
>  	 */
> -	if (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0) == 0
> +	if (ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0) == 0
>  	    || rc == H_RESOURCE) {
>  		/*
>  		 * Wait around max init_timeout secs for the adapter to finish
> @@ -1637,7 +1640,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>        add_host_failed:
>  	release_event_pool(&hostdata->pool, hostdata);
>        init_pool_failed:
> -	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata, max_requests);
> +	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_requests);
>        init_crq_failed:
>  	scsi_host_put(host);
>        scsi_host_alloc_failed:
> @@ -1648,8 +1651,8 @@ static int ibmvscsi_remove(struct vio_dev *vdev)
>  {
>  	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
>  	release_event_pool(&hostdata->pool, hostdata);
> -	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
> -				   max_requests);
> +	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
> +					max_requests);
>  	
>  	scsi_remove_host(hostdata->host);
>  	scsi_host_put(hostdata->host);
> @@ -1679,6 +1682,13 @@ static struct vio_driver ibmvscsi_driver = {
> 
>  int __init ibmvscsi_module_init(void)
>  {
> +	if (firmware_has_feature(FW_FEATURE_ISERIES))
> +		ibmvscsi_ops = &iseriesvscsi_ops;
> +	else if (firmware_has_feature(FW_FEATURE_VIO))
> +		ibmvscsi_ops = &rpavscsi_ops;
> +	else
> +		return -ENODEV;
> +
>  	return vio_register_driver(&ibmvscsi_driver);
>  }
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
> index b19c2e2..46e850e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.h
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
> @@ -98,21 +98,25 @@ struct ibmvscsi_host_data {
>  };
> 
>  /* routines for managing a command/response queue */
> -int ibmvscsi_init_crq_queue(struct crq_queue *queue,
> -			    struct ibmvscsi_host_data *hostdata,
> -			    int max_requests);
> -void ibmvscsi_release_crq_queue(struct crq_queue *queue,
> -				struct ibmvscsi_host_data *hostdata,
> -				int max_requests);
> -int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
> -			      struct ibmvscsi_host_data *hostdata);
> -
> -int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
> -				struct ibmvscsi_host_data *hostdata);
> -
>  void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  			 struct ibmvscsi_host_data *hostdata);
> -int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
> -		      u64 word1, u64 word2);
> +
> +struct ibmvscsi_ops {
> +	int (*init_crq_queue)(struct crq_queue *queue,
> +			      struct ibmvscsi_host_data *hostdata,
> +			      int max_requests);
> +	void (*release_crq_queue)(struct crq_queue *queue,
> +				  struct ibmvscsi_host_data *hostdata,
> +				  int max_requests);
> +	int (*reset_crq_queue)(struct crq_queue *queue,
> +			       struct ibmvscsi_host_data *hostdata);
> +	int (*reenable_crq_queue)(struct crq_queue *queue,
> +				  struct ibmvscsi_host_data *hostdata);
> +	int (*send_crq)(struct ibmvscsi_host_data *hostdata,
> +		       u64 word1, u64 word2);
> +};
> +
> +extern struct ibmvscsi_ops iseriesvscsi_ops;
> +extern struct ibmvscsi_ops rpavscsi_ops;
> 
>  #endif				/* IBMVSCSI_H */
> diff --git a/drivers/scsi/ibmvscsi/iseries_vscsi.c b/drivers/scsi/ibmvscsi/iseries_vscsi.c
> index 6aeb5f0..0775fde 100644
> --- a/drivers/scsi/ibmvscsi/iseries_vscsi.c
> +++ b/drivers/scsi/ibmvscsi/iseries_vscsi.c
> @@ -53,7 +53,7 @@ struct srp_lp_event {
>  /** 
>   * standard interface for handling logical partition events.
>   */
> -static void ibmvscsi_handle_event(struct HvLpEvent *lpevt)
> +static void iseriesvscsi_handle_event(struct HvLpEvent *lpevt)
>  {
>  	struct srp_lp_event *evt = (struct srp_lp_event *)lpevt;
> 
> @@ -74,9 +74,9 @@ static void ibmvscsi_handle_event(struct HvLpEvent *lpevt)
>  /* ------------------------------------------------------------
>   * Routines for driver initialization
>   */
> -int ibmvscsi_init_crq_queue(struct crq_queue *queue,
> -			    struct ibmvscsi_host_data *hostdata,
> -			    int max_requests)
> +static int iseriesvscsi_init_crq_queue(struct crq_queue *queue,
> +				       struct ibmvscsi_host_data *hostdata,
> +				       int max_requests)
>  {
>  	int rc;
> 
> @@ -88,7 +88,7 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  		goto viopath_open_failed;
>  	}
> 
> -	rc = vio_setHandler(viomajorsubtype_scsi, ibmvscsi_handle_event);
> +	rc = vio_setHandler(viomajorsubtype_scsi, iseriesvscsi_handle_event);
>  	if (rc < 0) {
>  		printk("vio_setHandler failed with rc %d in open_event_path\n",
>  		       rc);
> @@ -102,9 +102,9 @@ int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  	return -1;
>  }
> 
> -void ibmvscsi_release_crq_queue(struct crq_queue *queue,
> -				struct ibmvscsi_host_data *hostdata,
> -				int max_requests)
> +static void iseriesvscsi_release_crq_queue(struct crq_queue *queue,
> +					   struct ibmvscsi_host_data *hostdata,
> +					   int max_requests)
>  {
>  	vio_clearHandler(viomajorsubtype_scsi);
>  	viopath_close(viopath_hostLp, viomajorsubtype_scsi, max_requests);
> @@ -117,8 +117,8 @@ void ibmvscsi_release_crq_queue(struct crq_queue *queue,
>   *
>   * no-op for iSeries
>   */
> -int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
> -			      struct ibmvscsi_host_data *hostdata)
> +static int iseriesvscsi_reset_crq_queue(struct crq_queue *queue,
> +					struct ibmvscsi_host_data *hostdata)
>  {
>  	return 0;
>  }
> @@ -130,19 +130,20 @@ int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
>   *
>   * no-op for iSeries
>   */
> -int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
> -				struct ibmvscsi_host_data *hostdata)
> +static int iseriesvscsi_reenable_crq_queue(struct crq_queue *queue,
> +					   struct ibmvscsi_host_data *hostdata)
>  {
>  	return 0;
>  }
> 
>  /**
> - * ibmvscsi_send_crq: - Send a CRQ
> + * iseriesvscsi_send_crq: - Send a CRQ
>   * @hostdata:	the adapter
>   * @word1:	the first 64 bits of the data
>   * @word2:	the second 64 bits of the data
>   */
> -int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
> +static int iseriesvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
> +				 u64 word1, u64 word2)
>  {
>  	single_host_data = hostdata;
>  	return HvCallEvent_signalLpEventFast(viopath_hostLp,
> @@ -156,3 +157,11 @@ int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
>  					     VIOVERSION << 16, word1, word2, 0,
>  					     0);
>  }
> +
> +struct ibmvscsi_ops iseriesvscsi_ops = {
> +	.init_crq_queue = iseriesvscsi_init_crq_queue,
> +	.release_crq_queue = iseriesvscsi_release_crq_queue,
> +	.reset_crq_queue = iseriesvscsi_reset_crq_queue,
> +	.reenable_crq_queue = iseriesvscsi_reenable_crq_queue,
> +	.send_crq = iseriesvscsi_send_crq,
> +};
> diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
> index f67d9ef..6ac0633 100644
> --- a/drivers/scsi/ibmvscsi/Makefile
> +++ b/drivers/scsi/ibmvscsi/Makefile
> @@ -1,9 +1,7 @@
>  obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
> 
>  ibmvscsic-y			+= ibmvscsi.o
> -ifndef CONFIG_PPC_PSERIES
>  ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
> -endif
>  ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
> 
>  obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvstgt.o
> 
>>From mathieu.desnoyers@polymtl.ca Tue Aug 28 01:52:38 2007
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Subject: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to powerpc
> Date: Tue, 28 Aug 2007 01:52:38 +1000
> X-Patchwork-ID: 13137
> 
> Make sure that at least cmpxchg64_local is available on all
> architectures to use for unsigned long long values.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/asm-powerpc/system.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> 
> 
> ---
> Index: linux-2.6-lttng/include/asm-powerpc/system.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-powerpc/system.h	2007-08-27 11:42:08.000000000 -0400
> +++ linux-2.6-lttng/include/asm-powerpc/system.h	2007-08-27 11:42:43.000000000 -0400
> @@ -485,6 +485,12 @@ __cmpxchg_local(volatile void *ptr, unsi
>   */
>  #define NET_IP_ALIGN	0
>  #define NET_SKB_PAD	L1_CACHE_BYTES
> +
> +#define cmpxchg64	cmpxchg
> +#define cmpxchg64_local	cmpxchg_local
> +#else
> +#include <asm-generic/cmpxchg-local.h>
> +#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
>  #endif
> 
>  #define arch_align_stack(x) (x)
> 
>>From grant.likely@secretlab.ca Fri Aug 31 06:26:24 2007
> From: Grant Likely <grant.likely@secretlab.ca>
> Subject: [PATCH 2/3] mpc8349: Add linux,network-index to ethernet nodes in device tree
> Date: Fri, 31 Aug 2007 06:26:24 +1000
> X-Patchwork-ID: 13235
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> cuImage needs to know the logical index of the ethernet devices in order
> to assign mac addresses.  This adds the needed properties.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: David Gibson <david@gibson.dropbear.id.au>
> CC: Scott Wood <scottwood@freescale.com>
> CC: Kumar Gala <galak@kernel.crashing.org>
> CC: Timur Tabi <timur@freescale.com>
> ---
> 
>  arch/powerpc/boot/dts/mpc8349emitx.dts   |    2 ++
>  arch/powerpc/boot/dts/mpc8349emitxgp.dts |    1 +
>  arch/powerpc/boot/dts/mpc834x_mds.dts    |    2 ++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> 
> 
> ---
> diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
> index 502f47c..a4e2284 100644
> --- a/arch/powerpc/boot/dts/mpc8349emitx.dts
> +++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
> @@ -141,6 +141,7 @@
>  			interrupts = <20 8 21 8 22 8>;
>  			interrupt-parent = < &ipic >;
>  			phy-handle = < &phy1c >;
> +			linux,network-index = <0>;
>  		};
> 
>  		ethernet@25000 {
> @@ -160,6 +161,7 @@
>  			interrupts = <23 8 24 8 25 8>;
>  			interrupt-parent = < &ipic >;
>  			phy-handle = < &phy1f >;
> +			linux,network-index = <1>;
>  		};
> 
>  		serial@4500 {
> diff --git a/arch/powerpc/boot/dts/mpc8349emitxgp.dts b/arch/powerpc/boot/dts/mpc8349emitxgp.dts
> index 0b83871..004b737 100644
> --- a/arch/powerpc/boot/dts/mpc8349emitxgp.dts
> +++ b/arch/powerpc/boot/dts/mpc8349emitxgp.dts
> @@ -116,6 +116,7 @@
>  			interrupts = <20 8 21 8 22 8>;
>  			interrupt-parent = < &ipic >;
>  			phy-handle = < &phy1c >;
> +			linux,network-index = <0>;
>  		};
> 
>  		serial@4500 {
> diff --git a/arch/powerpc/boot/dts/mpc834x_mds.dts b/arch/powerpc/boot/dts/mpc834x_mds.dts
> index 4810997..251c233 100644
> --- a/arch/powerpc/boot/dts/mpc834x_mds.dts
> +++ b/arch/powerpc/boot/dts/mpc834x_mds.dts
> @@ -146,6 +146,7 @@
>  			interrupts = <20 8 21 8 22 8>;
>  			interrupt-parent = < &ipic >;
>  			phy-handle = < &phy0 >;
> +			linux,network-index = <0>;
>  		};
> 
>  		ethernet@25000 {
> @@ -165,6 +166,7 @@
>  			interrupts = <23 8 24 8 25 8>;
>  			interrupt-parent = < &ipic >;
>  			phy-handle = < &phy1 >;
> +			linux,network-index = <1>;
>  		};
> 
>  		serial@4500 {
> 
>>From grant.likely@secretlab.ca Sat Sep  1 03:34:37 2007
> From: Grant Likely <grant.likely@secretlab.ca>
> Subject: mpc5200: Add cuimage support for mpc5200 boards
> Date: Sat, 01 Sep 2007 03:34:37 +1000
> X-Patchwork-ID: 13249
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: David Gibson <david@gibson.dropbear.id.au>
> ---
> 
>  arch/powerpc/boot/Makefile          |    5 ++-
>  arch/powerpc/boot/cuboot-52xx.c     |   59 ++++++++++++++++++++++++++++++
>  arch/powerpc/boot/mpc52xx-psc.c     |   69 +++++++++++++++++++++++++++++++++++
>  arch/powerpc/boot/ops.h             |    1 +
>  arch/powerpc/boot/serial.c          |    2 +
>  arch/powerpc/platforms/52xx/Kconfig |    1 +
>  6 files changed, 135 insertions(+), 2 deletions(-)
> 
> 
> ---
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index cd7c057..45be0e5 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -45,8 +45,8 @@ src-wlib := string.S crt0.S stdio.c main.c flatdevtree.c flatdevtree_misc.c \
>  		ns16550.c serial.c simple_alloc.c div64.S util.S \
>  		gunzip_util.c elf_util.c $(zlib) devtree.c oflib.c ofconsole.c \
>  		4xx.c ebony.c mv64x60.c mpsc.c mv64x60_i2c.c cuboot.c bamboo.c \
> -		cpm-serial.c
> -src-plat := of.c cuboot-83xx.c cuboot-85xx.c holly.c \
> +		cpm-serial.c mpc52xx-psc.c
> +src-plat := of.c cuboot-52xx.c cuboot-83xx.c cuboot-85xx.c holly.c \
>  		cuboot-ebony.c treeboot-ebony.c prpmc2800.c \
>  		ps3-head.S ps3-hvcall.S ps3.c treeboot-bamboo.c cuboot-8xx.c cuboot-pq2.c
>  src-boot := $(src-wlib) $(src-plat) empty.c
> @@ -142,6 +142,7 @@ image-$(CONFIG_DEFAULT_UIMAGE)		+= uImage
>  ifneq ($(CONFIG_DEVICE_TREE),"")
>  image-$(CONFIG_PPC_8xx)			+= cuImage.8xx
>  image-$(CONFIG_8260)			+= cuImage.pq2
> +image-$(CONFIG_PPC_MPC52xx)		+= cuImage.52xx
>  image-$(CONFIG_PPC_83xx)		+= cuImage.83xx
>  image-$(CONFIG_PPC_85xx)		+= cuImage.85xx
>  image-$(CONFIG_EBONY)			+= treeImage.ebony cuImage.ebony
> diff --git a/arch/powerpc/boot/cuboot-52xx.c b/arch/powerpc/boot/cuboot-52xx.c
> new file mode 100644
> index 0000000..9256a26
> --- /dev/null
> +++ b/arch/powerpc/boot/cuboot-52xx.c
> @@ -0,0 +1,59 @@
> +/*
> + * Old U-boot compatibility for MPC5200
> + *
> + * Author: Grant Likely <grant.likely@secretlab.ca>
> + *
> + * Copyright (c) 2007 Secret Lab Technologies Ltd.
> + * Copyright (c) 2007 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include "ops.h"
> +#include "stdio.h"
> +#include "io.h"
> +#include "cuboot.h"
> +
> +#define TARGET_PPC_MPC52xx
> +#include "ppcboot.h"
> +
> +static bd_t bd;
> +
> +static void platform_fixups(void)
> +{
> +	void *soc, *reg;
> +	int div;
> +	u32 sysfreq;
> +
> +
> +	dt_fixup_memory(bd.bi_memstart, bd.bi_memsize);
> +	dt_fixup_mac_addresses(bd.bi_enetaddr);
> +	dt_fixup_cpu_clocks(bd.bi_intfreq, bd.bi_busfreq / 4, bd.bi_busfreq);
> +
> +	/* Unfortunately, the specific model number is encoded in the
> +	 * soc node name in existing dts files -- once that is fixed,
> +	 * this can do a simple path lookup.
> +	 */
> +	soc = find_node_by_devtype(NULL, "soc");
> +	if (soc) {
> +		setprop(soc, "bus-frequency", &bd.bi_ipbfreq,
> +			sizeof(bd.bi_ipbfreq));
> +
> +		if (!dt_xlate_reg(soc, 0, (void*)&reg, NULL))
> +			return;
> +		div = in_8(reg + 0x204) & 0x0020 ? 8 : 4;
> +		sysfreq = bd.bi_busfreq * div;
> +		setprop(soc, "system-frequency", &sysfreq, sizeof(sysfreq));
> +	}
> +}
> +
> +void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
> +                   unsigned long r6, unsigned long r7)
> +{
> +	CUBOOT_INIT();
> +	ft_init(_dtb_start, _dtb_end - _dtb_start, 32);
> +	serial_console_init();
> +	platform_ops.fixups = platform_fixups;
> +}
> diff --git a/arch/powerpc/boot/mpc52xx-psc.c b/arch/powerpc/boot/mpc52xx-psc.c
> new file mode 100644
> index 0000000..1074626
> --- /dev/null
> +++ b/arch/powerpc/boot/mpc52xx-psc.c
> @@ -0,0 +1,69 @@
> +/*
> + * MPC5200 PSC serial console support.
> + *
> + * Author: Grant Likely <grant.likely@secretlab.ca>
> + *
> + * Copyright (c) 2007 Secret Lab Technologies Ltd.
> + * Copyright (c) 2007 Freescale Semiconductor, Inc.
> + *
> + * It is assumed that the firmware (or the platform file) has already set
> + * up the port.
> + */
> +
> +#include "types.h"
> +#include "io.h"
> +#include "ops.h"
> +
> +/* Programmable Serial Controller (PSC) status register bits */
> +#define MPC52xx_PSC_SR		0x04
> +#define MPC52xx_PSC_SR_RXRDY		0x0100
> +#define MPC52xx_PSC_SR_RXFULL		0x0200
> +#define MPC52xx_PSC_SR_TXRDY		0x0400
> +#define MPC52xx_PSC_SR_TXEMP		0x0800
> +
> +#define MPC52xx_PSC_BUFFER	0x0C
> +
> +static void *psc;
> +
> +static int psc_open(void)
> +{
> +	/* Assume the firmware has already configured the PSC into
> +	 * uart mode */
> +	return 0;
> +}
> +
> +static void psc_putc(unsigned char c)
> +{
> +	while (!(in_be16(psc + MPC52xx_PSC_SR) & MPC52xx_PSC_SR_TXRDY)) ;
> +	out_8(psc + MPC52xx_PSC_BUFFER, c);
> +}
> +
> +static unsigned char psc_tstc(void)
> +{
> +	return (in_be16(psc + MPC52xx_PSC_SR) & MPC52xx_PSC_SR_RXRDY) != 0;
> +}
> +
> +static unsigned char psc_getc(void)
> +{
> +	while (!(in_be16(psc + MPC52xx_PSC_SR) & MPC52xx_PSC_SR_RXRDY)) ;
> +	return in_8(psc + MPC52xx_PSC_BUFFER);
> +}
> +
> +int mpc5200_psc_console_init(void *devp, struct serial_console_data *scdp)
> +{
> +	int n;
> +
> +	/* Get the base address of the psc registers */
> +	n = getprop(devp, "virtual-reg", &psc, sizeof(psc));
> +	if (n != sizeof(psc)) {
> +		if (!dt_xlate_reg(devp, 0, (void *)&psc, NULL))
> +			return -1;
> +	}
> +
> +	scdp->open = psc_open;
> +	scdp->putc = psc_putc;
> +	scdp->getc = psc_getc;
> +	scdp->tstc = psc_tstc;
> +
> +	return 0;
> +}
> diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
> index 45c2268..5ab9b51 100644
> --- a/arch/powerpc/boot/ops.h
> +++ b/arch/powerpc/boot/ops.h
> @@ -83,6 +83,7 @@ int serial_console_init(void);
>  int ns16550_console_init(void *devp, struct serial_console_data *scdp);
>  int mpsc_console_init(void *devp, struct serial_console_data *scdp);
>  int cpm_console_init(void *devp, struct serial_console_data *scdp);
> +int mpc5200_psc_console_init(void *devp, struct serial_console_data *scdp);
>  void *simple_alloc_init(char *base, unsigned long heap_size,
>  			unsigned long granularity, unsigned long max_allocs);
>  extern void flush_cache(void *, unsigned long);
> diff --git a/arch/powerpc/boot/serial.c b/arch/powerpc/boot/serial.c
> index d47f8e0..95e08e4 100644
> --- a/arch/powerpc/boot/serial.c
> +++ b/arch/powerpc/boot/serial.c
> @@ -126,6 +126,8 @@ int serial_console_init(void)
>  	         dt_is_compatible(devp, "fsl,cpm2-scc-uart") ||
>  	         dt_is_compatible(devp, "fsl,cpm2-smc-uart"))
>  		rc = cpm_console_init(devp, &serial_cd);
> +	else if (dt_is_compatible(devp, "mpc5200-psc-uart"))
> +		rc = mpc5200_psc_console_init(devp, &serial_cd);
> 
>  	/* Add other serial console driver calls here */
> 
> diff --git a/arch/powerpc/platforms/52xx/Kconfig b/arch/powerpc/platforms/52xx/Kconfig
> index 3ffaa06..9ddf251 100644
> --- a/arch/powerpc/platforms/52xx/Kconfig
> +++ b/arch/powerpc/platforms/52xx/Kconfig
> @@ -30,6 +30,7 @@ config PPC_EFIKA
>  config PPC_LITE5200
>  	bool "Freescale Lite5200 Eval Board"
>  	depends on PPC_MULTIPLATFORM && PPC32
> +	select WANT_DEVICE_TREE
>  	select PPC_MPC5200
>  	default n
> 
> 
>>From tony@bakeyournoodle.com Wed Sep 12 13:58:54 2007
> From: Tony Breeds <tony@bakeyournoodle.com>
> Subject: Convert define_machine(mpc885_ads) to C99 initializer syntax
> Date: Wed, 12 Sep 2007 13:58:54 +1000
> X-Patchwork-ID: 13372
> 
> Make the define_machine() block for mpc885_ads more greppable and
> consistent with other examples in tree.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> 
>  arch/powerpc/platforms/8xx/mpc885ads_setup.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> 
> Yours Tony
> 
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
> 
> 
> ---
> Index: working/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> ===================================================================
> --- working.orig/arch/powerpc/platforms/8xx/mpc885ads_setup.c	2007-09-10 16:56:54.000000000 +1000
> +++ working/arch/powerpc/platforms/8xx/mpc885ads_setup.c	2007-09-12 13:53:17.000000000 +1000
> @@ -441,9 +441,14 @@ static int __init mpc885ads_probe(void)
> 
>  define_machine(mpc885_ads)
>  {
> -.name = "MPC885 ADS",.probe = mpc885ads_probe,.setup_arch =
> -	    mpc885ads_setup_arch,.init_IRQ =
> -	    m8xx_pic_init,.show_cpuinfo = mpc8xx_show_cpuinfo,.get_irq =
> -	    mpc8xx_get_irq,.restart = mpc8xx_restart,.calibrate_decr =
> -	    mpc8xx_calibrate_decr,.set_rtc_time =
> -	    mpc8xx_set_rtc_time,.get_rtc_time = mpc8xx_get_rtc_time,};
> +	.name            = "MPC885 ADS",
> +	.probe           = mpc885ads_probe,
> +	.setup_arch      = mpc885ads_setup_arch,
> +	.init_IRQ        = m8xx_pic_init,
> +	.show_cpuinfo    = mpc8xx_show_cpuinfo,
> +	.get_irq         = mpc8xx_get_irq,
> +	.restart         = mpc8xx_restart,
> +	.calibrate_decr  = mpc8xx_calibrate_decr,
> +	.set_rtc_time    = mpc8xx_set_rtc_time,
> +	.get_rtc_time    = mpc8xx_get_rtc_time,
> +};
> 
>>From jk@ozlabs.org Fri Sep 14 15:46:40 2007
> From: Jeremy Kerr <jk@ozlabs.org>
> Subject: [PATCH 1/2] cell: Don't cast the result of of_get_property()
> Date: Fri, 14 Sep 2007 15:46:40 +1000
> X-Patchwork-ID: 13451
> 
> The cast to u32 * isn't required, of_get_property returns a void *.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
> 
> ---
>  arch/powerpc/platforms/cell/spu_manage.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> ---
> diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
> index 0e14f53..1b01070 100644
> --- a/arch/powerpc/platforms/cell/spu_manage.c
> +++ b/arch/powerpc/platforms/cell/spu_manage.c
> @@ -377,10 +377,10 @@ static int qs20_reg_memory[QS20_SPES_PER_BE] = { 1, 1, 0, 0, 0, 0, 0, 0 };
>  static struct spu *spu_lookup_reg(int node, u32 reg)
>  {
>  	struct spu *spu;
> -	u32 *spu_reg;
> +	const u32 *spu_reg;
> 
>  	list_for_each_entry(spu, &cbe_spu_info[node].spus, cbe_list) {
> -		spu_reg = (u32*)of_get_property(spu_devnode(spu), "reg", NULL);
> +		spu_reg = of_get_property(spu_devnode(spu), "reg", NULL);
>  		if (*spu_reg == reg)
>  			return spu;
>  	}
> 
>>From arnd@arndb.de Sat Sep 15 10:21:57 2007
> From: Arnd Bergmann <arnd@arndb.de>
> Subject: add Kconfig option for optimizing for cell
> Date: Sat, 15 Sep 2007 10:21:57 +1000
> X-Patchwork-ID: 13485
> 
> Since the PPE on cell is an in-order core, it suffers significantly
> from wrong instruction scheduling.  This adds a Kconfig option that
> enables passing -mtune=cell to gcc in order to generate object
> code that runs well on cell.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 6015a92..87aff53 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -92,6 +92,10 @@ else
>  endif
>  endif
> 
> +ifeq ($(CONFIG_TUNE_CELL),y)
> +	CFLAGS += $(call cc-option,-mtune=cell)
> +endif
> +
>  # No AltiVec instruction when building kernel
>  CFLAGS += $(call cc-option,-mno-altivec)
> 
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 86eb4cf..4c315be 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -71,6 +71,18 @@ config POWER4
>  	depends on PPC64
>  	def_bool y
> 
> +config TUNE_CELL
> +	bool "Optimize for Cell Broadband Engine"
> +	depends on PPC64
> +	help
> +	  Cause the compiler to optimize for the PPE of the Cell Broadband
> +	  Engine. This will make the code run considerably faster on Cell
> +	  but somewhat slower on other machines. This option only changes
> +	  the scheduling of instructions, not the selection of instructions
> +	  itself, so the resulting kernel will keep running on all other
> +	  machines. When building a kernel that is supposed to run only
> +	  on Cell, you should also select the POWER4_ONLY option.
> +
>  config 6xx
>  	bool
> 
> 
>>From olof@lixom.net Tue Sep 18 06:12:29 2007
> From: Olof Johansson <olof@lixom.net>
> Subject: [POWERPC] Support setting affinity for U3/U4 MSI sources
> Date: Tue, 18 Sep 2007 06:12:29 +1000
> X-Patchwork-ID: 13547
> 
> Hook up affinity-setting for U3/U4 MSI interrupt sources.
> 
> Tested on Quad G5 with myri10ge.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Michael Ellerman <michael@ellerman.id.au>
> 
> ---
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 8de29f2..22600fd 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -768,7 +768,7 @@ static void mpic_end_ipi(unsigned int irq)
> 
>  #endif /* CONFIG_SMP */
> 
> -static void mpic_set_affinity(unsigned int irq, cpumask_t cpumask)
> +void mpic_set_affinity(unsigned int irq, cpumask_t cpumask)
>  {
>  	struct mpic *mpic = mpic_from_irq(irq);
>  	unsigned int src = mpic_irq_to_hw(irq);
> diff --git a/arch/powerpc/sysdev/mpic.h b/arch/powerpc/sysdev/mpic.h
> index 3a1c3d2..1cb6bd8 100644
> --- a/arch/powerpc/sysdev/mpic.h
> +++ b/arch/powerpc/sysdev/mpic.h
> @@ -34,5 +34,6 @@ extern int mpic_set_irq_type(unsigned int virq, unsigned int flow_type);
>  extern void mpic_end_irq(unsigned int irq);
>  extern void mpic_mask_irq(unsigned int irq);
>  extern void mpic_unmask_irq(unsigned int irq);
> +extern void mpic_set_affinity(unsigned int irq, cpumask_t cpumask);
> 
>  #endif /* _POWERPC_SYSDEV_MPIC_H */
> diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
> index 305b864..0fc4e96 100644
> --- a/arch/powerpc/sysdev/mpic_u3msi.c
> +++ b/arch/powerpc/sysdev/mpic_u3msi.c
> @@ -40,6 +40,7 @@ static struct irq_chip mpic_u3msi_chip = {
>  	.unmask		= mpic_u3msi_unmask_irq,
>  	.eoi		= mpic_end_irq,
>  	.set_type	= mpic_set_irq_type,
> +	.set_affinity	= mpic_set_affinity,
>  	.typename	= "MPIC-U3MSI",
>  };
> 
> 
>>From satyam@infradead.org Tue Sep 18 09:43:40 2007
> From: Satyam Sharma <satyam@infradead.org>
> Subject: Avoid pointless WARN_ON(irqs_disabled()) from panic codepath
> Date: Tue, 18 Sep 2007 09:43:40 +1000
> X-Patchwork-ID: 13552
> 
>> ------------[ cut here ]------------
>> Badness at arch/powerpc/kernel/smp.c:202
> 
> comes when smp_call_function_map() has been called with irqs disabled,
> which is illegal. However, there is a special case, the panic() codepath,
> when we do not want to warn about this -- warning at that time is pointless
> anyway, and only serves to scroll away the *real* cause of the panic and
> distracts from the real bug.
> 
> * So let's extract the WARN_ON() from smp_call_function_map() into all its
>   callers -- smp_call_function() and smp_call_function_single()
> 
> * Also, introduce another caller of smp_call_function_map(), namely
>   __smp_call_function() (and make smp_call_function() a wrapper over this)
>   which does *not* warn about disabled irqs
> 
> * Use this __smp_call_function() from the panic codepath's smp_send_stop()
> 
> We also end having to move code of smp_send_stop() below the definition
> of __smp_call_function().
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
> Untested (not even compile-tested) patch.
> Could someone point me to ppc32/64 cross-compilers for i386?
> 
>  arch/powerpc/kernel/smp.c |   27 ++++++++++++++++++---------
>  1 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> ---
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 1ea4316..b24dcba 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -152,11 +152,6 @@ static void stop_this_cpu(void *dummy)
>  		;
>  }
> 
> -void smp_send_stop(void)
> -{
> -	smp_call_function(stop_this_cpu, NULL, 1, 0);
> -}
> -
>  /*
>   * Structure and data for smp_call_function(). This is designed to minimise
>   * static memory requirements. It also looks cleaner.
> @@ -198,9 +193,6 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
>  	int cpu;
>  	u64 timeout;
> 
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	if (unlikely(smp_ops == NULL))
>  		return ret;
> 
> @@ -270,10 +262,19 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
>  	return ret;
>  }
> 
> +static int __smp_call_function(void (*func)(void *info), void *info,
> +			       int nonatomic, int wait)
> +{
> +	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
> +}
> +
>  int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
>  			int wait)
>  {
> -	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
> +	return __smp_call_function(func, info, nonatomic, wait);
>  }
>  EXPORT_SYMBOL(smp_call_function);
> 
> @@ -283,6 +284,9 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
>  	cpumask_t map = CPU_MASK_NONE;
>  	int ret = 0;
> 
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
>  	if (!cpu_online(cpu))
>  		return -EINVAL;
> 
> @@ -299,6 +303,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
>  }
>  EXPORT_SYMBOL(smp_call_function_single);
> 
> +void smp_send_stop(void)
> +{
> +	__smp_call_function(stop_this_cpu, NULL, 1, 0);
> +}
> +
>  void smp_call_function_interrupt(void)
>  {
>  	void (*func) (void *info);
> 
>>From benh@kernel.crashing.org Wed Sep 19 14:50:22 2007
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Subject: Fix platinumfb framebuffer
> Date: Wed, 19 Sep 2007 14:50:22 +1000
> X-Patchwork-ID: 13599
> 
> Current kernels have a non-working platinumfb due to some resource
> management issues.  This fixes it.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Note: platinumfb is a powermac only driver
> 
> 
> ---
> Index: linux-work/drivers/video/platinumfb.c
> ===================================================================
> --- linux-work.orig/drivers/video/platinumfb.c	2007-09-19 14:21:42.000000000 +1000
> +++ linux-work/drivers/video/platinumfb.c	2007-09-19 14:47:11.000000000 +1000
> @@ -17,6 +17,8 @@
>   *  more details.
>   */
> 
> +#undef DEBUG
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> @@ -535,33 +537,35 @@ static int __devinit platinumfb_probe(st
>  	volatile __u8		*fbuffer;
>  	int			bank0, bank1, bank2, bank3, rc;
> 
> -	printk(KERN_INFO "platinumfb: Found Apple Platinum video hardware\n");
> +	dev_info(&odev->dev, "Found Apple Platinum video hardware\n");
> 
>  	info = framebuffer_alloc(sizeof(*pinfo), &odev->dev);
> -	if (info == NULL)
> +	if (info == NULL) {
> +		dev_err(&odev->dev, "Failed to allocate fbdev !\n");
>  		return -ENOMEM;
> +	}
>  	pinfo = info->par;
> 
>  	if (of_address_to_resource(dp, 0, &pinfo->rsrc_reg) ||
>  	    of_address_to_resource(dp, 1, &pinfo->rsrc_fb)) {
> -		printk(KERN_ERR "platinumfb: Can't get resources\n");
> -		framebuffer_release(info);
> -		return -ENXIO;
> -	}
> -	if (!request_mem_region(pinfo->rsrc_reg.start,
> -				pinfo->rsrc_reg.start -
> -				pinfo->rsrc_reg.end + 1,
> -				"platinumfb registers")) {
> +		dev_err(&odev->dev, "Can't get resources\n");
>  		framebuffer_release(info);
>  		return -ENXIO;
>  	}
> +	dev_dbg(&odev->dev, " registers  : 0x%llx...0x%llx\n",
> +		(unsigned long long)pinfo->rsrc_reg.start,
> +		(unsigned long long)pinfo->rsrc_reg.end);
> +	dev_dbg(&odev->dev, " framebuffer: 0x%llx...0x%llx\n",
> +		(unsigned long long)pinfo->rsrc_fb.start,
> +		(unsigned long long)pinfo->rsrc_fb.end);
> +
> +	/* Do not try to request register space, they overlap with the
> +	 * northbridge and that can fail. Only request framebuffer
> +	 */
>  	if (!request_mem_region(pinfo->rsrc_fb.start,
> -				pinfo->rsrc_fb.start
> -				- pinfo->rsrc_fb.end + 1,
> +				pinfo->rsrc_fb.end - pinfo->rsrc_fb.start + 1,
>  				"platinumfb framebuffer")) {
> -		release_mem_region(pinfo->rsrc_reg.start,
> -				   pinfo->rsrc_reg.end -
> -				   pinfo->rsrc_reg.start + 1);
> +		printk(KERN_ERR "platinumfb: Can't request framebuffer !\n");
>  		framebuffer_release(info);
>  		return -ENXIO;
>  	}
> @@ -600,7 +604,8 @@ static int __devinit platinumfb_probe(st
>  	bank2 = fbuffer[0x200000] == 0x56;
>  	bank3 = fbuffer[0x300000] == 0x78;
>  	pinfo->total_vram = (bank0 + bank1 + bank2 + bank3) * 0x100000;
> -	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n", (int) (pinfo->total_vram / 1024 / 1024),
> +	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n",
> +	       (unsigned int) (pinfo->total_vram / 1024 / 1024),
>  	       bank3, bank2, bank1, bank0);
> 
>  	/*
> @@ -644,16 +649,15 @@ static int __devexit platinumfb_remove(s
>          unregister_framebuffer (info);
>  	
>  	/* Unmap frame buffer and registers */
> +	iounmap(pinfo->frame_buffer);
> +	iounmap(pinfo->platinum_regs);
> +	iounmap(pinfo->cmap_regs);
> +
>  	release_mem_region(pinfo->rsrc_fb.start,
>  			   pinfo->rsrc_fb.end -
>  			   pinfo->rsrc_fb.start + 1);
> -	release_mem_region(pinfo->rsrc_reg.start,
> -			   pinfo->rsrc_reg.end -
> -			   pinfo->rsrc_reg.start + 1);
> -	iounmap(pinfo->frame_buffer);
> -	iounmap(pinfo->platinum_regs);
> +
>  	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
> -	iounmap(pinfo->cmap_regs);
> 
>  	framebuffer_release(info);
> 
> 
>>From Emilian.Medve@Freescale.com Thu Sep 20 12:25:17 2007
> From: Emil Medve <Emilian.Medve@Freescale.com>
> Subject: [PATCH v3] [POWERPC] Fix build errors when BLOCK=n
> Date: Thu, 20 Sep 2007 12:25:17 +1000
> X-Patchwork-ID: 13617
> 
> These are the symptom error messages:
> 
>   CC      arch/powerpc/kernel/setup_32.o
> In file included from include/linux/blkdev.h:17,
>                  from include/linux/ide.h:13,
>                  from arch/powerpc/kernel/setup_32.c:13:
> include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
> include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list
> In file included from arch/powerpc/kernel/setup_32.c:13:
> include/linux/ide.h:857: error: field 'wrq' has incomplete type
> 
>   CC      arch/powerpc/kernel/ppc_ksyms.o
> In file included from include/linux/blkdev.h:17,
>                  from include/linux/ide.h:13,
>                  from arch/powerpc/kernel/ppc_ksyms.c:15:
> include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
> include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list
> In file included from arch/powerpc/kernel/ppc_ksyms.c:15:
> include/linux/ide.h:857: error: field 'wrq' has incomplete type
> 
> The fix tries to use the smallest scope CONFIG_* symbols that will fix
> the build problem.  In this case <linux/ide.h> needs to be included
> only if IDE=y or IDE=m were selected.  Also, ppc_ide_md is needed only
> if BLK_DEV_IDE=y or BLK_DEV_IDE=m
> 
> Moved the EXPORT_SYMBOL(ppc_ide_md) from ppc_ksysms.c next to its
> declaration in setup_32.c which made <linux/ide.h> not needed. With
> <linux/ide.h> gone from ppc_ksyms.c, <asm/cacheflush.h> is needed to
> address the following warnings and errors:
> 
>   CC      arch/powerpc/kernel/ppc_ksyms.o
> arch/powerpc/kernel/ppc_ksyms.c:122: error: '__flush_icache_range' undeclared here (not in a function)
> arch/powerpc/kernel/ppc_ksyms.c:122: warning: type defaults to 'int' in declaration of '__flush_icache_range'
> arch/powerpc/kernel/ppc_ksyms.c:123: error: 'flush_dcache_range' undeclared here (not in a function)
> arch/powerpc/kernel/ppc_ksyms.c:123: warning: type defaults to 'int' in declaration of 'flush_dcache_range'
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> ---
> 
> I tested that the code builds with this patch in various combinations of
> configuration options: all the combinations involving BLOCK, IDE and BLK_DEV_IDE
> 
> A patch for the warnings above has been already commited here: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=49892223f7d3a2333ef9e6cbdd526676e1fc517a
> 
> This patch is against Paul's tree (75cdff9242c4e048cb830d359920719d29b9ee7c)
> 
> powerpc> scripts/checkpatch.pl 0001-POWERPC-Fix-build-errors-when-BLOCK-n.patch
> Your patch has no obvious style problems and is ready for submission.
> 
>  arch/powerpc/kernel/ppc_ksyms.c |    6 +-----
>  arch/powerpc/kernel/setup_32.c  |    5 +++++
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> 
> 
> ---
> diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
> index 430c502..c6b1aa3 100644
> --- a/arch/powerpc/kernel/ppc_ksyms.c
> +++ b/arch/powerpc/kernel/ppc_ksyms.c
> @@ -12,12 +12,12 @@
>  #include <linux/irq.h>
>  #include <linux/pci.h>
>  #include <linux/delay.h>
> -#include <linux/ide.h>
>  #include <linux/bitops.h>
> 
>  #include <asm/page.h>
>  #include <asm/semaphore.h>
>  #include <asm/processor.h>
> +#include <asm/cacheflush.h>
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  #include <asm/atomic.h>
> @@ -95,10 +95,6 @@ EXPORT_SYMBOL(__strnlen_user);
>  EXPORT_SYMBOL(copy_4K_page);
>  #endif
> 
> -#if defined(CONFIG_PPC32) && (defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE))
> -EXPORT_SYMBOL(ppc_ide_md);
> -#endif
> -
>  #if defined(CONFIG_PCI) && defined(CONFIG_PPC32)
>  EXPORT_SYMBOL(isa_io_base);
>  EXPORT_SYMBOL(isa_mem_base);
> diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
> index a288a5f..7474502 100644
> --- a/arch/powerpc/kernel/setup_32.c
> +++ b/arch/powerpc/kernel/setup_32.c
> @@ -10,7 +10,9 @@
>  #include <linux/reboot.h>
>  #include <linux/delay.h>
>  #include <linux/initrd.h>
> +#if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE)
>  #include <linux/ide.h>
> +#endif
>  #include <linux/tty.h>
>  #include <linux/bootmem.h>
>  #include <linux/seq_file.h>
> @@ -49,7 +51,10 @@
> 
>  extern void bootx_init(unsigned long r4, unsigned long phys);
> 
> +#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
>  struct ide_machdep_calls ppc_ide_md;
> +EXPORT_SYMBOL(ppc_ide_md);
> +#endif
> 
>  int boot_cpuid;
>  EXPORT_SYMBOL_GPL(boot_cpuid);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
