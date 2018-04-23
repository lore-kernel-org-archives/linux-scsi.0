From: Igor Rybak <igor@media-clone.com>
Subject: RE: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination
 (v4)
Date: Mon, 23 Apr 2018 18:28:03 +0000
Message-ID: <9C0A3C06154E83419DE77BA0861EAE4F011467C3A0@MCMAIL.media-clone.com>
References: <20161110135443.GA28767@kroah.com>
 <1478788527-7372-1-git-send-email-andrey2805@gmail.com>,<CAK=zhgpUo-t=xBm93NmBf6q-VD01C2s7mqFOy-C7Vo=WABGvSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgpUo-t=xBm93NmBf6q-VD01C2s7mqFOy-C7Vo=WABGvSw@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Andrey Grodzovsky <andrey2805@gmail.com>
Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Ezra Kohavi <ezra@media-clone.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

We are running kernel 4.4.0-22 and the patch below does not seem to be present in the mpt3sas driver. Can you please confirm?
As a reminder the patch was related to a Security Erase ATA command that requires a very long timeout like 100 minutes or more and the drive retains a busy status. And the driver should not try to send other commands or reset the drive.

Thanks,

Igor Rybak
CTO
MediaClone Inc
6900 Canby Ave Ste 107
Reseda, CA 91335
USA
+1-818-654-6286
________________________________________
From: Sreekanth Reddy [sreekanth.reddy@broadcom.com]
Sent: Thursday, November 10, 2016 8:38 PM
To: Andrey Grodzovsky
Cc: PDL-MPT-FUSIONLINUX; Igor Rybak; Ezra Kohavi; linux-scsi@vger.kernel.org; Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; Hannes Reinecke; stable@vger.kernel.org
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v4)

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
