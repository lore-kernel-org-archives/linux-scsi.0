From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 15:32:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024153240.A18890@eng2.beaverton.ibm.com>
References: <3DB7436E.9060100@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DB7436E.9060100@mvista.com>; from sdake@mvista.com on Wed, Oct 23, 2002 at 05:48:46PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2002 at 05:48:46PM -0700, Steven Dake wrote:
> linux-scsi,
> 
> 

> diff -uNr linux-2.5.44-qla/drivers/scsi/scsi_error.c linux-2.5.44-scsi-hotswap/drivers/scsi/scsi_error.c
> --- linux-2.5.44-qla/drivers/scsi/scsi_error.c	Fri Oct 18 21:01:07 2002
> +++ linux-2.5.44-scsi-hotswap/drivers/scsi/scsi_error.c	Wed Oct 23 11:48:20 2002

> @@ -962,6 +970,8 @@
>  
>  	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Trying BDR\n", __FUNCTION__));
>  
> +	spin_lock (&shost->host_queue_lock);
> +
>  	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
>  		for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
>  			if ((scmd->device == sdev) &&
> @@ -985,6 +995,7 @@
>  							scsi_eh_finish_cmd(scmd, shost);
>  					}
>  	}
> +	spin_unlock (&shost->host_queue_lock);
>  
>  	return shost->host_failed;
>  }

The bus device reset functions are allowed sleep, so you cannot hold a lock
while calling them.

-- Patrick Mansfield
