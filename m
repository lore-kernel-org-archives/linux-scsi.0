From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v2)
Date: Wed, 2 Nov 2016 15:35:11 +0530
Message-ID: <CAK=zhgpYj0TcrPK8kQ-TTqGfU=JHZbXr+2-szGf1w_XcOU3p9Q@mail.gmail.com>
References: <2179ecb8-183f-a500-4d65-10f64f0f43cc@suse.de> <1478045394-19536-1-git-send-email-andrey2805@gmail.com>
 <dbeededa-e2fc-53d3-997c-34ba1129a80b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35125 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbcKBKFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2016 06:05:13 -0400
Received: by mail-vk0-f42.google.com with SMTP id w194so8466036vkw.2
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2016 03:05:13 -0700 (PDT)
In-Reply-To: <dbeededa-e2fc-53d3-997c-34ba1129a80b@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>
Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org

On Wed, Nov 2, 2016 at 7:37 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 11/02/2016 01:09 AM, Andrey Grodzovsky wrote:
>>
>> Problem:
>> This is a work around for a bug with LSI Fusion MPT SAS2 when
>> pefroming secure erase. Due to the very long time the operation
>> takes commands issued during the erase will time out and will trigger
>> execution of abort hook. Even though the abort hook is called for
>> the specifc command which timed out this leads to entire device halt
>> (scsi_state terminated) and premature termination of the secured erase.
>>
>> Fix:
>> Set device state to busy while erase in progress to reject any incoming
>> commands until the erase is done. The device is blocked any way during
>> this time and cannot execute any other command.
>> More data and logs can be found here -
>> https://drive.google.com/file/d/0B9ocOHYHbbS1Q3VMdkkzeWFkTjg/view
>>
>> v2: Update according to example patch by Hannes Reinecke to apply
>> the blocking logic to any ATA 12/16 command.
>>
>> Signed-off-by: Andrey Grodzovsky <andrey2805@gmail.com>
>> Cc: <linux-scsi@vger.kernel.org>
>> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
>> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
>> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
>> Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index 5a97e32..43ab0cc 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -3500,6 +3500,20 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd=
,
>> u16 ioc_status)
>>             SAM_STAT_CHECK_CONDITION;
>>  }
>>
>> +/**
>> + * This is a work around for a bug with LSI Fusion MPT SAS2 when
>> + * pefroming secure erase. Due to the verly long time the operation
>> + * takes commands issued during the erase will time out and will trigge=
r
>> + * execution of abort hook. This leads to device reset and premature
>> + * termination of the secured erase.
>> + *
>> + */
>> +static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
>> +{
>> +   return (scmd->cmnd[0] =3D=3D 0xa1 || scmd->cmnd[0] =3D=3D 0x85);
>> +}
>> +
>> +
>>
>>  /**
>>   * _scsih_qcmd - main scsi request entry point
>> @@ -3528,6 +3542,14 @@ _scsih_qcmd(struct Scsi_Host *shost, struct
>> scsi_cmnd *scmd)
>>                 scsi_print_command(scmd);
>>  #endif
>>
>> +   /**
>> +       * Lock the device for any subsequent command until
>> +       * command is done.
>> +       */
>> +       if (ata_12_16_cmd(scmd))
>> +               scsi_internal_device_block(scmd->device);
>> +
>> +
>>         sas_device_priv_data =3D scmd->device->hostdata;
>>         if (!sas_device_priv_data || !sas_device_priv_data->sas_target) =
{
>>                 scmd->result =3D DID_NO_CONNECT << 16;
>> @@ -4062,6 +4084,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16
>> smid, u8 msix_index, u32 reply)
>>         if (scmd =3D=3D NULL)
>>                 return 1;
>>
>> +       if (ata_12_16_cmd(scmd))
>> +               scsi_internal_device_unblock(scmd->device, SDEV_RUNNING)=
;
>> +
>> +
>>         mpi_request =3D mpt3sas_base_get_msg_frame(ioc, smid);
>>
>>         if (mpi_reply =3D=3D NULL) {
>>
> Yeah, it's ugly, but I can't think of a better solution for the moment.
> Thanks for debugging this.

May I known the result of same test case if the SATA drive is
connected to on-bord SATA?

If it is assumed to be HBA firmware issue then it should be fixed in
the Firmware not in the driver. Have you tried with the latest HBA
Firmware image?  if it still occurs then is it possible for you to
share the firmware logs?

I think that service request has raised for this issue with Broadcom,
in this service request our support people can help you in collecting
the firmware logs and can provide the analysis of those firmware logs.

Thanks,
Sreekanth

>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
