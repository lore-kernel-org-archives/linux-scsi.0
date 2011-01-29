From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/28] libfc: add hook to notify providers of local port
	changes
Date: Fri, 28 Jan 2011 16:04:18 -0800
Message-ID: <20110129000418.1784.10502.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42266 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1A2AET (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:19 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When an SCST provider is registered, it needs to know what
local ports are available for configuration as targets.

Add a notifier chain that is invoked when any local port
that is added or deleted.

Maintain a global list of local ports and add an
interator function that calls a given function for
every existing local port.  This is used when first
loading a provider.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_libfc.c |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_libfc.h |    2 ++
 drivers/scsi/libfc/fc_lport.c |    2 ++
 include/scsi/libfc.h          |   14 +++++++++++++-
 4 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index ae3abef..5e40dab 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -36,6 +36,10 @@ module_param_named(debug_logging, fc_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
 DEFINE_MUTEX(fc_prov_mutex);
+static LIST_HEAD(fc_local_ports);
+struct blocking_notifier_head fc_lport_notifier_head =
+		BLOCKING_NOTIFIER_INIT(fc_lport_notifier_head);
+EXPORT_SYMBOL(fc_lport_notifier_head);
 
 /*
  * Providers which primarily send requests and PRLIs.
@@ -228,6 +232,17 @@ void fc_fill_reply_hdr(struct fc_frame *fp, const struct fc_frame *in_fp,
 }
 EXPORT_SYMBOL(fc_fill_reply_hdr);
 
+void fc_lport_iterate(void (*notify)(struct fc_lport *, void *), void *arg)
+{
+	struct fc_lport *lport;
+
+	mutex_lock(&fc_prov_mutex);
+	list_for_each_entry(lport, &fc_local_ports, lport_list)
+		notify(lport, arg);
+	mutex_unlock(&fc_prov_mutex);
+}
+EXPORT_SYMBOL(fc_lport_iterate);
+
 /**
  * fc_fc4_register_provider() - register FC-4 upper-level provider.
  * @type: FC-4 type, such as FC_TYPE_FCP
@@ -270,3 +285,29 @@ void fc_fc4_deregister_provider(enum fc_fh_type type, struct fc4_prov *prov)
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(fc_fc4_deregister_provider);
+
+/**
+ * fc_fc4_add_lport() - add new local port to list and run notifiers.
+ * @lport:  The new local port.
+ */
+void fc_fc4_add_lport(struct fc_lport *lport)
+{
+	mutex_lock(&fc_prov_mutex);
+	list_add_tail(&lport->lport_list, &fc_local_ports);
+	blocking_notifier_call_chain(&fc_lport_notifier_head,
+				     FC_LPORT_EV_ADD, lport);
+	mutex_unlock(&fc_prov_mutex);
+}
+
+/**
+ * fc_fc4_del_lport() - remove local port from list and run notifiers.
+ * @lport:  The new local port.
+ */
+void fc_fc4_del_lport(struct fc_lport *lport)
+{
+	mutex_lock(&fc_prov_mutex);
+	list_del(&lport->lport_list);
+	blocking_notifier_call_chain(&fc_lport_notifier_head,
+				     FC_LPORT_EV_DEL, lport);
+	mutex_unlock(&fc_prov_mutex);
+}
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index 205de28..8496f70 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -123,6 +123,8 @@ void fc_destroy_fcp(void);
  * Internal libfc functions
  */
 const char *fc_els_resp_type(struct fc_frame *);
+extern void fc_fc4_add_lport(struct fc_lport *);
+extern void fc_fc4_del_lport(struct fc_lport *);
 
 /*
  * Copies a buffer into an sg list
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e2cd087..e0ef814 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -633,6 +633,7 @@ int fc_lport_destroy(struct fc_lport *lport)
 	lport->tt.fcp_abort_io(lport);
 	lport->tt.disc_stop_final(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
+	fc_fc4_del_lport(lport);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_destroy);
@@ -1633,6 +1634,7 @@ int fc_lport_init(struct fc_lport *lport)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_1GBIT;
 	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
+	fc_fc4_add_lport(lport);
 
 	return 0;
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a9aff25..79d1c76 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -763,6 +763,15 @@ struct fc_disc {
 			      enum fc_disc_event);
 };
 
+/*
+ * Local port notifier and events.
+ */
+extern struct blocking_notifier_head fc_lport_notifier_head;
+enum fc_lport_event {
+	FC_LPORT_EV_ADD,
+	FC_LPORT_EV_DEL,
+};
+
 /**
  * struct fc_lport - Local port
  * @host:                  The SCSI host associated with a local port
@@ -803,9 +812,10 @@ struct fc_disc {
  * @lso_max:               The maximum large offload send size
  * @fcts:                  FC-4 type mask
  * @lp_mutex:              Mutex to protect the local port
- * @list:                  Handle for list of local ports
+ * @list:                  Linkage on list of vport peers
  * @retry_work:            Handle to local port for delayed retry context
  * @prov:		   Pointers available for use by passive FC-4 providers
+ * @lport_list:            Linkage on module-wide list of local ports
  */
 struct fc_lport {
 	/* Associations */
@@ -862,6 +872,7 @@ struct fc_lport {
 	struct list_head               list;
 	struct delayed_work	       retry_work;
 	void			       *prov[FC_FC4_PROV_SIZE];
+	struct list_head               lport_list;
 };
 
 /**
@@ -1016,6 +1027,7 @@ struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
 int fc_lport_bsg_request(struct fc_bsg_job *);
 void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
+void fc_lport_iterate(void (*func)(struct fc_lport *, void *), void *);
 
 /*
  * REMOTE PORT LAYER

