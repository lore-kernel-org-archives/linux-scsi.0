From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 08/24] aacraid: Added support for response path
Date: Mon, 30 Jan 2017 20:16:48 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6DA3@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-9-RaghavaAditya.Renukunta@microsemi.com>
 <20170130095006.GE3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0087.outbound.protection.outlook.com ([104.47.40.87]:45760
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754244AbdA3UQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:16:51 -0500
In-Reply-To: <20170130095006.GE3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 1:50 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 08/24] aacraid: Added support for response path
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:37AM -0800, Raghava Aditya Renukunta wrote:
> > This patch enables the driver to actually process the I/O, or srb repli=
es
> > from adapter. In addition to any HBA1000 or SmartIOC2000 adapter events=
.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> Sorry for not completely reviewing the patchset before you reposted.
>=20
> > @@ -475,16 +475,26 @@ int aac_get_containers(struct aac_dev *dev)
> >
> >       if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
> >               maximum_num_containers =3D MAXIMUM_NUM_CONTAINERS;
> > -     fsa_dev_ptr =3D kzalloc(sizeof(*fsa_dev_ptr) *
> maximum_num_containers,
> > -                     GFP_KERNEL);
> > -     if (!fsa_dev_ptr)
> > -             return -ENOMEM;
> > +     if ((dev->fsa_dev =3D=3D NULL) ||
> > +             (dev->maximum_num_containers !=3D maximum_num_containers)=
)
> {
> > +
> > +             fsa_dev_ptr =3D dev->fsa_dev;
>=20
> Comparison has precedence over logical OR. See
> http://en.cppreference.com/w/c/language/operator_precedence

Acknowledged.  , I will remove the parentheses.
The idea was to make it easier to read the code , if there were enclosed in=
=20
Parenthesis  (I dabbled a bit in lisp , and for me brackets makes it easier=
 to read).

>=20
> >
> > -     dev->fsa_dev =3D fsa_dev_ptr;
> > -     dev->maximum_num_containers =3D maximum_num_containers;
> > +             dev->fsa_dev =3D kzalloc(sizeof(*fsa_dev_ptr) *
> > +                             maximum_num_containers, GFP_KERNEL);
>=20
> kcalloc()?

Yes kcalloc makes sense, but then an additional mem set would be required.
Unless there is a kzcalloc or kczalloc?


> [...]
>=20
>=20
> > @@ -251,8 +250,9 @@ static void aac_aif_callback(void *context, struct =
fib
> * fibptr)
> >       BUG_ON(fibptr =3D=3D NULL);
> >       dev =3D fibptr->dev;
> >
> > -     if (fibptr->hw_fib_va->header.XferState &
> > -         cpu_to_le32(NoMoreAifDataAvailable)) {
> > +     if ((fibptr->hw_fib_va->header.XferState &
> > +         cpu_to_le32(NoMoreAifDataAvailable)) ||
> > +             dev->sa_firmware) {
>=20
> Again unnecessary parenthesis.

> >               aac_fib_complete(fibptr);
> >               aac_fib_free(fibptr);
> >               return;
> > @@ -282,8 +282,8 @@ static void aac_aif_callback(void *context, struct =
fib
> * fibptr)
> >   *   know there is a response on our normal priority queue. We will pu=
ll off
> >   *   all QE there are and wake up all the waiters before exiting.
> >   */
> > -unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
> > -                     int isAif, int isFastResponse, struct hw_fib *aif=
_fib)
> > +unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif=
,
> > +     int isFastResponse, struct hw_fib *aif_fib)
>=20
> Isn't this exactly the same but now with broken indent?

It is, I tried removing stuff like this before sending the patches, must ha=
ve
snuck in. I will remove it.=20

Regards,
Raghava Aditya

> [...]
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
