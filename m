From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 08/10] isci: ->lldd_ata_check_ready handler
Date: Mon, 16 Jan 2012 21:11:43 -0800
Message-ID: <20120117051143.22344.21687.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab2AQFLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 00:11:43 -0500
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>

Report to libata whether the link to the given domain_device is up and the
signature fis has been received.

Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    3 +++
 drivers/scsi/isci/port.c |   25 +++++++++++++++++++++++++
 drivers/scsi/isci/port.h |    1 +
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 59f2ae7..40293b3 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -185,6 +185,9 @@ static struct sas_domain_function_template isci_transport_ops  = {
 	.lldd_lu_reset		= isci_task_lu_reset,
 	.lldd_query_task	= isci_task_query_task,
 
+	/* ata recovery called from ata-eh */
+	.lldd_ata_check_ready	= isci_ata_check_ready,
+
 	/* Port and Adapter management */
 	.lldd_clear_nexus_port	= isci_task_clear_nexus_port,
 	.lldd_clear_nexus_ha	= isci_task_clear_nexus_ha,
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 7e4a9ee..eca9ba0 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -1663,6 +1663,31 @@ int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *ipor
 	return ret;
 }
 
+int isci_ata_check_ready(struct domain_device *dev)
+{
+	struct isci_port *iport = dev->port->lldd_port;
+	struct isci_host *ihost = dev_to_ihost(dev);
+	struct isci_remote_device *idev;
+	unsigned long flags;
+	int rc = 0;
+
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	idev = isci_lookup_device(dev);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
+
+	if (!idev)
+		goto out;
+
+	if (test_bit(IPORT_RESET_PENDING, &iport->state))
+		goto out;
+
+	rc = !!iport->active_phy_mask;
+ out:
+	isci_put_device(idev);
+
+	return rc;
+}
+
 void isci_port_deformed(struct asd_sas_phy *phy)
 {
 	struct isci_host *ihost = phy->ha->lldd_ha;
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index 78e1e82..b4a733c 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -293,4 +293,5 @@ void isci_port_init(
 
 int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *iport,
 				 struct isci_phy *iphy);
+int isci_ata_check_ready(struct domain_device *dev);
 #endif /* !defined(_ISCI_PORT_H_) */

