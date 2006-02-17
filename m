From: Brian King <brking@us.ibm.com>
Subject: [PATCH 02/16] libata: Add some dummy noop functions
Date: Fri, 17 Feb 2006 16:19:49 -0600
Message-ID: <200602172219.k1HMJnv6013331@d01av02.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Add some dummy noop functions for use by libata clients
that do not need to do anything. Future SAS patches will
utilize these functions.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |    3 +++
 libata-dev-bjking1/include/linux/libata.h     |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/libata-core.c~libata_noop_funcs drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_noop_funcs	2006-02-14 09:27:38.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-14 09:27:38.000000000 -0600
@@ -2713,6 +2713,8 @@ void ata_qc_prep(struct ata_queued_cmd *
 	ata_fill_sg(qc);
 }
 
+void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
+
 /**
  *	ata_sg_init_one - Associate command with memory buffer
  *	@qc: Command to be associated
@@ -4908,6 +4910,7 @@ EXPORT_SYMBOL_GPL(ata_port_stop);
 EXPORT_SYMBOL_GPL(ata_host_stop);
 EXPORT_SYMBOL_GPL(ata_interrupt);
 EXPORT_SYMBOL_GPL(ata_qc_prep);
+EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
 EXPORT_SYMBOL_GPL(ata_bmdma_irq_clear);
diff -puN include/linux/libata.h~libata_noop_funcs include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_noop_funcs	2006-02-14 09:27:38.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-14 09:27:38.000000000 -0600
@@ -532,6 +532,7 @@ extern void ata_port_stop (struct ata_po
 extern void ata_host_stop (struct ata_host_set *host_set);
 extern irqreturn_t ata_interrupt (int irq, void *dev_instance, struct pt_regs *regs);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
+extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
 		unsigned int buflen);
_
