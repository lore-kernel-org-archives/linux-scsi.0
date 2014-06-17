From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/24] drviers/scsi: check sysfs init return value via
 IS_ERR at iscsi_boot_create_kset
Date: Tue, 17 Jun 2014 12:22:19 -0700
Message-ID: <20140617192219.GC4319@kroah.com>
References: <53A0520A.8050509@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbaFQTSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 15:18:23 -0400
Content-Disposition: inline
In-Reply-To: <53A0520A.8050509@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Liu <jeff.liu@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Tue, Jun 17, 2014 at 10:34:50PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> kset_create_and_add() has been fixed to return the actual error ptr
> than NULL on failure, update iscsi_boot_create_kset() to check the
> return value via IS_ERR() accordingly.
> 
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  drivers/scsi/iscsi_boot_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
> index 680bf6f..821df62 100644
> --- a/drivers/scsi/iscsi_boot_sysfs.c
> +++ b/drivers/scsi/iscsi_boot_sysfs.c
> @@ -443,7 +443,7 @@ struct iscsi_boot_kset *iscsi_boot_create_kset(const char *set_name)
>  		return NULL;
>  
>  	boot_kset->kset = kset_create_and_add(set_name, NULL, firmware_kobj);
> -	if (!boot_kset->kset) {
> +	if (IS_ERR(boot_kset->kset)) {
>  		kfree(boot_kset);
>  		return NULL;
>  	}

James, please do not take this patch.

thanks,

greg k-h
