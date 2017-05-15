From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Mon, 15 May 2017 23:32:58 +0000
Message-ID: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Monday, May 15, 2017 4:03 PM
> To: jejb@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Long Li <longli@microsoft.com>;
> martin.petersen@oracle.com
> Cc: Long Li <longli@microsoft.com>
> Subject: Re: [Possible Phish Fraud][PATCH] scsi: zero per-cmd driver data=
 for
> each MQ I/O
>=20
> On Wed, 2017-05-10 at 14:07 -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > Lower layer driver may not initialize private data before use. Zero
> > them out to prevent use of stale data.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
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
> >  	/* zero out the cmd, except for the embedded scsi_request */
> >  	memset((char *)cmd + sizeof(cmd->req), 0,
> > -		sizeof(*cmd) - sizeof(cmd->req));
> > +		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
> >
> >  	req->special =3D cmd;
>=20
> Hello Long,
>=20
> Sorry but this patch looks wrong to me. Since scsi_mq_prep_fn() is called
> after scsi_req_init(), erasing struct scsi_request from scsi_mq_prep_fn()=
 will
> erase the values that were set by scsi_req_init(). That includes informat=
ion
> like the pointer to the SCSI CDB and the CDB itself. See e.g.
> scsi_execute().
>=20
> Did you come up with this patch after source reading or did you come up w=
ith
> this patch while chasing a bug?

Thanks for looking! Yes this is for chasing a bug.=20

Actually scsi_mq_prep_fn() doesn't touch cmd->req (which is the struct scsi=
_request mentioned in your email).

With the patch, we also zero the private data used by lower layer driver, i=
n addition to the private data in scsi_cmnd.

>=20
> Thanks,
>=20
> Bart.
