From: Sumant Patro <sumantp@lsil.com>
Subject: Re: [PATCH] megaraid_sas: fix physical disk handling
Date: Fri, 17 Feb 2006 19:02:43 -0800
Message-ID: <1140231763.4203.0.camel@dhcp80-31.lsil.com>
References: <20060206140519.GA2515@lst.de>  <20060217111348.GB28379@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60110 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750715AbWBRC7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 21:59:38 -0500
In-Reply-To: <20060217111348.GB28379@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sreenivas.Bagalkote@lsil.com, Sumant.Patro@lsil.com, Chandra_Nelogal@Dell.com, linux-scsi@vger.kernel.org

On Fri, 2006-02-17 at 12:13 +0100, Christoph Hellwig wrote:
> On Mon, Feb 06, 2006 at 03:05:19PM +0100, Christoph Hellwig wrote:
> > Chandra_Nelogal noticed that megaraid_sas currently exports all physical
> > disks normally to the disk layer, which is obviously quite bad.
> > 
> > The problems is that megaraid_sas is doing inquiry sniffing, and since
> > 2.6.15 inquiry commands are sent down as one-element scatterlists on
> > which the code in the driver doesn't work anymore.  The right place to
> > keep the scsi midlayer from attaching to a device is the slave_alloc
> > method in the host template.  To completely prevent attaching the method
> > needs to return -ENXIO, but the patch below sets the no_uld_attach flag
> > instead which prevents upper level drivers from attaching while still
> > allowing scsi generic access to it, as in other raid HBA drivers.
> 
> I got feedback from LSI that they're very unhappy to allow generic
> access to the physical devices at this point because they haven't
> audited the firmware yet about what could happen if someone actually
> accesses the physical devices.
> 
> This patch hides the devices completely from the midlayer instead.
> It requires the patch to handle the slave_configure failure I posted
> earlier.
> 



Thank you.

--Sumant


> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-14 16:23:29.000000000 +0100
> +++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-14 20:38:06.000000000 +0100
> @@ -707,6 +707,20 @@
>  	return 0;
>  }
>  
> +static int megasas_slave_configure(struct scsi_device *sdev)
> +{
> +	/*
> +	 * Don't export physical disk devices to the disk driver.
> +	 *
> +	 * FIXME: Currently we don't export them to the midlayer at all.
> +	 * 	  That will be fixed once LSI engineers have audited the
> +	 * 	  firmware for possible issues.
> +	 */
> +	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
> +		return -ENXIO;
> +	return 0;
> +}
> +
>  /**
>   * megasas_wait_for_outstanding -	Wait for all outstanding cmds
>   * @instance:				Adapter soft state
> @@ -857,6 +871,7 @@
>  	.module = THIS_MODULE,
>  	.name = "LSI Logic SAS based MegaRAID driver",
>  	.proc_name = "megaraid_sas",
> +	.slave_configure = megasas_slave_configure,
>  	.queuecommand = megasas_queue_command,
>  	.eh_device_reset_handler = megasas_reset_device,
>  	.eh_bus_reset_handler = megasas_reset_bus_host,
> @@ -985,20 +1000,6 @@
>  			break;
>  		}
>  
> -		/*
> -		 * Don't export physical disk devices to mid-layer.
> -		 */
> -		if (!MEGASAS_IS_LOGICAL(cmd->scmd) &&
> -		    (hdr->cmd_status == MFI_STAT_OK) &&
> -		    (cmd->scmd->cmnd[0] == INQUIRY)) {
> -
> -			if (((*(u8 *) cmd->scmd->request_buffer) & 0x1F) ==
> -			    TYPE_DISK) {
> -				cmd->scmd->result = DID_BAD_TARGET << 16;
> -				exception = 1;
> -			}
> -		}
> -
>  	case MFI_CMD_LD_READ:
>  	case MFI_CMD_LD_WRITE:
>  

