From: Cathy Avery <cavery@redhat.com>
Subject: [RFC PATCH] scsi: scsi_transport_fc: Create a lightweight option for
 Virtual FC Hosts.
Date: Wed,  4 Jan 2017 10:39:46 -0500
Message-ID: <1483544386-6008-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch represents an attempt to resurrect the conversation
based on the submission of patch:

[PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on Hyper-V
K. Y. Srinivasan kys at microsoft.com
Sat Mar 12 21:52:48 UTC 2016

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2016-March/087116.html

That patch attempted to address the problem of not being able to scan FC
hosts on a Hyper-V guest via sysfs due to the fact that they did not
contain the complete characteristic set associated with a normal FC host
( missing rports, vports, etc ). These new lightweight hosts as they
were subsequently referred to are not consistent with the current FC
transport model.

The patch below provides a method to reconcile the issue by offering
a lightweight option to the current FC transport class. The new option
is selected by a driver when it indicates it wants the lightweight
transport in fc_function_template. I have included the changes for
storvsc_drv.c in this patch as an example of a driver making use of the
lightweight transport option.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 125 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/storvsc_drv.c       |   6 +-
 include/scsi/scsi_transport_fc.h |   1 +
 3 files changed, 123 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 03577bd..4adc669 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -50,6 +50,15 @@ static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
+static int fc_host_lw_setup(struct Scsi_Host *, struct fc_host_attrs *);
+static int fc_host_hw_setup(struct Scsi_Host *, struct fc_host_attrs *);
+static int fc_host_hw_remove(struct fc_host_attrs *);
+static struct scsi_transport_template *
+	fc_attach_lw_transport(struct fc_function_template *);
+static struct scsi_transport_template *
+	fc_attach_hw_transport(struct fc_function_template *);
+static void fc_remove_lw_host(struct Scsi_Host *);
+static void fc_remove_hw_host(struct Scsi_Host *, struct fc_host_attrs *);
 
 /*
  * Module Parameters
@@ -352,6 +361,10 @@ struct fc_internal {
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
 
+
+static void fc_release_lw_transport(struct fc_internal *);
+static void fc_release_hw_transport(struct fc_internal *);
+
 static int fc_target_setup(struct transport_container *tc, struct device *dev,
 			   struct device *cdev)
 {
@@ -387,7 +400,26 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (i->f->lightweight_transport)
+		return fc_host_lw_setup(shost, fc_host);
+
+	return fc_host_hw_setup(shost, fc_host);
+}
+
+static int fc_host_lw_setup(struct Scsi_Host *shost,
+			    struct fc_host_attrs *fc_host)
+{
+	fc_host->node_name = -1;
+	fc_host->port_name = -1;
+
+	return 0;
+}
 
+static int fc_host_hw_setup(struct Scsi_Host *shost,
+			    struct fc_host_attrs *fc_host)
+{
 	/*
 	 * Set default values easily detected by the midlayer as
 	 * failure cases.  The scsi lldd is responsible for initializing
@@ -468,7 +500,16 @@ static int fc_host_remove(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (i->f->lightweight_transport)
+		return 0;
 
+	return fc_host_hw_remove(fc_host);
+}
+
+static int fc_host_hw_remove(struct fc_host_attrs *fc_host)
+{
 	fc_bsg_remove(fc_host->rqst_q);
 	return 0;
 }
@@ -2175,6 +2216,49 @@ static int fc_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
+	if (ft->lightweight_transport)
+		return fc_attach_lw_transport(ft);
+
+	return fc_attach_hw_transport(ft);
+}
+EXPORT_SYMBOL(fc_attach_transport);
+
+
+struct scsi_transport_template *
+fc_attach_lw_transport(struct fc_function_template *ft)
+{
+	int count;
+	struct fc_internal *i;
+
+	i = kzalloc(sizeof(struct fc_internal),
+			GFP_KERNEL);
+
+	if (unlikely(!i))
+		return NULL;
+
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &fc_host_class.class;
+	i->t.host_attrs.ac.match = fc_host_match;
+	i->t.host_size = sizeof(struct fc_host_attrs);
+	transport_container_register(&i->t.host_attrs);
+
+	i->f = ft;
+
+	count = 0;
+	SETUP_HOST_ATTRIBUTE_RD(node_name);
+	SETUP_HOST_ATTRIBUTE_RD(port_name);
+
+	BUG_ON(count > FC_HOST_NUM_ATTRS);
+
+	i->host_attrs[count] = NULL;
+
+	return &i->t;
+}
+
+
+struct scsi_transport_template *
+fc_attach_hw_transport(struct fc_function_template *ft)
+{
 	int count;
 	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
 					GFP_KERNEL);
@@ -2318,12 +2402,27 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	return &i->t;
 }
-EXPORT_SYMBOL(fc_attach_transport);
 
 void fc_release_transport(struct scsi_transport_template *t)
 {
 	struct fc_internal *i = to_fc_internal(t);
 
+	if (i->f->lightweight_transport)
+		fc_release_lw_transport(i);
+	else
+		fc_release_hw_transport(i);
+}
+EXPORT_SYMBOL(fc_release_transport);
+
+void fc_release_lw_transport(struct fc_internal *i)
+{
+	transport_container_unregister(&i->t.host_attrs);
+
+	kfree(i);
+}
+
+void fc_release_hw_transport(struct fc_internal *i)
+{
 	transport_container_unregister(&i->t.target_attrs);
 	transport_container_unregister(&i->t.host_attrs);
 	transport_container_unregister(&i->rport_attr_cont);
@@ -2331,7 +2430,6 @@ void fc_release_transport(struct scsi_transport_template *t)
 
 	kfree(i);
 }
-EXPORT_SYMBOL(fc_release_transport);
 
 /**
  * fc_queue_work - Queue work to the fc_host workqueue.
@@ -2438,10 +2536,30 @@ fc_flush_devloss(struct Scsi_Host *shost)
 void
 fc_remove_host(struct Scsi_Host *shost)
 {
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (i->f->lightweight_transport)
+		fc_remove_lw_host(shost);
+
+	else
+		fc_remove_hw_host(shost, fc_host);
+}
+EXPORT_SYMBOL(fc_remove_host);
+
+void
+fc_remove_lw_host(struct Scsi_Host *shost)
+{
+	/* flush all scan work items */
+	scsi_flush_work(shost);
+}
+
+void
+fc_remove_hw_host(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
+{
 	struct fc_vport *vport = NULL, *next_vport = NULL;
 	struct fc_rport *rport = NULL, *next_rport = NULL;
 	struct workqueue_struct *work_q;
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -2484,7 +2602,6 @@ fc_remove_host(struct Scsi_Host *shost)
 		destroy_workqueue(work_q);
 	}
 }
-EXPORT_SYMBOL(fc_remove_host);
 
 static void fc_terminate_rport_io(struct fc_rport *rport)
 {
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 888e16e..fc1d6ba 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1882,6 +1882,7 @@ static struct hv_driver storvsc_drv = {
 static struct fc_function_template fc_transport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+	.lightweight_transport = 1,
 };
 #endif
 
@@ -1906,11 +1907,6 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
-
-	/*
-	 * Install Hyper-V specific timeout handler.
-	 */
-	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 924c8e6..b1c03cc 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -718,6 +718,7 @@ struct fc_function_template {
 	unsigned long	show_host_system_hostname:1;
 
 	unsigned long	disable_target_scan:1;
+	unsigned long	lightweight_transport:1;
 };
 
 
-- 
2.5.0
