From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 05/16] aacraid: Fix memory leak in fib init path
Date: Wed, 15 Feb 2017 18:08:53 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C17D1@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-6-RaghavaAditya.Renukunta@microsemi.com>
 <23eeae24-16d7-1671-2fde-edb17305574a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:58080
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750767AbdBOSJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 13:09:31 -0500
In-Reply-To: <23eeae24-16d7-1671-2fde-edb17305574a@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 12:32 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; dan.carpenter@oracle.com
> Subject: Re: [PATCH 05/16] aacraid: Fix memory leak in fib init path
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > aac_fib_map_free frees misaligned fib dma memory, additionally it does
> not
> > free up the whole memory.
> >
> > Fixed by changing the  code to free up the correct and full memory
> > allocation.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e8b12f0fb835223 ([SCSI] aacraid: Add new code for PMC-Sierra's S=
RC
> based controller family)
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/commsup.c | 20 +++++++++-----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> > index f7a3bcb..863c98d 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -97,8 +97,8 @@ void aac_fib_map_free(struct aac_dev *dev)
> >  {
> >       if (dev->hw_fib_va && dev->max_cmd_size) {
> >               pci_free_consistent(dev->pdev,
> > -             (dev->max_cmd_size *
> > -             (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
> > +             (dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
> > +             * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + 31,
> >               dev->hw_fib_va, dev->hw_fib_pa);
>=20
> Can you please do something like:
>=20
> size_t alloc_size;
> int numtags;
>=20
> numtags =3D dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
> alloc_size =3D (dev->max_cmd_size + sizeof(struct aac_fib_xporthdr)) *
>                 numtags + 31;
> pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
>                     dev->hw_fib_pa);
>=20
> And please indent correctly. If it indentation doesn't work correctly
> because you hit the 80 chars limit, that's a sign something should be
> reconsidered.

Yes, I will rework this.=20

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
