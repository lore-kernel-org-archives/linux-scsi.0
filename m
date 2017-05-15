From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Mon, 15 May 2017 23:20:40 +0000
Message-ID: <DM5PR03MB24901EA07027152EB5AA68C4A0E10@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
 <MWHPR03MB3136FC54E76FBFD54A178159CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR03MB3136FC54E76FBFD54A178159CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Long Li
> Sent: Monday, May 15, 2017 3:48 PM
> To: Long Li <longli@microsoft.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>
> Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
>=20
> > -----Original Message-----
> > From: Long Li [mailto:longli@exchange.microsoft.com]
> > Sent: Wednesday, May 10, 2017 2:07 PM
> > To: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> > <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>
> > Subject: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
> >
> > From: Long Li <longli@microsoft.com>
> >
> > Lower layer driver may not initialize private data before use. Zero the=
m out
> > to prevent use of stale data.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
>=20
> Can someone help review this patch?
Reviewed-by:  K. Y. Srinivasan <kys@microsoft.com>

>=20
> > ---
> >  drivers/scsi/scsi_lib.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> > 19125d7..a821593 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1850,7 +1850,7 @@ static int scsi_mq_prep_fn(struct request *req)
> >
> >         /* zero out the cmd, except for the embedded scsi_request */
> >         memset((char *)cmd + sizeof(cmd->req), 0,
> > -               sizeof(*cmd) - sizeof(cmd->req));
> > +               sizeof(*cmd) - sizeof(cmd->req) +
> > + shost->hostt->cmd_size);
> >
> >         req->special =3D cmd;
> >
> > --
> > 2.7.4
