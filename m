From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 3/6] pm80xx : Different SAS addresses for phys.
Date: Fri, 1 Sep 2017 10:52:52 +0200
Message-ID: <CAD+HZHXCOWKBVfbFZYUoejNjxkrenVsWgnvKH9+a6GiueFu22Q@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com>
 <20150130060645.23653-4-Viswas.G@microsemi.com> <CAD+HZHVF83w-s9ih5FQRAH_-OYPCNBYEs=9x=09LOwZ0nxymaQ@mail.gmail.com>
 <E96847475729F24299853D257F7211218C8C9947@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33001 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdIAIwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 04:52:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id m85so1862658wma.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Sep 2017 01:52:53 -0700 (PDT)
In-Reply-To: <E96847475729F24299853D257F7211218C8C9947@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <viswas.g@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi Tharmarajan <vasanthalakshmi.thar@microsemi.com>

2017-08-30 18:55 GMT+02:00 Viswas G <viswas.g@microsemi.com>:
> Hi Jack,
>
> This is a customer requirement. Since the SAS addresses of all the phys w=
ere same , when the attached SAS addresses are different, it was forming on=
ly one domain.  If we assign different SAS addresses, this will cause dupli=
cate domain unless we set the strict_wide_port to 1.
>
> Regards,
> Viswas G

Ok, understand now!

Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
Thanks!
>
>
>> -----Original Message-----
>> From: Jack Wang [mailto:xjtuwjp@gmail.com]
>> Sent: Tuesday, August 29, 2017 4:55 PM
>> To: Viswas G <viswas.g@microsemi.com>
>> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan
>> <vasanthalakshmi.thar@microsemi.com>
>> Subject: Re: [PATCH 3/6] pm80xx : Different SAS addresses for phys.
>>
>> EXTERNAL EMAIL
>>
>>
>> 2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
>> > Different SAS addresses are assigned for each set of phys.
>> >
>> > Signed-off-by: Viswas G <Viswas.G@microsemi.com>
>> > ---
>> >  drivers/scsi/pm8001/pm8001_init.c | 13 +++++++++----
>> >  drivers/scsi/pm8001/pm80xx_hwi.c  |  3 +--
>> >  2 files changed, 10 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/drivers/scsi/pm8001/pm8001_init.c
>> b/drivers/scsi/pm8001/pm8001_init.c
>> > index 034b2f7d1135..d282f1562615 100644
>> > --- a/drivers/scsi/pm8001/pm8001_init.c
>> > +++ b/drivers/scsi/pm8001/pm8001_init.c
>> > @@ -132,7 +132,7 @@ static void pm8001_phy_init(struct
>> pm8001_hba_info *pm8001_ha, int phy_id)
>> >         sas_phy->oob_mode =3D OOB_NOT_CONNECTED;
>> >         sas_phy->linkrate =3D SAS_LINK_RATE_UNKNOWN;
>> >         sas_phy->id =3D phy_id;
>> > -       sas_phy->sas_addr =3D &pm8001_ha->sas_addr[0];
>> > +       sas_phy->sas_addr =3D (u8 *)&phy->dev_sas_addr;
>> >         sas_phy->frame_rcvd =3D &phy->frame_rcvd[0];
>> >         sas_phy->ha =3D (struct sas_ha_struct *)pm8001_ha->shost->host=
data;
>> >         sas_phy->lldd_phy =3D phy;
>> > @@ -593,10 +593,12 @@ static void  pm8001_post_sas_ha_init(struct
>> Scsi_Host *shost,
>> >         for (i =3D 0; i < chip_info->n_phy; i++) {
>> >                 sha->sas_phy[i] =3D &pm8001_ha->phy[i].sas_phy;
>> >                 sha->sas_port[i] =3D &pm8001_ha->port[i].sas_port;
>> > +               sha->sas_phy[i]->sas_addr =3D
>> > +                       (u8 *)&pm8001_ha->phy[i].dev_sas_addr;
>> >         }
>> >         sha->sas_ha_name =3D DRV_NAME;
>> >         sha->dev =3D pm8001_ha->dev;
>> > -
>> > +       sha->strict_wide_ports =3D 1;
>> >         sha->lldd_module =3D THIS_MODULE;
>> >         sha->sas_addr =3D &pm8001_ha->sas_addr[0];
>> >         sha->num_phys =3D chip_info->n_phy;
>> > @@ -613,6 +615,7 @@ static void  pm8001_post_sas_ha_init(struct
>> Scsi_Host *shost,
>> >  static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>> >  {
>> >         u8 i, j;
>> > +       u8 sas_add[8];
>> >  #ifdef PM8001_READ_VPD
>> >         /* For new SPC controllers WWN is stored in flash vpd
>> >         *  For SPC/SPCve controllers WWN is stored in EEPROM
>> > @@ -674,10 +677,12 @@ static void pm8001_init_sas_add(struct
>> pm8001_hba_info *pm8001_ha)
>> >                         pm8001_ha->sas_addr[j] =3D
>> >                                         payload.func_specific[0x804 + =
i];
>> >         }
>> > -
>> > +       memcpy(sas_add, pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>> >         for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {
>> > +               if (i && ((i % 4) =3D=3D 0))
>> > +                       sas_add[7] =3D sas_add[7] + 4;
>> >                 memcpy(&pm8001_ha->phy[i].dev_sas_addr,
>> > -                       pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>> > +                       sas_add, SAS_ADDR_SIZE);
>> >                 PM8001_INIT_DBG(pm8001_ha,
>> >                         pm8001_printk("phy %d sas_addr =3D %016llx\n",=
 i,
>> >                         pm8001_ha->phy[i].dev_sas_addr));
>> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>> > index 8fb5ddf08cc4..a07b023c09bf 100644
>> > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> > @@ -3041,7 +3041,6 @@ hw_event_phy_down(struct pm8001_hba_info
>> *pm8001_ha, void *piomb)
>> >         port->port_state =3D portstate;
>> >         phy->identify.device_type =3D 0;
>> >         phy->phy_attached =3D 0;
>> > -       memset(&phy->dev_sas_addr, 0, SAS_ADDR_SIZE);
>> >         switch (portstate) {
>> >         case PORT_VALID:
>> >                 break;
>> > @@ -4394,7 +4393,7 @@ pm80xx_chip_phy_start_req(struct
>> pm8001_hba_info *pm8001_ha, u8 phy_id)
>> >         payload.sas_identify.dev_type =3D SAS_END_DEVICE;
>> >         payload.sas_identify.initiator_bits =3D SAS_PROTOCOL_ALL;
>> >         memcpy(payload.sas_identify.sas_addr,
>> > -               pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>> > +               &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
>> >         payload.sas_identify.phy_id =3D phy_id;
>> >         ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode,
>> &payload, 0);
>> >         return ret;
>> > --
>> > 2.12.3
>> >
>> This removes the possibility to form a wide port, why do you want to do =
it?
