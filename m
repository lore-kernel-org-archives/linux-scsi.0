From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 1/8] fc: Create FC sybsystem
Date: Mon, 07 Mar 2011 18:31:48 -0800
Message-ID: <20110308023148.6205.30749.stgit@localhost6.localdomain6>
References: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1CHCbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 21:31:50 -0500
In-Reply-To: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

This patch creates a Fibre Channel subsystem. This new FC layer allows different
FC4 types to register with it; it also allows LLDs to register with it. When a
LLD supports one of the FC4s registered, the FC layer allows the FC4 to be
transported over the LLD.

This patch creates files under drivers/fc/ that expose APIs to both the FC4s
and LLDs. The API to the FC4s allow FC4s to register with FC so that they can
be used by LLDs. The API to the LLDs allows the LLDs to add fcports, fcfabrics,
fcvports and fcrports to sysfs and to make use of the registered FC4s.

The patch creates the following FC devices. The attributes for each new device
are taken from the existing FC Transport code.

fcport: Represents physical port
	Attributes: maxframe_size
		    supported_speeds
		    speed
		    supported_fc4s
		    active_fc4s
		    supported_classes
		    serial_number

fcfabric: Represents the FC fabric and switch (FCF for FCoE)
	  Attributes: fabric_name
	  	      max_npiv_vports
		      npiv_vports_inuse
		      vport_create
		      vport_delete
		      vport_disable

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

One major thing to note is that there is not an object-wise
distinction between N_Ports and VN_Ports; all instances are
of type struct fc_vport.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/Kconfig       |    2 
 drivers/Makefile      |    1 
 drivers/fc/Kconfig    |    8 
 drivers/fc/Makefile   |    7 
 drivers/fc/fcfabric.c |  540 ++++++++++++++++++++++++++
 drivers/fc/fcport.c   |  445 ++++++++++++++++++++++
 drivers/fc/fcrport.c  | 1012 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fc/fcsysfs.c  |  176 +++++++++
 drivers/fc/fcsysfs.h  |   92 ++++
 drivers/fc/fcvport.c  |  687 +++++++++++++++++++++++++++++++++
 include/fc/fc.h       |  952 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 3922 insertions(+), 0 deletions(-)
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
index 9bfb71f..b132b25 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -30,6 +30,8 @@ source "drivers/target/Kconfig"
 
 source "drivers/message/fusion/Kconfig"
 
+source "drivers/fc/Kconfig"
+
 source "drivers/firewire/Kconfig"
 
 source "drivers/message/i2o/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index b423bb1..bf470c5 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -52,6 +52,7 @@ obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
 obj-y				+= firewire/
+obj-$(CONFIG_FC)		+= fc/
 obj-$(CONFIG_UIO)		+= uio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
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
index 0000000..b275351
--- /dev/null
+++ b/drivers/fc/fcfabric.c
@@ -0,0 +1,540 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+/* used by max_npiv_vports */
+/* used by npiv_vports_inuse */
+#define fc_fabric_rd_attr(field, format_string, sz)			\
+	fc_show_function(fc, fabric, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fabric_##field, NULL)
+
+/* used by fabric_name */
+#define fc_fabric_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_show_function(fc, fabric, field, format_string, sz, (cast))	\
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fabric_##field, NULL)
+
+fc_fabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fc_fabric_rd_attr(max_npiv_vports, "%u\n", 20);
+fc_fabric_rd_attr(npiv_vports_inuse, "%u\n", 20);
+
+fc_fabric_rd_attr(dev_loss_tmo, "%d\n", 20);
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
+	for (i = 0, j = 0; i < 16; i++) {
+		if ((*ns >= 'a') && (*ns <= 'f'))
+			j = ((j << 4) | ((*ns++ - 'a') + 10));
+		else if ((*ns >= 'A') && (*ns <= 'F'))
+			j = ((j << 4) | ((*ns++ - 'A') + 10));
+		else if ((*ns >= '0') && (*ns <= '9'))
+			j = ((j << 4) | (*ns++ - '0'));
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
+ * fc_vport_setup() - allocates and creates a FC virtual port.
+ * @fcfabric:	The fabric that the virtual port is connected to.
+ * @channel:	Channel on shost port connected to.
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
+static int fc_vport_setup(struct fc_fabric *fcfabric, int channel,
+			  struct fc_vport_identifiers *ids,
+			  struct fc_vport **ret_vport)
+{
+	struct fc_vport *fcnport = fc_fabric_find_nport(fcfabric);
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	struct fc_vport *fcvport;
+
+	*ret_vport = NULL;
+
+	if (!fcnport->f->vport_create)
+		return -ENOENT;
+
+	fcvport = fc_vport_alloc(fcnport, ids, &fcport->f->fcvport_f,
+				 channel, FC4_FCP_INITIATOR);
+	if (unlikely(!fcvport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		return -ENOMEM;
+	}
+
+	mutex_lock(&fcport->lock);
+
+	if (fcfabric->npiv_vports_inuse >= fcfabric->max_npiv_vports) {
+		mutex_unlock(&fcport->lock);
+		kfree(fcvport);
+		return -ENOSPC;
+	}
+
+	fcfabric->npiv_vports_inuse++;
+	fcvport->number = fcfabric->next_vport_number++;
+	list_add_tail(&fcvport->peers, &fcfabric->vports);
+
+	mutex_unlock(&fcport->lock);
+
+	return 0;
+}
+
+/**
+ * fc_vport_create() - Admin App or LLDD requests creation of a vport
+ * @fcfabric:	The fabric that the virtual port is connected to.
+ * @channel:	channel on shost port connected to.
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_vport *fc_vport_create(struct fc_fabric *fcfabric,
+				 int channel, struct fc_vport_identifiers *ids)
+{
+	int stat;
+	struct fc_vport *vport;
+
+	stat = fc_vport_setup(fcfabric, channel, ids, &vport);
+
+	return stat ? NULL : vport;
+}
+
+/**
+ * fc_vport_terminate() - Admin App or LLDD requests termination of a vport
+ * @fcfabric:   The fabric that the FC vport is attached to.
+ * @vport:	The FC vport to be terminated.
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+int fc_vport_terminate(struct fc_fabric *fcfabric, struct fc_vport *vport)
+{
+	struct fc_vport *fcnport;
+	unsigned long flags;
+	int stat = 0;
+
+	spin_lock_irqsave(&vport->lock, flags);
+	if (vport->flags & FC_VPORT_CREATING) {
+		spin_unlock_irqrestore(&vport->lock, flags);
+		return -EBUSY;
+	}
+	if (vport->flags & FC_VPORT_DEL) {
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
+	fcnport = vport->fcnport;
+	if (fcnport && fcnport->f->vport_delete)
+		stat = fcnport->f->vport_delete(fcnport, vport);
+	else
+		stat = -ENOENT;
+
+	spin_lock_irqsave(&vport->lock, flags);
+	vport->flags &= ~FC_VPORT_DELETING;
+	if (!stat) {
+		vport->flags |= FC_VPORT_DELETED;
+		vport->fcfabric = NULL;
+		list_del(&vport->peers);
+		fcfabric->npiv_vports_inuse--;
+	}
+	spin_unlock_irqrestore(&vport->lock, flags);
+
+	fc_vport_free(vport);
+
+	if (stat)
+		return stat;
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
+static ssize_t store_fabric_vport_create(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct fc_fabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_vport_identifiers vid;
+	struct fc_vport *fcnport, *fcvport;
+	unsigned int cnt = count;
+	int stat;
+
+	fcnport = fc_fabric_find_nport(fcfabric);
+	if (!fcnport)
+		return -ENODEV;
+	put_device(&fcnport->dev); /* from find_nport */
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
+		      store_fabric_vport_create);
+
+struct fc_vport *fc_vport_lookup(struct fc_fabric *fcfabric,
+				 const u32 port_id)
+{
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	struct fc_vport *fcvport, *found = NULL;
+
+	mutex_lock(&fcport->lock);
+	list_for_each_entry(fcvport, &fcfabric->vports, peers) {
+		if (fcvport->port_id == port_id) {
+			found = fcvport;
+			break;
+		}
+	}
+	mutex_unlock(&fcport->lock);
+
+	return found;
+}
+EXPORT_SYMBOL(fc_vport_lookup);
+
+
+/*
+ * "Short-cut" sysfs variable to delete a vport on a FC Host.
+ * Vport is identified by a string containing "<WWPN>:<WWNN>".
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t store_fabric_vport_delete(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct fc_fabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	struct fc_vport *vport;
+	u64 wwpn, wwnn;
+	unsigned int cnt = count;
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
+	mutex_lock(&fcport->lock);
+	match = 0;
+	/* we only allow support on Channel 0 !!! */
+	list_for_each_entry(vport, &fcfabric->vports, peers) {
+		if ((vport->channel == 0) &&
+		    (vport->port_name == wwpn) &&
+		    (vport->node_name == wwnn) &&
+		    (!fc_vport_is_nport(vport))) {
+			match = 1;
+			break;
+		}
+	}
+	mutex_unlock(&fcport->lock);
+
+	if (!match)
+		return -ENODEV;
+
+	stat = fc_vport_terminate(fcfabric, vport);
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcfabric, vport_delete, S_IWUSR, NULL,
+		      store_fabric_vport_delete);
+
+/**
+ * fc_fabric_release() - Release the FC fabric memory
+ * @dev: Pointer to the fabric's embedded device
+ *
+ * Called when the last FC fabric reference is released.
+ */
+static void fc_fabric_release(struct device *dev)
+{
+	struct fc_fabric *fcfabric = dev_to_fcfabric(dev);
+	put_device(fcfabric->dev.parent);
+	fcfabric->dev.parent = NULL;
+	kfree(fcfabric);
+}
+
+/**
+ * fc_fabric_final_delete() - Final delete routine
+ * @work: The FC fabric's embedded work struct
+ *
+ * Flush any vport work on the fabric's devloss workqueue
+ * in case the fabric is being deleted somewhere else. Then
+ * delete the fabric's N_Port, which will in turn delete
+ * any FC vports on the fabric. Finally, remove the device
+ * from sysfs and drop the last reference.
+ *
+ * It is expected that the fabric has been removed from
+ * the FC port's list before calling this routine.
+ */
+static void fc_fabric_final_delete(struct work_struct *work)
+{
+	struct fc_fabric *fcfabric =
+		container_of(work, struct fc_fabric, delete_work);
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	struct fc_vport *fcvport;
+
+	/*
+	 * Cancel any outstanding timers. These should really exist
+	 * only when rmmod'ing the LLDD and we're asking for
+	 * immediate termination of the rports
+	 */
+	mutex_lock(&fcport->lock);
+	if (fcfabric->flags & FC_FABRIC_DEVLOSS_PENDING) {
+		mutex_unlock(&fcport->lock);
+		if (!cancel_delayed_work(&fcfabric->dev_loss_work))
+			fc_port_flush_devloss(fcport);
+		mutex_lock(&fcport->lock);
+		fcfabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+	}
+
+	/*
+	 * Deleting the N_Port will delete all NPIV vports too
+	 */
+	fcvport = fc_fabric_find_nport(fcfabric);
+	if (fcvport) {
+		fc_vport_del(fcvport);
+		put_device(&fcvport->dev); /* drop from find_nport */
+	}
+
+	mutex_unlock(&fcport->lock);
+
+	device_del(&fcfabric->dev);
+	put_device(&fcfabric->dev); /* self-reference */
+}
+
+/**
+ * fc_timeout_deleted_fabric() - Delete a fabric when the devloss timer fires
+ * @work: The FC fabric's embedded work struct
+ *
+ * Removes the fabric from the FC port's list of fabrics and
+ * queues the final deletion.
+ */
+static void fc_timeout_deleted_fabric(struct work_struct *work)
+{
+	struct fc_fabric *fcfabric =
+		container_of(work, struct fc_fabric, dev_loss_work.work);
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+
+	mutex_lock(&fcport->lock);
+
+	fcfabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+
+	if (fcfabric->state == FC_FABRICSTATE_CONNECTED) {
+		mutex_unlock(&fcport->lock);
+		return;
+	}
+
+	dev_printk(KERN_ERR, &fcfabric->dev,
+		   "FC fabric connection time out: removing fabric\n");
+
+	list_del(&fcfabric->peers);
+	fc_port_queue_work(fcport, &fcfabric->delete_work);
+
+	mutex_unlock(&fcport->lock);
+}
+
+/**
+ * fc_fabric_del() - Delete a FC fabric
+ * @fcfabric: Pointer to the fabric which is to be deleted
+ *
+ * Queues the FC fabric on the devloss workqueue
+ *
+ * Expects the FC port lock to be held (from age_fcfs - fcoe)
+ */
+void fc_fabric_del(struct fc_fabric *fcfabric)
+{
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	int timeout = fcfabric->dev_loss_tmo;
+
+	if (fcfabric->state != FC_FABRICSTATE_CONNECTED)
+		return;
+
+	fcfabric->state = FC_FABRICSTATE_DISCONNECTED;
+	fcfabric->flags |= FC_FABRIC_DEVLOSS_PENDING;
+
+	fc_port_queue_devloss_work(fcport, &fcfabric->dev_loss_work,
+				   timeout * HZ);
+}
+EXPORT_SYMBOL(fc_fabric_del);
+
+struct class fcfabric_class = {
+	.name = "fcfabric",
+	.dev_release = fc_fabric_release,
+};
+
+/**
+ * fc_fabric_add() - Add a FC fabric to sysfs
+ * @fcport:   The FC port that the fabric is to be added to
+ * @fcn_tmpl: The FC fabric function template
+ * @name:     The fabric name
+ *
+ * Expects the fcport lock to be held
+ */
+struct fc_fabric *fc_fabric_add(struct fc_port *fcport,
+				struct fc_fabric_function_template *fcn_tmpl,
+				struct fc_fabric *new_fcfabric)
+{
+	struct fc_fabric *fcfabric;
+	int error = 0;
+	int count = 0;
+	int size;
+
+	list_for_each_entry(fcfabric, &fcport->fabrics, peers) {
+		if (fcn_tmpl->fabric_match(new_fcfabric, fcfabric)) {
+			if (fcfabric->state == FC_FABRICSTATE_CONNECTED)
+				return fcfabric;
+
+			fcfabric->flags &= ~FC_FABRIC_DEVLOSS_PENDING;
+			fcfabric->state = FC_FABRICSTATE_CONNECTED;
+
+			if (!cancel_delayed_work(&fcfabric->dev_loss_work))
+				fc_port_flush_devloss(fcport);
+
+			return fcfabric;
+		}
+	}
+
+	size = (sizeof(struct fc_fabric) + fcn_tmpl->dd_fcfabric_size);
+	fcfabric = kzalloc(size, GFP_ATOMIC);
+	if (unlikely(!fcfabric))
+		goto out;
+
+	INIT_WORK(&fcfabric->delete_work, fc_fabric_final_delete);
+	INIT_DELAYED_WORK(&fcfabric->dev_loss_work, fc_timeout_deleted_fabric);
+
+	device_initialize(&fcfabric->dev);
+	fcfabric->dev.parent = get_device(&fcport->dev);
+	fcfabric->dev.class = &fcfabric_class;
+	fcfabric->f = fcn_tmpl;
+	fcfabric->id = atomic_inc_return(&fcfabric_num) - 1;
+	fcfabric->state = FC_FABRICSTATE_CONNECTED;
+
+	fcfabric->dev_loss_tmo = fcport->fab_dev_loss_tmo;
+
+	list_add_tail(&fcfabric->peers, &fcport->fabrics);
+
+	dev_set_name(&fcfabric->dev, "fcfabric_%d",
+		     fcfabric->id);
+
+	INIT_LIST_HEAD(&fcfabric->vports);
+
+	fcfabric->fabric_name = new_fcfabric->fabric_name;
+	fcfabric->max_npiv_vports = 0;
+	fcfabric->next_vport_number = 0;
+	fcfabric->npiv_vports_inuse = 0;
+
+	error = device_add(&fcfabric->dev);
+	if (error)
+		goto out_del;
+
+	FC_SETUP_COND_ATTR_RD(fcfabric, fabric_name);
+	FC_SETUP_COND_ATTR_RD(fcfabric, dev_loss_tmo);
+
+	FC_SETUP_ATTR_RD_NS(fcfabric, max_npiv_vports);
+	FC_SETUP_ATTR_RD_NS(fcfabric, npiv_vports_inuse);
+	FC_SETUP_ATTR_RW_NS(fcfabric, vport_create);
+	FC_SETUP_ATTR_RW_NS(fcfabric, vport_delete);
+
+	BUG_ON(count > FC_FABRIC_NUM_ATTRS);
+	FC_CREATE_ATTRS(fcfabric, count);
+
+	if (error || count != 0)
+		goto out_del_dev;
+
+	return fcfabric;
+
+out_del_dev:
+	device_del(&fcfabric->dev);
+	list_del(&fcfabric->peers);
+out_del:
+	put_device(&fcport->dev);
+	kfree(fcfabric);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fabric_add);
diff --git a/drivers/fc/fcport.c b/drivers/fc/fcport.c
new file mode 100644
index 0000000..e9dc2b7
--- /dev/null
+++ b/drivers/fc/fcport.c
@@ -0,0 +1,445 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+	u32			value;
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
+/* used by maxframe_size */
+/* used by serial_number */
+#define fc_port_rd_attr(field, format_string, sz)		\
+	fc_show_function(fc, port, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcport, field, S_IRUGO,		\
+			      show_port_##field, NULL)
+
+#define fc_port_store_str_function(field, slen)				\
+	static ssize_t store_port_##field(struct device *dev,		\
+					  struct device_attribute *attr, \
+					  const char *buf, size_t count) \
+	{								\
+		struct fc_port *fcport = dev_to_fcport(dev);		\
+		unsigned int cnt = count;				\
+									\
+		/* count may include a LF at end of string */		\
+		if (buf[cnt-1] == '\n')					\
+			cnt--;						\
+		if (cnt > ((slen) - 1))					\
+			return -EINVAL;					\
+		memcpy(fc_port_##field(fcport), buf, cnt);		\
+		fcport->f->set_fcport_##field(fcport);			\
+		return count;						\
+	}
+
+static int show_fc_fc4s(char *buf, u8 *fc4_list)
+{
+	int i, len = 0;
+
+	for (i = 0; i < FC_FC4_LIST_SIZE; i++, fc4_list++)
+		len += sprintf(buf + len , "0x%02x ", *fc4_list);
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+
+/* used by supported_fc4s */
+static ssize_t show_port_supported_fc4s(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+	return (ssize_t)show_fc_fc4s(buf, fc_port_supported_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, supported_fc4s, S_IRUGO,
+		      show_port_supported_fc4s, NULL);
+
+/* used by active_fc4s */
+static ssize_t show_port_active_fc4s(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+	if (fcport->f->get_fcport_active_fc4s)
+		fcport->f->get_fcport_active_fc4s(fcport);
+
+	return (ssize_t)show_fc_fc4s(buf, fc_port_active_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, active_fc4s, S_IRUGO,
+		      show_port_active_fc4s, NULL);
+
+/* used by speed */
+static ssize_t show_port_speed(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+
+	if (fcport->f->get_fcport_speed)
+		fcport->f->get_fcport_speed(fcport);
+
+	if (fc_port_speed(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fc_port_speed(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, speed, S_IRUGO, show_port_speed, NULL);
+
+fc_port_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_port_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE + 1));
+
+/* used by supported_speeds */
+static ssize_t show_port_supported_speeds(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+	if (fc_port_supported_speeds(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fc_port_supported_speeds(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_speeds, S_IRUGO,
+		      show_port_supported_speeds, NULL);
+
+/* used by supported_classes */
+static ssize_t show_port_supported_classes(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+
+	if (fc_port_supported_classes(fcport) == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+
+	return get_fc_cos_names(fc_port_supported_classes(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_classes, S_IRUGO,
+		      show_port_supported_classes, NULL);
+
+fc_show_function(fc, port, system_hostname, "%s\n",
+		 FC_SYMBOLIC_NAME_SIZE + 1, )
+
+fc_port_store_str_function(system_hostname, FC_SYMBOLIC_NAME_SIZE)
+static FC_DEVICE_ATTR(fcport, system_hostname, S_IRUGO | S_IWUSR,
+		      show_port_system_hostname,
+		      store_port_system_hostname);
+
+fc_show_function(fc, port, fab_dev_loss_tmo, "%d\n", 20, )
+static ssize_t store_port_fab_dev_loss_tmo(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+	int val;
+	char *cp;
+	val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || (val < 0))
+		return -EINVAL;
+
+	fcport->fab_dev_loss_tmo = val;
+	return count;
+}
+static FC_DEVICE_ATTR(fcport, fab_dev_loss_tmo, S_IRUGO | S_IWUSR,
+		      show_port_fab_dev_loss_tmo, store_port_fab_dev_loss_tmo);
+
+/**
+ * fc_port_release() - Release the FC port memory
+ * @dev: Pointer to the FC port's embedded device
+ *
+ * Called when the last FC port reference is released.
+ */
+static void fc_port_release(struct device *dev)
+{
+	struct fc_port *fcport = dev_to_fcport(dev);
+
+	put_device(fcport->dev.parent);
+	fcport->dev.parent = NULL;
+	kfree(fcport);
+}
+
+struct class fcport_class = {
+	.name = "fcport",
+	.dev_release = fc_port_release,
+};
+
+/**
+ * fc_port_del() - Delete a FC port and its subtree from sysfs
+ * @fcport: A pointer to the port to be deleted
+ *
+ * Deletes a FC port and any fabrics attached
+ * to it. Deleting fabrics will cause their childen
+ * to be deleted as well.
+ *
+ * The port is detached from sysfs and it's resources
+ * are freed (work q), but the memory is not freed
+ * until its last reference is released.
+ *
+ * This routine expects no locks to be held before
+ * calling.
+ */
+void fc_port_del(struct fc_port *fcport)
+{
+	struct fc_fabric *fcfabric, *next;
+
+	/* Remove any attached fabrics */
+	mutex_lock(&fcport->lock);
+	list_for_each_entry_safe(fcfabric, next,
+				 &fcport->fabrics, peers) {
+		list_del(&fcfabric->peers);
+		fcfabric->state = FC_FABRICSTATE_DISCONNECTED;
+		fc_port_queue_work(fcport, &fcfabric->delete_work);
+	}
+	mutex_unlock(&fcport->lock);
+
+	fc_port_flush_work(fcport);
+
+	destroy_workqueue(fcport->devloss_work_q);
+	fcport->devloss_work_q = NULL;
+	destroy_workqueue(fcport->work_q);
+	fcport->work_q = NULL;
+
+	device_del(&fcport->dev);
+	put_device(&fcport->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_port_del);
+
+/**
+ * fc_port_add() - Add a FC port to sysfs
+ * @pdev:     The parent device to which the FC port should be attached
+ * @fcn_tmpl: The FC port function template
+ * @fc4_f:    The FC4 function template for any vports created
+ *
+ * This routine allocates a FC port object with some additional memory
+ * for the LLD. The FC port is initialized, added to sysfs and then
+ * attributes are added to it.
+ */
+struct fc_port *fc_port_add(struct device *pdev,
+			    struct fc_port_function_template *fcn_tmpl,
+			    void *fc4_f)
+{
+	struct fc_port *fcport;
+	int count = 0;
+	int error = 0;
+
+	fcport = kzalloc(sizeof(struct fc_port) + fcn_tmpl->dd_fcport_size,
+			 GFP_KERNEL);
+	if (!fcport)
+		goto out;
+
+	fcport->id = atomic_inc_return(&fcport_num) - 1;
+	INIT_LIST_HEAD(&fcport->fabrics);
+	mutex_init(&fcport->lock);
+	device_initialize(&fcport->dev);
+	fcport->dev.parent = get_device(pdev);
+	fcport->dev.class = &fcport_class;
+	fcport->f = fcn_tmpl;
+	fcport->fc4_f = fc4_f;
+
+	snprintf(fcport->work_q_name, sizeof(fcport->work_q_name),
+		 "fcport_wq_%d", fcport->id);
+	fcport->work_q = create_singlethread_workqueue(
+		fcport->work_q_name);
+	if (!fcport->work_q)
+		goto out_del;
+
+	snprintf(fcport->devloss_work_q_name,
+		 sizeof(fcport->devloss_work_q_name),
+		 "fcport_dl_wq_%d", fcport->id);
+	fcport->devloss_work_q = create_singlethread_workqueue(
+		fcport->devloss_work_q_name);
+	if (!fcport->devloss_work_q)
+		goto out_del_q;
+
+	dev_set_name(&fcport->dev, "fcport_%d", fcport->id);
+	error = device_add(&fcport->dev);
+	if (error)
+		goto out_del_q2;
+
+	memset(fcport->system_hostname, 0, sizeof(fcport->system_hostname));
+	fcport->maxframe_size = -1;
+	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	fcport->speed = FC_PORTSPEED_UNKNOWN;
+	fcport->fab_dev_loss_tmo = 600; /* default to 10mins */
+	memset(fcport->supported_fc4s, 0,
+	       sizeof(fcport->supported_fc4s));
+	memset(fcport->active_fc4s, 0,
+	       sizeof(fcport->active_fc4s));
+	memset(fcport->serial_number, 0,
+	       sizeof(fcport->serial_number));
+
+	/*
+	 * system_hostname may be set through sysfs, but
+	 * not updated by the lld
+	 */
+	FC_SETUP_COND_ATTR_RW(fcport, system_hostname);
+	FC_SETUP_COND_ATTR_RW(fcport, fab_dev_loss_tmo);
+
+	FC_SETUP_COND_ATTR_RD(fcport, maxframe_size);
+	FC_SETUP_COND_ATTR_RD(fcport, supported_speeds);
+	FC_SETUP_COND_ATTR_RD(fcport, supported_fc4s);
+	FC_SETUP_COND_ATTR_RD(fcport, active_fc4s);
+	FC_SETUP_COND_ATTR_RD(fcport, supported_classes);
+	FC_SETUP_COND_ATTR_RD(fcport, serial_number);
+	FC_SETUP_COND_ATTR_RD(fcport, speed);
+
+	BUG_ON(count > FC_PORT_NUM_ATTRS);
+	FC_CREATE_ATTRS(fcport, count);
+
+	if (error || count != 0)
+		goto out_del_dev;
+
+	return fcport;
+
+out_del_dev:
+	device_del(&fcport->dev);
+out_del_q2:
+	destroy_workqueue(fcport->devloss_work_q);
+	fcport->devloss_work_q = NULL;
+out_del_q:
+	destroy_workqueue(fcport->work_q);
+	fcport->work_q = NULL;
+out_del:
+	put_device(pdev);
+	kfree(fcport);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_port_add);
+
+/**
+ * fc_port_del_fabrics() - Delete all fabrics on a FC port
+ * @fcport: The port whose fabrics are to be deleted
+ *
+ * Goes through a FC port's list of fabrics and queues
+ * a device loss deletion for each fabric. The devloss
+ * queue can be flushed after calling this routine to
+ * expediate the deletion.
+ *
+ * This routine expects the FC port's mutex to be locked.
+ */
+void fc_port_del_fabrics(struct fc_port *fcport)
+{
+	struct fc_fabric *fcfabric, *next_fcfabric;
+
+	list_for_each_entry_safe(fcfabric, next_fcfabric,
+				 &fcport->fabrics, peers) {
+
+		if (fcfabric->flags & FC_FABRIC_DEVLOSS_PENDING)
+			continue;
+
+		fcfabric->state = FC_FABRICSTATE_DISCONNECTED;
+		fcfabric->flags |= FC_FABRIC_DEVLOSS_PENDING;
+		fc_port_queue_devloss_work(fcport, &fcfabric->dev_loss_work,
+					   fcfabric->dev_loss_tmo * HZ);
+	}
+}
+EXPORT_SYMBOL(fc_port_del_fabrics);
+
+/**
+ * fc_port_flush_work() - Flush a FC port's workqueue
+ * @fcport: Pointer to the FC port whose workqueue is to be flushed
+ */
+void fc_port_flush_work(struct fc_port *fcport)
+{
+	if (!fc_port_work_q(fcport)) {
+		printk(KERN_ERR
+		       "ERROR: FC Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fc_port_work_q(fcport));
+}
+
+/**
+ * fc_port_queue_work() - Schedule work for a FC port's workqueue
+ * @fcport: Pointer to the FC port who owns the devloss workqueue
+ * @work:   Work to queue for execution
+ *
+ * Return value:
+ *      1 on success / 0 already queued / < 0 for error
+ */
+int fc_port_queue_work(struct fc_port *fcport, struct work_struct *work)
+{
+	if (unlikely(!fc_port_work_q(fcport))) {
+		printk(KERN_ERR
+		       "ERROR: FC Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(fc_port_work_q(fcport), work);
+}
+
+/**
+ * fc_port_flush_devloss() - Flush a FC port's devloss workqueue
+ * @fcport: Pointer to FC port whose workqueue is to be flushed
+ */
+void fc_port_flush_devloss(struct fc_port *fcport)
+{
+	if (!fc_port_devloss_work_q(fcport)) {
+		printk(KERN_ERR
+		       "ERROR: FC Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fc_port_devloss_work_q(fcport));
+}
+
+/**
+ * fc_port_queue_devloss_work() - Schedule work for a FC port's devloss workqueue
+ * @fcport: Pointer to the FC port who owns the devloss workqueue
+ * @work:   Work to queue for execution
+ * @delay:  jiffies to delay the work queuing
+ *
+ * Return value:
+ *      1 on success / 0 already queued / < 0 for error
+ */
+int fc_port_queue_devloss_work(struct fc_port *fcport,
+			       struct delayed_work *work,
+			       unsigned long delay)
+{
+	if (unlikely(!fc_port_devloss_work_q(fcport))) {
+		printk(KERN_ERR
+		       "ERROR: FC Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_delayed_work(fc_port_devloss_work_q(fcport), work, delay);
+}
diff --git a/drivers/fc/fcrport.c b/drivers/fc/fcrport.c
new file mode 100644
index 0000000..4fa6dff
--- /dev/null
+++ b/drivers/fc/fcrport.c
@@ -0,0 +1,1012 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+/*
+ * TODO: This is dup from scsi_priv.h. We should get it from
+ * whatever FC4 is being transported. For now it should be fine
+ * to use a singular value.
+ */
+#define FC_DEVICE_BLOCK_MAX_TIMEOUT   600     /* units in seconds */
+
+static void fc_timeout_deleted_rport(struct work_struct *work);
+static void fc_timeout_fail_rport_io(struct work_struct *work);
+
+/**
+ * fc_rport_dev_release() - Free the FC rport's memory
+ * @dev: The FC rport's embedded device
+ */
+static void fc_rport_dev_release(struct device *dev)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+	kfree(rport);
+}
+
+#define fc_rport_show_function(field, format_string, sz, cast)		\
+	static ssize_t							\
+	show_fc_rport_##field(struct device *dev,			\
+			      struct device_attribute *attr, char *buf) \
+	{								\
+		struct fc_rport *rport = dev_to_fcrport(dev);		\
+		if ((rport->f->get_rport_##field) &&			\
+		    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||	\
+		      (rport->port_state == FC_PORTSTATE_DELETED) ||	\
+		      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))	\
+			rport->f->get_rport_##field(rport);		\
+		return snprintf(buf, sz, format_string, cast rport->field); \
+	}
+
+#define fc_rport_store_function(field)					\
+	static ssize_t							\
+	store_fc_rport_##field(struct device *dev,			\
+			       struct device_attribute *attr,		\
+			       const char *buf,	size_t count)		\
+	{								\
+		int val;						\
+		struct fc_rport *rport = dev_to_fcrport(dev);		\
+		char *cp;						\
+		if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||	\
+		    (rport->port_state == FC_PORTSTATE_DELETED) ||	\
+		    (rport->port_state == FC_PORTSTATE_NOTPRESENT))	\
+			return -EBUSY;					\
+		val = simple_strtoul(buf, &cp, 0);			\
+		if (*cp && (*cp != '\n'))				\
+			return -EINVAL;					\
+		rport->f->set_rport_##field(rport, val);		\
+		return count;						\
+	}
+
+static ssize_t show_fc_rport_supported_classes(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+	if (rport->supported_classes == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+	return get_fc_cos_names(rport->supported_classes, buf);
+}
+static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
+		      show_fc_rport_supported_classes, NULL);
+
+
+fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t store_fc_rport_dev_loss_tmo(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int val;
+	struct fc_rport *rport = dev_to_fcrport(dev);
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
+static ssize_t show_fc_rport_roles(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+
+	/* identify any roles that are port_id specific */
+	if ((rport->port_id != -1) &&
+	    (rport->port_id & FC_WELLKNOWN_PORTID_MASK) ==
+	    FC_WELLKNOWN_PORTID_MASK) {
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
+#define fc_rport_rd_enum_attr(title, maxlen)				\
+	static ssize_t show_rport_##title(struct device *dev,		\
+					  struct device_attribute *attr, \
+					  char *buf)			\
+	{								\
+		struct fc_rport *rport = dev_to_fcrport(dev);		\
+		const char *name;					\
+		name = get_fc_##title##_name(fc_rport_##title(rport));	\
+		if (!name)						\
+			return -EINVAL;					\
+		return snprintf(buf, maxlen, "%s\n", name);		\
+	}								\
+	static FC_DEVICE_ATTR(rport, title, S_IRUGO,			\
+			      show_rport_##title, NULL)
+
+fc_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+
+#define fc_rport_rw_attr(field, format_string, sz)		\
+	fc_show_function(fc, rport, field, format_string, sz, )	\
+	rport_store_function(field)				\
+	static FC_DEVICE_ATTR(rport, field, S_IRUGO,		\
+			      show_rport_##field,		\
+			      store_rport_##field)
+
+#define fc_rport_rd_attr(field, format_string, sz)		\
+	fc_show_function(fc, rport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(rport, field, S_IRUGO,		\
+			      show_rport_##field, NULL)
+
+#define fc_rport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_show_function(fc, rport, field, format_string, sz, (cast))	\
+	static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
+			      show_rport_##field, NULL)
+
+fc_rport_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_rport_rd_attr(port_id, "0x%06x\n", 20);
+fc_rport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_rport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+/*
+ * fast_io_fail_tmo attribute
+ */
+static ssize_t show_fc_rport_fast_io_fail_tmo(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+
+	if (rport->fast_io_fail_tmo == -1)
+		return snprintf(buf, 5, "off\n");
+	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
+}
+
+static ssize_t store_fc_rport_fast_io_fail_tmo(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf,
+					       size_t count)
+{
+	int val;
+	char *cp;
+	struct fc_rport *rport = dev_to_fcrport(dev);
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
+/**
+ * fc_rport_final_delete() - finish rport termination and delete it.
+ * @work:	remote port to be deleted.
+ */
+static void fc_rport_final_delete(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, rport_delete_work);
+	struct device *dev = &rport->dev;
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	unsigned long flags;
+	int do_callback = 0;
+
+	/*
+	 * if a scan is pending, flush the SCSI Host work_q so that
+	 * that we can reclaim the rport scan work element.
+	 */
+	if (rport->flags & FC_RPORT_SCAN_PENDING) {
+		if (fcvport->fc4_f)
+			fcvport->fc4_f->fc4_init_scsi_flush_work(fcvport);
+	}
+
+	if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+		fcvport->fc4_f->fc4_targ_terminate_io(rport);
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
+			fc_vport_flush_devloss(fcvport);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_vport_flush_devloss(fcvport);
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
+	device_del(dev);
+	put_device(dev->parent);
+	dev->parent = NULL;
+	put_device(dev);	/* for self-reference */
+}
+
+/**
+ * fc_rport_create() - Allocate and add a FC remote port to sysfs.
+ * @fcvport: The vport on which the rport was discovered
+ * @f:       The rport function template
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
+static struct fc_rport *fc_rport_create(struct fc_vport *fcvport,
+					struct fc_rport_function_template *f,
+					int channel,
+					struct fc_rport_identifiers *ids)
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
+	if (unlikely(!rport))
+		goto out;
+
+	rport->f = f;
+
+	rport->maxframe_size = -1;
+	rport->supported_classes = FC_COS_UNSPECIFIED;
+	rport->dev_loss_tmo = fc_vport_rport_dev_loss_tmo(fcvport);
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
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	dev = &rport->dev;
+	device_initialize(dev); /* takes self reference */
+	dev->parent = get_device(&fcvport->dev); /* parent reference */
+	dev->bus = &fc_rport_bus_type;
+	dev->release = fc_rport_dev_release;
+	dev_set_name(dev, "rport-%d:%d-%d",
+		     fcvport->id, channel, rport->number);
+	error = device_add(dev);
+	if (error)
+		goto out_del;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	list_add_tail(&rport->peers, &fcvport->rports);
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * Setup attributes
+	 */
+	FC_SETUP_ATTR_RW_NS(rport, fast_io_fail_tmo);
+	FC_SETUP_ATTR_RD_NS(rport, port_id);
+	FC_SETUP_ATTR_RD_NS(rport, port_state);
+	FC_SETUP_ATTR_RD_NS(rport, roles);
+	FC_SETUP_ATTR_RD_NS(rport, node_name);
+	FC_SETUP_ATTR_RD_NS(rport, port_name);
+	FC_SETUP_ATTR_RD_NS(rport, supported_classes);
+	FC_SETUP_ATTR_RD_NS(rport, maxframe_size);
+	FC_SETUP_ATTR_RW_NS(rport, dev_loss_tmo);
+
+	BUG_ON(count > FC_RPORT_NUM_ATTRS);
+	FC_CREATE_ATTRS(rport, count);
+	if (error || count != 0)
+		goto out_del_dev;
+
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
+		/* initiate a scan of the target */
+		rport->flags |= FC_RPORT_SCAN_PENDING;
+		if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			fcvport->fc4_f->fc4_targ_queue_scan(rport);
+	}
+
+	return rport;
+
+out_del_dev:
+	device_del(&fcvport->dev);
+	spin_lock_irqsave(&fcvport->lock, flags);
+	list_del(&rport->peers);
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+out_del:
+	put_device(dev->parent);
+	kfree(rport);
+out:
+	return NULL;
+}
+
+/**
+ * fc_rport_add() - notify fc transport of the existence of a remote FC port.
+ * @fcvport: The FC vport that the rport was discovered on
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
+struct fc_rport *fc_rport_add(struct fc_vport *fcvport,
+			      struct fc_rport_identifiers *ids)
+{
+	struct fc_rport *rport;
+	struct fc_rport_function_template *f = &fcvport->f->fcrport_f;
+
+	unsigned long flags;
+	int match = 0;
+
+	/* ensure any stgt delete functions are done */
+	fc_vport_flush_work(fcvport);
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
+		    (rport->channel == fcvport->channel)) {
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
+				memcpy(&rport->node_name, &ids->node_name,
+				       sizeof(rport->node_name));
+				memcpy(&rport->port_name, &ids->port_name,
+				       sizeof(rport->port_name));
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
+				if ((!dev_get_drvdata(&rport->dev)) &&
+				    (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)))
+					return rport;
+
+				/*
+				 * Stop the fail io and dev_loss timers.
+				 * If they flush, the port_state will
+				 * be checked and will NOOP the function.
+				 */
+				if (!cancel_delayed_work(&rport->fail_io_work))
+					fc_vport_flush_devloss(fcvport);
+				if (!cancel_delayed_work(&rport->dev_loss_work))
+					fc_vport_flush_devloss(fcvport);
+
+				spin_lock_irqsave(&fcvport->lock, flags);
+
+				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+						  FC_RPORT_DEVLOSS_PENDING |
+						  FC_RPORT_DEVLOSS_CALLBK_DONE);
+
+				/* if target, initiate a scan */
+				if (dev_get_drvdata(&rport->dev)) {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					if (fcvport->fc4_f &&
+					    (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+						fcvport->fc4_f->fc4_targ_queue_scan(rport);
+					spin_unlock_irqrestore(&fcvport->lock,
+							       flags);
+
+					if (fcvport->fc4_f &&
+					    (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+						fcvport->fc4_f->fc4_targ_unblock(rport);
+				} else
+					spin_unlock_irqrestore(&fcvport->lock,
+							       flags);
+
+				if (fcvport->fc4_f &&
+				    (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+					fcvport->fc4_f->fc4_bsg_goose_queue(rport);
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
+			if (rport->channel != fcvport->channel)
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
+			       sizeof(rport->node_name));
+			memcpy(&rport->port_name, &ids->port_name,
+			       sizeof(rport->port_name));
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
+				if (fcvport->fc4_f &&
+				    (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+					fcvport->fc4_f->fc4_targ_queue_scan(rport);
+
+				spin_unlock_irqrestore(&fcvport->lock, flags);
+				if (fcvport->fc4_f &&
+				    (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+					fcvport->fc4_f->fc4_targ_unblock(rport);
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
+	rport = fc_rport_create(fcvport, f, fcvport->channel, ids);
+
+	return rport;
+}
+EXPORT_SYMBOL(fc_rport_add);
+
+/**
+ * fc_rport_del() - notifies the fc transport that a remote port is no longer in existence.
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
+ *   fc_rport_add()) within the dev_loss_tmo timeout, then the
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
+void fc_rport_del(struct fc_rport *rport)
+{
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
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
+	if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
+		fcvport->fc4_f->fc4_targ_final_delete(rport);
+		fcvport->fc4_f->fc4_targ_block(rport);
+	}
+
+	/* see if we need to kill io faster than waiting for device loss */
+	if ((rport->fast_io_fail_tmo != -1) &&
+	    (rport->fast_io_fail_tmo < timeout))
+		fc_vport_queue_devloss_work(fcvport, &rport->fail_io_work,
+					    rport->fast_io_fail_tmo * HZ);
+
+	/* cap the length the devices can be blocked until they are deleted */
+	fc_vport_queue_devloss_work(fcvport, &rport->dev_loss_work,
+				    timeout * HZ);
+}
+EXPORT_SYMBOL(fc_rport_del);
+
+/**
+ * fc_rport_rolechg() - notifies the fc transport that the roles on a remote may have changed.
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
+void fc_rport_rolechg(struct fc_rport *rport, u32 roles)
+{
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	unsigned long flags;
+	int create = 0;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+		create = fcvport->fc4_f->fc4_targ_rolechg(rport, roles);
+	rport->roles = roles;
+
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
+			fc_vport_flush_devloss(fcvport);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_vport_flush_devloss(fcvport);
+
+		spin_lock_irqsave(&fcvport->lock, flags);
+		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+				  FC_RPORT_DEVLOSS_PENDING);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+
+		/* ensure any stgt delete functions are done */
+		fc_vport_flush_work(fcvport);
+
+		/* initiate a scan of the target */
+		spin_lock_irqsave(&fcvport->lock, flags);
+		rport->flags |= FC_RPORT_SCAN_PENDING;
+		if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			fcvport->fc4_f->fc4_targ_queue_scan(rport);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			fcvport->fc4_f->fc4_targ_unblock(rport);
+	}
+}
+EXPORT_SYMBOL(fc_rport_rolechg);
+
+/**
+ * fc_timeout_deleted_rport() - Timeout handler for a deleted remote port.
+ * @work:	rport target that failed to reappear in the allotted time.
+ *
+ * Description: An attempt to delete a remote port blocks, and if it fails
+ *              to return in the allotted time this gets called.
+ */
+static void fc_timeout_deleted_rport(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, dev_loss_work.work);
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
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
+			   "blocked FC remote port time out: no longer"
+			   " a FCP target, removing starget\n");
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		if (fcvport->fc4_f &&
+		    (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
+			fcvport->fc4_f->fc4_targ_unblock(rport);
+			fcvport->fc4_f->fc4_queue_starget_delete(rport);
+		}
+		return;
+	}
+
+	/* NOOP state - we're flushing workq's */
+	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		dev_printk(KERN_ERR, &rport->dev,
+			   "blocked FC remote port time out: leaving"
+			   " rport%s alone\n",
+			   (dev_get_drvdata(&rport->dev)) ?
+			   " and starget" : "");
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
+			   (dev_get_drvdata(&rport->dev)) ?
+			   " and starget" : "");
+		fc_vport_queue_work(fcvport, &rport->rport_delete_work);
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		return;
+	}
+
+	dev_printk(KERN_ERR, &rport->dev,
+		   "blocked FC remote port time out: removing target and "
+		   "saving binding\n");
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
+	if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+		fcvport->fc4_f->fc4_targ_terminate_io(rport);
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) { /* still missing */
+
+		/*
+		 * remove the identifiers that aren't used
+		 * in the consisting binding
+		 */
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
+		if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			fcvport->fc4_f->fc4_queue_starget_delete(rport);
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
+ * fc_timeout_fail_rport_io() - Timeout handler for a fast io failing on
+ *                              a disconnected SCSI target.
+ * @work:	rport to terminate io on.
+ *
+ * Notes: Only requests the failure of the io, not that all are flushed
+ *    prior to returning.
+ */
+static void fc_timeout_fail_rport_io(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, fail_io_work.work);
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+
+	if (rport->port_state != FC_PORTSTATE_BLOCKED)
+		return;
+
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
+	if (fcvport->fc4_f && (rport->roles & FC_PORT_ROLE_FCP_TARGET))
+		fcvport->fc4_f->fc4_targ_terminate_io(rport);
+}
+
+static int fc_rport_bus_match(struct device *dev,
+			      struct device_driver *drv);
+
+struct bus_type fc_rport_bus_type = {
+	.name = "fc_rport",
+	.match = fc_rport_bus_match,
+};
+EXPORT_SYMBOL(fc_rport_bus_type);
+
+static int fc_rport_bus_match(struct device *dev,
+			      struct device_driver *drv)
+{
+	if (dev->bus == &fc_rport_bus_type)
+		return 1;
+	return 0;
+}
+
+int fc_rport_bus_register(void)
+{
+	return bus_register(&fc_rport_bus_type);
+}
+
+void fc_rport_bus_unregister(void)
+{
+	bus_unregister(&fc_rport_bus_type);
+}
diff --git a/drivers/fc/fcsysfs.c b/drivers/fc/fcsysfs.c
new file mode 100644
index 0000000..3649e2c
--- /dev/null
+++ b/drivers/fc/fcsysfs.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+ */
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
+	error = fc_vport_bus_register();
+	if (error)
+		goto unreg_fcfabric;
+
+	error = fc_rport_bus_register();
+	if (error)
+		goto unreg_vport_bus;
+
+	return 0;
+
+unreg_vport_bus:
+	fc_vport_bus_unregister();
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
+	fc_rport_bus_unregister();
+	fc_vport_bus_unregister();
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
+fc_enum_name_search(fc, port_type, fc_port_type, fc_port_type_names)
+EXPORT_SYMBOL(get_fc_port_type_name);
+fc_enum_name_search(fc, vport_type, fc_port_type, fc_port_type_names)
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
+fc_enum_name_search(fc, port_state, fc_port_state, fc_port_state_names)
+EXPORT_SYMBOL(get_fc_port_state_name);
+
+static struct {
+	enum fc_vport_state value;
+	char                *name;
+} fc_vport_state_names[] = {
+	{ FC_VPORT_ACTIVE,          "Active" },
+	{ FC_VPORT_DISABLED,        "Disabled" },
+	{ FC_VPORT_INITIALIZING,    "Initializing" },
+	{ FC_VPORT_NO_FABRIC_SUPP,  "No Fabric Support" },
+	{ FC_VPORT_NO_FABRIC_RSCS,  "No Fabric Resources" },
+	{ FC_VPORT_FABRIC_LOGOUT,   "Fabric Logout" },
+	{ FC_VPORT_FABRIC_REJ_WWN,  "Fabric Rejected WWN" },
+	{ FC_VPORT_FAILED,          "VPort Failed" },
+};
+fc_enum_name_search(fc, vport_state, fc_vport_state, fc_vport_state_names)
+EXPORT_SYMBOL(get_fc_vport_state_name);
diff --git a/drivers/fc/fcsysfs.h b/drivers/fc/fcsysfs.h
new file mode 100644
index 0000000..9bd7936
--- /dev/null
+++ b/drivers/fc/fcsysfs.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+#define fc_bitfield_name_search(title, table)				\
+	ssize_t get_fc_##title##_names(u32 table_key, char *buf)	\
+	{								\
+		char *prefix = "";					\
+		ssize_t len = 0;					\
+		int i;							\
+									\
+		for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+			if (table[i].value & table_key) {		\
+				len += sprintf(buf + len, "%s%s",	\
+					       prefix, table[i].name);	\
+				prefix = ", ";				\
+			}						\
+		}							\
+		len += sprintf(buf + len, "\n");			\
+		return len;						\
+	}
+
+/*
+ * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
+ */
+#define FC_WELLKNOWN_PORTID_MASK        0xfffff0
+#define FC_WELLKNOWN_ROLE_MASK          0x00000f
+#define FC_FPORT_PORTID                 0x00000e
+#define FC_FABCTLR_PORTID               0x00000d
+#define FC_DIRSRVR_PORTID               0x00000c
+#define FC_TIMESRVR_PORTID              0x00000b
+#define FC_MGMTSRVR_PORTID              0x00000a
+
+extern struct class fcport_class;
+extern struct class fcfabric_class;
+extern struct class fcvport_class;
+extern struct class fcrport_class;
+
+extern unsigned int fc_dev_loss_tmo;
+
+extern struct fc4_template *fc4s[NUM_FC4S];
+
+int fc_vport_terminate(struct fc_fabric *, struct fc_vport *vport);
+
+void fc_vport_flush_devloss(struct fc_vport *fcvport);
+int fc_vport_queue_devloss_work(struct fc_vport *fcvport,
+				struct delayed_work *work,
+				unsigned long delay);
+void fc_port_flush_devloss(struct fc_port *fcport);
+int fc_port_queue_devloss_work(struct fc_port *fcport,
+			       struct delayed_work *work,
+			       unsigned long delay);
+void fc_port_flush_work(struct fc_port *fcport);
+int fc_port_queue_work(struct fc_port *fcport, struct work_struct *work);
+
+int fc_vport_bus_register(void);
+void fc_vport_bus_unregister(void);
+int fc_rport_bus_register(void);
+void fc_rport_bus_unregister(void);
+
+#define FC_PORTTYPE_MAX_NAMELEN		50
+const char *get_fc_port_type_name(enum fc_port_type table_key);
+ssize_t get_fc_port_roles_names(u32 table_key, char *buf);
+ssize_t get_fc_cos_names(u32 table_key, char *buf);
+
+const char *get_fc_port_state_name(enum fc_port_state table_key);
+/* Reuse fc_port_state enum function for port_last_state */
+#define get_fc_port_last_state_name get_fc_port_state_name
+
+const char *get_fc_vport_state_name(enum fc_vport_state table_key);
+
+#endif /*_FC_SYSFS_H_*/
diff --git a/drivers/fc/fcvport.c b/drivers/fc/fcvport.c
new file mode 100644
index 0000000..3dcfb49
--- /dev/null
+++ b/drivers/fc/fcvport.c
@@ -0,0 +1,687 @@
+/*
+ * Copyright(c) 2011 Intel Corporation. All rights reserved.
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
+/* used by node_name */
+/* used by port_name */
+/* used by permanaent_port_name */
+#define fc_vport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_show_function(fc, vport, field, format_string, sz, (cast))	\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_vport_##field, NULL)
+
+/*
+ * TODO: Notce that we're still using get_fc_##title##_name and not
+ * a get_vport_##title##_name routine. The port_type structure,
+ * related lookups and names need to be somewhere global for rports
+ * and other fc_host obects.
+ */
+
+/* used by port_state */
+/*
+ * TODO: Can't port_state use a fc_vport_update_show_function?
+ *       No- because it's enum specific, but are there enough
+ *       rd_enum_attr routines that there should be a common
+ *       fc_update_rd_enum_attr?
+ */
+#define fc_vport_update_rd_enum_attr(title, maxlen)			\
+	static ssize_t show_vport_##title(struct device *dev,		\
+					  struct device_attribute *attr, \
+					  char *buf)			\
+	{								\
+		struct fc_vport *fcvport = dev_to_fcvport(dev);		\
+		const char *name;					\
+		if (fcvport->f->get_fcvport_##title)			\
+			fcvport->f->get_fcvport_##title(fcvport);	\
+		name = get_fc_##title##_name(fc_vport_##title(fcvport)); \
+		if (!name)						\
+			return -EINVAL;					\
+		return snprintf(buf, maxlen, "%s\n", name);		\
+	}								\
+	static FC_DEVICE_ATTR(fcvport, title, S_IRUGO, show_vport_##title, NULL)
+
+#define fc_vport_store_function(field)					\
+	static ssize_t store_vport_##field(struct device *dev,		\
+					   struct device_attribute *attr, \
+					   const char *buf, size_t count) \
+	{								\
+		int val;						\
+		struct fc_vport *vport = dev_to_vport(dev);		\
+		char *cp;						\
+		if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+			return -EBUSY;					\
+		val = simple_strtoul(buf, &cp, 0);			\
+		if (*cp && (*cp != '\n'))				\
+			return -EINVAL;					\
+		vport->f->set_vport_##field(vport, val);		\
+		return count;						\
+	}
+
+#define fc_vport_store_str_function(field, slen)			\
+	static ssize_t store_vport_##field(struct device *dev,		\
+					   struct device_attribute *attr, \
+					   const char *buf, size_t count) \
+	{								\
+		struct fc_vport *fcvport = dev_to_fcvport(dev);		\
+		unsigned int cnt = count;				\
+									\
+		/* count may include a LF at end of string */		\
+		if (buf[cnt-1] == '\n')					\
+			cnt--;						\
+		if (cnt > ((slen) - 1))					\
+			return -EINVAL;					\
+		memcpy(fcvport->field, buf, cnt);			\
+		fcvport->f->set_fcvport_##field(fcvport);		\
+		return count;						\
+	}
+
+/* used by port_id */
+#define fc_vport_update_rd_attr(field, format_string, sz)		\
+	fc_update_show_function(fc, vport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_vport_##field, NULL)
+
+/* used by port_last_state */
+#define fc_vport_rd_enum_attr(title, maxlen)				\
+	static ssize_t show_vport_##title(struct device *dev,		\
+					  struct device_attribute *attr, \
+					  char *buf)			\
+	{								\
+		struct fc_vport *fcvport = dev_to_fcvport(dev);		\
+		const char *name;					\
+		name = get_fc_##title##_name(fcvport->title);		\
+		if (!name)						\
+			return -EINVAL;					\
+		return snprintf(buf, maxlen, "%s\n", name);		\
+	}								\
+	static FC_DEVICE_ATTR(fcvport, title, S_IRUGO,			\
+			      show_vport_##title, NULL)
+
+fc_vport_rd_enum_attr(vport_state, FC_VPORT_MAX_NAMELEN);
+fc_vport_update_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+fc_vport_rd_enum_attr(port_last_state, FC_PORTSTATE_MAX_NAMELEN);
+fc_vport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_vport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+fc_vport_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
+		      unsigned long long);
+
+static ssize_t show_vport_roles(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+
+	if (fcvport->roles == FC_PORT_ROLE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	return get_fc_port_roles_names(fcvport->roles, buf);
+}
+static FC_DEVICE_ATTR(fcvport, roles, S_IRUGO, show_vport_roles, NULL);
+
+fc_show_function(fc, vport, symbolic_name, "%s\n",
+		 FC_VPORT_SYMBOLIC_NAMELEN + 1, )
+fc_vport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
+static FC_DEVICE_ATTR(fcvport, symbolic_name, S_IRUGO | S_IWUSR,
+		      show_vport_symbolic_name, store_vport_symbolic_name);
+
+static ssize_t store_vport_issue_lip(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	int ret;
+
+	/* ignore any data value written to the attribute */
+	if (fcvport->f->issue_fcvport_lip) {
+		ret = fcvport->f->issue_fcvport_lip(fcvport);
+		return ret ? ret : count;
+	}
+
+	return -ENOENT;
+}
+
+static FC_DEVICE_ATTR(fcvport, issue_lip, S_IWUSR, NULL,
+		      store_vport_issue_lip);
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
+fc_enum_name_search(fc, tgtid_bind_type, fc_tgtid_binding_type,
+		    fc_tgtid_binding_type_names)
+fc_enum_name_match(tgtid_bind_type, fc_tgtid_binding_type,
+		   fc_tgtid_binding_type_names)
+#define FC_BINDTYPE_MAX_NAMELEN	30
+
+static ssize_t show_vport_tgtid_bind_type(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	const char *name;
+
+	name = get_fc_tgtid_bind_type_name(fc_vport_tgtid_bind_type(fcvport));
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FC_BINDTYPE_MAX_NAMELEN, "%s\n", name);
+}
+
+#define get_list_head_entry(pos, head, member)			\
+	pos = list_entry((head)->next, typeof(*pos), member)
+
+static ssize_t store_vport_tgtid_bind_type(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	struct fc_rport *rport;
+	enum fc_tgtid_binding_type val;
+	unsigned long flags;
+
+	if (get_fc_tgtid_bind_type_match(buf, &val))
+		return -EINVAL;
+
+	/* if changing bind type, purge all unused consistent bindings */
+	if (val != fc_vport_tgtid_bind_type(fcvport)) {
+		spin_lock_irqsave(&fcvport->lock, flags);
+		while (!list_empty(&fc_vport_rport_bindings(fcvport))) {
+			get_list_head_entry(rport,
+					    &fc_vport_rport_bindings(fcvport),
+					    peers);
+			list_del(&rport->peers);
+			rport->port_state = FC_PORTSTATE_DELETED;
+			fc_vport_queue_work(fcvport, &rport->rport_delete_work);
+		}
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+	}
+
+	fc_vport_tgtid_bind_type(fcvport) = val;
+	return count;
+}
+
+static FC_DEVICE_ATTR(fcvport, tgtid_bind_type, S_IRUGO | S_IWUSR,
+		      show_vport_tgtid_bind_type,
+		      store_vport_tgtid_bind_type);
+
+static ssize_t store_fc_vport_delete(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+
+	fc_vport_queue_work(fcvport, &fcvport->vport_delete_work);
+	return count;
+}
+static FC_DEVICE_ATTR(fcvport, vport_delete, S_IWUSR,
+		      NULL, store_fc_vport_delete);
+
+/*
+ * Enable/Disable vport
+ *  Write "1" to disable, write "0" to enable
+ */
+static ssize_t store_fc_vport_disable(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	int stat;
+
+	if (fcvport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+		return -EBUSY;
+
+	/*
+	 * TODO: This PORTSTATE_DISABLED is a hack, I somehow
+	 * broke this when I merged the two port states.
+	 */
+
+	if (*buf == '0') {
+		if (fcvport->port_state != FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else if (*buf == '1') {
+		if (fcvport->port_state == FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else
+		return -EINVAL;
+
+	stat = fcvport->f->vport_disable(fcvport,
+					 ((*buf == '0') ? false : true));
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcvport, vport_disable, S_IWUSR,
+		      NULL, store_fc_vport_disable);
+
+fc_vport_update_rd_attr(port_id, "0x%06x\n", 20);
+fc_vport_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
+
+/**
+ * fc_vport_release() - Release the FC vport memory
+ * @dev: Pointer to the vport's embedded device
+ *
+ * Called when the last FC vport reference is released.
+ */
+static void fc_vport_release(struct device *dev)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+
+	struct workqueue_struct *work_q;
+
+	fc_vport_flush_work(fcvport);
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
+	kfree(fcvport);
+}
+
+/**
+ * fc_vport_del() - Delete a FC vport
+ * @fcvport: The FC vport to be deleted
+ *
+ * If the FC vport is an N_Port then delete any NPIV vports
+ * associated with it. Delete any rports discovered on this
+ * vport and then detach the vport from sysfs. The final
+ * reference release is done in fc_vport_free().
+ */
+void fc_vport_del(struct fc_vport *fcvport)
+{
+	struct fc_fabric *fcfabric = fcvport_to_fcfabric(fcvport);
+	struct fc_vport *vport = NULL, *next_vport = NULL;
+	struct fc_rport *rport = NULL, *next_rport = NULL;
+	unsigned long flags;
+
+	if (!fc_vport_added(fcvport))
+		return;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	if (fc_vport_is_nport(fcvport)) {
+		/* Remove any vports */
+		list_for_each_entry_safe(vport, next_vport,
+					 &fcfabric->vports, peers) {
+			fc_vport_queue_work(fcvport, &vport->vport_delete_work);
+		}
+	}
+
+	/* Remove any remote ports */
+	list_for_each_entry_safe(rport, next_rport,
+				 &fcvport->rports, peers) {
+		list_del(&rport->peers);
+		rport->port_state = FC_PORTSTATE_DELETED;
+		fc_vport_queue_work(fcvport, &rport->rport_delete_work);
+	}
+
+	list_for_each_entry_safe(rport, next_rport,
+				 &fcvport->rport_bindings, peers) {
+		list_del(&rport->peers);
+		rport->port_state = FC_PORTSTATE_DELETED;
+		fc_vport_queue_work(fcvport, &rport->rport_delete_work);
+	}
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	fc_vport_flush_work(fcvport);
+
+	put_device(&fcvport->dev); /* For rports list */
+	device_del(&fcvport->dev);
+	put_device(fcvport->dev.parent);
+	fcvport->dev.parent = NULL;
+}
+EXPORT_SYMBOL(fc_vport_del);
+
+/**
+ * fc_vport_free() - Drop the final FC vport reference
+ * @fcvport: Pointer to the FC vport to be released
+ *
+ * Since vport's are allocated separately from their
+ * sysfs addition their tear-down routines are also
+ * split such that the callers first call fc_vport_del()
+ * and then fc_vport_free().
+ */
+void fc_vport_free(struct fc_vport *fcvport)
+{
+	put_device(&fcvport->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_vport_free);
+
+/**
+ * fc_vport_alloc() - Allocate a FC vport (does not add to sysfs)
+ * @fcvport:  The N_Port if the vport to be allocated is a VN_Port
+ * @ids:      The FC vport identifiers
+ * @f:        The vport function template
+ * @channel:  The channel
+ * @fc4:      The supported FC4s for this vport
+ *
+ * Some LLDs need the memory allocated with the N_Port vport before
+ * they are ready to create FC port or fabric devices. To accomodate
+ * this need alloc and add are split for vports. This allows these
+ * LLDs to allocate vports and then add them later. For LLDs without
+ * this issue they can just call add immediately after alloc.
+ */
+struct fc_vport *fc_vport_alloc(struct fc_vport *fcnport,
+				struct fc_vport_identifiers *ids,
+				struct fc_vport_function_template *f,
+				int channel, enum possible_fc4s fc4)
+{
+	struct fc_vport *fcvport;
+	unsigned long flags;
+	int error = 0;
+
+	fcvport = kzalloc(sizeof(struct fc_vport) + f->dd_fcvport_size,
+			  GFP_KERNEL);
+	if (!fcvport)
+		goto out;
+
+	fcvport->port_state = FC_PORTSTATE_UNKNOWN;
+	fcvport->port_last_state = FC_PORTSTATE_UNKNOWN;
+	fcvport->permanent_port_name = -1;
+	fcvport->node_name = ids->node_name;
+	fcvport->port_name = ids->port_name;
+	fcvport->roles = ids->roles;
+	fcvport->port_type = ids->vport_type;
+	strncpy(fcvport->symbolic_name, ids->symbolic_name,
+		strlen(ids->symbolic_name));
+	fcvport->channel = channel;
+	fcvport->id = atomic_inc_return(&fcvport_num) - 1;
+	fcvport->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
+	fcvport->rport_dev_loss_tmo = fc_dev_loss_tmo;
+
+	INIT_LIST_HEAD(&fcvport->rports);
+	INIT_LIST_HEAD(&fcvport->rport_bindings);
+	fcvport->next_rport_number = 0;
+
+	INIT_WORK(&fcvport->vport_delete_work, fc_vport_sched_delete);
+	spin_lock_init(&fcvport->lock);
+	device_initialize(&fcvport->dev); /* Takes a self-reference */
+
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
+		 "fcvport_wq_%d", fcvport->id);
+	fcvport->work_q = create_singlethread_workqueue(
+		fcvport->work_q_name);
+	if (!fcvport->work_q)
+		goto out_del;
+
+	snprintf(fcvport->devloss_work_q_name,
+		 sizeof(fcvport->devloss_work_q_name),
+		 "fc_dl_%d", fcvport->id);
+	fcvport->devloss_work_q = create_singlethread_workqueue(
+		fcvport->devloss_work_q_name);
+	if (!fcvport->devloss_work_q)
+		goto out_del_q;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	fcvport->flags &= ~FC_VPORT_CREATING;
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	if (fcnport) {
+		fcvport->fcnport = fcnport;
+		error = fcvport->f->vport_create(fcnport, fcvport, 0);
+		if (error)
+			goto out_del_q2;
+	}
+
+	return fcvport;
+
+out_del_q2:
+	destroy_workqueue(fcvport->devloss_work_q);
+	fcvport->devloss_work_q = NULL;
+out_del_q:
+	destroy_workqueue(fcvport->work_q);
+	fcvport->work_q = NULL;
+out_del:
+	kfree(fcvport);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_vport_alloc);
+
+/**
+ * fc_vport_add() - Add a FC vport to a FC fabric
+ * @fcvport:  The FC vport to add
+ *
+ * Add the device to sysfs and then populate it with
+ * attributes.
+ */
+int fc_vport_add(struct fc_fabric *fcfabric,
+		 struct fc_vport *fcvport)
+{
+	int count = 0;
+	int error = 0;
+
+	if (fc_vport_added(fcvport)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * The libfc issue_lip causes a reset and when the
+	 * local port gets the FLOGI response it will attempt
+	 * to add the vport again. Check to see if it's
+	 * already attached to the fabric before readding.
+	 * The test is if the vport's parent is the fabric.
+	 */
+	if (fcvport->dev.parent == &fcfabric->dev) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	fcvport->fcfabric = fcfabric;
+
+	fcvport->dev.parent = get_device(&fcfabric->dev);
+	fcvport->dev.bus = &fc_vport_bus_type;
+	fcvport->dev.release = fc_vport_release;
+
+	error = device_add(&fcvport->dev);
+	if (error)
+		goto out;
+
+	FC_SETUP_COND_ATTR_RD(fcvport, port_id);
+	FC_SETUP_COND_ATTR_RD(fcvport, node_name);
+	FC_SETUP_COND_ATTR_RD(fcvport, port_name);
+	FC_SETUP_COND_ATTR_RD(fcvport, port_type);
+	FC_SETUP_COND_ATTR_RD(fcvport, permanent_port_name);
+
+	FC_SETUP_ATTR_RD_NS(fcvport, port_state);
+	FC_SETUP_ATTR_RD_NS(fcvport, port_last_state);
+	FC_SETUP_ATTR_RD_NS(fcvport, roles);
+	FC_SETUP_ATTR_RD_NS(fcvport, symbolic_name);
+	FC_SETUP_ATTR_RW_NS(fcvport, tgtid_bind_type);
+
+	FC_SETUP_ATTR_RD_NS(fcvport, vport_state);
+
+	FC_SETUP_ATTR_RW_NS(fcvport, vport_disable);
+	FC_SETUP_ATTR_RW_NS(fcvport, vport_delete);
+
+	if (fcvport->f->issue_fcvport_lip)
+		FC_SETUP_ATTR_RW_NS(fcvport, issue_lip);
+
+	BUG_ON(count > FC_VPORT_NUM_ATTRS);
+	FC_CREATE_ATTRS(fcvport, count);
+
+	if (error || count != 0)
+		goto out_del_dev;
+
+	return 0;
+
+out_del_dev:
+	device_del(&fcvport->dev);
+out:
+	return error;
+}
+EXPORT_SYMBOL(fc_vport_add);
+
+/**
+ * fc_vport_sched_delete() - workq-based delete request for a vport
+ * @work:	vport to be deleted.
+ */
+static void fc_vport_sched_delete(struct work_struct *work)
+{
+	struct fc_vport *vport =
+		container_of(work, struct fc_vport, vport_delete_work);
+	struct fc_fabric *fcfabric = fcvport_to_fcfabric(vport);
+	int stat;
+
+	stat = fc_vport_terminate(fcfabric, vport);
+	if (stat)
+		dev_printk(KERN_ERR, vport->dev.parent,
+			   "%s: %s could not be deleted created via "
+			   "fabric %d channel %d - error %d\n", __func__,
+			   dev_name(&vport->dev), fcfabric->id,
+			   vport->channel, stat);
+}
+
+/**
+ * fc_vport_queue_work() - Queue work to the fcpinit workqueue
+ * @fcvport: Pointer to the FC vport to who owns the workqueue
+ * @work:    Work to queue for execution
+ *
+ * Return value:
+ *      1 - work queued for execution
+ *      0 - work is already queued
+ *      -EINVAL - work queue doesn't exist
+ */
+int fc_vport_queue_work(struct fc_vport *fcvport, struct work_struct *work)
+{
+	if (unlikely(!fc_vport_work_q(fcvport))) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(fc_vport_work_q(fcvport), work);
+}
+EXPORT_SYMBOL(fc_vport_queue_work);
+
+/**
+ * fc_vport_flush_work() - Flush a FC vport's workqueue
+ * @fcvport: Pointer to the FC vport whose workqueue is to be flushed
+ */
+void fc_vport_flush_work(struct fc_vport *fcvport)
+{
+	if (!fc_vport_work_q(fcvport)) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fc_vport_work_q(fcvport));
+}
+
+/**
+ * fc_vport_queue_devloss_work() - Schedule work for a FC vport's devloss workqueue
+ * @fcvport: Pointer to the FC vport who owns the  devloss workqueue
+ * @work:    Work to queue for execution
+ * @delay:   jiffies to delay the work queuing
+ *
+ * Return value:
+ *      1 on success / 0 already queued / < 0 for error
+ */
+int fc_vport_queue_devloss_work(struct fc_vport *fcvport,
+				struct delayed_work *work,
+				unsigned long delay)
+{
+	if (unlikely(!fc_vport_devloss_work_q(fcvport))) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to queue work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_delayed_work(fc_vport_devloss_work_q(fcvport),
+				  work, delay);
+}
+
+/**
+ * fc_vport_flush_devloss() - Flush a FC vport's devloss workqueue
+ * @fcvport: Pointer to FC vport whose workqueue is to be flushed
+ */
+void fc_vport_flush_devloss(struct fc_vport *fcvport)
+{
+	if (!fc_vport_devloss_work_q(fcvport)) {
+		printk(KERN_ERR
+		       "ERROR: FC VN_Port '%d' attempted to flush work, "
+		       "when no workqueue created.\n", fcvport->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fc_vport_devloss_work_q(fcvport));
+}
+
+static int fc_vport_bus_match(struct device *dev,
+			      struct device_driver *drv);
+
+struct bus_type fc_vport_bus_type = {
+	.name = "fc_vport",
+	.match = fc_vport_bus_match,
+};
+EXPORT_SYMBOL(fc_vport_bus_type);
+
+static int fc_vport_bus_match(struct device *dev,
+			      struct device_driver *drv)
+{
+	if (dev->bus == &fc_vport_bus_type)
+		return 1;
+	return 0;
+}
+
+int fc_vport_bus_register(void)
+{
+	return bus_register(&fc_vport_bus_type);
+}
+
+void fc_vport_bus_unregister(void)
+{
+	bus_unregister(&fc_vport_bus_type);
+}
diff --git a/include/fc/fc.h b/include/fc/fc.h
new file mode 100644
index 0000000..c59d191
--- /dev/null
+++ b/include/fc/fc.h
@@ -0,0 +1,952 @@
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
+struct fc_port;
+struct fc_fabric;
+struct fc_vport;
+struct fc_rport;
+
+struct fc_vport_function_template;
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
+
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
+/* Names are in fcsysfs.c */
+#define FC_PORTSTATE_MAX_NAMELEN 20
+#define FC_VPORT_MAX_NAMELEN	 20
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
+#define NUM_FC4S 4
+enum possible_fc4s {
+	FC4_UNKNOWN,
+	FC4_FCP_TARGET,
+	FC4_FCP_INITIATOR,
+	FC4_IP,
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
+/* bit field values for struct fc_vport "flags" field */
+#define FC_VPORT_CREATING		0x01
+#define FC_VPORT_DELETING		0x02
+#define FC_VPORT_DELETED		0x04
+#define FC_VPORT_DEL			0x06	/* Any DELETE state */
+
+/* Error return codes for vport_create() callback */
+#define VPCERR_UNSUPPORTED		(-ENOSYS)	/* no driver/adapter
+							   support */
+#define VPCERR_BAD_WWN			(-ENOTUNIQ)	/* driver validation
+							   of WWNs failed */
+#define VPCERR_NO_FABRIC_SUPP		(-EOPNOTSUPP)	/* Fabric connection
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
+#define fc_enum_name_match(title, table_type, table)		\
+	int get_fc_##title##_match(const char *table_key,	\
+				   enum table_type *value)	\
+	{							\
+		int i;						\
+								\
+		for (i = 0; i < ARRAY_SIZE(table); i++) {	\
+			if (strncmp(table_key, table[i].name,	\
+				    table[i].matchlen) == 0) {	\
+				*value = table[i].value;	\
+				return 0; /* success */		\
+			}					\
+		}						\
+		return 1; /* failure */				\
+	}
+
+#define fc_enum_name_search(pre, title, table_type, table)		\
+	const char *get_##pre##_##title##_name(enum table_type table_key) \
+	{								\
+		int i;							\
+		char *name = NULL;					\
+									\
+		for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+			if (table[i].value == table_key) {		\
+				name = table[i].name;			\
+				break;					\
+			}						\
+		}							\
+		return name;						\
+	}
+
+/* Macro for use in defining Remote Port attributes */
+#define FC_RPORT_ATTR(_name, _mode, _show, _store)		\
+	struct device_attribute dev_attr_rport_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+#define FC_FC4_LIST_SIZE		32
+#define FC_SYMBOLIC_NAME_SIZE          256
+
+u32 fc_get_event_number(void);
+/* Note: when specifying vendor_id to fcpinit_post_vendor_event()
+ *   be sure to read the Vendor Type and ID formatting requirements
+ *   specified in scsi_netlink.h
+ */
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
+#define FC_SERIAL_NUMBER_SIZE		80
+
+#define dev_to_fcport(d)			\
+	container_of((d), struct fc_port, dev)
+
+#define dev_to_fcfabric(d)				\
+	container_of((d), struct fc_fabric, dev)
+
+#define dev_to_fcvport(d)			\
+	container_of((d), struct fc_vport, dev)
+
+#define	dev_to_fcrport(d)			\
+	container_of((d), struct fc_rport, dev)
+
+#define FC_PORT_NUM_ATTRS    9
+#define FC_VPORT_NUM_ATTRS  16
+#define FC_RPORT_NUM_ATTRS   9
+#define FC_FABRIC_NUM_ATTRS  6
+
+struct fc_rport_function_template {
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
+	 unsigned long	show_starget_node_name:1;
+	 unsigned long	show_starget_port_name:1;
+	 unsigned long	show_starget_port_id:1;
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
+ * fc_rport_add(). The transport fully manages all get functions
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
+	struct fc_rport_function_template *f;
+	struct device_attribute attrs[FC_RPORT_NUM_ATTRS];
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
+} __attribute__((aligned(sizeof(unsigned long))));
+
+#define fc_rport_port_state(x)			\
+	((x)->port_state)
+#define fc_rport_port_id(x)			\
+	((x)->port_id)
+#define fc_rport_node_name(x)			\
+	((x)->node_name)
+#define fc_rport_port_name(x)			\
+	((x)->port_name)
+#define fc_rport_maxframe_size(x)		\
+	((x)->maxframe_size)
+
+
+/* bit field values for struct fc_rport "flags" field */
+#define FC_RPORT_DEVLOSS_PENDING	0x01
+#define FC_RPORT_SCAN_PENDING		0x02
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
+#define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
+
+#define rport_to_fcvport(r)			\
+	dev_to_fcvport((r)->dev.parent)
+
+struct fc_vport_function_template {
+	int  (*vport_create)(struct fc_vport *nport,
+			     struct fc_vport *vport, bool);
+	int  (*vport_disable)(struct fc_vport *, bool);
+	int  (*vport_delete)(struct fc_vport *nport,
+			     struct fc_vport *vport);
+
+	void (*get_fcvport_port_id)(struct fc_vport *);
+	void (*get_fcvport_symbolic_name)(struct fc_vport *);
+	void (*get_fcvport_port_type)(struct fc_vport *);
+	void (*set_fcvport_symbolic_name)(struct fc_vport *);
+	void (*get_fcvport_port_state)(struct fc_vport *);
+
+	int (*issue_fcvport_lip)(struct fc_vport *);
+
+	unsigned long show_fcvport_permanent_port_name:1;
+	unsigned long show_fcvport_port_id:1;
+	unsigned long show_fcvport_symbolic_name:1;
+	unsigned long show_fcvport_node_name:1;
+	unsigned long show_fcvport_port_name:1;
+	unsigned long show_fcvport_port_type:1;
+
+	u32 dd_fcvport_size;
+
+	struct fc_rport_function_template fcrport_f;
+};
+
+struct fc_fabric_function_template {
+	int  (*fabric_match)(struct fc_fabric *, struct fc_fabric *);
+
+	unsigned long show_fcfabric_fabric_name:1;
+	unsigned long show_fcfabric_dev_loss_tmo:1;
+
+	u32 dd_fcfabric_size;
+};
+
+/* bit field values for struct fc_fabric "flags" field */
+#define FC_FABRIC_DEVLOSS_PENDING 0x01
+
+/* fabric states */
+enum fabric_state {
+	FC_FABRICSTATE_UNKNOWN,
+	FC_FABRICSTATE_DISCONNECTED,
+	FC_FABRICSTATE_CONNECTED,
+};
+
+struct fc_fabric {
+	struct device    dev;
+	struct fc_fabric_function_template *f;
+	struct list_head peers;
+	struct work_struct delete_work;
+	struct delayed_work dev_loss_work;
+	u32 dev_loss_tmo;
+
+	/*
+	 * TODO: What is most appropriate for these, enum, mask?
+	 */
+	u8 flags;
+	enum fabric_state state;
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
+	struct list_head vports; /* uses the fcport->lock */
+	struct device_attribute attrs[FC_FABRIC_NUM_ATTRS];
+};
+
+static inline void *fc_fabric_priv(const struct fc_fabric *fcfabric)
+{
+	return (void *)(fcfabric + 1);
+}
+
+#define fc_fabric_fabric_name(x)		\
+	((x)->fabric_name)
+#define fc_fabric_dev_loss_tmo(x)		\
+	((x)->dev_loss_tmo)
+#define fc_fabric_max_npiv_vports(x)		\
+	((x)->max_npiv_vports)
+#define fc_fabric_next_vport_number(x)		\
+	((x)->next_vport_number)
+#define fc_fabric_npiv_vports_inuse(x)		\
+	((x)->npiv_vports_inuse)
+#define fc_fabric_vports(x)			\
+	((x)->vports)
+#define fcfabric_to_fcport(x)			\
+	dev_to_fcport((x)->dev.parent)
+
+struct fc_port_function_template {
+	void (*get_fcport_speed)(struct fc_port *);
+	void (*get_fcport_active_fc4s)(struct fc_port *);
+	void (*set_fcport_system_hostname)(struct fc_port *);
+
+	unsigned long show_fcport_system_hostname:1;
+	unsigned long show_fcport_fab_dev_loss_tmo:1;
+	unsigned long show_fcport_maxframe_size:1;
+	unsigned long show_fcport_supported_speeds:1;
+	unsigned long show_fcport_speed:1;
+	unsigned long show_fcport_supported_fc4s:1;
+	unsigned long show_fcport_active_fc4s:1;
+	unsigned long show_fcport_supported_classes:1;
+	unsigned long show_fcport_serial_number:1;
+
+	u32 dd_fcport_size;
+
+	struct fc_vport_function_template fcvport_f;
+};
+
+struct fc_port {
+	u32                             id;
+	struct device                   dev;
+	struct list_head                fabrics;
+	char                            work_q_name[20];
+	struct workqueue_struct         *work_q;
+	char                            devloss_work_q_name[20];
+	struct workqueue_struct         *devloss_work_q;
+	struct mutex                    lock;
+	struct fc_port_function_template *f;
+	void *fc4_f;
+	struct device_attribute attrs[FC_PORT_NUM_ATTRS];
+
+	/* Fixed Attributes */
+	u8   supported_fc4s[FC_FC4_LIST_SIZE];
+	u32  maxframe_size;
+	u32  supported_classes;
+	char serial_number[FC_SERIAL_NUMBER_SIZE];
+
+	/* Dynamic Attributes*/
+	u8 active_fc4s[FC_FC4_LIST_SIZE];
+	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
+
+	/*
+	 * FCoE supported_speeds and speed can change on
+	 * a link event so they are dynamic.
+	 */
+	u32 supported_speeds;
+	u32 speed;
+
+	int fab_dev_loss_tmo;
+};
+
+static inline void *fc_port_priv(const struct fc_port *fcport)
+{
+	return (void *)(fcport + 1);
+}
+
+#define fc_port_id(x)				\
+	((x)->id)
+#define fc_port_work_q_name(x)			\
+	((x)->work_q_name)
+#define fc_port_work_q(x)			\
+	((x)->work_q)
+#define fc_port_devloss_work_q_name(x)		\
+	((x)->devloss_work_q_name)
+#define fc_port_devloss_work_q(x)		\
+	((x)->devloss_work_q)
+#define fc_port_system_hostname(x)		\
+	((x)->system_hostname)
+#define fc_port_maxframe_size(x)		\
+	((x)->maxframe_size)
+#define fc_port_supported_speeds(x)		\
+	((x)->supported_speeds)
+#define fc_port_speed(x)			\
+	((x)->speed)
+#define fc_port_fab_dev_loss_tmo(x)		\
+	((x)->fab_dev_loss_tmo)
+#define fc_port_supported_fc4s(x)		\
+	((x)->supported_fc4s)
+#define fc_port_active_fc4s(x)			\
+	((x)->active_fc4s)
+#define fc_port_supported_classes(x)		\
+	((x)->supported_classes)
+#define fc_port_serial_number(x)		\
+	((x)->serial_number)
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
+struct fc_vport {
+	struct device                    dev;
+	struct fc_vport_function_template *f;
+	u32                              id;
+
+	/* Fixed Attributes */
+	u64                              permanent_port_name;
+	u32                              port_id;
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	u64                              node_name;
+	u64                              port_name;
+	enum fc_port_type                port_type;
+	enum fc_vport_state              vport_state;
+
+	struct fc_vport  *fcnport; /* NULL if N_Port */
+	struct fc_fabric *fcfabric; /* fabric on which the
+				       vport was created */
+	struct device_attribute attrs[FC_VPORT_NUM_ATTRS];
+
+	struct fc4_template *fc4_f;
+
+	/* Dynamic Attributes */
+	u32 rport_dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_port_state port_state;
+	enum fc_port_state port_last_state;
+	u32 roles;
+	u32 vport_id;		/* Admin Identifier for the vport */
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
+static inline void *fc_vport_priv(const struct fc_vport *fcvport)
+{
+	return (void *)(fcvport + 1);
+}
+
+#define fc_vport_port_state(x)			\
+	((x)->port_state)
+#define fc_vport_permanent_port_name(x)		\
+	((x)->permanent_port_name)
+#define fc_vport_port_id(x)			\
+	((x)->port_id)
+#define fc_vport_symbolic_name(x)		\
+	((x)->symbolic_name)
+#define fc_vport_node_name(x)			\
+	((x)->node_name)
+#define fc_vport_port_name(x)			\
+	((x)->port_name)
+#define fc_vport_port_type(x)			\
+	((x)->port_type)
+#define fc_vport_tgtid_bind_type(x)		\
+	((x)->tgtid_bind_type)
+#define fc_vport_rports(x)			\
+	((x)->rports)
+#define fc_vport_rport_dev_loss_tmo(x)		\
+	((x)->rport_dev_loss_tmo)
+#define fc_vport_rport_bindings(x)		\
+	((x)->rport_bindings)
+#define fc_vport_next_rport_number(x)		\
+	((x)->next_rport_number)
+#define fc_vport_work_q_name(x)			\
+	((x)->work_q_name)
+#define fc_vport_work_q(x)			\
+	((x)->work_q)
+#define fc_vport_devloss_work_q_name(x)		\
+	((x)->devloss_work_q_name)
+#define fc_vport_devloss_work_q(x)		\
+	((x)->devloss_work_q)
+#define fcvport_to_fcfabric(x)			\
+	((x)->fcfabric)
+
+static inline int fc_vport_added(const struct fc_vport *fcvport)
+{
+	return (fcvport->dev.parent != NULL) ? 1 : 0;
+}
+
+static inline int fc_vport_is_nport(struct fc_vport *fcvport)
+{
+	if (fc_vport_port_type(fcvport) == FC_PORTTYPE_NPORT)
+		return 1;
+	return 0;
+}
+
+/**
+ * dev_is_nport() - Is the device embedded in a FC vport an Nport
+ * @dev:     Pointer to the device embedded in a FC vport
+ * @ignored: Mandatory void* needed by device_find_child()
+ */
+static inline int dev_is_nport(struct device *dev, void *ignored)
+{
+	return fc_vport_is_nport(dev_to_fcvport(dev));
+}
+
+/**
+ * fc_fabric_find_nport() - Find the NPort on a FC fabric
+ * @fcfabric: The fabric to search for the N_Port on
+ *
+ * device_find_child() grabs a reference to the FC vport
+ * representing the N_port. It must be released when the
+ * returned vport is not needed anymore.
+ */
+static inline struct fc_vport *fc_fabric_find_nport(struct fc_fabric *fcfabric)
+{
+	struct device *dev = device_find_child(&fcfabric->dev,
+					       NULL, dev_is_nport);
+	if (!dev)
+		return NULL;
+	return dev_to_fcvport(dev);
+}
+
+static inline u64 wwn_to_u64(u8 *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+		(u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+		(u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+		(u64)wwn[6] <<  8 | (u64)wwn[7];
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
+static inline void fc_vport_set_state(struct fc_vport *fcvport,
+				      enum fc_vport_state new_state)
+{
+	if ((new_state != FC_VPORT_UNKNOWN) &&
+	    (new_state != FC_VPORT_INITIALIZING))
+		fcvport->port_last_state = fcvport->port_state;
+	fcvport->port_state = new_state;
+}
+
+struct fc_vport *fc_vport_lookup(struct fc_fabric *fcfabric,
+				 const u32 id);
+
+struct fc_port *fc_port_add(struct device *pdev,
+			    struct fc_port_function_template *,
+			    void *fc4_f);
+struct fc_fabric *fc_fabric_add(struct fc_port *fcport,
+				struct fc_fabric_function_template *,
+				struct fc_fabric *);
+struct fc_vport *fc_vport_alloc(struct fc_vport *fcnport,
+				struct fc_vport_identifiers *ids,
+				struct fc_vport_function_template *fcn_tmpl,
+				int channel, enum possible_fc4s fc4);
+struct fc_vport *fc_vport_create(struct fc_fabric *, int channel,
+				 struct fc_vport_identifiers *);
+int fc_vport_add(struct fc_fabric *fcfabric,
+		 struct fc_vport *fcvport);
+
+void fc_port_del(struct fc_port *fcport);
+void fc_port_del_fabrics(struct fc_port *fcport);
+void fc_fabric_del(struct fc_fabric *fcfabric);
+void fc_vport_del(struct fc_vport *fcvport);
+void fc_vport_free(struct fc_vport *fcvport);
+
+#define FC_DEVICE_ATTR(_prefix, _name, _mode, _show, _store)		\
+	struct device_attribute device_attr_##_prefix##_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+#define FC_CREATE_ATTRS(_var, count)					\
+	while (count > 0) {						\
+		sysfs_attr_init(&_var->attrs[count-1].attr);		\
+		error = device_create_file(&_var->dev, &_var->attrs[count-1]); \
+		if (error)						\
+			break;						\
+		count--;						\
+	}
+
+/* used by maxframe_size */
+/* used by supported_speeds */
+/* used by supported_fc4s */
+/* used by supported_classes */
+/* used by serial_number */
+/* used by fabric_name */
+/* used by speed */
+/* used by active_fc4s */
+/* used by port_id */
+/* used by node_name */
+/* used by port_name */
+/* used by permanent_port_name */
+#define FC_SETUP_COND_ATTR_RD(_var, field)				\
+	if (_var->f->show_##_var##_##field) {				\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		_var->attrs[count].attr.mode = S_IRUGO;			\
+		_var->attrs[count].store = NULL;			\
+		count++;						\
+	}
+
+/* used by system_hostname */
+#define FC_SETUP_COND_ATTR_RW(_var, field)				\
+	{								\
+		if (_var->f->show_##_var##_##field) {			\
+			_var->attrs[count] = device_attr_##_var##_##field; \
+			count++;					\
+		}							\
+	}
+
+/* used by vport_create */
+/* used by vport_delete (fabric) */
+/* used by tgtid_bind_type */
+/* used by vport_delete (vport) */
+/* used by vport_disable */
+#define FC_SETUP_ATTR_RW_NS(_var, field)				\
+	{								\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		count++;						\
+	}
+
+/* used by max_npiv_vports */
+/* used by npiv_vports_inuse */
+/* used by port_state */
+/* used by port_last_state */
+/* used by vport_state */
+/* used by symbolic_name */
+#define FC_SETUP_ATTR_RD_NS(_var, field)				\
+	do {								\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		_var->attrs[count].attr.mode = S_IRUGO;			\
+		_var->attrs[count].store = NULL;			\
+		count++;						\
+	} while (0)
+
+/* used by fc_port_rd_attr */
+/* used by system_hostname */
+/* used by fc_fabric_rd_attr */
+#define fc_show_function(_pre, _obj, field, format_string, sz, cast)	\
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+	{								\
+		struct _pre##_##_obj *_obj = dev_to_##_pre##_obj(dev);	\
+		return snprintf(buf, sz, format_string,			\
+				cast _pre##_##_obj##_##field(_obj));	\
+	}
+
+#define fc_update_show_function(_pre, _obj, field, format_string, sz, cast) \
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+	{								\
+		struct _pre##_##_obj *_obj = dev_to_##_pre##_obj(dev);	\
+		if (_obj->f->get_##_pre##_obj##_##field)		\
+			_obj->f->get_##_pre##_obj##_##field(_obj);	\
+		return snprintf(buf, sz, format_string,			\
+				cast _pre##_##_obj##_##field(_obj));	\
+	}
+
+struct fc_rport *fc_rport_add(struct fc_vport *fcvport,
+			      struct fc_rport_identifiers *ids);
+void fc_rport_del(struct fc_rport *rport);
+void fc_rport_rolechg(struct fc_rport *rport, u32 roles);
+
+int fc_vport_queue_work(struct fc_vport *fcvport, struct work_struct *work);
+void fc_vport_flush_work(struct fc_vport *fcvport);
+
+struct fc4_template {
+	void (*fc4_bsg_goose_queue)(struct fc_rport *rport);
+	void (*fc4_targ_block)(struct fc_rport *rport);
+	void (*fc4_targ_unblock)(struct fc_rport *rport);
+	void (*fc4_targ_terminate_io)(struct fc_rport *rport);
+	void (*fc4_starget_delete)(struct fc_rport *rport);
+	void (*fc4_queue_starget_delete)(struct fc_rport *rport);
+	void (*fc4_targ_queue_scan)(struct fc_rport *rport);
+	void (*fc4_init_scsi_flush_work)(struct fc_vport *fcvport);
+	int  (*fc4_targ_rolechg)(struct fc_rport *rport, u32 roles);
+	void (*fc4_targ_final_delete)(struct fc_rport *rport);
+};
+
+int register_fc4(struct fc4_template *tmpl, enum possible_fc4s fc4);
+void unregister_fc4(enum possible_fc4s fc4);
+
+extern struct bus_type fc_vport_bus_type;
+extern struct bus_type fc_rport_bus_type;
+
+#endif /* _FC_H_ */

