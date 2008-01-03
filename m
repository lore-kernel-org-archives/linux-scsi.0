From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: advansys broken (at least) on ARM and MIPS
Date: Thu, 3 Jan 2008 16:56:37 +0000
Message-ID: <20080103165637.GB2752@flint.arm.linux.org.uk>
References: <20080103074353.GD22470@deprecation.cyrius.com> <1199373667.3122.6.camel@localhost.localdomain> <20080103155549.GA29400@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56123 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbYACQ5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 11:57:00 -0500
Content-Disposition: inline
In-Reply-To: <20080103155549.GA29400@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Thu, Jan 03, 2008 at 04:55:49PM +0100, Martin Michlmayr wrote:
> Adding Russell King to CC who can hopefully answer James' question
> below.
>=20
> * James Bottomley <James.Bottomley@HansenPartnership.com> [2008-01-03=
 09:21]:
> > On Thu, 2008-01-03 at 08:43 +0100, Martin Michlmayr wrote:
> > > Commit 9d511a4b29de6764931343d03e493f2e04df0271 removed the "depe=
nds
> > > on BROKEN || X86_32" line from advansys' Kconfig entry.  I'm not =
sure
> > > that was such a great idea - the module doesn't compile at least =
on
> > > ARM and MIPS:
> > >=20
> > > ARM:
> > >=20
> > >   CC [M]  drivers/scsi/advansys.o
> > > drivers/scsi/advansys.c:71:2: warning: #warning this driver is st=
ill not properly converted to the DMA
> > >  API
> > > drivers/scsi/advansys.c: In function =E2=80=98AdvBuildCarrierFree=
list=E2=80=99:
> > > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=
=99 is deprecated (declared at include/asm/memory.h:1
> > > 92)
> > > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=
=99 is deprecated (declared at include/asm/memory.h:1
> > > 92)
> > > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=
=99 is deprecated (declared at include/asm/memory.h:1
> > > 92)
> > > ...
> > > drivers/scsi/advansys.c: In function =E2=80=98advansys_get_sense_=
buffer_dma=E2=80=99:
> > > drivers/scsi/advansys.c:9885: error: implicit declaration of func=
tion =E2=80=98dma_cache_sync=E2=80=99
> >=20
> > That error doesn't look to tbe the fault of the driver.
> > dma_cache_sync() is a piece of the DMA API it looks like ARM doesn'=
t
> > implement?

Let's look at the code:

        scp->SCp.dma_handle =3D dma_map_single(board->dev, scp->sense_b=
uffer,
                                sizeof(scp->sense_buffer), DMA_FROM_DEV=
ICE);
        dma_cache_sync(board->dev, scp->sense_buffer,
                                sizeof(scp->sense_buffer), DMA_FROM_DEV=
ICE);

What's the point of that dma_cache_sync() ?

Ah - this is why - sense_buffer could share the same cache line as SCp.

        unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
                                /* obtained by REQUEST SENSE when
                                 * CHECK CONDITION is received on origi=
nal
                                 * command (auto-sense) */

        /* Low-level done function - can be used by low-level driver to=
 point
         *        to completion function.  Not used by mid/upper level =
code. */
        void (*scsi_done) (struct scsi_cmnd *);

        /*
         * The following fields can be written to by the host specific =
code.
         * Everything else should be left alone.
         */
        struct scsi_pointer SCp;        /* Scratchpad used by some host=
 adapters */

So reading or writing scp->SCp.dma_handle could destroy what
dma_map_single() did.

However, that's not the end of the issue, because if the cache line is
shared, the very next action the driver does:

        return cpu_to_le32(scp->SCp.dma_handle);

will result in the cache line being re-loaded into the cache.  So even =
if
we did implement dma_cache_sync(), this driver would still be broken.


The real answer in this case is to fix the driver - even with
dma_cache_sync() implemented, the driver is still broken on ARM.  Or fi=
x
the SCSI core problem which causes driver writers to write crap code li=
ke
this - like BenH has been trying to do.  See the threads on lkml from
BenH:

Subject: [PATCH 1/2] DMA buffer alignment annotations
Subject: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer i=
n scsi_cmnd

=46ixing that in some way and removing that redundant and improper
dma_cache_sync() will fix the driver properly on ARM.  Anything else
is just papering over the problem.

Matthew disagrees with BenH on his method of fixing this - but not that
there is a problem.  So this driver can be added to Matthew's list of
"broken drivers that DMA directly to the SCSI command structure".  So
Matthew's wrong to globally remove the 'BROKEN' annotation in the Kconf=
ig.

--=20
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
