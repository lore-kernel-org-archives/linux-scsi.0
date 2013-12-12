From: Loc Ho <lho@apm.com>
Subject: [PATCH v6 1/4] ata: Export required functions by APM X-Gene SATA driver
Date: Thu, 12 Dec 2013 00:55:37 -0700
Message-ID: <1386834940-30875-2-git-send-email-lho@apm.com>
References: <1386834940-30875-1-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386834940-30875-1-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch exports functions required by APM X-Gene SoC SATA host
controller driver to avoid duplication of code.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h    |    9 +++++++++
 drivers/ata/libahci.c |   16 ++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2289efd..8163b59 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -370,6 +370,15 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
 void ahci_error_handler(struct ata_port *ap);
+void ahci_sw_activity(struct ata_link *link);
+int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+void ahci_error_intr(struct ata_port *ap, u32 irq_stat);
+int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+			 struct ata_taskfile *tf, int is_cmd, u16 flags,
+			 unsigned long timeout_msec);
+void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+                        u32 opts);
+unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);

 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index c482f8c..1d24bf5 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,


 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
@@ -553,7 +552,7 @@ static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }

-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
+int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	void __iomem *port_mmio = ahci_port_base(link->ap);
 	int offset = ahci_scr_offset(link->ap, sc_reg);
@@ -564,6 +563,7 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(ahci_scr_write);

 void ahci_start_engine(struct ata_port *ap)
 {
@@ -869,7 +869,7 @@ int ahci_reset_controller(struct ata_host *host)
 }
 EXPORT_SYMBOL_GPL(ahci_reset_controller);

-static void ahci_sw_activity(struct ata_link *link)
+void ahci_sw_activity(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -882,6 +882,7 @@ static void ahci_sw_activity(struct ata_link *link)
 	if (!timer_pending(&emp->timer))
 		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
 }
+EXPORT_SYMBOL_GPL(ahci_sw_activity);

 static void ahci_sw_activity_blink(unsigned long arg)
 {
@@ -1239,7 +1240,7 @@ int ahci_kick_engine(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ahci_kick_engine);

-static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 				struct ata_taskfile *tf, int is_cmd, u16 flags,
 				unsigned long timeout_msec)
 {
@@ -1268,6 +1269,7 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,

 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_exec_polled_cmd);

 int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		      int pmp, unsigned long deadline,
@@ -1472,7 +1474,7 @@ static void ahci_postreset(struct ata_link *link, unsigned int *class)
 	}
 }

-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 {
 	struct scatterlist *sg;
 	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
@@ -1494,6 +1496,7 @@ static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)

 	return si;
 }
+EXPORT_SYMBOL_GPL(ahci_fill_sg);

 static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc)
 {
@@ -1568,7 +1571,7 @@ static void ahci_fbs_dec_intr(struct ata_port *ap)
 		dev_err(ap->host->dev, "failed to clear device error\n");
 }

-static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
+void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1678,6 +1681,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	} else
 		ata_port_abort(ap);
 }
+EXPORT_SYMBOL_GPL(ahci_error_intr);

 static void ahci_handle_port_interrupt(struct ata_port *ap,
 				       void __iomem *port_mmio, u32 status)
--
1.5.5

