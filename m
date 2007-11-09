From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvscsi: requeue while CRQ closed
Date: Fri, 09 Nov 2007 11:35:36 -0600
Message-ID: <47349A68.4020001@linux.vnet.ibm.com>
References: <20071109151600.GA16255@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41803 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbXKIRga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 12:36:30 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA9HaQYM027650
	for <linux-scsi@vger.kernel.org>; Fri, 9 Nov 2007 12:36:26 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA9HaQl3127424
	for <linux-scsi@vger.kernel.org>; Fri, 9 Nov 2007 12:36:26 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA9HaPO0007974
	for <linux-scsi@vger.kernel.org>; Fri, 9 Nov 2007 12:36:26 -0500
In-Reply-To: <20071109151600.GA16255@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: James.Bottomley@steeleye.com, santil@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

James,

Hold off on pulling this in. The patch is currently being reworked to
fix a problem.

Thanks,

-Brian

Robert Jennings wrote:
> CRQ send errors that return with H_CLOSED should return with
> SCSI_MLQUEUE_HOST_BUSY until firmware alerts the client of a CRQ
> transport event.  The transport event will either reinitialize and
> requeue the requests, or fail and return IO with DID_ERROR.
> 
> To avoid failing the eh_* functions while re-attaching to the server
> adapter this will retry for a period of time while ibmvscsi_send_srp_event
> returns SCSI_MLQUEUE_HOST_BUSY.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> 
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c |   59 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 48 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-11-09 08:53:02.000000000 -0600
> +++ linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-11-09 08:53:36.000000000 -0600
> @@ -629,6 +629,16 @@
>  		list_del(&evt_struct->list);
>  		del_timer(&evt_struct->timer);
> 
> +		/* If send_crq returns H_CLOSED, return SCSI_MLQUEUE_HOST_BUSY.
> +		 * Firmware will send a CRQ with a transport event (0xFF) to
> +		 * tell this client what has happened to the transport.  This
> +		 * will be handled in ibmvscsi_handle_crq()
> +		 */
> +		if (rc == H_CLOSED) {
> +			dev_warn(hostdata->dev, "send warning. "
> +			         "Receive queue closed, will retry.\n");
> +			goto send_busy;
> +		}
>  		dev_err(hostdata->dev, "send error %d\n", rc);
>  		atomic_inc(&hostdata->request_limit);
>  		goto send_error;
> @@ -976,6 +986,7 @@
>  	int rsp_rc;
>  	unsigned long flags;
>  	u16 lun = lun_from_dev(cmd->device);
> +	unsigned long wait_switch = 0;
> 
>  	/* First, find this command in our sent list so we can figure
>  	 * out the correct tag
> @@ -1019,15 +1030,30 @@
>  		    tsk_mgmt->lun, tsk_mgmt->task_tag);
> 
>  	evt->sync_srp = &srp_rsp;
> -	init_completion(&evt->comp);
> -	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
> -	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> +
> +	wait_switch = jiffies + (init_timeout * HZ);
> +	do {
> +		init_completion(&evt->comp);
> +		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
> +
> +		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
> +			break;
> +
> +		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> +		msleep(10);
> +		spin_lock_irqsave(hostdata->host->host_lock, flags);
> +	} while (time_before(jiffies, wait_switch));
> +
>  	if (rsp_rc != 0) {
> +		free_event_struct(&found_evt->hostdata->pool, found_evt);
> +		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>  		sdev_printk(KERN_ERR, cmd->device,
>  			    "failed to send abort() event. rc=%d\n", rsp_rc);
>  		return FAILED;
>  	}
> 
> +	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> +
>  	wait_for_completion(&evt->comp);
> 
>  	/* make sure we got a good response */
> @@ -1099,6 +1125,7 @@
>  	int rsp_rc;
>  	unsigned long flags;
>  	u16 lun = lun_from_dev(cmd->device);
> +	unsigned long wait_switch = 0;
> 
>  	spin_lock_irqsave(hostdata->host->host_lock, flags);
>  	evt = get_event_struct(&hostdata->pool);
> @@ -1125,9 +1152,20 @@
>  		    tsk_mgmt->lun);
> 
>  	evt->sync_srp = &srp_rsp;
> -	init_completion(&evt->comp);
> -	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
> -	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> +
> +	wait_switch = jiffies + (init_timeout * HZ);
> +	do {
> +		init_completion(&evt->comp);
> +		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
> +		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> +
> +		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
> +			break;
> +
> +		msleep(10);
> +		spin_lock_irqsave(hostdata->host->host_lock, flags);
> +	} while (time_before(jiffies, wait_switch));
> +
>  	if (rsp_rc != 0) {
>  		sdev_printk(KERN_ERR, cmd->device,
>  			    "failed to send reset event. rc=%d\n", rsp_rc);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
