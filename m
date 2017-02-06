From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 21/39] megaraid_sas: avoid unaligned access in ioctl path
Date: Mon, 6 Feb 2017 12:22:34 +0100
Message-ID: <1b63ba30-b52e-f054-02ce-9b2576c10cab@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:43086 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBFLWh (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:22:37 -0500
In-Reply-To: <1486375212-17329-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Fix kernel warning for accessing unaligned memory access in driver.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index c38b9c3..907b2bf 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -43,6 +43,7 @@
>  #include <linux/uio.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <asm/unaligned.h>
>  #include <linux/fs.h>
>  #include <linux/compat.h>
>  #include <linux/blkdev.h>
> @@ -7002,7 +7003,8 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  		sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
>  				ioc->sense_off);
>  
> -		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
> +		if (copy_to_user((void __user *)((unsigned long)
> +				 get_unaligned((unsigned long *)sense_ptr)),
>  				 sense, ioc->sense_len)) {
>  			dev_err(&instance->pdev->dev, "Failed to copy out to user "
>  					"sense data\n");
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
