From: Martin Michlmayr <tbm@cyrius.com>
Subject: advansys still broken (at least) on ARM and MIPS
Date: Mon, 25 Aug 2008 15:35:45 +0300
Message-ID: <20080825123545.GA13931@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:4087 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbYHYMf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 08:35:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org

I reported the following back in January: "Commit
9d511a4b29de6764931343d03e493f2e04df0271 removed the "depends on
BROKEN || X86_32" line from advansys' Kconfig entry.  I'm not sure
that was such a great idea - the module doesn't compile at least on
ARM and MIPS", see
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12773.html
for the error messages.

Russell King had major concerns about the driver on ARM:
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12789.html

willy, are you planning to work again on this driver in the near
future?  If not, I suggest the following patch to undo some of the
damage caused by the removal of BROKEN.

--- a/drivers/scsi/Kconfig	2007-12-27 19:16:18.000000000 +0000
+++ b/drivers/scsi/Kconfig	2007-12-27 19:16:58.000000000 +0000
@@ -523,6 +523,7 @@
 	tristate "AdvanSys SCSI support"
 	depends on SCSI && VIRT_TO_BUS
 	depends on ISA || EISA || PCI
+	depends on (!MIPS && !ARM) || BROKEN
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in

-- 
Martin Michlmayr
http://www.cyrius.com/
