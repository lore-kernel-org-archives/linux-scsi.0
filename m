From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI 53c700.c: make NCR_700_intr static
Date: Mon, 15 Nov 2004 02:47:13 +0100
Message-ID: <20041115014713.GB2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32265 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261401AbUKOB7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 20:59:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

NCR_700_intr is EXPORT_SYMBOL'e but has no external users.

Is the patch below correct or is future external usage planned?


diffstat output:
 drivers/scsi/53c700.c |    4 ++--
 drivers/scsi/53c700.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/53c700.h.old	2004-11-13 16:05:17.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/53c700.h	2004-11-13 16:19:50.000000000 +0100
@@ -63,7 +63,6 @@
 		struct NCR_700_Host_Parameters *, struct device *,
 		unsigned long, u8);
 int NCR_700_release(struct Scsi_Host *host);
-irqreturn_t NCR_700_intr(int, void *, struct pt_regs *);
 
 
 enum NCR_700_Host_State {
--- linux-2.6.10-rc1-mm5-full/drivers/scsi/53c700.c.old	2004-11-13 16:19:58.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/53c700.c	2004-11-13 16:22:42.000000000 +0100
@@ -167,6 +167,7 @@
 #include "53c700_d.h"
 
 
+STATIC irqreturn_t NCR_700_intr(int irq, void *dev_id, struct pt_regs *regs);
 STATIC int NCR_700_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
@@ -1486,7 +1487,7 @@
 	return 1;
 }
 
-irqreturn_t
+STATIC irqreturn_t
 NCR_700_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
@@ -2148,7 +2149,6 @@
 
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
-EXPORT_SYMBOL(NCR_700_intr);
 
 static struct spi_function_template NCR_700_transport_functions =  {
 	.set_period	= NCR_700_set_period,

