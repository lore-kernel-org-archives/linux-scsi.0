From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: Let users disable SCSI_WAIT_SCAN to be built
Date: Tue, 15 May 2007 23:56:32 +0200 (CEST)
Message-ID: <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
 <17841.simon.1179228389@5ec7c279.invalid>
 <20070515120228.GI10562@parisc-linux.org>
 <4649E03A.1090004@simon.arlott.org.uk>
 <20070515172905.GJ10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47744 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbXEOV4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 17:56:51 -0400
In-Reply-To: <20070515172905.GJ10562@parisc-linux.org>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-packagers@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/Kconfig |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc1/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.22-rc1.orig/drivers/scsi/Kconfig
+++ linux-2.6.22-rc1/drivers/scsi/Kconfig
@@ -241,11 +241,19 @@ config SCSI_SCAN_ASYNC
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
-config SCSI_WAIT_SCAN
+config SCSI_WAIT_SCAN_NO_Y
 	tristate
 	default m
-	depends on SCSI
-	depends on MODULES
+
+config SCSI_WAIT_SCAN
+	tristate "Pseudo driver which waits for SCSI scanning to finish"
+	depends on MODULES && SCSI && SCSI_WAIT_SCAN_NO_Y
+	help
+	  When loaded, this module will do nothing else than wait for
+	  SCSI low-level drivers to finish asynchronous scanning.
+	  The module will be called scsi_wait_scan.
+
+	  Most people can say n here.
 
 menu "SCSI Transports"
 	depends on SCSI


Is there a better way to restrict SCSI_WAIT_SCAN to m and n?
-- 
Stefan Richter
-=====-=-=== -=-= -====
http://arcgraph.de/sr/

