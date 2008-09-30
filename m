From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Tue, 30 Sep 2008 10:23:54 +0300
Message-ID: <20080930072354.GA24133@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:4143 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYI3HYS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 03:24:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Commit 9d511a4b29de6764931343d03e493f2e04df0271 ("advansys: Changes to
work on parisc") removed the "depends on BROKEN || X86_32" line from
advansys' Kconfig entry.  Unfortunately, this led to compilation errors
on ARM and MIPS (that are not related).  Since nobody looked into this
issue since I reported it in January 2008 and Russell King said that
the driver is completely broken on ARM, let's undo some of the damage
caused by the removal of the "BROKEN" Kconfig depends by disabling the
driver on ARM and MIPS.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

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
