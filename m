From: Chris Adams <cmadams@hiwaay.net>
Subject: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 11:04:52 -0600
Message-ID: <20041110170451.GA1061425@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bee.hiwaay.net ([216.180.54.11]:19828 "EHLO bee.hiwaay.net")
	by vger.kernel.org with ESMTP id S262016AbUKJRE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 12:04:57 -0500
Received: from bee.hiwaay.net (bee.hiwaay.net [216.180.54.11])
	by bee.hiwaay.net (8.13.0/8.13.0) with ESMTP id iAAH4qFv1068940
	for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2004 11:04:54 -0600 (CST)
Received: (from cmadams@localhost)
	by bee.hiwaay.net (8.13.0/8.13.0/DefSubmit) id iAAH4qmP1063159
	for linux-scsi@vger.kernel.org; Wed, 10 Nov 2004 11:04:52 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've got some systems that need the old megaraid driver with Fedora Core
3, however it isn't being built.  Looking at Kconfig.megaraid, I see
that the new and old drivers are mutually exclusive?  Is there a reason
for that?  It means that packagers can't build both as modules.

Is there a good reason not to do:

diff -urN linux-2.6.9-dist/drivers/scsi/megaraid/Kconfig.megaraid linux-2.6.9/drivers/scsi/megaraid/Kconfig.megaraid
--- linux-2.6.9-dist/drivers/scsi/megaraid/Kconfig.megaraid	2004-10-18 16:53:22.000000000 -0500
+++ linux-2.6.9/drivers/scsi/megaraid/Kconfig.megaraid	2004-11-10 10:33:26.748570929 -0600
@@ -63,7 +63,6 @@
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
 
-if MEGARAID_NEWGEN=n
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
 	depends on PCI && SCSI
@@ -74,4 +73,3 @@
 
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid
-endif


I looked in MAINTAINERS, CREDITS, megaraid.txt, and ChangeLog.megaraid,
but I didn't see that there was any more specific list to use for the
megaraid driver (other than three author addresses listed in
megaraid_mbox.c).

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
