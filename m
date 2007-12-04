From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libsas: Don't issue commands to devices that have been
	hot-removed.
Date: Tue, 4 Dec 2007 14:35:16 -0800
Message-ID: <20071204223516.GA6767@tree.beaverton.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47799 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbXLDWfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 17:35:18 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB4MZIPw032077
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:35:18 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB4MZHS0129034
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 15:35:17 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB4MZHAl016077
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 15:35:17 -0700
Content-Disposition: inline
In-Reply-To: <200712032106.44176.kb@sysmikro.com.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof =?utf-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Hrm... does this patch help?  You'll get a bunch of ATA/SAS disk errors
printed to the screen if you yank the disk, but at least libsas won't
get stuck waiting for the cache-flush commands to time out.
---
sd will get hung up issuing commands to flush write cache if a SAS device
is unplugged without warning.  Change libsas to reject commands to domain
devices that have already gone away.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c       |    4 ++++
 drivers/scsi/libsas/sas_expander.c  |    3 +++
 drivers/scsi/libsas/sas_port.c      |    2 ++
 drivers/scsi/libsas/sas_scsi_host.c |    7 +++++++
 include/scsi/libsas.h               |    1 +
 5 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0829b55..f5e5213 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -161,6 +161,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	unsigned int num = 0;
 	unsigned int xfer = 0;
 
+	/* If the device fell off, no sense in issuing commands */
+	if (dev->gone)
+		return AC_ERR_SYSTEM;
+
 	task = sas_alloc_task(GFP_ATOMIC);
 	if (!task)
 		return AC_ERR_SYSTEM;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 27674fe..4ba4d2a 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1680,6 +1680,7 @@ static void sas_unregister_ex_tree(struct domain_device *dev)
 	struct domain_device *child, *n;
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
+		child->gone = 1;
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV)
 			sas_unregister_ex_tree(child);
@@ -1699,6 +1700,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 	list_for_each_entry_safe(child, n, &ex_dev->children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(phy->attached_sas_addr)) {
+			child->gone = 1;
 			if (child->dev_type == EDGE_DEV ||
 			    child->dev_type == FANOUT_DEV)
 				sas_unregister_ex_tree(child);
@@ -1707,6 +1709,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 			break;
 		}
 	}
+	parent->gone = 1;
 	sas_disable_routing(parent, phy->attached_sas_addr);
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	sas_port_delete_phy(phy->port, phy->phy);
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index b6f0243..2e82097 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -144,6 +144,8 @@ void sas_deform_port(struct asd_sas_phy *phy)
 		port->port_dev->pathways--;
 
 	if (port->num_phys == 1) {
+		if (port->port_dev)
+			port->port_dev->gone = 1;
 		sas_unregister_domain_devices(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c29ba47..61d2679 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -228,6 +228,13 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 			goto out;
 		}
 
+		/* If the device fell off, no sense in issuing commands */
+		if (dev->gone) {
+			cmd->result = DID_BAD_TARGET << 16;
+			scsi_done(cmd);
+			goto out;
+		}
+
 		res = -ENOMEM;
 		task = sas_create_task(cmd, dev, GFP_ATOMIC);
 		if (!task)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8ad7465..73c5b15 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -207,6 +207,7 @@ struct domain_device {
         };
 
         void *lldd_dev;
+	int gone;
 };
 
 struct sas_discovery_event {
