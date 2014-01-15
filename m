From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/41] hpsa: enable unit attention reporting
Date: Wed, 15 Jan 2014 16:36:44 -0600
Message-ID: <20140115223643.5061.28103.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30518 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAOVgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:36:45 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This used to be the default, but at some point the firmware guys
changed the default and I failed to notice.  Now to get unit
attention notifications, you must twiddle a bit indicating you
want them.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    7 ++++---
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 25afeb4..d65567a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4384,14 +4384,15 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 
 static inline void hpsa_set_driver_support_bits(struct ctlr_info *h)
 {
-#ifdef CONFIG_X86
-	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	u32 driver_support;
 
 	driver_support = readl(&(h->cfgtable->driver_support));
+#ifdef CONFIG_X86
+	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	driver_support |= ENABLE_SCSI_PREFETCH;
-	writel(driver_support, &(h->cfgtable->driver_support));
 #endif
+	driver_support |= ENABLE_UNIT_ATTN;
+	writel(driver_support, &(h->cfgtable->driver_support));
 }
 
 /* Disable DMA prefetch for the P600.  Otherwise an ASIC bug may result
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 5158709..bfc8c4e 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -358,6 +358,7 @@ struct CfgTable {
 	u32           HeartBeat;
 	u32           driver_support;
 #define			ENABLE_SCSI_PREFETCH 0x100
+#define			ENABLE_UNIT_ATTN 0x01
 	u32	 	MaxScatterGatherElements;
 	u32		MaxLogicalUnits;
 	u32		MaxPhysicalDevices;

