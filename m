From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH RESEND] libsas: Fixup device_del() inversion
Date: Thu, 31 Aug 2017 11:20:49 +0200
Message-ID: <1504171249-38053-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750882AbdHaJVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 05:21:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

(resending to include linux-scsi)

When removing the HBA or port there's a device_del() inversion
in sas_deform_port().
If there's only one phy it will call sas_unregister_domain_devices(),
which in turn might remove any phys and end_devices asynchronously
via the DISCE_DESTRUCT event.
But then it goes ahead and calls sas_port_delete() before the DISCE_DESTRUCT
event had a chance to run.
Consequently the port is removed before the phy, and we're getting
nasty kernel WARNING like

WARNING: CPU: 14 PID: 1592 at fs/sysfs/group.c:237 device_del+0x61/0x2a0()
sysfs group ffffffff81eff140 not found for kobject '6:0:0:0'

This patch moves the call to sas_port_delete() into the DISCE_DESTRUCT
handler to ensure that devices are removed in the correct order.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_discover.c | 10 +++++++++-
 drivers/scsi/libsas/sas_port.c     |  6 ++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de662..dc8f789 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -368,6 +368,10 @@ static void sas_destruct_devices(struct work_struct *work)
 		sas_rphy_delete(dev->rphy);
 		sas_unregister_common_dev(port, dev);
 	}
+	if (!port->port->rphy) {
+		sas_port_delete(port->port);
+		port->port = NULL;
+	}
 }
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
@@ -401,8 +405,12 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 		sas_unregister_dev(port, dev);
 
+	/*
+	 * Add another destruct event (or overload the existing one)
+	 * to trigger port deletion.
+	 */
 	port->port->rphy = NULL;
-
+	sas_discover_event(port, DISCE_DESTRUCT);
 }
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297..7ee0c0a 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -217,11 +217,9 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 	if (dev)
 		dev->pathways--;
 
-	if (port->num_phys == 1) {
+	if (port->num_phys == 1)
 		sas_unregister_domain_devices(port, gone);
-		sas_port_delete(port->port);
-		port->port = NULL;
-	} else {
+	else {
 		sas_port_delete_phy(port->port, phy->phy);
 		sas_device_set_phy(dev, port->port);
 	}
-- 
1.8.5.6
