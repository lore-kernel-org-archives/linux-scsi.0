From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Tue, 30 May 2006 08:53:56 -0700
Message-ID: <20060530085356.0059596c.rdunlap@xenotime.net>
References: <890BF3111FB9484E9526987D912B261901BD99@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:29335 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751402AbWE3PvS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 11:51:18 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 08:51:16 -0700
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD99@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: ismail@pardus.org.tr, linux-scsi@vger.kernel.org, akpm@osdl.org, james.bottomley@steeleye.com, Neela.Kolli@engenio.com

On Tue, 30 May 2006 07:37:18 -0600 Ju, Seokmann wrote:

> Hi,
>=20
> Thursday, May 25, 2006 12:46 PM, Randy Dunlap wrote:
> > Fix section warning:
> > WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section=20
> > mismatch: reference to .init.text: from .text between=20
> > 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command=
'
> >=20
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
> >  1 files changed, 1 insertion(+), 1 deletion(-)
> >=20
> > --- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
> > +++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
> > @@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
> >   * . Allocate memory required for all the commands
> >   * . Use internal library of FW routines, build up complete=20
> > soft state
> >   */
> > -static int __init
> > +static int __devinit
> >  megaraid_init_mbox(adapter_t *adapter)
> >  {
> >  	struct pci_dev		*pdev;
> Thank you for pointing out a bug.
> However, in my opinion, I would rather to simply remove '__init' from=
 the function.
> The function is just a sub function called by megaraid_probe_one whic=
h has '__devinit' tag.
> Please let me know if this is acceptable.
> I will submit a patch with proper change.

Sure, go for it.

> Thanks,
>=20
> Seokmann
>=20
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org=20
> > [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Randy.Dunlap
> > Sent: Thursday, May 25, 2006 12:46 PM
> > To: __smail D=F6nmez; scsi
> > Cc: akpm; jejb; Kolli, Neela
> > Subject: [PATCH] megaraid_mbox: fix section mismatch warnings
> >=20
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >=20
> > Fix section warning:
> > WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section=20
> > mismatch: reference to .init.text: from .text between=20
> > 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command=
'
> >=20
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
> >  1 files changed, 1 insertion(+), 1 deletion(-)
> >=20
> > --- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
> > +++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
> > @@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
> >   * . Allocate memory required for all the commands
> >   * . Use internal library of FW routines, build up complete=20
> > soft state
> >   */
> > -static int __init
> > +static int __devinit
> >  megaraid_init_mbox(adapter_t *adapter)
> >  {
> >  	struct pci_dev		*pdev;

---
~Randy
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
