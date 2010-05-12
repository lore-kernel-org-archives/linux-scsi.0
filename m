From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 1/3] fc: Create FC sybsystem
Date: Wed, 12 May 2010 13:20:09 -0700
Message-ID: <20100512202009.27512.304.stgit@localhost.localdomain>
References: <20100512202003.27512.34851.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab0ELUUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 16:20:11 -0400
In-Reply-To: <20100512202003.27512.34851.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, hare@suse.de, christof.schmitt@de.ibm.com, james.bottomley@suse.de

This patch creates a Fibre Channel subsystem. This new FC layer allows different
FC4 types to register with it; it also allows LLDs to register with it. When a
LLD supports one of the FC4s registered, the FC layer allows the FC4 to be
transported over the LLD.

This patch creates files under drivers/fc/ that expose APIs to both the FC4s
and LLDs. The API to the FC4s allow FC4s to register with FC so that they can
be used by LLDs. The API to the LLDs allows the LLDs to add fcports, fcfabrics,
fcvports and fcrports to sysfs and to make use of the registered FC4s.

The patch creates the following FC devices:

fcport: Represents physical port
	Attributes: maxframe_size
		    supported_speeds
		    speed (misplaced?)
		    supported_fc4s
		    active_fc4s (misplaced?)
		    supported_classes
		    serial_number

fcfabric: Represents the FC fabric and switch (FCF for FCoE)
	  Attributes: fabric_name
	  	      max_npiv_vports
		      npiv_vports_inuse
		      vport_create
		      vport_delete

fcvport: Represents either an N_Port or VN_Port
	 Attributes: port_id
	 	     node_name
		     port_name
		     port_type
		     vport_state
		     vport_last_state
		     roles
		     vport_type (duplicate)
		     symbolic_name
		     tgtid_bind_type
		     issue_lip

fcrport: Represents FC remote ports
	 Attributes: fast_io_fail_tmo
	 	     port_id
		     port_state
		     roles
		     node_name
		     port_name
		     supported_classes
		     maxframe_size
		     dev_loss_tmo

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/Kconfig       |    2 
 drivers/Makefile      |    1 
 drivers/fc/Kconfig    |    8 
 drivers/fc/Makefile   |    7 
 drivers/fc/fcfabric.c |  425 ++++++++++++++++++++
 drivers/fc/fcport.c   |  205 ++++++++++
 drivers/fc/fcrport.c  | 1034 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fc/fcsysfs.c  |  180 +++++++++
 drivers/fc/fcsysfs.h  |   76 ++++
 drivers/fc/fcvport.c  |  714 ++++++++++++++++++++++++++++++++++
 include/fc/fc.h       |  843 ++++++++++++++++++++++++++++++++++++++++
 11 files changed, 3495 insertions(+), 0 deletions(-)
 create mode 100644 drivers/fc/Kconfig
 create mode 100644 drivers/fc/Makefile
 create mode 100644 drivers/fc/fcfabric.c
 create mode 100644 drivers/fc/fcport.c
 create mode 100644 drivers/fc/fcrport.c
 create mode 100644 drivers/fc/fcsysfs.c
 create mode 100644 drivers/fc/fcsysfs.h
 create mode 100644 drivers/fc/fcvport.c
 create mode 100644 include/fc/fc.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index a2b902f..6eb6e22 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -28,6 +28,8 @@ source "drivers/md/Kconfig"
 
 source "drivers/message/fusion/Kconfig"
 
+source "drivers/fc/Kconfig"
+
 source "drivers/firewire/Kconfig"
 
 source "drivers/message/i2o/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 34f1e10..bf15da8 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_SPI)		+= spi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
+obj-$(CONFIG_FC)		+= fc/
 obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
diff --git a/drivers/fc/Kconfig b/drivers/fc/Kconfig
new file mode 100644
index 0000000..bcd5444
--- /dev/null
+++ b/drivers/fc/Kconfig
@@ -0,0 +1,8 @@
+menu "Experimental Fibre Channel Support"
+
+config FC
+       tristate "Fibre Channel Support"
+       ---help---
+	 Experimental Fibre Channel Support
+
+endmenu
diff --git a/drivers/fc/Makefile b/drivers/fc/Makefile
new file mode 100644
index 0000000..fa1d60e
--- /dev/null
+++ b/drivers/fc/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_FC) += fc.o
+
+fc-objs := fcsysfs.o \
+	   fcport.o \
+	   fcfabric.o \
+	   fcvport.o \
+	   fcrport.o
diff --git a/drivers/fc/fcfabric.c b/drivers/fc/fcfabric.c
new file mode 100644
index 0000000..2588cf0
--- /dev/null
+++ b/drivers/fc/fcfabric.c
@@ -0,0 +1,425 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fcsysfs.h"
+
+int dev_is_nport(struct device *dev, void *ignored)
+{
+	return fc_fcvport_is_nport(dev_to_fcvport(dev));
+}
+
+#define fc_private_fcfabric_rd_attr(field, format_string, sz)		\
+	fc_always_show_function(fcfabric, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fcfabric_##field, NULL)
+
+#define fcfabric_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_conditional_show_function(fcfabric, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fcfabric_##field, NULL)
+
+fcfabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fc_private_fcfabric_rd_attr(max_npiv_vports, "%u\n", 20);
+fc_private_fcfabric_rd_attr(npiv_vports_inuse, "%u\n", 20);
+
+static atomic_t fcfabric_num;
+
+static int fc_parse_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i=0, j=0; i < 16; i++) {
+		if ((*ns >= 'a') && (*ns <= 'f'))
+			j = ((j << 4) | ((*ns++ -'a') + 10));
+		else if ((*ns >= 'A') && (*ns <= 'F'))
+			j = ((j << 4) | ((*ns++ -'A') + 10));
+		else if ((*ns >= '0') && (*ns <= '9'))
+			j = ((j << 4) | (*ns++ -'0'));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+
+	return 0;
+}
+
+/**
+ * fc_vport_setup - allocates and creates a FC virtual port.
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	Channel on shost port connected to.
+ * @pdev:	parent device for vport
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ * @ret_vport:	The pointer to the created vport.
+ *
+ * Allocates and creates the vport structure, calls the parent host
+ * to instantiate the vport, the completes w/ class and sysfs creation.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+static int fc_vport_setup(struct fc_fcfabric *fcfabric, int channel,
+			  struct fc_vport_identifiers  *ids, struct fc_fcvport **ret_vport)
+{
+	struct fc_fcport *fcport = fcfabric_to_fcport(fcfabric);
+	struct fc_fcvport *fcvport;
+	unsigned long flags;
+
+	*ret_vport = NULL;
+
+	if (!fcfabric->f->vport_create)
+		return -ENOENT;
+
+	fcvport = fc_fcvport_alloc(fcfabric, ids, fcfabric->fcvport_f,
+				   fcfabric->f->dd_fcvport_size, fcport);
+	if (unlikely(!fcvport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+
+	if (fcfabric->npiv_vports_inuse >= fcfabric->max_npiv_vports) {
+		spin_unlock_irqrestore(&fcfabric->lock, flags);
+		kfree(fcvport);
+		return -ENOSPC;
+	}
+
+	fcfabric->npiv_vports_inuse++;
+	fcvport->number = fcfabric->next_vport_number++;
+	list_add_tail(&fcvport->peers, &fcfabric->vports);
+
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	return 0;
+}
+
+/**
+ * fc_vport_create - Admin App or LLDD requests creation of a vport
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	channel on shost port connected to.
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_fcvport *fc_vport_create(struct fc_fcfabric *fcfabric,
+				   int channel, struct fc_vport_identifiers *ids)
+{
+	int stat;
+	struct fc_fcvport *vport;
+
+	stat = fc_vport_setup(fcfabric, channel, ids, &vport);
+
+	return stat ? NULL : vport;
+}
+
+/**
+ * fc_vport_terminate - Admin App or LLDD requests termination of a vport
+ * @vport:	fc_vport to be terminated
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+int fc_vport_terminate(struct fc_fcfabric *fcfabric, struct fc_fcvport *vport)
+{
+	struct fc_fcvport *fcnport;
+	unsigned long flags;
+	int stat = 0;
+
+	spin_lock_irqsave(&vport->lock, flags);
+	if (vport->flags & FC_VPORT_CREATING) {
+		spin_unlock_irqrestore(&vport->lock, flags);
+		return -EBUSY;
+	}
+	if (vport->flags & (FC_VPORT_DEL)) {
+		spin_unlock_irqrestore(&vport->lock, flags);
+		return -EALREADY;
+	}
+	vport->flags |= FC_VPORT_DELETING;
+	spin_unlock_irqrestore(&vport->lock, flags);
+
+	/*
+	 * The fabric needs to be aware of whether the port being
+	 * removed is a VN_Port or an N_Port. The LLD is only
+	 * notified if a VN_Port is being deleted.
+	 */
+	if (fcfabric->f->vport_delete) {
+		fcnport = fc_fcfabric_find_nport(fcfabric);
+		if (fcnport)
+			stat = fcfabric->f->vport_delete(fcvport_priv(fcnport), vport);
+	} else
+		stat = -ENOENT;
+
+	/*
+	 * TODO: This is incorrect.. Which lock is protecting the
+	 * vport->flags? Above it is the vport->lock (which makes
+	 * sense) but here it's the fcfabric->lock!
+	 */
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+	vport->flags &= ~FC_VPORT_DELETING;
+	if (!stat) {
+		vport->flags |= FC_VPORT_DELETED;
+		list_del(&vport->peers);
+		fcfabric->npiv_vports_inuse--;
+	}
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	if (stat)
+		return stat;
+
+	/*
+	 * TODO: What is this stuff? I probably need to do something here.
+
+	if (dev->parent != &shost->shost_gendev)
+		sysfs_remove_link(&shost->shost_gendev.kobj, dev_name(dev));
+	*/
+
+	return 0; /* SUCCESS */
+}
+
+/*
+ * "Short-cut" sysfs variable to create a new vport on a FC Host.
+ * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
+ * will default to a NPIV-based FCP_Initiator; The WWNs are specified
+ * as hex characters, and may *not* contain any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fcfabric_vport_create(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_vport_identifiers vid;
+	struct fc_fcvport *fcvport;
+	unsigned int cnt = count;
+	int stat;
+
+	memset(&vid, 0, sizeof(vid));
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &vid.port_name);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &vid.node_name);
+	if (stat)
+		return stat;
+
+	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	vid.vport_type = FC_PORTTYPE_NPIV;
+	/* vid.symbolic_name is already zero/NULL's */
+	vid.disable = false;		/* always enabled */
+
+	/* we only allow support on Channel 0 !!! */
+	stat = fc_vport_setup(fcfabric, 0, &vid, &fcvport);
+
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcfabric, vport_create, S_IWUSR, NULL,
+		      store_fcfabric_vport_create);
+
+
+/*
+ * "Short-cut" sysfs variable to delete a vport on a FC Host.
+ * Vport is identified by a string containing "<WWPN>:<WWNN>".
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fcfabric_vport_delete(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_fcvport *vport;
+	u64 wwpn, wwnn;
+	unsigned long flags;
+	unsigned int cnt=count;
+	int stat, match;
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &wwpn);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &wwnn);
+	if (stat)
+		return stat;
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+	match = 0;
+	/* we only allow support on Channel 0 !!! */
+	list_for_each_entry(vport, &fcfabric->vports, peers) {
+		if ((vport->channel == 0) &&
+		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
+			match = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	if (!match)
+		return -ENODEV;
+
+	stat = fc_vport_terminate(fcfabric, vport);
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcfabric, vport_delete, S_IWUSR, NULL,
+		      store_fcfabric_vport_delete);
+
+static void fc_fcfabric_release(struct device *dev)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+
+	/*
+	 * TODO: Remove this memset. It's helpful when checking
+	 * reference counting becuase it forces NULL pointer
+	 * exceptions for things that are incorrectly using the
+	 * object that's about to be free'd.
+	 */
+	memset(fcfabric, 0, sizeof(*fcfabric));
+	kfree(fcfabric);
+}
+
+void fc_fcfabric_del(struct fc_fcfabric *fcfabric)
+{
+	device_del(&fcfabric->dev);
+	put_device(fcfabric->dev.parent);
+	put_device(&fcfabric->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_fcfabric_del);
+
+struct class fcfabric_class = {
+	.name = "fcfabric",
+	.dev_release = fc_fcfabric_release,
+};
+EXPORT_SYMBOL(fcfabric_class);
+
+struct fc_fcfabric *fc_fcfabric_add(struct fc_fcport *fcport,
+				    struct fcfabric_function_template *fcn_tmpl,
+				    const u64 name)
+{
+	struct fc_fcfabric *fcfabric;
+	int error = 0;
+	int count = 0, max = 0;
+
+	fcfabric = kzalloc(sizeof(struct fc_fcfabric), GFP_ATOMIC);
+
+	device_initialize(&fcfabric->dev);
+	get_device(&fcfabric->dev); /* For vports list */
+	fcfabric->dev.parent = get_device(&fcport->dev);
+	fcfabric->dev.class = &fcfabric_class;
+	fcfabric->f = fcn_tmpl;
+	fcfabric->id = atomic_inc_return(&fcfabric_num) - 1;
+
+	dev_set_name(&fcfabric->dev, "fcfabric_%d",
+		     fcfabric->id);
+
+	spin_lock_init(&fcfabric->lock);
+	INIT_LIST_HEAD(&fcfabric->vports);
+
+	fcfabric->fabric_name = name;
+	fcfabric->max_npiv_vports = 0;
+	fcfabric->next_vport_number = 0;
+	fcfabric->npiv_vports_inuse = 0;
+
+	error = device_add(&fcfabric->dev);
+	if (error)
+		goto out_del_dev;
+
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcfabric, fabric_name);
+
+	BUG_ON(count > FCFABRIC_NUM_ATTRS);
+	max = count;
+	FC_CREATE_ATTRIBUTES(fcfabric, count, 0);
+
+	fcfabric->attr_count = max;
+
+	if (error || count != 0)
+		goto out_del_dev;
+
+	return fcfabric;
+
+out_del_dev:
+	device_del(&fcfabric->dev);
+	kfree(fcfabric);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcfabric_add);
+
+struct fc_fcvport *fc_fcfabric_find_nport(struct fc_fcfabric *fcfabric)
+{
+	struct device *dev = device_find_child(&fcfabric->dev, NULL, dev_is_nport);
+	if (!dev)
+		return NULL;
+	return dev_to_fcvport(dev);
+}
+EXPORT_SYMBOL(fc_fcfabric_find_nport);
+
+/*
+ * TODO: The way the vport_* attributes are aded to the fcfabric
+ * is a bit odd. However, we don't want the vport_create interface
+ * created before the N_Port is logged in to the fabric.
+ */
+void fc_fcfabric_add_npiv(struct fc_fcfabric *fcfabric)
+{
+	int count = fcfabric->attr_count;
+	int error;
+	int max;
+
+	if (fcfabric->f->vport_create) {
+		FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcfabric, max_npiv_vports);
+		FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcfabric, npiv_vports_inuse);
+		FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcfabric, vport_create);
+	}
+
+	if (fcfabric->f->vport_delete)
+		FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcfabric, vport_delete);
+
+	BUG_ON(count > FCFABRIC_NUM_ATTRS);
+	max = count;
+	FC_CREATE_ATTRIBUTES(fcfabric, count, fcfabric->attr_count);
+
+	fcfabric->attr_count = max;
+}
diff --git a/drivers/fc/fcport.c b/drivers/fc/fcport.c
new file mode 100644
index 0000000..7389ca8
--- /dev/null
+++ b/drivers/fc/fcport.c
@@ -0,0 +1,205 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fcsysfs.h"
+
+static atomic_t fcport_num;
+
+/* Convert FC_PORTSPEED bit values to ascii string name */
+static const struct {
+	u32 			value;
+	char			*name;
+} fc_port_speed_names[] = {
+	{ FC_PORTSPEED_1GBIT,		"1 Gbit" },
+	{ FC_PORTSPEED_2GBIT,		"2 Gbit" },
+	{ FC_PORTSPEED_4GBIT,		"4 Gbit" },
+	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
+	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
+	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
+	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
+};
+fc_bitfield_name_search(port_speed, fc_port_speed_names)
+
+#define fc_fcport_rd_attr(field, format_string, sz)			\
+	fc_always_show_function(fcport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcport, field, S_IRUGO,			\
+			      show_fcport_##field, NULL)
+
+static int show_fc_fc4s(char *buf, u8 *fc4_list)
+{
+	int i, len=0;
+
+	for (i = 0; i < FC_FC4_LIST_SIZE; i++, fc4_list++)
+		len += sprintf(buf + len , "0x%02x ", *fc4_list);
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+
+static ssize_t show_fcport_supported_fc4s(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	return (ssize_t)show_fc_fc4s(buf, fcport_supported_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, supported_fc4s, S_IRUGO,
+		      show_fcport_supported_fc4s, NULL);
+
+static ssize_t show_fcport_active_fc4s (struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	if (fcport->f->get_fcport_active_fc4s)
+		fcport->f->get_fcport_active_fc4s(fcport);
+
+	return (ssize_t)show_fc_fc4s(buf, fcport_active_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, active_fc4s, S_IRUGO,
+		      show_fcport_active_fc4s, NULL);
+
+static ssize_t show_fcport_speed(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+
+	if (fcport->f->get_fcport_speed)
+		fcport->f->get_fcport_speed(fcport);
+
+	if (fcport_speed(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fcport_speed(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, speed, S_IRUGO, show_fcport_speed, NULL);
+
+fc_fcport_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_fcport_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
+
+static ssize_t show_fcport_supported_speeds(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	if (fcport_supported_speeds(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fcport_supported_speeds(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_speeds, S_IRUGO,
+		      show_fcport_supported_speeds, NULL);
+
+static ssize_t show_fcport_supported_classes(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+
+	if (fcport_supported_classes(fcport) == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+
+	return get_fc_cos_names(fcport_supported_classes(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_classes, S_IRUGO,
+		      show_fcport_supported_classes, NULL);
+
+
+static void fc_fcport_release(struct device *dev)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	/*
+	 * TODO: Remove this memset. It's helpful when checking
+	 * reference counting becuase it forces NULL pointer
+	 * exceptions for things that are incorrectly using the
+	 * object that's about to be free'd.
+	 */
+	memset(fcport, 0, sizeof(*fcport));
+	kfree(fcport);
+}
+
+struct class fcport_class = {
+	.name = "fcport",
+	.dev_release = fc_fcport_release,
+};
+EXPORT_SYMBOL(fcport_class);
+
+void fc_fcport_del(struct fc_fcport *fcport)
+{
+	device_del(&fcport->dev);
+	put_device(fcport->dev.parent);
+	put_device(&fcport->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_fcport_del);
+
+struct fc_fcport *fc_fcport_add(struct device *pdev,
+				struct fcport_function_template *fcn_tmpl,
+				void *fc4_f)
+{
+	struct fc_fcport *fcport;
+	int count = 0;
+	int error = 0;
+
+	fcport = kzalloc(sizeof(struct fc_fcport), GFP_KERNEL);
+	if (!fcport)
+		goto out;
+	fcport->id = atomic_inc_return(&fcport_num) - 1;
+	device_initialize(&fcport->dev);
+	fcport->dev.parent = get_device(pdev);
+	fcport->dev.class = &fcport_class;
+	fcport->f = fcn_tmpl;
+	fcport->fc4_f = fc4_f;
+	dev_set_name(&fcport->dev, "fcport_%d", fcport->id);
+
+	error = device_add(&fcport->dev);
+	if (error)
+		goto out_del_dev;
+
+	fcport->maxframe_size = -1;
+	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	fcport->speed = FC_PORTSPEED_UNKNOWN;
+	memset(fcport->supported_fc4s, 0,
+	       sizeof(fcport->supported_fc4s));
+	memset(fcport->active_fc4s, 0,
+	       sizeof(fcport->active_fc4s));
+	memset(fcport->serial_number, 0,
+	       sizeof(fcport->serial_number));
+
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, maxframe_size);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_speeds);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, speed);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_fc4s);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, active_fc4s);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_classes);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, serial_number);
+
+	BUG_ON(count > FCPORT_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(fcport, count, 0);
+
+	if (error || count != 0)
+		goto out_del_dev;
+
+	return fcport;
+
+out_del_dev:
+	device_del(&fcport->dev);
+	kfree(fcport);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcport_add);
diff --git a/drivers/fc/fcrport.c b/drivers/fc/fcrport.c
new file mode 100644
index 0000000..37b7a1d
--- /dev/null
+++ b/drivers/fc/fcrport.c
@@ -0,0 +1,1034 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+
+#include "fcsysfs.h"
+
+/* TODO: This is dup from scsi_priv.h */
+#define FC_DEVICE_BLOCK_MAX_TIMEOUT   600     /* units in seconds */
+
+static void fc_timeout_deleted_rport(struct work_struct *work);
+static void fc_timeout_fail_rport_io(struct work_struct *work);
+
+static void fc_rport_dev_release(struct device *dev)
+{
+	struct fc_rport *rport = dev_to_rport(dev);
+	/*
+	 * TODO: Remove this memset. It's helpful when checking
+	 * reference counting becuase it forces NULL pointer
+	 * exceptions for things that are incorrectly using the
+	 * object that's about to be free'd.
+	 */
+	memset(rport, 0, sizeof(*rport));
+	kfree(rport);
+}
+
+struct class fcrport_class = {
+	.name = "fcrport",
+	.dev_release = fc_rport_dev_release,
+};
+EXPORT_SYMBOL(fcrport_class);
+
+/*
+ * FC Remote Port Attribute Management
+ */
+
+#define fc_rport_show_function(field, format_string, sz, cast)		\
+static ssize_t								\
+show_fc_rport_##field (struct device *dev, 				\
+		       struct device_attribute *attr, char *buf)	\
+{									\
+	struct fc_rport *rport = dev_to_rport(dev);			\
+	if ((rport->f->get_rport_##field) &&				\
+	    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	      (rport->port_state == FC_PORTSTATE_DELETED) ||		\
+	      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))		\
+		rport->f->get_rport_##field(rport);			\
+	return snprintf(buf, sz, format_string, cast rport->field); 	\
+}
+
+
+
+#define fc_rport_store_function(field)					\
+static ssize_t								\
+store_fc_rport_##field(struct device *dev,				\
+		       struct device_attribute *attr,			\
+		       const char *buf,	size_t count)			\
+{									\
+	int val;							\
+	struct fc_rport *rport = dev_to_rport(dev);			\
+	char *cp;							\
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||		\
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))		\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	rport->f->set_rport_##field(rport, val);			\
+	return count;							\
+}
+
+static ssize_t
+show_fc_rport_supported_classes(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = dev_to_rport(dev);
+	if (rport->supported_classes == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+	return get_fc_cos_names(rport->supported_classes, buf);
+}
+static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
+		      show_fc_rport_supported_classes, NULL);
+
+
+fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t
+store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	int val;
+	struct fc_rport *rport = dev_to_rport(dev);
+	char *cp;
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || (val < 0))
+		return -EINVAL;
+
+	/*
+	 * If fast_io_fail is off we have to cap
+	 * dev_loss_tmo at FC_DEVICE_BLOCK_MAX_TIMEOUT
+	 */
+	if (rport->fast_io_fail_tmo == -1 &&
+	    val > FC_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	rport->f->set_rport_dev_loss_tmo(rport, val);
+	return count;
+}
+static FC_DEVICE_ATTR(rport, dev_loss_tmo, S_IRUGO | S_IWUSR,
+		      show_fc_rport_dev_loss_tmo, store_fc_rport_dev_loss_tmo);
+
+static ssize_t
+show_fc_rport_roles(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct fc_rport *rport = dev_to_rport(dev);
+
+	/* identify any roles that are port_id specific */
+	if ((rport->port_id != -1) &&
+	    (rport->port_id & FC_WELLKNOWN_PORTID_MASK) ==
+					FC_WELLKNOWN_PORTID_MASK) {
+		switch (rport->port_id & FC_WELLKNOWN_ROLE_MASK) {
+		case FC_FPORT_PORTID:
+			return snprintf(buf, 30, "Fabric Port\n");
+		case FC_FABCTLR_PORTID:
+			return snprintf(buf, 30, "Fabric Controller\n");
+		case FC_DIRSRVR_PORTID:
+			return snprintf(buf, 30, "Directory Server\n");
+		case FC_TIMESRVR_PORTID:
+			return snprintf(buf, 30, "Time Server\n");
+		case FC_MGMTSRVR_PORTID:
+			return snprintf(buf, 30, "Management Server\n");
+		default:
+			return snprintf(buf, 30, "Unknown Fabric Entity\n");
+		}
+	} else {
+		if (rport->roles == FC_PORT_ROLE_UNKNOWN)
+			return snprintf(buf, 20, "unknown\n");
+		return get_fc_port_roles_names(rport->roles, buf);
+	}
+}
+static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
+		      show_fc_rport_roles, NULL);
+
+
+#define fc_rport_rd_enum_attr(title, maxlen)                    \
+static ssize_t                                                          \
+show_rport_##title(struct device *dev,			\
+		   struct device_attribute *attr, char *buf)		\
+{                                                                       \
+	struct fc_rport *rport = dev_to_rport(dev);			\
+	const char *name;                                               \
+	name = get_fc_##title##_name(rport_##title(rport));		\
+	if (!name)                                                      \
+		return -EINVAL;                                         \
+	return snprintf(buf, maxlen, "%s\n", name);                     \
+}                                                                       \
+static FC_DEVICE_ATTR(rport, title, S_IRUGO,				\
+		      show_rport_##title, NULL)
+
+fc_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+
+/*
+#define rport_store_function(field)					\
+static ssize_t								\
+store_rport_##field(struct device *dev, 				\
+		    struct device_attribute *attr,			\
+		    const char *buf, size_t count)			\
+{									\
+	struct fc_rport *rport = dev_to_rport(dev);		\
+	int val;							\
+	char *cp;							\
+									\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	rport->f->set_rport_##field(rport, val);			\
+	return count;							\
+}
+*/
+
+#define fc_rport_rw_attr(field, format_string, sz)			\
+	fc_always_show_function(rport, field, format_string, sz, )	\
+		rport_store_function(field)				\
+		static FC_DEVICE_ATTR(rport, field, S_IRUGO,		\
+				      show_rport_##field,		\
+				      store_rport_##field)
+
+#define fc_rport_rd_attr(field, format_string, sz)			\
+	fc_always_show_function(rport, field, format_string, sz, )	\
+		static FC_DEVICE_ATTR(rport, field, S_IRUGO,		\
+				      show_rport_##field, NULL)
+
+#define fc_rport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_always_show_function(rport, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
+			      show_rport_##field, NULL)
+
+/* Fixed Remote Port Attributes */
+fc_rport_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_rport_rd_attr(port_id, "0x%06x\n", 20);
+fc_rport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_rport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+
+/*
+ * fast_io_fail_tmo attribute
+*/
+
+static ssize_t
+show_fc_rport_fast_io_fail_tmo(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = dev_to_rport(dev);
+
+	if (rport->fast_io_fail_tmo == -1)
+		return snprintf(buf, 5, "off\n");
+	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
+}
+
+
+static ssize_t
+store_fc_rport_fast_io_fail_tmo(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	int val;
+	char *cp;
+	struct fc_rport *rport = dev_to_rport(dev);
+
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	if (strncmp(buf, "off", 3) == 0)
+		rport->fast_io_fail_tmo = -1;
+	else {
+		val = simple_strtoul(buf, &cp, 0);
+		if ((*cp && (*cp != '\n')) || (val < 0))
+			return -EINVAL;
+		/*
+		 * Cap fast_io_fail by dev_loss_tmo or
+		 * FC_DEVICE_BLOCK_MAX_TIMEOUT.
+		 */
+		if ((val >= rport->dev_loss_tmo) ||
+		    (val > FC_DEVICE_BLOCK_MAX_TIMEOUT))
+			return -EINVAL;
+
+		rport->fast_io_fail_tmo = val;
+	}
+	return count;
+}
+static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
+		      show_fc_rport_fast_io_fail_tmo,
+		      store_fc_rport_fast_io_fail_tmo);
+
+
+/**
+ * fc_rport_final_delete - finish rport termination and delete it.
+ * @work:	remote port to be deleted.
+ */
+static void fc_rport_final_delete(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, rport_delete_work);
+	struct device *dev = &rport->dev;
+	struct fc_fcvport *fcvport = rport_to_fcvport(rport);
+	unsigned long flags;
+	int do_callback = 0;
+
+	/*
+	 * if a scan is pending, flush the SCSI Host work_q so that
+	 * that we can reclaim the rport scan work element.
+	 */
+
+	/*
+	 * TODO: What work is being flushed?
+	 */
+	if (rport->flags & FC_RPORT_SCAN_PENDING)
+		fc4->fc4_init_scsi_flush_work(fcvport);
+
+	fc4->fc4_targ_terminate_io(rport);
+
+	/*
+	 * Cancel any outstanding timers. These should really exist
+	 * only when rmmod'ing the LLDD and we're asking for
+	 * immediate termination of the rports
+	 */
+	spin_lock_irqsave(&fcvport->lock, flags);
+	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(fcvport);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_flush_devloss(fcvport);
+		spin_lock_irqsave(&fcvport->lock, flags);
+		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
+	}
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * Notify the driver that the rport is now dead. The LLDD will
+	 * also guarantee that any communication to the rport is terminated
+	 *
+	 * Avoid this call if we already called it when we preserved the
+	 * rport for the binding.
+	 */
+	spin_lock_irqsave(&fcvport->lock, flags);
+	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
+	    (rport->f->dev_loss_tmo_callbk)) {
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		do_callback = 1;
+	}
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	if (do_callback)
+		rport->f->dev_loss_tmo_callbk(rport);
+
+	/*
+	 * TODO: In what order should the fcptarg be deleted?
+	 * What do the LLDs need to do to cleanup?
+	 */
+	fc4->fc4_targ_del(rport);
+
+	device_del(dev);
+	put_device(dev->parent);
+	put_device(dev);	/* for self-reference */
+}
+
+/**
+ * fc_rport_create - allocates and creates a remote FC port.
+ * @channel:	Channel on the port is connected to.
+ * @ids:	The world wide names, fc address, and FC4 port
+ *		roles for the remote port.
+ *
+ * Allocates and creates the remoter port structure, including the
+ * class and sysfs creation.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+static struct fc_rport *
+fc_rport_create(struct fc_fcvport *fcvport,
+		struct fcrport_function_template *f,
+		int channel, struct fc_rport_identifiers *ids)
+{
+	struct fc_rport *rport;
+	struct device *dev;
+	unsigned long flags;
+	int error = 0;
+	int count = 0;
+	size_t size;
+
+	size = (sizeof(struct fc_rport) + f->dd_fcrport_size);
+	rport = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!rport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		return NULL;
+	}
+
+	rport->f = f;
+
+	rport->maxframe_size = -1;
+	rport->supported_classes = FC_COS_UNSPECIFIED;
+	rport->dev_loss_tmo = fc_dev_loss_tmo;
+	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
+	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
+	rport->port_id = ids->port_id;
+	rport->roles = ids->roles;
+	rport->port_state = FC_PORTSTATE_ONLINE;
+	if (f->dd_fcrport_size)
+		rport->dd_data = &rport[1];
+	rport->channel = channel;
+	rport->fast_io_fail_tmo = -1;
+
+	INIT_DELAYED_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport);
+	INIT_DELAYED_WORK(&rport->fail_io_work, fc_timeout_fail_rport_io);
+	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete);
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	rport->number = fcvport->next_rport_number++;
+
+	dev = &rport->dev;
+	device_initialize(dev); /* takes self reference */
+	dev->parent = get_device(&fcvport->dev); /* parent reference */
+	dev->class = &fcrport_class;
+	dev_set_name(dev, "rport-%d:%d-%d",
+		     fcvport->id, channel, rport->number);
+	error = device_add(dev);
+	if (error) {
+		printk(KERN_ERR "FC Remote Port device_add failed\n");
+		goto delete_rport;
+	}
+
+	/*
+	 * TODO: Should return something and check it here.
+	 */
+	/*
+	 * Called withing fcvport lock so that the FC4 layer can
+	 * check the rport role without worrying about it changing.
+	 */
+	fc4->fc4_targ_add(rport, fcvport, channel);
+
+	list_add_tail(&rport->peers, &fcvport->rports);
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * Setup attributes
+	 */
+	/* Should this be _NS? Does that mean No Store */
+	FC_SETUP_ALWAYS_ATTRIBUTE_RW(rport, fast_io_fail_tmo);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, port_id);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, port_state);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, roles);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, node_name);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, port_name);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, supported_classes);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(rport, maxframe_size);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RW(rport, dev_loss_tmo);
+
+	BUG_ON(count > FCRPORT_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(rport, count, 0);
+	if (error || count != 0) {
+		/*
+		 * TODO: Clean up if there is an error
+		 */
+		return NULL;
+	}
+
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
+		/* initiate a scan of the target */
+		rport->flags |= FC_RPORT_SCAN_PENDING;
+		fc4->fc4_targ_queue_scan(rport);
+	}
+
+	return rport;
+
+delete_rport:
+	spin_lock_irqsave(&fcvport->lock, flags);
+	list_del(&rport->peers);
+	put_device(&fcvport->dev);	/* for fcvport->rport list */
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+	put_device(dev->parent);
+
+	kfree(rport);
+	return NULL;
+}
+
+/**
+ * fc_fcrport_add - notify fc transport of the existence of a remote FC port.
+ * @channel:	Channel on port connected to.
+ * @ids:	The world wide names, fc address, and FC4 port
+ *		roles for the remote port.
+ *
+ * The LLDD calls this routine to notify the transport of the existence
+ * of a remote port. The LLDD provides the unique identifiers (wwpn,wwn)
+ * of the port, it's FC address (port_id), and the FC4 roles that are
+ * active for the port.
+ *
+ * For ports that are FCP targets (aka scsi targets), the FC transport
+ * maintains consistent target id bindings on behalf of the LLDD.
+ * A consistent target id binding is an assignment of a target id to
+ * a remote port identifier, which persists while the scsi host is
+ * attached. The remote port can disappear, then later reappear, and
+ * it's target id assignment remains the same. This allows for shifts
+ * in FC addressing (if binding by wwpn or wwnn) with no apparent
+ * changes to the scsi subsystem which is based on scsi host number and
+ * target id values.  Bindings are only valid during the attachment of
+ * the scsi host. If the host detaches, then later re-attaches, target
+ * id bindings may change.
+ *
+ * This routine is responsible for returning a remote port structure.
+ * The routine will search the list of remote ports it maintains
+ * internally on behalf of consistent target id mappings. If found, the
+ * remote port structure will be reused. Otherwise, a new remote port
+ * structure will be allocated.
+ *
+ * Whenever a remote port is allocated, a new fc_remote_port class
+ * device is created.
+ *
+ * Should not be called from interrupt context.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_rport *fc_fcrport_add(struct fc_fcvport *fcvport,
+				struct fcrport_function_template *f,
+				int channel,
+				struct fc_rport_identifiers *ids)
+{
+	struct fc_rport *rport;
+	unsigned long flags;
+	int match = 0;
+
+	/* ensure any stgt delete functions are done */
+	fc_flush_work(fcvport);
+
+	/*
+	 * Search the list of "active" rports, for an rport that has been
+	 * deleted, but we've held off the real delete while the target
+	 * is in a "blocked" state.
+	 */
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	list_for_each_entry(rport, &fcvport->rports, peers) {
+
+		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
+			(rport->channel == channel)) {
+
+			switch (fcvport->tgtid_bind_type) {
+			case FC_TGTID_BIND_BY_WWPN:
+			case FC_TGTID_BIND_NONE:
+				if (rport->port_name == ids->port_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_WWNN:
+				if (rport->node_name == ids->node_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_ID:
+				if (rport->port_id == ids->port_id)
+					match = 1;
+				break;
+			}
+
+			if (match) {
+
+				memcpy(&rport->node_name, &ids->node_name,
+					sizeof(rport->node_name));
+				memcpy(&rport->port_name, &ids->port_name,
+					sizeof(rport->port_name));
+				rport->port_id = ids->port_id;
+
+				rport->port_state = FC_PORTSTATE_ONLINE;
+				rport->roles = ids->roles;
+
+				spin_unlock_irqrestore(&fcvport->lock, flags);
+
+				if (f->dd_fcrport_size)
+					memset(rport->dd_data, 0,
+					       f->dd_fcrport_size);
+
+				/*
+				 * If we were not a target, cancel the
+				 * io terminate and rport timers, and
+				 * we're done.
+				 *
+				 * If we were a target, but our new role
+				 * doesn't indicate a target, leave the
+				 * timers running expecting the role to
+				 * change as the target fully logs in. If
+				 * it doesn't, the target will be torn down.
+				 *
+				 * If we were a target, and our role shows
+				 * we're still a target, cancel the timers
+				 * and kick off a scan.
+				 */
+
+				/* was a target, not in roles */
+				/*
+				 * TODO: This was previously checking the
+				 * scsi_target_id, which was just checking
+				 * to see if the rport had been initialized
+				 * as a TARGET or not. It also indicated that
+				 * the target had been scanned.
+				 *
+				 * Now we're just checking to see if the FC4
+				 * has been initialized or not. That should be
+				 * the same check.
+				 */
+				if ((!rport->fc4_priv) &&
+				    (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)))
+					return rport;
+
+				/*
+				 * Stop the fail io and dev_loss timers.
+				 * If they flush, the port_state will
+				 * be checked and will NOOP the function.
+				 */
+				if (!cancel_delayed_work(&rport->fail_io_work))
+					fc_flush_devloss(fcvport);
+				if (!cancel_delayed_work(&rport->dev_loss_work))
+					fc_flush_devloss(fcvport);
+
+				spin_lock_irqsave(&fcvport->lock, flags);
+
+				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+						  FC_RPORT_DEVLOSS_PENDING |
+						  FC_RPORT_DEVLOSS_CALLBK_DONE);
+
+				/*
+				 * TODO: All this SCSI-ml stuff needs to go into
+				 * scsi_transport_fcp.c
+				 */
+
+				/* if target, initiate a scan */
+				if (rport->fc4_priv) {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					fc4->fc4_targ_queue_scan(rport);
+					spin_unlock_irqrestore(&fcvport->lock,
+							       flags);
+
+					fc4->fc4_targ_unblock(rport);
+				} else
+					spin_unlock_irqrestore(&fcvport->lock,
+							       flags);
+
+				fc4->fc4_bsg_goose_queue(rport);
+
+				return rport;
+			}
+		}
+	}
+
+	/*
+	 * Search the bindings array
+	 * Note: if never a FCP target, you won't be on this list
+	 */
+	if (fcvport->tgtid_bind_type != FC_TGTID_BIND_NONE) {
+
+		/* search for a matching consistent binding */
+
+		list_for_each_entry(rport, &fcvport->rport_bindings,
+				    peers) {
+			if (rport->channel != channel)
+				continue;
+
+			switch (fcvport->tgtid_bind_type) {
+			case FC_TGTID_BIND_BY_WWPN:
+				if (rport->port_name == ids->port_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_WWNN:
+				if (rport->node_name == ids->node_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_ID:
+				if (rport->port_id == ids->port_id)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_NONE: /* to keep compiler happy */
+				break;
+			}
+
+			if (match) {
+				list_move_tail(&rport->peers, &fcvport->rports);
+				break;
+			}
+		}
+
+		if (match) {
+			memcpy(&rport->node_name, &ids->node_name,
+				sizeof(rport->node_name));
+			memcpy(&rport->port_name, &ids->port_name,
+				sizeof(rport->port_name));
+			rport->port_id = ids->port_id;
+			rport->roles = ids->roles;
+			rport->port_state = FC_PORTSTATE_ONLINE;
+			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
+
+			if (f->dd_fcrport_size)
+				memset(rport->dd_data, 0,
+				       f->dd_fcrport_size);
+
+			if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
+				/* initiate a scan of the target */
+				rport->flags |= FC_RPORT_SCAN_PENDING;
+				fc4->fc4_targ_queue_scan(rport);
+
+				spin_unlock_irqrestore(&fcvport->lock, flags);
+				fc4->fc4_targ_unblock(rport);
+			} else
+				spin_unlock_irqrestore(&fcvport->lock, flags);
+
+			return rport;
+		}
+	}
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/* No consistent binding found - create new remote port entry */
+	rport = fc_rport_create(fcvport, f, channel, ids);
+
+	return rport;
+}
+EXPORT_SYMBOL(fc_fcrport_add);
+
+
+/**
+ * fc_fcrport_del - notifies the fc transport that a remote port is no longer in existence.
+ * @rport:	The remote port that no longer exists
+ *
+ * The LLDD calls this routine to notify the transport that a remote
+ * port is no longer part of the topology. Note: Although a port
+ * may no longer be part of the topology, it may persist in the remote
+ * ports displayed by the fcpinit. We do this under 2 conditions:
+ * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
+ *   This allows the port to temporarily disappear, then reappear without
+ *   disrupting the SCSI device tree attached to it. During the "blocked"
+ *   period the port will still exist.
+ * 2) If the port was a scsi target and disappears for longer than we
+ *   expect, we'll delete the port and the tear down the SCSI device tree
+ *   attached to it. However, we want to semi-persist the target id assigned
+ *   to that port if it eventually does exist. The port structure will
+ *   remain (although with minimal information) so that the target id
+ *   bindings remails.
+ *
+ * If the remote port is not an FCP Target, it will be fully torn down
+ * and deallocated, including the fc_remote_port class device.
+ *
+ * If the remote port is an FCP Target, the port will be placed in a
+ * temporary blocked state. From the LLDD's perspective, the rport no
+ * longer exists. From the SCSI midlayer's perspective, the SCSI target
+ * exists, but all sdevs on it are blocked from further I/O. The following
+ * is then expected.
+ *
+ *   If the remote port does not return (signaled by a LLDD call to
+ *   fc_fcrport_add()) within the dev_loss_tmo timeout, then the
+ *   scsi target is removed - killing all outstanding i/o and removing the
+ *   scsi devices attached ot it. The port structure will be marked Not
+ *   Present and be partially cleared, leaving only enough information to
+ *   recognize the remote port relative to the scsi target id binding if
+ *   it later appears.  The port will remain as long as there is a valid
+ *   binding (e.g. until the user changes the binding type or unloads the
+ *   scsi host with the binding).
+ *
+ *   If the remote port returns within the dev_loss_tmo value (and matches
+ *   according to the target id binding type), the port structure will be
+ *   reused. If it is no longer a SCSI target, the target will be torn
+ *   down. If it continues to be a SCSI target, then the target will be
+ *   unblocked (allowing i/o to be resumed), and a scan will be activated
+ *   to ensure that all luns are detected.
+ *
+ * Called from normal process context only - cannot be called from interrupt.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void fc_fcrport_del(struct fc_rport *rport)
+{
+	struct fc_fcvport *fcvport = rport_to_fcvport(rport);
+	int timeout = rport->dev_loss_tmo;
+	unsigned long flags;
+
+	/*
+	 * No need to flush the fcpinit work_q's, as all adds are synchronous.
+	 *
+	 * We do need to reclaim the rport scan work element, so eventually
+	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
+	 * there's still a scan pending.
+	 */
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		return;
+	}
+
+	/*
+	 * In the past, we if this was not an FCP-Target, we would
+	 * unconditionally just jump to deleting the rport.
+	 * However, rports can be used as node containers by the LLDD,
+	 * and its not appropriate to just terminate the rport at the
+	 * first sign of a loss in connectivity. The LLDD may want to
+	 * send ELS traffic to re-validate the login. If the rport is
+	 * immediately deleted, it makes it inappropriate for a node
+	 * container.
+	 * So... we now unconditionally wait dev_loss_tmo before
+	 * destroying an rport.
+	 */
+
+	rport->port_state = FC_PORTSTATE_BLOCKED;
+
+	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	fc4->fc4_targ_final_delete(rport);
+
+	fc4->fc4_targ_block(rport);
+
+	/* see if we need to kill io faster than waiting for device loss */
+	if ((rport->fast_io_fail_tmo != -1) &&
+	    (rport->fast_io_fail_tmo < timeout))
+		fc_queue_devloss_work(fcvport, &rport->fail_io_work,
+				      rport->fast_io_fail_tmo * HZ);
+
+	/* cap the length the devices can be blocked until they are deleted */
+	fc_queue_devloss_work(fcvport, &rport->dev_loss_work, timeout * HZ);
+}
+EXPORT_SYMBOL(fc_fcrport_del);
+
+/**
+ * fc_fcrport_rolechg - notifies the fc transport that the roles on a remote may have changed.
+ * @rport:	The remote port that changed.
+ * @roles:      New roles for this port.
+ *
+ * Description: The LLDD calls this routine to notify the transport that the
+ * roles on a remote port may have changed. The largest effect of this is
+ * if a port now becomes a FCP Target, it must be allocated a
+ * scsi target id.  If the port is no longer a FCP target, any
+ * scsi target id value assigned to it will persist in case the
+ * role changes back to include FCP Target. No changes in the scsi
+ * midlayer will be invoked if the role changes (in the expectation
+ * that the role will be resumed. If it doesn't normal error processing
+ * will take place).
+ *
+ * Should not be called from interrupt context.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void fc_fcrport_rolechg(struct fc_rport *rport, u32 roles)
+{
+	struct fc_fcvport *fcvport = rport_to_fcvport(rport);
+	unsigned long flags;
+	int create = 0;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	create = fc4->fc4_targ_rolechg(rport, roles);
+	rport->roles = roles;
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	if (create) {
+		/*
+		 * There may have been a delete timer running on the
+		 * port. Ensure that it is cancelled as we now know
+		 * the port is an FCP Target.
+		 * Note: we know the rport is exists and in an online
+		 *  state as the LLDD would not have had an rport
+		 *  reference to pass us.
+		 *
+		 * Take no action on the del_timer failure as the state
+		 * machine state change will validate the
+		 * transaction.
+		 */
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(fcvport);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_flush_devloss(fcvport);
+
+		spin_lock_irqsave(&fcvport->lock, flags);
+		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+				  FC_RPORT_DEVLOSS_PENDING);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+
+		/* ensure any stgt delete functions are done */
+		fc_flush_work(fcvport);
+
+		/* initiate a scan of the target */
+		spin_lock_irqsave(&fcvport->lock, flags);
+		rport->flags |= FC_RPORT_SCAN_PENDING;
+		fc4->fc4_targ_queue_scan(rport);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		fc4->fc4_targ_unblock(rport);
+	}
+}
+EXPORT_SYMBOL(fc_fcrport_rolechg);
+
+/**
+ * fc_timeout_deleted_rport - Timeout handler for a deleted remote port.
+ * @work:	rport target that failed to reappear in the allotted time.
+ *
+ * Description: An attempt to delete a remote port blocks, and if it fails
+ *              to return in the allotted time this gets called.
+ */
+static void fc_timeout_deleted_rport(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, dev_loss_work.work);
+	struct fc_fcvport *fcvport = rport_to_fcvport(rport);
+	unsigned long flags;
+	int do_callback = 0;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
+
+	/*
+	 * If the port is ONLINE, then it came back. If it was a SCSI
+	 * target, validate it still is. If not, tear down the
+	 * scsi_target on it.
+	 */
+	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: no longer"
+			" a FCP target, removing starget\n");
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		fc4->fc4_targ_unblock(rport);
+		fc4->fc4_queue_starget_delete(rport);
+		return;
+	}
+
+	/* NOOP state - we're flushing workq's */
+	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		dev_printk(KERN_ERR, &rport->dev,
+			   "blocked FC remote port time out: leaving"
+			   " rport%s alone\n",
+			   (rport->fc4_priv) ?  " and starget" : "");
+		return;
+	}
+
+	if ((fcvport->tgtid_bind_type == FC_TGTID_BIND_NONE) ||
+	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
+		list_del(&rport->peers);
+		rport->port_state = FC_PORTSTATE_DELETED;
+		dev_printk(KERN_ERR, &rport->dev,
+			   "blocked FC remote port time out: removing"
+			   " rport%s\n",
+			   (rport->fc4_priv) ?  " and starget" : "");
+		fc_queue_work(fcvport, &rport->rport_delete_work);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		return;
+	}
+
+	dev_printk(KERN_ERR, &rport->dev,
+		"blocked FC remote port time out: removing target and "
+		"saving binding\n");
+
+	list_move_tail(&rport->peers, &fcvport->rport_bindings);
+
+	/*
+	 * Note: We do not remove or clear the hostdata area. This allows
+	 *   host-specific target data to persist along with the
+	 *   scsi_target_id. It's up to the host to manage it's hostdata area.
+	 */
+
+	/*
+	 * Reinitialize port attributes that may change if the port comes back.
+	 */
+	rport->maxframe_size = -1;
+	rport->supported_classes = FC_COS_UNSPECIFIED;
+	rport->roles = FC_PORT_ROLE_UNKNOWN;
+	rport->port_state = FC_PORTSTATE_NOTPRESENT;
+	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
+
+	/*
+	 * Pre-emptively kill I/O rather than waiting for the work queue
+	 * item to teardown the starget. (FCOE libFC folks prefer this
+	 * and to have the rport_port_id still set when it's done).
+	 */
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+	fc4->fc4_targ_terminate_io(rport);
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */
+
+		/* remove the identifiers that aren't used in the consisting binding */
+		switch (fcvport->tgtid_bind_type) {
+		case FC_TGTID_BIND_BY_WWPN:
+			rport->node_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_WWNN:
+			rport->port_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_ID:
+			rport->node_name = -1;
+			rport->port_name = -1;
+			break;
+		case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
+			break;
+		}
+
+		/*
+		 * As this only occurs if the remote port (scsi target)
+		 * went away and didn't come back - we'll remove
+		 * all attached scsi devices.
+		 */
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		fc4->fc4_queue_starget_delete(rport);
+
+		do_callback = 1;
+	}
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * Notify the driver that the rport is now dead. The LLDD will
+	 * also guarantee that any communication to the rport is terminated
+	 *
+	 * Note: we set the CALLBK_DONE flag above to correspond
+	 */
+	if (do_callback && rport->f->dev_loss_tmo_callbk)
+		rport->f->dev_loss_tmo_callbk(rport);
+}
+
+
+/**
+ * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a disconnected SCSI target.
+ * @work:	rport to terminate io on.
+ *
+ * Notes: Only requests the failure of the io, not that all are flushed
+ *    prior to returning.
+ */
+static void
+fc_timeout_fail_rport_io(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, fail_io_work.work);
+
+	if (rport->port_state != FC_PORTSTATE_BLOCKED)
+		return;
+
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
+	fc4->fc4_targ_terminate_io(rport);
+}
diff --git a/drivers/fc/fcsysfs.c b/drivers/fc/fcsysfs.c
new file mode 100644
index 0000000..fd751a2
--- /dev/null
+++ b/drivers/fc/fcsysfs.c
@@ -0,0 +1,180 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fcsysfs.h"
+
+
+/*
+ * Original Author:  Martin Hicks
+ * Revised by:       James Smart
+*/
+MODULE_AUTHOR("Robert Love");
+MODULE_DESCRIPTION("Fibre Channel");
+MODULE_LICENSE("GPL");
+
+/*
+ * dev_loss_tmo: the default number of seconds that the FC transport
+ *   should insulate the loss of a remote port.
+ *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
+ */
+unsigned int fc_dev_loss_tmo = 60;		/* seconds */
+module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dev_loss_tmo,
+		 "Maximum number of seconds that the FC transport should"
+		 " insulate the loss of a remote port. Once this value is"
+		 " exceeded, the scsi target is removed. Value should be"
+		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
+		 " fast_io_fail_tmo is not set.");
+
+/*
+ * Netlink Infrastructure
+ */
+
+static atomic_t fc_event_seq;
+
+/**
+ * fc_get_event_number - Obtain the next sequential FC event number
+ *
+ * Notes:
+ *   We could have inlined this, but it would have required fc_event_seq to
+ *   be exposed. For now, live with the subroutine call.
+ *   Atomic used to avoid lock/unlock...
+ */
+u32 fc_get_event_number(void)
+{
+	return atomic_add_return(1, &fc_event_seq);
+}
+//EXPORT_SYMBOL(fc_get_event_number);
+
+/* Private Host Attributes */
+
+static int __init fc_init(void)
+{
+	int error;
+
+	error = class_register(&fcport_class);
+	if (error)
+		return error;
+
+	error = class_register(&fcfabric_class);
+	if (error)
+		goto unreg_fcport;
+
+	error = class_register(&fcvport_class);
+	if (error)
+		goto unreg_fcfabric;
+
+	error = class_register(&fcrport_class);
+	if (error)
+		goto unreg_fcvport;
+
+	return 0;
+
+unreg_fcvport:
+	class_unregister(&fcvport_class);
+unreg_fcfabric:
+	class_unregister(&fcfabric_class);
+unreg_fcport:
+	class_unregister(&fcport_class);
+	return error;
+}
+module_init(fc_init);
+
+static void __exit fc_exit(void)
+{
+	class_unregister(&fcrport_class);
+	class_unregister(&fcvport_class);
+	class_unregister(&fcfabric_class);
+	class_unregister(&fcport_class);
+}
+module_exit(fc_exit);
+
+struct _fc_port_types fc_port_type_names[] = {
+	{ FC_PORTTYPE_UNKNOWN,		"Unknown" },
+	{ FC_PORTTYPE_OTHER,		"Other" },
+	{ FC_PORTTYPE_NOTPRESENT,	"Not Present" },
+	{ FC_PORTTYPE_NPORT,	"NPort (fabric via point-to-point)" },
+	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
+	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
+	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection)" },
+	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
+};
+/* Convert fc_port_type values to ascii string name */
+fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
+EXPORT_SYMBOL(get_fc_port_type_name);
+fc_enum_name_search(vport_type, fc_port_type, fc_port_type_names)
+EXPORT_SYMBOL(get_fc_vport_type_name);
+
+struct _fc_port_role_names  fc_port_role_names[] = {
+	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
+	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
+	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
+};
+/* Convert FC_PORT_ROLE bit values to ascii string name */
+fc_bitfield_name_search(port_roles, fc_port_role_names)
+EXPORT_SYMBOL(get_fc_port_roles_names);
+
+struct _fc_cos_names fc_cos_names[] = {
+	{ FC_COS_CLASS1,	"Class 1" },
+	{ FC_COS_CLASS2,	"Class 2" },
+	{ FC_COS_CLASS3,	"Class 3" },
+	{ FC_COS_CLASS4,	"Class 4" },
+	{ FC_COS_CLASS6,	"Class 6" },
+};
+
+/* Convert FC_COS bit values to ascii string name */
+fc_bitfield_name_search(cos, fc_cos_names)
+EXPORT_SYMBOL(get_fc_cos_names);
+
+/* Reuse fc_port_type enum function for vport_type */
+//#define get_fc_vport_type_name get_fc_port_type_name
+
+
+/* Convert fc_port_state values to ascii string name */
+static struct {
+	enum fc_port_state	value;
+	char			*name;
+} fc_port_state_names[] = {
+	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
+	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
+	{ FC_PORTSTATE_ONLINE,		"Online" },
+	{ FC_PORTSTATE_OFFLINE,		"Offline" },
+	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
+	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
+	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
+	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
+	{ FC_PORTSTATE_ERROR,		"Error" },
+	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
+	{ FC_PORTSTATE_DELETED,		"Deleted" },
+};
+fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
+EXPORT_SYMBOL(get_fc_port_state_name);
+
+struct fc4_template *fc4;
+
+int register_fc4(struct fc4_template *tmpl)
+{
+	fc4 = tmpl;
+	return 0;
+}
+EXPORT_SYMBOL(register_fc4);
+
+void unregister_fc4()
+{
+	fc4 = NULL;
+}
+EXPORT_SYMBOL(unregister_fc4);
diff --git a/drivers/fc/fcsysfs.h b/drivers/fc/fcsysfs.h
new file mode 100644
index 0000000..2df0f9a
--- /dev/null
+++ b/drivers/fc/fcsysfs.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _FC_SYSFS_H_
+#define _FC_SYSFS_H_
+
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <fc/fc.h>
+
+#define fc_bitfield_name_search(title, table)			\
+ssize_t get_fc_##title##_names(u32 table_key, char *buf)	\
+{								\
+	char *prefix = "";					\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value & table_key) {		\
+			len += sprintf(buf + len, "%s%s",	\
+				prefix, table[i].name);		\
+			prefix = ", ";				\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+/*
+ * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
+ */
+#define FC_WELLKNOWN_PORTID_MASK	0xfffff0
+#define FC_WELLKNOWN_ROLE_MASK  	0x00000f
+#define FC_FPORT_PORTID			0x00000e
+#define FC_FABCTLR_PORTID		0x00000d
+#define FC_DIRSRVR_PORTID		0x00000c
+#define FC_TIMESRVR_PORTID		0x00000b
+#define FC_MGMTSRVR_PORTID		0x00000a
+
+extern struct class fcport_class;
+extern struct class fcfabric_class;
+extern struct class fcvport_class;
+extern struct class fcrport_class;
+
+extern unsigned int fc_dev_loss_tmo;
+
+extern struct fc4_template *fc4;
+
+int fc_vport_terminate(struct fc_fcfabric *, struct fc_fcvport *vport);
+void fc_flush_devloss(struct fc_fcvport *fcvport);
+int fc_queue_devloss_work(struct fc_fcvport *fcvport, struct delayed_work *work,
+			  unsigned long delay);
+
+#define FC_PORTTYPE_MAX_NAMELEN		50
+const char *get_fc_port_type_name(enum fc_port_type table_key);
+const char *get_fc_vport_type_name(enum fc_port_type table_key);
+ssize_t get_fc_port_roles_names(u32 table_key, char *buf);
+ssize_t get_fc_cos_names(u32 table_key, char *buf);
+
+void fc_fcfabric_add_npiv(struct fc_fcfabric *fcfabric);
+
+#endif /*_FC_SYSFS_H_*/
diff --git a/drivers/fc/fcvport.c b/drivers/fc/fcvport.c
new file mode 100644
index 0000000..2079b5e
--- /dev/null
+++ b/drivers/fc/fcvport.c
@@ -0,0 +1,714 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fcsysfs.h"
+
+static atomic_t fcvport_num;
+
+static void fc_vport_sched_delete(struct work_struct *work);
+
+#define fcvport_rd_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_private_fcvport_rd_attr(field, format_string, sz)		\
+	fc_always_show_function(fcvport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_private_fcvport_rd_attr_cast(field, format_string, sz, cast)	\
+	fc_always_show_function(fcvport, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+/* Convert fc_vport_state values to ascii string name */
+static struct {
+	enum fc_vport_state	value;
+	char			*name;
+} fc_vport_state_names[] = {
+	{ FC_VPORT_UNKNOWN,		"Unknown" },
+	{ FC_VPORT_ACTIVE,		"Active" },
+	{ FC_VPORT_DISABLED,		"Disabled" },
+	{ FC_VPORT_LINKDOWN,		"Linkdown" },
+	{ FC_VPORT_INITIALIZING,	"Initializing" },
+	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
+	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
+	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
+	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
+	{ FC_VPORT_FAILED,		"VPort Failed" },
+};
+fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
+#define FC_VPORTSTATE_MAX_NAMELEN	24
+
+/* Reuse fc_vport_state enum function for vport_last_state */
+#define get_fc_vport_last_state_name get_fc_vport_state_name
+
+/*
+ * TODO: Notce that we're still using get_fc_##title##_name and not
+ * a get_fcvport_##title##_name routine. The port_type structure,
+ * related lookups and names need to be somewhere global for rports
+ * and other fc_host obects.
+ */
+#define fcvport_rd_enum_attr(title, maxlen)				\
+	static ssize_t show_fcvport_##title (struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	const char *name;						\
+	if (fcvport->f->get_fcvport_##title)				\
+		fcvport->f->get_fcvport_##title(fcvport);		\
+	name = get_fc_##title##_name(fcvport_##title(fcvport));		\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+static FC_DEVICE_ATTR(fcvport, title, S_IRUGO, show_fcvport_##title, NULL)
+
+#define fcvport_store_function(field)					\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	int val;							\
+	struct fc_vport *vport = dev_to_vport(dev);			\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))		\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	vport->f->set_vport_##field(vport, val);			\
+	return count;							\
+}
+
+#define fcvport_store_str_function(field, slen)				\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	unsigned int cnt = count;					\
+									\
+	/* count may include a LF at end of string */			\
+	if (buf[cnt-1] == '\n')						\
+		cnt--;							\
+	if (cnt > ((slen) - 1))						\
+		return -EINVAL;						\
+	memcpy(fcvport->field, buf, cnt);				\
+	fcvport->f->set_fcvport_##field(fcvport);			\
+	return count;							\
+}
+
+#define fcvport_rd_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fcvport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_conditional_show_function(fcvport, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_vport_rw_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	fcvport_store_function(field)					\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO | S_IWUSR,	\
+			      show_fcvport_##field,			\
+			      store_fcvport_##field)
+
+#define fc_private_fcvport_store_u32_function(field)			\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	u32 val;							\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	char *cp;							\
+	if (fcvport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	fcvport->field = val;						\
+	return count;							\
+}
+
+
+#define fc_private_fcvport_rw_u32_attr(field, format_string, sz)	\
+	fc_always_show_function(fcvport, field, format_string, sz, )	\
+	fc_private_fcvport_store_u32_function(field)			\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO | S_IWUSR,	\
+			      show_fcvport_##field,			\
+			      store_fcvport_##field)
+
+
+#define fc_private_fcvport_rd_enum_attr(title, maxlen)			\
+	static ssize_t show_fcvport_##title (struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	const char *name;						\
+	name = get_fc_##title##_name(fcvport->title);			\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+	static FC_DEVICE_ATTR(fcvport, title, S_IRUGO,			\
+			      show_fcvport_##title, NULL)
+
+/*
+ * TODO: I'm not sure how this macro is supposed to work. Why would there
+ * be a "field" in the function template? It's for vport_delete and
+ * vport_destroy, but I don't get it!
+ */
+#define SETUP_FCVPORT_ATTRIBUTE_WR(field)				\
+	if (fcvport->f->field) {					\
+		fcvport->attrs[count] = device_attr_fcvport_##field;	\
+		device_create_file(&fcvport->dev, &fcvport->attrs[count]); \
+		count++;						\
+	}
+	/* NOTE: Above MACRO differs: checks function */
+
+#define SETUP_FCVPORT_ATTRIBUTE_RW(field)				\
+	if (!fcvport->f->set_fcvport_##field) {				\
+		fcvport->attrs[count] = device_attr_fcvport_##field;	\
+		fcvport->attrs[count].attr.mode = S_IRUGO;		\
+		fcvport->attrs[count].store = NULL;			\
+		count++;						\
+	}
+	/* NOTE: Above MACRO differs: does not check show bit */
+
+#define SETUP_PRIVATE_FCVPORT_ATTRIBUTE_RW(field)			\
+{									\
+	fcvport->attrs[count] = device_attr_fcvport_##field;		\
+	count++;							\
+}
+
+
+/* The FC Transport Virtual Port Attributes: */
+
+/* Fixed Virtual Port Attributes */
+
+/* Dynamic Virtual Port Attributes */
+
+/* Private Virtual Port Attributes */
+
+fc_private_fcvport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_fcvport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_fcvport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_private_fcvport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+static ssize_t show_fcvport_roles(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+
+	if (fcvport->roles == FC_PORT_ROLE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	return get_fc_port_roles_names(fcvport->roles, buf);
+}
+static FC_DEVICE_ATTR(fcvport, roles, S_IRUGO, show_fcvport_roles, NULL);
+
+fc_private_fcvport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);
+
+fc_always_show_function(fcvport, symbolic_name, "%s\n",
+			FC_VPORT_SYMBOLIC_NAMELEN + 1, )
+fcvport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
+static FC_DEVICE_ATTR(fcvport, symbolic_name, S_IRUGO | S_IWUSR,
+		      show_fcvport_symbolic_name, store_fcvport_symbolic_name);
+
+static ssize_t store_fcvport_issue_lip(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	int ret;
+
+	/* ignore any data value written to the attribute */
+	if (fcvport->f->issue_fcvport_lip) {
+		ret = fcvport->f->issue_fcvport_lip(fcvport);
+		return ret ? ret: count;
+	}
+
+	return -ENOENT;
+}
+
+static FC_DEVICE_ATTR(fcvport, issue_lip, S_IWUSR, NULL,
+		      store_fcvport_issue_lip);
+
+/* Convert fc_tgtid_binding_type values to ascii string name */
+static const struct {
+	enum fc_tgtid_binding_type	value;
+	char				*name;
+	int				matchlen;
+} fc_tgtid_binding_type_names[] = {
+	{ FC_TGTID_BIND_NONE, "none", 4 },
+	{ FC_TGTID_BIND_BY_WWPN, "wwpn (World Wide Port Name)", 4 },
+	{ FC_TGTID_BIND_BY_WWNN, "wwnn (World Wide Node Name)", 4 },
+	{ FC_TGTID_BIND_BY_ID, "port_id (FC Address)", 7 },
+};
+fc_enum_name_search(tgtid_bind_type, fc_tgtid_binding_type,
+		    fc_tgtid_binding_type_names)
+fc_enum_name_match(tgtid_bind_type, fc_tgtid_binding_type,
+		   fc_tgtid_binding_type_names)
+#define FC_BINDTYPE_MAX_NAMELEN	30
+
+static ssize_t show_fcvport_tgtid_bind_type(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	const char *name;
+
+	name = get_fc_tgtid_bind_type_name(fcvport_tgtid_bind_type(fcvport));
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FC_BINDTYPE_MAX_NAMELEN, "%s\n", name);
+}
+
+#define get_list_head_entry(pos, head, member)			\
+	pos = list_entry((head)->next, typeof(*pos), member)
+
+static ssize_t store_fcvport_tgtid_bind_type(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	struct fc_rport *rport;
+	enum fc_tgtid_binding_type val;
+	unsigned long flags;
+
+	if (get_fc_tgtid_bind_type_match(buf, &val))
+		return -EINVAL;
+
+	/* if changing bind type, purge all unused consistent bindings */
+	if (val != fcvport_tgtid_bind_type(fcvport)) {
+		spin_lock_irqsave(&fcvport->lock, flags);
+		while (!list_empty(&fcvport_rport_bindings(fcvport))) {
+			get_list_head_entry(rport,
+				&fcvport_rport_bindings(fcvport), peers);
+			list_del(&rport->peers);
+			rport->port_state = FC_PORTSTATE_DELETED;
+			fc_queue_work(fcvport, &rport->rport_delete_work);
+		}
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+	}
+
+	fcvport_tgtid_bind_type(fcvport) = val;
+	return count;
+}
+
+static FC_DEVICE_ATTR(fcvport, tgtid_bind_type, S_IRUGO | S_IWUSR,
+		      show_fcvport_tgtid_bind_type,
+		      store_fcvport_tgtid_bind_type);
+
+/*
+static ssize_t
+store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	struct fc_fcfabric *fcfabric = fcvport_to_fcfabric(fcvport);
+
+	fc4->fc4_queue_work(fcpinit, &vport->vport_delete_work);
+	return count;
+}
+static FC_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
+			NULL, store_fc_vport_delete);
+
+
+*
+ * Enable/Disable vport
+ *  Write "1" to disable, write "0" to enable
+ *
+static ssize_t
+store_fc_vport_disable(struct device *dev, struct device_attribute *attr,
+		       const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(dev);
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int stat;
+
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+		return -EBUSY;
+
+	if (*buf == '0') {
+		if (vport->vport_state != FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else if (*buf == '1') {
+		if (vport->vport_state == FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else
+		return -EINVAL;
+
+	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
+		NULL, store_fc_vport_disable);
+*/
+
+fcvport_rd_attr(port_id, "0x%06x\n", 20);
+fcvport_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
+
+/**
+ * fc_queue_work - Queue work to the fcpinit workqueue.
+ * @shost:      Pointer to Scsi_Host bound to fcpinit.
+ * @work:       Work to queue for execution.
+ *
+ * Return value:
+ *      1 - work queued for execution
+ *      0 - work is already queued
+ *      -EINVAL - work queue doesn't exist
+ */
+int fc_queue_work(struct fc_fcvport *fcvport, struct work_struct *work)
+{
+	if (unlikely(!fcvport_work_q(fcvport))) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(fcvport_work_q(fcvport), work);
+}
+EXPORT_SYMBOL(fc_queue_work);
+
+/**
+ * fc_flush_work - Flush a fcpinit's workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
+ */
+void fc_flush_work(struct fc_fcvport *fcvport)
+{
+	if (!fcvport_work_q(fcvport)) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fcvport_work_q(fcvport));
+}
+
+/**
+ * fc_queue_devloss_work - Schedule work for the fcpinit devloss workqueue.
+ * @shost:      Pointer to Scsi_Host bound to fcpinit.
+ * @work:       Work to queue for execution.
+ * @delay:      jiffies to delay the work queuing
+ *
+ * Return value:
+ *      1 on success / 0 already queued / < 0 for error
+ */
+int fc_queue_devloss_work(struct fc_fcvport *fcvport, struct delayed_work *work,
+			  unsigned long delay)
+{
+	if (unlikely(!fcvport_devloss_work_q(fcvport))) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_delayed_work(fcvport_devloss_work_q(fcvport), work, delay);
+}
+
+/**
+ * fc_flush_devloss - Flush a fcpinit's devloss workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
+ */
+void fc_flush_devloss(struct fc_fcvport *fcvport)
+{
+	if (!fcvport_devloss_work_q(fcvport)) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fcvport_devloss_work_q(fcvport));
+}
+
+static void fc_fcvport_release(struct device *dev)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	/*
+	 * TODO: Remove this memset. It's helpful when checking
+	 * reference counting becuase it forces NULL pointer
+	 * exceptions for things that are incorrectly using the
+	 * object that's about to be free'd.
+	 */
+	memset(fcvport, 0, sizeof(*fcvport));
+	kfree(fcvport);
+}
+
+void fc_fcvport_del(struct fc_fcvport *fcvport)
+{
+	struct fc_rport *rport = NULL, *next_rport = NULL;
+	struct workqueue_struct *work_q;
+	unsigned long flags;
+
+	/*
+	 * TODO: fc_vport_terminate checks the vport->flags to
+	 * determine if the vport is being created, deleted, etc...
+	 * That stuff does need to be checked before calling this
+	 * routine in case the user spams sysfs but does this
+	 * routine not care about the vport->flags at all?
+	 */
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	/* Remove any remote ports */
+	list_for_each_entry_safe(rport, next_rport,
+				 &fcvport->rports, peers) {
+		list_del(&rport->peers);
+		rport->port_state = FC_PORTSTATE_DELETED;
+		fc_queue_work(fcvport, &rport->rport_delete_work);
+	}
+
+	list_for_each_entry_safe(rport, next_rport,
+				 &fcvport->rport_bindings, peers) {
+		list_del(&rport->peers);
+		rport->port_state = FC_PORTSTATE_DELETED;
+		fc_queue_work(fcvport, &rport->rport_delete_work);
+	}
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/* flush all stgt delete, and rport delete work items, then kill it  */
+	if (fcvport->work_q) {
+		work_q = fcvport->work_q;
+		fcvport->work_q = NULL;
+		destroy_workqueue(work_q);
+	}
+
+	/* flush all devloss work items, then kill it  */
+	if (fcvport->devloss_work_q) {
+		work_q = fcvport->devloss_work_q;
+		fcvport->devloss_work_q = NULL;
+		destroy_workqueue(work_q);
+	}
+
+	fc4->fc4_init_del(fcvport);
+
+	put_device(&fcvport->dev); /* For rports list */
+	device_del(&fcvport->dev);
+	put_device(fcvport->dev.parent);
+}
+EXPORT_SYMBOL(fc_fcvport_del);
+
+void fc_fcvport_free(struct fc_fcvport *fcvport)
+{
+	put_device(&fcvport->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_fcvport_free);
+
+struct class fcvport_class = {
+	.name = "fcvport",
+	.dev_release = fc_fcvport_release,
+};
+EXPORT_SYMBOL(fcvport_class);
+
+struct fc_fcvport *fc_fcvport_alloc(struct fc_fcfabric *fcfabric,
+				    struct fc_vport_identifiers *ids,
+				    struct fcvport_function_template *f,
+				    int priv_size,
+				    struct fc_fcport *fcport)
+{
+	struct fc_fcvport *fcvport, *fcnport;
+	unsigned long flags;
+	int error = 0;
+
+	fcvport = kzalloc(sizeof(struct fc_fcvport) + priv_size, GFP_KERNEL);
+	if (!fcvport)
+		return NULL;
+
+	fcvport->vport_state = FC_VPORT_UNKNOWN;
+	fcvport->vport_last_state = FC_VPORT_UNKNOWN;
+	fcvport->node_name = ids->node_name;
+	fcvport->port_name = ids->port_name;
+	fcvport->roles = ids->roles;
+	fcvport->vport_type = ids->vport_type;
+	fcvport->id = atomic_inc_return(&fcvport_num) - 1;
+	fcvport->port_type = FC_PORTTYPE_UNKNOWN;
+	fcvport->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
+
+	INIT_LIST_HEAD(&fcvport->rports);
+	INIT_LIST_HEAD(&fcvport->rport_bindings);
+	fcvport->next_rport_number = 0;
+
+	INIT_WORK(&fcvport->vport_delete_work, fc_vport_sched_delete);
+	spin_lock_init(&fcvport->lock);
+	device_initialize(&fcvport->dev); /* Takes a self-reference */
+
+	fcvport->dev.class = &fcvport_class;
+	fcvport->f = f;
+
+	dev_set_name(&fcvport->dev, "fcvport_%d", fcvport->id);
+	get_device(&fcvport->dev); /* For rports list */
+
+	/*
+	 * rport management initialization
+	 */
+	fcvport->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
+
+	snprintf(fcvport->work_q_name, sizeof(fcvport->work_q_name),
+		 "fc_wq_%d", fcvport->id);
+	fcvport->work_q = create_singlethread_workqueue(
+		fcvport->work_q_name);
+	if (!fcvport->work_q)
+		return NULL;
+
+	snprintf(fcvport->devloss_work_q_name,
+		 sizeof(fcvport->devloss_work_q_name),
+		 "fc_dl_%d", fcvport->id);
+	fcvport->devloss_work_q = create_singlethread_workqueue(
+		fcvport->devloss_work_q_name);
+	if (!fcvport->devloss_work_q) {
+		destroy_workqueue(fcvport->work_q);
+		fcvport->work_q = NULL;
+		return NULL;
+	}
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	fcvport->flags &= ~FC_VPORT_CREATING;
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * TODO: This is ugly. We're doing different cases for N_Ports
+	 * and VN_Ports since there's no fcfabric passed in for N_Ports.
+	 */
+	if (fcfabric) {
+		fcnport = fc_fcfabric_find_nport(fcfabric);
+		if (!fcnport)
+			return NULL;
+
+		error = fcfabric->f->vport_create(fcvport_priv(fcnport),
+						  fcvport, 0);
+		if (error)
+			goto delete_vport_all;
+	}
+
+	/*
+	 * TODO: We probably want to re-add a dev_printk here
+	 dev_printk(KERN_NOTICE, pdev,
+	 "%s created via shost%d channel %d\n", dev_name(dev),
+	 shost->host_no, channel);
+	*/
+	return fcvport;
+
+delete_vport_all:
+/*
+ * TODO: Double check this routines error handling,
+ * we probably need to clean up more here.
+ */
+	kfree(fcvport);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcvport_alloc);
+
+int fc_fcvport_add(struct fc_fcvport *fcvport,
+		   struct fc_fcfabric *fcfabric)
+{
+	struct fc_fcport *fcport = fcfabric_to_fcport(fcfabric);
+	int count = 0;
+	int error = 0;
+
+	fcvport->dev.parent = get_device(&fcfabric->dev);
+
+	/*
+	 * TODO: Should the device be free'd if the
+	 * device_add() fails?
+	 */
+	error = device_add(&fcvport->dev);
+	if (error)
+		return error;
+
+	/* TODO: Check for failure */
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_id);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, node_name);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_name);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_type);
+
+	/*
+	 * Setup Virtual Port Attributes.
+	 */
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_state);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_last_state);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, roles);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_type);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, symbolic_name);
+
+	FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcvport, tgtid_bind_type);
+
+	if (fc_fcvport_is_nport(fcvport))
+		fc_fcfabric_add_npiv(fcfabric);
+
+	if (fcvport->f->issue_fcvport_lip)
+		FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcvport, issue_lip);
+
+	BUG_ON(count > FCVPORT_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(fcvport, count, 0);
+
+	if (error || count != 0)
+		return error;
+
+	fc4->fc4_init_add(fcvport, fcport->fc4_f);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_fcvport_add);
+
+int fc_fcvport_is_nport(struct fc_fcvport *fcvport)
+{
+	if (fcvport_port_type(fcvport) == FC_PORTTYPE_NPORT)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(fc_fcvport_is_nport);
+
+/**
+ * fc_vport_sched_delete - workq-based delete request for a vport
+ * @work:	vport to be deleted.
+ */
+static void
+fc_vport_sched_delete(struct work_struct *work)
+{
+	struct fc_fcvport *vport =
+		container_of(work, struct fc_fcvport, vport_delete_work);
+	struct fc_fcfabric *fcfabric = fcvport_to_fcfabric(vport);
+	int stat;
+
+	stat = fc_vport_terminate(fcfabric, vport);
+	if (stat)
+		dev_printk(KERN_ERR, vport->dev.parent,
+			   "%s: %s could not be deleted created via "
+			   "fcfabric %d channel %d - error %d\n", __func__,
+			   dev_name(&vport->dev), fcfabric->id,
+			   vport->channel, stat);
+}
diff --git a/include/fc/fc.h b/include/fc/fc.h
new file mode 100644
index 0000000..2487262
--- /dev/null
+++ b/include/fc/fc.h
@@ -0,0 +1,843 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _FC_H_
+#define _FC_H_
+
+#include <linux/device.h>
+#include <linux/sched.h>
+
+struct fc_fcport;
+struct fc_fcfabric;
+struct fc_fcvport;
+struct fc_rport;
+
+struct fcvport_function_template;
+
+/*
+ * FC Port definitions - Following FC HBAAPI guidelines
+ *
+ * Note: Not all binary values for the different fields match HBAAPI.
+ *  Instead, we use densely packed ordinal values or enums.
+ *  We get away with this as we never present the actual binary values
+ *  externally. For sysfs, we always present the string that describes
+ *  the value. Thus, an admin doesn't need a magic HBAAPI decoder ring
+ *  to understand the values. The HBAAPI user-space library is free to
+ *  convert the strings into the HBAAPI-specified binary values.
+ *
+ * Note: Not all HBAAPI-defined values are contained in the definitions
+ *  below. Those not appropriate to an fc_host (e.g. FCP initiator) have
+ *  been removed.
+ */
+
+/*
+ * fc_port_state: If you alter this, you also need to alter scsi_transport_fc.c
+ * (for the ascii descriptions).
+ */
+enum fc_port_state {
+	FC_PORTSTATE_UNKNOWN,
+	FC_PORTSTATE_NOTPRESENT,
+	FC_PORTSTATE_ONLINE,
+	FC_PORTSTATE_OFFLINE,		/* User has taken Port Offline */
+	FC_PORTSTATE_BLOCKED,
+	FC_PORTSTATE_BYPASSED,
+	FC_PORTSTATE_DIAGNOSTICS,
+	FC_PORTSTATE_LINKDOWN,
+	FC_PORTSTATE_ERROR,
+	FC_PORTSTATE_LOOPBACK,
+	FC_PORTSTATE_DELETED,
+};
+/* Names are in fcsysfs.c */
+#define FC_PORTSTATE_MAX_NAMELEN	20
+
+/*
+ * fc_port_type: If you alter this, you also need to alter scsi_transport_fc.c
+ * (for the ascii descriptions).
+ */
+enum fc_port_type {
+	FC_PORTTYPE_UNKNOWN,
+	FC_PORTTYPE_OTHER,
+	FC_PORTTYPE_NOTPRESENT,
+	FC_PORTTYPE_NPORT,		/* Attached to FPort */
+	FC_PORTTYPE_NLPORT,		/* (Public) Loop w/ FLPort */
+	FC_PORTTYPE_LPORT,		/* (Private) Loop w/o FLPort */
+	FC_PORTTYPE_PTP,		/* Point to Point w/ another NPort */
+	FC_PORTTYPE_NPIV,		/* VPORT based on NPIV */
+};
+
+/*
+ * FC Classes of Service
+ * Note: values are not enumerated, as they can be "or'd" together
+ * for reporting (e.g. report supported_classes). If you alter this list,
+ * you also need to alter scsi_transport_fc.c (for the ascii descriptions).
+ */
+#define FC_COS_UNSPECIFIED		0
+#define FC_COS_CLASS1			2
+#define FC_COS_CLASS2			4
+#define FC_COS_CLASS3			8
+#define FC_COS_CLASS4			0x10
+#define FC_COS_CLASS6			0x40
+
+/*
+ * FC Port Speeds
+ * Note: values are not enumerated, as they can be "or'd" together
+ * for reporting (e.g. report supported_speeds). If you alter this list,
+ * you also need to alter scsi_transport_fc.c (for the ascii descriptions).
+ */
+#define FC_PORTSPEED_UNKNOWN		0 /* Unknown - transceiver
+					     incapable of reporting */
+#define FC_PORTSPEED_1GBIT		1
+#define FC_PORTSPEED_2GBIT		2
+#define FC_PORTSPEED_4GBIT		4
+#define FC_PORTSPEED_10GBIT		8
+#define FC_PORTSPEED_8GBIT		0x10
+#define FC_PORTSPEED_16GBIT		0x20
+#define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
+
+/*
+ * fc_tgtid_binding_type: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_tgtid_binding_type  {
+	FC_TGTID_BIND_NONE,
+	FC_TGTID_BIND_BY_WWPN,
+	FC_TGTID_BIND_BY_WWNN,
+	FC_TGTID_BIND_BY_ID,
+};
+
+/*
+ * FC Port Roles
+ * Note: values are not enumerated, as they can be "or'd" together
+ * for reporting (e.g. report roles). If you alter this list,
+ * you also need to alter scsi_transport_fc.c (for the ascii descriptions).
+ */
+#define FC_PORT_ROLE_UNKNOWN			0x00
+#define FC_PORT_ROLE_FCP_TARGET			0x01
+#define FC_PORT_ROLE_FCP_INITIATOR		0x02
+#define FC_PORT_ROLE_IP_PORT			0x04
+
+/* The following are for compatibility */
+#define FC_RPORT_ROLE_UNKNOWN			FC_PORT_ROLE_UNKNOWN
+#define FC_RPORT_ROLE_FCP_TARGET		FC_PORT_ROLE_FCP_TARGET
+#define FC_RPORT_ROLE_FCP_INITIATOR		FC_PORT_ROLE_FCP_INITIATOR
+#define FC_RPORT_ROLE_IP_PORT			FC_PORT_ROLE_IP_PORT
+
+/* TODO: Delete this macro, is duplicated in fcvport.c
+
+ Macro for use in defining Virtual Port attributes
+ #define FC_VPORT_ATTR(_name,_mode,_show,_store)	\
+struct device_attribute dev_attr_vport_##_name =	\
+	__ATTR(_name,_mode,_show,_store)
+*/
+
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
+
+/* bit field values for struct fc_vport "flags" field: */
+#define FC_VPORT_CREATING		0x01
+#define FC_VPORT_DELETING		0x02
+#define FC_VPORT_DELETED		0x04
+#define FC_VPORT_DEL			0x06	/* Any DELETE state */
+
+/* Error return codes for vport_create() callback */
+#define VPCERR_UNSUPPORTED		-ENOSYS		/* no driver/adapter
+							   support */
+#define VPCERR_BAD_WWN			-ENOTUNIQ	/* driver validation
+							   of WWNs failed */
+#define VPCERR_NO_FABRIC_SUPP		-EOPNOTSUPP	/* Fabric connection
+							   is loop or the
+							   Fabric Port does
+							   not support NPIV */
+
+/*
+ * fc_rport_identifiers: This set of data contains all elements
+ * to uniquely identify a remote FC port. The driver uses this data
+ * to report the existence of a remote FC port in the topology. Internally,
+ * the transport uses this data for attributes and to manage consistent
+ * target id bindings.
+ */
+struct fc_rport_identifiers {
+	u64 node_name;
+	u64 port_name;
+	u32 port_id;
+	u32 roles;
+};
+
+#define fc_enum_name_match(title, table_type, table)			\
+int get_fc_##title##_match(const char *table_key,		\
+			   enum table_type *value)			\
+{									\
+	int i;								\
+									\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
+		if (strncmp(table_key, table[i].name,			\
+				table[i].matchlen) == 0) {		\
+			*value = table[i].value;			\
+			return 0; /* success */				\
+		}							\
+	}								\
+	return 1; /* failure */						\
+}
+
+#define fc_enum_name_search(title, table_type, table)			\
+const char *get_fc_##title##_name(enum table_type table_key)	\
+{									\
+	int i;								\
+	char *name = NULL;						\
+									\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
+		if (table[i].value == table_key) {			\
+			name = table[i].name;				\
+			break;						\
+		}							\
+	}								\
+	return name;							\
+}
+
+/* Macro for use in defining Remote Port attributes */
+#define FC_RPORT_ATTR(_name, _mode, _show, _store)				\
+struct device_attribute dev_attr_rport_##_name = 	\
+	__ATTR(_name, _mode, _show, _store)
+
+
+/*
+ * FC Local Port (Host) Attributes
+ *
+ * Attributes are based on HBAAPI V2.0 definitions.
+ * Note: OSDeviceName is determined by user-space library
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after successfully calling scsi_add_host().
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+
+#define FC_FC4_LIST_SIZE		32
+#define FC_SYMBOLIC_NAME_SIZE          256
+
+u32 fc_get_event_number(void);
+	/* Note: when specifying vendor_id to fcpinit_post_vendor_event()
+	 *   be sure to read the Vendor Type and ID formatting requirements
+	 *   specified in scsi_netlink.h
+	 */
+
+struct _fc_port_types {
+	enum fc_port_type value;
+	char             *name;
+};
+
+struct _fc_port_role_names {
+	u32   value;
+	char *name;
+};
+
+struct _fc_cos_names {
+	u32   value;
+	char *name;
+};
+
+const char *get_fc_port_state_name(enum fc_port_state table_key);
+
+/*
+ * fc_vport_state: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_vport_state {
+	FC_VPORT_UNKNOWN,
+	FC_VPORT_ACTIVE,
+	FC_VPORT_DISABLED,
+	FC_VPORT_LINKDOWN,
+	FC_VPORT_INITIALIZING,
+	FC_VPORT_NO_FABRIC_SUPP,
+	FC_VPORT_NO_FABRIC_RSCS,
+	FC_VPORT_FABRIC_LOGOUT,
+	FC_VPORT_FABRIC_REJ_WWN,
+	FC_VPORT_FAILED,
+};
+
+#define FC_SERIAL_NUMBER_SIZE		80
+
+#define dev_to_fcport(d)				\
+	container_of((d), struct fc_fcport, dev)
+
+#define dev_to_fcfabric(d)				\
+	container_of((d), struct fc_fcfabric, dev)
+
+#define dev_to_fcvport(d)				\
+	container_of((d), struct fc_fcvport, dev)
+
+/*
+ * TODO: Double check these maximum attribute defines
+ */
+#define FCPORT_NUM_ATTRS    7
+#define FCVPORT_NUM_ATTRS  12
+#define FCRPORT_NUM_ATTRS   9
+#define FCFABRIC_NUM_ATTRS  5
+
+struct fcport_function_template {
+	void (*get_fcport_speed)(struct fc_fcport *);
+	void (*get_fcport_active_fc4s)(struct fc_fcport *);
+
+	unsigned long show_fcport_maxframe_size:1;
+	unsigned long show_fcport_supported_speeds:1;
+	unsigned long show_fcport_speed:1;
+	unsigned long show_fcport_supported_fc4s:1;
+	unsigned long show_fcport_active_fc4s:1;
+	unsigned long show_fcport_supported_classes:1;
+	unsigned long show_fcport_serial_number:1;
+};
+
+struct fc_fcport {
+	u32              id;
+	struct device    dev;
+	struct fcport_function_template *f;
+	void *fc4_f;
+	struct device_attribute attrs[FCPORT_NUM_ATTRS];
+
+	/* Fixed Attributes */
+	u8   supported_fc4s[FC_FC4_LIST_SIZE];
+	u32  maxframe_size;
+	u32  supported_classes;
+	char serial_number[FC_SERIAL_NUMBER_SIZE];
+
+	/* Dynamic Attributes*/
+	u8 active_fc4s[FC_FC4_LIST_SIZE];
+
+	/*
+	 * TODO: For FCoE supported_speeds and speed
+	 * can change on a link event. Previously they
+	 * were listed under the "Fixed Attributes" comment,
+	 * but maybe they should be moved under the
+	 * "Dynamic Attributes" comment. Does this have
+	 * an impact on the functionality?
+	 */
+	u32 supported_speeds;
+	u32 speed;
+};
+#define fcport_maxframe_size(x)			\
+	((x)->maxframe_size)
+#define fcport_supported_speeds(x)		\
+	((x)->supported_speeds)
+#define fcport_speed(x)				\
+	((x)->speed)
+#define fcport_supported_fc4s(x)		\
+	((x)->supported_fc4s)
+#define fcport_active_fc4s(x)			\
+	((x)->active_fc4s)
+#define fcport_supported_classes(x)		\
+	((x)->supported_classes)
+#define fcport_serial_number(x)			\
+	((x)->serial_number)
+
+struct fcfabric_function_template {
+	void (*get_fcfabric_fabric_name)(struct fc_fcfabric *);
+	int  (*vport_create)(void *, struct fc_fcvport *, bool);
+	int  (*vport_disable)(struct fc_fcvport *, bool);
+	int  (*vport_delete)(void *, struct fc_fcvport *);
+
+	unsigned long	show_fcfabric_fabric_name:1;
+
+	/*
+	 * TODO: This seems misplaced, but the vport_create
+	 * code in fcfabric needs it.
+	 */
+	u32 dd_fcvport_size;
+};
+
+struct fc_fcfabric {
+	struct device    dev;
+	struct fcfabric_function_template *f;
+
+	/* Fixed Attributes */
+	u64 fabric_name;
+	u16 max_npiv_vports;
+
+	/* Dynamic Attributes */
+	u16 npiv_vports_inuse;
+
+	/* Internal Data */
+	u32 next_vport_number;
+
+	u32 id;
+
+	/*
+	 * TODO: Can this be moved out of the fabric?
+	 * It is needed for vport_create which orignates
+	 * from the fabric.
+	 */
+	struct fcvport_function_template *fcvport_f;
+
+	int attr_count;
+
+	struct list_head vports;
+
+	/* Replacement for shost->host_lock, protects vports list */
+	spinlock_t              lock;
+
+	struct device_attribute attrs[FCFABRIC_NUM_ATTRS];
+};
+
+#define fcfabric_fabric_name(x)			\
+	((x)->fabric_name)
+#define fcfabric_max_npiv_vports(x)		\
+	((x)->max_npiv_vports)
+#define fcfabric_next_vport_number(x)		\
+	((x)->next_vport_number)
+#define fcfabric_npiv_vports_inuse(x)		\
+	((x)->npiv_vports_inuse)
+#define fcfabric_vports(x)			\
+	((x)->vports)
+#define fcfabric_to_fcport(x)			\
+	dev_to_fcport((x)->dev.parent)
+
+struct fcvport_function_template {
+	void (*get_fcvport_port_id)(struct fc_fcvport *);
+	void (*get_fcvport_symbolic_name)(struct fc_fcvport *);
+	void (*get_fcvport_port_type)(struct fc_fcvport *);
+	void (*set_fcvport_symbolic_name)(struct fc_fcvport *);
+
+	int (*issue_fcvport_lip)(struct fc_fcvport *);
+
+	unsigned long show_fcvport_port_id:1;
+	unsigned long show_fcvport_symbolic_name:1;
+	unsigned long show_fcvport_node_name:1;
+	unsigned long show_fcvport_port_name:1;
+	unsigned long show_fcvport_port_type:1;
+};
+
+/*
+ * FC Virtual Port Attributes
+ *
+ * This structure exists for each FC port is a virtual FC port. Virtual
+ * ports share the physical link with the Physical port. Each virtual
+ * ports has a unique presense on the SAN, and may be instantiated via
+ * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
+ * unique presense, each vport has it's own view of the fabric,
+ * authentication privilege, and priorities.
+ *
+ * A virtual port may support 1 or more FC4 roles. Typically it is a
+ * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
+ * roles. FC port attributes for the vport will be reported on any
+ * fc_host class object allocated for an FCP Initiator.
+ *
+ * --
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after receiving the fc_vport structure
+ * via the vport_create() call from the transport.
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+struct fc_fcvport {
+	struct device                    dev;
+	struct fcvport_function_template *f;
+	u32                              id;
+
+	u32                              port_id;
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	u64                              node_name;
+	u64                              port_name;
+	enum fc_port_type                port_type;
+
+	struct device_attribute attrs[FCVPORT_NUM_ATTRS];
+
+	/*
+	 * The upper layer fc4 protocol needs a way get
+	 * from a vport to its internal object. Is there
+	 * a better way to do this other than a void *
+	 */
+	void *fc4_priv;
+
+	/* Fixed Attributes */
+
+	/* Dynamic Attributes */
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_vport_state vport_state;
+	enum fc_vport_state vport_last_state;
+	u32 roles;
+	u32 vport_id;		/* Admin Identifier for the vport */
+	enum fc_port_type vport_type;
+
+	/* internal data */
+	unsigned int channel;
+	u32 number;
+	u8 flags;
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_tgtid_binding_type  tgtid_bind_type;
+
+	/* internal data */
+	struct list_head rports;
+	struct list_head rport_bindings;
+	u32 next_rport_number;
+
+	/* work queues for rport state manipulation */
+	char work_q_name[20];
+	struct workqueue_struct *work_q;
+	char devloss_work_q_name[20];
+	struct workqueue_struct *devloss_work_q;
+
+	/*
+	 * Replacement for shost->host_lock, protects vport_state,
+	 * the scsi_target_id (needs to change) and the rport list
+	 */
+	spinlock_t              lock;
+
+	struct list_head peers;
+
+	struct work_struct vport_delete_work;
+
+} __attribute__((aligned(sizeof(unsigned long))));
+
+static inline void *fcvport_priv(const struct fc_fcvport *fcvport)
+{
+	return (void *)(fcvport + 1);
+}
+
+#define fcvport_port_id(x)			\
+	((x)->port_id)
+#define fcvport_symbolic_name(x)		\
+	((x)->symbolic_name)
+#define fcvport_node_name(x)			\
+	((x)->node_name)
+#define fcvport_port_name(x)			\
+	((x)->port_name)
+#define fcvport_port_type(x)			\
+	((x)->port_type)
+#define fcvport_tgtid_bind_type(x)		\
+	((x)->tgtid_bind_type)
+#define fcvport_rports(x)			\
+	((x)->rports)
+#define fcvport_rport_bindings(x)		\
+	((x)->rport_bindings)
+#define fcvport_next_rport_number(x)		\
+	((x)->next_rport_number)
+#define fcvport_work_q_name(x)			\
+	((x)->work_q_name)
+#define fcvport_work_q(x)			\
+	((x)->work_q)
+#define fcvport_devloss_work_q_name(x)		\
+	((x)->devloss_work_q_name)
+#define fcvport_devloss_work_q(x)		\
+	((x)->devloss_work_q)
+#define fcvport_to_fcfabric(x)			\
+	dev_to_fcfabric((x)->dev.parent)
+
+struct fcrport_function_template {
+	void (*get_rport_dev_loss_tmo)(struct fc_rport *);
+	void (*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
+
+	void (*dev_loss_tmo_callbk)(struct fc_rport *);
+	void (*terminate_rport_io)(struct fc_rport *);
+
+	/* remote port fixed attributes */
+	unsigned long	show_rport_maxframe_size:1;
+	unsigned long	show_rport_supported_classes:1;
+	unsigned long   show_rport_dev_loss_tmo:1;
+
+	/* allocation lengths for host-specific data */
+	u32 dd_fcrport_size;
+
+	/*
+	 * target dynamic attributes
+	 * These should all be "1" if the driver uses the remote port
+	 * add/delete functions (so attributes reflect rport values).
+	 *
+	unsigned long	show_starget_node_name:1;
+	unsigned long	show_starget_port_name:1;
+	unsigned long	show_starget_port_id:1;
+	*/
+	unsigned long	disable_target_scan:1;
+};
+
+/*
+ * FC Remote Port Attributes
+ *
+ * This structure exists for each remote FC port that a LLDD notifies
+ * the subsystem of.  A remote FC port may or may not be a SCSI Target,
+ * also be a SCSI initiator, IP endpoint, etc. As such, the remote
+ * port is considered a separate entity, independent of "role" (such
+ * as scsi target).
+ *
+ * --
+ *
+ * Attributes are based on HBAAPI V2.0 definitions. Only those
+ * attributes that are determinable by the local port (aka Host)
+ * are contained.
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after successfully calling
+ * fc_fcrport_add(). The transport fully manages all get functions
+ * w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+
+struct fc_rport {	/* aka fc_starget_attrs */
+	struct fcrport_function_template *f;
+	struct device_attribute attrs[FCRPORT_NUM_ATTRS];
+
+	/* Fixed Attributes */
+	u32 maxframe_size;
+	u32 supported_classes;
+
+	/* Dynamic Attributes */
+	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
+
+	/* Private (Transport-managed) Attributes */
+	u64 node_name;
+	u64 port_name;
+	u32 port_id;
+	u32 roles;
+	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
+	u32 fast_io_fail_tmo;
+
+	/* exported data */
+	void *dd_data;			/* Used for driver-specific storage */
+
+	/* internal data */
+	unsigned int channel;
+	u32 number;
+	u8 flags;
+	struct list_head peers;
+	struct device dev;
+
+	struct delayed_work dev_loss_work;
+	struct delayed_work fail_io_work;
+	struct work_struct rport_delete_work;
+
+	void *fc4_priv;
+} __attribute__((aligned(sizeof(unsigned long))));
+
+#define rport_port_state(x)			\
+	((x)->port_state)
+#define rport_port_id(x)			\
+	((x)->port_id)
+#define rport_node_name(x)			\
+	((x)->node_name)
+#define rport_port_name(x)			\
+	((x)->port_name)
+#define rport_maxframe_size(x)			\
+	((x)->maxframe_size)
+
+
+/* bit field values for struct fc_rport "flags" field: */
+#define FC_RPORT_DEVLOSS_PENDING	0x01
+#define FC_RPORT_SCAN_PENDING		0x02
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
+#define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
+
+#define	dev_to_rport(d)				\
+	container_of((d), struct fc_rport, dev)
+
+#define rport_to_fcvport(r)			\
+	dev_to_fcvport((r)->dev.parent)
+
+static inline u64 wwn_to_u64(u8 *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+	    (u64)wwn[6] <<  8 | (u64)wwn[7];
+}
+
+static inline void u64_to_wwn(u64 inm, u8 *wwn)
+{
+	wwn[0] = (inm >> 56) & 0xff;
+	wwn[1] = (inm >> 48) & 0xff;
+	wwn[2] = (inm >> 40) & 0xff;
+	wwn[3] = (inm >> 32) & 0xff;
+	wwn[4] = (inm >> 24) & 0xff;
+	wwn[5] = (inm >> 16) & 0xff;
+	wwn[6] = (inm >> 8) & 0xff;
+	wwn[7] = inm & 0xff;
+}
+
+/**
+ * fc_vport_set_state() - called to set a vport's state. Saves the old state,
+ *   excepting the transitory states of initializing and sending the ELS
+ *   traffic to instantiate the vport on the link.
+ *
+ * Assumes the driver has surrounded this with the proper locking to ensure
+ * a coherent state change.
+ *
+ * @vport:	virtual port whose state is changing
+ * @new_state:  new state
+ **/
+static inline void
+fc_vport_set_state(struct fc_fcvport *fcvport, enum fc_vport_state new_state)
+{
+	if ((new_state != FC_VPORT_UNKNOWN) &&
+	    (new_state != FC_VPORT_INITIALIZING))
+		fcvport->vport_last_state = fcvport->vport_state;
+	fcvport->vport_state = new_state;
+}
+
+struct fc_fcvport *fc_fcvport_lookup(struct fc_fcfabric *fcfabric,
+				     const u32 id);
+
+struct fc_fcport *fc_fcport_add(struct device *pdev,
+				struct fcport_function_template *,
+				void *fc4_f);
+struct fc_fcfabric *fc_fcfabric_add(struct fc_fcport *fcport,
+				    struct fcfabric_function_template *,
+				    const u64 name);
+struct fc_fcvport *fc_fcvport_alloc(struct fc_fcfabric *fcfabric,
+				    struct fc_vport_identifiers *ids,
+				    struct fcvport_function_template *fcn_tmpl,
+				    int priv_size, struct fc_fcport *fcport);
+struct fc_fcvport *fc_vport_create(struct fc_fcfabric *, int channel,
+				   struct fc_vport_identifiers *);
+int fc_fcvport_add(struct fc_fcvport *fcvport,
+		   struct fc_fcfabric *fcfabric);
+
+void fc_fcport_del(struct fc_fcport *fcport);
+void fc_fcfabric_del(struct fc_fcfabric *fcfabric);
+void fc_fcvport_del(struct fc_fcvport *fcvport);
+void fc_fcvport_free(struct fc_fcvport *fcvport);
+
+int fc_fcvport_is_nport(struct fc_fcvport *fcvport);
+struct fc_fcvport *fc_fcfabric_find_nport(struct fc_fcfabric *fcfabric);
+
+#define FC_DEVICE_ATTR(_prefix, _name, _mode, _show, _store)		\
+	struct device_attribute device_attr_##_prefix##_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+#define FC_CREATE_ATTRIBUTES(_var, count, min)				\
+	while (count > min) {						\
+		error = device_create_file(&_var->dev, &_var->attrs[count-1]); \
+		if (error)						\
+			break;						\
+		count--;						\
+	}
+
+#define FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(_var, field)			\
+	if (_var->f->show_##_var##_##field) {				\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		_var->attrs[count].attr.mode = S_IRUGO;			\
+		_var->attrs[count].store = NULL;			\
+		count++;						\
+	}
+
+#define FC_SETUP_CONDITIONAL_ATTRIBUTE_RW(_var, field)			\
+{									\
+	if (_var->f->show_##_var##_##field) {				\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		count++;						\
+	}								\
+}
+
+#define FC_SETUP_ALWAYS_ATTRIBUTE_RW(_var, field)			\
+{									\
+	_var->attrs[count] = device_attr_##_var##_##field;		\
+	count++;							\
+}
+
+#define FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(_var, field)			\
+	_var->attrs[count] = device_attr_##_var##_##field;		\
+	_var->attrs[count].attr.mode = S_IRUGO;				\
+	_var->attrs[count].store = NULL;				\
+	count++
+
+#define fc_always_show_function(_obj, field, format_string, sz, cast)	\
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_##_obj *_obj = dev_to_##_obj(dev);			\
+	return snprintf(buf, sz, format_string, cast _obj##_##field(_obj)); \
+}
+
+#define fc_conditional_show_function(_obj, field, format_string, sz, cast) \
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_##_obj *_obj = dev_to_##_obj(dev);			\
+	if (_obj->f->get_##_obj##_##field)				\
+		_obj->f->get_##_obj##_##field(_obj);			\
+	return snprintf(buf, sz, format_string, cast _obj##_##field(_obj)); \
+}
+
+struct fc_rport *fc_fcrport_add(struct fc_fcvport *fcvport,
+				struct fcrport_function_template *f,
+				int channel,
+				struct fc_rport_identifiers *ids);
+void fc_fcrport_del(struct fc_rport *rport);
+void fc_fcrport_rolechg(struct fc_rport *rport, u32 roles);
+
+int fc_queue_work(struct fc_fcvport *fcvport, struct work_struct *work);
+void fc_flush_work(struct fc_fcvport *fcvport);
+
+struct fc4_template {
+	int (*fc4_init_add)(struct fc_fcvport *fcvport,
+			    void *fc4_f);
+	void (*fc4_init_del)(struct fc_fcvport *fcvport);
+	int (*fc4_targ_add)(struct fc_rport *rport,
+			    struct fc_fcvport *fcvport,
+			    int channel);
+	void (*fc4_targ_del)(struct fc_rport *rport);
+
+	void (*fc4_bsg_goose_queue)(struct fc_rport *rport);
+	void (*fc4_targ_block)(struct fc_rport *rport);
+	void (*fc4_targ_unblock)(struct fc_rport *rport);
+	void (*fc4_targ_terminate_io)(struct fc_rport *rport);
+	void (*fc4_starget_delete)(struct fc_rport *rport);
+	void (*fc4_queue_starget_delete)(struct fc_rport *rport);
+	void (*fc4_targ_queue_scan)(struct fc_rport *rport);
+	void (*fc4_init_scsi_flush_work)(struct fc_fcvport *fcvport);
+	int  (*fc4_targ_rolechg)(struct fc_rport *rport, u32 roles);
+	void (*fc4_targ_final_delete)(struct fc_rport *rport);
+};
+
+int register_fc4(struct fc4_template *tmpl);
+void unregister_fc4(void);
+
+#endif /* _FC_H_ */

