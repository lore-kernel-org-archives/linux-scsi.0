From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 10/11] megaraid_sas : MFI MPT linked list corruption fix
Date: Fri, 12 Sep 2014 01:01:13 +0530
Message-ID: <356beeecc01b1c7572384ec3bc6aaf5e@mail.gmail.com>
References: <201409061328.s86DSC8H013387@palmhbs0.lsi.com>	<5410690F.5080204@redhat.com>
	<CAHsXFKEQwqQY9Nor2ynx-jBECyzXdFPEufZsMC6khGKoU_-9Tg@mail.gmail.com>
	<54119433.4010408@redhat.com> <CAHsXFKH_8F9JJznfBAr91EGmhddpdPbyLSP7=48tVRehhem-=w@mail.gmail.com>
 <5411F5F9.80607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:36017 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaIKTdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 15:33:53 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so10385654lbv.24
        for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2014 12:33:50 -0700 (PDT)
In-Reply-To: <5411F5F9.80607@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, jbottomley@parallels.com, aradford <aradford@gmail.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Friday, September 12, 2014 12:50 AM
> To: Kashyap Desai
> Cc: Sumit Saxena; linux-scsi@vger.kernel.org; Martin K. Petersen;
> Christoph
> Hellwig; jbottomley@parallels.com; aradford
> Subject: Re: [PATCH 10/11] megaraid_sas : MFI MPT linked list corrupt=
ion
> fix
>
> On 09/11/2014 08:41 PM, Kashyap Desai wrote:
> > On Thu, Sep 11, 2014 at 5:53 PM, Tomas Henzl <thenzl@redhat.com>
> wrote:
> >> On 09/11/2014 04:48 AM, Kashyap Desai wrote:
> >>> On Wed, Sep 10, 2014 at 8:36 PM, Tomas Henzl <thenzl@redhat.com>
> wrote:
> >>>> On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
> >>>>> Problem statement:
> >>>>> MFI link list in megaraid_sas driver is used from mfi-mpt
> >>>>> pass-through
> commands.
> >>>>> This list can be corrupted due to many possible race conditions=
 in
> >>>>> driver and eventually we may see kernel panic.
> >>>>>
> >>>>> One example -
> >>>>> MFI frame is freed from calling process as driver send command =
via
> >>>>> polling method and interrupt for that command comes after drive=
r
> >>>>> free mfi frame (actually even after some other context reuse th=
e
> >>>>> mfi frame). When driver receive MPT frame in ISR, driver will b=
e
> >>>>> using
> the index of MFI and access that MFI frame and finally in-used MFI fr=
ame=E2=80=99s
> list will be corrupted.
> >>>>>
> >>>>> High level description of new solution - Free MFI and MPT comma=
nd
> >>>>> from same context.
> >>>>> Free both the command either from process (from where mfi-mpt
> >>>>> pass-through was called) or from ISR context. Do not split free=
ing
> >>>>> of MFI and MPT, because it creates the race condition which wil=
l do
> MFI/MPT list corruption.
> >>>>>
> >>>>> Renamed the cmd_pool_lock which is used in instance as well as
> fusion with below name.
> >>>>> mfi_pool_lock and mpt_pool_lock to add more code readability.
> >>>>>
> >>>>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> >>>>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> >>>>> ---
> >>>>>  drivers/scsi/megaraid/megaraid_sas.h        |  25 +++-
> >>>>>  drivers/scsi/megaraid/megaraid_sas_base.c   | 196
> ++++++++++++++++++++--------
> >>>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  95 ++++++++++--=
--
> >>>>>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +-
> >>>>>  4 files changed, 235 insertions(+), 83 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> >>>>> b/drivers/scsi/megaraid/megaraid_sas.h
> >>>>> index 156d4b9..f99db18 100644
> >>>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
> >>>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> >>>>> @@ -1016,6 +1016,12 @@ struct megasas_ctrl_info {
> >>>>>
> >>>>>  #define VD_EXT_DEBUG 0
> >>>>>
> >>>>> +enum MR_MFI_MPT_PTHR_FLAGS {
> >>>>> +     MFI_MPT_DETACHED =3D 0,
> >>>>> +     MFI_LIST_ADDED =3D 1,
> >>>>> +     MFI_MPT_ATTACHED =3D 2,
> >>>>> +};
> >>>>> +
> >>>>>  /* Frame Type */
> >>>>>  #define IO_FRAME                             0
> >>>>>  #define PTHRU_FRAME                          1
> >>>>> @@ -1033,7 +1039,7 @@ struct megasas_ctrl_info {
> >>>>>  #define MEGASAS_IOCTL_CMD                    0
> >>>>>  #define MEGASAS_DEFAULT_CMD_TIMEOUT          90
> >>>>>  #define MEGASAS_THROTTLE_QUEUE_DEPTH         16
> >>>>> -
> >>>>> +#define MEGASAS_BLOCKED_CMD_TIMEOUT          60
> >>>>>  /*
> >>>>>   * FW reports the maximum of number of commands that it can
> accept (maximum
> >>>>>   * commands that can be outstanding) at any time. The driver m=
ust
> >>>>> report a @@ -1652,7 +1658,7 @@ struct megasas_instance {
> >>>>>       struct megasas_cmd **cmd_list;
> >>>>>       struct list_head cmd_pool;
> >>>>>       /* used to sync fire the cmd to fw */
> >>>>> -     spinlock_t cmd_pool_lock;
> >>>>> +     spinlock_t mfi_pool_lock;
> >>>>>       /* used to sync fire the cmd to fw */
> >>>>>       spinlock_t hba_lock;
> >>>>>       /* used to synch producer, consumer ptrs in dpc */ @@
> >>>>> -1839,6 +1845,11 @@ struct megasas_cmd {
> >>>>>
> >>>>>       struct list_head list;
> >>>>>       struct scsi_cmnd *scmd;
> >>>>> +
> >>>>> +     void *mpt_pthr_cmd_blocked;
> >>>>> +     atomic_t mfi_mpt_pthr;
> >>>>> +     u8 is_wait_event;
> >>>>> +
> >>>>>       struct megasas_instance *instance;
> >>>>>       union {
> >>>>>               struct {
> >>>>> @@ -1927,4 +1938,14 @@ int
> megasas_set_crash_dump_params(struct
> >>>>> megasas_instance *instance,  void
> >>>>> megasas_free_host_crash_buffer(struct megasas_instance
> *instance);
> >>>>> void megasas_fusion_crash_dump_wq(struct work_struct *work);
> >>>>>
> >>>>> +void megasas_return_cmd_fusion(struct megasas_instance
> *instance,
> >>>>> +     struct megasas_cmd_fusion *cmd); int
> >>>>> +megasas_issue_blocked_cmd(struct megasas_instance *instance,
> >>>>> +     struct megasas_cmd *cmd, int timeout); void
> >>>>> +__megasas_return_cmd(struct megasas_instance *instance,
> >>>>> +     struct megasas_cmd *cmd);
> >>>>> +
> >>>>> +void megasas_return_mfi_mpt_pthr(struct megasas_instance
> *instance,
> >>>>> +     struct megasas_cmd *cmd_mfi, struct megasas_cmd_fusion
> >>>>> +*cmd_fusion);
> >>>>> +
> >>>>>  #endif                               /*LSI_MEGARAID_SAS_H */
> >>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> >>>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
> >>>>> index 086beee..50d69eb 100644
> >>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> >>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> >>>>> @@ -210,43 +210,66 @@ struct megasas_cmd
> *megasas_get_cmd(struct megasas_instance
> >>>>>       unsigned long flags;
> >>>>>       struct megasas_cmd *cmd =3D NULL;
> >>>>>
> >>>>> -     spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> >>>>> +     spin_lock_irqsave(&instance->mfi_pool_lock, flags);
> >>>>>
> >>>>>       if (!list_empty(&instance->cmd_pool)) {
> >>>>>               cmd =3D list_entry((&instance->cmd_pool)->next,
> >>>>>                                struct megasas_cmd, list);
> >>>>>               list_del_init(&cmd->list);
> >>>>> +             atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_DETACHED);
> >>>>>       } else {
> >>>>>               printk(KERN_ERR "megasas: Command pool empty!\n")=
;
> >>>>>       }
> >>>>>
> >>>>> -     spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> >>>>> +     spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
> >>>>>       return cmd;
> >>>>>  }
> >>>>>
> >>>>>  /**
> >>>>> - * megasas_return_cmd -      Return a cmd to free command pool
> >>>>> + * __megasas_return_cmd -    Return a cmd to free command pool
> >>>>>   * @instance:                Adapter soft state
> >>>>>   * @cmd:             Command packet to be returned to free com=
mand
> pool
> >>>>>   */
> >>>>>  inline void
> >>>>> -megasas_return_cmd(struct megasas_instance *instance, struct
> >>>>> megasas_cmd *cmd)
> >>>>> +__megasas_return_cmd(struct megasas_instance *instance, struct
> >>>>> +megasas_cmd *cmd)
> >>>>>  {
> >>>>> -     unsigned long flags;
> >>>>> -
> >>>>> -     spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> >>>>> +     /*
> >>>>> +      * Don't go ahead and free the MFI frame, if correspondin=
g
> >>>>> +      * MPT frame is not freed(valid for only fusion adapters)=
=2E
> >>>>> +      * In case of MFI adapters, anyways for any allocated MFI
> >>>>> +      * frame will have cmd->mfi_mpt_mpthr set to
> MFI_MPT_DETACHED
> >>>>> +      */
> >>>>> +     if (atomic_read(&cmd->mfi_mpt_pthr) !=3D MFI_MPT_DETACHED=
)
> >>>>> +             return;
> >>>>>
> >>>>>       cmd->scmd =3D NULL;
> >>>>>       cmd->frame_count =3D 0;
> >>>>> +     cmd->is_wait_event =3D 0;
> >>>>> +     cmd->mpt_pthr_cmd_blocked =3D NULL;
> >>>>> +
> >>>>>       if ((instance->pdev->device !=3D PCI_DEVICE_ID_LSI_FUSION=
) &&
> >>>>> -         (instance->pdev->device !=3D PCI_DEVICE_ID_LSI_PLASMA=
) &&
> >>>>>           (instance->pdev->device !=3D PCI_DEVICE_ID_LSI_INVADE=
R) &&
> >>>>>           (instance->pdev->device !=3D PCI_DEVICE_ID_LSI_FURY) =
&&
> >>>>>           (reset_devices))
> >>>>>               cmd->frame->hdr.cmd =3D MFI_CMD_INVALID;
> >>>>> -     list_add_tail(&cmd->list, &instance->cmd_pool);
> >>>>>
> >>>>> -     spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> >>>>> +     atomic_set(&cmd->mfi_mpt_pthr, MFI_LIST_ADDED);
> >>>>> +     list_add(&cmd->list, (&instance->cmd_pool)->next); }
> >>>>> +
> >>>>> +/**
> >>>>> + * megasas_return_cmd -      Return a cmd to free command pool
> >>>>> + * @instance:                Adapter soft state
> >>>>> + * @cmd:             Command packet to be returned to free com=
mand
> pool
> >>>>> + */
> >>>>> +inline void
> >>>>> +megasas_return_cmd(struct megasas_instance *instance, struct
> >>>>> +megasas_cmd *cmd) {
> >>>>> +     unsigned long flags;
> >>>>> +
> >>>>> +     spin_lock_irqsave(&instance->mfi_pool_lock, flags);
> >>>>> +     __megasas_return_cmd(instance, cmd);
> >>>>> +     spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
> >>>>>  }
> >>>>>
> >>>>>
> >>>>> @@ -925,13 +948,14 @@ megasas_issue_polled(struct
> megasas_instance *instance, struct megasas_cmd *cmd)
> >>>>>   * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
> >>>>>   * Used to issue ioctl commands.
> >>>>>   */
> >>>>> -static int
> >>>>> +int
> >>>>>  megasas_issue_blocked_cmd(struct megasas_instance *instance,
> >>>>>                         struct megasas_cmd *cmd, int timeout)  =
{
> >>>>>       int ret =3D 0;
> >>>>>       cmd->cmd_status =3D ENODATA;
> >>>>>
> >>>>> +     cmd->is_wait_event =3D 1;
> >>>>>       instance->instancet->issue_dcmd(instance, cmd);
> >>>>>       if (timeout) {
> >>>>>               ret =3D wait_event_timeout(instance->int_cmd_wait=
_q,
> >>>>> @@ -1903,7 +1927,12 @@ out:
> >>>>>                                   new_affiliation_111,
> >>>>>                                   new_affiliation_111_h);
> >>>>>       }
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return retval;
> >>>>>  }
> >>>>> @@ -2070,7 +2099,11 @@ out:
> >>>>>                                   (MAX_LOGICAL_DRIVES + 1) *
> >>>>>                                   sizeof(struct
> >>>>> MR_LD_VF_AFFILIATION),
> >>>>>                                   new_affiliation,
> >>>>> new_affiliation_h);
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return retval;
> >>>>>  }
> >>>>> @@ -2530,7 +2563,12 @@ megasas_service_aen(struct
> megasas_instance *instance, struct megasas_cmd *cmd)
> >>>>>               cmd->abort_aen =3D 0;
> >>>>>
> >>>>>       instance->aen_cmd =3D NULL;
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       if ((instance->unload =3D=3D 0) &&
> >>>>>               ((instance->issuepend_done =3D=3D 1))) { @@ -2906=
,7
> >>>>> +2944,8 @@ megasas_complete_cmd(struct megasas_instance
> *instance, struct megasas_cmd *cmd,
> >>>>>                                              "failed, status =3D
> >>>>> 0x%x.\n",
> >>>>>
> >>>>> cmd->frame->hdr.cmd_status);
> >>>>>                               else {
> >>>>> -                                     megasas_return_cmd(instan=
ce,
> >>>>> cmd);
> >>>>> +
> >>>>> megasas_return_mfi_mpt_pthr(instance,
> >>>>> +                                             cmd,
> >>>>> + cmd->mpt_pthr_cmd_blocked);
> >>>>>                                       spin_unlock_irqrestore(
> >>>>>
> >>>>> instance->host->host_lock,
> >>>>>                                               flags); @@ -2914,=
7
> >>>>> +2953,8 @@ megasas_complete_cmd(struct megasas_instance
> *instance, struct megasas_cmd *cmd,
> >>>>>                               }
> >>>>>                       } else
> >>>>>                               instance->map_id++;
> >>>>> -                     megasas_return_cmd(instance, cmd);
> >>>>> +                     megasas_return_mfi_mpt_pthr(instance, cmd=
,
> >>>>> +                             cmd->mpt_pthr_cmd_blocked);
> >>>>>
> >>>>>                       /*
> >>>>>                        * Set fast path IO to ZERO.
> >>>>> @@ -3070,7 +3110,7 @@ megasas_internal_reset_defer_cmds(struct
> megasas_instance *instance)
> >>>>>       unsigned long flags;
> >>>>>
> >>>>>       defer_index     =3D 0;
> >>>>> -     spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> >>>>> +     spin_lock_irqsave(&instance->mfi_pool_lock, flags);
> >>>>>       for (i =3D 0; i < max_cmd; i++) {
> >>>>>               cmd =3D instance->cmd_list[i];
> >>>>>               if (cmd->sync_cmd =3D=3D 1 || cmd->scmd) { @@ -30=
91,7
> >>>>> +3131,7 @@ megasas_internal_reset_defer_cmds(struct
> megasas_instance *instance)
> >>>>>                               &instance->internal_reset_pending=
_q);
> >>>>>               }
> >>>>>       }
> >>>>> -     spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> >>>>> +     spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
> >>>>>  }
> >>>>>
> >>>>>
> >>>>> @@ -3656,7 +3696,9 @@ int megasas_alloc_cmds(struct
> megasas_instance *instance)
> >>>>>       int j;
> >>>>>       u32 max_cmd;
> >>>>>       struct megasas_cmd *cmd;
> >>>>> +     struct fusion_context *fusion;
> >>>>>
> >>>>> +     fusion =3D instance->ctrl_context;
> >>>>>       max_cmd =3D instance->max_mfi_cmds;
> >>>>>
> >>>>>       /*
> >>>>> @@ -3689,13 +3731,11 @@ int megasas_alloc_cmds(struct
> megasas_instance *instance)
> >>>>>               }
> >>>>>       }
> >>>>>
> >>>>> -     /*
> >>>>> -      * Add all the commands to command pool (instance->cmd_po=
ol)
> >>>>> -      */
> >>>>>       for (i =3D 0; i < max_cmd; i++) {
> >>>>>               cmd =3D instance->cmd_list[i];
> >>>>>               memset(cmd, 0, sizeof(struct megasas_cmd));
> >>>>>               cmd->index =3D i;
> >>>>> +             atomic_set(&cmd->mfi_mpt_pthr, MFI_LIST_ADDED);
> >>>>>               cmd->scmd =3D NULL;
> >>>>>               cmd->instance =3D instance;
> >>>>>
> >>>>> @@ -3766,11 +3806,11 @@ megasas_get_pd_list(struct
> megasas_instance *instance)
> >>>>>       dcmd->sgl.sge32[0].phys_addr =3D cpu_to_le32(ci_h);
> >>>>>       dcmd->sgl.sge32[0].length =3D cpu_to_le32(MEGASAS_MAX_PD =
*
> >>>>> sizeof(struct MR_PD_LIST));
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd)) {
> >>>>> -             ret =3D 0;
> >>>>> -     } else {
> >>>>> -             ret =3D -1;
> >>>>> -     }
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>> +     else
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>>
> >>>>>       /*
> >>>>>       * the following function will get the instance PD LIST.
> >>>>> @@ -3802,7 +3842,12 @@ megasas_get_pd_list(struct
> megasas_instance *instance)
> >>>>>       pci_free_consistent(instance->pdev,
> >>>>>                               MEGASAS_MAX_PD * sizeof(struct
> >>>>> MR_PD_LIST),
> >>>>>                               ci, ci_h);
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return ret;
> >>>>>  }
> >>>>> @@ -3861,11 +3906,12 @@ megasas_get_ld_list(struct
> megasas_instance *instance)
> >>>>>       dcmd->sgl.sge32[0].length =3D cpu_to_le32(sizeof(struct
> MR_LD_LIST));
> >>>>>       dcmd->pad_0  =3D 0;
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd)) {
> >>>>> -             ret =3D 0;
> >>>>> -     } else {
> >>>>> -             ret =3D -1;
> >>>>> -     }
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>> +     else
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>> +
> >>>>>
> >>>>>       ld_count =3D le32_to_cpu(ci->ldCount);
> >>>>>
> >>>>> @@ -3888,7 +3934,11 @@ megasas_get_ld_list(struct
> megasas_instance *instance)
> >>>>>                               ci,
> >>>>>                               ci_h);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>       return ret;
> >>>>>  }
> >>>>>
> >>>>> @@ -3949,12 +3999,11 @@ megasas_ld_list_query(struct
> megasas_instance *instance, u8 query_type)
> >>>>>       dcmd->sgl.sge32[0].length =3D cpu_to_le32(sizeof(struct
> MR_LD_TARGETID_LIST));
> >>>>>       dcmd->pad_0  =3D 0;
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd) && !dcmd->cmd_st=
atus)
> {
> >>>>> -             ret =3D 0;
> >>>>> -     } else {
> >>>>> -             /* On failure, call older LD list DCMD */
> >>>>> -             ret =3D 1;
> >>>>> -     }
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>> +     else
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>>
> >>>>>       tgtid_count =3D le32_to_cpu(ci->count);
> >>>>>
> >>>>> @@ -3970,7 +4019,11 @@ megasas_ld_list_query(struct
> megasas_instance *instance, u8 query_type)
> >>>>>       pci_free_consistent(instance->pdev, sizeof(struct
> MR_LD_TARGETID_LIST),
> >>>>>                           ci, ci_h);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return ret;
> >>>>>  }
> >>>>> @@ -4027,17 +4080,23 @@ megasas_get_ctrl_info(struct
> megasas_instance *instance,
> >>>>>       dcmd->sgl.sge32[0].length =3D cpu_to_le32(sizeof(struct
> megasas_ctrl_info));
> >>>>>       dcmd->mbox.b[0] =3D 1;
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd)) {
> >>>>> -             ret =3D 0;
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>> +     else
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>> +
> >>>>> +     if (!ret)
> >>>>>               memcpy(ctrl_info, ci, sizeof(struct
> >>>>> megasas_ctrl_info));
> >>>>> -     } else {
> >>>>> -             ret =3D -1;
> >>>>> -     }
> >>>>>
> >>>>>       pci_free_consistent(instance->pdev, sizeof(struct
> megasas_ctrl_info),
> >>>>>                           ci, ci_h);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>       return ret;
> >>>>>  }
> >>>>>
> >>>>> @@ -4086,11 +4145,17 @@ int
> megasas_set_crash_dump_params(struct megasas_instance *instance,
> >>>>>       dcmd->sgl.sge32[0].phys_addr =3D cpu_to_le32(instance-
> >crash_dump_h);
> >>>>>       dcmd->sgl.sge32[0].length =3D
> cpu_to_le32(CRASH_DMA_BUF_SIZE);
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd))
> >>>>> -             ret =3D 0;
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>>       else
> >>>>> -             ret =3D -1;
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>> +
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>       return ret;
> >>>>>  }
> >>>>>
> >>>>> @@ -4660,7 +4725,11 @@ megasas_get_seq_num(struct
> megasas_instance *instance,
> >>>>>       pci_free_consistent(instance->pdev, sizeof(struct
> megasas_evt_log_info),
> >>>>>                           el_info, el_info_h);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return 0;
> >>>>>  }
> >>>>> @@ -5015,7 +5084,7 @@ static int megasas_probe_one(struct
> pci_dev *pdev,
> >>>>>               }
> >>>>>               fusion =3D instance->ctrl_context;
> >>>>>               INIT_LIST_HEAD(&fusion->cmd_pool);
> >>>>> -             spin_lock_init(&fusion->cmd_pool_lock);
> >>>>> +             spin_lock_init(&fusion->mpt_pool_lock);
> >>>>>               memset(fusion->load_balance_info, 0,
> >>>>>                       sizeof(struct LD_LOAD_BALANCE_INFO) *
> MAX_LOGICAL_DRIVES_EXT);
> >>>>>       }
> >>>>> @@ -5084,7 +5153,7 @@ static int megasas_probe_one(struct
> pci_dev *pdev,
> >>>>>       init_waitqueue_head(&instance->int_cmd_wait_q);
> >>>>>       init_waitqueue_head(&instance->abort_cmd_wait_q);
> >>>>>
> >>>>> -     spin_lock_init(&instance->cmd_pool_lock);
> >>>>> +     spin_lock_init(&instance->mfi_pool_lock);
> >>>>>       spin_lock_init(&instance->hba_lock);
> >>>>>       spin_lock_init(&instance->completion_lock);
> >>>>>
> >>>>> @@ -5104,7 +5173,7 @@ static int megasas_probe_one(struct
> pci_dev *pdev,
> >>>>>               instance->flag_ieee =3D 1;
> >>>>>               sema_init(&instance->ioctl_sem,
> MEGASAS_SKINNY_INT_CMDS);
> >>>>>       } else
> >>>>> -             sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS)=
;
> >>>>> +             sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS=
 -
> >>>>> + 5));
> >>>>>
> >>>>>       megasas_dbg_lvl =3D 0;
> >>>>>       instance->flag =3D 0;
> >>>>> @@ -5316,7 +5385,11 @@ static void megasas_flush_cache(struct
> megasas_instance *instance)
> >>>>>               dev_err(&instance->pdev->dev, "Command timedout"
> >>>>>                       " from %s\n", __func__);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return;
> >>>>>  }
> >>>>> @@ -5363,7 +5436,11 @@ static void
> megasas_shutdown_controller(struct megasas_instance *instance,
> >>>>>               dev_err(&instance->pdev->dev, "Command timedout"
> >>>>>                       "from %s\n", __func__);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return;
> >>>>>  }
> >>>>> @@ -6024,9 +6101,14 @@ megasas_mgmt_fw_ioctl(struct
> megasas_instance *instance,
> >>>>>
> >>>>> le32_to_cpu(kern_sge32[i].length),
> >>>>>                                         kbuff_arr[i],
> >>>>>
> >>>>> le32_to_cpu(kern_sge32[i].phys_addr));
> >>>>> +                     kbuff_arr[i] =3D NULL;
> >>>>>       }
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>       return error;
> >>>>>  }
> >>>>>
> >>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>>>> index a3de45a..e8f4f6c 100644
> >>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>>>> @@ -50,6 +50,7 @@
> >>>>>  #include <scsi/scsi_cmnd.h>
> >>>>>  #include <scsi/scsi_device.h>
> >>>>>  #include <scsi/scsi_host.h>
> >>>>> +#include <scsi/scsi_dbg.h>
> >>>>>
> >>>>>  #include "megaraid_sas_fusion.h"
> >>>>>  #include "megaraid_sas.h"
> >>>>> @@ -163,7 +164,7 @@ struct megasas_cmd_fusion
> *megasas_get_cmd_fusion(struct megasas_instance
> >>>>>               (struct fusion_context *)instance->ctrl_context;
> >>>>>       struct megasas_cmd_fusion *cmd =3D NULL;
> >>>>>
> >>>>> -     spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
> >>>>> +     spin_lock_irqsave(&fusion->mpt_pool_lock, flags);
> >>>>>
> >>>>>       if (!list_empty(&fusion->cmd_pool)) {
> >>>>>               cmd =3D list_entry((&fusion->cmd_pool)->next,
> >>>>> @@ -173,7 +174,7 @@ struct megasas_cmd_fusion
> *megasas_get_cmd_fusion(struct megasas_instance
> >>>>>               printk(KERN_ERR "megasas: Command pool (fusion)
> empty!\n");
> >>>>>       }
> >>>>>
> >>>>> -     spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
> >>>>> +     spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags);
> >>>>>       return cmd;
> >>>>>  }
> >>>>>
> >>>>> @@ -182,21 +183,41 @@ struct megasas_cmd_fusion
> *megasas_get_cmd_fusion(struct megasas_instance
> >>>>>   * @instance:                Adapter soft state
> >>>>>   * @cmd:             Command packet to be returned to free com=
mand
> pool
> >>>>>   */
> >>>>> -static inline void
> >>>>> -megasas_return_cmd_fusion(struct megasas_instance *instance,
> >>>>> -                       struct megasas_cmd_fusion *cmd)
> >>>>> +inline void megasas_return_cmd_fusion(struct megasas_instance
> *instance,
> >>>>> +     struct megasas_cmd_fusion *cmd)
> >>>>>  {
> >>>>>       unsigned long flags;
> >>>>>       struct fusion_context *fusion =3D
> >>>>>               (struct fusion_context *)instance->ctrl_context;
> >>>>>
> >>>>> -     spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
> >>>>> +     spin_lock_irqsave(&fusion->mpt_pool_lock, flags);
> >>>>>
> >>>>>       cmd->scmd =3D NULL;
> >>>>>       cmd->sync_cmd_idx =3D (u32)ULONG_MAX;
> >>>>> -     list_add_tail(&cmd->list, &fusion->cmd_pool);
> >>>>> +     list_add(&cmd->list, (&fusion->cmd_pool)->next);
> >>>>> +
> >>>>> +     spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags); }
> >>>>> +
> >>>>> +/**
> >>>>> + * megasas_return_mfi_mpt_pthr - Return a mfi and mpt to free
> command pool
> >>>>> + * @instance:                Adapter soft state
> >>>>> + * @cmd_mfi:         MFI Command packet to be returned to free
> command pool
> >>>>> + * @cmd_mpt:         MPT Command packet to be returned to free
> command pool
> >>>>> + */
> >>>>> +inline void megasas_return_mfi_mpt_pthr(struct megasas_instanc=
e
> *instance,
> >>>>> +     struct megasas_cmd *cmd_mfi, struct megasas_cmd_fusion
> >>>>> +*cmd_fusion) {
> >>>>> +     unsigned long flags;
> >>>>>
> >>>>> -     spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
> >>>>> +     spin_lock_irqsave(&instance->mfi_pool_lock, flags);
> >>>>> +     megasas_return_cmd_fusion(instance, cmd_fusion);
> >>>> Is the lock needed in this place for megasas_return_cmd_fusion (=
it
> >>>> uses another lock inside)
> >>> Issue what we are trying to fix is very unusual.  Driver fetch th=
e
> >>> MFI frame and MPT frame from different pool.
> >>> and link it via sync_cmd_idx.
> >>>
> >>> Driver send MFI-MPT Pass through command and do completion in syn=
c
> >>> (Just do polling on status) or async (complete from ISR via wakeu=
p
> >>> call) method.  While completing in sync method (In Ideal case we
> >>> should not get interrupt as caller do not expect it), there are
> >>> cases (Due to some known workaround specific to MR) where interru=
pts
> >>> are enabled and completion comes from ISR path as well.
> >>>
> >>> As current driver do not complete MFI and MPT at same time, we en=
d
> >>> up in link corruption because lots of places driver access frame =
via
> >>> sync_cmd_idx.
> >>>
> >>> Since driver does not use common lock for MFI-MPT pool we have to
> >>> still keep both the lock to avoid any issue with older
> >>> controllers.(which are only MFI based and no MPT pool). I thought=
 of
> >>> doing with only mfi_pool_lock() for Fusion controller and complet=
ely
> >>> remove mpt_pool_lock(). To do that, we need lots of code changes =
in
> >>> driver just to support code around callback issue_dcmd().
> >>> There is legacy code for older controller which does not allow
> >>> smooth changes to use single lock for both mpt and mfi frame, so =
we
> >>> continue with both the lock as this is not coming under IO Path +
> >>> adding code change like this will not cause much regression issue=
s.
> >> Yes, and all that is the reason why you have in __megasas_return_c=
md
> >> this test "if (atomic_read(&cmd->mfi_mpt_pthr) !=3D
> MFI_MPT_DETACHED) return;"
> > This particular check is to avoid freeing mfi and mpt as a separate
> command.
> > If we hit this condition, it means... driver will later free this
> > command so caller can skip this.
> >
> >> You free both linked mfi+mpt from this function, so when you are h=
ere
> >> you know that no one else uses these two commands, correct?
> >> That means you don't need to hold both locks when when freeing the
> >> first command.
> > We still operate in two different frame pool, so those individual
> > frame need respective locks.
>
> Yes megasas_return_cmd_fusion uses mpt_pool_lock and
> _megasas_return_cmd the  mfi_pool_lock - that is OK.
> I commented the fact that you take here the mfi_pool_lock for
> megasas_return_cmd_fusion even though it has it's own mpt_pool_lock.

Correct... just need to be careful here so will try it in next phase.

>
> As I already said I accept the code as it is.
>
> I will  tomorrow check if the series is complete. Do you want to repo=
st
> any
> patches?
=46or this patch will only add comment in code for to-do item.

We will send one more Resend patch series to make sure we address all
comments for this patch series.

> (I lost the overview a bit) and add he formal reviewed-by.
Just to avoid confusion will resend whole patch series. In header will
mentioned what has been changed from earlier version of the patch.
 + formal review by tag.


>
> Tomas
>
> > the
> > We can either remove mpt lock completely and use mfi lock throughou=
t
> > to avoid this two level of locking.
> >
> > We can plan to remove mpt_pool_lock and use only mfi_pool_lock (wit=
h
> > some rename of this variable) even if driver wants to grab mfi OR m=
pt
> > frame use the single lock for both the pool... we just need to keep
> > things working for older controllers as well.
> >
> > Let me mark this as To-do (probably will add comment in code) and o=
nce
> > we have any progress we will post add-on patch for this.
> >
> > Kashyap
> >
> >> It's is not a bug holding both locks at once, it is just not neces=
sary.
> >> If you prefer the code as it is, I can accept it too.
> >>
> >> tomash
> >>
> >>> ~ Kashyap
> >>>
> >>>>> +     if (atomic_read(&cmd_mfi->mfi_mpt_pthr) !=3D
> MFI_MPT_ATTACHED)
> >>>>> +             dev_err(&instance->pdev->dev, "Possible bug from =
%s
> %d\n",
> >>>>> +                     __func__, __LINE__);
> >>>>> +     atomic_set(&cmd_mfi->mfi_mpt_pthr, MFI_MPT_DETACHED);
> >>>>> +     __megasas_return_cmd(instance, cmd_mfi);
> >>>> And the lock could be moved here?
> >>> Covered in above inline reply.
> >>>
> >>>> Thanks,
> >>>> Tomas
> >>>>
> >>>>> +     spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
> >>>>>  }
> >>>>>
> >>>>>  /**
> >>>>> @@ -562,9 +583,11 @@ wait_and_poll(struct megasas_instance
> >>>>> *instance, struct megasas_cmd *cmd,  {
> >>>>>       int i;
> >>>>>       struct megasas_header *frame_hdr =3D &cmd->frame->hdr;
> >>>>> +     struct fusion_context *fusion;
> >>>>>
> >>>>>       u32 msecs =3D seconds * 1000;
> >>>>>
> >>>>> +     fusion =3D instance->ctrl_context;
> >>>>>       /*
> >>>>>        * Wait for cmd_status to change
> >>>>>        */
> >>>>> @@ -573,8 +596,12 @@ wait_and_poll(struct megasas_instance
> *instance, struct megasas_cmd *cmd,
> >>>>>               msleep(20);
> >>>>>       }
> >>>>>
> >>>>> -     if (frame_hdr->cmd_status =3D=3D 0xff)
> >>>>> +     if (frame_hdr->cmd_status =3D=3D 0xff) {
> >>>>> +             if (fusion)
> >>>>> +                     megasas_return_mfi_mpt_pthr(instance, cmd=
,
> >>>>> +                             cmd->mpt_pthr_cmd_blocked);
> >>>>>               return -ETIME;
> >>>>> +     }
> >>>>>
> >>>>>       return 0;
> >>>>>  }
> >>>>> @@ -777,14 +804,17 @@ megasas_get_ld_map_info(struct
> megasas_instance *instance)
> >>>>>       dcmd->sgl.sge32[0].phys_addr =3D cpu_to_le32(ci_h);
> >>>>>       dcmd->sgl.sge32[0].length =3D cpu_to_le32(size_map_info);
> >>>>>
> >>>>> -     if (!megasas_issue_polled(instance, cmd))
> >>>>> -             ret =3D 0;
> >>>>> -     else {
> >>>>> -             printk(KERN_ERR "megasas: Get LD Map Info Failed\=
n");
> >>>>> -             ret =3D -1;
> >>>>> -     }
> >>>>> +     if (instance->ctrl_context && !instance->mask_interrupts)
> >>>>> +             ret =3D megasas_issue_blocked_cmd(instance, cmd,
> >>>>> +                     MEGASAS_BLOCKED_CMD_TIMEOUT);
> >>>>> +     else
> >>>>> +             ret =3D megasas_issue_polled(instance, cmd);
> >>>>>
> >>>>> -     megasas_return_cmd(instance, cmd);
> >>>>> +     if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
> >>>>> +             megasas_return_mfi_mpt_pthr(instance, cmd,
> >>>>> +                     cmd->mpt_pthr_cmd_blocked);
> >>>>> +     else
> >>>>> +             megasas_return_cmd(instance, cmd);
> >>>>>
> >>>>>       return ret;
> >>>>>  }
> >>>>> @@ -2020,10 +2050,19 @@ complete_cmd_fusion(struct
> megasas_instance *instance, u32 MSIxIndex)
> >>>>>                       break;
> >>>>>               case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST:
> /*MFI command */
> >>>>>                       cmd_mfi =3D
> >>>>> instance->cmd_list[cmd_fusion->sync_cmd_idx];
> >>>>> +
> >>>>> +                     if (!cmd_mfi->mpt_pthr_cmd_blocked) {
> >>>>> +                             if (megasas_dbg_lvl =3D=3D 5)
> >>>>> +                                     dev_info(&instance->pdev-=
>dev,
> >>>>> +                                             "freeing mfi/mpt
> >>>>> pass-through "
> >>>>> +                                             "from %s %d\n",
> >>>>> +                                              __func__, __LINE=
__);
> >>>>> +                             megasas_return_mfi_mpt_pthr(insta=
nce,
> >>>>> cmd_mfi,
> >>>>> +                                     cmd_fusion);
> >>>>> +                     }
> >>>>> +
> >>>>>                       megasas_complete_cmd(instance, cmd_mfi,
> >>>>> DID_OK);
> >>>>>                       cmd_fusion->flags =3D 0;
> >>>>> -                     megasas_return_cmd_fusion(instance,
> >>>>> cmd_fusion);
> >>>>> -
> >>>>>                       break;
> >>>>>               }
> >>>>>
> >>>>> @@ -2183,6 +2222,7 @@ build_mpt_mfi_pass_thru(struct
> megasas_instance *instance,
> >>>>>       struct megasas_cmd_fusion *cmd;
> >>>>>       struct fusion_context *fusion;
> >>>>>       struct megasas_header *frame_hdr =3D &mfi_cmd->frame->hdr=
;
> >>>>> +     u32 opcode;
> >>>>>
> >>>>>       cmd =3D megasas_get_cmd_fusion(instance);
> >>>>>       if (!cmd)
> >>>>> @@ -2190,9 +2230,20 @@ build_mpt_mfi_pass_thru(struct
> >>>>> megasas_instance *instance,
> >>>>>
> >>>>>       /*  Save the smid. To be used for returning the cmd */
> >>>>>       mfi_cmd->context.smid =3D cmd->index;
> >>>>> -
> >>>>>       cmd->sync_cmd_idx =3D mfi_cmd->index;
> >>>>>
> >>>>> +     /* Set this only for Blocked commands */
> >>>>> +     opcode =3D le32_to_cpu(mfi_cmd->frame->dcmd.opcode);
> >>>>> +     if ((opcode =3D=3D MR_DCMD_LD_MAP_GET_INFO)
> >>>>> +             && (mfi_cmd->frame->dcmd.mbox.b[1] =3D=3D 1))
> >>>>> +             mfi_cmd->is_wait_event =3D 1;
> >>>>> +
> >>>>> +     if (opcode =3D=3D MR_DCMD_CTRL_EVENT_WAIT)
> >>>>> +             mfi_cmd->is_wait_event =3D 1;
> >>>>> +
> >>>>> +     if (mfi_cmd->is_wait_event)
> >>>>> +             mfi_cmd->mpt_pthr_cmd_blocked =3D cmd;
> >>>>> +
> >>>>>       /*
> >>>>>        * For cmds where the flag is set, store the flag and che=
ck
> >>>>>        * on completion. For cmds with this flag, don't call @@
> >>>>> -2281,6 +2332,7 @@ megasas_issue_dcmd_fusion(struct
> megasas_instance *instance,
> >>>>>               printk(KERN_ERR "Couldn't issue MFI pass thru cmd=
\n");
> >>>>>               return;
> >>>>>       }
> >>>>> +     atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_ATTACHED);
> >>>>>       instance->instancet->fire_cmd(instance, req_desc->u.low,
> >>>>>                                     req_desc->u.high,
> >>>>> instance->reg_set);  } @@ -2752,10 +2804,7 @@ int
> >>>>> megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
> >>>>>
> >>>>> cmd_list[cmd_fusion->sync_cmd_idx];
> >>>>>                                       if
> >>>>> (cmd_mfi->frame->dcmd.opcode =3D=3D
> >>>>>
> >>>>> cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) {
> >>>>> -
> >>>>> megasas_return_cmd(instance,
> >>>>> -
> >>>>> cmd_mfi);
> >>>>> -
> >>>>> megasas_return_cmd_fusion(
> >>>>> -                                                     instance,
> >>>>> cmd_fusion);
> >>>>> +
> >>>>> + megasas_return_mfi_mpt_pthr(instance, cmd_mfi, cmd_fusion);
> >>>>>                                       } else  {
> >>>>>                                               req_desc =3D
> >>>>>
> >>>>> megasas_get_request_descriptor( diff --git
> >>>>> a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> >>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> >>>>> index a72fa19..9822de2 100644
> >>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> >>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> >>>>> @@ -800,7 +800,7 @@ struct fusion_context {
> >>>>>       struct megasas_cmd_fusion **cmd_list;
> >>>>>       struct list_head cmd_pool;
> >>>>>
> >>>>> -     spinlock_t cmd_pool_lock;
> >>>>> +     spinlock_t mpt_pool_lock;
> >>>>>
> >>>>>       dma_addr_t req_frames_desc_phys;
> >>>>>       u8 *req_frames_desc;
> >>>
> >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
