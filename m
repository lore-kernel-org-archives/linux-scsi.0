From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] libsas: Fix kernel-doc headers
Date: Mon, 12 Feb 2018 10:45:00 -0800
Message-ID: <20180212184500.26562-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9405 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752972AbeBLSpB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 13:45:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Avoid that building with W=1 causes the kernel-doc tool to complain
about the libsas kernel-doc headers.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/libsas/sas_discover.c |  6 +++---
 drivers/scsi/libsas/sas_expander.c | 20 ++++++++++----------
 drivers/scsi/libsas/sas_init.c     |  2 +-
 drivers/scsi/libsas/sas_port.c     |  1 +
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index e4fd078e4175..8a184c7f5f56 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -279,7 +279,7 @@ static void sas_resume_devices(struct work_struct *work)
 
 /**
  * sas_discover_end_dev -- discover an end device (SSP, etc)
- * @end: pointer to domain device of interest
+ * @dev: pointer to domain device of interest
  *
  * See comment in sas_discover_sata().
  */
@@ -429,7 +429,7 @@ void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
 
 /**
  * sas_discover_domain -- discover the domain
- * @port: port to the domain of interest
+ * @work: work structure embedded in port to the domain of interest
  *
  * NOTE: this process _must_ quit (return) as soon as any connection
  * errors are encountered.  Connection recovery is done elsewhere.
@@ -571,7 +571,7 @@ int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
 	return 0;
 }
 
-/**
+/*
  * sas_init_disc -- initialize the discovery struct in the port
  * @port: pointer to struct port
  *
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6a4f8198b78e..6e7a128619f4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1171,8 +1171,8 @@ static int sas_check_level_subtractive_boundary(struct domain_device *dev)
 }
 /**
  * sas_ex_discover_devices -- discover devices attached to this expander
- * dev: pointer to the expander domain device
- * single: if you want to do a single phy, else set to -1;
+ * @dev: pointer to the expander domain device
+ * @single: if you want to do a single phy, else set to -1;
  *
  * Configure this expander for use with its devices and register the
  * devices of this expander.
@@ -1527,11 +1527,11 @@ static int sas_configure_phy(struct domain_device *dev, int phy_id,
 	return res;
 }
 
-/**
+/*
  * sas_configure_parent -- configure routing table of parent
- * parent: parent expander
- * child: child expander
- * sas_addr: SAS port identifier of device directly attached to child
+ * @parent: parent expander
+ * @child: child expander
+ * @sas_addr: SAS port identifier of device directly attached to child
  */
 static int sas_configure_parent(struct domain_device *parent,
 				struct domain_device *child,
@@ -1571,8 +1571,8 @@ static int sas_configure_parent(struct domain_device *parent,
 
 /**
  * sas_configure_routing -- configure routing
- * dev: expander device
- * sas_addr: port identifier of device directly attached to the expander device
+ * @dev: expander device
+ * @sas_addr: port identifier of device directly attached to the expander device
  */
 static int sas_configure_routing(struct domain_device *dev, u8 *sas_addr)
 {
@@ -1590,7 +1590,7 @@ static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr)
 
 /**
  * sas_discover_expander -- expander discovery
- * @ex: pointer to expander domain device
+ * @dev: pointer to expander domain device
  *
  * See comment in sas_discover_sata().
  */
@@ -2112,7 +2112,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 
 /**
  * sas_revalidate_domain -- revalidate the domain
- * @port: port to the domain of interest
+ * @port_dev: port to the domain of interest
  *
  * NOTE: this process _must_ quit (return) as soon as any connection
  * errors are encountered.  Connection recovery is done elsewhere.
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index c81a63b5dc71..ede0af78144f 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -234,7 +234,7 @@ int sas_try_ata_reset(struct asd_sas_phy *asd_phy)
 	return -ENODEV;
 }
 
-/**
+/*
  * transport_sas_phy_reset - reset a phy and permit libata to manage the link
  *
  * phy reset request via sysfs in host workqueue context so we know we
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index f07e55d3aa73..7cd7b9f3f25e 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -199,6 +199,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 /**
  * sas_deform_port -- remove this phy from the port it belongs to
  * @phy: the phy of interest
+ * @gone: whether or not the port is gone
  *
  * This is called when the physical link to the other phy has been
  * lost (on this phy), in Event thread context. We cannot delay here.
-- 
2.16.1
