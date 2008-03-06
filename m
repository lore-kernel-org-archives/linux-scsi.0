From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 06 Mar 2008 15:32:06 -0600
Message-ID: <1204839126.3062.57.camel@localhost.localdomain>
References: <200803062009.20309.toralf.foerster@gmx.de>
	 <20080306202246.GB5259@cs181133002.pp.htv.fi>
	 <20080306203558.GA7430@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47899 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765080AbYCFVcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:32:11 -0500
In-Reply-To: <20080306203558.GA7430@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 12:35 -0800, Darrick J. Wong wrote:
> On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> > This patch fixes the following build error reported by Toralf F=C3=B6=
rster:
> >=20
> > <--  snip  -->
> >=20
> > ...
> >   MODPOST 243 modules
> > ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
>=20
> <snip>
>=20
> > --- a/drivers/scsi/aic94xx/Kconfig
> > +++ b/drivers/scsi/aic94xx/Kconfig
>=20
> Maybe I'm missing something here, but how does patching aic94xx Kconf=
ig
> fix an mvsas build problem?

Actually, it's a dependency chain fault.  The config this was generated
from has

CONFIG_SCSI=3Dm

CONFIG_SCSI_AIC94XX=3Dy

the latter then forces

CONFIG_SCSI_SAS_LIBSAS=3Dy

I think the error reported is wrong: the kernel just should have failed
to link, since both the built in aic94xx and libsas have scsi
dependencies.

We have a few other drivers in this category (like ibmvscsi).  The root
cause seems to be that SCSI_LOWLEVEL doesn't act as a tristate.  I thin=
k
a fix that will prevent all of these issues from recurring is this one.

James


---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c46666a..b9d3740 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -325,7 +325,7 @@ menuconfig SCSI_LOWLEVEL
 	depends on SCSI!=3Dn
 	default y
=20
-if SCSI_LOWLEVEL
+if SCSI_LOWLEVEL && SCSI
=20
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
