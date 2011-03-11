From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 04/10] scsi_transport_fcp: Create FC/SCSI interaction
	layer
Date: Fri, 11 Mar 2011 13:54:50 -0800
Message-ID: <20110311215450.18760.79289.stgit@localhost6.localdomain6>
References: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1CKVyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 16:54:51 -0500
In-Reply-To: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

This patch adds SCSI (initiator) as FC4 type that registers with the FC layer.
This layer bridges the FC subsystem and the SCSI subsystem. When a fcvport is
created in the FC layer a callback is made to scsi_transport_fcp and a fcpinit
and Scsi_Host are allocated and added to sysfs. When a fcrport is created in the
FC layer a callback is made to scsi_transport_fcp and a fcptarg is allocated,
added to sysfs and SCSI is notified to scan.

The devices created by scsi_transport_fcp are:

fcpinit: Object that bridges fcvport and Scsi_Host
	 Attributes: fcp_statistics

fcptarg: Object that bridges fcrports and stargets
	 Attributes: scsi_target_id

The fcptarg is not linked to the scsi targets in sysfs right now.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/Kconfig              |   10 
 drivers/scsi/Makefile             |    1 
 drivers/scsi/scsi_transport_fcp.c | 1571 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_fcp.h |  307 +++++++
 4 files changed, 1889 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/scsi_transport_fcp.c
 create mode 100644 include/scsi/scsi_transport_fcp.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a1f029..47450a6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -299,6 +299,16 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_FCP_ATTRS
+       tristate "Experimental Fiber Channel Protocol Transport Attributes"
+       depends on SCSI
+       depends on FC
+       select SCSI_NETLINK
+	help
+         If you wish to export transport-specific information about
+	 each attached FiberChannel device to sysfs, say Y.
+	 Otherwise, say N.
+
 config SCSI_FC_TGT_ATTRS
 	bool "SCSI target support for FiberChannel Transport Attributes"
 	depends on SCSI_FC_ATTRS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b57c532..4526c46 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 # --------------------------
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
+obj-$(CONFIG_SCSI_FCP_ATTRS) 	+= scsi_transport_fcp.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
diff --git a/drivers/scsi/scsi_transport_fcp.c b/drivers/scsi/scsi_transport_fcp.c
new file mode 100644
index 0000000..ca30566
--- /dev/null
+++ b/drivers/scsi/scsi_transport_fcp.c
@@ -0,0 +1,1571 @@
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fcp.h>
+#include <scsi/scsi_cmnd.h>
+#include <linux/netlink.h>
+#include <net/netlink.h>
+#include <scsi/scsi_netlink_fc.h>
+#include <scsi/scsi_bsg_fc.h>
+#include "scsi_priv.h"
+#include "scsi_transport_fc_internal.h"
+
+static struct fc4_template fcp_fc4_template;
+
+static int fcp_bsg_hostadd(struct Scsi_Host *);
+static void fcp_bsg_remove(struct request_queue *q);
+static int fcp_bsg_targadd(struct fcp_init *fcpinit,
+			   struct fcp_targ *fcptarg);
+static void fcp_bsg_request_handler(struct request_queue *q,
+				    struct Scsi_Host *shost,
+				    struct fcp_targ *fcptarg,
+				    struct device *dev);
+static void fcp_bsg_softirq_done(struct request *rq);
+static enum blk_eh_timer_return fcp_bsg_job_timeout(struct request *req);
+
+static void fcp_starget_delete(struct fc_rport *rport);
+static void fcp_starget_delete_work(struct work_struct *work);
+static void fcp_scsi_scan_rport(struct work_struct *work);
+
+/* Convert fcpinit_event_code values to ascii string name */
+static const struct {
+	enum fcp_init_event_code	value;
+	char				*name;
+} fcp_init_event_code_names[] = {
+	{ FCH_EVT_LIP,			"lip" },
+	{ FCH_EVT_LINKUP,		"link_up" },
+	{ FCH_EVT_LINKDOWN,		"link_down" },
+	{ FCH_EVT_LIPRESET,		"lip_reset" },
+	{ FCH_EVT_RSCN,			"rscn" },
+	{ FCH_EVT_ADAPTER_CHANGE,	"adapter_chg" },
+	{ FCH_EVT_PORT_UNKNOWN,		"port_unknown" },
+	{ FCH_EVT_PORT_ONLINE,		"port_online" },
+	{ FCH_EVT_PORT_OFFLINE,		"port_offline" },
+	{ FCH_EVT_PORT_FABRIC,		"port_fabric" },
+	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
+	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
+};
+fc_enum_name_search(fcp, init_event_code, fcp_init_event_code,
+		    fcp_init_event_code_names)
+#define FCPINIT_EVENT_CODE_MAX_NAMELEN	30
+
+#define fcpinit_store_function(field)				\
+	static ssize_t						\
+	store_fcpinit_##field(struct device *dev,		\
+			      struct device_attribute *attr,	\
+			      const char *buf,	size_t count)	\
+	{							\
+		struct fcp_init *fcpinit = dev_to_fcpinit(dev);	\
+		int val;					\
+		char *cp;					\
+								\
+		val = simple_strtoul(buf, &cp, 0);		\
+		if (*cp && (*cp != '\n'))			\
+			return -EINVAL;				\
+		fcpinit->f->set_fcpinit_##field(fcpinit, val);	\
+		return count;					\
+	}
+
+#define fcpinit_rd_attr(field, format_string, sz)			\
+	fc_always_show_function(fcpinit, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcpinit, field, S_IRUGO,			\
+			      show_fcpinit_##field, NULL)
+
+#define fcpinit_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_always_show_function(fcpinit, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcpinit, field, S_IRUGO,			\
+			      show_fcpinit_##field, NULL)
+
+#define fcpinit_rw_attr(field, format_string, sz)			\
+	fc_always_show_function(fcpinit, field, format_string, sz, )	\
+	fcpinit_store_function(field)					\
+	static FC_DEVICE_ATTR(fcpinit, field, S_IRUGO | S_IWUSR,	\
+			      show_fcpinit_##field,			\
+			      store_fcpinit_##field)
+
+#define fcp_init_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_always_show_function(fcpinit, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcpinit, field, S_IRUGO,			\
+			      show_fcpinit_##field, NULL)
+
+#define fcp_get_stat(stats, offset)					\
+	(unsigned long long)*(u64 *)(((u8 *) (stats)) + (offset))
+
+/* Show a given an attribute in the statistics group */
+static ssize_t fcp_stat_show(const struct device *dev, char *buf,
+			     unsigned long offset)
+{
+	struct fcp_init *fcpinit = dev_to_fcpinit(dev);
+	struct fcp_init_statistics *stats;
+	ssize_t ret = -ENOENT;
+
+	if (offset > sizeof(struct fcp_init_statistics) ||
+	    offset % sizeof(u64) != 0)
+		WARN_ON(1);
+
+	if (fcpinit->f->get_fcpinit_stats) {
+		stats = (fcpinit->f->get_fcpinit_stats)(fcpinit);
+		if (stats)
+			ret = snprintf(buf, 20, "0x%llx\n",
+				       fcp_get_stat(stats, offset));
+	}
+
+	return ret;
+}
+
+/* generate a read-only statistics attribute */
+#define fcp_init_statistic(name)					\
+	static ssize_t show_fcstat_##name(struct device *cd,		\
+					  struct device_attribute *attr, \
+					  char *buf)			\
+	{								\
+		return fcp_stat_show(cd, buf,				\
+				     offsetof(struct fcp_init_statistics, \
+					     name));			\
+	}								\
+	static FC_DEVICE_ATTR(fcpinit, name, S_IRUGO, show_fcstat_##name, NULL)
+
+fcp_init_statistic(seconds_since_last_reset);
+fcp_init_statistic(tx_frames);
+fcp_init_statistic(tx_words);
+fcp_init_statistic(rx_frames);
+fcp_init_statistic(rx_words);
+fcp_init_statistic(lip_count);
+fcp_init_statistic(nos_count);
+fcp_init_statistic(error_frames);
+fcp_init_statistic(dumped_frames);
+fcp_init_statistic(link_failure_count);
+fcp_init_statistic(loss_of_sync_count);
+fcp_init_statistic(loss_of_signal_count);
+fcp_init_statistic(prim_seq_protocol_err_count);
+fcp_init_statistic(invalid_tx_word_count);
+fcp_init_statistic(invalid_crc_count);
+fcp_init_statistic(fcp_input_requests);
+fcp_init_statistic(fcp_output_requests);
+fcp_init_statistic(fcp_control_requests);
+fcp_init_statistic(fcp_input_megabytes);
+fcp_init_statistic(fcp_output_megabytes);
+
+static ssize_t fcp_reset_statistics(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct fcp_init *fcpinit = dev_to_fcpinit(dev);
+
+	/* ignore any data value written to the attribute */
+	if (fcpinit->f->reset_fcpinit_stats) {
+		fcpinit->f->reset_fcpinit_stats(fcpinit);
+		return count;
+	}
+
+	return -ENOENT;
+}
+static FC_DEVICE_ATTR(fcpinit, reset_statistics, S_IWUSR, NULL,
+		      fcp_reset_statistics);
+
+static struct attribute *fcp_statistics_attrs[] = {
+	&device_attr_fcpinit_seconds_since_last_reset.attr,
+	&device_attr_fcpinit_tx_frames.attr,
+	&device_attr_fcpinit_tx_words.attr,
+	&device_attr_fcpinit_rx_frames.attr,
+	&device_attr_fcpinit_rx_words.attr,
+	&device_attr_fcpinit_lip_count.attr,
+	&device_attr_fcpinit_nos_count.attr,
+	&device_attr_fcpinit_error_frames.attr,
+	&device_attr_fcpinit_dumped_frames.attr,
+	&device_attr_fcpinit_link_failure_count.attr,
+	&device_attr_fcpinit_loss_of_sync_count.attr,
+	&device_attr_fcpinit_loss_of_signal_count.attr,
+	&device_attr_fcpinit_prim_seq_protocol_err_count.attr,
+	&device_attr_fcpinit_invalid_tx_word_count.attr,
+	&device_attr_fcpinit_invalid_crc_count.attr,
+	&device_attr_fcpinit_fcp_input_requests.attr,
+	&device_attr_fcpinit_fcp_output_requests.attr,
+	&device_attr_fcpinit_fcp_control_requests.attr,
+	&device_attr_fcpinit_fcp_input_megabytes.attr,
+	&device_attr_fcpinit_fcp_output_megabytes.attr,
+	&device_attr_fcpinit_reset_statistics.attr,
+	NULL
+};
+
+static struct attribute_group fcp_statistics_group = {
+	.name = "statistics",
+	.attrs = fcp_statistics_attrs,
+};
+
+#define fcp_targ_rd_attr(field, format_string, sz)		\
+	fc_show_function(fcp, targ, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcptarg, field, S_IRUGO,		\
+			      show_targ_##field, NULL)
+
+fcp_targ_rd_attr(scsi_target_id, "%d\n", 20);
+
+/**
+ * fcp_timed_out() - FC Transport I/O timeout intercept handler
+ * @scmd:	The SCSI command which timed out
+ *
+ * This routine protects against error handlers getting invoked while a
+ * rport is in a blocked state, typically due to a temporarily loss of
+ * connectivity. If the error handlers are allowed to proceed, requests
+ * to abort i/o, reset the target, etc will likely fail as there is no way
+ * to communicate with the device to perform the requested function. These
+ * failures may result in the midlayer taking the device offline, requiring
+ * manual intervention to restore operation.
+ *
+ * This routine, called whenever an i/o times out, validates the state of
+ * the underlying rport. If the rport is blocked, it returns
+ * EH_RESET_TIMER, which will continue to reschedule the timeout.
+ * Eventually, either the device will return, or devloss_tmo will fire,
+ * and when the timeout then fires, it will be handled normally.
+ * If the rport is not blocked, normal error handling continues.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+static enum blk_eh_timer_return fcp_timed_out(struct scsi_cmnd *scmd)
+{
+	struct scsi_target *starget = scsi_target(scmd->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+
+	if (rport->port_state == FC_PORTSTATE_BLOCKED)
+		return BLK_EH_RESET_TIMER;
+
+	return BLK_EH_NOT_HANDLED;
+}
+
+/*
+ * Called by fc_user_scan to locate an rport on the shost that
+ * matches the channel and target id, and invoke scsi_scan_target()
+ * on the rport.
+ */
+static void fcp_user_scan_tgt(struct Scsi_Host *shost, uint channel,
+			     uint id, uint lun)
+{
+	struct fcp_init *fcpinit = shost_priv(shost);
+	struct fc_vport *fcvport = fcpinit_to_fcvport(fcpinit);
+	struct fc_rport *rport;
+	struct fcp_targ *fcptarg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+
+	list_for_each_entry(rport, &fc_vport_rports(fcvport), peers) {
+		if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			continue;
+
+		fcptarg = rport_to_fcptarg(rport);
+
+		if (fcptarg->scsi_target_id == -1)
+			continue;
+
+		if (rport->port_state != FC_PORTSTATE_ONLINE)
+			continue;
+
+		if ((channel == rport->channel) &&
+		    (id == fcptarg->scsi_target_id)) {
+			spin_unlock_irqrestore(&fcvport->lock, flags);
+			scsi_scan_target(&fcptarg->dev, channel, id, lun, 1);
+			return;
+		}
+	}
+
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+}
+
+/*
+ * Called via sysfs scan routines. Necessary, as the FC transport
+ * wants to place all target objects below the rport object. So this
+ * routine must invoke the scsi_scan_target() routine with the rport
+ * object as the parent.
+ */
+static int fcp_user_scan(struct Scsi_Host *shost, uint channel,
+			 uint id, uint lun)
+{
+	uint chlo, chhi;
+	uint tgtlo, tgthi;
+
+	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
+	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
+	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+		return -EINVAL;
+
+	if (channel == SCAN_WILD_CARD) {
+		chlo = 0;
+		chhi = shost->max_channel + 1;
+	} else {
+		chlo = channel;
+		chhi = channel + 1;
+	}
+
+	if (id == SCAN_WILD_CARD) {
+		tgtlo = 0;
+		tgthi = shost->max_id;
+	} else {
+		tgtlo = id;
+		tgthi = id + 1;
+	}
+
+	for ( ; chlo < chhi; chlo++)
+		for ( ; tgtlo < tgthi; tgtlo++)
+			fcp_user_scan_tgt(shost, chlo, tgtlo, lun);
+
+	return 0;
+}
+
+static int fcp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
+				 int result)
+{
+	/*
+	 * This was previously calling the fc_internal template's
+	 * callback, why does the Scsi_Host have one too? Is there
+	 * a problem with calling the Scsi_Host's callback directly?
+	 */
+	return shost->transportt->tsk_mgmt_response(shost, nexus,
+						    tm_id, result);
+}
+
+static int fcp_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
+{
+	/*
+	 * This was previously calling the fc_internal template's
+	 * callback, why does the Scsi_Host have one too? Is there
+	 * a problem with calling the Scsi_Host's callback directly?
+	 */
+	return shost->transportt->it_nexus_response(shost, nexus, result);
+}
+
+/**
+ * fcp_init_release() - Put the Scsi_Host reference to free the fcpinit
+ * @dev: The fcpinit's embedded device
+ */
+static void fcp_init_release(struct device *dev)
+{
+	struct fcp_init *fcpinit = dev_to_fcpinit(dev);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+
+	scsi_host_put(shost);
+}
+
+/**
+ * fcp_init_del() - Delete a init instance
+ * @fcvport: The FC vport associated with the fcpinit to be deleted
+ *
+ * Determine the fcpinit from the FC vport. Flush any work on the
+ * associated Scsi_Host, remove the fcpinit and Scsi_Host from
+ * sysfs, notify the LLD and drop the self-refrence to the fcpinit.
+ */
+static int fcp_init_remove(struct device *dev)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	struct fcp_init *fcpinit = fcvport_to_fcpinit(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+
+	fcp_bsg_remove(fcpinit->rqst_q);
+
+	/* flush all scan work items */
+	scsi_flush_work(shost);
+
+	device_del(&fcpinit->dev);
+	put_device(fcpinit->dev.parent);
+	fcpinit->dev.parent = NULL;
+
+	/*
+	 * Detach from the scsi-ml. This frees the shost,
+	 * fcpinit and any LLD private data.
+	 */
+	scsi_remove_host(shost);
+
+	if (fcpinit->f->fcp_fcpinit_del)
+		fcpinit->f->fcp_fcpinit_del(fcpinit);
+
+	put_device(&fcpinit->dev); /* Self Reference from device_initialize */
+
+	return 0;
+}
+
+static struct scsi_transport_template fcpinit_scsi_transport_template = {
+	/* Use the shost workq for scsi scanning */
+	.create_work_queue = 1,
+
+	.eh_timed_out = fcp_timed_out,
+
+	.user_scan = fcp_user_scan,
+
+	/* target-mode drivers' functions */
+	.tsk_mgmt_response = fcp_tsk_mgmt_response,
+	.it_nexus_response = fcp_it_nexus_response,
+};
+
+/**
+ * fcp_init_probe() - Create and add a fcpinit device
+ * @dev: The FC vport
+ *
+ * Allocate the fcpinit structure with the Scsi_Host. Add
+ * it and the Scsi_Host to sysfs and notify the LLD.
+ */
+static int fcp_init_probe(struct device *dev)
+{
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	struct fc_fabric *fcfabric = fcvport_to_fcfabric(fcvport);
+	struct fc_port *fcport = fcfabric_to_fcport(fcfabric);
+	struct fcp_template *f = fcport->fc4_f;
+	struct Scsi_Host *shost;
+	struct fcp_init *fcpinit;
+	int error = 0;
+
+	int priv_size = sizeof(struct fcp_init) + f->fcpinit_priv_size;
+	shost = scsi_host_alloc(&f->shost_template, priv_size);
+	if (unlikely(!shost)) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	shost->transportt = &fcpinit_scsi_transport_template;
+	fcvport->fc4_f = &fcp_fc4_template;
+
+	fcpinit = shost_priv(shost);
+	fcpinit->f = f;
+
+	dev_set_drvdata(dev, fcpinit);
+	fcpinit->fcvport = fcvport;
+	fcpinit->shost = shost;
+	fcpinit->next_target_id = 0;
+
+	device_initialize(&fcpinit->dev); /* Requires a put_device */
+	fcpinit->dev.release = fcp_init_release;
+	dev_set_name(&fcpinit->dev, "fcpinit_%d", shost->host_no);
+
+	/*
+	 * Need to call back to the LLD with priv memory
+	 */
+	if (fcpinit->f->fcp_fcpinit_add)
+		fcpinit->f->fcp_fcpinit_add(fcpinit);
+
+	fcpinit->dev.parent = get_device(&fcvport->dev);
+
+	error = device_add(&fcpinit->dev);
+	if (error)
+		goto out_del;
+
+	if (fcpinit->f->get_fcpinit_stats)
+		error = sysfs_update_group(&fcpinit->dev.kobj,
+					   &fcp_statistics_group);
+
+	/* add the new host to the SCSI-ml */
+	error = scsi_add_host(shost, &fcpinit->dev);
+	if (error)
+		goto out_del_dev;
+
+	fcp_bsg_hostadd(shost);
+	/* ignore any bsg add error - we just can't do sgio */
+
+	dev_printk(KERN_NOTICE, fcpinit->dev.parent,
+		   "%s created via shost%d channel %d\n",
+		   dev_name(&fcpinit->dev), shost->host_no,
+		   fcvport->channel);
+
+	return 0;
+
+out_del_dev:
+	device_del(&fcpinit->dev);
+out_del:
+	put_device(&fcvport->dev);
+	scsi_host_put(shost);
+out:
+	return error;
+}
+
+/**
+ * fcp_init_post_event() - called to post an even on an fcp_init.
+ * @shost:		host the event occurred on
+ * @event_number:	fc event number obtained from get_fc_event_number()
+ * @event_code:		fcp_init event being posted
+ * @event_data:		32bits of data for the event being posted
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void fcp_init_post_event(struct Scsi_Host *shost, u32 event_number,
+			 enum fcp_init_event_code event_code, u32 event_data)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr	*nlh;
+	struct fc_nl_event *event;
+	const char *name;
+	u32 len, skblen;
+	int err;
+
+	if (!scsi_nl_sock) {
+		err = -ENOENT;
+		goto send_fail;
+	}
+
+	len = FC_NL_MSGALIGN(sizeof(*event));
+	skblen = NLMSG_SPACE(len);
+
+	skb = alloc_skb(skblen, GFP_KERNEL);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto send_fail;
+	}
+
+	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
+			skblen - sizeof(*nlh), 0);
+	if (!nlh) {
+		err = -ENOBUFS;
+		goto send_fail_skb;
+	}
+	event = NLMSG_DATA(nlh);
+
+	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
+			 FC_NL_ASYNC_EVENT, len);
+	event->seconds = get_seconds();
+	event->vendor_id = 0;
+	event->host_no = shost->host_no;
+	event->event_datalen = sizeof(u32);	/* bytes */
+	event->event_num = event_number;
+	event->event_code = event_code;
+	event->event_data = event_data;
+
+	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
+			GFP_KERNEL);
+	return;
+
+send_fail_skb:
+	kfree_skb(skb);
+send_fail:
+	name = get_fcp_init_event_code_name(event_code);
+	printk(KERN_WARNING
+	       "%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
+	       __func__, shost->host_no,
+	       (name) ? name : "<unknown>", event_data, err);
+	return;
+}
+EXPORT_SYMBOL(fcp_init_post_event);
+
+/**
+ * fcp_init_post_vendor_event() - called to post a vendor unique event on an fcp_init
+ * @shost:		host the event occurred on
+ * @event_number:	fc event number obtained from get_fc_event_number()
+ * @data_len:		amount, in bytes, of vendor unique data
+ * @data_buf:		pointer to vendor unique data
+ * @vendor_id:          Vendor id
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void fcp_init_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
+				u32 data_len, char *data_buf, u64 vendor_id)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr	*nlh;
+	struct fc_nl_event *event;
+	u32 len, skblen;
+	int err;
+
+	if (!scsi_nl_sock) {
+		err = -ENOENT;
+		goto send_vendor_fail;
+	}
+
+	len = FC_NL_MSGALIGN(sizeof(*event) + data_len);
+	skblen = NLMSG_SPACE(len);
+
+	skb = alloc_skb(skblen, GFP_KERNEL);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto send_vendor_fail;
+	}
+
+	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
+			skblen - sizeof(*nlh), 0);
+	if (!nlh) {
+		err = -ENOBUFS;
+		goto send_vendor_fail_skb;
+	}
+	event = NLMSG_DATA(nlh);
+
+	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
+			 FC_NL_ASYNC_EVENT, len);
+	event->seconds = get_seconds();
+	event->vendor_id = vendor_id;
+	event->host_no = shost->host_no;
+	event->event_datalen = data_len;	/* bytes */
+	event->event_num = event_number;
+	event->event_code = FCH_EVT_VENDOR_UNIQUE;
+	memcpy(&event->event_data, data_buf, data_len);
+
+	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
+			GFP_KERNEL);
+	return;
+
+send_vendor_fail_skb:
+	kfree_skb(skb);
+send_vendor_fail:
+	printk(KERN_WARNING
+	       "%s: Dropped Event : host %d vendor_unique - err %d\n",
+	       __func__, shost->host_no, err);
+	return;
+}
+EXPORT_SYMBOL(fcp_init_post_vendor_event);
+
+/**
+ * fcp_bsg_host_handler() - handler for bsg requests for a fc host
+ * @q:		fc host request queue
+ */
+static void fcp_bsg_host_handler(struct request_queue *q)
+{
+	struct Scsi_Host *shost = q->queuedata;
+
+	fcp_bsg_request_handler(q, shost, NULL, &shost->shost_gendev);
+}
+
+/**
+ * fcp_bsg_hostadd() - Create and add the bsg hooks so we can receive requests
+ * @shost:	shost for fcp_init
+ */
+static int fcp_bsg_hostadd(struct Scsi_Host *shost)
+{
+	struct fcp_init *fcpinit = shost_priv(shost);
+	struct device *dev = &shost->shost_gendev;
+	struct request_queue *q;
+	int err;
+	char bsg_name[20];
+
+	fcpinit->rqst_q = NULL;
+
+	if (!fcpinit->f->bsg_request)
+		return -ENOTSUPP;
+
+	snprintf(bsg_name, sizeof(bsg_name),
+		 "fcpinit%d", shost->host_no);
+
+	q = __scsi_alloc_queue(shost, fcp_bsg_host_handler);
+	if (!q) {
+		printk(KERN_ERR "fcpinit%d: bsg interface failed to "
+		       "initialize - no request queue\n",
+		       shost->host_no);
+		return -ENOMEM;
+	}
+
+	q->queuedata = shost;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, fcp_bsg_softirq_done);
+	blk_queue_rq_timed_out(q, fcp_bsg_job_timeout);
+	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
+
+	err = bsg_register_queue(q, dev, bsg_name, NULL);
+	if (err) {
+		printk(KERN_ERR "fcpinit%d: bsg interface failed to "
+		       "initialize - register queue\n",
+		       shost->host_no);
+		blk_cleanup_queue(q);
+		return err;
+	}
+
+	fcpinit->rqst_q = q;
+	return 0;
+}
+
+/**
+ * fcp_bsg_remove() - Deletes the bsg hooks on fchosts/fcptargs
+ * @q:	the request_queue that is to be torn down.
+ */
+void fcp_bsg_remove(struct request_queue *q)
+{
+	if (q) {
+		bsg_unregister_queue(q);
+		blk_cleanup_queue(q);
+	}
+}
+
+/**
+ * fcp_targ_dev_release() - Free the fcptarg's memory
+ * @dev: The fcptarg's embedded device
+ *
+ * Called when the last fcptarg reference is released.
+ */
+static void fcp_targ_dev_release(struct device *dev)
+{
+	struct fcp_targ *fcptarg = dev_to_fcptarg(dev);
+	kfree(fcptarg);
+}
+
+/**
+ * scsi_is_fcptarg() - Determines if a device is a fcptarg
+ * @dev: The device to check
+ */
+int scsi_is_fcptarg(const struct device *dev)
+{
+	return dev->release == fcp_targ_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_fcptarg);
+
+/**
+ * fcp_targ_probe() - Create a SCSI-FCP targ device
+ * @dev: The embedded device in the FC rport
+ *
+ * Called from the FC layer when an rport is added to
+ * a SCSI-FCP capable initiator. Attaches the FC rport
+ * to the scsi_target device.
+ */
+static int fcp_targ_probe(struct device *dev)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	struct fcp_init *fcpinit = fcvport_to_fcpinit(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	struct fcp_targ *fcptarg;
+	int error = 0;
+	int count = 0;
+
+	fcptarg = kzalloc(sizeof(struct fcp_targ), GFP_KERNEL);
+	if (unlikely(!fcptarg)) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	dev_set_drvdata(dev, fcptarg);
+	fcptarg->rport = rport;
+	fcptarg->fcpinit = fcpinit;
+
+	INIT_WORK(&fcptarg->stgt_delete_work, fcp_starget_delete_work);
+	INIT_WORK(&fcptarg->scan_work, fcp_scsi_scan_rport);
+
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
+		fcptarg->scsi_target_id = fcpinit->next_target_id++;
+	else
+		fcptarg->scsi_target_id = -1;
+
+	device_initialize(&fcptarg->dev);  /* takes self reference */
+	fcptarg->dev.parent = get_device(&shost->shost_gendev);
+
+	fcptarg->dev.release = fcp_targ_dev_release;
+	dev_set_name(&fcptarg->dev, "fcptarg-%d:%d-%d",
+		     shost->host_no, rport->channel, rport->number);
+
+	error = device_add(&fcptarg->dev);
+	if (error)
+		goto out_del;
+
+	fcp_bsg_targadd(fcpinit, fcptarg);
+	/* ignore any bsg add error - we just can't do sgio */
+
+	FC_SETUP_ATTR_RD_NS(fcptarg, scsi_target_id);
+
+	BUG_ON(count > FCP_TARG_NUM_ATTRS);
+	FC_CREATE_ATTRS(fcptarg, count);
+
+	if (error || count != 0) {
+		error = -EINVAL;
+		goto out_del_dev;
+	}
+
+	return 0;
+
+out_del_dev:
+	put_device(&shost->shost_gendev);
+out_del:
+	kfree(fcptarg);
+out:
+	return error;
+}
+
+/**
+ * fcp_targ_remove() - Delete a fcptarg from sysfs
+ * @dev: The FC rport associated with the fcptarg
+ */
+static int fcp_targ_remove(struct device *dev)
+{
+	struct fc_rport *rport = dev_to_fcrport(dev);
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+
+	fcp_bsg_remove(fcptarg->rqst_q);
+
+	/* Delete SCSI target and sdevs */
+	if (fcptarg->scsi_target_id != -1)
+		fcp_starget_delete(rport);
+
+	device_del(&fcptarg->dev);
+	put_device(fcptarg->dev.parent);
+	put_device(&fcptarg->dev);
+
+	return 0;
+}
+
+/**
+ * fcp_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
+ * @cmnd: SCSI command that scsi_eh is trying to recover
+ *
+ * This routine can be called from a FC LLD scsi_eh callback. It
+ * blocks the scsi_eh thread until the fc_rport leaves the
+ * FC_PORTSTATE_BLOCKED. This is necessary to avoid the scsi_eh
+ * failing recovery actions for blocked rports which would lead to
+ * offlined SCSI devices.
+ */
+int fcp_block_scsi_eh(struct scsi_cmnd *cmnd)
+{
+	struct fcp_targ *fcptarg = starget_to_fcptarg(
+		scsi_target(cmnd->device));
+	struct fc_rport *rport = fcptarg->rport;
+	struct fcp_init *fcpinit = fcptarg->fcpinit;
+	struct fc_vport *fcvport = fcpinit_to_fcvport(fcpinit);
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(&fcvport->lock, flags);
+		msleep(1000);
+		spin_lock_irqsave(&fcvport->lock, flags);
+	}
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+		return FAST_IO_FAIL;
+
+	return 0;
+}
+EXPORT_SYMBOL(fcp_block_scsi_eh);
+
+/*
+ * BSG support
+ */
+
+/**
+ * fcp_destroy_bsgjob - routine to teardown/delete a fc bsg job
+ * @job:	fcp_bsg_job that is to be torn down
+ */
+static void fcp_destroy_bsgjob(struct fcp_bsg_job *job)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->ref_cnt) {
+		spin_unlock_irqrestore(&job->job_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	put_device(job->dev);	/* release reference for the request */
+
+	kfree(job->request_payload.sg_list);
+	kfree(job->reply_payload.sg_list);
+	kfree(job);
+}
+
+/**
+ * fcp_bsg_jobdone - completion routine for bsg requests that the LLD has
+ *                   completed
+ * @job:	fcp_bsg_job that is complete
+ */
+static void fcp_bsg_jobdone(struct fcp_bsg_job *job)
+{
+	struct request *req = job->req;
+	struct request *rsp = req->next_rq;
+	int err;
+
+	err = job->req->errors = job->reply->result;
+
+	if (err < 0)
+		/* we're only returning the result field in the reply */
+		job->req->sense_len = sizeof(uint32_t);
+	else
+		job->req->sense_len = job->reply_len;
+
+	/* we assume all request payload was transferred, residual == 0 */
+	req->resid_len = 0;
+
+	if (rsp) {
+		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
+
+		/* set reply (bidi) residual */
+		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
+				      rsp->resid_len);
+	}
+	blk_complete_request(req);
+}
+
+/**
+ * fcp_bsg_softirq_done - softirq done routine for destroying the bsg requests
+ * @rq:        BSG request that holds the job to be destroyed
+ */
+static void fcp_bsg_softirq_done(struct request *rq)
+{
+	struct fcp_bsg_job *job = rq->special;
+	unsigned long flags;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	job->state_flags |= FC_RQST_STATE_DONE;
+	job->ref_cnt--;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	blk_end_request_all(rq, rq->errors);
+	fcp_destroy_bsgjob(job);
+}
+
+/**
+ * fcp_bsg_job_timeout - handler for when a bsg request timesout
+ * @req:	request that timed out
+ */
+static enum blk_eh_timer_return fcp_bsg_job_timeout(struct request *req)
+{
+	struct fcp_bsg_job *job = (void *) req->special;
+	struct Scsi_Host *shost = job->shost;
+	struct fcp_init *fcpinit = shost_priv(shost);
+	unsigned long flags;
+	int err = 0, done = 0;
+
+	if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
+		return BLK_EH_RESET_TIMER;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->state_flags & FC_RQST_STATE_DONE)
+		done = 1;
+	else
+		job->ref_cnt++;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	if (!done && fcpinit->f->bsg_timeout) {
+		/* call LLDD to abort the i/o as it has timed out */
+		err = fcpinit->f->bsg_timeout(job);
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
+			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
+			       "abort failed with status %d\n", err);
+	}
+
+	/* the blk_end_sync_io() doesn't check the error */
+	if (done)
+		return BLK_EH_NOT_HANDLED;
+	else
+		return BLK_EH_HANDLED;
+}
+
+static int fcp_bsg_map_buffer(struct fcp_bsg_buffer *buf, struct request *req)
+{
+	size_t sz = (sizeof(struct scatterlist)*req->nr_phys_segments);
+
+	BUG_ON(!req->nr_phys_segments);
+
+	buf->sg_list = kzalloc(sz, GFP_KERNEL);
+	if (!buf->sg_list)
+		return -ENOMEM;
+	sg_init_table(buf->sg_list, req->nr_phys_segments);
+	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
+	buf->payload_len = blk_rq_bytes(req);
+	return 0;
+}
+
+
+/**
+ * fcp_req_to_bsgjob - Allocate/create the fcp_bsg_job structure for the
+ *                     bsg request
+ * @shost:	SCSI Host corresponding to the bsg object
+ * @rport:	(optional) FC Remote Port corresponding to the bsg object
+ * @req:	BSG request that needs a job structure
+ */
+static int fcp_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
+			     struct request *req)
+{
+	struct fcp_init *fcpinit = shost_priv(shost);
+	struct request *rsp = req->next_rq;
+	struct fcp_bsg_job *job;
+	int ret;
+
+	BUG_ON(req->special);
+
+	job = kzalloc(sizeof(struct fcp_bsg_job) + fcpinit->f->dd_bsg_size,
+		      GFP_KERNEL);
+	if (!job)
+		return -ENOMEM;
+
+	/*
+	 * Note: this is a bit silly.
+	 * The request gets formatted as a SGIO v4 ioctl request, which
+	 * then gets reformatted as a blk request, which then gets
+	 * reformatted as a fc bsg request. And on completion, we have
+	 * to wrap return results such that SGIO v4 thinks it was a scsi
+	 * status.  I hope this was all worth it.
+	 */
+
+	req->special = job;
+	job->shost = shost;
+	job->rport = rport;
+	job->req = req;
+	if (fcpinit->f->dd_bsg_size)
+		job->dd_data = (void *)&job[1];
+	spin_lock_init(&job->job_lock);
+	job->request = (struct fc_bsg_request *)req->cmd;
+	job->request_len = req->cmd_len;
+	job->reply = req->sense;
+	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
+						 * allocated */
+	if (req->bio) {
+		ret = fcp_bsg_map_buffer(&job->request_payload, req);
+		if (ret)
+			goto failjob_rls_job;
+	}
+	if (rsp && rsp->bio) {
+		ret = fcp_bsg_map_buffer(&job->reply_payload, rsp);
+		if (ret)
+			goto failjob_rls_rqst_payload;
+	}
+	job->job_done = fcp_bsg_jobdone;
+	if (rport)
+		job->dev = &rport->dev;
+	else
+		job->dev = &shost->shost_gendev;
+	get_device(job->dev);		/* take a reference for the request */
+
+	job->ref_cnt = 1;
+
+	return 0;
+
+
+failjob_rls_rqst_payload:
+	kfree(job->request_payload.sg_list);
+failjob_rls_job:
+	kfree(job);
+	return -ENOMEM;
+}
+
+enum fc_dispatch_result {
+	FC_DISPATCH_BREAK,	/* on return, q is locked, break from q loop */
+	FC_DISPATCH_LOCKED,	/* on return, q is locked, continue on */
+	FC_DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
+};
+
+/**
+ * fcp_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
+ * @q:		fc host request queue
+ * @shost:	scsi host rport attached to
+ * @job:	bsg job to be processed
+ */
+static enum fc_dispatch_result
+fcp_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+		      struct fcp_bsg_job *job)
+{
+	struct fcp_init *fcpinit = shost_priv(shost);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* Validate the host command */
+	switch (job->request->msgcode) {
+	case FC_BSG_HST_ADD_RPORT:
+		cmdlen += sizeof(struct fc_bsg_host_add_rport);
+		break;
+
+	case FC_BSG_HST_DEL_RPORT:
+		cmdlen += sizeof(struct fc_bsg_host_del_rport);
+		break;
+
+	case FC_BSG_HST_ELS_NOLOGIN:
+		cmdlen += sizeof(struct fc_bsg_host_els);
+		/* there better be a xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		break;
+
+	case FC_BSG_HST_CT:
+		cmdlen += sizeof(struct fc_bsg_host_ct);
+		/* there better be xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		break;
+
+	case FC_BSG_HST_VENDOR:
+		cmdlen += sizeof(struct fc_bsg_host_vendor);
+		if ((shost->hostt->vendor_id == 0L) ||
+		    (job->request->rqst_data.h_vendor.vendor_id !=
+		     shost->hostt->vendor_id)) {
+			ret = -ESRCH;
+			goto fail_host_msg;
+		}
+		break;
+
+	default:
+		ret = -EBADR;
+		goto fail_host_msg;
+	}
+
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
+	ret = fcpinit->f->bsg_request(job);
+	if (!ret)
+		return FC_DISPATCH_UNLOCKED;
+
+fail_host_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->reply_payload_rcv_len = 0;
+	job->reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	fcp_bsg_jobdone(job);
+	return FC_DISPATCH_UNLOCKED;
+}
+
+
+/*
+ * fcp_bsg_goose_queue - restart rport queue in case it was stopped
+ * @rport:	rport to be restarted
+ */
+static void fcp_bsg_goose_queue(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	int flagset;
+	unsigned long flags;
+
+	if (!fcptarg->rqst_q)
+		return;
+
+	get_device(&fcptarg->dev);
+
+	spin_lock_irqsave(fcptarg->rqst_q->queue_lock, flags);
+	flagset = test_bit(QUEUE_FLAG_REENTER, &fcptarg->rqst_q->queue_flags) &&
+		!test_bit(QUEUE_FLAG_REENTER, &fcptarg->rqst_q->queue_flags);
+	if (flagset)
+		queue_flag_set(QUEUE_FLAG_REENTER, fcptarg->rqst_q);
+	__blk_run_queue(fcptarg->rqst_q);
+	if (flagset)
+		queue_flag_clear(QUEUE_FLAG_REENTER, fcptarg->rqst_q);
+	spin_unlock_irqrestore(fcptarg->rqst_q->queue_lock, flags);
+
+	put_device(&fcptarg->dev);
+}
+
+/**
+ * fcp_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
+ * @q:		rport request queue
+ * @shost:	scsi host rport attached to
+ * @rport:	rport request destined to
+ * @job:	bsg job to be processed
+ */
+static enum fc_dispatch_result
+fcp_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+		       struct fc_rport *rport, struct fcp_bsg_job *job)
+{
+	struct fcp_init *fcpinit = shost_priv(shost);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* Validate the rport command */
+	switch (job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+		cmdlen += sizeof(struct fc_bsg_rport_els);
+		goto check_bidi;
+
+	case FC_BSG_RPT_CT:
+		cmdlen += sizeof(struct fc_bsg_rport_ct);
+check_bidi:
+		/* there better be xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_rport_msg;
+		}
+		break;
+	default:
+		ret = -EBADR;
+		goto fail_rport_msg;
+	}
+
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_rport_msg;
+	}
+
+	ret = fcpinit->f->bsg_request(job);
+	if (!ret)
+		return FC_DISPATCH_UNLOCKED;
+
+fail_rport_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->reply_payload_rcv_len = 0;
+	job->reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	fcp_bsg_jobdone(job);
+	return FC_DISPATCH_UNLOCKED;
+}
+
+
+/**
+ * fcp_bsg_request_handler - generic handler for bsg requests
+ * @q:		request queue to manage
+ * @shost:	Scsi_Host related to the bsg object
+ * @rport:	FC remote port related to the bsg object (optional)
+ * @dev:	device structure for bsg object
+ */
+static void fcp_bsg_request_handler(struct request_queue *q,
+				    struct Scsi_Host *shost,
+				    struct fcp_targ *fcptarg,
+				    struct device *dev)
+{
+	struct fc_rport *rport = fcptarg->rport;
+	struct request *req;
+	struct fcp_bsg_job *job;
+	enum fc_dispatch_result ret;
+
+	if (!get_device(dev))
+		return;
+
+	while (!blk_queue_plugged(q)) {
+		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
+		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
+			break;
+
+		req = blk_fetch_request(q);
+		if (!req)
+			break;
+
+		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
+			req->errors = -ENXIO;
+			spin_unlock_irq(q->queue_lock);
+			blk_end_request(req, -ENXIO, blk_rq_bytes(req));
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		spin_unlock_irq(q->queue_lock);
+
+		ret = fcp_req_to_bsgjob(shost, rport, req);
+		if (ret) {
+			req->errors = ret;
+			blk_end_request(req, ret, blk_rq_bytes(req));
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		job = req->special;
+
+		/* check if we have the msgcode value at least */
+		if (job->request_len < sizeof(uint32_t)) {
+			BUG_ON(job->reply_len < sizeof(uint32_t));
+			job->reply->reply_payload_rcv_len = 0;
+			job->reply->result = -ENOMSG;
+			job->reply_len = sizeof(uint32_t);
+			fcp_bsg_jobdone(job);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		/* the dispatch routines will unlock the queue_lock */
+		if (rport)
+			ret = fcp_bsg_rport_dispatch(q, shost, rport, job);
+		else
+			ret = fcp_bsg_host_dispatch(q, shost, job);
+
+		/* did dispatcher hit state that can't process any more */
+		if (ret == FC_DISPATCH_BREAK)
+			break;
+
+		/* did dispatcher had released the lock */
+		if (ret == FC_DISPATCH_UNLOCKED)
+			spin_lock_irq(q->queue_lock);
+	}
+
+	spin_unlock_irq(q->queue_lock);
+	put_device(dev);
+	spin_lock_irq(q->queue_lock);
+}
+
+/**
+ * fcp_bsg_targ_handler - handler for bsg requests for a fc rport
+ * @q:		rport request queue
+ */
+static void fcp_bsg_targ_handler(struct request_queue *q)
+{
+	struct fcp_targ *fcptarg = q->queuedata;
+	struct Scsi_Host *shost = fcptarg_to_shost(fcptarg);
+
+	fcp_bsg_request_handler(q, shost, fcptarg, &fcptarg->dev);
+}
+
+/**
+ * fcp_bsg_fcptargadd - Create and add the bsg hooks so we can receive requests
+ * @shost:	shost that rport is attached to
+ * @rport:	rport that the bsg hooks are being attached to
+ */
+static int fcp_bsg_targadd(struct fcp_init *fcpinit,
+			   struct fcp_targ *fcptarg)
+{
+	struct device *dev = &fcptarg->dev;
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	struct request_queue *q;
+	int err;
+
+	fcptarg->rqst_q = NULL;
+
+	if (!fcpinit->f->bsg_request)
+		return -ENOTSUPP;
+
+	q = __scsi_alloc_queue(shost, fcp_bsg_targ_handler);
+	if (!q) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+		       "initialize - no request queue\n",
+		       dev->kobj.name);
+		return -ENOMEM;
+	}
+
+	q->queuedata = fcptarg;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, fcp_bsg_softirq_done);
+	blk_queue_rq_timed_out(q, fcp_bsg_job_timeout);
+	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
+
+	err = bsg_register_queue(q, dev, NULL, NULL);
+	if (err) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+		       "initialize - register queue\n",
+		       dev->kobj.name);
+		blk_cleanup_queue(q);
+		return err;
+	}
+
+	fcptarg->rqst_q = q;
+	return 0;
+}
+
+static void fcp_targ_block(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	scsi_target_block(&fcptarg->dev);
+}
+
+static void fcp_targ_unblock(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	scsi_target_unblock(&fcptarg->dev);
+}
+
+static void fcp_targ_terminate_io(struct fc_rport *rport)
+{
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	if (rport->f->terminate_rport_io)
+		rport->f->terminate_rport_io(rport);
+
+	/*
+	 * must unblock to flush queued IO. The caller will have set
+	 * the port_state or flags, so that fc_remote_port_chkready will
+	 * fail IO.
+	 */
+	fcp_targ_unblock(rport);
+}
+
+static void fcp_starget_delete(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	fcp_targ_terminate_io(rport);
+	scsi_remove_target(&fcptarg->dev);
+}
+
+/**
+ * fcp_starget_delete - called to delete the scsi decendents of an rport
+ * @work:	remote port to be operated on.
+ *
+ * Deletes target and all sdevs.
+ */
+static void fcp_starget_delete_work(struct work_struct *work)
+{
+	struct fcp_targ *fcptarg =
+		container_of(work, struct fcp_targ, stgt_delete_work);
+	struct fc_rport *rport = fcptarg_to_rport(fcptarg);
+	fcp_starget_delete(rport);
+}
+
+static void fcp_queue_starget_delete(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	fc_vport_queue_work(fcvport, &fcptarg->stgt_delete_work);
+}
+
+static void fcp_targ_queue_scan(struct fc_rport *rport)
+{
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	struct Scsi_Host *shost = fcptarg_to_shost(fcptarg);
+	scsi_queue_work(shost, &fcptarg->scan_work);
+}
+
+/**
+ * fcp_scsi_scan_rport - called to perform a scsi scan on a remote port.
+ * @work:	remote port to be scanned.
+ */
+static void fcp_scsi_scan_rport(struct work_struct *work)
+{
+	struct fcp_targ *fcptarg =
+		container_of(work, struct fcp_targ, scan_work);
+	struct fc_rport *rport;
+	struct fc_vport *fcvport;
+	unsigned long flags;
+
+	rport = fcptarg_to_rport(fcptarg);
+	fcvport = rport_to_fcvport(rport);
+
+	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
+	    !(rport->f->disable_target_scan)) {
+		scsi_scan_target(&fcptarg->dev,
+				 rport->channel,
+				 fcptarg->scsi_target_id,
+				 SCAN_WILD_CARD, 1);
+	}
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	rport->flags &= ~FC_RPORT_SCAN_PENDING;
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+}
+
+static void fcp_init_scsi_flush_work(struct fc_vport *fcvport)
+{
+	struct fcp_init *fcpinit = fcvport_to_fcpinit(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	scsi_flush_work(shost);
+}
+
+/*
+ * Return 1 to create, 0 to skip creation
+ */
+static int fcp_targ_rolechg(struct fc_rport *rport, u32 roles)
+{
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	struct fcp_init *fcpinit = fcvport_to_fcpinit(fcvport);
+	struct fcp_targ *fcptarg = rport_to_fcptarg(rport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	int create = 0;
+	int ret;
+
+	if (roles & FC_PORT_ROLE_FCP_TARGET) {
+		if (fcptarg->scsi_target_id == -1) {
+			fcptarg->scsi_target_id = fcpinit->next_target_id++;
+			create = 1;
+		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
+			create = 1;
+	} else if (shost->active_mode & MODE_TARGET) {
+		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
+					     (char *)&rport->node_name);
+		if (ret)
+			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
+			       ret);
+	}
+
+	return create;
+}
+
+/**
+ * fcp_targ_final_delete() - Final delete routine for the fcp_targ
+ * @rport: The FC rport associated with the fcp_targ
+ */
+static void fcp_targ_final_delete(struct fc_rport *rport)
+{
+	struct fc_vport *fcvport = rport_to_fcvport(rport);
+	struct fcp_init *fcpinit = fcvport_to_fcpinit(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+
+	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
+	    shost->active_mode & MODE_TARGET)
+		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
+}
+
+static struct fc4_template fcp_fc4_template = {
+	.fc4_bsg_goose_queue = fcp_bsg_goose_queue,
+	.fc4_targ_block = fcp_targ_block,
+	.fc4_targ_unblock = fcp_targ_unblock,
+	.fc4_targ_terminate_io = fcp_targ_terminate_io,
+	.fc4_starget_delete = fcp_starget_delete,
+	.fc4_queue_starget_delete = fcp_queue_starget_delete,
+	.fc4_targ_queue_scan = fcp_targ_queue_scan,
+	.fc4_init_scsi_flush_work = fcp_init_scsi_flush_work,
+	.fc4_targ_rolechg = fcp_targ_rolechg,
+	.fc4_targ_final_delete = fcp_targ_final_delete,
+};
+
+struct device_driver fcp_targ_drv = {
+	.name = "fcp_target",
+	.bus = &fc_rport_bus_type,
+	.probe = fcp_targ_probe,
+	.remove = fcp_targ_remove,
+};
+
+struct device_driver fcp_init_drv = {
+	.name = "fcp_initiator",
+	.bus = &fc_vport_bus_type,
+	.probe = fcp_init_probe,
+	.remove = fcp_init_remove,
+};
+
+/**
+ * fcp_transport_init() - Initialize the FCP transport
+ *
+ * Registers the FCP transport with the FC module.
+ */
+static __init int fcp_transport_init(void)
+{
+	int error;
+	error = driver_register(&fcp_init_drv);
+	if (error)
+		goto err;
+
+	error = driver_register(&fcp_targ_drv);
+	if (error)
+		goto unreg_init;
+
+	return 0;
+
+unreg_init:
+	driver_unregister(&fcp_targ_drv);
+err:
+	return error;
+}
+
+/**
+ * fcp_transport_exit() - Tear down the FCP transport
+ *
+ * Unregisters the FCP transport with the FC module.
+ */
+static void __exit fcp_transport_exit(void)
+{
+	driver_unregister(&fcp_targ_drv);
+	driver_unregister(&fcp_init_drv);
+}
+
+/* Original Author:  Martin Hicks */
+/* Major Updates by: James Smart */
+MODULE_AUTHOR("Robert Love");
+MODULE_DESCRIPTION("FCP Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(fcp_transport_init);
+module_exit(fcp_transport_exit);
diff --git a/include/scsi/scsi_transport_fcp.h b/include/scsi/scsi_transport_fcp.h
new file mode 100644
index 0000000..ca13b48
--- /dev/null
+++ b/include/scsi/scsi_transport_fcp.h
@@ -0,0 +1,307 @@
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
+#ifndef _FCP_H_
+#define _FCP_H_
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+
+#include <scsi/scsi_transport_fcp.h>
+#include <fc/fc.h>
+
+/*
+ * FC SCSI Target Attributes
+ *
+ * The SCSI Target is considered an extention of a remote port (as
+ * a remote port can be more than a SCSI Target). Within the scsi
+ * subsystem, we leave the Target as a separate entity. Doing so
+ * provides backward compatibility with prior FC transport api's,
+ * and lets remote ports be handled entirely within the FC transport
+ * and independently from the scsi subsystem. The drawback is that
+ * some data will be duplicated.
+ */
+
+struct fc_starget_attrs {	/* aka fc_target_attrs */
+	/* Dynamic Attributes */
+	u64 node_name;
+	u64 port_name;
+	u32 port_id;
+};
+
+#define fc_starget_node_name(x)						\
+	(((struct fc_starget_attrs *)&(x)->starget_data)->node_name)
+#define fc_starget_port_name(x)						\
+	(((struct fc_starget_attrs *)&(x)->starget_data)->port_name)
+#define fc_starget_port_id(x)						\
+	(((struct fc_starget_attrs *)&(x)->starget_data)->port_id)
+
+/*
+ * FC Local Port (Host) Statistics
+ */
+
+/* FC Statistics - Following FC HBAAPI v2.0 guidelines */
+struct fcp_init_statistics {
+	/* port statistics */
+	u64 seconds_since_last_reset;
+	u64 tx_frames;
+	u64 tx_words;
+	u64 rx_frames;
+	u64 rx_words;
+	u64 lip_count;
+	u64 nos_count;
+	u64 error_frames;
+	u64 dumped_frames;
+	u64 link_failure_count;
+	u64 loss_of_sync_count;
+	u64 loss_of_signal_count;
+	u64 prim_seq_protocol_err_count;
+	u64 invalid_tx_word_count;
+	u64 invalid_crc_count;
+
+	/* fc4 statistics  (only FCP supported currently) */
+	u64 fcp_input_requests;
+	u64 fcp_output_requests;
+	u64 fcp_control_requests;
+	u64 fcp_input_megabytes;
+	u64 fcp_output_megabytes;
+};
+
+/*
+ * FC Event Codes - Polled and Async, following FC HBAAPI v2.0 guidelines
+ */
+
+/*
+ * fcp_init_event_code: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fcp_init_event_code  {
+	FCH_EVT_LIP			= 0x1,
+	FCH_EVT_LINKUP			= 0x2,
+	FCH_EVT_LINKDOWN		= 0x3,
+	FCH_EVT_LIPRESET		= 0x4,
+	FCH_EVT_RSCN			= 0x5,
+	FCH_EVT_ADAPTER_CHANGE		= 0x103,
+	FCH_EVT_PORT_UNKNOWN		= 0x200,
+	FCH_EVT_PORT_OFFLINE		= 0x201,
+	FCH_EVT_PORT_ONLINE		= 0x202,
+	FCH_EVT_PORT_FABRIC		= 0x204,
+	FCH_EVT_LINK_UNKNOWN		= 0x500,
+	FCH_EVT_VENDOR_UNIQUE		= 0xffff,
+};
+
+#define FC_SYMBOLIC_NAME_SIZE		256
+
+struct fcp_bsg_buffer {
+	unsigned int payload_len;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+};
+
+/* Values for fc_bsg_job->state_flags (bitflags) */
+#define FC_RQST_STATE_INPROGRESS	0
+#define FC_RQST_STATE_DONE		1
+
+struct fcp_bsg_job {
+	struct Scsi_Host *shost;
+	struct fc_rport *rport;
+	struct device *dev;
+	struct request *req;
+	spinlock_t job_lock;
+	unsigned int state_flags;
+	unsigned int ref_cnt;
+	void (*job_done)(struct fcp_bsg_job *);
+
+	struct fc_bsg_request *request;
+	struct fc_bsg_reply *reply;
+	unsigned int request_len;
+	unsigned int reply_len;
+	/*
+	 * On entry : reply_len indicates the buffer size allocated for
+	 * the reply.
+	 *
+	 * Upon completion : the message handler must set reply_len
+	 *  to indicates the size of the reply to be returned to the
+	 *  caller.
+	 */
+
+	/* DMA payloads for the request/response */
+	struct fcp_bsg_buffer request_payload;
+	struct fcp_bsg_buffer reply_payload;
+
+	void *dd_data;			/* Used for driver-specific storage */
+};
+
+#define FCP_TARG_NUM_ATTRS   1
+struct fcp_targ {
+	struct device dev;
+	struct device_attribute attrs[FCP_TARG_NUM_ATTRS];
+	struct fc_rport *rport;
+	struct fcp_init *fcpinit;
+	struct request_queue *rqst_q;	/* bsg support */
+	struct work_struct stgt_delete_work;
+	struct work_struct scan_work;
+	u32 scsi_target_id;
+};
+
+#define	dev_to_fcptarg(d)			\
+	container_of((d), struct fcp_targ, dev)
+#define fcptarg_to_rport(t)			\
+	((t)->rport)
+#define fcp_targ_scsi_target_id(x)		\
+	((x)->scsi_target_id)
+
+struct fcp_init {
+	struct device    dev;
+	struct fcp_template *f;
+
+	struct Scsi_Host *shost;
+	struct fc_vport *fcvport;
+
+	struct fcp_init_statistics fcp_stats;
+
+	u32 next_target_id;
+
+	/* bsg support */
+	struct request_queue *rqst_q;
+};
+
+#define fcpinit_to_fcvport(x)			\
+	((x)->fcvport)
+
+#define fcpinit_next_target_id(x)		\
+	((x)->next_target_id)
+
+/* The functions by which the transport class and the driver communicate
+struct fc_function_template {
+
+	 target-mode drivers' functions 
+	int     (*tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
+	int     (*it_nexus_response)(struct Scsi_Host *, u64, int);
+
+	
+	 * The driver sets these to tell the transport class it
+	 * wants the attributes displayed in sysfs.  If the show_ flag
+	 * is not set, the attribute will be private to the transport
+	 * class
+	 
+};
+
+
+struct scsi_transport_template *fc_attach_transport(
+	struct fc_function_template *);
+void fc_release_transport(struct scsi_transport_template *);
+*/
+
+#define dev_to_fcpinit(d)			\
+	container_of((d), struct fcp_init, dev)
+
+#define fcpinit_to_fcvport(x)			\
+	((x)->fcvport)
+
+void fcpinit_post_event(struct Scsi_Host *shost, u32 event_number,
+			enum fcp_init_event_code event_code, u32 event_data);
+void fcpinit_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
+			       u32 data_len, char *data_buf, u64 vendor_id);
+
+
+int scsi_is_fcptarg(const struct device *dev);
+int fcp_block_scsi_eh(struct scsi_cmnd *cmnd);
+
+#define starget_to_fcptarg(s)						\
+	scsi_is_fcptarg(s->dev.parent) ?				\
+	container_of((s->dev.parent),					\
+		     struct fcp_targ, dev) : NULL
+
+#define rport_to_fcptarg(r)					\
+	((struct fcp_targ *)(dev_get_drvdata(&(r)->dev)))
+
+#define fcptarg_to_shost(t)						\
+	container_of(((t)->dev.parent), struct Scsi_Host, shost_gendev)
+
+#define fcptarg_to_fcpinit(t)			\
+	((t)->fcpinit)
+
+#define fcvport_to_fcpinit(v)			\
+	((struct fcp_init *)(dev_get_drvdata(&(v)->dev)))
+
+#define fcpinit_to_shost(i)			\
+	((i)->shost)
+
+/**
+ * fc_remote_port_chkready - called to validate the remote port state
+ *   prior to initiating io to the port.
+ *
+ * Returns a scsi result code that can be returned by the LLDD.
+ *
+ * @rport:	remote port to be checked
+ **/
+static inline int fc_remote_port_chkready(struct fc_rport *rport)
+{
+	int result;
+
+	switch (rport->port_state) {
+	case FC_PORTSTATE_ONLINE:
+		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
+			result = 0;
+		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
+			result = DID_IMM_RETRY << 16;
+		else
+			result = DID_NO_CONNECT << 16;
+		break;
+	case FC_PORTSTATE_BLOCKED:
+		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+			result = DID_TRANSPORT_FAILFAST << 16;
+		else
+			result = DID_IMM_RETRY << 16;
+		break;
+	default:
+		result = DID_NO_CONNECT << 16;
+		break;
+	}
+	return result;
+}
+
+/**
+ * fcp_init_priv() - Return the private data from a local port
+ */
+static inline void *fcp_init_priv(const struct fcp_init *fcpinit)
+{
+	return (void *)(fcpinit + 1);
+}
+
+struct fcp_template {
+	int fcpinit_priv_size;
+	void (*fcp_fcpinit_add)(struct fcp_init *fcpinit);
+	void (*fcp_fcpinit_del)(struct fcp_init *fcpinit);
+	struct scsi_host_template shost_template;
+
+	struct fcp_init_statistics * (*get_fcpinit_stats)(struct fcp_init *);
+	void (*reset_fcpinit_stats)(struct fcp_init *);
+
+	/* bsg support */
+	int	(*bsg_request)(struct fcp_bsg_job *);
+	int	(*bsg_timeout)(struct fcp_bsg_job *);
+
+	/* host dynamic attributes */
+	unsigned long	show_fcpinit_port_state:1;
+
+	/* TODO: Is this in the right place? */
+	u32				dd_bsg_size;
+};
+
+#endif /* _FCP_H_ */

