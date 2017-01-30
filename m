From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 19/24] aacraid: Added new IWBR reset
Date: Mon, 30 Jan 2017 19:56:10 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6CBD@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-20-RaghavaAditya.Renukunta@microsemi.com>
 <20170130113958.GN3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0087.outbound.protection.outlook.com ([104.47.32.87]:63506
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751033AbdA3T5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 14:57:40 -0500
In-Reply-To: <20170130113958.GN3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
> Sent: Monday, January 30, 2017 3:40 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 19/24] aacraid: Added new IWBR reset
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:48AM -0800, Raghava Aditya Renukunta wrote:
> > Added a new IWBR soft reset type, reworked the IOP reset interface for
> > a bit.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > @@ -1488,7 +1489,8 @@ static int _aac_reset_adapter(struct aac_dev
> *aac, int forced)
> >        *      If a positive health, means in a known DEAD PANIC
> >        * state and the adapter could be reset to `try again'.
> >        */
> > -     retval =3D aac_adapter_restart(aac, forced ? 0 :
> aac_adapter_check_health(aac));
> > +     bled =3D forced ? 0 : aac_adapter_check_health(aac);
> > +     retval =3D aac_adapter_restart(aac, bled, reset_type);
> >
> >       if (retval)
> >               goto out;
> > @@ -1598,7 +1600,7 @@ static int _aac_reset_adapter(struct aac_dev
> *aac, int forced)
> >       return retval;
> >  }
> >
> > -int aac_reset_adapter(struct aac_dev * aac, int forced)
> > +int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
> >  {
> >       unsigned long flagv =3D 0;
> >       int retval;
> > @@ -1651,7 +1653,9 @@ int aac_reset_adapter(struct aac_dev * aac, int
> forced)
> >       if (forced < 2)
> >               aac_send_shutdown(aac);
> >       spin_lock_irqsave(host->host_lock, flagv);
> > -     retval =3D _aac_reset_adapter(aac, forced ? forced : ((aac_check_=
reset !=3D
> 0) && (aac_check_reset !=3D 1)));
> > +     retval =3D _aac_reset_adapter(aac,
> > +             forced ? forced : ((aac_check_reset !=3D 0) &&
> > +             (aac_check_reset !=3D 1)), reset_type);
> >       spin_unlock_irqrestore(host->host_lock, flagv);
>=20
> Can you please add a local bled here as well, like you did in
> _aac_reset_adapter() instead of doing the 'forced ? forced :
> ((aac_check_reset
> !=3D 0) && aac_check_reset !=3D 1))' dance in the function call.

Yup, I will do that.=20

> >
> >       if ((forced < 2) && (retval =3D=3D -ENODEV)) {
> > @@ -1814,7 +1818,8 @@ int aac_check_health(struct aac_dev * aac)
> >       host =3D aac->scsi_host_ptr;
> >       if (aac->thread->pid !=3D current->pid)
> >               spin_lock_irqsave(host->host_lock, flagv);
> > -     BlinkLED =3D _aac_reset_adapter(aac, aac_check_reset !=3D 1);
> > +     BlinkLED =3D _aac_reset_adapter(aac,
> > +             aac_check_reset !=3D 1, IOP_HWSOFT_RESET);
>=20
> Arguably here as well.


Ditto here.

>=20
> >       if (aac->thread->pid !=3D current->pid)
> >               spin_unlock_irqrestore(host->host_lock, flagv);
> >       return BlinkLED;
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.=
c
> > index 2ead5c7..a0f26f6 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
>=20
> [...]
>=20
> > @@ -1162,7 +1162,9 @@ static ssize_t aac_store_reset_adapter(struct
> device *device,
> >
> >       if (!capable(CAP_SYS_ADMIN))
> >               return retval;
>=20
> struct aac_dev *adap =3D shost_priv(class_to_shost(device));
> int bled =3D buf[0] =3D=3D "!";
>=20
> retval =3D aac_reset_adapter(adap, bled, IOP_HWSOFT_RESET);

Here as well. I will make the necessary changes

> > -     retval =3D aac_reset_adapter((struct aac_dev*)class_to_shost(devi=
ce)-
> >hostdata, buf[0] =3D=3D '!');
> > +     retval =3D aac_reset_adapter((struct aac_dev *)
> > +             class_to_shost(device)->hostdata,
> > +             buf[0] =3D=3D '!', IOP_HWSOFT_RESET);
> >       if (retval >=3D 0)
> >               retval =3D count;
> >       return retval;
>=20
> [...]

Thank you,
Regards,
Raghava Aditya

> Thanks,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
