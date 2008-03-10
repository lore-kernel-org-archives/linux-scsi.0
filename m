From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] Fusion MPT: convert inactive_list_mutex in a mutex
Date: Mon, 10 Mar 2008 09:25:08 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70D82310@NAMAIL4.ad.lsil.com>
References: <20080309111627.GI2783@traven>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39829 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYCJP0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 11:26:03 -0400
Content-class: urn:content-classes:message
In-reply-to: <20080309111627.GI2783@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Kaehlcke <matthias@kaehlcke.net>, linux-scsi@vger.kernel.org
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Sunday, March 09, 2008 5:16 AM, Matthias Kaehlcke wrote:  
> diff --git a/drivers/message/fusion/mptbase.c 
> b/drivers/message/fusion/mptbase.c
> index 0c303c8..06557f2 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2136,7 +2136,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, 
> u32 reason, int sleepFlag)
>  		/*
>  		 * Initalize link list for inactive raid volumes.
>  		 */
> -		init_MUTEX(&ioc->raid_data.inactive_list_mutex);
> +		mutex_init(&ioc->raid_data.inactive_list_mutex);
>  		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
>  
>  		if (ioc->bus_type == SAS) {
> @@ -5122,13 +5122,13 @@ mpt_inactive_raid_list_free(MPT_ADAPTER *ioc)
>  	if (list_empty(&ioc->raid_data.inactive_list))
>  		return;
>  
> -	down(&ioc->raid_data.inactive_list_mutex);
> +	mutex_lock(&ioc->raid_data.inactive_list_mutex);
>  	list_for_each_entry_safe(component_info, pNext,
>  	    &ioc->raid_data.inactive_list, list) {
>  		list_del(&component_info->list);
>  		kfree(component_info);
>  	}
> -	up(&ioc->raid_data.inactive_list_mutex);
> +	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
>  }
>  
>  /**
> @@ -5187,7 +5187,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER 
> *ioc, u8 channel, u8 id)
>  	if (!handle_inactive_volumes)
>  		goto out;
>  
> -	down(&ioc->raid_data.inactive_list_mutex);
> +	mutex_lock(&ioc->raid_data.inactive_list_mutex);
>  	for (i = 0; i < buffer->NumPhysDisks; i++) {
>  		if(mpt_raid_phys_disk_pg0(ioc,
>  		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
> @@ -5207,7 +5207,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER 
> *ioc, u8 channel, u8 id)
>  		list_add_tail(&component_info->list,
>  		    &ioc->raid_data.inactive_list);
>  	}
> -	up(&ioc->raid_data.inactive_list_mutex);
> +	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
>  
>   out:
>  	if (buffer)
> diff --git a/drivers/message/fusion/mptbase.h 
> b/drivers/message/fusion/mptbase.h
> index caadc68..88e7a15 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -51,6 +51,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
> +#include <linux/mutex.h>
>  
>  #include "lsi/mpi_type.h"
>  #include "lsi/mpi.h"		/* Fusion MPI(nterface) basic defs */
> @@ -531,7 +532,7 @@ struct inactive_raid_component_info {
>  typedef	struct _RaidCfgData {
>  	IOCPage2_t	*pIocPg2;		/* table of 
> Raid Volumes */
>  	IOCPage3_t	*pIocPg3;		/* table of 
> physical disks */
> -	struct semaphore	inactive_list_mutex;
> +	struct mutex	inactive_list_mutex;
>  	struct list_head	inactive_list; /* link list for physical
>  						disk that belong in
>  						inactive volumes */
> diff --git a/drivers/message/fusion/mptscsih.c 
> b/drivers/message/fusion/mptscsih.c
> index af1de0c..4e70ef4 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2295,14 +2295,14 @@ mptscsih_is_phys_disk(MPT_ADAPTER 
> *ioc, u8 channel, u8 id)
>  	if (list_empty(&ioc->raid_data.inactive_list))
>  		goto out;
>  
> -	down(&ioc->raid_data.inactive_list_mutex);
> +	mutex_lock(&ioc->raid_data.inactive_list_mutex);
>  	list_for_each_entry(component_info, 
> &ioc->raid_data.inactive_list,
>  	    list) {
>  		if ((component_info->d.PhysDiskID == id) &&
>  		    (component_info->d.PhysDiskBus == channel))
>  			rc = 1;
>  	}
> -	up(&ioc->raid_data.inactive_list_mutex);
> +	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
>  
>   out:
>  	return rc;
> @@ -2332,14 +2332,14 @@ mptscsih_raid_id_to_num(MPT_ADAPTER 
> *ioc, u8 channel, u8 id)
>  	if (list_empty(&ioc->raid_data.inactive_list))
>  		goto out;
>  
> -	down(&ioc->raid_data.inactive_list_mutex);
> +	mutex_lock(&ioc->raid_data.inactive_list_mutex);
>  	list_for_each_entry(component_info, 
> &ioc->raid_data.inactive_list,
>  	    list) {
>  		if ((component_info->d.PhysDiskID == id) &&
>  		    (component_info->d.PhysDiskBus == channel))
>  			rc = component_info->d.PhysDiskNum;
>  	}
> -	up(&ioc->raid_data.inactive_list_mutex);
> +	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
>  
>   out:
>  	return rc;
>  

This is good, ACK
