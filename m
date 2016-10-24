From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v3 5/6] scsi: replace custom approach to hexdump small
 buffers
Date: Mon, 24 Oct 2016 08:35:38 -0400
Message-ID: <1477312538.17595.4.camel@localhost.localdomain>
References: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
         <20161022173231.170417-6-andriy.shevchenko@linux.intel.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932934AbcJXMfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 08:35:41 -0400
In-Reply-To: <20161022173231.170417-6-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Jon Mason <jonmason@broadcom.com>

On Sat, 2016-10-22 at 20:32 +0300, Andy Shevchenko wrote:
> In kernel we have defined specifier (%*ph[C]) to dump small buffers in a hex
> format. Replace custom approach by a generic one.
> 
> Cc: Jon Mason <jonmason@broadcom.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/scsi/scsi_transport_srp.c | 11 +----------
>  drivers/scsi/sd.c                 |  4 +---
>  2 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index e3cd3ec..02cfc6b 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -115,21 +115,12 @@ static DECLARE_TRANSPORT_CLASS(srp_host_class, "srp_host", srp_host_setup,
>  static DECLARE_TRANSPORT_CLASS(srp_rport_class, "srp_remote_ports",
>  			       NULL, NULL, NULL);
>  
> -#define SRP_PID(p) \
> -	(p)->port_id[0], (p)->port_id[1], (p)->port_id[2], (p)->port_id[3], \
> -	(p)->port_id[4], (p)->port_id[5], (p)->port_id[6], (p)->port_id[7], \
> -	(p)->port_id[8], (p)->port_id[9], (p)->port_id[10], (p)->port_id[11], \
> -	(p)->port_id[12], (p)->port_id[13], (p)->port_id[14], (p)->port_id[15]
> -
> -#define SRP_PID_FMT "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:" \
> -	"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x"
> -
>  static ssize_t
>  show_srp_rport_id(struct device *dev, struct device_attribute *attr,
>  		  char *buf)
>  {
>  	struct srp_rport *rport = transport_class_to_srp_rport(dev);
> -	return sprintf(buf, SRP_PID_FMT "\n", SRP_PID(rport));
> +	return sprintf(buf, "%16phC\n", rport->port_id);
>  }
>  
>  static DEVICE_ATTR(port_id, S_IRUGO, show_srp_rport_id, NULL);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b9618ff..5634b54 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2472,9 +2472,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>  		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
>  			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
>  				  sdkp->write_prot ? "on" : "off");
> -			sd_printk(KERN_DEBUG, sdkp,
> -				  "Mode Sense: %02x %02x %02x %02x\n",
> -				  buffer[0], buffer[1], buffer[2], buffer[3]);
> +			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
>  		}
>  	}
>  }

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



