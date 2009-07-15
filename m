From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/4] libata: Allow AHCI to flag ports as not hotpluggable
Date: Thu, 16 Jul 2009 00:43:58 +0100
Message-ID: <1247701438-18266-4-git-send-email-mjg@redhat.com>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
 <1247701438-18266-2-git-send-email-mjg@redhat.com>
 <1247701438-18266-3-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:46557 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbZGOXoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 19:44:13 -0400
In-Reply-To: <1247701438-18266-3-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>

Some SATA ports are fully internal and unlikely to be hotplugged. The
AHCI spec allows vendors to flag these ports differently, allowing
hotplug bays and eSATA ports to be treated differently. Ensure that
this information is exposed to userspace so policy decisions can be
made.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/ahci.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index de84054..51d8350 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -77,6 +77,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 			      size_t size);
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
+static int ahci_is_hotplug_capable(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -193,6 +194,8 @@ enum {
 	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_ESP		= (1 << 21), /* port is esata capable */
+	PORT_CMD_HPCP           = (1 << 18), /* port is hot plug capable */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -373,6 +376,8 @@ static struct ata_port_operations ahci_ops = {
 	.pmp_attach		= ahci_pmp_attach,
 	.pmp_detach		= ahci_pmp_detach,
 
+	.is_hotpluggable	= ahci_is_hotplug_capable,
+
 	.enable_pm		= ahci_enable_alpm,
 	.disable_pm		= ahci_disable_alpm,
 	.em_show		= ahci_led_show,
@@ -876,6 +881,15 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return -EINVAL;
 }
 
+static int ahci_is_hotplug_capable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	return cmd & (PORT_CMD_HPCP | PORT_CMD_ESP);
+}
+
 static void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
-- 
1.6.2.5

