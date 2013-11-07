From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/11] hpsa: enable unit attention reporting
Date: Thu, 07 Nov 2013 10:46:21 -0600
Message-ID: <20131107164621.3504.71269.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12685 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3KGQqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:46:24 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

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
index 542d4cb..be9ea76 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4386,14 +4386,15 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 
 static inline void hpsa_set_driver_support_bits(struct ctlr_info *h)
 {
-#ifdef CONFIG_X86
-	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	u32 driver_support;
 
+#ifdef CONFIG_X86
+	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	driver_support = readl(&(h->cfgtable->driver_support));
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

