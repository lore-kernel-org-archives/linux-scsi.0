From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v2 1/2] libahci: Implement the function ahci_restart_engine to restart the port dma engine.
Date: Mon, 16 Jun 2014 15:05:35 +0530
Message-ID: <1402911336-31788-2-git-send-email-stripathi@apm.com>
References: <1402911336-31788-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1402911336-31788-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements the function ahci_restart_engine function to restart the port dma engine.
---
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index af63c75..3c1760e 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -372,6 +372,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,

 int ahci_stop_engine(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
+int ahci_restart_engine(struct ata_port *ap);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
 int ahci_port_resume(struct ata_port *ap);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b986145..584da77 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -742,6 +742,16 @@ static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	return 0;
 }

+int ahci_restart_engine(struct ata_port *ap)
+{
+	ahci_stop_engine(ap);
+	ahci_start_fis_rx(ap);
+	ahci_start_engine(ap);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_restart_engine);
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
--
1.8.2.1

