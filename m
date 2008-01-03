From: Martin Michlmayr <tbm@cyrius.com>
Subject: advansys broken (at least) on ARM and MIPS
Date: Thu, 3 Jan 2008 08:43:53 +0100
Message-ID: <20080103074353.GD22470@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2000 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbYACIHy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 03:07:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>

Commit 9d511a4b29de6764931343d03e493f2e04df0271 removed the "depends
on BROKEN || X86_32" line from advansys' Kconfig entry.  I'm not sure
that was such a great idea - the module doesn't compile at least on
ARM and MIPS:

ARM:

  CC [M]  drivers/scsi/advansys.o
drivers/scsi/advansys.c:71:2: warning: #warning this driver is still no=
t properly converted to the DMA
 API
drivers/scsi/advansys.c: In function =E2=80=98AdvBuildCarrierFreelist=E2=
=80=99:
drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 is=
 deprecated (declared at include/asm/memory.h:1
92)
drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 is=
 deprecated (declared at include/asm/memory.h:1
92)
drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99 is=
 deprecated (declared at include/asm/memory.h:1
92)
=2E..
drivers/scsi/advansys.c: In function =E2=80=98advansys_get_sense_buffer=
_dma=E2=80=99:
drivers/scsi/advansys.c:9885: error: implicit declaration of function =E2=
=80=98dma_cache_sync=E2=80=99

MIPS:

  Building modules, stage 2.
  MODPOST 64 modules
ERROR: "free_dma" [drivers/scsi/advansys.ko] undefined!

--=20
Martin Michlmayr
http://www.cyrius.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
