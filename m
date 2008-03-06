From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 6 Mar 2008 23:39:38 +0200
Message-ID: <20080306213938.GA1574@cs181133002.pp.htv.fi>
References: <200803062009.20309.toralf.foerster@gmx.de> <20080306202246.GB5259@cs181133002.pp.htv.fi> <1204835467.3062.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60946 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbYCFVjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2008 16:39:48 -0500
Content-Disposition: inline
In-Reply-To: <1204835467.3062.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 02:31:07PM -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 22:22 +0200, Adrian Bunk wrote:
> > This patch fixes the following build error reported by Toralf F=C3=B6=
rster:
> >=20
> > <--  snip  -->
> >=20
> > ...
> >   MODPOST 243 modules
> > ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_change_queue_type" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_change_queue_depth" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_target_destroy" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_target_alloc" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_slave_destroy" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_slave_configure" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_eh_bus_reset_handler" [drivers/scsi/mvsas.ko] undefined=
!
> > ERROR: "sas_eh_device_reset_handler" [drivers/scsi/mvsas.ko] undefi=
ned!
> > ERROR: "sas_queuecommand" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_ioctl" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_register_ha" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_domain_attach_transport" [drivers/scsi/mvsas.ko] undefi=
ned!
> > ERROR: "sas_ssp_task_response" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_slave_alloc" [drivers/scsi/mvsas.ko] undefined!
> > ERROR: "sas_unregister_ha" [drivers/scsi/mvsas.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> >=20
> > <--  snip  -->
> >=20
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >=20
> > ---
> > --- a/drivers/scsi/aic94xx/Kconfig
> > +++ b/drivers/scsi/aic94xx/Kconfig
> > @@ -26,7 +26,7 @@
> > =20
> >  config SCSI_AIC94XX
> >  	tristate "Adaptec AIC94xx SAS/SATA support"
> > -	depends on PCI
> > +	depends on SCSI && PCI
> >  	select SCSI_SAS_LIBSAS
> >  	select FW_LOADER
>=20
> This doesn't look to be a fix for your error: the symbols you've list=
ed
> as missing are all libsas ones, not core SCSI ones.  Also they're all
> claiming to be missing from mvsas, not aic94xx.  There's something el=
se
> about the configuration that produced this error.

This is the right fix for this bug.

We have:
- SCSI=3Dm
- SCSI_AIC94XX=3Dy
- SCSI_MVSAS=3Dm
- SCSI_SAS_LIBSAS=3Dy

The problem is:
- SCSI_AIC94XX selects (and requires) SCSI_SAS_LIBSAS
- SCSI_MVSAS selects (and requires) SCSI_SAS_LIBSAS
- with SCSI=3Dm a SCSI_SAS_LIBSAS=3Dy is not linked into the kernel

SCSI_AIC94XX=3Dy also results in the AIC94xx driver not being linked in=
to=20
the kernel here (and that's also fixed by this patch), but this alone=20
wouldn't result in a build bug...

> James

cu
Adrian

--=20

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
