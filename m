From: "Joey Lee" <jlee@novell.com>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Mon, 21 Mar 2011 00:07:21 -0600
Message-ID: <4D8785C9020000230002A1D0@novprvlin0050.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: henry.su.ati@gmail.com, Joey Lee <JLee@novell.com>, James.Bottomley@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,=20

Sorry bother you for about support SATA ODD zero power in kernel.

Henry didn't reply me.=20
Could you please kindly give any comment for this topic?

Looks the SATA ODD zero power didn't have good power reserve number,
does that mean support it in Linux kernel is not worthwhile?


Thank's a lot!
Joey Lee

=E6=96=BC =E4=BA=8C=EF=BC=8C2011-02-22 =E6=96=BC 10:48 +0000=EF=BC=8Cjo=
eyli(Joey Lee) =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi Henry,
>=20
> =E6=96=BC =E4=B8=89=EF=BC=8C2010-12-08 =E6=96=BC 17:56 +0000=EF=BC=8C=
joeyli(Joey Lee) =E6=8F=90=E5=88=B0=EF=BC=9A
> > Hi Tejun,=20
> >=20
> > Nice can talk with you! :-)
> >=20
> > =E6=96=BC =E4=B8=89=EF=BC=8C2010-12-08 =E6=96=BC 18:25 +0100=EF=BC=8C=
Tejun Heo =E6=8F=90=E5=88=B0=EF=BC=9A
> > > (cc'ing linux-ide)
> > >=20
> > > Hello,
> > >=20
> > > On 12/08/2010 04:36 PM, Joey Lee wrote:
> > > > Dear all expert,=20
> > > >=20
> > > > Hi, m... I just google the SATA ODD zero power support and foun=
d Henry
> > > > already contribute the patch:
> > > >=20
> > > >  http://kerneltrap.org/mailarchive/linux-scsi/2010/6/25/6885558
> > > >=20
> > > > And, after first round review,=20
> > > > The second version is here:
> > > >  http://www.spinics.net/lists/linux-scsi/msg44925.html
> > > >=20
> > > > But, I didn't see this patch merged in kernel maintain, does th=
ere have
> > > > any problem with this patch? or actually the patch already in q=
ueue
> > > > waiting to merge to mainline?
> > > >=20
> > > > I appreciate if can have any comment to me.
> > >=20
> > > IIRC, at the time, the problem was that nobody had the hardware a=
nd
> > > the implementation was solely based on the specification only.  I
> > > didn't want it to go in without any actual testing, so it was put=
 on
> > > hold for the time being.  Do you have access to a device with zse=
ro
> > > power support?  If so, are you willing to test the implementation=
?
> > >=20
> >=20
> > Got it!
> > I will do the testing if I get hardware can support this function.
> >=20
>=20
> I received a AMD notebook, there have _PS3 method in DSDT table. Afte=
r
> test, your SATA ODD zero power patch works to me. The /dev/sr0 was
> removed when there have no media in tray, patch set ODD power to zero=
=2E
>=20
> But I have a bit questions:
>=20
> - I suggest add the kernel config check in drivers/scsi/sr.c like the
> following, it can avoid compiler error when we disable
> BLK_DEV_SR_ZERO_POWER:
>=20
> +#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
> +       cd->type =3D buffer[n + 6] >> 5;
> +#endif
>=20
>=20
> > > Hmmm... at the same time, I'm a little bit doubtful about its
> > > usefulness.  How much power does it save?  Furthermore, ODDs are =
often
> >=20
> > I am not sure how many watts can be save, it's need use 2-channel p=
ower
> > meter or NetDAQ to verify. I know how to do that, just need the sam=
ple
> > machine.
> >=20
>=20
> - After hardware guys test power consumption by 2 channel power-mette=
r,
> the patch can save 0.1 - 0.2 W (depend on different ODD hardware) whe=
n
> ODD power set to zero. This number is not high.
>=20
> My question is:
> What's the different between "ODD Zero power" with "SATA Link Power
> Management on ODD"?
>=20
> (Sorry for I cann't publish more detail power-metter result because i=
t's
> from my customer's lab.)
>=20
>=20
> > > omitted on mobile devices these days.  So, I have a slight reluct=
ance
> > > against including it but if the implementation is clean enough an=
d
> > > there is enough benefits it shouldn't be too difficult to overcom=
e.
> >=20
> > Fully understood!
> >=20
> >=20
> > Thank's a lot!
> > Joey Lee
>=20
> The last question is:
>=20
> - This Linux patch's behavior is different with Windows platform:
> When ODD go to "Zero power" mode, if I want to open tray then I need
> press ODD's tray button TWICE: The first time is enable ODD power and
> second time for open the tray.
> But, on Windows, just need press tray button ONE time, then the tray =
can
> be opened.=20
>=20
> Does it possible modify your patch to enable ODD power then direct op=
en
> tray?
>=20
>=20
>=20
> Thank's a lot!
> Joey Lee
>=20


