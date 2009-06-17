From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] scsi_wait_scan: no option appears when configuring for scsi_wait_scan.
Date: Wed, 17 Jun 2009 10:07:32 +0800
Message-ID: <4A384FE4.9090703@gmail.com>
Reply-To: xiaosuo <xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:48763 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZFQCHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 22:07:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>

FIXBUG: missing comment after tristate leads to no option for
scsci_wait_scan when configuring.

When build kernel, this module is always built if I choose SCSI, and I
can't find any option in the configuration menu, so I can't disable it
or build it into kernel statically. After diving into the kernel source
code, I found no comment after keyword tristate, then I added the
comment and help.

Signed-off-by: Changli Gao <xiaosuo@gmail.com <mailto:xiaosuo@gmail.com>>
----

Kconfig | 7 ++++++-
1 file changed, 6 insertions(+), 1 deletion(-)

--- drivers/scsi/Kconfig.orig	2009-06-17 09:52:46.000000000 +0800
+++ drivers/scsi/Kconfig	2009-06-17 09:55:57.000000000 +0800
@@ -259,10 +259,15 @@
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait until all the async scans are complete"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  Wait until all the async scans are complete. The idea is to use it in
+	  initrd/initramfs scripts.  You modprobe it after all the modprobes of
+	  the root SCSI drivers and it will wait until they have all finished
+	  scanning their busses before allowing the boot to proceed
 
 menu "SCSI Transports"
 	depends on SCSI

