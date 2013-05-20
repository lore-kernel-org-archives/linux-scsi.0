From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 3/5] SAS transport: Add interface to specify fast io level for timed-out cmds
Date: Mon, 20 May 2013 15:15:01 +0800
Message-ID: <1369034103-31644-4-git-send-email-renmx@cn.fujitsu.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces new interfaces through sysfs for sas hosts
and rphys to allow users to avoid the scsi_eh recovery actions
on different levels when scsi commands timed out, e.g.
  /sys/devices/pci***/.../hostN/sas_host/hostN/fast_io_tmo_flags
  /sys/devices/pci***/.../hostN/port-X:Y/end_device-X:Y/\
                      sas_device/end_device-X:Y/fast_io_tmo_flags

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
 drivers/scsi/scsi_sas_internal.h  |    4 +-
 drivers/scsi/scsi_transport_sas.c |  103 ++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_sas.h |    8 +++
 3 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sas_internal.h b/drivers/scsi/scsi_sas_internal.h
index 6266a5d..8c7ab08 100644
--- a/drivers/scsi/scsi_sas_internal.h
+++ b/drivers/scsi/scsi_sas_internal.h
@@ -1,10 +1,10 @@
 #ifndef _SCSI_SAS_INTERNAL_H
 #define _SCSI_SAS_INTERNAL_H
 
-#define SAS_HOST_ATTRS		0
+#define SAS_HOST_ATTRS		1
 #define SAS_PHY_ATTRS		17
 #define SAS_PORT_ATTRS		1
-#define SAS_RPORT_ATTRS		7
+#define SAS_RPORT_ATTRS		8
 #define SAS_END_DEV_ATTRS	5
 #define SAS_EXPANDER_ATTRS	7
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..960f3e5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -37,6 +37,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "scsi_sas_internal.h"
 struct sas_host_attrs {
@@ -46,6 +47,7 @@ struct sas_host_attrs {
 	u32 next_target_id;
 	u32 next_expander_id;
 	int next_port_id;
+	u8 fast_io_tmo_flags;
 };
 #define to_sas_host_attrs(host)	((struct sas_host_attrs *)(host)->shost_data)
 
@@ -277,6 +279,59 @@ static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
  * SAS host attributes
  */
 
+static ssize_t
+show_sas_private_host_fast_io_tmo_flags(struct device *dev,
+					struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	return sprintf(buf, "0x%02x\n", sas_host->fast_io_tmo_flags);
+}
+
+static int sas_str_to_fast_io_tmo_flags(const char *buf, u8 *val)
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
+static ssize_t
+store_sas_private_host_fast_io_tmo_flags(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	struct sas_rphy *rphy;
+	u8 val;
+	int rc;
+	unsigned long flags;
+
+	if (count < 1)
+		return -EINVAL;
+
+	rc = sas_str_to_fast_io_tmo_flags(buf, &val);
+	if (rc)
+		return rc;
+
+	sas_host->fast_io_tmo_flags = val;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(rphy, &sas_host->rphy_list, list)
+		rphy->fast_io_tmo_flags = val;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return count;
+}
+
+static SAS_DEVICE_ATTR(host, fast_io_tmo_flags, S_IRUGO | S_IWUSR,
+		show_sas_private_host_fast_io_tmo_flags,
+		store_sas_private_host_fast_io_tmo_flags);
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
@@ -1267,6 +1322,38 @@ sas_rphy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
 		unsigned long long);
 sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
 
+static ssize_t show_sas_rphy_fast_io_tmo_flags (struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	struct sas_rphy *rphy = transport_class_to_rphy(dev);
+
+	return sprintf(buf, "0x%02x\n", rphy->fast_io_tmo_flags);
+}
+
+static ssize_t store_sas_rphy_fast_io_tmo_flags(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf,
+						size_t count)
+{
+	struct sas_rphy *rphy = transport_class_to_rphy(dev);
+	u8 val;
+	int rc;
+
+	if (count < 1)
+		return -EINVAL;
+
+	rc = sas_str_to_fast_io_tmo_flags(buf, &val);
+	if (rc)
+		return rc;
+
+	rphy->fast_io_tmo_flags = val;
+	return count;
+}
+static SAS_DEVICE_ATTR(rphy, fast_io_tmo_flags, S_IRUGO | S_IWUSR,
+		show_sas_rphy_fast_io_tmo_flags,
+		store_sas_rphy_fast_io_tmo_flags);
+
 /* only need 8 bytes of data plus header (4 or 8) */
 #define BUF_SIZE 64
 
@@ -1751,9 +1838,18 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 	if (test)							\
 		count++
 
+#define SETUP_TEMPLATE_PRIVATE_RW(attrb, field, perm)			\
+	SETUP_TEMPLATE_RW(attrb, field, perm, 1, 0, 0)
+
+#define SETUP_PRIVATE_HOST_ATTRIBUTE_RW(field)				\
+	SETUP_TEMPLATE_PRIVATE_RW(host_attrs, field, S_IRUGO | S_IWUSR)
+
 #define SETUP_RPORT_ATTRIBUTE(field) 					\
 	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, 1)
 
+#define SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(field)				\
+	SETUP_TEMPLATE_PRIVATE_RW(rphy_attrs, field, S_IRUGO | S_IWUSR)
+
 #define SETUP_OPTIONAL_RPORT_ATTRIBUTE(field, func)			\
 	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, i->f->func)
 
@@ -1762,7 +1858,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 
 #define SETUP_PHY_ATTRIBUTE_RW(field)					\
 	SETUP_TEMPLATE_RW(phy_attrs, field, S_IRUGO | S_IWUSR, 1,	\
-			!i->f->set_phy_speed, S_IRUGO)
+			  !i->f->set_phy_speed, S_IRUGO)
 
 #define SETUP_OPTIONAL_PHY_ATTRIBUTE_RW(field, func)			\
 	SETUP_TEMPLATE_RW(phy_attrs, field, S_IRUGO | S_IWUSR, 1,	\
@@ -1836,6 +1932,10 @@ sas_attach_transport(struct sas_function_template *ft)
 	i->f = ft;
 
 	count = 0;
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(host_fast_io_tmo_flags);
+	i->host_attrs[count] = NULL;
+
+	count = 0;
 	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
 	SETUP_PHY_ATTRIBUTE(target_port_protocols);
 	SETUP_PHY_ATTRIBUTE(device_type);
@@ -1867,6 +1967,7 @@ sas_attach_transport(struct sas_function_template *ft)
 	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
 	SETUP_RPORT_ATTRIBUTE(rphy_sas_address);
 	SETUP_RPORT_ATTRIBUTE(rphy_phy_identifier);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(rphy_fast_io_tmo_flags);
 	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_enclosure_identifier,
 				       get_enclosure_identifier);
 	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_bay_identifier,
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 0bd71e2..06e98b8 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -87,8 +87,16 @@ struct sas_rphy {
 	struct list_head	list;
 	struct request_queue	*q;
 	u32			scsi_target_id;
+	u8			fast_io_tmo_flags;
 };
 
+/* bit field values for struct sas_rphy "fast_io_tmo_flags" field: */
+#define SAS_RPHY_IGN_ABORT_CMDS		0x01
+#define SAS_RPHY_IGN_DEVICE_RESET	0x02
+#define SAS_RPHY_IGN_TARGET_RESET	0x04
+#define SAS_RPHY_IGN_BUS_RESET		0x08
+#define SAS_RPHY_IGN_HOST_RESET		0x10
+
 #define dev_to_rphy(d) \
 	container_of((d), struct sas_rphy, dev)
 #define transport_class_to_rphy(dev) \
-- 
1.7.1
