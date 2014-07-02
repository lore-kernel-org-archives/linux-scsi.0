From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 1/2] libahci: Implement the function ahci_restart_engine to restart the port dma engine.
Date: Wed,  2 Jul 2014 15:45:07 +0530
Message-ID: <1404296108-16233-2-git-send-email-stripathi@apm.com>
References: <1404296108-16233-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1404296108-16233-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds an function to restart the port dma engine.
This patch also exports the function ahci_qc_issue. The subsequent
patches will make use of them.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h    |  3 ++-
 drivers/ata/libahci.c | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index af63c75..98e8839 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -369,9 +369,10 @@ int ahci_reset_controller(struct ata_host *host);
 int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		      int pmp, unsigned long deadline,
 		      int (*check_ready)(struct ata_link *link));
-
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 int ahci_stop_engine(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
+int ahci_restart_engine(struct ata_port *ap);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
 int ahci_port_resume(struct ata_port *ap);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b986145..1b86cf4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,

 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
@@ -742,6 +741,18 @@ static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	return 0;
 }

+int ahci_restart_engine(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	ahci_stop_engine(ap);
+	ahci_start_fis_rx(ap);
+	hpriv->start_engine(ap);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_restart_engine);
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
@@ -1940,7 +1951,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 }
 EXPORT_SYMBOL_GPL(ahci_interrupt);

-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -1969,6 +1980,7 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)

 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_qc_issue);

 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
--
1.8.2.1

