From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 6 Mar 2008 23:30:27 +0100
Message-ID: <20080306223027.GA2869@uranus.ravnborg.org>
References: <200803062009.20309.toralf.foerster@gmx.de> <20080306202246.GB5259@cs181133002.pp.htv.fi> <20080306203558.GA7430@tree.beaverton.ibm.com> <1204839126.3062.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:39071 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYCFWaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2008 17:30:12 -0500
Content-Disposition: inline
In-Reply-To: <1204839126.3062.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Adrian Bunk <bunk@kernel.org>, Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 03:32:06PM -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 12:35 -0800, Darrick J. Wong wrote:
> > On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> > > This patch fixes the following build error reported by Toralf F=F6=
rster:
> > >=20
> > > <--  snip  -->
> > >=20
> > > ...
> > >   MODPOST 243 modules
> > > ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
> >=20
> > <snip>
> >=20
> > > --- a/drivers/scsi/aic94xx/Kconfig
> > > +++ b/drivers/scsi/aic94xx/Kconfig
> >=20
> > Maybe I'm missing something here, but how does patching aic94xx Kco=
nfig
> > fix an mvsas build problem?
>=20
> Actually, it's a dependency chain fault.  The config this was generat=
ed
> from has
>=20
> CONFIG_SCSI=3Dm
>=20
> CONFIG_SCSI_AIC94XX=3Dy
>=20
> the latter then forces
>=20
> CONFIG_SCSI_SAS_LIBSAS=3Dy
>=20
> I think the error reported is wrong: the kernel just should have fail=
ed
> to link, since both the built in aic94xx and libsas have scsi
> dependencies.
>=20
> We have a few other drivers in this category (like ibmvscsi).  The ro=
ot
> cause seems to be that SCSI_LOWLEVEL doesn't act as a tristate.  I th=
ink
> a fix that will prevent all of these issues from recurring is this on=
e.

Until kconfig is fixed - never select a symbol with a prompt or depende=
ncies.
Then most issues are gone.

	Sam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
