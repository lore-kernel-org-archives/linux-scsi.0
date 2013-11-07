From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/11] hpsa: rename scsi prefetch field
Date: Thu, 07 Nov 2013 10:46:16 -0600
Message-ID: <20131107164615.3504.85241.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48327 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3KGQqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:46:16 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The field contains more bits than just the one
to indicate whether scsi prefetch should be turned on.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   14 +++++++-------
 drivers/scsi/hpsa_cmd.h |    3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7256b29..542d4cb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4384,15 +4384,15 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 	return true;
 }
 
-/* Need to enable prefetch in the SCSI core for 6400 in x86 */
-static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
+static inline void hpsa_set_driver_support_bits(struct ctlr_info *h)
 {
 #ifdef CONFIG_X86
-	u32 prefetch;
+	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+	u32 driver_support;
 
-	prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
-	prefetch |= 0x100;
-	writel(prefetch, &(h->cfgtable->SCSI_Prefetch));
+	driver_support = readl(&(h->cfgtable->driver_support));
+	driver_support |= ENABLE_SCSI_PREFETCH;
+	writel(driver_support, &(h->cfgtable->driver_support));
 #endif
 }
 
@@ -4503,7 +4503,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-	hpsa_enable_scsi_prefetch(h);
+	hpsa_set_driver_support_bits(h);
 	hpsa_p600_dma_prefetch_quirk(h);
 	err = hpsa_enter_simple_mode(h);
 	if (err)
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index a894f2e..5158709 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -356,7 +356,8 @@ struct CfgTable {
 	u32           TransMethodOffset;
 	u8            ServerName[16];
 	u32           HeartBeat;
-	u32           SCSI_Prefetch;
+	u32           driver_support;
+#define			ENABLE_SCSI_PREFETCH 0x100
 	u32	 	MaxScatterGatherElements;
 	u32		MaxLogicalUnits;
 	u32		MaxPhysicalDevices;

