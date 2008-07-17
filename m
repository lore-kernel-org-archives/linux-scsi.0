From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] fc_transport: Add an API to allow an LLD to create vports.
Date: Thu, 17 Jul 2008 14:51:09 -0700
Message-ID: <20080717215109.GQ64690@n8027av35btxc1.qlogic.org>
References: <20080711220819.GE56545@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31061 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbYGQVvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 17:51:12 -0400
Content-Disposition: inline
In-Reply-To: <20080711220819.GE56545@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Smart <james.smart@emulex.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's already a fc_vport_termintate() call exported by
the transport.  This patch adds a symmetric call to the API to allow
an NPIV-capable LLD to instantiate vports sans user intervention.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

On Fri, 11 Jul 2008, Andrew Vasquez wrote:

> This is mostly just a shuffling and reuse of existing code.  Given we
> already use an *_identifiers interface to create rports, the vport
> creation API continues to use the previously internal
> fc_vport_identifiers structure to define a vport object.
> 
> The impetus for this work is that future QLogic cards will have a
> region set aside in flash-memory so that adminstrators may define
> pre-set NPIVs which should be created during OS load.

Ok, so if there's no major objections to the interface, here's an
updated patch which adds some bits of documentation.

diff --git a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
index d403e46..63fab5b 100644
--- a/Documentation/scsi/scsi_fc_transport.txt
+++ b/Documentation/scsi/scsi_fc_transport.txt
@@ -436,6 +436,40 @@ Other:
     was updated to remove all vports for the fc_host as well.
 
 
+Transport supplied functions
+----------------------------
+
+The following functions are supplied by the FC-transport for use by LLDs.
+
+   fc_vport_create - create a vport
+   fc_vport_terminate - detach and remove a vport
+
+Details:
+
+/**
+ * fc_vport_create - Admin App or LLDD requests creation of a vport
+ * @shost:     scsi host the virtual port is connected to.
+ * @ids:       The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Notes:
+ *     This routine assumes no locks are held on entry.
+ */
+struct fc_vport *
+fc_vport_create(struct Scsi_Host *shost, struct fc_vport_identifiers *ids)
+
+/**
+ * fc_vport_terminate - Admin App or LLDD requests termination of a vport
+ * @vport:      fc_vport to be terminated
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *      This routine assumes no locks are held on entry.
+ */
+
+
 Credits
 =======
 The following people have contributed to this document:
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5fd64e7..37f6449 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -40,31 +40,7 @@
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 static void fc_vport_sched_delete(struct work_struct *work);
-
-/*
- * This is a temporary carrier for creating a vport. It will eventually
- * be replaced  by a real message definition for sgio or netlink.
- *
- * fc_vport_identifiers: This set of data contains all elements
- * to uniquely identify and instantiate a FC virtual port.
- *
- * Notes:
- *   symbolic_name: The driver is to append the symbolic_name string data
- *      to the symbolic_node_name data that it generates by default.
- *      the resulting combination should then be registered with the switch.
- *      It is expected that things like Xen may stuff a VM title into
- *      this field.
- */
-struct fc_vport_identifiers {
-	u64 node_name;
-	u64 port_name;
-	u32 roles;
-	bool disable;
-	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */
-	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
-};
-
-static int fc_vport_create(struct Scsi_Host *shost, int channel,
+static int fc_vport_setup(struct Scsi_Host *shost, int channel,
 	struct device *pdev, struct fc_vport_identifiers  *ids,
 	struct fc_vport **vport);
 
@@ -1759,7 +1735,7 @@ store_fc_host_vport_create(struct device *dev, struct device_attribute *attr,
 	vid.disable = false;		/* always enabled */
 
 	/* we only allow support on Channel 0 !!! */
-	stat = fc_vport_create(shost, 0, &shost->shost_gendev, &vid, &vport);
+	stat = fc_vport_setup(shost, 0, &shost->shost_gendev, &vid, &vport);
 	return stat ? stat : count;
 }
 static FC_DEVICE_ATTR(host, vport_create, S_IWUSR, NULL,
@@ -3102,7 +3078,7 @@ fc_scsi_scan_rport(struct work_struct *work)
 
 
 /**
- * fc_vport_create - allocates and creates a FC virtual port.
+ * fc_vport_setup - allocates and creates a FC virtual port.
  * @shost:	scsi host the virtual port is connected to.
  * @channel:	Channel on shost port connected to.
  * @pdev:	parent device for vport
@@ -3117,7 +3093,7 @@ fc_scsi_scan_rport(struct work_struct *work)
  *	This routine assumes no locks are held on entry.
  */
 static int
-fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
+fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
 {
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
@@ -3230,6 +3206,27 @@ delete_vport:
 	return error;
 }
 
+/**
+ * fc_vport_create - Admin App or LLDD requests creation of a vport
+ * @shost:	scsi host the virtual port is connected to.
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_vport *
+fc_vport_create(struct Scsi_Host *shost, struct fc_vport_identifiers *ids)
+{
+	int stat;
+	struct fc_vport *vport;
+
+	/* We only create vports here. */
+	ids->vport_type = FC_PORTTYPE_NPIV;
+	stat = fc_vport_setup(shost, 0, &shost->shost_gendev, ids, &vport);
+	return stat ? NULL : vport;
+}
+EXPORT_SYMBOL(fc_vport_create);
 
 /**
  * fc_vport_terminate - Admin App or LLDD requests termination of a vport
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 06f72ba..cbd621d 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -167,6 +167,26 @@ enum fc_tgtid_binding_type  {
 struct device_attribute dev_attr_vport_##_name = 	\
 	__ATTR(_name,_mode,_show,_store)
 
+/*
+ * fc_vport_identifiers: This set of data contains all elements
+ * to uniquely identify and instantiate a FC virtual port.
+ *
+ * Notes:
+ *   symbolic_name: The driver is to append the symbolic_name string data
+ *      to the symbolic_node_name data that it generates by default.
+ *      the resulting combination should then be registered with the switch.
+ *      It is expected that things like Xen may stuff a VM title into
+ *      this field.
+ */
+#define FC_VPORT_SYMBOLIC_NAMELEN		64
+struct fc_vport_identifiers {
+	u64 node_name;
+	u64 port_name;
+	u32 roles;
+	bool disable;
+	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */
+	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
+};
 
 /*
  * FC Virtual Port Attributes
@@ -197,7 +217,6 @@ struct device_attribute dev_attr_vport_##_name = 	\
  * managed by the transport w/o driver interaction.
  */
 
-#define FC_VPORT_SYMBOLIC_NAMELEN		64
 struct fc_vport {
 	/* Fixed Attributes */
 
@@ -732,6 +751,8 @@ void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h
 	 */
+struct fc_vport *fc_vport_create(struct Scsi_Host *shost,
+		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 
 #endif /* SCSI_TRANSPORT_FC_H */
