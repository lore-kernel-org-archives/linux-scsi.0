From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
Date: Wed, 17 Jun 2009 12:07:27 +0200 (CEST)
Message-ID: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
References: <4A384FE4.9090703@gmail.com>
 <20090617021254.GQ19977@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56399 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZFQKHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 06:07:32 -0400
In-Reply-To: <20090617021254.GQ19977@parisc-linux.org>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Changli Gao <xiaosuo@gmail.com>, James.Bottomley@HansenPartnership.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
item.  These patches aren't accepted upstream, so let's stop the ongoing
irritation of people due to this obscure and strange installed module
and its Kconfig option.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/Kconfig |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/Kconfig
===================================================================
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -259,10 +259,25 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate  # No prompt here, this is a hidden option.
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  Wait until all the async scans are complete.  The idea is to use
+	  it in initrd/ initramfs scripts.  You modprobe it after all the
+	  modprobes of the root SCSI drivers and it will wait until they
+	  have all finished scanning their buses before allowing the boot
+	  to proceed.
+
+	  Of course this does not work if targets boot independently of and
+	  in parallel with the initiator, and/ or with transports with non-
+	  deterministic target discovery schemes, and/ or if a transport
+	  driver does not support scsi_wait_scan.
+
+	  Still, this option is not exposed as a prompt because little is
+	  to be gained by disabling it, whereas people who accidentally
+	  switch it off may wonder why their mkinitrd gets into trouble.
 
 menu "SCSI Transports"
 	depends on SCSI

-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/

