From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 1/6] pm80xx : redefine sas_identify_frame structure
Date: Wed, 30 Aug 2017 18:03:41 +0200
Message-ID: <CAD+HZHUq0Jy1uZgh1JcrDJfTiSCe-NxEj_Ospyi7RGDuO4hxwg@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com>
 <20150130060645.23653-2-Viswas.G@microsemi.com> <CAD+HZHWwL=sjCC=4uKG8erLBTk=C+OWxsj9ACQf767Fma+hCKw@mail.gmail.com>
 <E96847475729F24299853D257F7211218C8C98EB@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33942 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdH3QDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 12:03:43 -0400
Received: by mail-wm0-f68.google.com with SMTP id l19so2267098wmi.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 09:03:42 -0700 (PDT)
In-Reply-To: <E96847475729F24299853D257F7211218C8C98EB@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <viswas.g@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi Tharmarajan <vasanthalakshmi.thar@microsemi.com>

2017-08-30 17:41 GMT+02:00 Viswas G <viswas.g@microsemi.com>:
> Hi Jack,
>
> The firmware expectation is that there is no 4 byte CRC. This causes the =
IOMB to be generated incorrectly for PHY_START. Local structure for SAS Ide=
ntify included in the driver so that it matches the Programmer's Manual and=
 Firmware expectations.
>
> The sas_identify struct from the kernel includes the checksum word (32-bi=
ts) . So it is 32 bytes rather than 28 bytes. The changed size for the sas =
identify frame means that the "spasti" field for PHY_START is at a differen=
t offset than documented, word 11 rather than word 10. We're not changing t=
he phy analog settings so this doesn't really matter, but the docs indicate=
 that the sas frame's crc isn't included. So having a local definition will=
 be better than taking the system definition.
>
> Regards,
> Viswas G

Hi Viswas,

The spasti field is only for pm80xx, not for pm8001, I think it's
better to move sas_identify_frame_local to pm80xx_hwi.h.

Regards,
Jack


>
>> -----Original Message-----
>> From: Jack Wang [mailto:xjtuwjp@gmail.com]
>> Sent: Tuesday, August 29, 2017 4:49 PM
>> To: Viswas G <viswas.g@microsemi.com>
>> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan
>> <vasanthalakshmi.thar@microsemi.com>
>> Subject: Re: [PATCH 1/6] pm80xx : redefine sas_identify_frame structure
>>
>> EXTERNAL EMAIL
>>
>>
>> 2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
>> > sas_identify structure defined by pm80xx doesn't have CRC field.
>> > So added a new sas_identify structure without CRC.
>> >
>> > Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
>> > Signed-off-by: Viswas G <Viswas.G@microsemi.com>
>> > ---
>> >  drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
>> >  drivers/scsi/pm8001/pm8001_sas.h | 95
>> ++++++++++++++++++++++++++++++++++++++++
>> >  drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
>> >  3 files changed, 97 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
>> b/drivers/scsi/pm8001/pm8001_hwi.h
>> > index e4867e690c84..f4331afe9b0b 100644
>> > --- a/drivers/scsi/pm8001/pm8001_hwi.h
>> > +++ b/drivers/scsi/pm8001/pm8001_hwi.h
>> > @@ -157,7 +157,7 @@ struct mpi_msg_hdr{
>> >  struct phy_start_req {
>> >         __le32  tag;
>> >         __le32  ase_sh_lm_slr_phyid;
>> > -       struct sas_identify_frame sas_identify;
>> > +       struct sas_identify_frame_local sas_identify;
>> >         u32     reserved[5];
>> >  } __attribute__((packed, aligned(4)));
>> >
>> > diff --git a/drivers/scsi/pm8001/pm8001_sas.h
>> b/drivers/scsi/pm8001/pm8001_sas.h
>> > index e81a8fa7ef1a..2e17505ed5b8 100644
>> > --- a/drivers/scsi/pm8001/pm8001_sas.h
>> > +++ b/drivers/scsi/pm8001/pm8001_sas.h
>> > @@ -118,6 +118,101 @@ extern const struct pm8001_dispatch
>> pm8001_80xx_dispatch;
>> >  struct pm8001_hba_info;
>> >  struct pm8001_ccb_info;
>> >  struct pm8001_device;
>> > +#ifdef __LITTLE_ENDIAN_BITFIELD
>> > +struct sas_identify_frame_local {
>> > +       /* Byte 0 */
>> > +       u8  frame_type:4;
>> > +       u8  dev_type:3;
>> > +       u8  _un0:1;
>> > +
>> > +       /* Byte 1 */
>> > +       u8  _un1;
>> > +
>> > +       /* Byte 2 */
>> > +       union {
>> > +               struct {
>> > +                       u8  _un20:1;
>> > +                       u8  smp_iport:1;
>> > +                       u8  stp_iport:1;
>> > +                       u8  ssp_iport:1;
>> > +                       u8  _un247:4;
>> > +               };
>> > +               u8 initiator_bits;
>> > +       };
>> > +
>> > +       /* Byte 3 */
>> > +       union {
>> > +               struct {
>> > +                       u8  _un30:1;
>> > +                       u8 smp_tport:1;
>> > +                       u8 stp_tport:1;
>> > +                       u8 ssp_tport:1;
>> > +                       u8 _un347:4;
>> > +               };
>> > +               u8 target_bits;
>> > +       };
>> > +
>> > +       /* Byte 4 - 11 */
>> > +       u8 _un4_11[8];
>> > +
>> > +       /* Byte 12 - 19 */
>> > +       u8 sas_addr[SAS_ADDR_SIZE];
>> > +
>> > +       /* Byte 20 */
>> > +       u8 phy_id;
>> > +
>> > +       u8 _un21_27[7];
>> > +
>> > +} __packed;
>> > +
>> > +#elif defined(__BIG_ENDIAN_BITFIELD)
>> > +struct sas_identify_frame_local {
>> > +       /* Byte 0 */
>> > +       u8  _un0:1;
>> > +       u8  dev_type:3;
>> > +       u8  frame_type:4;
>> > +
>> > +       /* Byte 1 */
>> > +       u8  _un1;
>> > +
>> > +       /* Byte 2 */
>> > +       union {
>> > +               struct {
>> > +                       u8  _un247:4;
>> > +                       u8  ssp_iport:1;
>> > +                       u8  stp_iport:1;
>> > +                       u8  smp_iport:1;
>> > +                       u8  _un20:1;
>> > +               };
>> > +               u8 initiator_bits;
>> > +       };
>> > +
>> > +       /* Byte 3 */
>> > +       union {
>> > +               struct {
>> > +                       u8 _un347:4;
>> > +                       u8 ssp_tport:1;
>> > +                       u8 stp_tport:1;
>> > +                       u8 smp_tport:1;
>> > +                       u8 _un30:1;
>> > +               };
>> > +               u8 target_bits;
>> > +       };
>> > +
>> > +       /* Byte 4 - 11 */
>> > +       u8 _un4_11[8];
>> > +
>> > +       /* Byte 12 - 19 */
>> > +       u8 sas_addr[SAS_ADDR_SIZE];
>> > +
>> > +       /* Byte 20 */
>> > +       u8 phy_id;
>> > +
>> > +       u8 _un21_27[7];
>> > +} __packed;
>> > +#else
>> > +#error "Bitfield order not defined!"
>> > +#endif
>> >  /* define task management IU */
>> >  struct pm8001_tmf_task {
>> >         u8      tmf;
>> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h
>> b/drivers/scsi/pm8001/pm80xx_hwi.h
>> > index 7a443bad6163..1ee2ec210065 100644
>> > --- a/drivers/scsi/pm8001/pm80xx_hwi.h
>> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
>> > @@ -248,7 +248,7 @@ struct mpi_msg_hdr {
>> >  struct phy_start_req {
>> >         __le32  tag;
>> >         __le32  ase_sh_lm_slr_phyid;
>> > -       struct sas_identify_frame sas_identify; /* 28 Bytes */
>> > +       struct sas_identify_frame_local sas_identify; /* 28 Bytes */
>> >         __le32 spasti;
>> >         u32     reserved[21];
>> >  } __attribute__((packed, aligned(4)));
>> > --
>> > 2.12.3
>> >
>> Did this cause any trouble? I guest not, as we does memset for
>> phy_start_req,  why bother?
>>
>> Jack
