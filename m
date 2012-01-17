From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 01/10] libsas: convert dev->gone to flags
Date: Mon, 16 Jan 2012 21:11:07 -0800
Message-ID: <20120117051106.22344.74002.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for adding tracking of another device state "destroy".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |    2 +-
 drivers/scsi/libsas/sas_expander.c  |    6 +++---
 drivers/scsi/libsas/sas_port.c      |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/scsi/libsas.h               |    7 +++++--
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 81ce39d..2fc5a39 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -184,7 +184,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	spin_unlock(ap->lock);
 
 	/* If the device fell off, no sense in issuing commands */
-	if (dev->gone)
+	if (test_bit(SAS_DEV_GONE, &dev->state))
 		goto out;
 
 	task = sas_alloc_task(GFP_ATOMIC);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 15d2239..f33d0c9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1750,7 +1750,7 @@ static void sas_unregister_ex_tree(struct asd_sas_port *port, struct domain_devi
 	struct domain_device *child, *n;
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
-		child->gone = 1;
+		set_bit(SAS_DEV_GONE, &child->state);
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV)
 			sas_unregister_ex_tree(port, child);
@@ -1771,7 +1771,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 			&ex_dev->children, siblings) {
 			if (SAS_ADDR(child->sas_addr) ==
 			    SAS_ADDR(phy->attached_sas_addr)) {
-				child->gone = 1;
+				set_bit(SAS_DEV_GONE, &child->state);
 				if (child->dev_type == EDGE_DEV ||
 				    child->dev_type == FANOUT_DEV)
 					sas_unregister_ex_tree(parent->port, child);
@@ -1780,7 +1780,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				break;
 			}
 		}
-		parent->gone = 1;
+		set_bit(SAS_DEV_GONE, &parent->state);
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index a47c7a7..d88e55f 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -171,7 +171,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 
 	if (port->num_phys == 1) {
 		if (dev && gone)
-			dev->gone = 1;
+			set_bit(SAS_DEV_GONE, &dev->state);
 		sas_unregister_domain_devices(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index fd60465..15533a1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -192,7 +192,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	int res = 0;
 
 	/* If the device fell off, no sense in issuing commands */
-	if (dev->gone) {
+	if (test_bit(SAS_DEV_GONE, &dev->state)) {
 		cmd->result = DID_BAD_TARGET << 16;
 		goto out_done;
 	}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 42900fa..d792b13 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -173,7 +173,10 @@ struct sata_device {
 	struct ata_taskfile tf;
 };
 
-/* ---------- Domain device ---------- */
+enum {
+	SAS_DEV_GONE,
+};
+
 struct domain_device {
         enum sas_dev_type dev_type;
 
@@ -205,7 +208,7 @@ struct domain_device {
         };
 
         void *lldd_dev;
-	int gone;
+	unsigned long state;
 	struct kref kref;
 };
 

