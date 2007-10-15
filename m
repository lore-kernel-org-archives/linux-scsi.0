From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/2] fc4/pluto - Enable compilation for all ARCHs
Date: Mon, 15 Oct 2007 13:15:54 -0700
Message-ID: <20071015131554.9a5cfb5b.randy.dunlap@oracle.com>
References: <4713A175.9020408@panasas.com>
	<4713A2DB.2000302@panasas.com>
	<20071015180949.GC25488@parisc-linux.org>
	<4713AEF0.5070706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57513 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbXJOUSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 16:18:55 -0400
In-Reply-To: <4713AEF0.5070706@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

> > I think I see two problems ... one is that fc4 plainly depends on SCSI,

Does it?  It builds with SCSI=n.

> > yet it's not mentioned in the fc4 Kconfig file.  The other is that,
> > given this dependency, fc4 should come after scsi.  And maybe even be
> > included from drivers/scsi/Kconfig rather than drivers/Kconfig.  I don't
> > have a strong feeling on that last point.

Me either.  I moved it to after scsi/Kconfig.

> This is all new territory for me. But CONFIG_SCSI_PLUTO is dependent on
> SCSI and fc.c is not the real driver just the needed bits from the sparc
> side. So the code mess calls for a Kconfig mess, I guess.
> 
> Please, anyone, try something better, it is the best I could think of.

Here's my attempt.
patch 1/2 for fc4.
patch 2/2 for one more pluto fix.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Move drivers/fc4/Kconfig to the main drivers/Kconfig file & menu.
This allows any $arch to build fc4.

fc.c (on non-sparc) uses pci interfaces, so include pci.h and
make FC4 depend on PCI || SPARC.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/sparc64/Kconfig |    2 --
 drivers/Kconfig      |    2 ++
 drivers/fc4/Kconfig  |    1 +
 drivers/fc4/fc.c     |    1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.23-git7.orig/arch/sparc64/Kconfig
+++ linux-2.6.23-git7/arch/sparc64/Kconfig
@@ -456,8 +456,6 @@ source "drivers/Kconfig"
 
 source "drivers/sbus/char/Kconfig"
 
-source "drivers/fc4/Kconfig"
-
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
--- linux-2.6.23-git7.orig/drivers/Kconfig
+++ linux-2.6.23-git7/drivers/Kconfig
@@ -24,6 +24,8 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
+source "drivers/fc4/Kconfig"
+
 source "drivers/ata/Kconfig"
 
 source "drivers/md/Kconfig"
--- linux-2.6.23-git7.orig/drivers/fc4/fc.c
+++ linux-2.6.23-git7/drivers/fc4/fc.c
@@ -30,6 +30,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
+#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- linux-2.6.23-git7.orig/drivers/fc4/Kconfig
+++ linux-2.6.23-git7/drivers/fc4/Kconfig
@@ -6,6 +6,7 @@ menu "Fibre Channel support"
 
 config FC4
 	tristate "Fibre Channel and FC4 SCSI support"
+	depends on SPARC || PCI
 	---help---
 	  Fibre Channel is a high speed serial protocol mainly used to
 	  connect large storage devices to the computer; it is compatible with
