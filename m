From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 10:47:23 +1100
Message-ID: <20170213104723.7741de0a@kryten>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <1486941294.3401.67.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hr2.samba.org ([144.76.82.148]:49804 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdBLXrm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Feb 2017 18:47:42 -0500
In-Reply-To: <1486941294.3401.67.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, ebiederm@xmission.com
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

Hi Ben,

On Mon, 13 Feb 2017 10:14:54 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2017-02-13 at 08:49 +1100, Anton Blanchard wrote:
> > From: Anton Blanchard <anton@samba.org>
> >=20
> > We see lpfc devices regularly fail during kexec. Fix this by adding
> > a shutdown method which mirrors the remove method. =20
>=20
> Or instead finally do what I've been advocating for years (and even
> sent patches for) which is to have kexec call remove instead of
> shutdown.
>
> Shutdown is and has *always* been the wrong thing to do.

Good point, at the very least we should call remove if shutdown doesn't
exist. Eric: could we make the changes Ben suggests?

Anton

> > Signed-off-by: Anton Blanchard <anton@samba.org>
> > ---
> > =C2=A0drivers/scsi/lpfc/lpfc_init.c | 1 +
> > =C2=A01 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/scsi/lpfc/lpfc_init.c
> > b/drivers/scsi/lpfc/lpfc_init.c
> > index 4776fd8..10f75ad 100644
> > --- a/drivers/scsi/lpfc/lpfc_init.c
> > +++ b/drivers/scsi/lpfc/lpfc_init.c
> > @@ -11447,6 +11447,7 @@ static struct pci_driver lpfc_driver =3D {
> > =C2=A0	.id_table	=3D lpfc_id_table,
> > =C2=A0	.probe		=3D lpfc_pci_probe_one,
> > =C2=A0	.remove		=3D lpfc_pci_remove_one,
> > +	.shutdown	=3D lpfc_pci_remove_one,
> > =C2=A0	.suspend=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D lpfc=
_pci_suspend_one,
> > =C2=A0	.resume		=3D lpfc_pci_resume_one,
> > =C2=A0	.err_handler=C2=A0=C2=A0=C2=A0=C2=A0=3D &lpfc_err_handler, =20
>=20
