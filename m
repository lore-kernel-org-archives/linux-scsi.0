From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: libsas depends on HAS_DMA
Date: Mon, 11 May 2009 22:59:44 +0000
Message-ID: <1242082784.27353.13.camel@mulgrave.int.hansenpartnership.com>
References: <20090511222702.352192505@arndb.de> >
	 <200905112240.20171.arnd@arndb.de>
	 <1242082233.27353.9.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53735 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758559AbZEKW7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 18:59:45 -0400
In-Reply-To: <1242082233.27353.9.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2009-05-11 at 22:50 +0000, James Bottomley wrote:
> On Mon, 2009-05-11 at 22:40 +0000, Arnd Bergmann wrote:
> > libsas uses the DMA mapping API, so it cannot be
> > built on architectures that don't support DMA.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/scsi/libsas/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
> > index 18f33cd..59e00fa 100644
> > --- a/drivers/scsi/libsas/Kconfig
> > +++ b/drivers/scsi/libsas/Kconfig
> > @@ -24,7 +24,7 @@
> >  
> >  config SCSI_SAS_LIBSAS
> >  	tristate "SAS Domain Transport Attributes"
> > -	depends on SCSI
> > +	depends on SCSI && HAS_DMA
> 
> Our unfortunate Kconfig system can cause problems if you do this:
> SCSI_SAS_LIBSAS is used as a select for drivers that need it, so either
> they'd need to select this themselves, or you need some other solution.

Actually, looking at this further, the problem is only in the ata
compatibility layer because of the way libata does dma mapping on behalf
of drivers, so the solution below (just disable SATA support if HAS_DMA
isn't defined) will work without requiring select dependency
modification.

James

---

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 18f33cd..f462a0e 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -33,6 +33,7 @@ config SCSI_SAS_LIBSAS
 config SCSI_SAS_ATA
 	bool "ATA support for libsas (requires libata)"
 	depends on SCSI_SAS_LIBSAS
+	depends on HAS_DMA
 	depends on ATA = y || ATA = SCSI_SAS_LIBSAS
 	help
 		Builds in ATA support into libsas.  Will necessitate


