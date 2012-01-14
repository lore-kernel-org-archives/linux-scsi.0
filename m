From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 1/7] libsas: mark all domain devices gone if root port
 disappears
Date: Sat, 14 Jan 2012 10:10:00 -0800
Message-ID: <20120114180956.25887.68501.stgit@localhost6.localdomain6>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab2ANSKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2012 13:10:01 -0500
In-Reply-To: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

If the top level expander is hot removed, mark all child devices as gone
before unregistration to short circuit futile recovery.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    8 ++++++--
 drivers/scsi/libsas/sas_port.c     |    4 +---
 include/scsi/libsas.h              |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index dfb0250..3ef7741 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -299,12 +299,16 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 }
 
-void sas_unregister_domain_devices(struct asd_sas_port *port)
+void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 {
 	struct domain_device *dev, *n;
 
-	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node)
+	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node) {
+		if (gone)
+			set_bit(SAS_DEV_GONE, &dev->state);
 		sas_unregister_dev(port, dev);
+	}
+
 	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 		sas_unregister_dev(port, dev);
 
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 31adcd1..59ee8a0 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -167,9 +167,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 		dev->pathways--;
 
 	if (port->num_phys == 1) {
-		if (dev && gone)
-			set_bit(SAS_DEV_GONE, &dev->state);
-		sas_unregister_domain_devices(port);
+		sas_unregister_domain_devices(port, gone);
 		sas_port_delete(port->port);
 		port->port = NULL;
 	} else {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 55bab86..4a42be3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -664,7 +664,7 @@ void sas_init_ex_attr(void);
 
 int  sas_ex_revalidate_domain(struct domain_device *);
 
-void sas_unregister_domain_devices(struct asd_sas_port *port);
+void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 

