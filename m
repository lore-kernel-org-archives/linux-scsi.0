From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 08/11] megaraid_sas: Enable or Disable Fast path based
 on the PCI Threshold Bandwidth
Date: Tue, 20 Dec 2016 16:12:06 +0100
Message-ID: <35236428-854c-fe94-3f38-21f290b12ea9@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-9-git-send-email-sasikumar.pc@broadcom.com>
 <5e8d0157-51e1-1727-6ebb-2917b0d333c5@redhat.com>
 <459befddaf0e9f9ad1f597f1037f82ba@mail.gmail.com>
 <e604955b-86a3-e510-67ab-9632cf16e667@redhat.com>
 <253204edbcd5836c84a89f9460bc4a83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <253204edbcd5836c84a89f9460bc4a83@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar PC <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, Christopher Owens <christopher.owens@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 20.12.2016 02:51, Sasikumar PC wrote:
> Hi Tomas,
>
> Please see my response inline
>
> Thanks
> sasi
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, December 15, 2016 10:10 AM
> To: Sasikumar PC; jejb@kernel.org; hch@infradead.org
> Cc: linux-scsi@vger.kernel.org; Sathya Prakash Veerichetty;
> linux-kernel@vger.kernel.org; Christopher Owens; Kiran Kumar Kasturi
> Subject: Re: [PATCH V4 08/11] megaraid_sas: Enable or Disable Fast path
> based on the PCI Threshold Bandwidth
>
> On 14.12.2016 22:54, Sasikumar PC wrote:
>> Hi Tomas,
>>
>> Please see my response inline
>>
>> Thanks
>> sasi
>>
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Friday, December 09, 2016 8:59 AM
>> To: Sasikumar Chandrasekaran; jejb@kernel.org; hch@infradead.org
>> Cc: linux-scsi@vger.kernel.org; Sathya.Prakash@broadcom.com;
>> linux-kernel@vger.kernel.org; christopher.owens@broadcom.com;
>> kiran-kumar.kasturi@broadcom.com
>> Subject: Re: [PATCH V4 08/11] megaraid_sas: Enable or Disable Fast
>> path based on the PCI Threshold Bandwidth
>>
>> On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
>>> Large SEQ IO workload should sent as non fast path commands
>>>
>>> This patch is depending on patch 7
>>>
>>> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas.h        |  8 +++++
>>>  drivers/scsi/megaraid/megaraid_sas_base.c   | 48
>> +++++++++++++++++++++++++++++
>>>  drivers/scsi/megaraid/megaraid_sas_fp.c     | 11 +++++--
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 20 +++++++-----
>>> drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +-
>>>  5 files changed, 78 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>> index 3e087ab..eb5be2b 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
>>>  #define MFI_1068_FW_HANDSHAKE_OFFSET		0x64
>>>  #define MFI_1068_FW_READY			0xDDDD0000
>>>
>>> +#define MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL HZ
>>> +
>>>  #define MR_MAX_REPLY_QUEUES_OFFSET              0X0000001F
>>>  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET          0X003FC000
>>>  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>>> @@ -2101,6 +2103,10 @@ struct megasas_instance {
>>>  	atomic_t ldio_outstanding;
>>>  	atomic_t fw_reset_no_pci_access;
>>>
>>> +	atomic64_t bytes_wrote; /* used for raid1 fast path enable or
>> disable */
>>> +	atomic_t r1_write_fp_capable;
>> Is a an atomic variable needed for a just boolean variable?
>> Sasi - As we need to synchronize timer thread and IO issue threads,
>> With atomic, at any point of time the value will be definitive.
>> With boolean, it depends, the value could be in transit while one
>> thread is reading and other is writing.
> This explanation is I think not good enough, as a write of a char value is
> atomic on all architectures. If you need synchronisation you probably need a
> spinlock.
> Tomash
>
> boolean may not be a char in all architectures/implementations. It could be
> implementation specific isn't it ?

On which arch? 

> Spin_Lock is heavier as the check is in IO path.

Lightest form of atomic variable for isolated write and read is probably a char - so why can't
you use that plain basic type to store a boolean value?

> We need it to be consistent
> non-transient value, not an exact synchronization.

Could you be please more specific - what exactly is the transient value other than true or false ?

> There could be more values that we may set this variable to, to make
> different decisions and value can be set in more places in future.
> Atomic will help it keep consistent and extensible.

And then you'll rename the variable and use bit operations or may use
different state values and for that a char or int which is atomic per se
are the best option.

You've tested the whole series so you try to not change anything in the series,
I'm trying to understand.
You wrote earlier here that an explicit synchronisation is not needed,
that means, that there is no race condition possible and the
code is just a bit less then ideal. ok, fine, i'll this pass.

>
> sasi
>
>>> +
>>> +
>>>  	struct megasas_instance_template *instancet;
>>>  	struct tasklet_struct isr_tasklet;
>>>  	struct work_struct work_init;
>>> @@ -2143,6 +2149,7 @@ struct megasas_instance {
>>>  	long reset_flags;
>>>  	struct mutex reset_mutex;
>>>  	struct timer_list sriov_heartbeat_timer;
>>> +	struct timer_list r1_fp_hold_timer;
>>>  	char skip_heartbeat_timer_del;
>>>  	u8 requestorId;
>>>  	char PlasmaFW111;
>>> @@ -2159,6 +2166,7 @@ struct megasas_instance {
>>>  	bool is_ventura;
>>>  	bool msix_combined;
>>>  	u16 max_raid_mapsize;
>>> +	u64 pci_threshold_bandwidth; /* used to control the fp writes */
>>>  };
>>>  struct MR_LD_VF_MAP {
>>>  	u32 size;
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> index 8aafb59..899d25c 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -1940,6 +1940,9 @@ void megaraid_sas_kill_hba(struct
>>> megasas_instance
>> *instance)
>>>  	}
>>>  	/* Complete outstanding ioctls when adapter is killed */
>>>  	megasas_complete_outstanding_ioctls(instance);
>>> +	if (instance->is_ventura)
>>> +		del_timer_sync(&instance->r1_fp_hold_timer);
>>> +
>>>  }
>>>
>>>   /**
>>> @@ -2438,6 +2441,24 @@ void megasas_sriov_heartbeat_handler(unsigned
>> long instance_addr)
>>>  	}
>>>  }
>>>
>>> +/*Handler for disabling/enabling raid 1 fast paths*/ void
>>> +megasas_change_r1_fp_status(unsigned long instance_addr) {
>>> +	struct megasas_instance *instance =
>>> +			(struct megasas_instance *)instance_addr;
>>> +	if (atomic64_read(&instance->bytes_wrote) >=
>>> +					instance->pci_threshold_bandwidth)
>> {
>>> +
>>> +		atomic64_set(&instance->bytes_wrote, 0);
>>> +		atomic_set(&instance->r1_write_fp_capable, 0);
>>> +	} else {
>>> +		atomic64_set(&instance->bytes_wrote, 0);
>>> +		atomic_set(&instance->r1_write_fp_capable, 1);
>>> +	}
>>> +	mod_timer(&instance->r1_fp_hold_timer,
>>> +	 jiffies + MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
>>> +}
>>> +
>>>  /**
>>>   * megasas_wait_for_outstanding -	Wait for all outstanding cmds
>>>   * @instance:				Adapter soft state
>>> @@ -5371,6 +5392,17 @@ static int megasas_init_fw(struct
>> megasas_instance *instance)
>>>  			instance->skip_heartbeat_timer_del = 1;
>>>  	}
>>>
>>> +	if (instance->is_ventura) {
>>> +		atomic64_set(&instance->bytes_wrote, 0);
>>> +		atomic_set(&instance->r1_write_fp_capable, 1);
>>> +		megasas_start_timer(instance,
>>> +			    &instance->r1_fp_hold_timer,
>>> +			    megasas_change_r1_fp_status,
>>> +
>> MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
>>> +				dev_info(&instance->pdev->dev, "starting
>> the raid 1 fp timer with interval %d\n",
>>> +
>> MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
>>> +	}
>>> +
>>>  	return 0;
>>>
>>>  fail_get_ld_pd_list:
>>> @@ -6161,6 +6193,9 @@ static void megasas_shutdown_controller(struct
>> megasas_instance *instance,
>>>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
>>>  		del_timer_sync(&instance->sriov_heartbeat_timer);
>>>
>>> +	if (instance->is_ventura)
>>> +		del_timer_sync(&instance->r1_fp_hold_timer);
>>> +
>>>  	megasas_flush_cache(instance);
>>>  	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
>>>
>>> @@ -6280,6 +6315,16 @@ static void megasas_shutdown_controller(struct
>> megasas_instance *instance,
>>>  	megasas_setup_jbod_map(instance);
>>>  	instance->unload = 0;
>>>
>>> +	if (instance->is_ventura) {
>>> +		atomic64_set(&instance->bytes_wrote, 0);
>>> +		atomic_set(&instance->r1_write_fp_capable, 1);
>>> +		megasas_start_timer(instance,
>>> +			    &instance->r1_fp_hold_timer,
>>> +			    megasas_change_r1_fp_status,
>>> +
>> MEGASAS_RAID1_FAST_PATH_STATUS_CHECK_INTERVAL);
>>> +	}
>>> +
>>> +
>>>  	/*
>>>  	 * Initiate AEN (Asynchronous Event Notification)
>>>  	 */
>>> @@ -6368,6 +6413,9 @@ static void megasas_detach_one(struct pci_dev
>> *pdev)
>>>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
>>>  		del_timer_sync(&instance->sriov_heartbeat_timer);
>>>
>>> +	if (instance->is_ventura)
>>> +		del_timer_sync(&instance->r1_fp_hold_timer);
>>> +
>>>  	if (instance->fw_crash_state != UNAVAILABLE)
>>>  		megasas_free_host_crash_buffer(instance);
>>>  	scsi_remove_host(instance->host);
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fp.c
>>> index a6957a3..7da4685 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
>>> @@ -197,14 +197,19 @@ void MR_PopulateDrvRaidMap(struct
>>> megasas_instance *instance)
>>>
>>>  	if (instance->max_raid_mapsize) {
>>>  		fw_map_dyn = fusion->ld_map[(instance->map_id & 1)];
>>> +		if (fw_map_dyn->pci_threshold_bandwidth)
>>> +			instance->pci_threshold_bandwidth =
>>> +			le64_to_cpu(fw_map_dyn->pci_threshold_bandwidth);
>>>  #if VD_EXT_DEBUG
>>>  		dev_dbg(&instance->pdev->dev,
>>>  		" raidMapSize 0x%x fw_map_dyn->descTableOffset 0x%x, "
>>> -		" descTableSize 0x%x descTableNumElements 0x%x\n",
>>> +		" descTableSize 0x%x descTableNumElements 0x%x, "
>>> +		" PCIThreasholdBandwidth %llu\n",
>>>  		le32_to_cpu(fw_map_dyn->raid_map_size),
>>>  		le32_to_cpu(fw_map_dyn->desc_table_offset),
>>>  		le32_to_cpu(fw_map_dyn->desc_table_size),
>>> -		le32_to_cpu(fw_map_dyn->desc_table_num_elements));
>>> +		le32_to_cpu(fw_map_dyn->desc_table_num_elements),
>>> +		instance->pci_threshold_bandwidth);
>>>  		dev_dbg(&instance->pdev->dev,
>>>  		"drv map %p ldCount %d\n", drv_map, fw_map_dyn->ld_count);
>> #endif
>>> @@ -434,6 +439,8 @@ void MR_PopulateDrvRaidMap(struct
>>> megasas_instance
>> *instance)
>>>  			sizeof(struct MR_DEV_HANDLE_INFO) *
>>>  			MAX_RAIDMAP_PHYSICAL_DEVICES);
>>>  	}
>>> +	if (instance->is_ventura && !instance->pci_threshold_bandwidth)
>>> +		instance->pci_threshold_bandwidth = ULLONG_MAX;
>>>  }
>>>
>>>  /*
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index f968a23..5992153 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -95,6 +95,7 @@ void megasas_start_timer(struct megasas_instance
>>> *instance,  extern unsigned int dual_qdepth_disable;  static void
>>> megasas_free_rdpq_fusion(struct megasas_instance *instance);  static
>>> void megasas_free_reply_fusion(struct megasas_instance *instance);
>>> +void megasas_change_r1_fp_status(unsigned long instance_addr);
>>>
>>>
>>>
>>> @@ -2633,8 +2634,9 @@ void megasas_prepare_secondRaid1_IO(struct
>> megasas_instance *instance,
>>>  	*	to get new command
>>>  	*/
>>>  	if (cmd->is_raid_1_fp_write &&
>>> -		atomic_inc_return(&instance->fw_outstanding) >
>>> -			(instance->host->can_queue)) {
>>> +		(atomic_inc_return(&instance->fw_outstanding) >
>>> +			(instance->host->can_queue) ||
>>> +		(!atomic_read(&instance->r1_write_fp_capable)))) {
>>>  		megasas_fpio_to_ldio(instance, cmd, cmd->scmd);
>>>  		atomic_dec(&instance->fw_outstanding);
>>>  	} else if (cmd->is_raid_1_fp_write) { @@ -2643,17 +2645,19 @@ void
>>> megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
>>>  		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
>>>  	}
>>>
>>> -
>>>  	/*
>>> -	 * Issue the command to the FW
>>> -	 */
>>> +	* Issue the command to the FW
>>> +	*/
>>> +	if (scmd->sc_data_direction == PCI_DMA_TODEVICE &&
>> instance->is_ventura)
>>> +		atomic64_add(scsi_bufflen(scmd), &instance->bytes_wrote);
>> You count the bytes written to the ventura card and based on that it
>> is asynchronously decided whether the r1_write_fp_capable bit is set
>> in a timer function.
>> Please explain what should be achieved with this.
> Certain write IOs can be sent to Firmware on ventura adapter or bypass
> Firmware and sent to drives, through hardware.
> When the driver sends write IOs in the second path, it needs to send two
> such IOs one for each physical drive, in case RAID 1 logical devices.
> When two IOs are sent with the same payload, the payload need to cross PCI
> twice consuming twice the bandwidth for the same payload which affects the
> performance.
> The idea here is to make a decision of when to bypass firmware and when not,
> based on write bandwidth that can be handled by adapter and to meet
> performance goals.
> That's the reason write payload is monitored.

With the explanation makes sense now. Thanks.

>
> Sasi
>> Sasi - I am working on this and will be posting the update soon
>>
>> Thanks,
>> Tomas
>>
>>
>>
>>
>>>  	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
>>>
>>> -	if (r1_cmd)
>>> +	if (r1_cmd) {
>>> +		atomic64_add(scsi_bufflen(scmd), &instance->bytes_wrote);
>>>  		megasas_fire_cmd_fusion(instance, r1_cmd->request_desc,
>>> -				instance->is_ventura);
>>> -
>>> +			instance->is_ventura);
>>> +	}
>>>
>>>  	return 0;
>>>  }
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>> index c39c4ed..da05790 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>> @@ -977,7 +977,7 @@ struct MR_FW_RAID_MAP_DYNAMIC {
>>>  	u32 desc_table_size;  /* Total Size of desc table */
>>>  	/* Total Number of elements in the desc table */
>>>  	u32 desc_table_num_elements;
>>> -	u64	reserved1;
>>> +	u64	pci_threshold_bandwidth;
>>>  	u32	reserved2[3];	/*future use */
>>>  	/* timeout value used by driver in FP IOs */
>>>  	u8 fp_pd_io_timeout_sec;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
