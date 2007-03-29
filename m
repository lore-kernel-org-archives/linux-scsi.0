From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] ibmvscsi: add slave_configure to allow device
 restart
Date: Thu, 29 Mar 2007 09:42:35 -0700
Message-ID: <20070329094235.df5f29fa.randy.dunlap@oracle.com>
References: <20070328173828.GA22676@austin.ibm.com>
	<20070328174704.GC22676@austin.ibm.com>
	<20070328105410.8c66a8d8.randy.dunlap@oracle.com>
	<20070329162836.GB16619@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:58884 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449AbXC2Ql5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 12:41:57 -0400
In-Reply-To: <20070329162836.GB16619@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, 29 Mar 2007 11:28:36 -0500 Robert Jennings wrote:

> Fixed the kernel-doc comment for ibmvscsi_slave_configure.  Thanks to
> Randy Dunlap for catching that.

Sorry, there's still a minor nit below.

> Adding a slave_configure function for the driver. Now the disks can be
> restarted by the scsi mid-layer when the are disconnected and reconnected.
> 
> Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>
> Signed-off-by: "Santiago Leon" <santil@us.ibm.com>
> 
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
> ===================================================================
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1354,6 +1354,28 @@
>  	return rc;
>  }
>  
> +/**
> + * ibmvscsi_slave_configure: Set the "allow_restart" flag for each disk.
> + *

No "blank" ("*") line between the function name and its parameters...
it mucks up the generated output.

> + * @sdev:	struct scsi_device device to configure
> + *
> + * Enable allow_restart for a device if it is a disk.  Adjust the
> + * queue_depth here also as is required by the documentation for
> + * struct scsi_host_template.
> + */
> +static int ibmvscsi_slave_configure(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	unsigned long lock_flags = 0;
> +
> +	spin_lock_irqsave(shost->host_lock, lock_flags);
> +	if (sdev->type == TYPE_DISK)
> +		sdev->allow_restart = 1;
> +	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
> +	spin_unlock_irqrestore(shost->host_lock, lock_flags);
> +	return 0;
> +}
> +
>  /* ------------------------------------------------------------
>   * sysfs attributes
>   */
> @@ -1499,6 +1521,7 @@
>  	.queuecommand = ibmvscsi_queuecommand,
>  	.eh_abort_handler = ibmvscsi_eh_abort_handler,
>  	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
> +	.slave_configure = ibmvscsi_slave_configure,
>  	.cmd_per_lun = 16,
>  	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
>  	.this_id = -1,


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
