From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 03/16] aacraid: Fix for excessive prints on EEH
Date: Wed, 15 Feb 2017 18:06:46 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C1795@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-4-RaghavaAditya.Renukunta@microsemi.com>
 <b28c9ca8-8046-7db0-6a2d-64853ec3cce4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0072.outbound.protection.outlook.com ([104.47.34.72]:51712
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752193AbdBOSHW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 13:07:22 -0500
In-Reply-To: <b28c9ca8-8046-7db0-6a2d-64853ec3cce4@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>




> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > This issue showed up on a kdump debug(single CPU on powerkvm), when
> EEH
> > errors rendered the adapter unusable. The driver correctly detected the
> > issue and attempted to restart the controller, in doing so the driver
> > attempted to read the status registers of the controller. This triggere=
d
> > additional eeh errors which continued for a good 6 minutes.
> >
> > Fixed by returning without waiting when EEH error is reported.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/commsup.c | 38
> +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 37 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> > index 56090f5..6220b47 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -461,6 +461,30 @@ int aac_queue_get(struct aac_dev * dev, u32 *
> index, u32 qid, struct hw_fib * hw
> >       return 0;
> >  }
>=20
> Please do
>=20
> > +#ifdef CONFIG_EEH
> > +static inline int aac_check_eeh_failure(struct aac_dev *dev)
> > +{
> > +     /* Check for an EEH failure for the given
> > +      * device node. Function eeh_dev_check_failure()
> > +      * returns 0 if there has not been an EEH error
> > +      * otherwise returns a non-zero value.
> > +      *
> > +      * Need to be called before any PCI operation,
> > +      * i.e.,before aac_adapter_check_health()
> > +      */
> > +     struct eeh_dev *edev =3D pci_dev_to_eeh_dev(dev->pdev);
> > +
> > +     if (eeh_dev_check_failure(edev)) {
> > +             /* The EEH mechanisms will handle this
> > +              * error and reset the device if
> > +              * necessary.
> > +              */
> > +             return 1;
> > +     }
> > +     return 0;
> > +}
>=20
>   #else
>   static inline int aac_check_eeh_failure(struct aac_dev *dev)
>   {
>         return 0;
>   }
>=20
> > +#endif
> > +
>=20
> [...]
>=20
> > +
> > +#if defined(CONFIG_EEH)
> > +                             if (aac_check_eeh_failure(dev))
> > +                                     return -EFAULT;
> > +#endif
> > +
>=20
> So the #if defined() blocks become unnecessary.
Yes I can do that.

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
