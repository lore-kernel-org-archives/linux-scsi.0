From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH 1/3] zfcp: IO stall after path checker changes
Date: Tue, 29 May 2007 15:55:27 +0200
Message-ID: <200705291555.27555.swen@vnet.ibm.com>
References: <200705291529.39677.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:37870 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXE2NwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 09:52:18 -0400
In-Reply-To: <200705291529.39677.swen.schillig@freenet.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, mloehr2@linux.vnet.ibm.com

James

I just saw that I posted this patch on 9th already, 
but todays git pull from your tree didn't show the inclusion of this one (and another patch posted the same day).
Event though it's reported in your summary from the 26 !
If I'm to quick then I'm sorry for sending it twice, if there's any other
reason for this patch to not be included please let me know.

Thanks
	Swen
On Tuesday 29 May 2007 15:29, Swen Schillig wrote:
> From: Michael Loehr <mloehr2@linux.vnet.ibm.com>
> 
> Devices corresponding to a deleted unit are never freed.
> This has the effect that slave_destroy is never called and zfcp
> 'thinks' that this unit is still registered.
> This patch changes the zfcp behaviour the way that the
> rport and sdev are not deleted anymore. The host is set to
> block on 'offline'. Host online is only removing the blocked status 
> and everything works as expected again.
> 
> Signed-off-by: Michael Loehr <mloehr2@linux.vnet.ibm.com>
> Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
> 
> ---
> 
>  drivers/s390/scsi/zfcp_aux.c  |    1 +
>  drivers/s390/scsi/zfcp_ccw.c  |    5 +----
>  drivers/s390/scsi/zfcp_scsi.c |    3 +++
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
> ===================================================================
> --- linux_jb_patched.orig/drivers/s390/scsi/zfcp_aux.c
> +++ linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
> @@ -1127,6 +1127,7 @@ zfcp_adapter_dequeue(struct zfcp_adapter
>  	int retval = 0;
>  	unsigned long flags;
>  
> +	zfcp_adapter_scsi_unregister(adapter);
>  	device_unregister(&adapter->generic_services);
>  	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
>  	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
> Index: linux_jb_patched/drivers/s390/scsi/zfcp_ccw.c
> ===================================================================
> --- linux_jb_patched.orig/drivers/s390/scsi/zfcp_ccw.c
> +++ linux_jb_patched/drivers/s390/scsi/zfcp_ccw.c
> @@ -189,9 +189,7 @@ zfcp_ccw_set_online(struct ccw_device *c
>   * @ccw_device: pointer to belonging ccw device
>   *
>   * This function gets called by the common i/o layer and sets an adapter
> - * into state offline. Setting an fcp device offline means that it will be
> - * unregistered from the SCSI stack and that the adapter will be shut down
> - * asynchronously.
> + * into state offline.
>   */
>  static int
>  zfcp_ccw_set_offline(struct ccw_device *ccw_device)
> @@ -202,7 +200,6 @@ zfcp_ccw_set_offline(struct ccw_device *
>  	adapter = dev_get_drvdata(&ccw_device->dev);
>  	zfcp_erp_adapter_shutdown(adapter, 0);
>  	zfcp_erp_wait(adapter);
> -	zfcp_adapter_scsi_unregister(adapter);
>  	zfcp_erp_thread_kill(adapter);
>  	zfcp_adapter_debug_unregister(adapter);
>  	up(&zfcp_data.config_sema);
> Index: linux_jb_patched/drivers/s390/scsi/zfcp_scsi.c
> ===================================================================
> --- linux_jb_patched.orig/drivers/s390/scsi/zfcp_scsi.c
> +++ linux_jb_patched/drivers/s390/scsi/zfcp_scsi.c
> @@ -569,6 +569,9 @@ zfcp_adapter_scsi_register(struct zfcp_a
>  	int retval = 0;
>  	static unsigned int unique_id = 0;
>  
> +	if (adapter->scsi_host)
> +		goto out;
> +
>  	/* register adapter as SCSI host with mid layer of SCSI stack */
>  	adapter->scsi_host = scsi_host_alloc(&zfcp_data.scsi_host_template,
>  					     sizeof (struct zfcp_adapter *));
> 
