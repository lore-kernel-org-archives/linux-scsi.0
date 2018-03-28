From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 sector
 blacklist
Date: Wed, 28 Mar 2018 22:33:05 +0000
Message-ID: <MWHPR2101MB0729E7680EDB0EE4886AAED1CEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180326135651.8193-1-ross.lagerwall@citrix.com>
 <yq17epvj2f1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq17epvj2f1.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, KY Srinivasan <kys@microsoft.com>
Cc: Ross Lagerwall <ross.lagerwall@citrix.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Subject: Re: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 se=
ctor
> blacklist
>=20
>=20
> Long, KY: Please confirm.
>=20
> > The Windows Server 2016 iSCSI target doesn't work with the Linux
> > kernel initiator since the kernel started sending larger requests by
> > default, nor does it implement the block limits VPD page. Apply the
> > sector limit workaround for these targets.
> >
> > Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> > ---
> >  drivers/scsi/scsi_devinfo.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> > index f3b1172..5cb748a 100644
> > --- a/drivers/scsi/scsi_devinfo.c
> > +++ b/drivers/scsi/scsi_devinfo.c
> > @@ -213,7 +213,7 @@ static struct {
> >  	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
> >  	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
> >  	{"MICROP", "4110", NULL, BLIST_NOTQ},
> > -	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
> > +	{"MSFT", "Virtual HD", NULL, BLIST_MAX_1024 | BLIST_NO_RSOC},

Ross,

What about storage_channel_properties.max_transfer_bytes returned from VSTO=
R_OPERATION_QUERY_PROPERTIES (in storvsc_channel_init())

Does it return correctly the maximum transfer size for iSCSI?

Long=20

> >  	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
> >  	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
> >  	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN |
> BLIST_SINGLELUN},
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
