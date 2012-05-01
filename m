From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/17] hpsa: do not read from controller unnecessarily in
	completion code
Date: Tue, 01 May 2012 11:42:30 -0500
Message-ID: <20120501164230.11705.50818.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

MSI/MSI-X interrupts can't race the DMA completion they are communicating
so no need to read from controller to flush the DMA to the host if
MSI or MSI-X interrupts are being used.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7b28d54..48f7812 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -258,12 +258,12 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h)
 {
 	unsigned long register_value = FIFO_EMPTY;
 
-	/* flush the controller write of the reply queue by reading
-	 * outbound doorbell status register.
-	 */
-	register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 	/* msi auto clears the interrupt pending bit. */
 	if (!(h->msi_vector || h->msix_vector)) {
+		/* flush the controller write of the reply queue by reading
+		 * outbound doorbell status register.
+		 */
+		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 		writel(SA5_OUTDB_CLEAR_PERF_BIT, h->vaddr + SA5_OUTDB_CLEAR);
 		/* Do a read in order to flush the write to the controller
 		 * (as per spec.)
