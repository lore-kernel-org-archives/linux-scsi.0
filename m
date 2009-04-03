From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/6] mpt fusion: Firmware Event implementation using
	seperate WorkQueue
Date: Fri, 03 Apr 2009 13:21:05 -0500
Message-ID: <1238782865.3359.78.camel@mulgrave.int.hansenpartnership.com>
References: <20090403115025.GC17721@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45554 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbZDCSVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 14:21:11 -0400
In-Reply-To: <20090403115025.GC17721@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-04-03 at 17:20 +0530, Kashyap, Desai wrote:
> 1) 	Now Firmware events are handled by firmware event queue.
> 	Previously it was handled in interrupt context/WorkQueue of Linux.
> 	Firmware Event handling is restructured and optimized.
> 2.)	Test Unit Ready will be used by driver to make sure device is
> 	already come up before indicating Device Add to Scsi subsystem.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 3418e83..14a9d4f 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1928,6 +1928,11 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	 */
>  	mpt_detect_bound_ports(ioc, pdev);
>  
> +	INIT_LIST_HEAD(&ioc->fw_event_list);
> +	spin_lock_init(&ioc->fw_event_lock);
> +	snprintf(ioc->fw_event_q_name, 20, "mpt/%d", ioc->id);
> +	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
> +
>  	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
>  	    CAN_SLEEP)) != 0){
>  		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
> @@ -2007,6 +2012,11 @@ mpt_detach(struct pci_dev *pdev)
>  	cancel_delayed_work(&ioc->fault_reset_work);
>  	destroy_workqueue(wq);
>  
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	wq = ioc->fw_event_q;
> +	ioc->fw_event_q = NULL;
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +	destroy_workqueue(wq);
>  
>  	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
>  	remove_proc_entry(pname, NULL);
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 24d6012..a2e948b 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -694,9 +694,19 @@ typedef struct _MPT_ADAPTER
>  	struct net_device	*netdev;
>  	struct list_head	 sas_topology;
>  	struct mutex		 sas_topology_mutex;
> +	u8			 disable_hotplug_remove;
> +
> +	struct workqueue_struct	*fw_event_q;
> +	struct list_head	 fw_event_list;
> +	spinlock_t		 fw_event_lock;
> +	u8			 fw_events_off; /* if '1', then ignore events */
> +	char 			 fw_event_q_name[20];
> +
>  	struct mutex		 sas_discovery_mutex;
>  	u8			 sas_discovery_runtime;
>  	u8			 sas_discovery_ignore_events;
> +	struct list_head	 sas_device_info_list;
> +	struct semaphore	 sas_device_info_mutex;

As you say, this is a mutex ... it should use mutex primitives, not
semaphore ones.

>  	u8			 sas_discovery_quiesce_io;
>  	int			 sas_index; /* index refrencing */
>  	MPT_MGMT		 sas_mgmt;
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 4e90870..5b357ce 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -95,7 +95,25 @@ static u8	mptsasInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for interna
>  static u8	mptsasMgmtCtx = MPT_MAX_PROTOCOL_DRIVERS;
>  static u8	mptsasDeviceResetCtx = MPT_MAX_PROTOCOL_DRIVERS;
>  
> -static void mptsas_hotplug_work(struct work_struct *work);
> +static void mptsas_firmware_event_work(struct work_struct *work);
> +static int mptsas_get_lun_number(MPT_ADAPTER *ioc, u8 channel, u8 id, int *lun);
> +static void mptsas_send_sas_event(struct fw_event_work *fw_event);
> +static void mptsas_send_raid_event(struct fw_event_work *fw_event);
> +static void mptsas_send_ir2_event(struct fw_event_work *fw_event);
> +static void mptsas_parse_device_info(struct sas_identify *identify,
> +		struct mptsas_devinfo *device_info);
> +static inline void mptsas_set_rphy(MPT_ADAPTER *ioc,
> +    		struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy);
> +static struct mptsas_phyinfo	*mptsas_find_phyinfo_by_sas_address
> +		(MPT_ADAPTER *ioc, u64 sas_address);
> +static int mptsas_sas_device_pg0(MPT_ADAPTER *ioc,
> +	struct mptsas_devinfo *device_info, u32 form, u32 form_specific);
> +static int mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc,
> +	struct mptsas_enclosure *enclosure, u32 form, u32 form_specific);
> +static int mptsas_add_end_device(MPT_ADAPTER *ioc,
> +	struct mptsas_phyinfo *phy_info);
> +static void mptsas_del_end_device(MPT_ADAPTER *ioc,
> +	struct mptsas_phyinfo *phy_info);
>  
>  static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
>  					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
> @@ -219,6 +237,116 @@ static void mptsas_print_expander_pg1(MPT_ADAPTER *ioc, SasExpanderPage1_t *pg1)
>  	    le16_to_cpu(pg1->AttachedDevHandle)));
>  }
>  
> +/* inhibit sas firmware event handling */
> +static void
> +mptsas_fw_event_off(MPT_ADAPTER *ioc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	ioc->fw_events_off = 1;
> +	ioc->sas_discovery_quiesce_io = 0;
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +
> +}
> +
> +/* enable sas firmware event handling */
> +static void
> +mptsas_fw_event_on(MPT_ADAPTER *ioc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	ioc->fw_events_off = 0;
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +}
> +
> +/* queue a sas firmware event */
> +static void
> +mptsas_add_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
> +    unsigned long delay)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	list_add_tail(&fw_event->list, &ioc->fw_event_list);
> +	INIT_DELAYED_WORK(&fw_event->work, mptsas_firmware_event_work);
> +	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: add (fw_event=0x%p)\n",
> +	    ioc->name, __func__, fw_event));
> +	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
> +	    delay);
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +}
> +
> +/* requeue a sas firmware event */
> +static void
> +mptsas_requeue_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
> +    unsigned long delay)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: reschedule task "
> +	    "(fw_event=0x%p)\n", ioc->name, __func__, fw_event));
> +	fw_event->retries++;
> +	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
> +	    msecs_to_jiffies(delay));
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +}
> +
> +
> +/* free memory assoicated to a sas firmware event */
> +static void
> +mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: kfree (fw_event=0x%p)\n",
> +	    ioc->name, __func__, fw_event));
> +	list_del(&fw_event->list);
> +	kfree(fw_event);
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +}
> +
> +/* walk the firmware event queue, and either stop or wait for
> + * outstanding events to complete */
> +static void
> +mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
> +{
> +	struct fw_event_work *fw_event, *next;
> +	struct mptsas_target_reset_event *target_reset_list, *n;
> +	u8	flush_q;
> +	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
> +
> +	/* flush the target_reset_list */
> +	if (!list_empty(&hd->target_reset_list)) {
> +		list_for_each_entry_safe(target_reset_list, n,
> +		    &hd->target_reset_list, list) {

What protects this list while you're traversing it?

> +			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +			    "%s: removing target reset for id=%d\n",
> +			    ioc->name, __func__,
> +			   target_reset_list->sas_event_data.TargetID));
> +			list_del(&target_reset_list->list);
> +			kfree(target_reset_list);
> +		}
> +	}
> +
> +	if (list_empty(&ioc->fw_event_list) ||
> +	     !ioc->fw_event_q || in_interrupt())
> +		return;
> +
> +	flush_q = 0;
> +	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {

You go to a lot of trouble protecting the fw_event_list with the
fw_event_lock, shouldn't you be using it here to protect the list
iterator?

> +		if (cancel_delayed_work(&fw_event->work))
> +			mptsas_free_fw_event(ioc, fw_event);
> +		else
> +			flush_q = 1;
> +	}
> +	if (flush_q)
> +		flush_workqueue(ioc->fw_event_q);
> +}
> +
> +
>  static inline MPT_ADAPTER *phy_to_ioc(struct sas_phy *phy)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
> @@ -309,6 +437,7 @@ mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_detai
>  		if(phy_info->port_details != port_details)
>  			continue;
>  		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
> +		mptsas_set_rphy(ioc, phy_info, NULL);
>  		phy_info->port_details = NULL;
>  	}
>  	kfree(port_details);
> @@ -380,6 +509,158 @@ starget)
>  		phy_info->port_details->starget = starget;
>  }
>  
> +/**
> + *	mptsas_add_device_component -
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@channel: fw mapped id's
> + *	@id:
> + *	@sas_address:
> + *	@device_info:
> + *
> + **/
> +static void
> +mptsas_add_device_component(MPT_ADAPTER *ioc, u8 channel, u8 id,
> +	u64 sas_address, u32 device_info, u16 slot, u64 enclosure_logical_id)
> +{
> +	struct sas_device_info	*sas_info, *next;
> +	struct scsi_device	*sdev;
> +	struct scsi_target	*starget;
> +	struct sas_rphy		*rphy;
> +
> +	/*
> +	 * Delete all matching devices out of the list
> +	 */
> +	down(&ioc->sas_device_info_mutex);

Obviously, when this becomes a mutex, these all become mutex_lock and
mutex_unlock.

> +	list_for_each_entry_safe(sas_info, next, &ioc->sas_device_info_list,
> +	    list) {
> +		if (!sas_info->is_logical_volume &&
> +			(sas_info->sas_address == sas_address ||
> +			(sas_info->fw.channel == channel &&
> +			sas_info->fw.id == id))) {
> +			list_del(&sas_info->list);
> +			kfree(sas_info);
> +		}
> +	}
> +
> +	sas_info = kzalloc(sizeof(struct sas_device_info), GFP_KERNEL);
> +	if (!sas_info)
> +		goto out;
> +
> +	/*
> +	 * Set Firmware mapping
> +	 */
> +	sas_info->fw.id = id;
> +	sas_info->fw.channel = channel;
> +
> +	sas_info->sas_address = sas_address;
> +	sas_info->device_info = device_info;
> +	sas_info->slot = slot;
> +	sas_info->enclosure_logical_id = enclosure_logical_id;
> +	INIT_LIST_HEAD(&sas_info->list);
> +	list_add_tail(&sas_info->list, &ioc->sas_device_info_list);
> +
> +	/*
> +	 * Set OS mapping
> +	 */
> +	shost_for_each_device(sdev, ioc->sh) {
> +		starget = scsi_target(sdev);
> +		rphy = dev_to_rphy(starget->dev.parent);
> +		if (rphy->identify.sas_address == sas_address) {
> +			sas_info->os.id = starget->id;
> +			sas_info->os.channel = starget->channel;
> +		}
> +	}
> +
> + out:
> +	up(&ioc->sas_device_info_mutex);
> +	return;
> +}
> +
> +/**
> + *	mptsas_add_device_component_by_fw -
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@channel:  fw mapped id's
> + *	@id:
> + *
> + **/
> +static void
> +mptsas_add_device_component_by_fw(MPT_ADAPTER *ioc, u8 channel, u8 id)
> +{
> +	struct mptsas_devinfo sas_device;
> +	struct mptsas_enclosure enclosure_info;
> +	int rc;
> +
> +	rc = mptsas_sas_device_pg0(ioc, &sas_device,
> +	    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
> +	     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
> +	    (channel << 8) + id);
> +	if (rc)
> +		return;
> +
> +	memset(&enclosure_info, 0, sizeof(struct mptsas_enclosure));
> +	mptsas_sas_enclosure_pg0(ioc, &enclosure_info,
> +	    (MPI_SAS_ENCLOS_PGAD_FORM_HANDLE <<
> +	     MPI_SAS_ENCLOS_PGAD_FORM_SHIFT),
> +	     sas_device.handle_enclosure);
> +
> +	mptsas_add_device_component(ioc, sas_device.channel,
> +	    sas_device.id, sas_device.sas_address, sas_device.device_info,
> +	    sas_device.slot, enclosure_info.enclosure_logical_id);
> +}
> +
> +/**
> + *	mptsas_add_device_component_starget -
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@starget:
> + *
> + **/
> +static void
> +mptsas_add_device_component_starget(MPT_ADAPTER *ioc,
> +	struct scsi_target *starget)
> +{
> +	VirtTarget	*vtarget;
> +	struct sas_rphy	*rphy;
> +	struct mptsas_phyinfo	*phy_info = NULL;
> +	struct mptsas_enclosure	enclosure_info;
> +
> +	rphy = dev_to_rphy(starget->dev.parent);
> +	vtarget = starget->hostdata;
> +	phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
> +			rphy->identify.sas_address);
> +	if (!phy_info)
> +		return;
> +
> +	memset(&enclosure_info, 0, sizeof(struct mptsas_enclosure));
> +	mptsas_sas_enclosure_pg0(ioc, &enclosure_info,
> +		(MPI_SAS_ENCLOS_PGAD_FORM_HANDLE <<
> +		MPI_SAS_ENCLOS_PGAD_FORM_SHIFT),
> +		phy_info->attached.handle_enclosure);
> +
> +	mptsas_add_device_component(ioc, phy_info->attached.channel,
> +		phy_info->attached.id, phy_info->attached.sas_address,
> +		phy_info->attached.device_info,
> +		phy_info->attached.slot, enclosure_info.enclosure_logical_id);
> +}
> +
> +/**
> + *	mptsas_del_device_components - Cleaning the list
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *
> + **/
> +static void
> +mptsas_del_device_components(MPT_ADAPTER *ioc)
> +{
> +	struct sas_device_info	*sas_info, *next;
> +
> +	down(&ioc->sas_device_info_mutex);
> +	list_for_each_entry_safe(sas_info, next, &ioc->sas_device_info_list,
> +		list) {
> +		list_del(&sas_info->list);
> +		kfree(sas_info);
> +	}
> +	up(&ioc->sas_device_info_mutex);
> +}
> +
>  
>  /*
>   * mptsas_setup_wide_ports
> @@ -535,6 +816,29 @@ mptsas_find_vtarget(MPT_ADAPTER *ioc, u8 channel, u8 id)
>  	return vtarget;
>  }
>  
> +static void
> +mptsas_queue_device_delete(MPT_ADAPTER *ioc,
> +	MpiEventDataSasDeviceStatusChange_t *sas_event_data)
> +{
> +	struct fw_event_work *fw_event;
> +	int sz;
> +
> +	sz = offsetof(struct fw_event_work, event_data) +
> +	    sizeof(MpiEventDataSasDeviceStatusChange_t);
> +	fw_event = kzalloc(sz, GFP_ATOMIC);
> +	if (!fw_event) {
> +		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
> +		    ioc->name, __func__, __LINE__);
> +		return;
> +	}
> +	memcpy(fw_event->event_data, sas_event_data,
> +	    sizeof(MpiEventDataSasDeviceStatusChange_t));
> +	fw_event->event = MPI_EVENT_SAS_DEVICE_STATUS_CHANGE;
> +	fw_event->ioc = ioc;
> +	mptsas_add_fw_event(ioc, fw_event, msecs_to_jiffies(1));
> +}
> +
> +
>  /**
>   * mptsas_target_reset
>   *
> @@ -653,10 +957,8 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
>  {
>  	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
>          struct list_head *head = &hd->target_reset_list;
> -	struct mptsas_hotplug_event *ev;
>  	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
>  	u8		id, channel;
> -	__le64		sas_address;
>  	struct mptsas_target_reset_event	*target_reset_list;
>  	SCSITaskMgmtReply_t *pScsiTmReply;
>  
> @@ -728,41 +1030,9 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
>  	 * enable work queue to remove device from upper layers
>  	 */
>  	list_del(&target_reset_list->list);
> -
> -	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
> -	if (!ev) {
> -		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
> -		    ioc->name,__func__, __LINE__));
> -		goto out_fail;
> -	}
> -
> -	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
> -		ioc->name, mf));
> -
> -	INIT_WORK(&ev->work, mptsas_hotplug_work);
> -	ev->ioc = ioc;
> -	ev->handle = le16_to_cpu(sas_event_data->DevHandle);
> -	ev->parent_handle =
> -	    le16_to_cpu(sas_event_data->ParentDevHandle);
> -	ev->channel = channel;
> -	ev->id =id;
> -	ev->phy_id = sas_event_data->PhyNum;
> -	memcpy(&sas_address, &sas_event_data->SASAddress,
> -	    sizeof(__le64));
> -	ev->sas_address = le64_to_cpu(sas_address);
> -	ev->device_info = le32_to_cpu(sas_event_data->DeviceInfo);
> -	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> -	   "TaskMgmt type=%d (sas device delete) fw_channel = %d fw_id = %d)\n",
> -	   ioc->name, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET, channel, id));
> -
> -	ev->event_type = MPTSAS_DEL_DEVICE;
> -	schedule_work(&ev->work);
> -	kfree(target_reset_list);
> -
> - out_fail:
> -
> -	mpt_clear_taskmgmt_in_progress_flag(ioc);
> -	return 0;
> +	if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
> +		mptsas_queue_device_delete(ioc,
> +			&target_reset_list->sas_event_data);
>  
> 
>  	/*
> @@ -797,37 +1067,191 @@ static int
>  mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
>  {
>  	MPT_SCSI_HOST	*hd;
> -	struct mptsas_target_reset_event *target_reset_list, *n;
>  	int rc;
>  
>  	rc = mptscsih_ioc_reset(ioc, reset_phase);
> +	if ((ioc->bus_type != SAS) || (!rc))

This is well over braced.

> +		return rc;
> -	if (ioc->bus_type != SAS)
> -		goto out;
> -
> -	if (reset_phase != MPT_IOC_POST_RESET)
> -		goto out;
> -
> -	if (!ioc->sh || !ioc->sh->hostdata)
> -		goto out;
>  	hd = shost_priv(ioc->sh);
>  	if (!hd->ioc)
>  		goto out;
>  
> -	if (list_empty(&hd->target_reset_list))
> -		goto out;
> -
> -	/* flush the target_reset_list */
> -	list_for_each_entry_safe(target_reset_list, n,
> -	    &hd->target_reset_list, list) {
> -		list_del(&target_reset_list->list);
> -		kfree(target_reset_list);
> +	switch (reset_phase) {
> +	case MPT_IOC_SETUP_RESET:
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
> +		mptsas_fw_event_off(ioc);
> +		break;
> +	case MPT_IOC_PRE_RESET:
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
> +		break;
> +	case MPT_IOC_POST_RESET:
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __func__));
> +		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_PENDING) {
> +			ioc->sas_mgmt.status |= MPT_MGMT_STATUS_DID_IOCRESET;
> +			complete(&ioc->sas_mgmt.done);
> +		}
> +		mptsas_cleanup_fw_event_q(ioc);
> +		mptsas_fw_event_on(ioc);
> +		break;
> +	default:
> +		break;
>  	}
>  
>   out:
>  	return rc;
>  }
>  
> +
> +/**
> + * enum device_state -
> + * @DEVICE_RETRY: need to retry the TUR
> + * @DEVICE_ERROR: TUR return error, don't add device
> + * @DEVICE_READY: device can be added
> + *
> + */
> +enum device_state{
> +	DEVICE_RETRY,
> +	DEVICE_ERROR,
> +	DEVICE_READY,
> +};
> +
> +/**
> + * mptsas_test_unit_ready -
> + * @ioc: Pointer to MPT_ADAPTER structure
> + * @channel:
> + * @id:
> + * @count: retry count
> + *
> + */
> +enum device_state
> +mptsas_test_unit_ready(MPT_ADAPTER *ioc, u8 channel, u8 id, u16 count)
> +{
> +	INTERNAL_CMD	*iocmd;
> +	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
> +	enum device_state	state;
> +	int			rc;
> +	u8		skey, asc, ascq;
> +	u8		retry_ua;
> +
> +	retry_ua = 0;
> +	iocmd = kzalloc(sizeof(INTERNAL_CMD), GFP_KERNEL);
> +	if (!iocmd) {
> +		printk(MYIOC_s_ERR_FMT "%s: kzalloc(%zd) FAILED!\n",
> +			__func__, ioc->name, sizeof(INTERNAL_CMD));
> +		return DEVICE_ERROR;
> +	}
> +
> +	state = DEVICE_ERROR;
> +	iocmd->cmd = TEST_UNIT_READY;
> +	iocmd->data_dma = -1;
> +	iocmd->data = NULL;
> +
> +	if (mptscsih_is_phys_disk(ioc, channel, id)) {
> +		iocmd->flags |= MPT_ICFLAG_PHYS_DISK;
> +		iocmd->physDiskNum = mptscsih_raid_id_to_num(ioc, channel, id);
> +		iocmd->id = id;
> +	}
> +	iocmd->channel = channel;
> +	iocmd->id = id;
> +
> + retry:
> +	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: fw_channel=%d "
> +	    "fw_id=%d retry=%d\n", ioc->name, __func__, channel, id, count));
> +	rc = mptscsih_do_cmd(hd, iocmd);
> +	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: rc=0x%02x\n",
> +	    ioc->name, __func__, rc));
> +	if (rc < 0) {
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d: "
> +		    "tur failed due to timeout\n", ioc->name,
> +			__func__, channel, id);
> +		goto tur_done;
> +	}
> +
> +	switch (rc) {
> +	case MPT_SCANDV_GOOD:
> +		state = DEVICE_READY;
> +		goto tur_done;
> +	case MPT_SCANDV_BUSY:
> +		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: "
> +		    "fw_channel=%d fw_id=%d : device busy\n",
> +		    ioc->name, __func__, channel, id));
> +		state = DEVICE_RETRY;
> +		break;
> +	case MPT_SCANDV_DID_RESET:
> +		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: "
> +		    "fw_channel=%d fw_id=%d : did reset\n",
> +		    ioc->name, __func__, channel, id));
> +		state = DEVICE_RETRY;
> +		break;
> +	case MPT_SCANDV_SENSE:
> +		skey = ioc->internal_cmds.sense[2] & 0x0F;
> +		asc = ioc->internal_cmds.sense[12];
> +		ascq = ioc->internal_cmds.sense[13];
> +
> +		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: "
> +		    "fw_channel=%d fw_id=%d : [sense_key,asc,"
> +		    "ascq]: [0x%02x,0x%02x,0x%02x]\n", ioc->name,
> +		    __func__, channel, id, skey, asc, ascq));
> +
> +		if (skey == UNIT_ATTENTION) {
> +			state = DEVICE_RETRY;
> +			break;
> +		} else if (skey == NOT_READY) {
> +			/*
> +			 * medium isn't present
> +			 */
> +			if (asc == 0x3a) {
> +				state = DEVICE_READY;
> +				goto tur_done;
> +			}
> +			/*
> +			 * LU becoming ready, or
> +			 * LU hasn't self-configured yet
> +			 */
> +			if ((asc == 0x04 && ascq == 0x01) ||
> +			    (asc == 0x04 && ascq == 0x11) ||
> +			    asc == 0x3e) {
> +				state = DEVICE_RETRY;
> +				break;
> +			}
> +		} else if (skey == ILLEGAL_REQUEST) {
> +			/* try sending a tur to a non-zero lun number */
> +			if (!iocmd->lun && !mptsas_get_lun_number(ioc,
> +				channel, id, &iocmd->lun) && iocmd->lun)
> +				goto retry;
> +		}
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d : "
> +			"tur failed due to [sense_key,asc,ascq]: "
> +			"[0x%02x,0x%02x,0x%02x]\n", ioc->name,
> +			__func__, channel, id, skey, asc, ascq);
> +		goto tur_done;
> +	case MPT_SCANDV_SELECTION_TIMEOUT:
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d: "
> +			"tur failed due to no device\n", ioc->name,
> +			__func__, channel,
> +			id);
> +		goto tur_done;
> +	case MPT_SCANDV_SOME_ERROR:
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d: "
> +			"tur failed due to some error\n", ioc->name,
> +			__func__, channel, id);
> +		goto tur_done;
> +	default:
> +		printk(MYIOC_s_ERR_FMT
> +			"%s: fw_channel=%d fw_id=%d: tur failed due to "
> +			"unknown rc=0x%02x\n", ioc->name, __func__,
> +			channel, id, rc);
> +		goto tur_done;
> +	}
> + tur_done:
> +	kfree(iocmd);
> +	return state;
> +}

This routine looks like a recoding of scsi_test_unit_ready().  Firstly,
why not just use it, but secondly, why is it necessary ... the use case
is when you spot a device added and the mid layer does inquiry and
settle checking anyway.

>  static int
>  mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
>  		u32 form, u32 form_specific)
> @@ -893,15 +1317,361 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
>  	return error;
>  }
>  
> +/**
> + *	mptsas_get_lun_number - returns the first entry in report_luns table
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@channel:
> + *	@id:
> + *	@lun:
> + *
> + */
> +static int
> +mptsas_get_lun_number(MPT_ADAPTER *ioc, u8 channel, u8 id, int *lun)
> +{
> +	INTERNAL_CMD	*iocmd;
> +	struct scsi_lun *lun_data;
> +	dma_addr_t	lun_data_dma;
> +	u32		lun_data_len;
> +	u8	*data;
> +	MPT_SCSI_HOST	*hd;
> +	int		rc;
> +	u32		length, num_luns;
> +
> +	iocmd = NULL;
> +	hd = shost_priv(ioc->sh);
> +	lun_data_len = (255 * sizeof(struct scsi_lun));
> +	lun_data = pci_alloc_consistent(ioc->pcidev, lun_data_len,
> +	    &lun_data_dma);
> +	if (!lun_data) {
> +		printk(MYIOC_s_ERR_FMT "%s: pci_alloc_consistent(%d) FAILED!\n",
> +		    ioc->name, __func__, lun_data_len);
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	iocmd = kzalloc(sizeof(INTERNAL_CMD), GFP_KERNEL);
> +	if (!iocmd) {
> +		printk(MYIOC_s_ERR_FMT "%s: kzalloc(%zd) FAILED!\n",
> +		    ioc->name, __func__, sizeof(INTERNAL_CMD));
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Report Luns
> +	 */
> +	iocmd->cmd = REPORT_LUNS;
> +	iocmd->data_dma = lun_data_dma;
> +	iocmd->data = (u8 *)lun_data;
> +	iocmd->size = lun_data_len;
> +	iocmd->channel = channel;
> +	iocmd->id = id;
> +
> +	rc = mptscsih_do_cmd(hd, iocmd);
> +	if (rc < 0) {
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d: "
> +		    "report_luns failed due to rc=0x%x\n", ioc->name,
> +		 __func__, channel, id, rc);
> +		goto out;
> +	}
> +
> +	if (rc != MPT_SCANDV_GOOD) {
> +		printk(MYIOC_s_ERR_FMT "%s: fw_channel=%d fw_id=%d: "
> +		    "report_luns failed due to rc=0x%x\n", ioc->name,
> +		 __func__, channel, id, rc);
> +		rc = -rc;
> +		goto out;
> +	}
> +
> +	data = (u8 *)lun_data;
> +	length = ((data[0] << 24) | (data[1] << 16) |
> +	    (data[2] << 8) | (data[3] << 0));
> +
> +	num_luns = (length / sizeof(struct scsi_lun));
> +	if (!num_luns)
> +		goto out;
> +	/* return 1st lun in the list */
> +	*lun = mpt_scsilun_to_int(&lun_data[1]);
> +
> +#if 0
> +	/* some debugging, left commented out */
> +	{
> +		struct scsi_lun *lunp;
> +		for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++)
> +			printk("%x\n", scsilun_to_int(lunp));
> +	}
> +#endif
> +
> + out:
> +	if (lun_data)
> +		pci_free_consistent(ioc->pcidev, lun_data_len, lun_data,
> +		    lun_data_dma);
> +	kfree(iocmd);
> +	return rc;
> +}

OK, this is getting sillier.  You send a TUR to a device, but the device
may not have a LUN 0, so now we're going to send a report luns and fish
for an actual lun to test?  Again, the mid layer does all of this when
the device appears, why not just let it?

> +/**
> + *	mptsas_add_end_device - report a new end device to sas transport layer
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@phy_info: decribes attached device
> + *
> + *	return (0) success (1) failure
> + *
> + **/
> +static int
> +mptsas_add_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
> +{
> +	struct sas_rphy *rphy;
> +	struct sas_port *port;
> +	struct sas_identify identify;
> +	char *ds = NULL;
> +	u8 fw_id;
> +
> +	if (!phy_info) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: exit at line=%d\n", ioc->name,
> +			 __func__, __LINE__));
> +		return 1;
> +	}
> +
> +	fw_id = phy_info->attached.id;
> +
> +	if (mptsas_get_rphy(phy_info)) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		return 2;
> +	}
> +
> +	port = mptsas_get_port(phy_info);
> +	if (!port) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		return 3;
> +	}
> +
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_SSP_TARGET)
> +		ds = "ssp";
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_STP_TARGET)
> +		ds = "stp";
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
> +		ds = "sata";
> +
> +	printk(MYIOC_s_INFO_FMT "attaching %s device: fw_channel %d, fw_id %d,"
> +	    " phy %d, sas_addr 0x%llx\n", ioc->name, ds,
> +	    phy_info->attached.channel, phy_info->attached.id,
> +	    phy_info->attached.phy_id, (unsigned long long)
> +	    phy_info->attached.sas_address);
> +
> +	mptsas_parse_device_info(&identify, &phy_info->attached);
> +	rphy = sas_end_device_alloc(port);
> +	if (!rphy) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		return 5; /* non-fatal: an rphy can be added later */
> +	}
> +
> +	rphy->identify = identify;
> +	if (sas_rphy_add(rphy)) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		sas_rphy_free(rphy);
> +		return 6;
> +	}
> +	mptsas_set_rphy(ioc, phy_info, rphy);
> +	return 0;
> +}
> +
> +/**
> + *	mptsas_del_end_device - report a deleted end device to sas transport
> + *	layer
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@phy_info: decribes attached device
> + *
> + **/
> +static void
> +mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
> +{
> +	struct sas_rphy *rphy;
> +	struct sas_port *port;
> +	struct mptsas_portinfo *port_info;
> +	struct mptsas_phyinfo *phy_info_parent;
> +	int i;
> +	char *ds = NULL;
> +	u8 fw_id;
> +	u64 sas_address;
> +
> +	if (!phy_info)
> +		return;
> +
> +	fw_id = phy_info->attached.id;
> +	sas_address = phy_info->attached.sas_address;
> +
> +	if (!phy_info->port_details) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		return;
> +	}
> +	rphy = mptsas_get_rphy(phy_info);
> +	if (!rphy) {
> +		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
> +			"%s: fw_id=%d exit at line=%d\n", ioc->name,
> +			 __func__, fw_id, __LINE__));
> +		return;
> +	}
> +
> +	if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_INITIATOR
> +		|| phy_info->attached.device_info
> +			& MPI_SAS_DEVICE_INFO_SMP_INITIATOR
> +		|| phy_info->attached.device_info
> +			& MPI_SAS_DEVICE_INFO_STP_INITIATOR)
> +		ds = "initiator";
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_SSP_TARGET)
> +		ds = "ssp";
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_STP_TARGET)
> +		ds = "stp";
> +	if (phy_info->attached.device_info &
> +	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
> +		ds = "sata";
> +
> +	printk(MYIOC_s_INFO_FMT "removing %s device: fw_channel %d,"
> +	    " fw_id %d, phy %d, sas_addr 0x%llx\n", ioc->name, ds,
> +	    phy_info->attached.channel, phy_info->attached.id,
> +	    phy_info->attached.phy_id, (unsigned long long)
> +	    sas_address);

If you just did a dev_printk on &rphy->dev, you'll get a lot of the
above.  The remaining information might be a useful addition to the sas
transport class as a printing primitive.

James


