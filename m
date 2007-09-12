From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Subject: [PATCH 20/24] scsi: esp family convert to accessors and
 !use_sg cleanup
Date: Wed, 12 Sep 2007 03:09:02 +0300
Message-ID: <46E72E1E.1040908@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13896 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432AbXILAJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:09:38 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


  - convert to scsi data accessors and !use_sg code path
    removal
  - When removing !use_sg code path I noticed that
    dma_mmu_get_scsi_one() && dma_mmu_release_scsi_one()
    are no longer used. So also remove all implementations
    of these.
  - This family of drivers is totally not ready for chaining.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/NCR53C9x.c    |   42 ++++++++++++++----------------------------
 drivers/scsi/NCR53C9x.h    |    2 --
 drivers/scsi/dec_esp.c     |   17 -----------------
 drivers/scsi/oktagon_esp.c |   14 --------------
 drivers/scsi/sun3x_esp.c   |   20 ++------------------
 5 files changed, 16 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 79b4df1..303328d 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -910,36 +910,21 @@ EXPORT_SYMBOL(esp_proc_info);
 
 static void esp_get_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	if(sp->use_sg == 0) {
-		sp->SCp.this_residual = sp->request_bufflen;
-		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
-		sp->SCp.buffers_residual = 0;
-		if (esp->dma_mmu_get_scsi_one)
-			esp->dma_mmu_get_scsi_one(esp, sp);
-		else
-			sp->SCp.ptr =
-				(char *) virt_to_phys(sp->request_buffer);
-	} else {
-		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
-		sp->SCp.buffers_residual = sp->use_sg - 1;
-		sp->SCp.this_residual = sp->SCp.buffer->length;
-		if (esp->dma_mmu_get_scsi_sgl)
-			esp->dma_mmu_get_scsi_sgl(esp, sp);
-		else
-			sp->SCp.ptr =
-				(char *) virt_to_phys((page_address(sp->SCp.buffer->page) + sp->SCp.buffer->offset));
-	}
+	sp->SCp.buffer = scsi_sglist(sp);
+	sp->SCp.buffers_residual = scsi_sg_count(sp) - 1;
+	sp->SCp.this_residual = sp->SCp.buffer->length;
+	if (esp->dma_mmu_get_scsi_sgl)
+		esp->dma_mmu_get_scsi_sgl(esp, sp);
+	else
+		sp->SCp.ptr = (char *)
+			virt_to_phys((page_address(sp->SCp.buffer->page) +
+			              sp->SCp.buffer->offset));
 }
 
 static void esp_release_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	if(sp->use_sg == 0) {
-		if (esp->dma_mmu_release_scsi_one)
-			esp->dma_mmu_release_scsi_one(esp, sp);
-	} else {
-		if (esp->dma_mmu_release_scsi_sgl)
-			esp->dma_mmu_release_scsi_sgl(esp, sp);
-	}
+	if (esp->dma_mmu_release_scsi_sgl)
+		esp->dma_mmu_release_scsi_sgl(esp, sp);
 }
 
 static void esp_restore_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
@@ -2102,9 +2087,10 @@ static int esp_do_data_finale(struct NCR_ESP *esp,
 		ESPLOG(("esp%d: csz=%d fifocount=%d ecount=%d\n",
 			esp->esp_id,
 			esp->current_transfer_size, fifocnt, ecount));
-		ESPLOG(("esp%d: use_sg=%d ptr=%p this_residual=%d\n",
+		ESPLOG(("esp%d: sg_count=%d ptr=%p this_residual=%d\n",
 			esp->esp_id,
-			SCptr->use_sg, SCptr->SCp.ptr, SCptr->SCp.this_residual));
+			scsi_sg_count(SCptr), SCptr->SCp.ptr,
+			SCptr->SCp.this_residual));
 		ESPLOG(("esp%d: Forcing async for target %d\n", esp->esp_id, 
 			SCptr->device->id));
 		SCptr->device->borken = 1;
diff --git a/drivers/scsi/NCR53C9x.h b/drivers/scsi/NCR53C9x.h
index d85cb73..b77eff4 100644
--- a/drivers/scsi/NCR53C9x.h
+++ b/drivers/scsi/NCR53C9x.h
@@ -440,9 +440,7 @@ struct NCR_ESP {
   void (*dma_reset)(struct NCR_ESP *);
     
   /* Optional virtual DMA functions */
-  void (*dma_mmu_get_scsi_one)(struct NCR_ESP *, Scsi_Cmnd *);
   void (*dma_mmu_get_scsi_sgl)(struct NCR_ESP *, Scsi_Cmnd *);
-  void (*dma_mmu_release_scsi_one)(struct NCR_ESP *, Scsi_Cmnd *);
   void (*dma_mmu_release_scsi_sgl)(struct NCR_ESP *, Scsi_Cmnd *);
   void (*dma_advance_sg)(Scsi_Cmnd *);
 };
diff --git a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
index d42ad66..b61da6c 100644
--- a/drivers/scsi/dec_esp.c
+++ b/drivers/scsi/dec_esp.c
@@ -64,7 +64,6 @@ static void dma_ints_on(struct NCR_ESP *esp);
 static int  dma_irq_p(struct NCR_ESP *esp);
 static int  dma_ports_p(struct NCR_ESP *esp);
 static void dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write);
-static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp);
 static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd * sp);
 static void dma_advance_sg(struct scsi_cmnd * sp);
 
@@ -74,7 +73,6 @@ static void pmaz_dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length);
 static void pmaz_dma_ints_off(struct NCR_ESP *esp);
 static void pmaz_dma_ints_on(struct NCR_ESP *esp);
 static void pmaz_dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write);
-static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp);
 
 #define TC_ESP_RAM_SIZE 0x20000
 #define ESP_TGT_DMA_SIZE ((TC_ESP_RAM_SIZE/7) & ~(sizeof(int)-1))
@@ -153,9 +151,7 @@ static int dec_esp_platform_probe(void)
 		esp->dma_led_on = 0;
 
 		/* virtual DMA functions */
-		esp->dma_mmu_get_scsi_one = &dma_mmu_get_scsi_one;
 		esp->dma_mmu_get_scsi_sgl = &dma_mmu_get_scsi_sgl;
-		esp->dma_mmu_release_scsi_one = 0;
 		esp->dma_mmu_release_scsi_sgl = 0;
 		esp->dma_advance_sg = &dma_advance_sg;
 
@@ -290,9 +286,7 @@ static int __init dec_esp_probe(struct device *dev)
 	esp->dma_led_off = 0;
 	esp->dma_led_on = 0;
 
-	esp->dma_mmu_get_scsi_one = pmaz_dma_mmu_get_scsi_one;
 	esp->dma_mmu_get_scsi_sgl = 0;
-	esp->dma_mmu_release_scsi_one = 0;
 	esp->dma_mmu_release_scsi_sgl = 0;
 	esp->dma_advance_sg = 0;
 
@@ -536,11 +530,6 @@ static void dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write)
 		dma_init_write(esp, addr, count);
 }
 
-static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp)
-{
-	sp->SCp.ptr = (char *)virt_to_phys(sp->request_buffer);
-}
-
 static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd * sp)
 {
 	int sz = sp->SCp.buffers_residual;
@@ -617,12 +606,6 @@ static void pmaz_dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write)
 		pmaz_dma_init_write(esp, addr, count);
 }
 
-static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp)
-{
-	sp->SCp.ptr = (char *)virt_to_phys(sp->request_buffer);
-}
-
-
 #ifdef CONFIG_TC
 static int __init dec_esp_tc_probe(struct device *dev);
 static int __exit dec_esp_tc_remove(struct device *dev);
diff --git a/drivers/scsi/oktagon_esp.c b/drivers/scsi/oktagon_esp.c
index 26a6d55..49a6bf7 100644
--- a/drivers/scsi/oktagon_esp.c
+++ b/drivers/scsi/oktagon_esp.c
@@ -64,9 +64,7 @@ static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
 static void dma_irq_exit(struct NCR_ESP *esp);
 static void dma_invalidate(struct NCR_ESP *esp);
 
-static void dma_mmu_get_scsi_one(struct NCR_ESP *,Scsi_Cmnd *);
 static void dma_mmu_get_scsi_sgl(struct NCR_ESP *,Scsi_Cmnd *);
-static void dma_mmu_release_scsi_one(struct NCR_ESP *,Scsi_Cmnd *);
 static void dma_mmu_release_scsi_sgl(struct NCR_ESP *,Scsi_Cmnd *);
 static void dma_advance_sg(Scsi_Cmnd *);
 static int  oktagon_notify_reboot(struct notifier_block *this, unsigned long code, void *x);
@@ -169,9 +167,7 @@ int oktagon_esp_detect(struct scsi_host_template *tpnt)
 		esp->dma_poll = 0;
 		esp->dma_reset = 0;
 
-		esp->dma_mmu_get_scsi_one = &dma_mmu_get_scsi_one;
 		esp->dma_mmu_get_scsi_sgl = &dma_mmu_get_scsi_sgl;
-		esp->dma_mmu_release_scsi_one = &dma_mmu_release_scsi_one;
 		esp->dma_mmu_release_scsi_sgl = &dma_mmu_release_scsi_sgl;
 		esp->dma_advance_sg = &dma_advance_sg;
 
@@ -542,22 +538,12 @@ static void dma_invalidate(struct NCR_ESP *esp)
  * mmu interface to pass the virtual address, not the physical.
  */
 
-void dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-        sp->SCp.ptr =
-                sp->request_buffer;
-}
-
 void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
         sp->SCp.ptr = page_address(sp->SCp.buffer->page)+
 		      sp->SCp.buffer->offset;
 }
 
-void dma_mmu_release_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-}
-
 void dma_mmu_release_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
 }
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 80fb3f8..9107283 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -38,9 +38,7 @@ static void dma_poll(struct NCR_ESP *esp, unsigned char *vaddr);
 static int  dma_ports_p(struct NCR_ESP *esp);
 static void dma_reset(struct NCR_ESP *esp);
 static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
 static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
 static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
 static void dma_advance_sg (Scsi_Cmnd *sp);
 
@@ -82,9 +80,7 @@ int sun3x_esp_detect(struct scsi_host_template *tpnt)
 	esp->dma_reset = &dma_reset;
 
         /* virtual DMA functions */
-        esp->dma_mmu_get_scsi_one = &dma_mmu_get_scsi_one;
         esp->dma_mmu_get_scsi_sgl = &dma_mmu_get_scsi_sgl;
-        esp->dma_mmu_release_scsi_one = &dma_mmu_release_scsi_one;
         esp->dma_mmu_release_scsi_sgl = &dma_mmu_release_scsi_sgl;
         esp->dma_advance_sg = &dma_advance_sg;
 	    
@@ -319,13 +315,6 @@ static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write)
 	dregs->st_addr = addr;
 }
 
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-    sp->SCp.have_data_in = dvma_map((unsigned long)sp->SCp.buffer,
-				       sp->SCp.this_residual);
-    sp->SCp.ptr = (char *)((unsigned long)sp->SCp.have_data_in);
-}
-
 static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
     int sz = sp->SCp.buffers_residual;
@@ -339,15 +328,10 @@ static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
     sp->SCp.ptr=(char *)((unsigned long)sp->SCp.buffer->dma_address);
 }
 
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-    dvma_unmap((char *)sp->SCp.have_data_in);
-}
-
 static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-    int sz = sp->use_sg - 1;
-    struct scatterlist *sg = (struct scatterlist *)sp->request_buffer;
+    int sz = scsi_sg_count(sp) - 1;
+    struct scatterlist *sg = scsi_sglist(sp);
                         
     while(sz >= 0) {
         dvma_unmap((char *)sg[sz].dma_address);
-- 
1.5.3.1


