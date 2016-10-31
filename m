From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 6/6] g_NCR5380: Fix release region in error handling
Date: Mon, 31 Oct 2016 21:18:32 +0100
Message-ID: <1477945112-25659-7-git-send-email-linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a SW-configurable card is specified but not found, the driver
releases wrong region, causing the following message in kernel log:
Trying to free nonexistent resource <0000000000000000-000000000000000f>

Fix it by assigning base earlier.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
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
-- 
Ondrej Zary
