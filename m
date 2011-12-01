From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 10/14] srp_transport: Simplify attribute initialization code
Date: Thu, 1 Dec 2011 20:08:00 +0100
Message-ID: <201112012008.00502.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Eliminate the private_rport_attrs[] array and the SETUP_*() macros
used to set up that array since the information in that array
duplicates the information in the static device attributes. Also,
trigger a kernel warning if SRP_RPORT_ATTRS is not large enough
since it is easy to forget to update that macro when adding new
attributes.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 07c4394..1cbf097 100644
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
+	WARN_ON(count > ARRAY_SIZE(i->rport_attrs));
 
 	transport_container_register(&i->rport_attr_cont);
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
