From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RESEND] SCSI: ips: remove pointless #warning
Date: Tue, 19 May 2015 15:33:28 +0200
Message-ID: <3121960.dnOqT9LCth@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58944 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbESNeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 09:34:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>

The ips driver contains

 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"

which gets printed by the compiler every time this driver gets
build for something other than those three architectures. The same
is true for most other drivers, but none of them prints a warning like
this.

Let's remove the warning now to reduce the amount of clutter.

FWIW, I've reviewed the driver and found a few oddities, but nothing
that needs to be fixed or that would be architecture specific.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Submitted last in January, but got no reply

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7542f11d3fcd..d86673a4cdb4 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -206,10 +206,6 @@ module_param(ips, charp, 0);
 #define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
 #define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
-#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
-#endif
-
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \

