From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 05/11] mpt3sas: combine fw_event_work and its
 event_data
Date: Tue, 1 Jul 2014 20:40:19 +0200
Message-ID: <20140701184019.GB6182@infradead.org>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
 <1403730334-20132-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbaGASiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 14:38:03 -0400
Content-Disposition: inline
In-Reply-To: <1403730334-20132-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Sreekanth, can you give me a review for this patch?  Thanks!

On Wed, Jun 25, 2014 at 05:05:34PM -0400, Joe Lawrence wrote:
> Tack the firmware reply event_data payload to the end of its
> corresponding struct fw_event_work allocation.  This matches the
> convention in the mptfusion driver and simplifies the code.
> 
> This avoids the following smatch warning:
> 
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c:2519
>     mpt3sas_send_trigger_data_event() warn: possible memory leak of
>     'fw_event'
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   56 +++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index f3ee3b4..a14be8f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -190,7 +190,7 @@ struct fw_event_work {
>  	u8			VP_ID;
>  	u8			ignore;
>  	u16			event;
> -	void			*event_data;
> +	char			event_data[0] __aligned(4);
>  };
>  
>  /* raid transport support */
> @@ -2492,7 +2492,6 @@ _scsih_fw_event_free(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
>  
>  	spin_lock_irqsave(&ioc->fw_event_lock, flags);
>  	list_del(&fw_event->list);
> -	kfree(fw_event->event_data);
>  	kfree(fw_event);
>  	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
>  }
> @@ -2513,12 +2512,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
>  
>  	if (ioc->is_driver_loading)
>  		return;
> -	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
> +	fw_event = kzalloc(sizeof(*fw_event) + sizeof(*event_data),
> +			   GFP_ATOMIC);
>  	if (!fw_event)
>  		return;
> -	fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
> -	if (!fw_event->event_data)
> -		return;
>  	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
>  	fw_event->ioc = ioc;
>  	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
> @@ -3213,7 +3210,8 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
>  		if (fw_event->event != MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST ||
>  		    fw_event->ignore)
>  			continue;
> -		local_event_data = fw_event->event_data;
> +		local_event_data = (Mpi2EventDataSasTopologyChangeList_t *)
> +				   fw_event->event_data;
>  		if (local_event_data->ExpStatus ==
>  		    MPI2_EVENT_SAS_TOPO_ES_ADDED ||
>  		    local_event_data->ExpStatus ==
> @@ -5045,7 +5043,9 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
>  	u64 sas_address;
>  	unsigned long flags;
>  	u8 link_rate, prev_link_rate;
> -	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
> +	Mpi2EventDataSasTopologyChangeList_t *event_data =
> +		(Mpi2EventDataSasTopologyChangeList_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -5243,7 +5243,8 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
>  	u64 sas_address;
>  	unsigned long flags;
>  	Mpi2EventDataSasDeviceStatusChange_t *event_data =
> -	    fw_event->event_data;
> +		(Mpi2EventDataSasDeviceStatusChange_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -5339,6 +5340,7 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
>  		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
> +		     (Mpi2EventDataSasEnclDevStatusChange_t *)
>  		     fw_event->event_data);
>  #endif
>  }
> @@ -5363,7 +5365,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
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
> @@ -5515,7 +5519,8 @@ static void
>  _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
>  	struct fw_event_work *fw_event)
>  {
> -	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
> +	Mpi2EventDataSasDiscovery_t *event_data =
> +		(Mpi2EventDataSasDiscovery_t *) fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
> @@ -6001,7 +6006,9 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
>  	Mpi2EventIrConfigElement_t *element;
>  	int i;
>  	u8 foreign_config;
> -	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrConfigChangeList_t *event_data =
> +		(Mpi2EventDataIrConfigChangeList_t *)
> +		fw_event->event_data;
>  
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
>  	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> @@ -6071,7 +6078,8 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
>  	u16 handle;
>  	u32 state;
>  	int rc;
> -	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrVolume_t *event_data =
> +		(Mpi2EventDataIrVolume_t *) fw_event->event_data;
>  
>  	if (ioc->shost_recovery)
>  		return;
> @@ -6154,7 +6162,8 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
>  	Mpi2ConfigReply_t mpi_reply;
>  	Mpi2SasDevicePage0_t sas_device_pg0;
>  	u32 ioc_status;
> -	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrPhysicalDisk_t *event_data =
> +		(Mpi2EventDataIrPhysicalDisk_t *) fw_event->event_data;
>  	u64 sas_address;
>  
>  	if (ioc->shost_recovery)
> @@ -6274,7 +6283,9 @@ static void
>  _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
>  	struct fw_event_work *fw_event)
>  {
> -	Mpi2EventDataIrOperationStatus_t *event_data = fw_event->event_data;
> +	Mpi2EventDataIrOperationStatus_t *event_data =
> +		(Mpi2EventDataIrOperationStatus_t *)
> +		fw_event->event_data;
>  	static struct _raid_device *raid_device;
>  	unsigned long flags;
>  	u16 handle;
> @@ -7036,7 +7047,9 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
>  
>  	switch (fw_event->event) {
>  	case MPT3SAS_PROCESS_TRIGGER_DIAG:
> -		mpt3sas_process_trigger_data(ioc, fw_event->event_data);
> +		mpt3sas_process_trigger_data(ioc,
> +			(struct SL_WH_TRIGGERS_EVENT_DATA_T *)
> +			fw_event->event_data);
>  		break;
>  	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
>  		while (scsi_host_in_recovery(ioc->shost) || ioc->shost_recovery)
> @@ -7194,18 +7207,11 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
>  		return 1;
>  	}
>  
> -	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
> -	if (!fw_event) {
> -		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -		    ioc->name, __FILE__, __LINE__, __func__);
> -		return 1;
> -	}
>  	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
> -	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
> -	if (!fw_event->event_data) {
> +	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
> +	if (!fw_event) {
>  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
>  		    ioc->name, __FILE__, __LINE__, __func__);
> -		kfree(fw_event);
>  		return 1;
>  	}
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
