From: Judith Lebzelter <judith@linux-foundation.org>
Subject: Re: [PATCH] aacraid: [Fastboot] Panics for AACRAID driverduring'insmod' for kexec test [take 4]
Date: Tue, 3 Apr 2007 09:54:10 -0700
Message-ID: <20070403165410.GE10239@shell0.pdx.osdl.net>
References: <1175611901.3645.3.camel@mulgrave.il.steeleye.com> <AE4F746F2AECFC4DA4AADD66A1DFEF017AA267@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964976AbXDCQyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Apr 2007 12:54:36 -0400
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA267@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Judith Lebzelter <judith@linux-foundation.org>, vgoyal@in.ibm.com, linux-scsi@vger.kernel.org

Hi Mark,

I was going to try and test this patch rather than the last, but I am g=
etting=20
this compile error again where line 640 is the beginning of function aa=
c_rx_init():

CC [M]  drivers/scsi/aacraid/rx.o
drivers/scsi/aacraid/rx.c: In function '_aac_rx_init':
drivers/scsi/aacraid/rx.c:640: warning: ISO C90 forbids mixed declarati=
ons and code
drivers/scsi/aacraid/rx.c:649: error: expected declaration or statement=
 at end of input
drivers/scsi/aacraid/rx.c:649: warning: control reaches end of non-void=
 function
make[3]: *** [drivers/scsi/aacraid/rx.o] Error 1
make[2]: *** [drivers/scsi/aacraid] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

I applied it to the scsi-misc tree I pulled yesterday after removing th=
e old patch.=20

Judith


On Tue, Apr 03, 2007 at 11:58:17AM -0400, Salyzyn, Mark wrote:
> I will do you one better, James, I will slip in a little cleanup in s=
a.c (support file for the old PPC based ARC cards) where I discovered t=
he restart platform function was ALSO left unset which could result in =
similar pain of null pointer discovery.
>=20
> Please note: The issue Judith ran into, where the card took longer th=
an 3 minutes to initialize because of a problem drive may require the e=
xtension of the timeout to address (insmod parameter aacraid.startup_ti=
meout=3D540 may do the trick). Extending the timeout may have been a fa=
ct of life given that the restart of the adapter normally occurs on BIO=
S load long before the driver instantiates settling the problem drives;=
 if this is the case a small and lower priority follow-up hardening pat=
ch can help the users that find adding the insmod parameter repugnant i=
n order to support kexec and kdump in the face of problem drives. Probl=
em drives may have lead to the need to get a kernel dump ...
>=20
> You will find enclosed the pristine patch based on the initial patch,=
 dropping the static function, and adding the three missing platform fu=
nction initializations.
>=20
> Attached is the patch I feel will address this interrupt issue. As an=
 added 'perk' I have also added the code to detect if the controller wa=
s previously initialized for interrupted operations by ANY operating sy=
stem should the reset_devices kernel parameter not be set and we are de=
aling with a na=EFve kexec without the addition of this kernel paramete=
r. The reset handler is also improved. Related to reset operations, but=
 not pertinent specifically to this issue, I have also altered the hand=
ling somewhat so that we reset the adapter if we feel it is taking too =
long (three minutes) to start up.
>=20
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook'=
s handling of patches.
>=20
> This attached patch is against current scsi-misc-2.6 MINUS the initia=
l version of this patch and the first patch that sets the missing platf=
orm function related to this discussion.
> =20
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>=20
> ---
>=20
> Sincerely -- Mark Salyzyn
>=20
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@SteelEye.com]=20
> > Sent: Tuesday, April 03, 2007 10:52 AM
> > To: Salyzyn, Mark
> > Cc: Judith Lebzelter; vgoyal@in.ibm.com
> > Subject: RE: [PATCH] aacraid: [Fastboot] Panics for AACRAID=20
> > driverduring'insmod' for kexec test.
> >=20
> >=20
> > On Tue, 2007-04-03 at 09:30 -0400, Salyzyn, Mark wrote:
> > > 0x48 status code means the Firmware is trying to boot the=20
> > Kernel. This
> > > phase is most likely blocked because of the hard drive=20
> > failure as you
> > > suspected; the kernel is not declared up and running until after =
the
> > > drives have spun up, and a problem drive could be tricking=20
> > the Firmware
> > > into a recovery loop holding things back ...
> >=20
> > I'm constructing what I hope will be the last pre 2.6.21=20
> > merge tree ...
> > do you have a clean patch with the two necessary fixes for=20
> > the panic you
> > can send to the list?
> >=20
> > James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
