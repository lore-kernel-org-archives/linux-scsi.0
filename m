From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/11] mpt2sas: combine fw_event_work and its
 event_data
Date: Tue, 1 Jul 2014 20:39:51 +0200
Message-ID: <20140701183951.GA6182@infradead.org>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
 <1403730213-19994-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56788 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaGAShk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 14:37:40 -0400
Content-Disposition: inline
In-Reply-To: <1403730213-19994-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Christoph Hellwig <hch@infradead.org>

Sreekanth,

can you give me a review for this one?

On Wed, Jun 25, 2014 at 05:03:33PM -0400, Joe Lawrence wrote:
> Tack the firmware reply event_data payload to the end of its
> corresponding struct fw_event_work allocation.  This matches the
> convention in the mptfusion driver and simplifies the code.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   52 ++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 13e49c3..e7801ff 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -173,7 +173,7 @@ struct fw_event_work {
>  	u8			VP_ID;
>  	u8			ignore;
>  	u16			event;
> -	void			*event_data;
> +	char			event_data[0] __aligned(4);
>  };
>  
>  /* raid transport support */
> @@ -2834,7 +2834,6 @@ _scsih_fw_event_free(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
>  
>  	spin_lock_irqsave(&ioc->fw_event_lock, flags);
>  	list_del(&fw_event->list);
> -	kfree(fw_event->event_data);
>  	kfree(fw_event);
>  	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
>  }
> @@ -3520,7 +3519,8 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
>  		if (fw_event->event != MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST ||
>  		    fw_event->ignore)
>  			continue;
> -		local_event_data = fw_event->event_data;
> +		local_event_data = (Mpi2EventDataSasTopologyChangeList_t *)
> +			fw_event->event_data;
>  		if (local_event_data->ExpStatus ==
>  		    MPI2_EVENT_SAS_TOPO_ES_ADDED ||
>  		    local_event_data->ExpStatus ==
> @@ -5504,7 +5504,9 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
>  	u64 sas_address;
>  	unsigned long flags;
>  	u8 link_rate, prev_link_rate;
> -	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
> +	Mpi2EventDataSasTopologyChangeList_t *event_data =
> +		(Mpi2EventDataSasTopologyChangeList_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -5699,7 +5701,8 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
>  	u64 sas_address;
>  	unsigned long flags;
>  	Mpi2EventDataSasDeviceStatusChange_t *event_data =
> -	    fw_event->event_data;
> +		(Mpi2EventDataSasDeviceStatusChange_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -5794,6 +5797,7 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT2SAS_ADAPTER *ioc,
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
>  		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
> +		     (Mpi2EventDataSasEnclDevStatusChange_t *)
>  		     fw_event->event_data);
>  #endif
>  }
> @@ -5818,7 +5822,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
>  	u32 termination_count;
>  	u32 query_count;
>  	Mpi2SCSITaskManagementReply_t *mpi_reply;
> -	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
> +	Mpi2EventDataSasBroadcastPrimitive_t *event_data =
> +		(Mpi2EventDataSasBroadcastPrimitive_t *)
> +		fw_event->event_data;
>  	u16 ioc_status;
>  	unsigned long flags;
>  	int r;
> @@ -5969,7 +5975,9 @@ static void
>  _scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
>      struct fw_event_work *fw_event)
>  {
> -	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
> +	Mpi2EventDataSasDiscovery_t *event_data =
> +		(Mpi2EventDataSasDiscovery_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
> @@ -6357,7 +6365,9 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc,
>  	Mpi2EventIrConfigElement_t *element;
>  	int i;
>  	u8 foreign_config;
> -	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrConfigChangeList_t *event_data =
> +		(Mpi2EventDataIrConfigChangeList_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	if ((ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -6425,7 +6435,9 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc,
>  	u16 handle;
>  	u32 state;
>  	int rc;
> -	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrVolume_t *event_data =
> +		(Mpi2EventDataIrVolume_t *)
> +		fw_event->event_data;
>  
>  	if (ioc->shost_recovery)
>  		return;
> @@ -6509,7 +6521,9 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
>  	Mpi2ConfigReply_t mpi_reply;
>  	Mpi2SasDevicePage0_t sas_device_pg0;
>  	u32 ioc_status;
> -	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrPhysicalDisk_t *event_data =
> +		(Mpi2EventDataIrPhysicalDisk_t *)
> +		fw_event->event_data;
>  	u64 sas_address;
>  
>  	if (ioc->shost_recovery)
> @@ -6632,7 +6646,9 @@ static void
>  _scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc,
>      struct fw_event_work *fw_event)
>  {
> -	Mpi2EventDataIrOperationStatus_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrOperationStatus_t *event_data =
> +		(Mpi2EventDataIrOperationStatus_t *)
> +		fw_event->event_data;
>  	static struct _raid_device *raid_device;
>  	unsigned long flags;
>  	u16 handle;
> @@ -7592,23 +7608,15 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
>  		return;
>  	}
>  
> -	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
> -	if (!fw_event) {
> -		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
> -		    ioc->name, __FILE__, __LINE__, __func__);
> -		return;
> -	}
>  	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
> -	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
> -	if (!fw_event->event_data) {
> +	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
> +	if (!fw_event) {
>  		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
>  		    ioc->name, __FILE__, __LINE__, __func__);
> -		kfree(fw_event);
>  		return;
>  	}
>  
> -	memcpy(fw_event->event_data, mpi_reply->EventData,
> -	    sz);
> +	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
>  	fw_event->ioc = ioc;
>  	fw_event->VF_ID = mpi_reply->VF_ID;
>  	fw_event->VP_ID = mpi_reply->VP_ID;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
