From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI 53c700.c: make NCR_700_intr static
Date: Fri, 11 Feb 2005 19:54:19 +0100
Message-ID: <20050211185419.GC3736@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:29202 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262302AbVBKSyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 13:54:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

NCR_700_intr was EXPORT_SYMBOL'e but has no external users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 15 Nov 2004
- 24 Nov 2004

 drivers/scsi/53c700.c |    4 ++--
 drivers/scsi/53c700.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

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


