From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v4)
Date: Fri, 11 Nov 2016 10:08:41 +0530
Message-ID: <CAK=zhgpUo-t=xBm93NmBf6q-VD01C2s7mqFOy-C7Vo=WABGvSw@mail.gmail.com>
References: <20161110135443.GA28767@kroah.com> <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33670 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933491AbcKKEin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 23:38:43 -0500
Received: by mail-vk0-f48.google.com with SMTP id 137so5015817vkl.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 20:38:42 -0800 (PST)
In-Reply-To: <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>
Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Igor Rybak <igor@media-clone.com>, Ezra Kohavi <ezra@media-clone.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

On Thu, Nov 10, 2016 at 8:05 PM, Andrey Grodzovsky <andrey2805@gmail.com> wrote:
> Problem:
> This is a work around for a bug with LSI Fusion MPT SAS2 when
> pefroming secure erase. Due to the very long time the operation
> takes commands issued during the erase will time out and will trigger
> execution of abort hook. Even though the abort hook is called for
> the specific command which timed out this leads to entire device halt
> (scsi_state terminated) and premature termination of the secured erase.
>
> Fix:
> Set device state to busy while erase in progress to reject any incoming
> commands until the erase is done. The device is blocked any way during
> this time and cannot execute any other command.
> More data and logs can be found here -
> https://drive.google.com/file/d/0B9ocOHYHbbS1Q3VMdkkzeWFkTjg/view
>
> v2: Update according to example patch by Hannes Reinecke to apply
> the blocking logic to any ATA 12/16 command.
>
> v3: Use SCSI commands opcodes definitions instead of value and
> correct identation.
>
> v4: Fix checkpath errors and warning.
>
> Signed-off-by: Andrey Grodzovsky <andrey2805@gmail.com>
> Cc: <linux-scsi@vger.kernel.org>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: <stable@vger.kernel.org>

Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 5a97e32..c032319 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3500,6 +3500,10 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>             SAM_STAT_CHECK_CONDITION;
>  }
>
> +static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
> +{
> +       return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
> +}
>
>  /**
>   * _scsih_qcmd - main scsi request entry point
> @@ -3528,6 +3532,14 @@ _scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>                 scsi_print_command(scmd);
>  #endif
>
> +       /**
> +       * Lock the device for any subsequent command until
> +       * command is done.
> +       */
> +       if (ata_12_16_cmd(scmd))
> +               scsi_internal_device_block(scmd->device);
> +
> +
>         sas_device_priv_data = scmd->device->hostdata;
>         if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
>                 scmd->result = DID_NO_CONNECT << 16;
> @@ -4062,6 +4074,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>         if (scmd == NULL)
>                 return 1;
>
> +       if (ata_12_16_cmd(scmd))
> +               scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
> +
> +
>         mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
>
>         if (mpi_reply == NULL) {
> --
> 2.1.4
>
