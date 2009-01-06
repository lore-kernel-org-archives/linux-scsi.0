From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 6/6] fastboot: Make libata initialization even more async
Date: Mon, 5 Jan 2009 20:13:44 -0800
Message-ID: <20090105201344.33cf1213@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbZAFENm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 23:13:42 -0500
In-Reply-To: <20090105200959.04a626ac@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

>From d9edec388ac06b74f190ed9ea929158003b915ee Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 5 Jan 2009 15:07:07 -0800
Subject: [PATCH] fastboot: Make libata initialization even more async

As suggested by Linus: Don't do the libata init in 2 separate
steps with a global sync inbetween, but do it as one async step,
with a local sync before registering the device.

This cuts the boottime on my machine with 2 sata controllers down
significantly, and it seems to work. Would be nice if the libata
folks take a good look at this patch though..

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/ata/libata-core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fe2c208..5d4f7e5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5951,6 +5951,12 @@ void async_port_probe(void *data, async_cookie_t cookie)
 			 */
 		}
 	}
+
+	/* in order to keep device order, we need to synchronize at this point */
+	async_synchronize_cookie(cookie);
+
+	ata_scsi_scan_host(ap, 1);
+
 }
 /**
  *	ata_host_register - register initialized ATA host
@@ -6033,15 +6039,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		struct ata_port *ap = host->ports[i];
 		async_schedule(async_port_probe, ap);
 	}
-	async_synchronize_full();
-	/* probes are done, now scan each port's disk(s) */
-	DPRINTK("host probe begin\n");
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		ata_scsi_scan_host(ap, 1);
-	}
-	DPRINTK("host probe end\n");
+	DPRINTK("probe end\n");
 
 	return 0;
 }
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
