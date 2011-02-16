From: David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC PATCH 2/6] isci: task (libsas interface support)
Date: Wed, 16 Feb 2011 12:48:20 -0600
Message-ID: <4D5C1BF4.2050100@redhat.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>	<20110207003445.27040.67152.stgit@localhost6.localdomain6>	<4D52AC5A.7020206@redhat.com> <AANLkTinfhEO2uXW94S9q++D8dNjBpOy1_3s64X=ScbLY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab1BPSsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 13:48:22 -0500
In-Reply-To: <AANLkTinfhEO2uXW94S9q++D8dNjBpOy1_3s64X=ScbLY@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Dan Williams wrote:
> Thanks David, comments below.
> 
>>> +       if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
>>> +
>>> +               isci_task_complete_for_upper_layer(
>>> +                       task,
>>> +                       SAS_TASK_UNDELIVERED,
>>> +                       SAM_STAT_TASK_ABORTED,
>>> +                       isci_perform_normal_io_completion
>>> +                       );
>>> +
>>> +               return 0;  /* The I/O was accepted (and failed). */
>> Dan, is this the right status to return to libsas?
>>
>> Looks like it checks (->lldd_execute_task) for non-zero result.
> 
> I think this is self defense that can be deleted, how can a task be
> aborted before it has even returned from the submission routine.
> 
>>> +       }
>>> +       if ((task->dev == NULL) || (task->dev->port == NULL)) {
>>> +
>>> +               /* Indicate SAS_TASK_UNDELIVERED, so that the scsi
>>> midlayer
>>> +                * removes the target.
>>> +                */
>>> +               isci_task_complete_for_upper_layer(
>>> +                       task,
>>> +                       SAS_TASK_UNDELIVERED,
>>> +                       SAS_DEVICE_UNKNOWN,
>>> +                       isci_perform_normal_io_completion
>>> +                       );
>>> +               return 0;  /* The I/O was accepted (and failed). */
>> Same here?
> 
> Yeah, we should always be able to dereference task->dev because ->dev
> is referenced counted against outstanding commands.  If we have a task
> by definition we have a dev.
> 
> [..]
>>> +        */
>>> +       isci_task_build_tmf(&tmf, isci_device, isci_tmf_ssp_lun_reset,
>>> NULL,
>>> +                           NULL);
>>> +
>>> +       #define ISCI_LU_RESET_TIMEOUT_MS 2000 /* 2 second timeout. */
>> Maybe move #define to isci_task.h?
> 
> Ok.
> 
>>> +       ret = isci_task_execute_tmf(isci_host, &tmf,
>>> ISCI_LU_RESET_TIMEOUT_MS);
>>> +
>>> +       if (ret == TMF_RESP_FUNC_COMPLETE)
>>> +               dev_dbg(&isci_host->pdev->dev,
>>> +                       "%s: %p: TMF_LU_RESET passed\n",
>>> +                       __func__, isci_device);
>>> +       else
>>> +               dev_dbg(&isci_host->pdev->dev,
>>> +                       "%s: %p: TMF_LU_RESET failed (%x)\n",
>>> +                       __func__, isci_device, ret);
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>> +
>>> +/*      int (*lldd_clear_nexus_port)(struct asd_sas_port *); */
>>> +int isci_task_clear_nexus_port(struct asd_sas_port *port)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>>> +
>>> +
>>> +
>>> +int isci_task_clear_nexus_ha(struct sas_ha_struct *ha)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>>> +
>>> +int isci_task_I_T_nexus_reset(struct domain_device *dev)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>>> +
>> These will be used during libsas error handling.
> 
> The driver implements abort_task, and promotes the rest to lu_reset.
> Assuming the documentation is not out of date:
> 
>      A SAS LLDD should also implement at least one of the Task
>      Management Functions (TMFs) described in SAM:
> 
> ...how urgent is the need for these other task management routines?

Dan,

Looks like some of these will be used down the scsi error handling
path

scsi_error_handler
  eh_strategy_handler (sas_scsi_recover_host)
   sas_eh_handle_sas_errors

For some of these you may be able to build and execute, something
like

isci_task_abort_task()
{
	isci_task_build_tmf(TMF_ABORT_TASK)
	isci_task_execute_tmf()
}


Also, looks like other libsas drivers do a phy reset from 
lldd_I_T_nexus_reset,
probably ok to eliminate lldd_clear_aca for now.

> 
> Speaking of mandatory libsas methods all other libsas drivers outside
> of aic94xx forgo implementing
> 
>              /* Port and Adapter management */
>              int (*lldd_clear_nexus_port)(struct sas_port *);
>              int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
> 
>      A SAS LLDD should implement at least one of those.
> 
> ...not clear that at least one of those is mandatory.
> 

Yes, good point, probably ok to initially eliminate these.

Thanks,
David


>>
>>> +/**
>>> + * isci_task_abort_task() - This function is one of the SAS Domain
>>> Template
>>> + *    functions. This function is called by libsas to abort a specified
>>> task.
>>> + * @task: This parameter specifies the SAS task to abort.
>>> + *
>>> + * status, zero indicates success.
>>> + */
>>> +int isci_task_abort_task(struct sas_task *task)
>>> +{
>> scic_lock, flags);
>>
>>
>>> +
>>> +               #define ISCI_ABORT_TASK_TIMEOUT_MS 500 /* half second
>>> timeout. */
>> Maybe move this #define to isci_task.h?
> 
> Ok.
> 
> [..]
>>> + * isci_task_abort_task_set() - This function is one of the SAS Domain
>>> Template
>>> + *    functions. This is one of the Task Management functoins called by
>>> libsas,
>>> + *    to abort all task for the given lun.
>>> + * @d_device: This parameter specifies the domain device associated with
>>> this
>>> + *    request.
>>> + * @lun: This parameter specifies the lun associated with this request.
>>> + *
>>> + * status, zero indicates success.
>>> + */
>>> +int isci_task_abort_task_set(
>>> +       struct domain_device *d_device,
>>> +       u8 *lun)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>>> +
>>> +
>>> +/**
>>> + * isci_task_clear_aca() - This function is one of the SAS Domain
>>> Template
>>> + *    functions. This is one of the Task Management functoins called by
>>> libsas.
>>> + * @d_device: This parameter specifies the domain device associated with
>>> this
>>> + *    request.
>>> + * @lun: This parameter specifies the lun       associated with this
>>> request.
>>> + *
>>> + * status, zero indicates success.
>>> + */
>>> +int isci_task_clear_aca(
>>> +       struct domain_device *d_device,
>>> +       u8 *lun)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>>> +
>>> +
>>> +
>>> +/**
>>> + * isci_task_clear_task_set() - This function is one of the SAS Domain
>>> Template
>>> + *    functions. This is one of the Task Management functoins called by
>>> libsas.
>>> + * @d_device: This parameter specifies the domain device associated with
>>> this
>>> + *    request.
>>> + * @lun: This parameter specifies the lun       associated with this
>>> request.
>>> + *
>>> + * status, zero indicates success.
>>> + */
>>> +int isci_task_clear_task_set(
>>> +       struct domain_device *d_device,
>>> +       u8 *lun)
>>> +{
>>> +       return TMF_RESP_FUNC_FAILED;
>>> +}
>> More libsas error recovery functions.
> 
> Same comment as above the driver has the little and the big recovery
> hammers, the medium hammers can be prioritized behind other fixes I
> think.
> 
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

