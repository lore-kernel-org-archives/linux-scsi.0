From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 01/21] scsi: wd33c93 - Kill empty wd33c93_release()
Date: Sun,  4 Apr 2010 11:00:31 +0200
Message-ID: <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-scsi@vger.kernel.org

wd33c93_release() has been empty since ages, and sgiwd93.c no longer calls it
since its conversion to a proper platform driver 2 years ago. Also remove the
callers in the m68k wd33c93 shims.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/scsi/a2091.c   |    2 --
 drivers/scsi/a3000.c   |    2 --
 drivers/scsi/gvp11.c   |    2 --
 drivers/scsi/mvme147.c |    2 --
 drivers/scsi/wd33c93.c |    6 ------
 drivers/scsi/wd33c93.h |    1 -
 6 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 4b38c47..f2731a7 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -192,7 +192,6 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 
 unregister:
 	scsi_unregister(instance);
-	wd33c93_release();
 release:
 	release_mem_region(address, 256);
     }
@@ -241,7 +240,6 @@ static int a2091_release(struct Scsi_Host *instance)
 	DMA(instance)->CNTR = 0;
 	release_mem_region(ZTWO_PADDR(instance->base), 256);
 	free_irq(IRQ_AMIGA_PORTS, instance);
-	wd33c93_release();
 #endif
 	return 1;
 }
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 6970ce8..50b10df 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -192,7 +192,6 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
     return 1;
 
 fail_irq:
-    wd33c93_release();
     scsi_unregister(a3000_host);
 fail_register:
     release_mem_region(0xDD0000, 256);
@@ -236,7 +235,6 @@ static struct scsi_host_template driver_template = {
 
 static int a3000_release(struct Scsi_Host *instance)
 {
-    wd33c93_release();
     DMA(instance)->CNTR = 0;
     release_mem_region(0xDD0000, 256);
     free_irq(IRQ_AMIGA_PORTS, a3000_intr);
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 5d1bf7e..0b09c0d 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -338,7 +338,6 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 
 unregister:
 	scsi_unregister(instance);
-	wd33c93_release();
 release:
 	release_mem_region(address, 256);
     }
@@ -391,7 +390,6 @@ int gvp11_release(struct Scsi_Host *instance)
     DMA(instance)->CNTR = 0;
     release_mem_region(ZTWO_PADDR(instance->base), 256);
     free_irq(IRQ_AMIGA_PORTS, instance);
-    wd33c93_release();
 #endif
     return 1;
 }
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index d722235..a423fcc 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -108,7 +108,6 @@ int mvme147_detect(struct scsi_host_template *tpnt)
  err_free_irq:
     free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
  err_unregister:
-    wd33c93_release();
     scsi_unregister(mvme147_host);
  err_out:
     return 0;
@@ -155,7 +154,6 @@ int mvme147_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
     /* XXX Make sure DMA is stopped! */
-    wd33c93_release();
     free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
     free_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr);
 #endif
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 5fda881..b701bf2 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -2224,14 +2224,8 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 
 }
 
-void
-wd33c93_release(void)
-{
-}
-
 EXPORT_SYMBOL(wd33c93_host_reset);
 EXPORT_SYMBOL(wd33c93_init);
-EXPORT_SYMBOL(wd33c93_release);
 EXPORT_SYMBOL(wd33c93_abort);
 EXPORT_SYMBOL(wd33c93_queuecommand);
 EXPORT_SYMBOL(wd33c93_intr);
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 00123f2..1ed5f3b 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -348,6 +348,5 @@ int wd33c93_queuecommand (struct scsi_cmnd *cmd,
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 int wd33c93_host_reset (struct scsi_cmnd *);
-void wd33c93_release(void);
 
 #endif /* WD33C93_H */
-- 
1.6.0.4
