From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 06/13] IB/srp: Keep rport as long as the IB transport layer
Date: Wed, 03 Jul 2013 14:53:26 +0200
Message-ID: <51D41EC6.1070409@acm.org>
References: <51D41C03.4020607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:34220 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3GCMx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 08:53:28 -0400
In-Reply-To: <51D41C03.4020607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: David Dillow <dave@thedillows.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

Keep the rport data structure around after srp_remove_host() has
finished until cleanup of the IB transport layer has finished
completely. This is necessary because later patches use the rport
pointer inside the queuecommand callback. Without this patch
accessing the rport from inside a queuecommand callback is racy
because srp_remove_host() must be invoked before scsi_remove_host()
and because the queuecommand callback may get invoked after
srp_remove_host() has finished.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 drivers/scsi/scsi_transport_srp.c   |   18 ++++++++++++++++++
 include/scsi/scsi_transport_srp.h   |    2 ++
 4 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f046e32..f65701d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -526,11 +526,13 @@ static void srp_remove_target(struct srp_target_port *target)
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
 	srp_del_scsi_host_attr(target->scsi_host);
+	srp_rport_get(target->rport);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
 	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
+	srp_rport_put(target->rport);
 	srp_free_req_data(target);
 	scsi_host_put(target->scsi_host);
 }
@@ -1982,6 +1984,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	}
 
 	rport->lld_data = target;
+	target->rport = rport;
 
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 66fbedd..1817ed5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -153,6 +153,7 @@ struct srp_target_port {
 	u16			io_class;
 	struct srp_host	       *srp_host;
 	struct Scsi_Host       *scsi_host;
+	struct srp_rport       *rport;
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f379c7f..f7ba94a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -185,6 +185,24 @@ static int srp_host_match(struct attribute_container *cont, struct device *dev)
 }
 
 /**
+ * srp_rport_get() - increment rport reference count
+ */
+void srp_rport_get(struct srp_rport *rport)
+{
+	get_device(&rport->dev);
+}
+EXPORT_SYMBOL(srp_rport_get);
+
+/**
+ * srp_rport_put() - decrement rport reference count
+ */
+void srp_rport_put(struct srp_rport *rport)
+{
+	put_device(&rport->dev);
+}
+EXPORT_SYMBOL(srp_rport_put);
+
+/**
  * srp_rport_add - add a SRP remote port to the device hierarchy
  * @shost:	scsi host the remote port is connected to.
  * @ids:	The port id for the remote port.
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index ff0f04a..5a2d2d1 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -38,6 +38,8 @@ extern struct scsi_transport_template *
 srp_attach_transport(struct srp_function_template *);
 extern void srp_release_transport(struct scsi_transport_template *);
 
+extern void srp_rport_get(struct srp_rport *rport);
+extern void srp_rport_put(struct srp_rport *rport);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
-- 
1.7.10.4

