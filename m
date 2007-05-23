From: akpm@linux-foundation.org
Subject: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Wed, 23 May 2007 14:41:44 -0700
Message-ID: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555AbXEWWDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:03:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org

From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~scsi-use-irq_handler_t-where-appropriate drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~scsi-use-irq_handler_t-where-appropriate
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -464,7 +464,7 @@ struct adapter_ops
 	int  (*adapter_restart)(struct aac_dev *dev, int bled);
 	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
-	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
+	irq_handler_t adapter_intr;
 	/* Packet operations */
 	int  (*adapter_deliver)(struct fib * fib);
 	int  (*adapter_bounds)(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba);
diff -puN drivers/scsi/qla2xxx/qla_isr.c~scsi-use-irq_handler_t-where-appropriate drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c~scsi-use-irq_handler_t-where-appropriate
+++ a/drivers/scsi/qla2xxx/qla_isr.c
@@ -1633,7 +1633,7 @@ struct qla_init_msix_entry {
 	uint16_t entry;
 	uint16_t index;
 	const char *name;
-	irqreturn_t (*handler)(int, void *);
+	irq_handler_t handler;
 };
 
 static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
_
