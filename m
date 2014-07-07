From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v6 1/2] libahci: Export some of the libahci functions.
Date: Mon,  7 Jul 2014 22:33:04 +0530
Message-ID: <1404752585-915-2-git-send-email-stripathi@apm.com>
References: <1404752585-915-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44691 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbaGGRKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 13:10:23 -0400
In-Reply-To: <1404752585-915-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch exports the function ahci_qc_issue and ahci_start_fis_rx.
The subsequent patches will make use of them.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h    | 2 ++
 drivers/ata/libahci.c | 7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index af63c75..f4a9299 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -370,7 +370,9 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		      int pmp, unsigned long deadline,
 		      int (*check_ready)(struct ata_link *link));

+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 int ahci_stop_engine(struct ata_port *ap);
+void ahci_start_fis_rx(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b986145..e6dd89a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,

 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
@@ -615,7 +614,7 @@ int ahci_stop_engine(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ahci_stop_engine);

-static void ahci_start_fis_rx(struct ata_port *ap)
+void ahci_start_fis_rx(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -641,6 +640,7 @@ static void ahci_start_fis_rx(struct ata_port *ap)
 	/* flush */
 	readl(port_mmio + PORT_CMD);
 }
+EXPORT_SYMBOL_GPL(ahci_start_fis_rx);

 static int ahci_stop_fis_rx(struct ata_port *ap)
 {
@@ -1940,7 +1940,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 }
 EXPORT_SYMBOL_GPL(ahci_interrupt);

-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -1969,6 +1969,7 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)

 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_qc_issue);

 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
--
1.8.2.1

