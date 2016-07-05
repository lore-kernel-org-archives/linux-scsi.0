From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Fix possible NULL pointer dereference
Date: Tue, 5 Jul 2016 14:38:39 +0200
Message-ID: <20160705123839.icbrfwyru4z3gc67@c203.arch.suse.de>
References: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
 <5772DDE3.30600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5772DDE3.30600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 28, 2016 at 01:28:19PM -0700, Tyrel Datwyler wrote:
> On 06/15/2016 06:00 AM, Johannes Thumshirn wrote:
> > Check for the existance of pciob->vport before accessing it.
>=20
> piocb mispelled.

Oops

>=20
> >=20
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/lpfc/lpfc_sli.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_=
sli.c
> > index 70edf21..134078f 100644
> > --- a/drivers/scsi/lpfc/lpfc_sli.c
> > +++ b/drivers/scsi/lpfc/lpfc_sli.c
> > @@ -1329,15 +1329,10 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *ph=
ba, struct lpfc_sli_ring *pring,
> >  	if ((unlikely(pring->ringno =3D=3D LPFC_ELS_RING)) &&
> >  	   (piocb->iocb.ulpCommand !=3D CMD_ABORT_XRI_CN) &&
> >  	   (piocb->iocb.ulpCommand !=3D CMD_CLOSE_XRI_CN) &&
> > -	 (!(piocb->vport->load_flag & FC_UNLOADING))) {
> > -		if (!piocb->vport)
> > -			BUG();
>=20
> Granted the previous code would crash and burn in the if statement pr=
ior
> to the BUG() assertion if piocb->vport was NULL, but is the condition
> !piocb->vport still a bug here? Should that case still be asserted?

Yes, you're right. Let me see how to solve it _and_ make the statement =
a bit
more readable.

Thanks,
	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
