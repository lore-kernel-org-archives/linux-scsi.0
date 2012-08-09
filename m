From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 14/20] srp_transport: Simplify attribute initialization code
Date: Thu, 09 Aug 2012 15:57:14 +0000
Message-ID: <5023DDDA.9050904@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:39900 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2HIP5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2012 11:57:17 -0400
In-Reply-To: <5023DA39.7020000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Eliminate the private_rport_attrs[] array and the SETUP_*() macros
used to set up that array since the information in that array
duplicates the information in the static device attributes. Also,
verify whether SRP_RPORT_ATTRS is large enough since it is easy
to forget to update that macro when adding new attributes.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/scsi_transport_srp.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 07c4394..0d85f79 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -47,7 +47,6 @@ struct srp_internal {
 	struct device_attribute *host_attrs[SRP_HOST_ATTRS + 1];
 
 	struct device_attribute *rport_attrs[SRP_RPORT_ATTRS + 1];
-	struct device_attribute private_rport_attrs[SRP_RPORT_ATTRS];
 	struct transport_container rport_attr_cont;
 };
 
@@ -72,24 +71,6 @@ static DECLARE_TRANSPORT_CLASS(srp_host_class, "srp_host", srp_host_setup,
 static DECLARE_TRANSPORT_CLASS(srp_rport_class, "srp_remote_ports",
 			       NULL, NULL, NULL);
 
-#define SETUP_TEMPLATE(attrb, field, perm, test, ro_test, ro_perm)	\
-	i->private_##attrb[count] = dev_attr_##field;		\
-	i->private_##attrb[count].attr.mode = perm;			\
-	if (ro_test) {							\
-		i->private_##attrb[count].attr.mode = ro_perm;		\
-		i->private_##attrb[count].store = NULL;			\
-	}								\
-	i->attrb[count] = &i->private_##attrb[count];			\
-	if (test)							\
-		count++
-
-#define SETUP_RPORT_ATTRIBUTE_RD(field)					\
-	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO, 1, 0, 0)
-
-#define SETUP_RPORT_ATTRIBUTE_RW(field)					\
-	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO | S_IWUSR,		\
-		       1, 1, S_IRUGO)
-
 #define SRP_PID(p) \
 	(p)->port_id[0], (p)->port_id[1], (p)->port_id[2], (p)->port_id[3], \
 	(p)->port_id[4], (p)->port_id[5], (p)->port_id[6], (p)->port_id[7], \
@@ -326,9 +307,10 @@ srp_attach_transport(struct srp_function_template *ft)
 	i->rport_attr_cont.ac.match = srp_rport_match;
 
 	count = 0;
-	SETUP_RPORT_ATTRIBUTE_RD(port_id);
-	SETUP_RPORT_ATTRIBUTE_RD(roles);
-	i->rport_attrs[count] = NULL;
+	i->rport_attrs[count++] = &dev_attr_port_id;
+	i->rport_attrs[count++] = &dev_attr_roles;
+	i->rport_attrs[count++] = NULL;
+	BUG_ON(count > ARRAY_SIZE(i->rport_attrs));
 
 	transport_container_register(&i->rport_attr_cont);
 
-- 
1.7.7

