From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 2] SCSI: explain the hidden scsi_wait_scan Kconfig
 variable
Date: Thu, 18 Jun 2009 21:03:23 +0200 (CEST)
Message-ID: <tkrat.da2728358fccf96e@s5r6.in-berlin.de>
References: <4A384FE4.9090703@gmail.com>
 <20090617021254.GQ19977@parisc-linux.org>
 <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
 <1245338486.7586.13.camel@mulgrave.site>
 <20090618165926.GA13229@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757531AbZFRTDy@vger.kernel.org>
In-Reply-To: <20090618165926.GA13229@uranus.ravnborg.org>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
item.  These patches aren't accepted upstream, so let's stop the ongoing
irritation of people due to the unconditionally installed module and its
Kconfig symbol.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
update 1: more precise wording
update 2: same as comment instead of help (pick what you like better)

 drivers/scsi/Kconfig |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/Kconfig
===================================================================
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -259,10 +259,21 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate  # No prompt here, this is an invisible symbol.
 	default m
 	depends on SCSI
 	depends on MODULES
+# scsi_wait_scan is a loadable module which waits until all the async scans are
+# complete.  The idea is to use it in initrd/ initramfs scripts.  You modprobe
+# it after all the modprobes of the root SCSI drivers and it will wait until
+# they have all finished scanning their buses before allowing the boot to
+# proceed.  (This method is not applicable if targets boot independently in
+# parallel with the initiator, or with transports with non-deterministic target
+# discovery schemes, or if a transport driver does not support scsi_wait_scan.)
+#
+# This symbol is not exposed as a prompt because little is to be gained by
+# disabling it, whereas people who accidentally switch it off may wonder why
+# their mkinitrd gets into trouble.
 
 menu "SCSI Transports"
 	depends on SCSI

-- 
Stefan Richter
-=====-==--= -==- =--=-
http://arcgraph.de/sr/
