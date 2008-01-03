From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: advansys broken (at least) on ARM and MIPS
Date: Thu, 03 Jan 2008 09:21:07 -0600
Message-ID: <1199373667.3122.6.camel@localhost.localdomain>
References: <20080103074353.GD22470@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60978 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbYACPVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 10:21:17 -0500
In-Reply-To: <20080103074353.GD22470@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>


On Thu, 2008-01-03 at 08:43 +0100, Martin Michlmayr wrote:
> Commit 9d511a4b29de6764931343d03e493f2e04df0271 removed the "depends
> on BROKEN || X86_32" line from advansys' Kconfig entry.  I'm not sure
> that was such a great idea - the module doesn't compile at least on
> ARM and MIPS:
>=20
> ARM:
>=20
>   CC [M]  drivers/scsi/advansys.o
> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still =
not properly converted to the DMA
>  API
> drivers/scsi/advansys.c: In function =E2=80=98AdvBuildCarrierFreelist=
=E2=80=99:
> drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 =
is deprecated (declared at include/asm/memory.h:1
> 92)
> drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 =
is deprecated (declared at include/asm/memory.h:1
> 92)
> drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 =
is deprecated (declared at include/asm/memory.h:1
> 92)
> ...
> drivers/scsi/advansys.c: In function =E2=80=98advansys_get_sense_buff=
er_dma=E2=80=99:
> drivers/scsi/advansys.c:9885: error: implicit declaration of function=
 =E2=80=98dma_cache_sync=E2=80=99

That error doesn't look to tbe the fault of the driver.
dma_cache_sync() is a piece of the DMA API it looks like ARM doesn't
implement?

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
