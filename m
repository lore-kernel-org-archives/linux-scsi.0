From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/7] drivers/scsi/arm/{cumana_2,eesox,powertec}.c: ensure arguments to request_irq and free_irq are compatible
Date: Sun, 11 Mar 2012 20:36:22 +0100
Message-ID: <1331494587-12196-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert calls to free_irq so that the second argument is the same as the
last argument of the corresponding call to request_irq.  Without this
property, free_irq does nothing.

In each case, the problem is only in the probe function.  The corresponding
call in the remove function already has the correct second argument.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/scsi/arm/cumana_2.c |    2 +-
 drivers/scsi/arm/eesox.c    |    2 +-
 drivers/scsi/arm/powertec.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 547987b..693d383 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -480,7 +480,7 @@ cumanascsi2_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_release:
 	fas216_release(host);
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index edfd12b..48c1a14 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -601,7 +601,7 @@ eesoxscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_remove:
 	fas216_remove(host);
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9274c06..c9d6e8b 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -393,7 +393,7 @@ powertecscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_release:
 	fas216_release(host);
