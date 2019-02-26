From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Tue, 26 Feb 2019 18:42:58 +0530
Message-ID: <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
 <d0672a75-2900-5f6b-368f-5808914322a8@suse.de> <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
 <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 26, 2019 at 5:59 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 2/26/19 12:48 PM, Sreekanth Reddy wrote:
> > On Tue, Feb 26, 2019 at 12:38 AM Hannes Reinecke <hare@suse.de> wrote:
> >>
> >> On 2/21/19 1:11 PM, Sreekanth Reddy wrote:
> >>> During expander reset handling, the driver invokes kernel function
> >>> scsi_host_find_tag() to obtain outstanding requests associated with
> >>> the scsi host managed by the driver. Kernel=E2=80=99s block layer may=
 return
> >>> stale entry for one or more outstanding requests if blk-mq is enabled=
.
> >>> This may lead to Kernel panic if the returned value is inaccessible o=
r
> >>> the memory pointed by the returned value is reused.
> >>>
> >>> Reference of upstream discussion -
> >>> https://patchwork.kernel.org/patch/10734933/
> >>>
> >>> So to fix this issue, driver will use scsi lookup table to track
> >>> outstanding IOs at driver level and it avoids using scsi_host_find_ta=
g().
> >>>
> >>> Have done following changes in this patch,
> >>> * Allocated & initialized scsi_lookup table of type
> >>>     (struct scsiio_tracker) and of depth host's can_queue at driver l=
oad time
> >>>     and it will be deallocated at driver unload time.
> >>>
> >>> * Once scmd is received, driver will take scsiio_tracker at entry
> >>>     corresponding to scmd's tag value from scsi_lookup table. Then th=
is
> >>>     scsiio_tracker entry is initialized with proper smid, scmd, cb_id=
x etc.
> >>>     And this scsiio_tracker entry contents are cleared before driver
> >>>     calling scsi_done callback function.
> >>>
> >>> * scmd's host_scribble variable is used to save the corresponding
> >>>     scsiio_tracker address, later at any time driver can easily retri=
eve the
> >>>     scmd's corresponding scsiio_tacker using this host_scribble varia=
ble.
> >>>
> >>> * Whenever driver wants to get the outstanding IOs at the driver leve=
l
> >>>     then driver can go through this scsi_lookup table and if it obser=
ve
> >>>     any entry with non-null scmd then it means that scmd is outstandi=
ng
> >>>     at the driver level.
> >>>
> >>> v1 change set:
> >>> Updated the patch description.
> >>>
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> >>> ---
> >>>    drivers/scsi/mpt3sas/mpt3sas_base.c      | 45 ++++++++++++++++++++=
+++++++++---
> >>>    drivers/scsi/mpt3sas/mpt3sas_base.h      | 10 +++++++
> >>>    drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  2 +-
> >>>    drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 16 +++++-------
> >>>    drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  2 +-
> >>>    5 files changed, 60 insertions(+), 15 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> >>> index 0a6cb8f..8e3d0d5 100644
> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> >>> @@ -1301,7 +1301,7 @@ static int mpt3sas_remove_dead_ioc_func(void *a=
rg)
> >>>
> >>>        cmd =3D mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> >>>        if (cmd)
> >>> -             return scsi_cmd_priv(cmd);
> >>> +             return mpt3sas_get_st_from_scmd(cmd);
> >>>
> >>>        return NULL;
> >>>    }
> >>> @@ -1709,7 +1709,7 @@ static int mpt3sas_remove_dead_ioc_func(void *a=
rg)
> >>>                               struct scsi_cmnd *scmd)
> >>>    {
> >>>        struct chain_tracker *chain_req;
> >>> -     struct scsiio_tracker *st =3D scsi_cmd_priv(scmd);
> >>> +     struct scsiio_tracker *st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>        u16 smid =3D st->smid;
> >>>        u8 chain_offset =3D
> >>>           atomic_read(&ioc->chain_lookup[smid - 1].chain_offset);
> >>> @@ -3203,14 +3203,18 @@ static int mpt3sas_remove_dead_ioc_func(void =
*arg)
> >>>    mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_id=
x,
> >>>        struct scsi_cmnd *scmd)
> >>>    {
> >>> -     struct scsiio_tracker *request =3D scsi_cmd_priv(scmd);
> >>> +     struct scsiio_tracker *request;
> >>>        unsigned int tag =3D scmd->request->tag;
> >>>        u16 smid;
> >>>
> >>> +     scmd->host_scribble =3D (unsigned char *)(&ioc->scsi_lookup[tag=
]);
> >>> +     request =3D mpt3sas_get_st_from_scmd(scmd);
> >>> +
> >>>        smid =3D tag + 1;
> >>>        request->cb_idx =3D cb_idx;
> >>>        request->msix_io =3D _base_get_msix_index(ioc);
> >>>        request->smid =3D smid;
> >>> +     request->scmd =3D scmd;
> >>>        INIT_LIST_HEAD(&request->chain_list);
> >>>        return smid;
> >>>    }
> >>> @@ -3264,6 +3268,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPT=
ER *ioc,
> >>>                return;
> >>>        st->cb_idx =3D 0xFF;
> >>>        st->direct_io =3D 0;
> >>> +     st->scmd =3D NULL;
> >>>        atomic_set(&ioc->chain_lookup[st->smid - 1].chain_offset, 0);
> >>>        st->smid =3D 0;
> >>>    }
> >>> @@ -4252,6 +4257,11 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAP=
TER *ioc,
> >>>                    ioc->config_page, ioc->config_page_dma);
> >>>        }
> >>>
> >>> +     if (ioc->scsi_lookup) {
> >>> +             free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pa=
ges);
> >>> +             ioc->scsi_lookup =3D NULL;
> >>> +     }
> >>> +
> >>>        kfree(ioc->hpr_lookup);
> >>>        kfree(ioc->internal_lookup);
> >>>        if (ioc->chain_lookup) {
> >>> @@ -4377,6 +4387,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPT=
ER *ioc,
> >>>                max_request_credit =3D min_t(u16, facts->RequestCredit=
,
> >>>                    MAX_HBA_QUEUE_DEPTH);
> >>>
> >>> +retry:
> >>>        /* Firmware maintains additional facts->HighPriorityCredit num=
ber of
> >>>         * credits for HiPriprity Request messages, so hba queue depth=
 will be
> >>>         * sum of max_request_credit and high priority queue depth.
> >>> @@ -4581,9 +4592,29 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAP=
TER *ioc,
> >>>                             (unsigned long long)ioc->request_dma));
> >>>        total_sz +=3D sz;
> >>>
> >>> +     sz =3D ioc->shost->can_queue * sizeof(struct scsiio_tracker);
> >>> +     ioc->scsi_lookup_pages =3D get_order(sz);
> >>> +     ioc->scsi_lookup =3D (struct scsiio_tracker *)__get_free_pages(
> >>> +         GFP_KERNEL, ioc->scsi_lookup_pages);
> >>> +     if (!ioc->scsi_lookup) {
> >>> +             /* Retry allocating memory by reducing the queue depth =
*/
> >>> +             if ((max_request_credit - 64) >
> >>> +                 (ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT))=
 {
> >>> +                     max_request_credit -=3D 64;
> >>> +                     _base_release_memory_pools(ioc);
> >>> +                     goto retry;
> >>> +             } else {
> >>> +                     ioc_err(ioc,
> >>> +                         "scsi_lookup: get_free_pages failed, sz(%d)=
\n",
> >>> +                         (int)sz);
> >>> +                     goto out;
> >>> +             }
> >>> +     }
> >>> +
> >>>        dinitprintk(ioc,
> >>>                    ioc_info(ioc, "scsiio(0x%p): depth(%d)\n",
> >>>                             ioc->request, ioc->scsiio_depth));
> >>> +     total_sz +=3D sz;
> >>>
> >>>        ioc->chain_depth =3D min_t(u32, ioc->chain_depth, MAX_CHAIN_DE=
PTH);
> >>>        sz =3D ioc->scsiio_depth * sizeof(struct chain_lookup);
> >>> @@ -6239,6 +6270,14 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAP=
TER *ioc,
> >>>
> >>>        spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> >>>
> >>> +     smid =3D 1;
> >>> +     for (i =3D 0; i < ioc->shost->can_queue; i++, smid++) {
> >>> +             ioc->scsi_lookup[i].cb_idx =3D 0xFF;
> >>> +             ioc->scsi_lookup[i].smid =3D smid;
> >>> +             ioc->scsi_lookup[i].scmd =3D NULL;
> >>> +             ioc->scsi_lookup[i].direct_io =3D 0;
> >>> +     }
> >>> +
> >>>        /* hi-priority queue */
> >>>        INIT_LIST_HEAD(&ioc->hpr_free_list);
> >>>        smid =3D ioc->hi_priority_smid;
> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> >>> index 19158cb..f8c82f6 100644
> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> >>> @@ -816,6 +816,7 @@ struct chain_lookup {
> >>>    /**
> >>>     * struct scsiio_tracker - scsi mf request tracker
> >>>     * @smid: system message id
> >>> + * @scmd: scsi request pointer
> >>>     * @cb_idx: callback index
> >>>     * @direct_io: To indicate whether I/O is direct (WARPDRIVE)
> >>>     * @chain_list: list of associated firmware chain tracker
> >>> @@ -823,6 +824,7 @@ struct chain_lookup {
> >>>     */
> >>>    struct scsiio_tracker {
> >>>        u16     smid;
> >>> +     struct scsi_cmnd *scmd;
> >>>        u8      cb_idx;
> >>>        u8      direct_io;
> >>>        struct pcie_sg_list pcie_sg_list;
> >>> @@ -830,6 +832,12 @@ struct scsiio_tracker {
> >>>        u16     msix_io;
> >>>    };
> >>>
> >>> +static inline struct scsiio_tracker *
> >>> +mpt3sas_get_st_from_scmd(struct scsi_cmnd *scmd)
> >>> +{
> >>> +     return (struct scsiio_tracker *)scmd->host_scribble;
> >>> +}
> >>> +
> >>>    /**
> >>>     * struct request_tracker - firmware request tracker
> >>>     * @smid: system message id
> >>> @@ -1296,6 +1304,8 @@ struct MPT3SAS_ADAPTER {
> >>>        u8              *request;
> >>>        dma_addr_t      request_dma;
> >>>        u32             request_dma_sz;
> >>> +     struct scsiio_tracker *scsi_lookup;
> >>> +     ulong           scsi_lookup_pages;
> >>>        struct pcie_sg_list *pcie_sg_lookup;
> >>>        spinlock_t      scsi_lookup_lock;
> >>>        int             pending_io_count;
> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sa=
s/mpt3sas_ctl.c
> >>> index b2bb47c..ad43e60 100644
> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> >>> @@ -595,7 +595,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SA=
S_ADAPTER *ioc)
> >>>                        continue;
> >>>                if (priv_data->sas_target->handle !=3D handle)
> >>>                        continue;
> >>> -             st =3D scsi_cmd_priv(scmd);
> >>> +             st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>                tm_request->TaskMID =3D cpu_to_le16(st->smid);
> >>>                found =3D 1;
> >>>        }
> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> >>> index 8bb5b8f..86d0e3c 100644
> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >>> @@ -1465,11 +1465,9 @@ struct scsi_cmnd *
> >>>
> >>>        if (smid > 0  &&
> >>>            smid <=3D ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) =
{
> >>> -             u32 unique_tag =3D smid - 1;
> >>> -
> >>> -             scmd =3D scsi_host_find_tag(ioc->shost, unique_tag);
> >>> +             scmd =3D ioc->scsi_lookup[smid - 1].scmd;
> >>>                if (scmd) {
> >>> -                     st =3D scsi_cmd_priv(scmd);
> >>> +                     st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>                        if (st->cb_idx =3D=3D 0xFF || st->smid =3D=3D =
0)
> >>>                                scmd =3D NULL;
> >>>                }
> >>> @@ -2819,7 +2817,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SA=
S_ADAPTER *ioc, u16 handle,
> >>>    {
> >>>        struct MPT3SAS_ADAPTER *ioc =3D shost_priv(scmd->device->host)=
;
> >>>        struct MPT3SAS_DEVICE *sas_device_priv_data;
> >>> -     struct scsiio_tracker *st =3D scsi_cmd_priv(scmd);
> >>> +     struct scsiio_tracker *st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>        u16 handle;
> >>>        int r;
> >>>
> >>> @@ -4466,7 +4464,7 @@ static int _scsih_set_satl_pending(struct scsi_=
cmnd *scmd, bool pending)
> >>>                        continue;
> >>>                count++;
> >>>                _scsih_set_satl_pending(scmd, false);
> >>> -             st =3D scsi_cmd_priv(scmd);
> >>> +             st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>                mpt3sas_base_clear_st(ioc, st);
> >>>                scsi_dma_unmap(scmd);
> >>>                if (ioc->pci_error_recovery || ioc->remove_host)
> >>> @@ -5193,7 +5191,7 @@ static int _scsih_set_satl_pending(struct scsi_=
cmnd *scmd, bool pending)
> >>>         * WARPDRIVE: If direct_io is set then it is directIO,
> >>>         * the failed direct I/O should be redirected to volume
> >>>         */
> >>> -     st =3D scsi_cmd_priv(scmd);
> >>> +     st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>        if (st->direct_io &&
> >>>             ((ioc_status & MPI2_IOCSTATUS_MASK)
> >>>              !=3D MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
> >>> @@ -7335,7 +7333,7 @@ static int _scsih_set_satl_pending(struct scsi_=
cmnd *scmd, bool pending)
> >>>                scmd =3D mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> >>>                if (!scmd)
> >>>                        continue;
> >>> -             st =3D scsi_cmd_priv(scmd);
> >>> +             st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>                sdev =3D scmd->device;
> >>>                sas_device_priv_data =3D sdev->hostdata;
> >>>                if (!sas_device_priv_data || !sas_device_priv_data->sa=
s_target)
> >>> @@ -10176,7 +10174,6 @@ static void pcie_device_make_active(struct MP=
T3SAS_ADAPTER *ioc,
> >>>        .shost_attrs                    =3D mpt3sas_host_attrs,
> >>>        .sdev_attrs                     =3D mpt3sas_dev_attrs,
> >>>        .track_queue_depth              =3D 1,
> >>> -     .cmd_size                       =3D sizeof(struct scsiio_tracke=
r),
> >>>    };
> >>>
> >>>    /* raid transport support for SAS 2.0 HBA devices */
> >>> @@ -10214,7 +10211,6 @@ static void pcie_device_make_active(struct MP=
T3SAS_ADAPTER *ioc,
> >>>        .shost_attrs                    =3D mpt3sas_host_attrs,
> >>>        .sdev_attrs                     =3D mpt3sas_dev_attrs,
> >>>        .track_queue_depth              =3D 1,
> >>> -     .cmd_size                       =3D sizeof(struct scsiio_tracke=
r),
> >>>    };
> >>>
> >>>    /* raid transport support for SAS 3.0 HBA devices */
> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/=
mpt3sas/mpt3sas_warpdrive.c
> >>> index cc07ba4..2a05bf3 100644
> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
> >>> @@ -259,7 +259,7 @@
> >>>        sector_t v_lba, p_lba, stripe_off, column, io_size;
> >>>        u32 stripe_sz, stripe_exp;
> >>>        u8 num_pds, cmd =3D scmd->cmnd[0];
> >>> -     struct scsiio_tracker *st =3D scsi_cmd_priv(scmd);
> >>> +     struct scsiio_tracker *st =3D mpt3sas_get_st_from_scmd(scmd);
> >>>
> >>>        if (cmd !=3D READ_10 && cmd !=3D WRITE_10 &&
> >>>            cmd !=3D READ_16 && cmd !=3D WRITE_16)
> >>>
> >> I still think this is the wrong way of approaching it.
> >> I'd rather using blk_mq_tagset_busy_iter() here; that would avoid the
> >> issue mentioned.
> >>
> >> Let's see if I can come up with a patch.
> >
> > Hannes,
> >
> > This API blk_mq_tagset_busy_iter() is not flexible to accommodate it
> > into mpt3sas driver code. For example driver can=E2=80=99t exit from th=
is API
> > in-between if need, i.e. While processing Async Broadcast primitive
> > event if host reset occurs then driver has to wait for this
> > blk_mq_tagset_busy_iter() API to call the callback function for all
> > the outstanding requests and no way to quit in-between.
> >
> This is actually not true; the return value from the iter function
> determines if the loop should continue.
> If the iter function returns false the loop will be terminated.

Oh ok I will look it again. Also I think this function can be used
only if MQ is enabled, we can't use it in Non-MQ mode (as same fix
need for stable kernels also).
Driver's scsi lookup table mechanism works both in MQ & Non-MQ mode.

Also currently most of the customers are observing this issue with
latest kernels as MQ is enabled by default and this fix is need very
urgently.

Also in below thread we concluded that first we go with driver's scsi
lookup table mechanism, as this fix is need very urgently and in pipe
line we will work to use this  blk_mq_tagset_busy_iter() API.
Here I am copying the Kashyap reply from below thread,
"We will address this issue through <mpt3sas> driver changes in two steps.
1. I can use  driver's internal memory and will not rely on request/scsi
command. Tag 0...depth loop  is not in main IO path, so what we need is
contention free access of the list. Having driver's internal memory and
array will provide that control.
2. As you suggested best way is to use busy tag iteration.  (only for blk-m=
q
stack)"

https://patchwork.kernel.org/patch/10734933/

Thanks,
Sreekanth


>
> Cheers,
>
> Hannes
