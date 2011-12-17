From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 18/24] libsas: use libata-eh-reset for sata rediscovery fis
 transmit failures
Date: Fri, 16 Dec 2011 18:34:41 -0800
Message-ID: <20111217023441.15036.63012.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since sata devices can take several seconds to recover the link on reset
the 0.5 seconds that libsas currently waits may not be enough.  Instead
if we are rediscovering a phy that was previously attached to a sata
device let libata handle any resets to encourage the device to transmit
the initial fis.

Once sas_ata_hard_reset() and lldds learn how to honor 'deadline' libsas
should stop encountering phys in an intermediate state, until then this
will loop until the fis is transmitted or ->attached_sas_addr gets
cleared, but in the more likely initial discovery case we keep existing
behavior.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c      |   20 ++++++++++++++++
 drivers/scsi/libsas/sas_expander.c |   44 ++++++++++++++++++++++++++++++++----
 include/scsi/sas_ata.h             |    6 ++++-
 3 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index bacd3ba..94354d5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -665,3 +665,23 @@ int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 
 	return rtn;
 }
+
+void sas_ata_schedule_reset(struct domain_device *dev)
+{
+	struct ata_eh_info *ehi;
+	struct ata_port *ap;
+	unsigned long flags;
+
+	if (!dev_is_sata(dev))
+		return;
+
+	ap = dev->sata_dev.ap;
+	ehi = &ap->link.eh_info;
+
+	spin_lock_irqsave(ap->lock, flags);
+	ehi->err_mask |= AC_ERR_TIMEOUT;
+	ehi->action |= ATA_EH_RESET;
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	ata_port_schedule_eh(ap);
+}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c3846cf..9d2bb32 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -28,6 +28,7 @@
 
 #include "sas_internal.h"
 
+#include <scsi/sas_ata.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include "../scsi_sas_internal.h"
@@ -226,12 +227,35 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	return;
 }
 
+/* check if we have an existing attached ata device on this expander phy */
+struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+{
+	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
+	struct domain_device *dev;
+	struct sas_rphy *rphy;
+
+	if (!ex_phy->port)
+		return NULL;
+
+	rphy = ex_phy->port->rphy;
+	if (!rphy)
+		return NULL;
+
+	dev = sas_find_dev_by_rphy(rphy);
+
+	if (dev && dev_is_sata(dev))
+		return dev;
+
+	return NULL;
+}
+
 #define DISCOVER_REQ_SIZE  16
 #define DISCOVER_RESP_SIZE 56
 
 static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 				      u8 *disc_resp, int single)
 {
+	struct domain_device *ata_dev = sas_ex_to_ata(dev, single);
 	int i, res;
 
 	disc_req[9] = single;
@@ -242,20 +266,30 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 				       disc_resp, DISCOVER_RESP_SIZE);
 		if (res)
 			return res;
-		/* This is detecting a failure to transmit initial
-		 * dev to host FIS as described in section G.5 of
-		 * sas-2 r 04b */
 		dr = &((struct smp_resp *)disc_resp)->disc;
 		if (memcmp(dev->sas_addr, dr->attached_sas_addr,
 			  SAS_ADDR_SIZE) == 0) {
 			sas_printk("Found loopback topology, just ignore it!\n");
 			return 0;
 		}
+
+		/* This is detecting a failure to transmit initial
+		 * dev to host FIS as described in section J.5 of
+		 * sas-2 r16
+		 */
 		if (!(dr->attached_dev_type == 0 &&
 		      dr->attached_sata_dev))
 			break;
-		/* In order to generate the dev to host FIS, we
-		 * send a link reset to the expander port */
+
+		/* In order to generate the dev to host FIS, we send a
+		 * link reset to the expander port.  If a device was
+		 * previously detected on this port we ask libata to
+		 * manage the reset and link recovery.
+		 */
+		if (ata_dev) {
+			sas_ata_schedule_reset(ata_dev);
+			break;
+		}
 		sas_smp_phy_control(dev, single, PHY_FUNC_LINK_RESET, NULL);
 		/* Wait for the reset to trigger the negotiation */
 		msleep(500);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 9f7a23d..c0bcd30 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -44,7 +44,7 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost);
 int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 	       struct list_head *done_q);
 void sas_probe_sata(struct work_struct *work);
-
+void sas_ata_schedule_reset(struct domain_device *dev);
 #else
 
 
@@ -75,6 +75,10 @@ static inline void sas_probe_sata(struct work_struct *work)
 {
 }
 
+static inline void sas_ata_schedule_reset(struct domain_device *dev)
+{
+}
+
 #endif
 
 #endif /* _SAS_ATA_H_ */

