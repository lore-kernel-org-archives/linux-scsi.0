From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] ib_srp: convert to use the srp transport class
Date: Wed, 27 Jun 2007 16:33:12 +0900
Message-ID: <20070627163312M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:50039 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbXF0K5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2007 06:57:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, rdreier@cisco.com

This converts ib_srp to use the srp transport class.

I don't have ib hardware so I've not tested this patch.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/infiniband/ulp/srp/Kconfig  |    1 +
 drivers/infiniband/ulp/srp/ib_srp.c |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/Kconfig b/drivers/infiniband/ulp/srp/Kconfig
index 8fe3be4..bd7bbbf 100644
--- a/drivers/infiniband/ulp/srp/Kconfig
+++ b/drivers/infiniband/ulp/srp/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_SRP
 	tristate "InfiniBand SCSI RDMA Protocol"
 	depends on INFINIBAND && SCSI
+	select SCSI_SRP_ATTRS
 	---help---
 	  Support for the SCSI RDMA Protocol over InfiniBand.  This
 	  allows you to access storage devices that speak SRP over
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f01ca18..d8d056e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -47,6 +47,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/srp.h>
+#include <scsi/scsi_transport_srp.h>
 
 #include <rdma/ib_cache.h>
 
@@ -90,6 +91,8 @@ static void srp_remove_one(struct ib_dev
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
+static struct scsi_transport_template *ib_srp_transport_template;
+
 static struct ib_client srp_client = {
 	.name   = "srp",
 	.add    = srp_add_one,
@@ -405,6 +408,7 @@ static void srp_remove_work(struct work_
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
+	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
@@ -1530,12 +1534,23 @@ static struct scsi_host_template srp_tem
 
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 {
+	struct srp_rport_identifiers ids;
+	struct srp_rport *rport;
+
 	sprintf(target->target_name, "SRP.T10:%016llX",
 		 (unsigned long long) be64_to_cpu(target->id_ext));
 
 	if (scsi_add_host(target->scsi_host, host->dev->dev->dma_device))
 		return -ENODEV;
 
+	memcpy(ids.port_id, &target->id_ext, 8);
+	memcpy(ids.port_id + 8, &target->ioc_guid, 8);
+	rport = srp_rport_add(target->scsi_host, &ids);
+	if (IS_ERR(rport)) {
+		scsi_remove_host(target->scsi_host);
+		return PTR_ERR(rport);
+	}
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
@@ -1760,6 +1775,7 @@ static ssize_t srp_create_target(struct
 	if (!target_host)
 		return -ENOMEM;
 
+	target_host->transportt = ib_srp_transport_template;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 
@@ -2039,10 +2055,18 @@ static void srp_remove_one(struct ib_dev
 	kfree(srp_dev);
 }
 
+static struct srp_function_template ib_srp_transport_functions = {
+};
+
 static int __init srp_init_module(void)
 {
 	int ret;
 
+	ib_srp_transport_template =
+		srp_attach_transport(&ib_srp_transport_functions);
+	if (!ib_srp_transport_template)
+		return -ENOMEM;
+
 	srp_template.sg_tablesize = srp_sg_tablesize;
 	srp_max_iu_len = (sizeof (struct srp_cmd) +
 			  sizeof (struct srp_indirect_buf) +
@@ -2051,6 +2075,7 @@ static int __init srp_init_module(void)
 	ret = class_register(&srp_class);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
+		srp_release_transport(ib_srp_transport_template);
 		return ret;
 	}
 
@@ -2059,6 +2084,7 @@ static int __init srp_init_module(void)
 	ret = ib_register_client(&srp_client);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register IB client\n");
+		srp_release_transport(ib_srp_transport_template);
 		ib_sa_unregister_client(&srp_sa_client);
 		class_unregister(&srp_class);
 		return ret;
@@ -2072,6 +2098,7 @@ static void __exit srp_cleanup_module(vo
 	ib_unregister_client(&srp_client);
 	ib_sa_unregister_client(&srp_sa_client);
 	class_unregister(&srp_class);
+	srp_release_transport(ib_srp_transport_template);
 }
 
 module_init(srp_init_module);
-- 
1.4.3.2

