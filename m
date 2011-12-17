From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 07/24] libsas: fix leak of
 dev->sata_dev.identify_[packet_]device
Date: Fri, 16 Dec 2011 18:33:44 -0800
Message-ID: <20111217023344.15036.5618.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760698Ab1LQCdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 21:33:45 -0500
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

These are never freed in the nominal path.  A domain_device has a
different lifetime than a sas_rphy we need a dev->rphy independent way
of identifying sata devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    6 ++++++
 include/scsi/sas_ata.h             |    3 ++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 4e64930..dc52b1f 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -30,6 +30,7 @@
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
+#include <scsi/sas_ata.h>
 #include "../scsi_sas_internal.h"
 
 /* ---------- Basic task processing for discovery purposes ---------- */
@@ -231,6 +232,11 @@ void sas_free_device(struct kref *kref)
 	if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV)
 		kfree(dev->ex_dev.ex_phy);
 
+	if (dev_is_sata(dev)) {
+		kfree(dev->sata_dev.identify_device);
+		kfree(dev->sata_dev.identify_packet_device);
+	}
+
 	kfree(dev);
 }
 
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 9c159f7..7d5013f 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -32,7 +32,8 @@
 
 static inline int dev_is_sata(struct domain_device *dev)
 {
-	return (dev->rphy->identify.target_port_protocols & SAS_PROTOCOL_SATA);
+	return dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM ||
+	       dev->dev_type == SATA_PM_PORT;
 }
 
 int sas_ata_init_host_and_port(struct domain_device *found_dev,

