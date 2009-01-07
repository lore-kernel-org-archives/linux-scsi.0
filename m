From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 3/5] mpt fusion: Added Firmware debug support
Date: Wed, 7 Jan 2009 12:04:23 -0800
Message-ID: <da824cf30901071204k2317df5er5f80b7a882e370a5@mail.gmail.com>
References: <20090106093332.GE13033@lsi.com>
	 <da824cf30901061153s714aa74dhdceb7ac50f25e4e7@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C13FF96712C@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZAGUE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 15:04:56 -0500
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n07K4skm010674
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2009 12:04:54 -0800
Received: from bwz4 (bwz4.prod.google.com [10.188.26.4])
	by spaceape7.eur.corp.google.com with ESMTP id n07K2EKQ027504
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2009 12:04:51 -0800
Received: by bwz4 with SMTP id 4so23785744bwz.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2009 12:04:51 -0800 (PST)
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C13FF96712C@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>

On Tue, Jan 6, 2009 at 10:03 PM, Desai, Kashyap <Kashyap.Desai@lsi.com> wrote:
> Grant,
>
> I do agree with you, but we have reasons doing things this way.
>
> 1. This is only for development purpose. Normally when Firmware fault occurs driver will reset firmware so that further communication with firmware can resume. In this condition we were not able to track root cause of fault. In debug environment mpt_fwfault_debug will be set. In this case Driver will not reset firmware rather it will panic the system.

developement flags should be disabled by default, not enabled.

> Reason doing Fault.
> If we don't panic the system, we will get huge IO errors if any IO stress is running  and error message will flood the syslog.(specially this things happens in Overnight stress test)

It makes sense to have the flag but not to enable it by default.

hth,
grant

>
> Thoughts?
>
> Thanks
> Kashyap Desai
>
> -----Original Message-----
> From: Grant Grundler [mailto:grundler@google.com]
> Sent: Wednesday, January 07, 2009 1:23 AM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya; James.Bottomley@hansenpartnership.com
> Subject: Re: [PATCH 3/5] mpt fusion: Added Firmware debug support
>
> On Tue, Jan 6, 2009 at 1:33 AM, Kashyap, Desai <kashyap.desai@lsi.com> wrote:
>>
>> Added support for Firmware debuging
>> ---
>>
>> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
>> ---
>> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>> index 55d9a7e..ea3aafb 100644
>> --- a/drivers/message/fusion/mptbase.c
>> +++ b/drivers/message/fusion/mptbase.c
>> @@ -107,6 +107,14 @@ module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
>>  MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
>>        - (default=0)");
>>
>> +int mpt_fwfault_debug;
>> +EXPORT_SYMBOL(mpt_fwfault_debug);
>> +module_param_call(mpt_fwfault_debug, param_set_int, param_get_int,
>> +         &mpt_fwfault_debug, 0600);
>> +MODULE_PARM_DESC(mpt_fwfault_debug, "Enable detection of Firmware fault"
>> +       " and halt Firmware on fault - (default=0)");
>> +
>> +
>>
>>  #ifdef MFCNT
>>  static int mfcounter = 0;
>> @@ -6337,6 +6345,33 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
>>        *size = y;
>>  }
>>
>> +
>> +/**
>> + *     mpt_halt_firmware - Halts the firmware if it is operational and panic
>> + *     the kernel
>> + *     @ioc: Pointer to MPT_ADAPTER structure
>> + *
>> + **/
>> +void
>> +mpt_halt_firmware(MPT_ADAPTER *ioc)
>> +{
>> +       u32      ioc_raw_state;
>> +
>> +       ioc_raw_state = mpt_GetIocState(ioc, 0);
>> +
>> +       if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
>> +               printk(MYIOC_s_ERR_FMT "IOC is in FAULT state (%04xh)!!!\n",
>> +                       ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
>> +               panic("%s: IOC Fault (%04xh)!!!\n", ioc->name,
>> +                       ioc_raw_state & MPI_DOORBELL_DATA_MASK);
>
> Wouldn't it be better to NOT panic the machine?
> One can still prod things "manually" (read config and MMIO space
> registers) for further debugging.
>
> I'm thinking it would make more sense to call the variable
> "mpt_fwfault_panic" and use it to decide if the machine should panic
> or not. Thoughts?
>
> grant
>
>> +       } else {
>> +               CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
>> +               panic("%s: Firmware is halted due to command timeout\n",
>> +                       ioc->name);
>> +       }
>> +}
>> +EXPORT_SYMBOL(mpt_halt_firmware);
>> +
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>>  /*
>>  *     Reset Handling
>> @@ -6369,6 +6404,8 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
>>        printk(MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name);
>>        printk("MF count 0x%x !\n", ioc->mfcnt);
>>  #endif
>> +       if (mpt_fwfault_debug)
>> +               mpt_halt_firmware(ioc);
>>
>>        /* Reset the adapter. Prevent more than 1 call to
>>         * mpt_do_ioc_recovery at any instant in time.
>> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
>> index dff048c..b3e981d 100644
>> --- a/drivers/message/fusion/mptbase.h
>> +++ b/drivers/message/fusion/mptbase.h
>> @@ -922,11 +922,14 @@ extern void        mpt_free_fw_memory(MPT_ADAPTER *ioc);
>>  extern int      mpt_findImVolumes(MPT_ADAPTER *ioc);
>>  extern int      mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
>>  extern int      mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
>> +extern void     mpt_halt_firmware(MPT_ADAPTER *ioc);
>> +
>>
>>  /*
>>  *  Public data decl's...
>>  */
>>  extern struct list_head          ioc_list;
>> +extern int mpt_fwfault_debug;
>>
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>>  #endif         /* } __KERNEL__ */
>> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
>> index ee09041..e62c6bc 100644
>> --- a/drivers/message/fusion/mptscsih.c
>> +++ b/drivers/message/fusion/mptscsih.c
>> @@ -1846,6 +1846,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>>        if (hd->timeouts < -1)
>>                hd->timeouts++;
>>
>> +       if (mpt_fwfault_debug)
>> +               mpt_halt_firmware(ioc);
>> +
>>        /* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
>>         * (the IO to be ABORT'd)
>>         *
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
