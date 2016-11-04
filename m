From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v2)
Date: Fri, 4 Nov 2016 18:15:32 +0530
Message-ID: <CAK=zhgra2zDZon5fuW1OwQfJ_2ExkAzcsKGiuBJaLYX6sMoTCQ@mail.gmail.com>
References: <2179ecb8-183f-a500-4d65-10f64f0f43cc@suse.de> <1478045394-19536-1-git-send-email-andrey2805@gmail.com>
 <dbeededa-e2fc-53d3-997c-34ba1129a80b@suse.de> <CAK=zhgpYj0TcrPK8kQ-TTqGfU=JHZbXr+2-szGf1w_XcOU3p9Q@mail.gmail.com>
 <CAJphD_qrQftfCOn_uzXCfdX=Xv9BYvVQ60AZ4DR2rc3gfXQa_Q@mail.gmail.com> <30w645ulbhlofxrk1h4a9q3s.1478144944778@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35751 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755986AbcKDMpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2016 08:45:34 -0400
Received: by mail-vk0-f44.google.com with SMTP id w194so65739560vkw.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Nov 2016 05:45:34 -0700 (PDT)
In-Reply-To: <30w645ulbhlofxrk1h4a9q3s.1478144944778@email.android.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Igor Rybak <igor@media-clone.com>, Andrey Grodzovsky <andrey2805@gmail.com>
Cc: Ezra Kohavi <ezra@media-clone.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

Hi All,

>From last two days, I was working with my firmware team to get the
required info over this issue. Here is my firmware team response

"For ATA PASSTHROUGH commands, the IOC SATL will not check for the
opcode and will direct it to the drive. So even though ATA PASSTHOUGH
has ATA erase to the drive, IOC SATL FW will not know that and as a
general logic for all ATA PASSTHOGH commands, IOC FW will pend the
upcoming IOs untill the previous ATA PASSTHORUGH completes. This is as
per the SAT specification for SAS controllers and we can't compare it
with the SATA controllers in the on board that have full fledge SATA
implementation".

So this is an expected behavior from our HBA firmware. i.e. it will
pend the subsequent commands if any ATA PASSTHROUGH command is going
on. So their is no issue with the FW.

Today I have tried the same test case on my local setup. i.e. I have
issued a secure erase command using hdparm utility and observed the
same issue on 4.2.3-300.fc23.x86_64 kernel.

Then after browsing over this issue, I found that some people are
recommending to enable 'CONFIG_IDE_TASK_IOCTL' Kconfig flag. I had a
compiled 4.4.0 kernel, so I have enabled this CONFIG_IDE_TASK_IOCTL
and recompiled this 4.4.0 kernel and booted in to this kernel. Then I
tried same test case and I haven't observed this issue and secure
erase operation was completed successfully.

So, can you please try once with CONFIG_IDE_TASK_IOCTL enabled.

Thanks,
Sreekanth






On Thu, Nov 3, 2016 at 9:19 AM, Igor Rybak <igor@media-clone.com> wrote:
> Hi,
>
> We tried the latest LSI firmware 20.0.0.7, also collected logs by the
> Broadcom script and emailed to their tech support already.
>
> Thanks,
>
> Igor Rybak
> VP Engineering
> MediaClone Inc
>
>
> -------- Original message --------
> From: Andrey Grodzovsky <andrey2805@gmail.com>
> Date: 11/2/16 9:31 PM (GMT+05:30)
> To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Igor Rybak
> <igor@media-clone.com>, Ezra Kohavi <ezra@media-clone.com>
> Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
> linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Sathya Prakas=
h
> <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>=
,
> Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
> stable@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature terminati=
on
> (v2)
>
>
>
> On Wed, Nov 2, 2016 at 6:05 AM, Sreekanth Reddy
> <sreekanth.reddy@broadcom.com> wrote:
>>
>> On Wed, Nov 2, 2016 at 7:37 AM, Hannes Reinecke <hare@suse.de> wrote:
>> > On 11/02/2016 01:09 AM, Andrey Grodzovsky wrote:
>> >>
>> >> Problem:
>> >> This is a work around for a bug with LSI Fusion MPT SAS2 when
>> >> pefroming secure erase. Due to the very long time the operation
>> >> takes commands issued during the erase will time out and will trigger
>> >> execution of abort hook. Even though the abort hook is called for
>> >> the specifc command which timed out this leads to entire device halt
>> >> (scsi_state terminated) and premature termination of the secured eras=
e.
>> >>
>> >> Fix:
>> >> Set device state to busy while erase in progress to reject any incomi=
ng
>> >> commands until the erase is done. The device is blocked any way durin=
g
>> >> this time and cannot execute any other command.
>> >> More data and logs can be found here -
>> >> https://drive.google.com/file/d/0B9ocOHYHbbS1Q3VMdkkzeWFkTjg/view
>> >>
>> >> v2: Update according to example patch by Hannes Reinecke to apply
>> >> the blocking logic to any ATA 12/16 command.
>> >>
>> >> Signed-off-by: Andrey Grodzovsky <andrey2805@gmail.com>
>> >> Cc: <linux-scsi@vger.kernel.org>
>> >> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
>> >> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
>> >> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
>> >> Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
>> >> Cc: Hannes Reinecke <hare@suse.de>
>> >> Cc: <stable@vger.kernel.org>
>> >> ---
>> >>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 26 ++++++++++++++++++++++++++
>> >>  1 file changed, 26 insertions(+)
>> >>
>> >> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> >> b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> >> index 5a97e32..43ab0cc 100644
>> >> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> >> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> >> @@ -3500,6 +3500,20 @@ _scsih_eedp_error_handling(struct scsi_cmnd
>> >> *scmd,
>> >> u16 ioc_status)
>> >>             SAM_STAT_CHECK_CONDITION;
>> >>  }
>> >>
>> >> +/**
>> >> + * This is a work around for a bug with LSI Fusion MPT SAS2 when
>> >> + * pefroming secure erase. Due to the verly long time the operation
>> >> + * takes commands issued during the erase will time out and will
>> >> trigger
>> >> + * execution of abort hook. This leads to device reset and premature
>> >> + * termination of the secured erase.
>> >> + *
>> >> + */
>> >> +static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
>> >> +{
>> >> +   return (scmd->cmnd[0] =3D=3D 0xa1 || scmd->cmnd[0] =3D=3D 0x85);
>> >> +}
>> >> +
>> >> +
>> >>
>> >>  /**
>> >>   * _scsih_qcmd - main scsi request entry point
>> >> @@ -3528,6 +3542,14 @@ _scsih_qcmd(struct Scsi_Host *shost, struct
>> >> scsi_cmnd *scmd)
>> >>                 scsi_print_command(scmd);
>> >>  #endif
>> >>
>> >> +   /**
>> >> +       * Lock the device for any subsequent command until
>> >> +       * command is done.
>> >> +       */
>> >> +       if (ata_12_16_cmd(scmd))
>> >> +               scsi_internal_device_block(scmd->device);
>> >> +
>> >> +
>> >>         sas_device_priv_data =3D scmd->device->hostdata;
>> >>         if (!sas_device_priv_data || !sas_device_priv_data->sas_targe=
t)
>> >> {
>> >>                 scmd->result =3D DID_NO_CONNECT << 16;
>> >> @@ -4062,6 +4084,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u1=
6
>> >> smid, u8 msix_index, u32 reply)
>> >>         if (scmd =3D=3D NULL)
>> >>                 return 1;
>> >>
>> >> +       if (ata_12_16_cmd(scmd))
>> >> +               scsi_internal_device_unblock(scmd->device,
>> >> SDEV_RUNNING);
>> >> +
>> >> +
>> >>         mpi_request =3D mpt3sas_base_get_msg_frame(ioc, smid);
>> >>
>> >>         if (mpi_reply =3D=3D NULL) {
>> >>
>> > Yeah, it's ugly, but I can't think of a better solution for the moment=
.
>> > Thanks for debugging this.
>>
>> May I known the result of same test case if the SATA drive is
>> connected to on-bord SATA?
>
>
> + Igor and Ezra from media-clone who originally reported the problem.
>
> With on board controller no problems were observed.
>>
>>
>> If it is assumed to be HBA firmware issue then it should be fixed in
>> the Firmware not in the driver. Have you tried with the latest HBA
>> Firmware image?  if it still occurs then is it possible for you to
>> share the firmware logs?
>
>
> Igor, Ezra - can you do it please ?
>>
>>
>> I think that service request has raised for this issue with Broadcom,
>> in this service request our support people can help you in collecting
>> the firmware logs and can provide the analysis of those firmware logs.
>
>
> Same as above.
>
> Thanks,
> Andrey
>>
>>
>> Thanks,
>> Sreekanth
>>
>> >
>> > Reviewed-by: Hannes Reinecke <hare@suse.com>
>> >
>> > Cheers,
>> >
>> > Hannes
>> > --
>> > Dr. Hannes Reinecke                   zSeries & Storage
>> > hare@suse.de                          +49 911 74053 688
>> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>> > GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnber=
g)
>
>
