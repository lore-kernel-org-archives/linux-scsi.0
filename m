From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: correct default value for fc_dev_loss_tmo
Date: Thu, 11 May 2006 10:37:22 -0400
Message-ID: <44634C22.80804@emulex.com>
References: <20060511092311.GA8077@lion28.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:1214 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751798AbWEKOhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 10:37:14 -0400
In-Reply-To: <20060511092311.GA8077@lion28.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

NACK.

The real problem is in the define for SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
If you look at every use within the fc transport, including the set
function and when it actually sets the timeout, it expects dev_loss_tmo
to be in units of seconds. Thus, SCSI_DEVICE_BLOCK_MAX_TIMEOUT should have
been the same thing.

I'll update my patch shortly.

-- james s

Andreas Herrmann wrote:
> In current kernels initialization of fc_dev_loss_tmo is wrong.
> See fc_remote_port_delete():
> 
>     int timeout = rport->dev_loss_tmo;
> ...
>     fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
> 
> So actually a timeout of ((HZ*60)*HZ) is used or with James S's recent
> patch we have a timeout of ((HZ*120)*HZ). I think this was not
> intentional, so I suggest the following patch to correct this.
> 
> 
> Regards,
> 
> Andreas
> 
> 
> fc transport: correct default value for fc_dev_loss_tmo
> 
> Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
> 
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 95c5478..a1cb05e 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -368,7 +368,7 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
>   *   should insulate the loss of a remote port.
>   *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
>   */
> -static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
> +static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT / HZ;
>  
>  module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(dev_loss_tmo,
> 
