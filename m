From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 06/18] isci: kill isci_port.domain_dev_list
Date: Sat, 10 Mar 2012 23:28:15 -0800
Message-ID: <20120311072815.6320.44694.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Another unused field, and isci_port_init is overkill.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    8 ++++++--
 drivers/scsi/isci/port.c |    7 -------
 drivers/scsi/isci/port.h |    6 ------
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index d647b07..bbec198 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -2557,8 +2557,12 @@ int isci_host_init(struct isci_host *ihost)
 	if (err)
 		return err;
 
-	for (i = 0; i < SCI_MAX_PORTS; i++)
-		isci_port_init(&ihost->ports[i], ihost, i);
+	for (i = 0; i < SCI_MAX_PORTS; i++) {
+		struct isci_port *iport = &ihost->ports[i];
+
+		INIT_LIST_HEAD(&iport->remote_dev_list);
+		iport->isci_host = ihost;
+	}
 
 	for (i = 0; i < SCI_MAX_PHYS; i++)
 		isci_phy_init(&ihost->phys[i], ihost, i);
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 923579f..6ef4bd9 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -1606,13 +1606,6 @@ void sci_port_construct(struct isci_port *iport, u8 index,
 		iport->phy_table[index] = NULL;
 }
 
-void isci_port_init(struct isci_port *iport, struct isci_host *ihost, int index)
-{
-	INIT_LIST_HEAD(&iport->remote_dev_list);
-	INIT_LIST_HEAD(&iport->domain_dev_list);
-	iport->isci_host = ihost;
-}
-
 void sci_port_broadcast_change_received(struct isci_port *iport, struct isci_phy *iphy)
 {
 	struct isci_host *ihost = iport->owning_controller;
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index 6b56240..f8bd1e8 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -97,7 +97,6 @@ enum isci_status {
 struct isci_port {
 	struct isci_host *isci_host;
 	struct list_head remote_dev_list;
-	struct list_head domain_dev_list;
 	#define IPORT_RESET_PENDING 0
 	unsigned long state;
 	enum sci_status hard_reset_status;
@@ -273,11 +272,6 @@ void sci_port_get_attached_sas_address(
 void isci_port_formed(struct asd_sas_phy *);
 void isci_port_deformed(struct asd_sas_phy *);
 
-void isci_port_init(
-	struct isci_port *port,
-	struct isci_host *host,
-	int index);
-
 int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *iport,
 				 struct isci_phy *iphy);
 int isci_ata_check_ready(struct domain_device *dev);

