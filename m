From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/12] sas_ata: Implement SATA PHY control
Date: Tue, 30 Jan 2007 01:18:47 -0800
Message-ID: <20070130091847.31530.6282.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38852 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965454AbXA3JQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:15 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9GD8G005779
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:13 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GD50128944
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:13 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GD0U030956
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:13 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


This patch requires "libsas: Add a sysfs knob to enable/disable a phy"
to be applied.  It hooks the SControl write function to provide basic
SATA phy control for phy enable/disable and speed limits.  Power
management is still broken, though it is unclear that libata actually
uses those SControl bits anyway.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c       |   42 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_scsi_host.c |    1 +
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 16c3e5a..2bb619e 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -270,6 +270,46 @@ static void sas_ata_tf_read(struct ata_p
 	memcpy(tf, &dev->sata_dev.tf, sizeof (*tf));
 }
 
+static void sas_ata_scontrol_write(struct domain_device *dev, u32 val)
+{
+	u32 tmp = dev->sata_dev.scontrol;
+	struct sas_phy *phy = dev->port->phy;
+
+	val &= 0x0FF; /* only set max spd and dev ctrl */
+	val |= 0x300; /* disallow host pm */
+	val |= tmp & 0xFFFFF000; /* preserve upper bits */
+
+	/* disable phy */
+	if ((val & 0x4) && !(tmp & 0x4))
+		sas_phy_enable(phy, 0);
+
+	/* enable phy */
+	if (!(val & 0x4) && (tmp & 0x4))
+		sas_phy_enable(phy, 1);
+
+	/* reset phy */
+	if ((val & 0x1) && !(tmp & 0x1))
+		sas_phy_reset(phy, 0);
+
+	/* speed limit */
+	if ((val & 0xF0) != (tmp & 0xF0)) {
+		struct sas_phy_linkrates rates = {0};
+
+		switch ((val & 0xF0) >> 4) {
+		case 0:
+		case 2:
+			rates.maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+			break;
+		case 1:
+			rates.maximum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+			break;
+		}
+		sas_set_phy_speed(phy, &rates);
+	}
+
+	dev->sata_dev.scontrol = val;
+}
+
 static void sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 			      u32 val)
 {
@@ -281,7 +321,7 @@ static void sas_ata_scr_write(struct ata
 			dev->sata_dev.sstatus = val;
 			break;
 		case SCR_CONTROL:
-			dev->sata_dev.scontrol = val;
+			sas_ata_scontrol_write(dev, val);
 			break;
 		case SCR_ERROR:
 			dev->sata_dev.serror = val;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index fee9c10..5b0c471 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1040,3 +1040,4 @@ EXPORT_SYMBOL_GPL(sas_eh_device_reset_ha
 EXPORT_SYMBOL_GPL(sas_slave_alloc);
 EXPORT_SYMBOL_GPL(sas_target_destroy);
 EXPORT_SYMBOL_GPL(sas_ioctl);
+EXPORT_SYMBOL_GPL(sas_set_phy_speed);
