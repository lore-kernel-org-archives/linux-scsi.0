From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/6] srp_transport: add target driver support
Date: Wed, 11 Jul 2007 15:08:19 +0900
Message-ID: <20070711150819P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56161 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104AbXGKGMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This adds minimum target driver support:

- srp_rport_{add,del} calls scsi_tgt_it_nexus_{create,destroy} for
target drivers.

- add a callback to notify target drivers of the nexus operation
results to srp_function_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig              |    2 +-
 drivers/scsi/scsi_transport_srp.c |   24 ++++++++++++++++++++++++
 include/scsi/scsi_transport_srp.h |    3 ++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index dfb45e7..ede8395 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -285,7 +285,7 @@ source "drivers/scsi/libsas/Kconfig"
 
 config SCSI_SRP_ATTRS
 	tristate "SRP Transport Attributes"
-	depends on SCSI
+	depends on SCSI && SCSI_TGT
 	help
 	  If you wish to export transport-specific information about
 	  each attached SRP device to sysfs, say Y.
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 608abd8..8e5b41c 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -30,6 +30,7 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
+#include <scsi/scsi_tgt.h>
 
 struct srp_host_attrs {
 	atomic_t next_port_id;
@@ -221,6 +222,17 @@ struct srp_rport *srp_rport_add(struct S
 		return ERR_PTR(ret);
 	}
 
+	if (ids->roles == SRP_RPORT_ROLE_INITIATOR) {
+		ret = scsi_tgt_it_nexus_create(shost, (unsigned long)rport,
+					       rport->port_id);
+		if (ret) {
+			device_del(&rport->dev);
+			transport_destroy_device(&rport->dev);
+			put_device(&rport->dev);
+			return ERR_PTR(ret);
+		}
+	}
+
 	transport_add_device(&rport->dev);
 	transport_configure_device(&rport->dev);
 
@@ -238,6 +250,10 @@ void srp_rport_del(struct srp_rport *rpo
 {
 	struct device *dev = &rport->dev;
 
+	if (rport->roles == SRP_RPORT_ROLE_INITIATOR)
+		scsi_tgt_it_nexus_destroy(dev_to_shost(dev->parent),
+					  (unsigned long)rport);
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -264,6 +280,12 @@ void srp_remove_host(struct Scsi_Host *s
 }
 EXPORT_SYMBOL_GPL(srp_remove_host);
 
+static int srp_it_nexus_response(struct Scsi_Host *shost, u64 id, int result)
+{
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+	return i->f->it_nexus_response(shost, id, result);
+}
+
 /**
  * srp_attach_transport  --  instantiate SRP transport template
  * @ft:		SRP transport class function template
@@ -278,6 +300,8 @@ srp_attach_transport(struct srp_function
 	if (!i)
 		return NULL;
 
+	i->t.it_nexus_response = srp_it_nexus_response;
+
 	i->t.host_size = sizeof(struct srp_host_attrs);
 	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
 	i->t.host_attrs.ac.class = &srp_host_class.class;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 08b4a28..a705dbc 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -21,7 +21,8 @@ struct srp_rport {
 };
 
 struct srp_function_template {
-	/* later */
+	/* for target drivers */
+	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
 };
 
 extern struct scsi_transport_template *
-- 
1.4.3.2

