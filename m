From: akpm@linux-foundation.org
Subject: [patch 09/27] g_NCR5380: remove misleading pnp error message
Date: Tue, 20 Jul 2010 15:28:48 -0700
Message-ID: <201007202228.o6KMSm2q021735@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925Ab0GTWbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:31:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux@rainbow-software.org

From: Ondrej Zary <linux@rainbow-software.org>

Remove misleading error message that appears after pnp card has been
detected correctly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-remove-misleading-pnp-error-message drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~g_ncr5380-remove-misleading-pnp-error-message
+++ a/drivers/scsi/g_NCR5380.c
@@ -322,10 +322,8 @@ int __init generic_NCR5380_detect(struct
 		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
 			if (count >= NO_OVERRIDES)
 				break;
-			if (pnp_device_attach(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: attach failed\n");
+			if (pnp_device_attach(dev) < 0)
 				continue;
-			}
 			if (pnp_activate_dev(dev) < 0) {
 				printk(KERN_ERR "dtc436e probe: activate failed\n");
 				pnp_device_detach(dev);
_
