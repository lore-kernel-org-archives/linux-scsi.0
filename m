From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
Date: Wed, 27 Apr 2016 16:49:50 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A163531DC@avsrvexchmbx2.microsemi.net>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063237.28402.20267.stgit@pmcuser-System-Product-Name>
 <20160427092943.GF2820@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0098.outbound.protection.outlook.com ([157.56.111.98]:35520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752353AbcD0QuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2016 12:50:11 -0400
In-Reply-To: <20160427092943.GF2820@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthmshirn@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Vishal Jose Mannanal <vishal.josemannanal@microsemi.com>

Hello Johannes,

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthmshirn@suse.de]
> Sent: Wednesday, April 27, 2016 2:30 AM
> To: Raghava Aditya Renukunta
> Cc: JBottomley@odin.com; linux-scsi@vger.kernel.org;
> martin.petersen@oracle.com; aacraid@pmc-sierra.com; Gana Sridaran; Sc=
ott
> Benesh; Vishal Jose Mannanal
> Subject: Re: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Mon, Apr 25, 2016 at 11:32:37PM -0700, Raghava Aditya Renukunta wr=
ote:
> > When KDUMP is triggered the driver first talks to the firmware in I=
NTX
> > mode, but the adapter firmware is still in MSIX mode. Therefore the=
 first
> > driver command hangs since the driver is waiting for an INTX respon=
se and
> > firmware gives a MSIX response. If when the OS is installed on a RA=
ID
> > drive created by the adapter KDUMP will hang since the driver does =
not
> > receive a response in sync mode.
> >
> > Fixed by: Change the firmware to INTX mode if it is in MSIX mode be=
fore
> > sending the first sync command.
> > Cc: stable@vger.kernel.org
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/aacraid.h  |    1 +
> >  drivers/scsi/aacraid/comminit.c |   24 ++++++++++++++++++++++++
> >  2 files changed, 25 insertions(+)
> >
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/=
aacraid.h
> > index b70f3eb..0ba8f61 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -29,6 +29,7 @@ enum {
> >  #define AAC_INT_MODE_MSI             (1<<1)
> >  #define AAC_INT_MODE_AIF             (1<<2)
> >  #define AAC_INT_MODE_SYNC            (1<<3)
> > +#define AAC_INT_MODE_MSIX            (1<<16)
> >
> >  #define AAC_INT_ENABLE_TYPE1_INTX    0xfffffffb
> >  #define AAC_INT_ENABLE_TYPE1_MSIX    0xfffffffa
> > diff --git a/drivers/scsi/aacraid/comminit.c
> b/drivers/scsi/aacraid/comminit.c
> > index 50d521a..341ea32 100644
> > --- a/drivers/scsi/aacraid/comminit.c
> > +++ b/drivers/scsi/aacraid/comminit.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>
> >  #include <linux/blkdev.h>
> > +#include <linux/delay.h>
> >  #include <linux/completion.h>
> >  #include <linux/mm.h>
> >  #include <scsi/scsi_host.h>
> > @@ -47,6 +48,20 @@ struct aac_common aac_config =3D {
> >       .irq_mod =3D 1
> >  };
> >
> > +static inline int aac_is_msix_mode(struct aac_dev *dev)
> > +{
> > +     u32 status;
> > +
> > +     status =3D src_readl(dev, MUnit.OMR);
> > +     return (status & AAC_INT_MODE_MSIX);
> > +}
> > +
> > +static inline void aac_change_to_intx(struct aac_dev *dev)
> > +{
> > +     aac_src_access_devreg(dev, AAC_DISABLE_MSIX);
> > +     aac_src_access_devreg(dev, AAC_ENABLE_INTX);
>=20
> I don't know your adpater firmware, but isn't it possible to loose in=
terrupts
> this way or do they get queued?

The firmware queues interrupts messages in its own buffers, and the dri=
ver sends
a command to retrieve those messages once the driver gets initialized.=20
The code that sends the command once the driver is initialized is in th=
e patch 7 of this=20
Series.

Hope that clarifies your doubt.

Regards,
Raghava Aditya



> > +}
> > +
> >  static int aac_alloc_comm(struct aac_dev *dev, void **commaddr,
> unsigned long commsize, unsigned long commalign)
> >  {
> >       unsigned char *base;
> > @@ -414,6 +429,15 @@ struct aac_dev *aac_init_adapter(struct aac_de=
v
> *dev)
> >       dev->comm_interface =3D AAC_COMM_PRODUCER;
> >       dev->raw_io_interface =3D dev->raw_io_64 =3D 0;
> >
> > +
> > +     /*
> > +      * Enable INTX mode, if not done already Enabled
> > +      */
> > +     if (aac_is_msix_mode(dev)) {
> > +             aac_change_to_intx(dev);
> > +             dev_info(&dev->pdev->dev, "Changed firmware to INTX m=
ode");
> > +     }
> > +
> >       if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
> >               0, 0, 0, 0, 0, 0,
> >               status+0, status+1, status+2, status+3, NULL)) &&
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
