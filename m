From: Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources.
Date: Thu, 10 Dec 2009 17:36:44 +0100
Message-ID: <20091210173644.20a86b88@wker>
References: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
	<1260459818.2457.77.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:43391 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZLJQgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 11:36:41 -0500
In-Reply-To: <1260459818.2457.77.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Pravin Bathija <pbathija@amcc.com>, linuxppc-dev@ozlabs.org, Eric.Moore@lsi.com, linux-scsi@vger.kernel.org

On Thu, 10 Dec 2009 09:43:38 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2009-12-02 at 17:51 -0800, Pravin Bathija wrote:
> > Powerpc 44x uses 36 bit real address while the real address defined
> >     in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
> >     fails to initialize. This fix changes the data types representing the real
> >     address from unsigned long 32-bit types to resource_size_t which is 64-bit. The
> >     driver has been tested, the disks get discovered correctly and can do IO.
> > 
> > Signed-off-by: Pravin Bathija <pbathija@amcc.com>
> > Acked-by: Feng Kan <fkan@amcc.com>
> > Acked-by: Fushen Chen <fchen@amcc.com>
> > Acked-by: Loc Ho <lho@amcc.com>
> > Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
> > Acked-by: Victor Gallardo <vgallardo@amcc.com>
> > ---
> >  drivers/message/fusion/mptbase.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> > index 5d496a9..9f14a60 100644
> > --- a/drivers/message/fusion/mptbase.c
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -1511,7 +1511,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> >  {
> >  	u8		__iomem *mem;
> >  	int		 ii;
> > -	unsigned long	 mem_phys;
> > +	resource_size_t	 mem_phys;
> 
> You never actually compiled this, did you?
> 
> drivers/message/fusion/mptbase.c: In function 'mpt_mapresources':
> drivers/message/fusion/mptbase.c:1680: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'
> 
> I'll just fold the fix in

another patch (inlined below) should probably also go in as 'mem_phys' is
assigned to ioc->mem_phys which is 'u32'. ioc->mem_phys is never used in
the driver, however.

Some time ago I posted a patch which enables using second LSI SAS HBA on
PPC440SPe based katmai board again:

http://thread.gmane.org/gmane.linux.scsi/54839

Could someone comment on this patch, please. Thanks!

Anatolij

---

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8dd4d21..8dc58e3 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -605,7 +605,7 @@ typedef struct _MPT_ADAPTER
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
 	u8			 bus_type;
-	u32			 mem_phys;	/* == f4020000 (mmap) */
+	resource_size_t		 mem_phys;	/* == f4020000 (mmap) */
 	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */
 	int			 mem_size;	/* mmap memory size */
 	int			 number_of_buses;
