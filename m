From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] g_NCR5380: Fix release_region in error handling
Date: Fri, 11 Nov 2016 10:00:20 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611110934080.17328@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43776 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756140AbcKJXAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 18:00:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <james.bottomley@hansenpartnership.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

When a SW-configurable card is specified but not found, the driver
releases wrong region, causing the following message in kernel log:
Trying to free nonexistent resource <0000000000000000-000000000000000f>

Fix it by assigning base earlier.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Fixes: a8cfbcaec0c1 ("scsi: g_NCR5380: Stop using scsi_module.c")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/g_NCR5380.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 6a08d3e..d33e71f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -258,12 +258,12 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		if (ports[i]) {
 			/* At this point we have our region reserved */
 			magic_configure(i, 0, magic); /* no IRQ yet */
-			outb(0xc0, ports[i] + 9);
-			if (inb(ports[i] + 9) != 0x80) {
+			base = ports[i];
+			outb(0xc0, base + 9);
+			if (inb(base + 9) != 0x80) {
 				ret = -ENODEV;
 				goto out_release;
 			}
-			base = ports[i];
 			port_idx = i;
 		} else
 			return -EINVAL;
