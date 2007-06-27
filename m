From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] ibmvscsi: convert to use the srp transport class
Date: Wed, 27 Jun 2007 16:32:50 +0900
Message-ID: <20070627163250P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41318 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbXF0IFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2007 04:05:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, santil@us.ibm.com

This converts ibmvscsi to use the srp transport class.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/Kconfig             |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c261ccb..dfb45e7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -829,6 +829,7 @@ config SCSI_IPS
 config SCSI_IBMVSCSI
 	tristate "IBM Virtual SCSI support"
 	depends on PPC_PSERIES || PPC_ISERIES
+	select SCSI_SRP_ATTRS
 	help
 	  This is the IBM POWER Virtual SCSI Client
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index f5da762..620e9e7 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -75,6 +75,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_srp.h>
 #include "ibmvscsi.h"
 
 /* The values below are somewhat arbitrary default values, but 
@@ -87,6 +88,8 @@ static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 
+static struct scsi_transport_template *ibmvscsi_transport_template;
+
 #define IBMVSCSI_VERSION "1.5.8"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
@@ -1604,6 +1607,8 @@ static int ibmvscsi_probe(struct vio_dev
 	struct ibmvscsi_host_data *hostdata;
 	struct Scsi_Host *host;
 	struct device *dev = &vdev->dev;
+	struct srp_rport_identifiers ids;
+	struct srp_rport *rport;
 	unsigned long wait_switch = 0;
 	int rc;
 
@@ -1616,6 +1621,7 @@ static int ibmvscsi_probe(struct vio_dev
 		goto scsi_host_alloc_failed;
 	}
 
+	host->transportt = ibmvscsi_transport_template;
 	hostdata = (struct ibmvscsi_host_data *)host->hostdata;
 	memset(hostdata, 0x00, sizeof(*hostdata));
 	INIT_LIST_HEAD(&hostdata->sent);
@@ -1641,6 +1647,13 @@ static int ibmvscsi_probe(struct vio_dev
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
 
+	/* we don't have a proper target_port_id so let's use the fake one */
+	memcpy(ids.port_id, hostdata->madapter_info.partition_name,
+	       sizeof(ids.port_id));
+	rport = srp_rport_add(host, &ids);
+	if (IS_ERR(rport))
+		goto add_srp_port_failed;
+
 	/* Try to send an initialization message.  Note that this is allowed
 	 * to fail if the other end is not acive.  In that case we don't
 	 * want to scan
@@ -1668,6 +1681,8 @@ static int ibmvscsi_probe(struct vio_dev
 	vdev->dev.driver_data = hostdata;
 	return 0;
 
+      add_srp_port_failed:
+	scsi_remove_host(hostdata->host);
       add_host_failed:
 	release_event_pool(&hostdata->pool, hostdata);
       init_pool_failed:
@@ -1684,7 +1699,8 @@ static int ibmvscsi_remove(struct vio_de
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 				   max_requests);
-	
+
+	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
 	scsi_host_put(hostdata->host);
 
@@ -1711,14 +1727,28 @@ static struct vio_driver ibmvscsi_driver
 	}
 };
 
+static struct srp_function_template ibmvscsi_transport_functions = {
+};
+
 int __init ibmvscsi_module_init(void)
 {
-	return vio_register_driver(&ibmvscsi_driver);
+	int ret;
+
+	ibmvscsi_transport_template =
+		srp_attach_transport(&ibmvscsi_transport_functions);
+	if (!ibmvscsi_transport_template)
+		return -ENOMEM;
+
+	ret = vio_register_driver(&ibmvscsi_driver);
+	if (ret)
+		srp_release_transport(ibmvscsi_transport_template);
+	return ret;
 }
 
 void __exit ibmvscsi_module_exit(void)
 {
 	vio_unregister_driver(&ibmvscsi_driver);
+	srp_release_transport(ibmvscsi_transport_template);
 }
 
 module_init(ibmvscsi_module_init);
-- 
1.4.3.2

