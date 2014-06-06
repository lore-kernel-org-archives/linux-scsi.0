From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v0 1/2] libahci: Implement the function restart_engine to restart the port dma engine.
Date: Sat,  7 Jun 2014 02:58:53 +0530
Message-ID: <1402090134-23164-2-git-send-email-stripathi@apm.com>
References: <1402090134-23164-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1402090134-23164-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, olof@lixom.net, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements the function restart_engine function to add the flexibility to  restart the port dma engine from the libata framework.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/libahci.c  | 11 +++++++++++
 include/linux/libata.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b986145..5f9a13e 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -70,6 +70,7 @@ static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static int ahci_restart_engine(struct ata_port *ap);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
 static void ahci_qc_prep(struct ata_queued_cmd *qc);
@@ -178,6 +179,7 @@ struct ata_port_operations ahci_ops = {
 #endif
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
+	.restart_engine		= ahci_restart_engine,
 };
 EXPORT_SYMBOL_GPL(ahci_ops);

@@ -2362,6 +2364,15 @@ static int ahci_port_start(struct ata_port *ap)
 	return ahci_port_resume(ap);
 }

+static int ahci_restart_engine(struct ata_port *ap)
+{
+	ahci_stop_engine(ap);
+	ahci_start_fis_rx(ap);
+	ahci_start_engine(ap);
+
+	return 0;
+}
+
 static void ahci_port_stop(struct ata_port *ap)
 {
 	const char *emsg = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5ab4e3a..42ab826 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -918,6 +918,7 @@ struct ata_port_operations {
 	void (*pmp_detach)(struct ata_port *ap);
 	int  (*set_lpm)(struct ata_link *link, enum ata_lpm_policy policy,
 			unsigned hints);
+	int (*restart_engine) (struct ata_port *ap);

 	/*
 	 * Start, stop, suspend and resume
--
1.8.2.1

