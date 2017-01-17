From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Tue, 17 Jan 2017 19:43:51 +0530
Message-ID: <CAK=zhgpFKLWUpQMp8VOfmHsUCQiF6E54FBP2juaHYNVvR+TOmw@mail.gmail.com>
References: <20161229080250.GA11605@infradead.org> <1483226343.2518.32.camel@linux.vnet.ibm.com>
 <1483280506.5512.1.camel@sandisk.com> <20170101.113311.417107391370623850.davem@davemloft.net>
 <1483292364.2345.5.camel@linux.vnet.ibm.com> <yq1y3ypgd7m.fsf@oracle.com> <1484596878.2540.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484596878.2540.58.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 1:31 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> From 91d249409546569444897a1ffde65c421e064899 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sun, 1 Jan 2017 09:39:24 -0800
> Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
>
> mpt3sas has a firmware failure where it can only handle one pass
> through ATA command at a time.  If another comes in, contrary to the
> SAT standard, it will hang until the first one completes (causing long
> commands like secure erase to timeout).  The original fix was to block
> the device when an ATA command came in, but this caused a regression
> with
>
> commit 669f044170d8933c3d66d231b69ea97cb8447338
> Author: Bart Van Assche <bart.vanassche@sandisk.com>
> Date:   Tue Nov 22 16:17:13 2016 -0800
>
>     scsi: srp_transport: Move queuecommand() wait code to SCSI core
>
> So fix the original fix of the secure erase timeout by properly
> returning SAM_STAT_BUSY like the SAT recommends.  The original patch
> also had a concurrency problem since scsih_qcmd is lockless at that
> point (this is fixed by using atomic bitops to set and test the flag).
>
> Fixes: 18f6084a989ba1b (mpt3sas: Fix secure erase premature termination)
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> ---
>
> v2 - use bitops for lockless atomicity
> v3 - update description, change function name
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h  | 12 +++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 40 +++++++++++++++++++++++-------------
>  2 files changed, 38 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 394fe13..dcb33f4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -393,6 +393,7 @@ struct MPT3SAS_TARGET {
>   * @eedp_enable: eedp support enable bit
>   * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
>   * @eedp_block_length: block size
> + * @ata_command_pending: SATL passthrough outstanding for device
>   */
>  struct MPT3SAS_DEVICE {
>         struct MPT3SAS_TARGET *sas_target;
> @@ -404,6 +405,17 @@ struct MPT3SAS_DEVICE {
>         u8      ignore_delay_remove;
>         /* Iopriority Command Handling */
>         u8      ncq_prio_enable;
> +       /*
> +        * Bug workaround for SATL handling: the mpt2/3sas firmware
> +        * doesn't return BUSY or TASK_SET_FULL for subsequent
> +        * commands while a SATL pass through is in operation as the
> +        * spec requires, it simply does nothing with them until the
> +        * pass through completes, causing them possibly to timeout if
> +        * the passthrough is a long executing command (like format or
> +        * secure erase).  This variable allows us to do the right
> +        * thing while a SATL command is pending.
> +        */
> +       unsigned long ata_command_pending;
>
>  };
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b5c966e..830e2c1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3899,9 +3899,18 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
>         }
>  }
>
> -static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
> +static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
>  {
> -       return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
> +       struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
> +
> +       if  (scmd->cmnd[0] != ATA_12 && scmd->cmnd[0] != ATA_16)
> +               return 0;
> +
> +       if (pending)
> +               return test_and_set_bit(0, &priv->ata_command_pending);
> +
> +       clear_bit(0, &priv->ata_command_pending);
> +       return 0;
>  }
>
>  /**
> @@ -3925,9 +3934,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
>                 if (!scmd)
>                         continue;
>                 count++;
> -               if (ata_12_16_cmd(scmd))
> -                       scsi_internal_device_unblock(scmd->device,
> -                                                       SDEV_RUNNING);
> +               _scsih_set_satl_pending(scmd, false);
>                 mpt3sas_base_free_smid(ioc, smid);
>                 scsi_dma_unmap(scmd);
>                 if (ioc->pci_error_recovery)
> @@ -4063,13 +4070,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>         if (ioc->logging_level & MPT_DEBUG_SCSI)
>                 scsi_print_command(scmd);
>
> -       /*
> -        * Lock the device for any subsequent command until command is
> -        * done.
> -        */
> -       if (ata_12_16_cmd(scmd))
> -               scsi_internal_device_block(scmd->device);
> -
>         sas_device_priv_data = scmd->device->hostdata;
>         if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
>                 scmd->result = DID_NO_CONNECT << 16;
> @@ -4083,6 +4083,19 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>                 return 0;
>         }
>
> +       /*
> +        * Bug work around for firmware SATL handling.  The loop
> +        * is based on atomic operations and ensures consistency
> +        * since we're lockless at this point
> +        */
> +       do {
> +               if (sas_device_priv_data->ata_command_pending) {
> +                       scmd->result = SAM_STAT_BUSY;
> +                       scmd->scsi_done(scmd);
> +                       return 0;
> +               }
> +       } while (_scsih_set_satl_pending(scmd, true));
> +

[Sreekanth] Just for readability purpose, can use use "if (test_bit(0,
&sas_device_priv_data->ata_command_pending)"
 instead of "if (sas_device_priv_data->ata_command_pending)".
Since while setting & clearing the bit we are using atomic bit
operations. I don't see any issue functionality wise.

>         sas_target_priv_data = sas_device_priv_data->sas_target;
>
>         /* invalid device handle */
> @@ -4650,8 +4663,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>         if (scmd == NULL)
>                 return 1;
>
> -       if (ata_12_16_cmd(scmd))
> -               scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
> +       _scsih_set_satl_pending(scmd, false);
>
>         mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
>
> --
> 2.6.6
>

Tested this patch. It is working fine. Please consider this patch as

Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Thanks,
Sreekanth
