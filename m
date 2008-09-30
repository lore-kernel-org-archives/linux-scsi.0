From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Tue, 30 Sep 2008 14:31:08 +0300
Message-ID: <20080930113108.GU8356@deprecation.cyrius.com>
References: <20080930072354.GA24133@deprecation.cyrius.com> <20080930073439.GA11059@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:1149 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbYI3Lbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 07:31:36 -0400
Content-Disposition: inline
In-Reply-To: <20080930073439.GA11059@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2008-09-30 03:34]:
> I'd still call it broken everywhere.  People who really care about this
> driver should just help with the full dma api translation, if only by
> testing patches.

I don't have the hardware or care about the driver, but I care about
the compilation errors on ARM and MIPS that were not there before
willy's patch.  Anyway, since you say it's broken, how about putting
back in the original Kconfig depends and add parisc to the list.

I don't care which patch goes in, as long as the compilation error
goes away.


From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] scsi: Enable advansys on x86_32 and parisc only

Commit 9d511a4b29de6764931343d03e493f2e04df0271 ("advansys: Changes to
work on parisc") removed the "depends on BROKEN || X86_32" line from
the advansys Kconfig entry.  Unfortunately, this led to compilation
errors on ARM and MIPS (that are not related).  Nobody looked into this
issue since I reported it in January 2008, but Russell King said that
the driver is completely broken on ARM, and Christoph Hellwig
calls it "broken everywhere".  So let's put in the original depends on
BROKEN and make the driver available on x86_32 and parisc.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -520,6 +520,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI && VIRT_TO_BUS
 	depends on ISA || EISA || PCI
+	depends on BROKEN || X86_32 || PARISC
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in

-- 
Martin Michlmayr
http://www.cyrius.com/
