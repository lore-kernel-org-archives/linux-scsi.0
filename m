From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/6] transport_srp: add rport roles attribute
Date: Wed, 11 Jul 2007 15:08:15 +0900
Message-ID: <20070711150815K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56152 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbXGKGML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This adds a 'roles' attribute to rport like transport_fc. The role can
be initiator or target. That is, the initiator driver creates target
remote ports and the target driver creates initiator remote ports.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c    |    1 +
 drivers/scsi/scsi_transport_srp.c   |   29 ++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h   |    5 +++++
 4 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d8d056e..e616c4f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1545,6 +1545,7 @@ static int srp_add_target(struct srp_hos
 
 	memcpy(ids.port_id, &target->id_ext, 8);
 	memcpy(ids.port_id + 8, &target->ioc_guid, 8);
+	ids.roles = SRP_RPORT_ROLE_TARGET;
 	rport = srp_rport_add(target->scsi_host, &ids);
 	if (IS_ERR(rport)) {
 		scsi_remove_host(target->scsi_host);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 620e9e7..19e9592 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1650,6 +1650,7 @@ static int ibmvscsi_probe(struct vio_dev
 	/* we don't have a proper target_port_id so let's use the fake one */
 	memcpy(ids.port_id, hostdata->madapter_info.partition_name,
 	       sizeof(ids.port_id));
+	ids.roles = SRP_RPORT_ROLE_TARGET;
 	rport = srp_rport_add(host, &ids);
 	if (IS_ERR(rport))
 		goto add_srp_port_failed;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index dcb3d2a..608abd8 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -37,7 +37,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 3
+#define SRP_RPORT_ATTRS 2
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -107,6 +107,31 @@ show_srp_rport_id(struct class_device *c
 
 static CLASS_DEVICE_ATTR(port_id, S_IRUGO, show_srp_rport_id, NULL);
 
+static const struct {
+	u32 value;
+	char *name;
+} srp_rport_role_names[] = {
+	{SRP_RPORT_ROLE_INITIATOR, "SRP Initiator"},
+	{SRP_RPORT_ROLE_TARGET, "SRP Target"},
+};
+
+static ssize_t
+show_srp_rport_roles(struct class_device *cdev, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(cdev);
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(srp_rport_role_names); i++)
+		if (srp_rport_role_names[i].value == rport->roles) {
+			name = srp_rport_role_names[i].name;
+			break;
+		}
+	return sprintf(buf, "%s\n", name ? : "unknown");
+}
+
+static CLASS_DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -182,6 +207,7 @@ struct srp_rport *srp_rport_add(struct S
 	rport->dev.release = srp_rport_release;
 
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
+	rport->roles = ids->roles;
 
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	sprintf(rport->dev.bus_id, "port-%d:%d", shost->host_no, id);
@@ -266,6 +292,7 @@ srp_attach_transport(struct srp_function
 
 	count = 0;
 	SETUP_RPORT_ATTRIBUTE_RD(port_id);
+	SETUP_RPORT_ATTRIBUTE_RD(roles);
 	i->rport_attrs[count] = NULL;
 
 	i->f = ft;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index adbfca4..08b4a28 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -5,14 +5,19 @@ #include <linux/transport_class.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
 
+#define SRP_RPORT_ROLE_INITIATOR 0
+#define SRP_RPORT_ROLE_TARGET 1
+
 struct srp_rport_identifiers {
 	u8 port_id[16];
+	u8 roles;
 };
 
 struct srp_rport {
 	struct device dev;
 
 	u8 port_id[16];
+	u8 roles;
 };
 
 struct srp_function_template {
-- 
1.4.3.2

