From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 2/6] isci: task (libsas interface support)
Date: Sun, 13 Feb 2011 23:14:50 -0800
Message-ID: <AANLkTinfhEO2uXW94S9q++D8dNjBpOy1_3s64X=ScbLY@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003445.27040.67152.stgit@localhost6.localdomain6>
	<4D52AC5A.7020206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BNHOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 02:14:52 -0500
Received: by fxm20 with SMTP id 20so4821942fxm.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 23:14:50 -0800 (PST)
In-Reply-To: <4D52AC5A.7020206@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Thanks David, comments below.

>> + =A0 =A0 =A0 if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 isci_task_complete_for_upper_layer(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAS_TASK_UNDELIVERED,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_TASK_ABORTED,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isci_perform_normal_io=
_completion
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 );
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; =A0/* The I/O was accepted (=
and failed). */
>
> Dan, is this the right status to return to libsas?
>
> Looks like it checks (->lldd_execute_task) for non-zero result.

I think this is self defense that can be deleted, how can a task be
aborted before it has even returned from the submission routine.

>
>> + =A0 =A0 =A0 }
>> + =A0 =A0 =A0 if ((task->dev =3D=3D NULL) || (task->dev->port =3D=3D=
 NULL)) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Indicate SAS_TASK_UNDELIVERED, so t=
hat the scsi
>> midlayer
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* removes the target.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 isci_task_complete_for_upper_layer(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAS_TASK_UNDELIVERED,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAS_DEVICE_UNKNOWN,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isci_perform_normal_io=
_completion
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 );
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; =A0/* The I/O was accepted (=
and failed). */
>
> Same here?

Yeah, we should always be able to dereference task->dev because ->dev
is referenced counted against outstanding commands.  If we have a task
by definition we have a dev.

[..]
>> + =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 isci_task_build_tmf(&tmf, isci_device, isci_tmf_ssp_lu=
n_reset,
>> NULL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL);
>> +
>> + =A0 =A0 =A0 #define ISCI_LU_RESET_TIMEOUT_MS 2000 /* 2 second time=
out. */
>
> Maybe move #define to isci_task.h?

Ok.

>
>> + =A0 =A0 =A0 ret =3D isci_task_execute_tmf(isci_host, &tmf,
>> ISCI_LU_RESET_TIMEOUT_MS);
>> +
>> + =A0 =A0 =A0 if (ret =3D=3D TMF_RESP_FUNC_COMPLETE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&isci_host->pdev->dev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s: %p: TMF_LU_RESET =
passed\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, isci_device)=
;
>> + =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&isci_host->pdev->dev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s: %p: TMF_LU_RESET =
failed (%x)\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, isci_device,=
 ret);
>> +
>> + =A0 =A0 =A0 return ret;
>> +}
>> +
>> +/**
>
>> +
>> +/* =A0 =A0 =A0int (*lldd_clear_nexus_port)(struct asd_sas_port *); =
*/
>> +int isci_task_clear_nexus_port(struct asd_sas_port *port)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>> +
>> +
>> +
>> +int isci_task_clear_nexus_ha(struct sas_ha_struct *ha)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>> +
>> +int isci_task_I_T_nexus_reset(struct domain_device *dev)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>> +
>
> These will be used during libsas error handling.

The driver implements abort_task, and promotes the rest to lu_reset.
Assuming the documentation is not out of date:

     A SAS LLDD should also implement at least one of the Task
     Management Functions (TMFs) described in SAM:

=2E..how urgent is the need for these other task management routines?

Speaking of mandatory libsas methods all other libsas drivers outside
of aic94xx forgo implementing

             /* Port and Adapter management */
             int (*lldd_clear_nexus_port)(struct sas_port *);
             int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);

     A SAS LLDD should implement at least one of those.

=2E..not clear that at least one of those is mandatory.

>
>
>> +/**
>> + * isci_task_abort_task() - This function is one of the SAS Domain
>> Template
>> + * =A0 =A0functions. This function is called by libsas to abort a s=
pecified
>> task.
>> + * @task: This parameter specifies the SAS task to abort.
>> + *
>> + * status, zero indicates success.
>> + */
>> +int isci_task_abort_task(struct sas_task *task)
>> +{
>
> scic_lock, flags);
>
>
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 #define ISCI_ABORT_TASK_TIMEOUT_MS 500=
 /* half second
>> timeout. */
>
> Maybe move this #define to isci_task.h?

Ok.

[..]
>> + * isci_task_abort_task_set() - This function is one of the SAS Dom=
ain
>> Template
>> + * =A0 =A0functions. This is one of the Task Management functoins c=
alled by
>> libsas,
>> + * =A0 =A0to abort all task for the given lun.
>> + * @d_device: This parameter specifies the domain device associated=
 with
>> this
>> + * =A0 =A0request.
>> + * @lun: This parameter specifies the lun associated with this requ=
est.
>> + *
>> + * status, zero indicates success.
>> + */
>> +int isci_task_abort_task_set(
>> + =A0 =A0 =A0 struct domain_device *d_device,
>> + =A0 =A0 =A0 u8 *lun)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>> +
>> +
>> +/**
>> + * isci_task_clear_aca() - This function is one of the SAS Domain
>> Template
>> + * =A0 =A0functions. This is one of the Task Management functoins c=
alled by
>> libsas.
>> + * @d_device: This parameter specifies the domain device associated=
 with
>> this
>> + * =A0 =A0request.
>> + * @lun: This parameter specifies the lun =A0 =A0 =A0 associated wi=
th this
>> request.
>> + *
>> + * status, zero indicates success.
>> + */
>> +int isci_task_clear_aca(
>> + =A0 =A0 =A0 struct domain_device *d_device,
>> + =A0 =A0 =A0 u8 *lun)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>> +
>> +
>> +
>> +/**
>> + * isci_task_clear_task_set() - This function is one of the SAS Dom=
ain
>> Template
>> + * =A0 =A0functions. This is one of the Task Management functoins c=
alled by
>> libsas.
>> + * @d_device: This parameter specifies the domain device associated=
 with
>> this
>> + * =A0 =A0request.
>> + * @lun: This parameter specifies the lun =A0 =A0 =A0 associated wi=
th this
>> request.
>> + *
>> + * status, zero indicates success.
>> + */
>> +int isci_task_clear_task_set(
>> + =A0 =A0 =A0 struct domain_device *d_device,
>> + =A0 =A0 =A0 u8 *lun)
>> +{
>> + =A0 =A0 =A0 return TMF_RESP_FUNC_FAILED;
>> +}
>
> More libsas error recovery functions.

Same comment as above the driver has the little and the big recovery
hammers, the medium hammers can be prioritized behind other fixes I
think.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
