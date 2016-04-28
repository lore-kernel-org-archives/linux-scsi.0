From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
Date: Thu, 28 Apr 2016 09:49:01 +0200
Message-ID: <20160428074901.GM2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063237.28402.20267.stgit@pmcuser-System-Product-Name>
 <20160427092943.GF2820@c203.arch.suse.de>
 <4D8E82A446BF54499747901DBDEB737A163531DC@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbcD1HtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 03:49:04 -0400
Content-Disposition: inline
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A163531DC@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Vishal Jose Mannanal <vishal.josemannanal@microsemi.com>

On Wed, Apr 27, 2016 at 04:49:50PM +0000, Raghava Aditya Renukunta wrot=
e:
> Hello Johannes,
>=20
> > -----Original Message-----
> > From: Johannes Thumshirn [mailto:jthmshirn@suse.de]
> > Sent: Wednesday, April 27, 2016 2:30 AM
> > To: Raghava Aditya Renukunta
> > Cc: JBottomley@odin.com; linux-scsi@vger.kernel.org;
> > martin.petersen@oracle.com; aacraid@pmc-sierra.com; Gana Sridaran; =
Scott
> > Benesh; Vishal Jose Mannanal
> > Subject: Re: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
> >=20
> > EXTERNAL EMAIL
> >=20
> >=20
> > On Mon, Apr 25, 2016 at 11:32:37PM -0700, Raghava Aditya Renukunta =
wrote:
> > > When KDUMP is triggered the driver first talks to the firmware in=
 INTX
> > > mode, but the adapter firmware is still in MSIX mode. Therefore t=
he first
> > > driver command hangs since the driver is waiting for an INTX resp=
onse and
> > > firmware gives a MSIX response. If when the OS is installed on a =
RAID
> > > drive created by the adapter KDUMP will hang since the driver doe=
s not
> > > receive a response in sync mode.
> > >
> > > Fixed by: Change the firmware to INTX mode if it is in MSIX mode =
before
> > > sending the first sync command.
> > > Cc: stable@vger.kernel.org
> > >
> > > Signed-off-by: Raghava Aditya Renukunta
> > <RaghavaAditya.Renukunta@microsemi.com>
> > > ---
> > >  drivers/scsi/aacraid/aacraid.h  |    1 +
> > >  drivers/scsi/aacraid/comminit.c |   24 ++++++++++++++++++++++++
> > >  2 files changed, 25 insertions(+)
> > >
> > > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacrai=
d/aacraid.h
> > > index b70f3eb..0ba8f61 100644
> > > --- a/drivers/scsi/aacraid/aacraid.h
> > > +++ b/drivers/scsi/aacraid/aacraid.h
> > > @@ -29,6 +29,7 @@ enum {
> > >  #define AAC_INT_MODE_MSI             (1<<1)
> > >  #define AAC_INT_MODE_AIF             (1<<2)
> > >  #define AAC_INT_MODE_SYNC            (1<<3)
> > > +#define AAC_INT_MODE_MSIX            (1<<16)
> > >
> > >  #define AAC_INT_ENABLE_TYPE1_INTX    0xfffffffb
> > >  #define AAC_INT_ENABLE_TYPE1_MSIX    0xfffffffa
> > > diff --git a/drivers/scsi/aacraid/comminit.c
> > b/drivers/scsi/aacraid/comminit.c
> > > index 50d521a..341ea32 100644
> > > --- a/drivers/scsi/aacraid/comminit.c
> > > +++ b/drivers/scsi/aacraid/comminit.c
> > > @@ -37,6 +37,7 @@
> > >  #include <linux/spinlock.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/blkdev.h>
> > > +#include <linux/delay.h>
> > >  #include <linux/completion.h>
> > >  #include <linux/mm.h>
> > >  #include <scsi/scsi_host.h>
> > > @@ -47,6 +48,20 @@ struct aac_common aac_config =3D {
> > >       .irq_mod =3D 1
> > >  };
> > >
> > > +static inline int aac_is_msix_mode(struct aac_dev *dev)
> > > +{
> > > +     u32 status;
> > > +
> > > +     status =3D src_readl(dev, MUnit.OMR);
> > > +     return (status & AAC_INT_MODE_MSIX);
> > > +}
> > > +
> > > +static inline void aac_change_to_intx(struct aac_dev *dev)
> > > +{
> > > +     aac_src_access_devreg(dev, AAC_DISABLE_MSIX);
> > > +     aac_src_access_devreg(dev, AAC_ENABLE_INTX);
> >=20
> > I don't know your adpater firmware, but isn't it possible to loose =
interrupts
> > this way or do they get queued?
>=20
> The firmware queues interrupts messages in its own buffers, and the d=
river sends
> a command to retrieve those messages once the driver gets initialized=
=2E=20
> The code that sends the command once the driver is initialized is in =
the patch 7 of this=20
> Series.
>=20
> Hope that clarifies your doubt.
>=20
> Regards,
> Raghava Aditya

OK, thanks for the clarification

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
