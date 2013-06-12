From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 06/14] IB/srp: Keep rport as long as the IB transport layer
Date: Wed, 12 Jun 2013 15:26:39 +0200
Message-ID: <51B8770F.3080004@acm.org>
References: <51B87501.4070005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87501.4070005-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Keep the rport data structure around after srp_remove_host() has
finished until cleanup of the IB transport layer has finished
completely. This is necessary because later patches use the rport
pointer inside the queuecommand callback. Without this patch
accessing the rport from inside a queuecommand callback is racy
because srp_remove_host() must be invoked before scsi_remove_host()
and because the queuecommand callback may get invoked after
srp_remove_host() has finished.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 drivers/scsi/scsi_transport_srp.c   |   18 ++++++++++++++++++
 include/scsi/scsi_transport_srp.h   |    2 ++
 4 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1a73b24..2bd0587 100644
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
@@ -2009,6 +2011,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
