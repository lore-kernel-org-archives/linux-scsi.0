From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 2/5] FC transport: Add interface to specify fast io level for timed-out cmds
Date: Mon, 20 May 2013 15:15:00 +0800
Message-ID: <1369034103-31644-3-git-send-email-renmx@cn.fujitsu.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces new interfaces through sysfs for fc hosts
and rports to allow users to avoid the scsi_eh recovery actions
on different levels when scsi commands timed out, e.g.
  /sys/devices/pci***/.../hostN/fc_host/hostN/fast_io_tmo_flags
  /sys/devices/pci***/.../hostN/rport-X:Y-Z/fc_remote_ports/\
                                rport-X:Y-Z/fast_io_tmo_flags

This new added interface "fast_io_tmo_flags" is a 8-bit mask with
low 5-bit available up to now:
  0x01 - Ignore aborting commands
  0x02 - Ignore device resets
  0x04 - Ignore target resets
  0x08 - Ignore bus resets
  0x10 - Ignore host resets

When scsi_eh unjams hosts, the corresponding bit fields will be
checked by LLDD to decide whether to ignore specified recovery
levels. Its value is zero by default, so it keeps existing
behavior, which is necessary for non-redundant systems.

This interface is mainly for redundant environments. To
redundant systems, they need a quick give up and failover,
instead of thorough recovery which usually takes much time.

The actions in LLDD/redundant configurations should be implemented
individually later.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/scsi_transport_fc.c |  108 +++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_fc.h |   11 ++++
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7b29e00..155a658 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -310,9 +310,9 @@ static void fc_scsi_scan_rport(struct work_struct *work);
  * Increase these values if you add attributes
  */
 #define FC_STARGET_NUM_ATTRS 	3
-#define FC_RPORT_NUM_ATTRS	10
+#define FC_RPORT_NUM_ATTRS	11
 #define FC_VPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	29
+#define FC_HOST_NUM_ATTRS	30
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -995,6 +995,67 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
 static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
+/*
+ * fast_io_tmo_flags attribute
+ */
+static ssize_t
+show_fc_rport_fast_io_tmo_flags(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	return sprintf(buf, "0x%02x\n", rport->fast_io_tmo_flags);
+}
+
+static int fc_str_to_fast_io_tmo_flags(const char *buf, u8 *val)
+{
+	char *cp;
+
+	*val = simple_strtoul(buf, &cp, 0) & 0xff;
+	if (cp == buf)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fc_rport_set_fast_io_tmo_flags(struct fc_rport *rport, u8 val)
+{
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+
+	rport->fast_io_tmo_flags = val;
+
+	return 0;
+}
+
+static ssize_t
+store_fc_rport_fast_io_tmo_flags(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t count)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	u8 val;
+	int rc;
+
+	if (count < 1)
+		return -EINVAL;
+
+	rc = fc_str_to_fast_io_tmo_flags(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = fc_rport_set_fast_io_tmo_flags(rport, val);
+	if (rc)
+		return rc;
+	return count;
+}
+static FC_DEVICE_ATTR(rport, fast_io_tmo_flags, S_IRUGO | S_IWUSR,
+	show_fc_rport_fast_io_tmo_flags, store_fc_rport_fast_io_tmo_flags);
+
 
 /*
  * FC SCSI Target Attribute Management
@@ -1679,6 +1740,47 @@ static FC_DEVICE_ATTR(host, dev_loss_tmo, S_IRUGO | S_IWUSR,
 		      show_fc_host_dev_loss_tmo,
 		      store_fc_private_host_dev_loss_tmo);
 
+static ssize_t
+show_fc_private_host_fast_io_tmo_flags (struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(dev);
+
+	return sprintf(buf, "0x%02x\n", fc_host_fast_io_tmo_flags(shost));
+}
+
+static ssize_t
+store_fc_private_host_fast_io_tmo_flags(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(dev);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_rport *rport;
+	u8 val;
+	int rc;
+	unsigned long flags;
+
+	if (count < 1)
+		return -EINVAL;
+
+	rc = fc_str_to_fast_io_tmo_flags(buf, &val);
+	if (rc)
+		return rc;
+
+	fc_host_fast_io_tmo_flags(shost) = val;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(rport, &fc_host->rports, peers)
+		fc_rport_set_fast_io_tmo_flags(rport, val);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return count;
+}
+static FC_DEVICE_ATTR(host, fast_io_tmo_flags, S_IRUGO | S_IWUSR,
+		      show_fc_private_host_fast_io_tmo_flags,
+		      store_fc_private_host_fast_io_tmo_flags);
+
 fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
 
 /*
@@ -2261,6 +2363,7 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	/* Transport-managed attributes */
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(dev_loss_tmo);
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(fast_io_tmo_flags);
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
 	if (ft->issue_fc_host_lip)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
@@ -2287,6 +2390,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_tmo_flags);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..8fd673c 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -336,6 +336,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
 	u32 fast_io_fail_tmo;
+	u8 fast_io_tmo_flags;	
 
 	/* exported data */
 	void *dd_data;			/* Used for driver-specific storage */
@@ -354,6 +355,13 @@ struct fc_rport {	/* aka fc_starget_attrs */
 	struct request_queue *rqst_q;	/* bsg support */
 } __attribute__((aligned(sizeof(unsigned long))));
 
+/* bit field values for struct fc_rport "fast_io_tmo_flags" field: */
+#define FC_RPORT_IGN_ABORT_CMDS		0x01
+#define FC_RPORT_IGN_DEVICE_RESET	0x02
+#define FC_RPORT_IGN_TARGET_RESET	0x04
+#define FC_RPORT_IGN_BUS_RESET		0x08
+#define FC_RPORT_IGN_HOST_RESET		0x10
+
 /* bit field values for struct fc_rport "flags" field: */
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
@@ -519,6 +527,7 @@ struct fc_host_attrs {
 
 	/* Private (Transport-managed) Attributes */
 	enum fc_tgtid_binding_type  tgtid_bind_type;
+	u8 fast_io_tmo_flags;
 
 	/* internal data */
 	struct list_head rports;
@@ -616,6 +625,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 #define fc_host_dev_loss_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
+#define fc_host_fast_io_tmo_flags(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->fast_io_tmo_flags)
 
 
 struct fc_bsg_buffer {
-- 
1.7.1
