From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Tue, 18 Nov 2008 14:21:11 -0800
Message-ID: <20081118222111.2289.35843.stgit@fritz>
References: <20081118222051.2289.81361.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYKRWVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 17:21:21 -0500
In-Reply-To: <20081118222051.2289.81361.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: jgarzik@redhat.com, james.smart@emulex.com, davem@davemloft.net, michaelc@cs.wisc.edu, jeffrey.t.kirsher@intel.com, jeykholt@cisco.com

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig          |    6 
 drivers/scsi/Makefile         |    1 
 drivers/scsi/libfc/Makefile   |   12 
 drivers/scsi/libfc/fc_disc.c  |  932 ++++++++++++++++++
 drivers/scsi/libfc/fc_elsct.c |   71 +
 drivers/scsi/libfc/fc_exch.c  | 1971 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_fcp.c   | 2130 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_frame.c |   89 ++
 drivers/scsi/libfc/fc_lport.c | 1525 +++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_rport.c | 1277 +++++++++++++++++++++++++
 include/scsi/fc_encode.h      |  309 ++++++
 include/scsi/fc_frame.h       |  239 +++++
 include/scsi/libfc.h          |  917 ++++++++++++++++++
 13 files changed, 9479 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/libfc/Makefile
 create mode 100644 drivers/scsi/libfc/fc_disc.c
 create mode 100644 drivers/scsi/libfc/fc_elsct.c
 create mode 100644 drivers/scsi/libfc/fc_exch.c
 create mode 100644 drivers/scsi/libfc/fc_fcp.c
 create mode 100644 drivers/scsi/libfc/fc_frame.c
 create mode 100644 drivers/scsi/libfc/fc_lport.c
 create mode 100644 drivers/scsi/libfc/fc_rport.c
 create mode 100644 include/scsi/fc_encode.h
 create mode 100644 include/scsi/fc_frame.h
 create mode 100644 include/scsi/libfc.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 403ecad..860c935 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -603,6 +603,12 @@ config SCSI_FLASHPOINT
 	  substantial, so users of MultiMaster Host Adapters may not
 	  wish to include it.
 
+config LIBFC
+	tristate "LibFC module"
+	depends on SCSI && SCSI_FC_ATTRS
+	---help---
+	  Fibre Channel library module
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72fd504..9158dc6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
+obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
diff --git a/drivers/scsi/libfc/Makefile b/drivers/scsi/libfc/Makefile
new file mode 100644
index 0000000..55f982d
--- /dev/null
+++ b/drivers/scsi/libfc/Makefile
@@ -0,0 +1,12 @@
+# $Id: Makefile
+
+obj-$(CONFIG_LIBFC) += libfc.o
+
+libfc-objs := \
+	fc_disc.o \
+	fc_exch.o \
+	fc_elsct.o \
+	fc_frame.o \
+	fc_lport.o \
+	fc_rport.o \
+	fc_fcp.o
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
new file mode 100644
index 0000000..aee2f9c
--- /dev/null
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -0,0 +1,932 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * Target Discovery
+ *
+ * This block discovers all FC-4 remote ports, including FCP initiators. It
+ * also handles RSCN events and re-discovery if necessary.
+ */
+
+#include <linux/timer.h>
+#include <linux/err.h>
+#include <asm/unaligned.h>
+
+#include <scsi/fc/fc_gs.h>
+
+#include <scsi/libfc.h>
+
+#define FC_DISC_RETRY_LIMIT	3	/* max retries */
+#define FC_DISC_RETRY_DELAY	500UL	/* (msecs) delay */
+
+#define	FC_DISC_DELAY		3
+
+static int fc_disc_debug;
+
+#define FC_DEBUG_DISC(fmt...)			\
+	do {					\
+		if (fc_disc_debug)		\
+			FC_DBG(fmt);		\
+	} while (0)
+
+static struct mutex		disc_list_lock;
+static struct list_head		disc_list;
+
+struct fc_disc {
+	unsigned char		retry_count;
+	unsigned char		delay;
+	unsigned char		pending;
+	unsigned char		requested;
+	unsigned short		seq_count;
+	unsigned char		buf_len;
+	enum fc_disc_event	event;
+
+	void (*disc_callback)(struct fc_lport *,
+			      enum fc_disc_event);
+
+	struct list_head	 rports;
+	struct fc_lport		*lport;
+	struct mutex		disc_mutex;
+	struct fc_gpn_ft_resp	partial_buf;	/* partial name buffer */
+	struct delayed_work	disc_work;
+
+	struct list_head	list;
+};
+
+static void fc_disc_gpn_ft_req(struct fc_disc *);
+static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
+static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
+			      struct fc_rport_identifiers *);
+static void fc_disc_del_target(struct fc_disc *, struct fc_rport *);
+static void fc_disc_done(struct fc_disc *);
+static void fc_disc_timeout(struct work_struct *);
+static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
+static void fc_disc_restart(struct fc_disc *);
+
+/**
+ * fc_disc_lookup_rport - lookup a remote port by port_id
+ * @lport: Fibre Channel host port instance
+ * @port_id: remote port port_id to match
+ */
+struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
+				      u32 port_id)
+{
+	struct fc_disc *disc;
+	struct fc_rport *rport, *found = NULL;
+	struct fc_rport_libfc_priv *rdata;
+	int disc_found = 0;
+
+	mutex_lock(&disc_list_lock);
+	list_for_each_entry(disc, &disc_list, list) {
+		if (disc->lport == lport) {
+			list_for_each_entry(rdata, &disc->rports, peers) {
+				rport = PRIV_TO_RPORT(rdata);
+				if (rport->port_id == port_id) {
+					disc_found = 1;
+					found = rport;
+					get_device(&found->dev);
+					break;
+				}
+			}
+		}
+	}
+	mutex_unlock(&disc_list_lock);
+
+	if (!disc_found) {
+		FC_DEBUG_DISC("The rport (%6x) for lport (%6x) "
+			      "is not maintained by the discovery layer\n",
+			      port_id, fc_host_port_id(lport->host));
+		found = NULL;
+	}
+
+	return found;
+}
+
+/**
+ * fc_disc_alloc - Allocate a discovery work object
+ * @lport: The FC lport associated with the discovery job
+ */
+static inline struct fc_disc *fc_disc_alloc(struct fc_lport *lport)
+{
+	struct fc_disc *disc;
+
+	disc = kzalloc(sizeof(struct fc_disc), GFP_KERNEL);
+	INIT_LIST_HEAD(&disc->list);
+	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
+	mutex_init(&disc->disc_mutex);
+	INIT_LIST_HEAD(&disc->rports);
+
+	disc->lport = lport;
+	disc->delay = FC_DISC_DELAY;
+	disc->event = DISC_EV_NONE;
+
+	mutex_lock(&disc_list_lock);
+	list_add_tail(&disc->list, &disc_list);
+	mutex_unlock(&disc_list_lock);
+
+	return disc;
+}
+
+/**
+ * fc_disc_stop_rports - delete all the remote ports associated with the lport
+ * @disc: The discovery job to stop rports on
+ *
+ * Locking Note: This function expects that the lport mutex is locked before
+ * calling it.
+ */
+void fc_disc_stop_rports(struct fc_disc *disc)
+{
+	struct fc_lport *lport;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata, *next;
+
+	lport = disc->lport;
+
+	mutex_lock(&disc->disc_mutex);
+	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
+		rport = PRIV_TO_RPORT(rdata);
+		list_del(&rdata->peers);
+		lport->tt.rport_logoff(rport);
+	}
+
+	mutex_unlock(&disc->disc_mutex);
+}
+
+/**
+ * fc_disc_rport_event - Event handler for rport events
+ * @lport: The lport which is receiving the event
+ * @rport: The rport which the event has occured on
+ * @event: The event that occured
+ *
+ * Locking Note: The rport lock should not be held when calling
+ *		 this function.
+ */
+static void fc_disc_rport_event(struct fc_lport *lport,
+				struct fc_rport *rport,
+				enum fc_lport_event event)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_disc *disc;
+	int found = 0;
+
+	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
+		      rport->port_id);
+
+	if (event == RPORT_EV_CREATED) {
+		mutex_lock(&disc_list_lock);
+		list_for_each_entry(disc, &disc_list, list) {
+			if (disc->lport == lport) {
+				found = 1;
+				mutex_lock(&disc->disc_mutex);
+				list_add_tail(&rdata->peers, &disc->rports);
+				mutex_unlock(&disc->disc_mutex);
+			}
+		}
+		mutex_unlock(&disc_list_lock);
+	}
+
+	if (!found)
+		FC_DEBUG_DISC("The rport (%6x) is not maintained "
+			      "by the discovery layer\n", rport->port_id);
+}
+
+/**
+ * fc_disc_recv_rscn_req - Handle Registered State Change Notification (RSCN)
+ * @sp: Current sequence of the RSCN exchange
+ * @fp: RSCN Frame
+ * @lport: Fibre Channel host port instance
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
+				  struct fc_disc *disc)
+{
+	struct fc_lport *lport;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata;
+	struct fc_els_rscn *rp;
+	struct fc_els_rscn_page *pp;
+	struct fc_seq_els_data rjt_data;
+	unsigned int len;
+	int redisc = 0;
+	enum fc_els_rscn_ev_qual ev_qual;
+	enum fc_els_rscn_addr_fmt fmt;
+	LIST_HEAD(disc_ports);
+	struct fc_disc_port *dp, *next;
+
+	lport = disc->lport;
+
+	FC_DEBUG_DISC("Received an RSCN event on port (%6x)\n",
+		      fc_host_port_id(lport->host));
+
+	rp = fc_frame_payload_get(fp, sizeof(*rp));
+
+	if (!rp || rp->rscn_page_len != sizeof(*pp))
+		goto reject;
+
+	len = ntohs(rp->rscn_plen);
+	if (len < sizeof(*rp))
+		goto reject;
+	len -= sizeof(*rp);
+
+	for (pp = (void *)(rp + 1); len; len -= sizeof(*pp), pp++) {
+		ev_qual = pp->rscn_page_flags >> ELS_RSCN_EV_QUAL_BIT;
+		ev_qual &= ELS_RSCN_EV_QUAL_MASK;
+		fmt = pp->rscn_page_flags >> ELS_RSCN_ADDR_FMT_BIT;
+		fmt &= ELS_RSCN_ADDR_FMT_MASK;
+		/*
+		 * if we get an address format other than port
+		 * (area, domain, fabric), then do a full discovery
+		 */
+		switch (fmt) {
+		case ELS_ADDR_FMT_PORT:
+			FC_DEBUG_DISC("Port address format for port (%6x)\n",
+				      ntoh24(pp->rscn_fid));
+			dp = kzalloc(sizeof(*dp), GFP_KERNEL);
+			if (!dp) {
+				redisc = 1;
+				break;
+			}
+			dp->lp = lport;
+			dp->ids.port_id = ntoh24(pp->rscn_fid);
+			dp->ids.port_name = -1;
+			dp->ids.node_name = -1;
+			dp->ids.roles = FC_RPORT_ROLE_UNKNOWN;
+			list_add_tail(&dp->peers, &disc_ports);
+			break;
+		case ELS_ADDR_FMT_AREA:
+		case ELS_ADDR_FMT_DOM:
+		case ELS_ADDR_FMT_FAB:
+		default:
+			FC_DEBUG_DISC("Address format is (%d)\n", fmt);
+			redisc = 1;
+			break;
+		}
+	}
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	if (redisc) {
+		FC_DEBUG_DISC("RSCN received: rediscovering\n");
+		fc_disc_restart(disc);
+	} else {
+		FC_DEBUG_DISC("RSCN received: not rediscovering. "
+			      "redisc %d state %d in_prog %d\n",
+			      redisc, lport->state, disc->pending);
+		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
+			list_del(&dp->peers);
+			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
+			if (rport) {
+				rdata = RPORT_TO_PRIV(rport);
+				list_del(&rdata->peers);
+				lport->tt.rport_logoff(rport);
+			}
+			fc_disc_single(disc, dp);
+		}
+	}
+	fc_frame_free(fp);
+	return;
+reject:
+	rjt_data.fp = NULL;
+	rjt_data.reason = ELS_RJT_LOGIC;
+	rjt_data.explan = ELS_EXPL_NONE;
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_disc_recv_req - Handle incoming requests
+ * @sp: Current sequence of the request exchange
+ * @fp: The frame
+ * @lport: The FC local port
+ *
+ * Locking Note: This function is called from the EM and will lock
+ *		 the disc_mutex before calling the handler for the
+ *		 request.
+ */
+static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
+			     struct fc_lport *lport)
+{
+	u8 op;
+	struct fc_disc *disc;
+	int found = 0;
+
+	mutex_lock(&disc_list_lock);
+	list_for_each_entry(disc, &disc_list, list) {
+		if (disc->lport == lport) {
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&disc_list_lock);
+
+	if (!found) {
+		FC_DBG("Received a request for an lport not managed "
+		       "by the discovery engine\n");
+		return;
+	}
+
+	op = fc_frame_payload_op(fp);
+	switch (op) {
+	case ELS_RSCN:
+		mutex_lock(&disc->disc_mutex);
+		fc_disc_recv_rscn_req(sp, fp, disc);
+		mutex_unlock(&disc->disc_mutex);
+		break;
+	default:
+		FC_DBG("Received an unsupported request. opcode (%x)\n", op);
+		break;
+	}
+}
+
+/**
+ * fc_disc_restart - Restart discovery
+ * @lport: FC discovery context
+ *
+ * Locking Note: This function expects that the disc mutex
+ *		 is already locked.
+ */
+static void fc_disc_restart(struct fc_disc *disc)
+{
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata, *next;
+	struct fc_lport *lport = disc->lport;
+
+	FC_DEBUG_DISC("Restarting discovery for port (%6x)\n",
+		      fc_host_port_id(lport->host));
+
+	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
+		rport = PRIV_TO_RPORT(rdata);
+		FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
+		list_del(&rdata->peers);
+		lport->tt.rport_logoff(rport);
+	}
+
+	disc->requested = 1;
+	if (!disc->pending)
+		fc_disc_gpn_ft_req(disc);
+}
+
+/**
+ * fc_disc_start - Fibre Channel Target discovery
+ * @lport: FC local port
+ *
+ * Returns non-zero if discovery cannot be started.
+ */
+static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
+						enum fc_disc_event),
+			  struct fc_lport *lport)
+{
+	struct fc_rport *rport;
+	struct fc_rport_identifiers ids;
+	struct fc_disc *disc;
+	int found = 0;
+
+	mutex_lock(&disc_list_lock);
+	list_for_each_entry(disc, &disc_list, list) {
+		if (disc->lport == lport) {
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&disc_list_lock);
+
+	if (!found) {
+		FC_DEBUG_DISC("No existing discovery job, "
+			      "creating one for lport (%6x)\n",
+			      fc_host_port_id(lport->host));
+		disc = fc_disc_alloc(lport);
+	} else
+		FC_DEBUG_DISC("Found an existing discovery job "
+			      "for lport (%6x)\n",
+			      fc_host_port_id(lport->host));
+
+	/*
+	 * At this point we may have a new disc job or an existing
+	 * one. Either way, let's lock when we make changes to it
+	 * and send the GPN_FT request.
+	 */
+	mutex_lock(&disc->disc_mutex);
+
+	disc->disc_callback = disc_callback;
+
+	/*
+	 * If not ready, or already running discovery, just set request flag.
+	 */
+	disc->requested = 1;
+
+	if (disc->pending) {
+		mutex_unlock(&disc->disc_mutex);
+		return;
+	}
+
+	/*
+	 * Handle point-to-point mode as a simple discovery
+	 * of the remote port. Yucky, yucky, yuck, yuck!
+	 */
+	rport = disc->lport->ptp_rp;
+	if (rport) {
+		ids.port_id = rport->port_id;
+		ids.port_name = rport->port_name;
+		ids.node_name = rport->node_name;
+		ids.roles = FC_RPORT_ROLE_UNKNOWN;
+		get_device(&rport->dev);
+
+		if (!fc_disc_new_target(disc, rport, &ids)) {
+			disc->event = DISC_EV_SUCCESS;
+			fc_disc_done(disc);
+		}
+		put_device(&rport->dev);
+	} else {
+		fc_disc_gpn_ft_req(disc);	/* get ports by FC-4 type */
+	}
+
+	mutex_unlock(&disc->disc_mutex);
+}
+
+/**
+ * fc_disc_new_target - Handle new target found by discovery
+ * @lport: FC local port
+ * @rport: The previous FC remote port (NULL if new remote port)
+ * @ids: Identifiers for the new FC remote port
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static int fc_disc_new_target(struct fc_disc *disc,
+			      struct fc_rport *rport,
+			      struct fc_rport_identifiers *ids)
+{
+	struct fc_lport *lport = disc->lport;
+	struct fc_rport_libfc_priv *rp;
+	int error = 0;
+
+	if (rport && ids->port_name) {
+		if (rport->port_name == -1) {
+			/*
+			 * Set WWN and fall through to notify of create.
+			 */
+			fc_rport_set_name(rport, ids->port_name,
+					  rport->node_name);
+		} else if (rport->port_name != ids->port_name) {
+			/*
+			 * This is a new port with the same FCID as
+			 * a previously-discovered port.  Presumably the old
+			 * port logged out and a new port logged in and was
+			 * assigned the same FCID.  This should be rare.
+			 * Delete the old one and fall thru to re-create.
+			 */
+			fc_disc_del_target(disc, rport);
+			rport = NULL;
+		}
+	}
+	if (((ids->port_name != -1) || (ids->port_id != -1)) &&
+	    ids->port_id != fc_host_port_id(lport->host) &&
+	    ids->port_name != lport->wwpn) {
+		if (!rport) {
+			rport = lport->tt.rport_lookup(lport, ids->port_id);
+			if (!rport) {
+				struct fc_disc_port dp;
+				dp.lp = lport;
+				dp.ids.port_id = ids->port_id;
+				dp.ids.port_name = ids->port_name;
+				dp.ids.node_name = ids->node_name;
+				dp.ids.roles = ids->roles;
+				rport = fc_rport_rogue_create(&dp);
+			}
+			if (!rport)
+				error = ENOMEM;
+		}
+		if (rport) {
+			rp = rport->dd_data;
+			rp->event_callback = fc_disc_rport_event;
+			rp->rp_state = RPORT_ST_INIT;
+			lport->tt.rport_login(rport);
+		}
+	}
+	return error;
+}
+
+/**
+ * fc_disc_del_target - Delete a target
+ * @disc: FC discovery context
+ * @rport: The remote port to be removed
+ */
+static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
+{
+	struct fc_lport *lport = disc->lport;
+	struct fc_rport_libfc_priv *rdata = RPORT_TO_PRIV(rport);
+	list_del(&rdata->peers);
+	lport->tt.rport_logoff(rport);
+}
+
+/**
+ * fc_disc_done - Discovery has been completed
+ * @disc: FC discovery context
+ */
+static void fc_disc_done(struct fc_disc *disc)
+{
+	struct fc_lport *lport = disc->lport;
+
+	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
+		      fc_host_port_id(lport->host));
+
+	disc->disc_callback(lport, disc->event);
+	disc->event = DISC_EV_NONE;
+
+	if (disc->requested)
+		fc_disc_gpn_ft_req(disc);
+	else
+		disc->pending = 0;
+}
+
+/**
+ * fc_disc_error - Handle error on dNS request
+ * @disc: FC discovery context
+ * @fp: The frame pointer
+ */
+static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
+{
+	struct fc_lport *lport = disc->lport;
+	unsigned long delay = 0;
+	if (fc_disc_debug)
+		FC_DBG("Error %ld, retries %d/%d\n",
+		       PTR_ERR(fp), disc->retry_count,
+		       FC_DISC_RETRY_LIMIT);
+
+	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
+		/*
+		 * Memory allocation failure, or the exchange timed out,
+		 * retry after delay.
+		 */
+		if (disc->retry_count < FC_DISC_RETRY_LIMIT) {
+			/* go ahead and retry */
+			if (!fp)
+				delay = msecs_to_jiffies(500);
+			else {
+				delay = jiffies +
+					msecs_to_jiffies(lport->e_d_tov);
+
+				/* timeout faster first time */
+				if (!disc->retry_count)
+					delay /= 4;
+			}
+			disc->retry_count++;
+			schedule_delayed_work(&disc->disc_work,
+					      delay);
+		} else {
+			/* exceeded retries */
+			disc->event = DISC_EV_FAILED;
+			fc_disc_done(disc);
+		}
+	}
+}
+
+/**
+ * fc_disc_gpn_ft_req - Send Get Port Names by FC-4 type (GPN_FT) request
+ * @lport: FC discovery context
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static void fc_disc_gpn_ft_req(struct fc_disc *disc)
+{
+	struct fc_frame *fp;
+	struct fc_lport *lport = disc->lport;
+
+	WARN_ON(!fc_lport_test_ready(lport));
+
+	disc->pending = 1;
+	disc->requested = 0;
+
+	disc->buf_len = 0;
+	disc->seq_count = 0;
+	fp = fc_frame_alloc(lport,
+			    sizeof(struct fc_ct_hdr) +
+			    sizeof(struct fc_ns_gid_ft));
+	if (!fp)
+		goto err;
+
+	if (lport->tt.elsct_send(lport, NULL, fp,
+				 FC_NS_GPN_FT,
+				 fc_disc_gpn_ft_resp,
+				 disc, lport->e_d_tov))
+		return;
+err:
+	fc_disc_error(disc, fp);
+}
+
+/**
+ * fc_disc_gpn_ft_parse - Parse the list of IDs and names resulting from a request
+ * @lport: Fibre Channel host port instance
+ * @buf: GPN_FT response buffer
+ * @len: size of response buffer
+ */
+static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
+{
+	struct fc_lport *lport;
+	struct fc_gpn_ft_resp *np;
+	char *bp;
+	size_t plen;
+	size_t tlen;
+	int error = 0;
+	struct fc_disc_port dp;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata;
+
+	lport = disc->lport;
+
+	/*
+	 * Handle partial name record left over from previous call.
+	 */
+	bp = buf;
+	plen = len;
+	np = (struct fc_gpn_ft_resp *)bp;
+	tlen = disc->buf_len;
+	if (tlen) {
+		WARN_ON(tlen >= sizeof(*np));
+		plen = sizeof(*np) - tlen;
+		WARN_ON(plen <= 0);
+		WARN_ON(plen >= sizeof(*np));
+		if (plen > len)
+			plen = len;
+		np = &disc->partial_buf;
+		memcpy((char *)np + tlen, bp, plen);
+
+		/*
+		 * Set bp so that the loop below will advance it to the
+		 * first valid full name element.
+		 */
+		bp -= tlen;
+		len += tlen;
+		plen += tlen;
+		disc->buf_len = (unsigned char) plen;
+		if (plen == sizeof(*np))
+			disc->buf_len = 0;
+	}
+
+	/*
+	 * Handle full name records, including the one filled from above.
+	 * Normally, np == bp and plen == len, but from the partial case above,
+	 * bp, len describe the overall buffer, and np, plen describe the
+	 * partial buffer, which if would usually be full now.
+	 * After the first time through the loop, things return to "normal".
+	 */
+	while (plen >= sizeof(*np)) {
+		dp.lp = lport;
+		dp.ids.port_id = ntoh24(np->fp_fid);
+		dp.ids.port_name = ntohll(np->fp_wwpn);
+		dp.ids.node_name = -1;
+		dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
+		if ((dp.ids.port_id != fc_host_port_id(lport->host)) &&
+		    (dp.ids.port_name != lport->wwpn)) {
+			rport = fc_rport_rogue_create(&dp);
+			if (rport) {
+				rdata = rport->dd_data;
+				rdata->event_callback = fc_disc_rport_event;
+				rdata->local_port = lport;
+				lport->tt.rport_login(rport);
+			} else
+				FC_DBG("Failed to allocate memory for "
+				       "the newly discovered port (%6x)\n",
+				       dp.ids.port_id);
+		}
+
+		if (np->fp_flags & FC_NS_FID_LAST) {
+			disc->event = DISC_EV_SUCCESS;
+			fc_disc_done(disc);
+			len = 0;
+			break;
+		}
+		len -= sizeof(*np);
+		bp += sizeof(*np);
+		np = (struct fc_gpn_ft_resp *)bp;
+		plen = len;
+	}
+
+	/*
+	 * Save any partial record at the end of the buffer for next time.
+	 */
+	if (error == 0 && len > 0 && len < sizeof(*np)) {
+		if (np != &disc->partial_buf) {
+			FC_DEBUG_DISC("Partial buffer remains "
+				      "for discovery by (%6x)\n",
+				      fc_host_port_id(lport->host));
+			memcpy(&disc->partial_buf, np, len);
+		}
+		disc->buf_len = (unsigned char) len;
+	} else {
+		disc->buf_len = 0;
+	}
+	return error;
+}
+
+/*
+ * Handle retry of memory allocation for remote ports.
+ */
+static void fc_disc_timeout(struct work_struct *work)
+{
+	struct fc_disc *disc = container_of(work,
+					    struct fc_disc,
+					    disc_work.work);
+	mutex_lock(&disc->disc_mutex);
+	if (disc->requested && !disc->pending)
+		fc_disc_gpn_ft_req(disc);
+	mutex_unlock(&disc->disc_mutex);
+}
+
+/**
+ * fc_disc_gpn_ft_resp - Handle a response frame from Get Port Names (GPN_FT)
+ * @sp: Current sequence of GPN_FT exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel host port instance
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
+				void *disc_arg)
+{
+	struct fc_disc *disc = disc_arg;
+	struct fc_ct_hdr *cp;
+	struct fc_frame_header *fh;
+	unsigned int seq_cnt;
+	void *buf = NULL;
+	unsigned int len;
+	int error;
+
+	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
+		      fc_host_port_id(disc->lport->host));
+
+	if (IS_ERR(fp)) {
+		fc_disc_error(disc, fp);
+		return;
+	}
+
+	WARN_ON(!fc_frame_is_linear(fp));	/* buffer must be contiguous */
+	fh = fc_frame_header_get(fp);
+	len = fr_len(fp) - sizeof(*fh);
+	seq_cnt = ntohs(fh->fh_seq_cnt);
+	if (fr_sof(fp) == FC_SOF_I3 && seq_cnt == 0 &&
+	    disc->seq_count == 0) {
+		cp = fc_frame_payload_get(fp, sizeof(*cp));
+		if (!cp) {
+			FC_DBG("GPN_FT response too short, len %d\n",
+			       fr_len(fp));
+		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
+
+			/*
+			 * Accepted.  Parse response.
+			 */
+			buf = cp + 1;
+			len -= sizeof(*cp);
+		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
+			FC_DBG("GPN_FT rejected reason %x exp %x "
+			       "(check zoning)\n", cp->ct_reason,
+			       cp->ct_explan);
+			disc->event = DISC_EV_FAILED;
+			fc_disc_done(disc);
+		} else {
+			FC_DBG("GPN_FT unexpected response code %x\n",
+			       ntohs(cp->ct_cmd));
+		}
+	} else if (fr_sof(fp) == FC_SOF_N3 &&
+		   seq_cnt == disc->seq_count) {
+		buf = fh + 1;
+	} else {
+		FC_DBG("GPN_FT unexpected frame - out of sequence? "
+		       "seq_cnt %x expected %x sof %x eof %x\n",
+		       seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
+	}
+	if (buf) {
+		error = fc_disc_gpn_ft_parse(disc, buf, len);
+		if (error)
+			fc_disc_error(disc, fp);
+		else
+			disc->seq_count++;
+	}
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_disc_single - Discover the directory information for a single target
+ * @lport: FC local port
+ * @dp: The port to rediscover
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
+{
+	struct fc_lport *lport;
+	struct fc_rport *rport;
+	struct fc_rport *new_rport;
+	struct fc_rport_libfc_priv *rdata;
+
+	lport = disc->lport;
+
+	if (dp->ids.port_id == fc_host_port_id(lport->host))
+		goto out;
+
+	rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
+	if (rport) {
+		fc_disc_del_target(disc, rport);
+		put_device(&rport->dev); /* hold from lookup */
+	}
+
+	new_rport = fc_rport_rogue_create(dp);
+	if (new_rport) {
+		rdata = new_rport->dd_data;
+		rdata->event_callback = fc_disc_rport_event;
+		kfree(dp);
+		lport->tt.rport_login(new_rport);
+	}
+	return;
+out:
+	kfree(dp);
+}
+
+/**
+ * fc_disc_stop - Stop discovery for a given lport
+ * @lport: The lport that discovery should stop for
+ */
+void fc_disc_stop(struct fc_lport *lport)
+{
+	struct fc_disc *disc, *next;
+
+	mutex_lock(&disc_list_lock);
+	list_for_each_entry_safe(disc, next, &disc_list, list) {
+		if (disc->lport == lport) {
+			cancel_delayed_work_sync(&disc->disc_work);
+			fc_disc_stop_rports(disc);
+		}
+	}
+	mutex_unlock(&disc_list_lock);
+}
+
+/**
+ * fc_disc_stop_final - Stop discovery for a given lport
+ * @lport: The lport that discovery should stop for
+ *
+ * This function will block until discovery has been
+ * completely stopped and all rports have been deleted.
+ */
+void fc_disc_stop_final(struct fc_lport *lport)
+{
+	struct fc_disc *disc, *next;
+	fc_disc_stop(lport);
+	lport->tt.rport_flush_queue();
+
+	mutex_lock(&disc_list_lock);
+	list_for_each_entry_safe(disc, next, &disc_list, list) {
+		if (disc->lport == lport) {
+			list_del(&disc->list);
+			kfree(disc);
+		}
+	}
+	mutex_unlock(&disc_list_lock);
+}
+
+/**
+ * fc_disc_init - Initialize the discovery block
+ * @lport: FC local port
+ */
+int fc_disc_init(struct fc_lport *lport)
+{
+	INIT_LIST_HEAD(&disc_list);
+	mutex_init(&disc_list_lock);
+
+	if (!lport->tt.disc_start)
+		lport->tt.disc_start = fc_disc_start;
+
+	if (!lport->tt.disc_stop)
+		lport->tt.disc_stop = fc_disc_stop;
+
+	if (!lport->tt.disc_stop_final)
+		lport->tt.disc_stop_final = fc_disc_stop_final;
+
+	if (!lport->tt.disc_recv_req)
+		lport->tt.disc_recv_req = fc_disc_recv_req;
+
+	if (!lport->tt.rport_lookup)
+		lport->tt.rport_lookup = fc_disc_lookup_rport;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_disc_init);
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
new file mode 100644
index 0000000..dd47fe6
--- /dev/null
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * Provide interface to send ELS/CT FC frames
+ */
+
+#include <asm/unaligned.h>
+#include <scsi/fc/fc_gs.h>
+#include <scsi/fc/fc_ns.h>
+#include <scsi/fc/fc_els.h>
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+/*
+ * fc_elsct_send - sends ELS/CT frame
+ */
+static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
+				    struct fc_rport *rport,
+				    struct fc_frame *fp,
+				    unsigned int op,
+				    void (*resp)(struct fc_seq *,
+						 struct fc_frame *fp,
+						 void *arg),
+				    void *arg, u32 timer_msec)
+{
+	enum fc_rctl r_ctl;
+	u32 did;
+	enum fc_fh_type fh_type;
+	int rc;
+
+	/* ELS requests */
+	if ((op >= ELS_LS_RJT) && (op <= ELS_AUTH_ELS))
+		rc = fc_els_fill(lport, rport, fp, op, &r_ctl, &did, &fh_type);
+	else
+		/* CT requests */
+		rc = fc_ct_fill(lport, fp, op, &r_ctl, &did, &fh_type);
+
+	if (rc)
+		return NULL;
+
+	fc_fill_fc_hdr(fp, r_ctl, did, fc_host_port_id(lport->host), fh_type,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	return lport->tt.exch_seq_send(lport, fp, resp, NULL, arg, timer_msec);
+}
+
+int fc_elsct_init(struct fc_lport *lport)
+{
+	if (!lport->tt.elsct_send)
+		lport->tt.elsct_send = fc_elsct_send;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_elsct_init);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
new file mode 100644
index 0000000..12a1196
--- /dev/null
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -0,0 +1,1971 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright(c) 2008 Mike Christie
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * Fibre Channel exchange and sequence handling.
+ */
+
+#include <linux/timer.h>
+#include <linux/gfp.h>
+#include <linux/err.h>
+
+#include <scsi/fc/fc_fc2.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+#define	  FC_DEF_R_A_TOV      (10 * 1000) /* resource allocation timeout */
+
+/*
+ * fc_exch_debug can be set in debugger or at compile time to get more logs.
+ */
+static int fc_exch_debug;
+
+#define FC_DEBUG_EXCH(fmt...)			\
+	do {					\
+		if (fc_exch_debug)		\
+			FC_DBG(fmt);		\
+	} while (0)
+
+static struct kmem_cache *fc_em_cachep;	/* cache for exchanges */
+
+/*
+ * Structure and function definitions for managing Fibre Channel Exchanges
+ * and Sequences.
+ *
+ * The three primary structures used here are fc_exch_mgr, fc_exch, and fc_seq.
+ *
+ * fc_exch_mgr holds the exchange state for an N port
+ *
+ * fc_exch holds state for one exchange and links to its active sequence.
+ *
+ * fc_seq holds the state for an individual sequence.
+ */
+
+/*
+ * Exchange manager.
+ *
+ * This structure is the center for creating exchanges and sequences.
+ * It manages the allocation of exchange IDs.
+ */
+struct fc_exch_mgr {
+	enum fc_class	class;		/* default class for sequences */
+	spinlock_t	em_lock;	/* exchange manager lock */
+	u16		last_xid;	/* last allocated exchange ID */
+	u16		min_xid;	/* min exchange ID */
+	u16		max_xid;	/* max exchange ID */
+	u16		max_read;	/* max exchange ID for read */
+	u16		last_read;	/* last xid allocated for read */
+	u32	total_exches;		/* total allocated exchanges */
+	struct list_head	ex_list;	/* allocated exchanges list */
+	struct fc_lport	*lp;		/* fc device instance */
+	mempool_t	*ep_pool;	/* reserve ep's */
+
+	/*
+	 * currently exchange mgr stats are updated but not used.
+	 * either stats can be expose via sysfs or remove them
+	 * all together if not used XXX
+	 */
+	struct {
+		atomic_t no_free_exch;
+		atomic_t no_free_exch_xid;
+		atomic_t xid_not_found;
+		atomic_t xid_busy;
+		atomic_t seq_not_found;
+		atomic_t non_bls_resp;
+	} stats;
+	struct fc_exch **exches;	/* for exch pointers indexed by xid */
+};
+#define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
+
+static void fc_exch_rrq(struct fc_exch *);
+static void fc_seq_ls_acc(struct fc_seq *);
+static void fc_seq_ls_rjt(struct fc_seq *, enum fc_els_rjt_reason,
+			  enum fc_els_rjt_explan);
+static void fc_exch_els_rec(struct fc_seq *, struct fc_frame *);
+static void fc_exch_els_rrq(struct fc_seq *, struct fc_frame *);
+static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp);
+
+/*
+ * Internal implementation notes.
+ *
+ * The exchange manager is one by default in libfc but LLD may choose
+ * to have one per CPU. The sequence manager is one per exchange manager
+ * and currently never separated.
+ *
+ * Section 9.8 in FC-FS-2 specifies:  "The SEQ_ID is a one-byte field
+ * assigned by the Sequence Initiator that shall be unique for a specific
+ * D_ID and S_ID pair while the Sequence is open."   Note that it isn't
+ * qualified by exchange ID, which one might think it would be.
+ * In practice this limits the number of open sequences and exchanges to 256
+ * per session.	 For most targets we could treat this limit as per exchange.
+ *
+ * The exchange and its sequence are freed when the last sequence is received.
+ * It's possible for the remote port to leave an exchange open without
+ * sending any sequences.
+ *
+ * Notes on reference counts:
+ *
+ * Exchanges are reference counted and exchange gets freed when the reference
+ * count becomes zero.
+ *
+ * Timeouts:
+ * Sequences are timed out for E_D_TOV and R_A_TOV.
+ *
+ * Sequence event handling:
+ *
+ * The following events may occur on initiator sequences:
+ *
+ *	Send.
+ *	    For now, the whole thing is sent.
+ *	Receive ACK
+ *	    This applies only to class F.
+ *	    The sequence is marked complete.
+ *	ULP completion.
+ *	    The upper layer calls fc_exch_done() when done
+ *	    with exchange and sequence tuple.
+ *	RX-inferred completion.
+ *	    When we receive the next sequence on the same exchange, we can
+ *	    retire the previous sequence ID.  (XXX not implemented).
+ *	Timeout.
+ *	    R_A_TOV frees the sequence ID.  If we're waiting for ACK,
+ *	    E_D_TOV causes abort and calls upper layer response handler
+ *	    with FC_EX_TIMEOUT error.
+ *	Receive RJT
+ *	    XXX defer.
+ *	Send ABTS
+ *	    On timeout.
+ *
+ * The following events may occur on recipient sequences:
+ *
+ *	Receive
+ *	    Allocate sequence for first frame received.
+ *	    Hold during receive handler.
+ *	    Release when final frame received.
+ *	    Keep status of last N of these for the ELS RES command.  XXX TBD.
+ *	Receive ABTS
+ *	    Deallocate sequence
+ *	Send RJT
+ *	    Deallocate
+ *
+ * For now, we neglect conditions where only part of a sequence was
+ * received or transmitted, or where out-of-order receipt is detected.
+ */
+
+/*
+ * Locking notes:
+ *
+ * The EM code run in a per-CPU worker thread.
+ *
+ * To protect against concurrency between a worker thread code and timers,
+ * sequence allocation and deallocation must be locked.
+ *  - exchange refcnt can be done atomicly without locks.
+ *  - sequence allocation must be locked by exch lock.
+ */
+
+/*
+ * opcode names for debugging.
+ */
+static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
+
+#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
+
+static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
+					      unsigned int max_index)
+{
+	const char *name = NULL;
+
+	if (op < max_index)
+		name = table[op];
+	if (!name)
+		name = "unknown";
+	return name;
+}
+
+static const char *fc_exch_rctl_name(unsigned int op)
+{
+	return fc_exch_name_lookup(op, fc_exch_rctl_names,
+				   FC_TABLE_SIZE(fc_exch_rctl_names));
+}
+
+/*
+ * Hold an exchange - keep it from being freed.
+ */
+static void fc_exch_hold(struct fc_exch *ep)
+{
+	atomic_inc(&ep->ex_refcnt);
+}
+
+/*
+ * setup fc hdr by initializing few more FC header fields and sof/eof.
+ * Initialized fields by this func:
+ *	- fh_ox_id, fh_rx_id, fh_seq_id, fh_seq_cnt
+ *	- sof and eof
+ */
+static void fc_exch_setup_hdr(struct fc_exch *ep, struct fc_frame *fp,
+			      u32 f_ctl)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	u16 fill;
+
+	fr_sof(fp) = ep->class;
+	if (ep->seq.cnt)
+		fr_sof(fp) = fc_sof_normal(ep->class);
+
+	if (f_ctl & FC_FC_END_SEQ) {
+		fr_eof(fp) = FC_EOF_T;
+		if (fc_sof_needs_ack(ep->class))
+			fr_eof(fp) = FC_EOF_N;
+		/*
+		 * Form f_ctl.
+		 * The number of fill bytes to make the length a 4-byte
+		 * multiple is the low order 2-bits of the f_ctl.
+		 * The fill itself will have been cleared by the frame
+		 * allocation.
+		 * After this, the length will be even, as expected by
+		 * the transport.
+		 */
+		fill = fr_len(fp) & 3;
+		if (fill) {
+			fill = 4 - fill;
+			/* TODO, this may be a problem with fragmented skb */
+			skb_put(fp_skb(fp), fill);
+			hton24(fh->fh_f_ctl, f_ctl | fill);
+		}
+	} else {
+		WARN_ON(fr_len(fp) % 4 != 0);	/* no pad to non last frame */
+		fr_eof(fp) = FC_EOF_N;
+	}
+
+	/*
+	 * Initialize remainig fh fields
+	 * from fc_fill_fc_hdr
+	 */
+	fh->fh_ox_id = htons(ep->oxid);
+	fh->fh_rx_id = htons(ep->rxid);
+	fh->fh_seq_id = ep->seq.id;
+	fh->fh_seq_cnt = htons(ep->seq.cnt);
+}
+
+
+/*
+ * Release a reference to an exchange.
+ * If the refcnt goes to zero and the exchange is complete, it is freed.
+ */
+static void fc_exch_release(struct fc_exch *ep)
+{
+	struct fc_exch_mgr *mp;
+
+	if (atomic_dec_and_test(&ep->ex_refcnt)) {
+		mp = ep->em;
+		if (ep->destructor)
+			ep->destructor(&ep->seq, ep->arg);
+		if (ep->lp->tt.exch_put)
+			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
+		WARN_ON(!ep->esb_stat & ESB_ST_COMPLETE);
+		mempool_free(ep, mp->ep_pool);
+	}
+}
+
+static int fc_exch_done_locked(struct fc_exch *ep)
+{
+	int rc = 1;
+
+	/*
+	 * We must check for completion in case there are two threads
+	 * tyring to complete this. But the rrq code will reuse the
+	 * ep, and in that case we only clear the resp and set it as
+	 * complete, so it can be reused by the timer to send the rrq.
+	 */
+	ep->resp = NULL;
+	if (ep->state & FC_EX_DONE)
+		return rc;
+	ep->esb_stat |= ESB_ST_COMPLETE;
+
+	if (!(ep->esb_stat & ESB_ST_REC_QUAL)) {
+		ep->state |= FC_EX_DONE;
+		if (cancel_delayed_work(&ep->timeout_work))
+			atomic_dec(&ep->ex_refcnt); /* drop hold for timer */
+		rc = 0;
+	}
+	return rc;
+}
+
+static void fc_exch_mgr_delete_ep(struct fc_exch *ep)
+{
+	struct fc_exch_mgr *mp;
+
+	mp = ep->em;
+	spin_lock_bh(&mp->em_lock);
+	WARN_ON(mp->total_exches <= 0);
+	mp->total_exches--;
+	mp->exches[ep->xid - mp->min_xid] = NULL;
+	list_del(&ep->ex_list);
+	spin_unlock_bh(&mp->em_lock);
+	fc_exch_release(ep);	/* drop hold for exch in mp */
+}
+
+/*
+ * Internal version of fc_exch_timer_set - used with lock held.
+ */
+static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
+					    unsigned int timer_msec)
+{
+	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
+		return;
+
+	FC_DEBUG_EXCH("Exchange (%4x) timed out, notifying the upper layer\n",
+		      ep->xid);
+	if (schedule_delayed_work(&ep->timeout_work,
+				  msecs_to_jiffies(timer_msec)))
+		fc_exch_hold(ep);		/* hold for timer */
+}
+
+/*
+ * Set timer for an exchange.
+ * The time is a minimum delay in milliseconds until the timer fires.
+ * Used for upper level protocols to time out the exchange.
+ * The timer is cancelled when it fires or when the exchange completes.
+ * Returns non-zero if a timer couldn't be allocated.
+ */
+static void fc_exch_timer_set(struct fc_exch *ep, unsigned int timer_msec)
+{
+	spin_lock_bh(&ep->ex_lock);
+	fc_exch_timer_set_locked(ep, timer_msec);
+	spin_unlock_bh(&ep->ex_lock);
+}
+
+int fc_seq_exch_abort(const struct fc_seq *req_sp, unsigned int timer_msec)
+{
+	struct fc_seq *sp;
+	struct fc_exch *ep;
+	struct fc_frame *fp;
+	int error;
+
+	ep = fc_seq_exch(req_sp);
+
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->esb_stat & (ESB_ST_COMPLETE | ESB_ST_ABNORMAL) ||
+	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP)) {
+		spin_unlock_bh(&ep->ex_lock);
+		return -ENXIO;
+	}
+
+	/*
+	 * Send the abort on a new sequence if possible.
+	 */
+	sp = fc_seq_start_next_locked(&ep->seq);
+	if (!sp) {
+		spin_unlock_bh(&ep->ex_lock);
+		return -ENOMEM;
+	}
+
+	sp->f_ctl |= FC_FC_SEQ_INIT;
+	ep->esb_stat |= ESB_ST_SEQ_INIT | ESB_ST_ABNORMAL;
+	if (timer_msec)
+		fc_exch_timer_set_locked(ep, timer_msec);
+	spin_unlock_bh(&ep->ex_lock);
+
+	/*
+	 * If not logged into the fabric, don't send ABTS but leave
+	 * sequence active until next timeout.
+	 */
+	if (!ep->sid)
+		return 0;
+
+	/*
+	 * Send an abort for the sequence that timed out.
+	 */
+	fp = fc_frame_alloc(ep->lp, 0);
+	if (fp) {
+		fc_fill_fc_hdr(fp, FC_RCTL_BA_ABTS, ep->did, ep->sid,
+			       FC_TYPE_BLS, FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		error = fc_seq_send(ep->lp, sp, fp);
+	} else
+		error = -ENOBUFS;
+	return error;
+}
+EXPORT_SYMBOL(fc_seq_exch_abort);
+
+/*
+ * Exchange timeout - handle exchange timer expiration.
+ * The timer will have been cancelled before this is called.
+ */
+static void fc_exch_timeout(struct work_struct *work)
+{
+	struct fc_exch *ep = container_of(work, struct fc_exch,
+					  timeout_work.work);
+	struct fc_seq *sp = &ep->seq;
+	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
+	void *arg;
+	u32 e_stat;
+	int rc = 1;
+
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
+		goto unlock;
+
+	e_stat = ep->esb_stat;
+	if (e_stat & ESB_ST_COMPLETE) {
+		ep->esb_stat = e_stat & ~ESB_ST_REC_QUAL;
+		if (e_stat & ESB_ST_REC_QUAL)
+			fc_exch_rrq(ep);
+		spin_unlock_bh(&ep->ex_lock);
+		goto done;
+	} else {
+		resp = ep->resp;
+		arg = ep->arg;
+		ep->resp = NULL;
+		if (e_stat & ESB_ST_ABNORMAL)
+			rc = fc_exch_done_locked(ep);
+		spin_unlock_bh(&ep->ex_lock);
+		if (!rc)
+			fc_exch_mgr_delete_ep(ep);
+		if (resp)
+			resp(sp, ERR_PTR(-FC_EX_TIMEOUT), arg);
+		fc_seq_exch_abort(sp, 2 * ep->r_a_tov);
+		goto done;
+	}
+unlock:
+	spin_unlock_bh(&ep->ex_lock);
+done:
+	/*
+	 * This release matches the hold taken when the timer was set.
+	 */
+	fc_exch_release(ep);
+}
+
+/*
+ * Allocate a sequence.
+ *
+ * We don't support multiple originated sequences on the same exchange.
+ * By implication, any previously originated sequence on this exchange
+ * is complete, and we reallocate the same sequence.
+ */
+static struct fc_seq *fc_seq_alloc(struct fc_exch *ep, u8 seq_id)
+{
+	struct fc_seq *sp;
+
+	sp = &ep->seq;
+	sp->ssb_stat = 0;
+	sp->f_ctl = 0;
+	sp->cnt = 0;
+	sp->id = seq_id;
+	return sp;
+}
+
+/*
+ * fc_em_alloc_xid - returns an xid based on request type
+ * @lp : ptr to associated lport
+ * @fp : ptr to the assocated frame
+ *
+ * check the associated fc_fsp_pkt to get scsi command type and
+ * command direction to decide from which range this exch id
+ * will be allocated from.
+ *
+ * Returns : 0 or an valid xid
+ */
+static u16 fc_em_alloc_xid(struct fc_exch_mgr *mp, const struct fc_frame *fp)
+{
+	u16 xid, min, max;
+	u16 *plast;
+	struct fc_exch *ep = NULL;
+
+	if (mp->max_read) {
+		if (fc_frame_is_read(fp)) {
+			min = mp->min_xid;
+			max = mp->max_read;
+			plast = &mp->last_read;
+		} else {
+			min = mp->max_read + 1;
+			max = mp->max_xid;
+			plast = &mp->last_xid;
+		}
+	} else {
+		min = mp->min_xid;
+		max = mp->max_xid;
+		plast = &mp->last_xid;
+	}
+	xid = *plast;
+	do {
+		xid = (xid == max) ? min : xid + 1;
+		ep = mp->exches[xid - mp->min_xid];
+	} while ((ep != NULL) && (xid != *plast));
+
+	if (unlikely(ep))
+		xid = 0;
+	else
+		*plast = xid;
+
+	return xid;
+}
+
+/*
+ * fc_exch_alloc - allocate an exchange.
+ * @mp : ptr to the exchange manager
+ * @xid: input xid
+ *
+ * if xid is supplied zero then assign next free exchange ID
+ * from exchange manager, otherwise use supplied xid.
+ * Returns with exch lock held.
+ */
+struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
+			      struct fc_frame *fp, u16 xid)
+{
+	struct fc_exch *ep = NULL;
+
+	/* allocate memory for exchange */
+	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
+	if (!ep) {
+		atomic_inc(&mp->stats.no_free_exch);
+		goto out;
+	}
+	memset(ep, 0, sizeof(*ep));
+
+	spin_lock_bh(&mp->em_lock);
+	/* alloc xid if input xid 0 */
+	if (!xid) {
+		/* alloc a new xid */
+		xid = fc_em_alloc_xid(mp, fp);
+		if (!xid) {
+			printk(KERN_ERR "fc_em_alloc_xid() failed\n");
+			goto err;
+		}
+	}
+
+	fc_exch_hold(ep);	/* hold for exch in mp */
+	spin_lock_init(&ep->ex_lock);
+	/*
+	 * Hold exch lock for caller to prevent fc_exch_reset()
+	 * from releasing exch	while fc_exch_alloc() caller is
+	 * still working on exch.
+	 */
+	spin_lock_bh(&ep->ex_lock);
+
+	mp->exches[xid - mp->min_xid] = ep;
+	list_add_tail(&ep->ex_list, &mp->ex_list);
+	fc_seq_alloc(ep, ep->seq_id++);
+	mp->total_exches++;
+	spin_unlock_bh(&mp->em_lock);
+
+	/*
+	 *  update exchange
+	 */
+	ep->oxid = ep->xid = xid;
+	ep->em = mp;
+	ep->lp = mp->lp;
+	ep->f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
+	ep->rxid = FC_XID_UNKNOWN;
+	ep->class = mp->class;
+	INIT_DELAYED_WORK(&ep->timeout_work, fc_exch_timeout);
+out:
+	return ep;
+err:
+	spin_unlock_bh(&mp->em_lock);
+	atomic_inc(&mp->stats.no_free_exch_xid);
+	mempool_free(ep, mp->ep_pool);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_exch_alloc);
+
+/*
+ * Lookup and hold an exchange.
+ */
+static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
+{
+	struct fc_exch *ep = NULL;
+
+	if ((xid >= mp->min_xid) && (xid <= mp->max_xid)) {
+		spin_lock_bh(&mp->em_lock);
+		ep = mp->exches[xid - mp->min_xid];
+		if (ep) {
+			fc_exch_hold(ep);
+			WARN_ON(ep->xid != xid);
+		}
+		spin_unlock_bh(&mp->em_lock);
+	}
+	return ep;
+}
+
+void fc_exch_done(struct fc_seq *sp)
+{
+	struct fc_exch *ep = fc_seq_exch(sp);
+	int rc;
+
+	spin_lock_bh(&ep->ex_lock);
+	rc = fc_exch_done_locked(ep);
+	spin_unlock_bh(&ep->ex_lock);
+	if (!rc)
+		fc_exch_mgr_delete_ep(ep);
+}
+EXPORT_SYMBOL(fc_exch_done);
+
+/*
+ * Allocate a new exchange as responder.
+ * Sets the responder ID in the frame header.
+ */
+static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
+{
+	struct fc_exch *ep;
+	struct fc_frame_header *fh;
+	u16 rxid;
+
+	ep = mp->lp->tt.exch_get(mp->lp, fp);
+	if (ep) {
+		ep->class = fc_frame_class(fp);
+
+		/*
+		 * Set EX_CTX indicating we're responding on this exchange.
+		 */
+		ep->f_ctl |= FC_FC_EX_CTX;	/* we're responding */
+		ep->f_ctl &= ~FC_FC_FIRST_SEQ;	/* not new */
+		fh = fc_frame_header_get(fp);
+		ep->sid = ntoh24(fh->fh_d_id);
+		ep->did = ntoh24(fh->fh_s_id);
+		ep->oid = ep->did;
+
+		/*
+		 * Allocated exchange has placed the XID in the
+		 * originator field. Move it to the responder field,
+		 * and set the originator XID from the frame.
+		 */
+		ep->rxid = ep->xid;
+		ep->oxid = ntohs(fh->fh_ox_id);
+		ep->esb_stat |= ESB_ST_RESP | ESB_ST_SEQ_INIT;
+		if ((ntoh24(fh->fh_f_ctl) & FC_FC_SEQ_INIT) == 0)
+			ep->esb_stat &= ~ESB_ST_SEQ_INIT;
+
+		/*
+		 * Set the responder ID in the frame header.
+		 * The old one should've been 0xffff.
+		 * If it isn't, don't assign one.
+		 * Incoming basic link service frames may specify
+		 * a referenced RX_ID.
+		 */
+		if (fh->fh_type != FC_TYPE_BLS) {
+			rxid = ntohs(fh->fh_rx_id);
+			WARN_ON(rxid != FC_XID_UNKNOWN);
+			fh->fh_rx_id = htons(ep->rxid);
+		}
+		fc_exch_hold(ep);	/* hold for caller */
+		spin_unlock_bh(&ep->ex_lock);	/* lock from exch_get */
+	}
+	return ep;
+}
+
+/*
+ * Find a sequence for receive where the other end is originating the sequence.
+ * If fc_pf_rjt_reason is FC_RJT_NONE then this function will have a hold
+ * on the ep that should be released by the caller.
+ */
+static enum fc_pf_rjt_reason
+fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fc_exch *ep = NULL;
+	struct fc_seq *sp = NULL;
+	enum fc_pf_rjt_reason reject = FC_RJT_NONE;
+	u32 f_ctl;
+	u16 xid;
+
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	WARN_ON((f_ctl & FC_FC_SEQ_CTX) != 0);
+
+	/*
+	 * Lookup or create the exchange if we will be creating the sequence.
+	 */
+	if (f_ctl & FC_FC_EX_CTX) {
+		xid = ntohs(fh->fh_ox_id);	/* we originated exch */
+		ep = fc_exch_find(mp, xid);
+		if (!ep) {
+			atomic_inc(&mp->stats.xid_not_found);
+			reject = FC_RJT_OX_ID;
+			goto out;
+		}
+		if (ep->rxid == FC_XID_UNKNOWN)
+			ep->rxid = ntohs(fh->fh_rx_id);
+		else if (ep->rxid != ntohs(fh->fh_rx_id)) {
+			reject = FC_RJT_OX_ID;
+			goto rel;
+		}
+	} else {
+		xid = ntohs(fh->fh_rx_id);	/* we are the responder */
+
+		/*
+		 * Special case for MDS issuing an ELS TEST with a
+		 * bad rxid of 0.
+		 * XXX take this out once we do the proper reject.
+		 */
+		if (xid == 0 && fh->fh_r_ctl == FC_RCTL_ELS_REQ &&
+		    fc_frame_payload_op(fp) == ELS_TEST) {
+			fh->fh_rx_id = htons(FC_XID_UNKNOWN);
+			xid = FC_XID_UNKNOWN;
+		}
+
+		/*
+		 * new sequence - find the exchange
+		 */
+		ep = fc_exch_find(mp, xid);
+		if ((f_ctl & FC_FC_FIRST_SEQ) && fc_sof_is_init(fr_sof(fp))) {
+			if (ep) {
+				atomic_inc(&mp->stats.xid_busy);
+				reject = FC_RJT_RX_ID;
+				goto rel;
+			}
+			ep = fc_exch_resp(mp, fp);
+			if (!ep) {
+				reject = FC_RJT_EXCH_EST;	/* XXX */
+				goto out;
+			}
+			xid = ep->xid;	/* get our XID */
+		} else if (!ep) {
+			atomic_inc(&mp->stats.xid_not_found);
+			reject = FC_RJT_RX_ID;	/* XID not found */
+			goto out;
+		}
+	}
+
+	/*
+	 * At this point, we have the exchange held.
+	 * Find or create the sequence.
+	 */
+	if (fc_sof_is_init(fr_sof(fp))) {
+		sp = fc_seq_start_next(&ep->seq);
+		if (!sp) {
+			reject = FC_RJT_SEQ_XS;	/* exchange shortage */
+			goto rel;
+		}
+		sp->id = fh->fh_seq_id;
+		sp->ssb_stat |= SSB_ST_RESP;
+	} else {
+		sp = &ep->seq;
+		if (sp->id != fh->fh_seq_id) {
+			atomic_inc(&mp->stats.seq_not_found);
+			reject = FC_RJT_SEQ_ID;	/* sequence/exch should exist */
+			goto rel;
+		}
+	}
+	WARN_ON(ep != fc_seq_exch(sp));
+
+	if (f_ctl & FC_FC_SEQ_INIT)
+		ep->esb_stat |= ESB_ST_SEQ_INIT;
+
+	fr_seq(fp) = sp;
+out:
+	return reject;
+rel:
+	fc_exch_done(&ep->seq);
+	fc_exch_release(ep);	/* hold from fc_exch_find/fc_exch_resp */
+	return reject;
+}
+
+/*
+ * Find the sequence for a frame being received.
+ * We originated the sequence, so it should be found.
+ * We may or may not have originated the exchange.
+ * Does not hold the sequence for the caller.
+ */
+static struct fc_seq *fc_seq_lookup_orig(struct fc_exch_mgr *mp,
+					 struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fc_exch *ep;
+	struct fc_seq *sp = NULL;
+	u32 f_ctl;
+	u16 xid;
+
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	WARN_ON((f_ctl & FC_FC_SEQ_CTX) != FC_FC_SEQ_CTX);
+	xid = ntohs((f_ctl & FC_FC_EX_CTX) ? fh->fh_ox_id : fh->fh_rx_id);
+	ep = fc_exch_find(mp, xid);
+	if (!ep)
+		return NULL;
+	if (ep->seq.id == fh->fh_seq_id) {
+		/*
+		 * Save the RX_ID if we didn't previously know it.
+		 */
+		sp = &ep->seq;
+		if ((f_ctl & FC_FC_EX_CTX) != 0 &&
+		    ep->rxid == FC_XID_UNKNOWN) {
+			ep->rxid = ntohs(fh->fh_rx_id);
+		}
+	}
+	fc_exch_release(ep);
+	return sp;
+}
+
+/*
+ * Set addresses for an exchange.
+ * Note this must be done before the first sequence of the exchange is sent.
+ */
+static void fc_exch_set_addr(struct fc_exch *ep,
+			     u32 orig_id, u32 resp_id)
+{
+	ep->oid = orig_id;
+	if (ep->esb_stat & ESB_ST_RESP) {
+		ep->sid = resp_id;
+		ep->did = orig_id;
+	} else {
+		ep->sid = orig_id;
+		ep->did = resp_id;
+	}
+}
+
+static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp)
+{
+	struct fc_exch *ep = fc_seq_exch(sp);
+
+	sp = fc_seq_alloc(ep, ep->seq_id++);
+	FC_DEBUG_EXCH("exch %4x f_ctl %6x seq %2x f_ctl %6x\n",
+		      ep->xid, ep->f_ctl, sp->id, sp->f_ctl);
+	return sp;
+}
+/*
+ * Allocate a new sequence on the same exchange as the supplied sequence.
+ * This will never return NULL.
+ */
+struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
+{
+	struct fc_exch *ep = fc_seq_exch(sp);
+
+	spin_lock_bh(&ep->ex_lock);
+	WARN_ON((ep->esb_stat & ESB_ST_COMPLETE) != 0);
+	sp = fc_seq_start_next_locked(sp);
+	spin_unlock_bh(&ep->ex_lock);
+
+	return sp;
+}
+EXPORT_SYMBOL(fc_seq_start_next);
+
+int fc_seq_send(struct fc_lport *lp, struct fc_seq *sp, struct fc_frame *fp)
+{
+	struct fc_exch *ep;
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	int error;
+
+	ep = fc_seq_exch(sp);
+	WARN_ON((ep->esb_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
+
+	sp->f_ctl = ntoh24(fh->fh_f_ctl);
+	fc_exch_setup_hdr(ep, fp, sp->f_ctl);
+
+	/*
+	 * update sequence count if this frame is carrying
+	 * multiple FC frames when sequence offload is enabled
+	 * by LLD.
+	 */
+	if (fr_max_payload(fp))
+		sp->cnt += DIV_ROUND_UP((fr_len(fp) - sizeof(*fh)),
+					fr_max_payload(fp));
+	else
+		sp->cnt++;
+
+	/*
+	 * Send the frame.
+	 */
+	error = lp->tt.frame_send(lp, fp);
+
+	/*
+	 * Update the exchange and sequence flags,
+	 * assuming all frames for the sequence have been sent.
+	 * We can only be called to send once for each sequence.
+	 */
+	spin_lock_bh(&ep->ex_lock);
+	ep->f_ctl &= ~FC_FC_FIRST_SEQ;	/* not first seq */
+	sp->f_ctl &= ~FC_FC_FIRST_SEQ;	/* not first seq */
+	if (sp->f_ctl & (FC_FC_END_SEQ | FC_FC_SEQ_INIT))
+		ep->esb_stat &= ~ESB_ST_SEQ_INIT;
+	spin_unlock_bh(&ep->ex_lock);
+	return error;
+}
+EXPORT_SYMBOL(fc_seq_send);
+
+void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
+			 struct fc_seq_els_data *els_data)
+{
+	switch (els_cmd) {
+	case ELS_LS_RJT:
+		fc_seq_ls_rjt(sp, els_data->reason, els_data->explan);
+		break;
+	case ELS_LS_ACC:
+		fc_seq_ls_acc(sp);
+		break;
+	case ELS_RRQ:
+		fc_exch_els_rrq(sp, els_data->fp);
+		break;
+	case ELS_REC:
+		fc_exch_els_rec(sp, els_data->fp);
+		break;
+	default:
+		FC_DBG("Invalid ELS CMD:%x\n", els_cmd);
+	}
+}
+EXPORT_SYMBOL(fc_seq_els_rsp_send);
+
+/*
+ * Send a sequence, which is also the last sequence in the exchange.
+ */
+static void fc_seq_send_last(struct fc_seq *sp, struct fc_frame *fp,
+			     enum fc_rctl rctl, enum fc_fh_type fh_type)
+{
+	u32 f_ctl;
+	struct fc_exch *ep = fc_seq_exch(sp);
+
+	f_ctl = FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+	fc_fill_fc_hdr(fp, rctl, ep->did, ep->sid, fh_type, f_ctl, 0);
+	fc_seq_send(fc_seq_exch(sp)->lp, sp, fp);
+}
+
+/*
+ * Send ACK_1 (or equiv.) indicating we received something.
+ * The frame we're acking is supplied.
+ */
+static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
+{
+	struct fc_frame *fp;
+	struct fc_frame_header *rx_fh;
+	struct fc_frame_header *fh;
+	struct fc_exch *ep = fc_seq_exch(sp);
+	struct fc_lport *lp = ep->lp;
+	unsigned int f_ctl;
+
+	/*
+	 * Don't send ACKs for class 3.
+	 */
+	if (fc_sof_needs_ack(fr_sof(rx_fp))) {
+		fp = fc_frame_alloc(lp, 0);
+		BUG_ON(!fp);
+		if (!fp)
+			return;
+
+		fh = fc_frame_header_get(fp);
+		fh->fh_r_ctl = FC_RCTL_ACK_1;
+		fh->fh_type = FC_TYPE_BLS;
+
+		/*
+		 * Form f_ctl by inverting EX_CTX and SEQ_CTX (bits 23, 22).
+		 * Echo FIRST_SEQ, LAST_SEQ, END_SEQ, END_CONN, SEQ_INIT.
+		 * Bits 9-8 are meaningful (retransmitted or unidirectional).
+		 * Last ACK uses bits 7-6 (continue sequence),
+		 * bits 5-4 are meaningful (what kind of ACK to use).
+		 */
+		rx_fh = fc_frame_header_get(rx_fp);
+		f_ctl = ntoh24(rx_fh->fh_f_ctl);
+		f_ctl &= FC_FC_EX_CTX | FC_FC_SEQ_CTX |
+			FC_FC_FIRST_SEQ | FC_FC_LAST_SEQ |
+			FC_FC_END_SEQ | FC_FC_END_CONN | FC_FC_SEQ_INIT |
+			FC_FC_RETX_SEQ | FC_FC_UNI_TX;
+		f_ctl ^= FC_FC_EX_CTX | FC_FC_SEQ_CTX;
+		hton24(fh->fh_f_ctl, f_ctl);
+
+		fc_exch_setup_hdr(ep, fp, f_ctl);
+		fh->fh_seq_id = rx_fh->fh_seq_id;
+		fh->fh_seq_cnt = rx_fh->fh_seq_cnt;
+		fh->fh_parm_offset = htonl(1);	/* ack single frame */
+
+		fr_sof(fp) = fr_sof(rx_fp);
+		if (f_ctl & FC_FC_END_SEQ)
+			fr_eof(fp) = FC_EOF_T;
+		else
+			fr_eof(fp) = FC_EOF_N;
+
+		(void) lp->tt.frame_send(lp, fp);
+	}
+}
+
+/*
+ * Send BLS Reject.
+ * This is for rejecting BA_ABTS only.
+ */
+static void
+fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
+		    enum fc_ba_rjt_explan explan)
+{
+	struct fc_frame *fp;
+	struct fc_frame_header *rx_fh;
+	struct fc_frame_header *fh;
+	struct fc_ba_rjt *rp;
+	struct fc_lport *lp;
+	unsigned int f_ctl;
+
+	lp = fr_dev(rx_fp);
+	fp = fc_frame_alloc(lp, sizeof(*rp));
+	if (!fp)
+		return;
+	fh = fc_frame_header_get(fp);
+	rx_fh = fc_frame_header_get(rx_fp);
+
+	memset(fh, 0, sizeof(*fh) + sizeof(*rp));
+
+	rp = fc_frame_payload_get(fp, sizeof(*rp));
+	rp->br_reason = reason;
+	rp->br_explan = explan;
+
+	/*
+	 * seq_id, cs_ctl, df_ctl and param/offset are zero.
+	 */
+	memcpy(fh->fh_s_id, rx_fh->fh_d_id, 3);
+	memcpy(fh->fh_d_id, rx_fh->fh_s_id, 3);
+	fh->fh_ox_id = rx_fh->fh_rx_id;
+	fh->fh_rx_id = rx_fh->fh_ox_id;
+	fh->fh_seq_cnt = rx_fh->fh_seq_cnt;
+	fh->fh_r_ctl = FC_RCTL_BA_RJT;
+	fh->fh_type = FC_TYPE_BLS;
+
+	/*
+	 * Form f_ctl by inverting EX_CTX and SEQ_CTX (bits 23, 22).
+	 * Echo FIRST_SEQ, LAST_SEQ, END_SEQ, END_CONN, SEQ_INIT.
+	 * Bits 9-8 are meaningful (retransmitted or unidirectional).
+	 * Last ACK uses bits 7-6 (continue sequence),
+	 * bits 5-4 are meaningful (what kind of ACK to use).
+	 * Always set LAST_SEQ, END_SEQ.
+	 */
+	f_ctl = ntoh24(rx_fh->fh_f_ctl);
+	f_ctl &= FC_FC_EX_CTX | FC_FC_SEQ_CTX |
+		FC_FC_END_CONN | FC_FC_SEQ_INIT |
+		FC_FC_RETX_SEQ | FC_FC_UNI_TX;
+	f_ctl ^= FC_FC_EX_CTX | FC_FC_SEQ_CTX;
+	f_ctl |= FC_FC_LAST_SEQ | FC_FC_END_SEQ;
+	f_ctl &= ~FC_FC_FIRST_SEQ;
+	hton24(fh->fh_f_ctl, f_ctl);
+
+	fr_sof(fp) = fc_sof_class(fr_sof(rx_fp));
+	fr_eof(fp) = FC_EOF_T;
+	if (fc_sof_needs_ack(fr_sof(fp)))
+		fr_eof(fp) = FC_EOF_N;
+
+	(void) lp->tt.frame_send(lp, fp);
+}
+
+/*
+ * Handle an incoming ABTS.  This would be for target mode usually,
+ * but could be due to lost FCP transfer ready, confirm or RRQ.
+ * We always handle this as an exchange abort, ignoring the parameter.
+ */
+static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
+{
+	struct fc_frame *fp;
+	struct fc_ba_acc *ap;
+	struct fc_frame_header *fh;
+	struct fc_seq *sp;
+
+	if (!ep)
+		goto reject;
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->esb_stat & ESB_ST_COMPLETE) {
+		spin_unlock_bh(&ep->ex_lock);
+		goto reject;
+	}
+	if (!(ep->esb_stat & ESB_ST_REC_QUAL))
+		fc_exch_hold(ep);		/* hold for REC_QUAL */
+	ep->esb_stat |= ESB_ST_ABNORMAL | ESB_ST_REC_QUAL;
+	fc_exch_timer_set_locked(ep, ep->r_a_tov);
+
+	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
+	if (!fp) {
+		spin_unlock_bh(&ep->ex_lock);
+		goto free;
+	}
+	fh = fc_frame_header_get(fp);
+	ap = fc_frame_payload_get(fp, sizeof(*ap));
+	memset(ap, 0, sizeof(*ap));
+	sp = &ep->seq;
+	ap->ba_high_seq_cnt = htons(0xffff);
+	if (sp->ssb_stat & SSB_ST_RESP) {
+		ap->ba_seq_id = sp->id;
+		ap->ba_seq_id_val = FC_BA_SEQ_ID_VAL;
+		ap->ba_high_seq_cnt = fh->fh_seq_cnt;
+		ap->ba_low_seq_cnt = htons(sp->cnt);
+	}
+	sp = fc_seq_start_next(sp);
+	spin_unlock_bh(&ep->ex_lock);
+	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
+	fc_frame_free(rx_fp);
+	return;
+
+reject:
+	fc_exch_send_ba_rjt(rx_fp, FC_BA_RJT_UNABLE, FC_BA_RJT_INV_XID);
+free:
+	fc_frame_free(rx_fp);
+}
+
+/*
+ * Handle receive where the other end is originating the sequence.
+ */
+static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
+			     struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fc_seq *sp = NULL;
+	struct fc_exch *ep = NULL;
+	enum fc_sof sof;
+	enum fc_eof eof;
+	u32 f_ctl;
+	enum fc_pf_rjt_reason reject;
+
+	fr_seq(fp) = NULL;
+	reject = fc_seq_lookup_recip(mp, fp);
+	if (reject == FC_RJT_NONE) {
+		sp = fr_seq(fp);	/* sequence will be held */
+		ep = fc_seq_exch(sp);
+		sof = fr_sof(fp);
+		eof = fr_eof(fp);
+		f_ctl = ntoh24(fh->fh_f_ctl);
+		fc_seq_send_ack(sp, fp);
+
+		/*
+		 * Call the receive function.
+		 *
+		 * The receive function may allocate a new sequence
+		 * over the old one, so we shouldn't change the
+		 * sequence after this.
+		 *
+		 * The frame will be freed by the receive function.
+		 * If new exch resp handler is valid then call that
+		 * first.
+		 */
+		if (ep->resp)
+			ep->resp(sp, fp, ep->arg);
+		else
+			lp->tt.lport_recv(lp, sp, fp);
+		fc_exch_release(ep);	/* release from lookup */
+	} else {
+		FC_DEBUG_EXCH("exch/seq lookup failed: reject %x\n", reject);
+		fc_frame_free(fp);
+	}
+}
+
+/*
+ * Handle receive where the other end is originating the sequence in
+ * response to our exchange.
+ */
+static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fc_seq *sp;
+	struct fc_exch *ep;
+	enum fc_sof sof;
+	u32 f_ctl;
+	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
+	void *ex_resp_arg;
+	int rc;
+
+	ep = fc_exch_find(mp, ntohs(fh->fh_ox_id));
+	if (!ep) {
+		atomic_inc(&mp->stats.xid_not_found);
+		goto out;
+	}
+	if (ep->rxid == FC_XID_UNKNOWN)
+		ep->rxid = ntohs(fh->fh_rx_id);
+	if (ep->sid != 0 && ep->sid != ntoh24(fh->fh_d_id)) {
+		atomic_inc(&mp->stats.xid_not_found);
+		goto rel;
+	}
+	if (ep->did != ntoh24(fh->fh_s_id) &&
+	    ep->did != FC_FID_FLOGI) {
+		atomic_inc(&mp->stats.xid_not_found);
+		goto rel;
+	}
+	sof = fr_sof(fp);
+	if (fc_sof_is_init(sof)) {
+		sp = fc_seq_start_next(&ep->seq);
+		sp->id = fh->fh_seq_id;
+		sp->ssb_stat |= SSB_ST_RESP;
+	} else {
+		sp = &ep->seq;
+		if (sp->id != fh->fh_seq_id) {
+			atomic_inc(&mp->stats.seq_not_found);
+			goto rel;
+		}
+	}
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	fr_seq(fp) = sp;
+	if (f_ctl & FC_FC_SEQ_INIT)
+		ep->esb_stat |= ESB_ST_SEQ_INIT;
+
+	if (fc_sof_needs_ack(sof))
+		fc_seq_send_ack(sp, fp);
+	resp = ep->resp;
+	ex_resp_arg = ep->arg;
+
+	if (fh->fh_type != FC_TYPE_FCP && fr_eof(fp) == FC_EOF_T &&
+	    (f_ctl & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
+	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
+		spin_lock_bh(&ep->ex_lock);
+		rc = fc_exch_done_locked(ep);
+		WARN_ON(fc_seq_exch(sp) != ep);
+		spin_unlock_bh(&ep->ex_lock);
+		if (!rc)
+			fc_exch_mgr_delete_ep(ep);
+	}
+
+	/*
+	 * Call the receive function.
+	 * The sequence is held (has a refcnt) for us,
+	 * but not for the receive function.
+	 *
+	 * The receive function may allocate a new sequence
+	 * over the old one, so we shouldn't change the
+	 * sequence after this.
+	 *
+	 * The frame will be freed by the receive function.
+	 * If new exch resp handler is valid then call that
+	 * first.
+	 */
+	if (resp)
+		resp(sp, fp, ex_resp_arg);
+	else
+		fc_frame_free(fp);
+	fc_exch_release(ep);
+	return;
+rel:
+	fc_exch_release(ep);
+out:
+	fc_frame_free(fp);
+}
+
+/*
+ * Handle receive for a sequence where other end is responding to our sequence.
+ */
+static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
+{
+	struct fc_seq *sp;
+
+	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
+	if (!sp) {
+		atomic_inc(&mp->stats.xid_not_found);
+		FC_DEBUG_EXCH("seq lookup failed\n");
+	} else {
+		atomic_inc(&mp->stats.non_bls_resp);
+		FC_DEBUG_EXCH("non-BLS response to sequence");
+	}
+	fc_frame_free(fp);
+}
+
+/*
+ * Handle the response to an ABTS for exchange or sequence.
+ * This can be BA_ACC or BA_RJT.
+ */
+static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
+{
+	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
+	void *ex_resp_arg;
+	struct fc_frame_header *fh;
+	struct fc_ba_acc *ap;
+	struct fc_seq *sp;
+	u16 low;
+	u16 high;
+	int rc = 1, has_rec = 0;
+
+	fh = fc_frame_header_get(fp);
+	FC_DEBUG_EXCH("exch: BLS rctl %x - %s\n",
+		      fh->fh_r_ctl, fc_exch_rctl_name(fh->fh_r_ctl));
+
+	if (cancel_delayed_work_sync(&ep->timeout_work))
+		fc_exch_release(ep);	/* release from pending timer hold */
+
+	spin_lock_bh(&ep->ex_lock);
+	switch (fh->fh_r_ctl) {
+	case FC_RCTL_BA_ACC:
+		ap = fc_frame_payload_get(fp, sizeof(*ap));
+		if (!ap)
+			break;
+
+		/*
+		 * Decide whether to establish a Recovery Qualifier.
+		 * We do this if there is a non-empty SEQ_CNT range and
+		 * SEQ_ID is the same as the one we aborted.
+		 */
+		low = ntohs(ap->ba_low_seq_cnt);
+		high = ntohs(ap->ba_high_seq_cnt);
+		if ((ep->esb_stat & ESB_ST_REC_QUAL) == 0 &&
+		    (ap->ba_seq_id_val != FC_BA_SEQ_ID_VAL ||
+		     ap->ba_seq_id == ep->seq_id) && low != high) {
+			ep->esb_stat |= ESB_ST_REC_QUAL;
+			fc_exch_hold(ep);  /* hold for recovery qualifier */
+			has_rec = 1;
+		}
+		break;
+	case FC_RCTL_BA_RJT:
+		break;
+	default:
+		break;
+	}
+
+	resp = ep->resp;
+	ex_resp_arg = ep->arg;
+
+	/* do we need to do some other checks here. Can we reuse more of
+	 * fc_exch_recv_seq_resp
+	 */
+	sp = &ep->seq;
+	/*
+	 * do we want to check END_SEQ as well as LAST_SEQ here?
+	 */
+	if (ep->fh_type != FC_TYPE_FCP &&
+	    ntoh24(fh->fh_f_ctl) & FC_FC_LAST_SEQ)
+		rc = fc_exch_done_locked(ep);
+	spin_unlock_bh(&ep->ex_lock);
+	if (!rc)
+		fc_exch_mgr_delete_ep(ep);
+
+	if (resp)
+		resp(sp, fp, ex_resp_arg);
+	else
+		fc_frame_free(fp);
+
+	if (has_rec)
+		fc_exch_timer_set(ep, ep->r_a_tov);
+
+}
+
+/*
+ * Receive BLS sequence.
+ * This is always a sequence initiated by the remote side.
+ * We may be either the originator or recipient of the exchange.
+ */
+static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
+{
+	struct fc_frame_header *fh;
+	struct fc_exch *ep;
+	u32 f_ctl;
+
+	fh = fc_frame_header_get(fp);
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	fr_seq(fp) = NULL;
+
+	ep = fc_exch_find(mp, (f_ctl & FC_FC_EX_CTX) ?
+			  ntohs(fh->fh_ox_id) : ntohs(fh->fh_rx_id));
+	if (ep && (f_ctl & FC_FC_SEQ_INIT)) {
+		spin_lock_bh(&ep->ex_lock);
+		ep->esb_stat |= ESB_ST_SEQ_INIT;
+		spin_unlock_bh(&ep->ex_lock);
+	}
+	if (f_ctl & FC_FC_SEQ_CTX) {
+		/*
+		 * A response to a sequence we initiated.
+		 * This should only be ACKs for class 2 or F.
+		 */
+		switch (fh->fh_r_ctl) {
+		case FC_RCTL_ACK_1:
+		case FC_RCTL_ACK_0:
+			break;
+		default:
+			FC_DEBUG_EXCH("BLS rctl %x - %s received",
+				      fh->fh_r_ctl,
+				      fc_exch_rctl_name(fh->fh_r_ctl));
+			break;
+		}
+		fc_frame_free(fp);
+	} else {
+		switch (fh->fh_r_ctl) {
+		case FC_RCTL_BA_RJT:
+		case FC_RCTL_BA_ACC:
+			if (ep)
+				fc_exch_abts_resp(ep, fp);
+			else
+				fc_frame_free(fp);
+			break;
+		case FC_RCTL_BA_ABTS:
+			fc_exch_recv_abts(ep, fp);
+			break;
+		default:			/* ignore junk */
+			fc_frame_free(fp);
+			break;
+		}
+	}
+	if (ep)
+		fc_exch_release(ep);	/* release hold taken by fc_exch_find */
+}
+
+/*
+ * Accept sequence with LS_ACC.
+ * If this fails due to allocation or transmit congestion, assume the
+ * originator will repeat the sequence.
+ */
+static void fc_seq_ls_acc(struct fc_seq *req_sp)
+{
+	struct fc_seq *sp;
+	struct fc_els_ls_acc *acc;
+	struct fc_frame *fp;
+
+	sp = fc_seq_start_next(req_sp);
+	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*acc));
+	if (fp) {
+		acc = fc_frame_payload_get(fp, sizeof(*acc));
+		memset(acc, 0, sizeof(*acc));
+		acc->la_cmd = ELS_LS_ACC;
+		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
+	}
+}
+
+/*
+ * Reject sequence with ELS LS_RJT.
+ * If this fails due to allocation or transmit congestion, assume the
+ * originator will repeat the sequence.
+ */
+static void fc_seq_ls_rjt(struct fc_seq *req_sp, enum fc_els_rjt_reason reason,
+			  enum fc_els_rjt_explan explan)
+{
+	struct fc_seq *sp;
+	struct fc_els_ls_rjt *rjt;
+	struct fc_frame *fp;
+
+	sp = fc_seq_start_next(req_sp);
+	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*rjt));
+	if (fp) {
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		memset(rjt, 0, sizeof(*rjt));
+		rjt->er_cmd = ELS_LS_RJT;
+		rjt->er_reason = reason;
+		rjt->er_explan = explan;
+		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
+	}
+}
+
+static void fc_exch_reset(struct fc_exch *ep)
+{
+	struct fc_seq *sp;
+	void (*resp)(struct fc_seq *, struct fc_frame *, void *);
+	void *arg;
+	int rc = 1;
+
+	spin_lock_bh(&ep->ex_lock);
+	ep->state |= FC_EX_RST_CLEANUP;
+	/*
+	 * we really want to call del_timer_sync, but cannot due
+	 * to the lport calling with the lport lock held (some resp
+	 * functions can also grab the lport lock which could cause
+	 * a deadlock).
+	 */
+	if (cancel_delayed_work(&ep->timeout_work))
+		atomic_dec(&ep->ex_refcnt);	/* drop hold for timer */
+	resp = ep->resp;
+	ep->resp = NULL;
+	if (ep->esb_stat & ESB_ST_REC_QUAL)
+		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec_qual */
+	ep->esb_stat &= ~ESB_ST_REC_QUAL;
+	arg = ep->arg;
+	sp = &ep->seq;
+	rc = fc_exch_done_locked(ep);
+	spin_unlock_bh(&ep->ex_lock);
+	if (!rc)
+		fc_exch_mgr_delete_ep(ep);
+
+	if (resp)
+		resp(sp, ERR_PTR(-FC_EX_CLOSED), arg);
+}
+
+/*
+ * Reset an exchange manager, releasing all sequences and exchanges.
+ * If sid is non-zero, reset only exchanges we source from that FID.
+ * If did is non-zero, reset only exchanges destined to that FID.
+ */
+void fc_exch_mgr_reset(struct fc_exch_mgr *mp, u32 sid, u32 did)
+{
+	struct fc_exch *ep;
+	struct fc_exch *next;
+
+	spin_lock_bh(&mp->em_lock);
+restart:
+	list_for_each_entry_safe(ep, next, &mp->ex_list, ex_list) {
+		if ((sid == 0 || sid == ep->sid) &&
+		    (did == 0 || did == ep->did)) {
+			fc_exch_hold(ep);
+			spin_unlock_bh(&mp->em_lock);
+
+			fc_exch_reset(ep);
+
+			fc_exch_release(ep);
+			spin_lock_bh(&mp->em_lock);
+
+			/*
+			 * must restart loop incase while lock was down
+			 * multiple eps were released.
+			 */
+			goto restart;
+		}
+	}
+	spin_unlock_bh(&mp->em_lock);
+}
+EXPORT_SYMBOL(fc_exch_mgr_reset);
+
+/*
+ * Handle incoming ELS REC - Read Exchange Concise.
+ * Note that the requesting port may be different than the S_ID in the request.
+ */
+static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
+{
+	struct fc_frame *fp;
+	struct fc_exch *ep;
+	struct fc_exch_mgr *em;
+	struct fc_els_rec *rp;
+	struct fc_els_rec_acc *acc;
+	enum fc_els_rjt_reason reason = ELS_RJT_LOGIC;
+	enum fc_els_rjt_explan explan;
+	u32 sid;
+	u16 rxid;
+	u16 oxid;
+
+	rp = fc_frame_payload_get(rfp, sizeof(*rp));
+	explan = ELS_EXPL_INV_LEN;
+	if (!rp)
+		goto reject;
+	sid = ntoh24(rp->rec_s_id);
+	rxid = ntohs(rp->rec_rx_id);
+	oxid = ntohs(rp->rec_ox_id);
+
+	/*
+	 * Currently it's hard to find the local S_ID from the exchange
+	 * manager.  This will eventually be fixed, but for now it's easier
+	 * to lookup the subject exchange twice, once as if we were
+	 * the initiator, and then again if we weren't.
+	 */
+	em = fc_seq_exch(sp)->em;
+	ep = fc_exch_find(em, oxid);
+	explan = ELS_EXPL_OXID_RXID;
+	if (ep && ep->oid == sid) {
+		if (ep->rxid != FC_XID_UNKNOWN &&
+		    rxid != FC_XID_UNKNOWN &&
+		    ep->rxid != rxid)
+			goto rel;
+	} else {
+		if (ep)
+			fc_exch_release(ep);
+		ep = NULL;
+		if (rxid != FC_XID_UNKNOWN)
+			ep = fc_exch_find(em, rxid);
+		if (!ep)
+			goto reject;
+	}
+
+	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*acc));
+	if (!fp) {
+		fc_exch_done(sp);
+		goto out;
+	}
+	sp = fc_seq_start_next(sp);
+	acc = fc_frame_payload_get(fp, sizeof(*acc));
+	memset(acc, 0, sizeof(*acc));
+	acc->reca_cmd = ELS_LS_ACC;
+	acc->reca_ox_id = rp->rec_ox_id;
+	memcpy(acc->reca_ofid, rp->rec_s_id, 3);
+	acc->reca_rx_id = htons(ep->rxid);
+	if (ep->sid == ep->oid)
+		hton24(acc->reca_rfid, ep->did);
+	else
+		hton24(acc->reca_rfid, ep->sid);
+	acc->reca_fc4value = htonl(ep->seq.rec_data);
+	acc->reca_e_stat = htonl(ep->esb_stat & (ESB_ST_RESP |
+						 ESB_ST_SEQ_INIT |
+						 ESB_ST_COMPLETE));
+	sp = fc_seq_start_next(sp);
+	fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
+out:
+	fc_exch_release(ep);
+	fc_frame_free(rfp);
+	return;
+
+rel:
+	fc_exch_release(ep);
+reject:
+	fc_seq_ls_rjt(sp, reason, explan);
+	fc_frame_free(rfp);
+}
+
+/*
+ * Handle response from RRQ.
+ * Not much to do here, really.
+ * Should report errors.
+ *
+ * TODO: fix error handler.
+ */
+static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
+{
+	struct fc_exch *aborted_ep = arg;
+	unsigned int op;
+
+	if (IS_ERR(fp)) {
+		int err = PTR_ERR(fp);
+
+		if (err == -FC_EX_CLOSED)
+			goto cleanup;
+		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
+		return;
+	}
+
+	op = fc_frame_payload_op(fp);
+	fc_frame_free(fp);
+
+	switch (op) {
+	case ELS_LS_RJT:
+		FC_DBG("LS_RJT for RRQ");
+		/* fall through */
+	case ELS_LS_ACC:
+		goto cleanup;
+	default:
+		FC_DBG("unexpected response op %x for RRQ", op);
+		return;
+	}
+
+cleanup:
+	fc_exch_done(&aborted_ep->seq);
+	/* drop hold for rec qual */
+	fc_exch_release(aborted_ep);
+}
+
+/*
+ * Send ELS RRQ - Reinstate Recovery Qualifier.
+ * This tells the remote port to stop blocking the use of
+ * the exchange and the seq_cnt range.
+ */
+static void fc_exch_rrq(struct fc_exch *ep)
+{
+	struct fc_lport *lp;
+	struct fc_els_rrq *rrq;
+	struct fc_frame *fp;
+	struct fc_seq *rrq_sp;
+	u32 did;
+
+	lp = ep->lp;
+
+	fp = fc_frame_alloc(lp, sizeof(*rrq));
+	if (!fp)
+		return;
+	rrq = fc_frame_payload_get(fp, sizeof(*rrq));
+	memset(rrq, 0, sizeof(*rrq));
+	rrq->rrq_cmd = ELS_RRQ;
+	hton24(rrq->rrq_s_id, ep->sid);
+	rrq->rrq_ox_id = htons(ep->oxid);
+	rrq->rrq_rx_id = htons(ep->rxid);
+
+	did = ep->did;
+	if (ep->esb_stat & ESB_ST_RESP)
+		did = ep->sid;
+
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, did,
+		       fc_host_port_id(lp->host), FC_TYPE_ELS,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	rrq_sp = fc_exch_seq_send(lp, fp, fc_exch_rrq_resp, NULL, ep,
+				  lp->e_d_tov);
+	if (!rrq_sp) {
+		ep->esb_stat |= ESB_ST_REC_QUAL;
+		fc_exch_timer_set_locked(ep, ep->r_a_tov);
+		return;
+	}
+}
+
+
+/*
+ * Handle incoming ELS RRQ - Reset Recovery Qualifier.
+ */
+static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
+{
+	struct fc_exch *ep;		/* request or subject exchange */
+	struct fc_els_rrq *rp;
+	u32 sid;
+	u16 xid;
+	enum fc_els_rjt_explan explan;
+
+	rp = fc_frame_payload_get(fp, sizeof(*rp));
+	explan = ELS_EXPL_INV_LEN;
+	if (!rp)
+		goto reject;
+
+	/*
+	 * lookup subject exchange.
+	 */
+	ep = fc_seq_exch(sp);
+	sid = ntoh24(rp->rrq_s_id);		/* subject source */
+	xid = ep->did == sid ? ntohs(rp->rrq_ox_id) : ntohs(rp->rrq_rx_id);
+	ep = fc_exch_find(ep->em, xid);
+
+	explan = ELS_EXPL_OXID_RXID;
+	if (!ep)
+		goto reject;
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->oxid != ntohs(rp->rrq_ox_id))
+		goto unlock_reject;
+	if (ep->rxid != ntohs(rp->rrq_rx_id) &&
+	    ep->rxid != FC_XID_UNKNOWN)
+		goto unlock_reject;
+	explan = ELS_EXPL_SID;
+	if (ep->sid != sid)
+		goto unlock_reject;
+
+	/*
+	 * Clear Recovery Qualifier state, and cancel timer if complete.
+	 */
+	if (ep->esb_stat & ESB_ST_REC_QUAL) {
+		ep->esb_stat &= ~ESB_ST_REC_QUAL;
+		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec qual */
+	}
+	if (ep->esb_stat & ESB_ST_COMPLETE) {
+		if (cancel_delayed_work(&ep->timeout_work))
+			atomic_dec(&ep->ex_refcnt);	/* drop timer hold */
+	}
+
+	spin_unlock_bh(&ep->ex_lock);
+
+	/*
+	 * Send LS_ACC.
+	 */
+	fc_seq_ls_acc(sp);
+	fc_frame_free(fp);
+	return;
+
+unlock_reject:
+	spin_unlock_bh(&ep->ex_lock);
+	fc_exch_release(ep);	/* drop hold from fc_exch_find */
+reject:
+	fc_seq_ls_rjt(sp, ELS_RJT_LOGIC, explan);
+	fc_frame_free(fp);
+}
+
+struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
+				      enum fc_class class,
+				      u16 min_xid, u16 max_xid)
+{
+	struct fc_exch_mgr *mp;
+	size_t len;
+
+	if (max_xid <= min_xid || min_xid == 0 || max_xid == FC_XID_UNKNOWN) {
+		FC_DBG("Invalid min_xid 0x:%x and max_xid 0x:%x\n",
+		       min_xid, max_xid);
+		return NULL;
+	}
+
+	/*
+	 * Memory need for EM
+	 */
+#define xid_ok(i, m1, m2) (((i) >= (m1)) && ((i) <= (m2)))
+	len = (max_xid - min_xid + 1) * (sizeof(struct fc_exch *));
+	len += sizeof(struct fc_exch_mgr);
+
+	mp = kzalloc(len, GFP_ATOMIC);
+	if (!mp)
+		return NULL;
+
+	mp->class = class;
+	mp->total_exches = 0;
+	mp->exches = (struct fc_exch **)(mp + 1);
+	mp->lp = lp;
+	/* adjust em exch xid range for offload */
+	mp->min_xid = min_xid;
+	mp->max_xid = max_xid;
+	mp->last_xid = min_xid - 1;
+	mp->max_read = 0;
+	mp->last_read = 0;
+	if (lp->lro_enabled && xid_ok(lp->lro_xid, min_xid, max_xid)) {
+		mp->max_read = lp->lro_xid;
+		mp->last_read = min_xid - 1;
+		mp->last_xid = mp->max_read;
+	} else {
+		/* disable lro if no xid control over read */
+		lp->lro_enabled = 0;
+	}
+
+	INIT_LIST_HEAD(&mp->ex_list);
+	spin_lock_init(&mp->em_lock);
+
+	mp->ep_pool = mempool_create_slab_pool(2, fc_em_cachep);
+	if (!mp->ep_pool)
+		goto free_mp;
+
+	return mp;
+
+free_mp:
+	kfree(mp);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_exch_mgr_alloc);
+
+void fc_exch_mgr_free(struct fc_exch_mgr *mp)
+{
+	WARN_ON(!mp);
+	/*
+	 * The total exch count must be zero
+	 * before freeing exchange manager.
+	 */
+	WARN_ON(mp->total_exches != 0);
+	mempool_destroy(mp->ep_pool);
+	kfree(mp);
+}
+EXPORT_SYMBOL(fc_exch_mgr_free);
+
+struct fc_exch *fc_exch_get(struct fc_lport *lp, struct fc_frame *fp)
+{
+	if (!lp || !lp->emp)
+		return NULL;
+
+	return fc_exch_alloc(lp->emp, fp, 0);
+}
+EXPORT_SYMBOL(fc_exch_get);
+
+struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
+				struct fc_frame *fp,
+				void (*resp)(struct fc_seq *,
+					     struct fc_frame *fp,
+					     void *arg),
+				void (*destructor)(struct fc_seq *, void *),
+				void *arg, u32 timer_msec)
+{
+	struct fc_exch *ep;
+	struct fc_seq *sp = NULL;
+	struct fc_frame_header *fh;
+	int rc = 1;
+
+	ep = lp->tt.exch_get(lp, fp);
+	if (!ep) {
+		fc_frame_free(fp);
+		return NULL;
+	}
+	ep->esb_stat |= ESB_ST_SEQ_INIT;
+	fh = fc_frame_header_get(fp);
+	fc_exch_set_addr(ep, ntoh24(fh->fh_s_id), ntoh24(fh->fh_d_id));
+	ep->resp = resp;
+	ep->destructor = destructor;
+	ep->arg = arg;
+	ep->r_a_tov = FC_DEF_R_A_TOV;
+	ep->lp = lp;
+	sp = &ep->seq;
+	WARN_ON((sp->f_ctl & FC_FC_END_SEQ) != 0);
+
+	ep->fh_type = fh->fh_type; /* save for possbile timeout handling */
+	ep->f_ctl = ntoh24(fh->fh_f_ctl);
+	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
+	sp->cnt++;
+
+	if (unlikely(lp->tt.frame_send(lp, fp)))
+		goto err;
+
+	if (timer_msec)
+		fc_exch_timer_set_locked(ep, timer_msec);
+	ep->f_ctl &= ~FC_FC_FIRST_SEQ;	/* not first seq */
+	sp->f_ctl = ep->f_ctl;	/* save for possible abort */
+
+	if (ep->f_ctl & FC_FC_SEQ_INIT)
+		ep->esb_stat &= ~ESB_ST_SEQ_INIT;
+	spin_unlock_bh(&ep->ex_lock);
+	return sp;
+err:
+	rc = fc_exch_done_locked(ep);
+	spin_unlock_bh(&ep->ex_lock);
+	if (!rc)
+		fc_exch_mgr_delete_ep(ep);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_exch_seq_send);
+
+/*
+ * Receive a frame
+ */
+void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
+		  struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	u32 f_ctl;
+
+	/* lport lock ? */
+	if (!lp || !mp || (lp->state == LPORT_ST_NONE)) {
+		FC_DBG("fc_lport or EM is not allocated and configured");
+		fc_frame_free(fp);
+		return;
+	}
+
+	/*
+	 * If frame is marked invalid, just drop it.
+	 */
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	switch (fr_eof(fp)) {
+	case FC_EOF_T:
+		if (f_ctl & FC_FC_END_SEQ)
+			skb_trim(fp_skb(fp), fr_len(fp) - FC_FC_FILL(f_ctl));
+		/* fall through */
+	case FC_EOF_N:
+		if (fh->fh_type == FC_TYPE_BLS)
+			fc_exch_recv_bls(mp, fp);
+		else if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) ==
+			 FC_FC_EX_CTX)
+			fc_exch_recv_seq_resp(mp, fp);
+		else if (f_ctl & FC_FC_SEQ_CTX)
+			fc_exch_recv_resp(mp, fp);
+		else
+			fc_exch_recv_req(lp, mp, fp);
+		break;
+	default:
+		FC_DBG("dropping invalid frame (eof %x)", fr_eof(fp));
+		fc_frame_free(fp);
+		break;
+	}
+}
+EXPORT_SYMBOL(fc_exch_recv);
+
+int fc_exch_init(struct fc_lport *lp)
+{
+	if (!lp->tt.exch_get) {
+		/*
+		 *  exch_put() should be NULL if
+		 *  exch_get() is NULL
+		 */
+		WARN_ON(lp->tt.exch_put);
+		lp->tt.exch_get = fc_exch_get;
+	}
+
+	if (!lp->tt.seq_start_next)
+		lp->tt.seq_start_next = fc_seq_start_next;
+
+	if (!lp->tt.exch_seq_send)
+		lp->tt.exch_seq_send = fc_exch_seq_send;
+
+	if (!lp->tt.seq_send)
+		lp->tt.seq_send = fc_seq_send;
+
+	if (!lp->tt.seq_els_rsp_send)
+		lp->tt.seq_els_rsp_send = fc_seq_els_rsp_send;
+
+	if (!lp->tt.exch_done)
+		lp->tt.exch_done = fc_exch_done;
+
+	if (!lp->tt.exch_mgr_reset)
+		lp->tt.exch_mgr_reset = fc_exch_mgr_reset;
+
+	if (!lp->tt.seq_exch_abort)
+		lp->tt.seq_exch_abort = fc_seq_exch_abort;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_exch_init);
+
+int fc_setup_exch_mgr(void)
+{
+	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
+					 0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fc_em_cachep)
+		return -ENOMEM;
+	return 0;
+}
+
+void fc_destroy_exch_mgr(void)
+{
+	kmem_cache_destroy(fc_em_cachep);
+}
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
new file mode 100644
index 0000000..9462118
--- /dev/null
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -0,0 +1,2130 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright(c) 2008 Mike Christie
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/scatterlist.h>
+#include <linux/err.h>
+#include <linux/crc32.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <scsi/fc/fc_fc2.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+MODULE_AUTHOR("Open-FCoE.org");
+MODULE_DESCRIPTION("libfc");
+MODULE_LICENSE("GPL");
+
+static int fc_fcp_debug;
+
+#define FC_DEBUG_FCP(fmt...)			\
+	do {					\
+		if (fc_fcp_debug)		\
+			FC_DBG(fmt);		\
+	} while (0)
+
+static struct kmem_cache *scsi_pkt_cachep;
+
+/* SRB state definitions */
+#define FC_SRB_FREE		0		/* cmd is free */
+#define FC_SRB_CMD_SENT		(1 << 0)	/* cmd has been sent */
+#define FC_SRB_RCV_STATUS	(1 << 1)	/* response has arrived */
+#define FC_SRB_ABORT_PENDING	(1 << 2)	/* cmd abort sent to device */
+#define FC_SRB_ABORTED		(1 << 3)	/* abort acknowleged */
+#define FC_SRB_DISCONTIG	(1 << 4)	/* non-sequential data recvd */
+#define FC_SRB_COMPL		(1 << 5)	/* fc_io_compl has been run */
+#define FC_SRB_FCP_PROCESSING_TMO (1 << 6)	/* timer function processing */
+#define FC_SRB_NOMEM		(1 << 7)	/* dropped to out of mem */
+
+#define FC_SRB_READ		(1 << 1)
+#define FC_SRB_WRITE		(1 << 0)
+
+/*
+ * The SCp.ptr should be tested and set under the host lock. NULL indicates
+ * that the command has been retruned to the scsi layer.
+ */
+#define CMD_SP(Cmnd)		    ((struct fc_fcp_pkt *)(Cmnd)->SCp.ptr)
+#define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
+#define CMD_COMPL_STATUS(Cmnd)	    ((Cmnd)->SCp.this_residual)
+#define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
+#define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
+
+struct fc_fcp_internal {
+	mempool_t	*scsi_pkt_pool;
+	struct list_head scsi_pkt_queue;
+	u8		throttled;
+};
+
+#define fc_get_scsi_internal(x)	((struct fc_fcp_internal *)(x)->scsi_priv)
+
+/*
+ * function prototypes
+ * FC scsi I/O related functions
+ */
+static void fc_fcp_recv_data(struct fc_fcp_pkt *, struct fc_frame *);
+static void fc_fcp_recv(struct fc_seq *, struct fc_frame *, void *);
+static void fc_fcp_resp(struct fc_fcp_pkt *, struct fc_frame *);
+static void fc_fcp_complete_locked(struct fc_fcp_pkt *);
+static void fc_tm_done(struct fc_seq *, struct fc_frame *, void *);
+static void fc_fcp_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp);
+static void fc_timeout_error(struct fc_fcp_pkt *);
+static void fc_fcp_timeout(unsigned long data);
+static void fc_fcp_rec(struct fc_fcp_pkt *);
+static void fc_fcp_rec_error(struct fc_fcp_pkt *, struct fc_frame *);
+static void fc_fcp_rec_resp(struct fc_seq *, struct fc_frame *, void *);
+static void fc_io_compl(struct fc_fcp_pkt *);
+
+static void fc_fcp_srr(struct fc_fcp_pkt *, enum fc_rctl, u32);
+static void fc_fcp_srr_resp(struct fc_seq *, struct fc_frame *, void *);
+static void fc_fcp_srr_error(struct fc_fcp_pkt *, struct fc_frame *);
+
+/*
+ * command status codes
+ */
+#define FC_COMPLETE		0
+#define FC_CMD_ABORTED		1
+#define FC_CMD_RESET		2
+#define FC_CMD_PLOGO		3
+#define FC_SNS_RCV		4
+#define FC_TRANS_ERR		5
+#define FC_DATA_OVRRUN		6
+#define FC_DATA_UNDRUN		7
+#define FC_ERROR		8
+#define FC_HRD_ERROR		9
+#define FC_CMD_TIME_OUT		10
+
+/*
+ * Error recovery timeout values.
+ */
+#define FC_SCSI_ER_TIMEOUT	(10 * HZ)
+#define FC_SCSI_TM_TOV		(10 * HZ)
+#define FC_SCSI_REC_TOV		(2 * HZ)
+#define FC_HOST_RESET_TIMEOUT	(30 * HZ)
+
+#define FC_MAX_ERROR_CNT	5
+#define FC_MAX_RECOV_RETRY	3
+
+#define FC_FCP_DFLT_QUEUE_DEPTH 32
+
+/**
+ * fc_fcp_pkt_alloc - allocation routine for scsi_pkt packet
+ * @lp:		fc lport struct
+ * @gfp:	gfp flags for allocation
+ *
+ * This is used by upper layer scsi driver.
+ * Return Value : scsi_pkt structure or null on allocation failure.
+ * Context	: call from process context. no locking required.
+ */
+static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lp, gfp_t gfp)
+{
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
+	struct fc_fcp_pkt *fsp;
+
+	fsp = mempool_alloc(si->scsi_pkt_pool, gfp);
+	if (fsp) {
+		memset(fsp, 0, sizeof(*fsp));
+		fsp->lp = lp;
+		atomic_set(&fsp->ref_cnt, 1);
+		init_timer(&fsp->timer);
+		INIT_LIST_HEAD(&fsp->list);
+		spin_lock_init(&fsp->scsi_pkt_lock);
+	}
+	return fsp;
+}
+
+/**
+ * fc_fcp_pkt_release - release hold on scsi_pkt packet
+ * @fsp:	fcp packet struct
+ *
+ * This is used by upper layer scsi driver.
+ * Context	: call from process  and interrupt context.
+ *		  no locking required
+ */
+static void fc_fcp_pkt_release(struct fc_fcp_pkt *fsp)
+{
+	if (atomic_dec_and_test(&fsp->ref_cnt)) {
+		struct fc_fcp_internal *si = fc_get_scsi_internal(fsp->lp);
+
+		mempool_free(fsp, si->scsi_pkt_pool);
+	}
+}
+
+static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
+{
+	atomic_inc(&fsp->ref_cnt);
+}
+
+/**
+ * fc_fcp_pkt_destory - release hold on scsi_pkt packet
+ *
+ * @seq:		exchange sequence
+ * @fsp:	fcp packet struct
+ *
+ * Release hold on scsi_pkt packet set to keep scsi_pkt
+ * till EM layer exch resource is not freed.
+ * Context	: called from from EM layer.
+ *		  no locking required
+ */
+static void fc_fcp_pkt_destroy(struct fc_seq *seq, void *fsp)
+{
+	fc_fcp_pkt_release(fsp);
+}
+
+/**
+ * fc_fcp_lock_pkt - lock a packet and get a ref to it.
+ * @fsp:	fcp packet
+ *
+ * We should only return error if we return a command to scsi-ml before
+ * getting a response. This can happen in cases where we send a abort, but
+ * do not wait for the response and the abort and command can be passing
+ * each other on the wire/network-layer.
+ *
+ * Note: this function locks the packet and gets a reference to allow
+ * callers to call the completion function while the lock is held and
+ * not have to worry about the packets refcount.
+ *
+ * TODO: Maybe we should just have callers grab/release the lock and
+ * have a function that they call to verify the fsp and grab a ref if
+ * needed.
+ */
+static inline int fc_fcp_lock_pkt(struct fc_fcp_pkt *fsp)
+{
+	spin_lock_bh(&fsp->scsi_pkt_lock);
+	if (fsp->state & FC_SRB_COMPL) {
+		spin_unlock_bh(&fsp->scsi_pkt_lock);
+		return -EPERM;
+	}
+
+	fc_fcp_pkt_hold(fsp);
+	return 0;
+}
+
+static inline void fc_fcp_unlock_pkt(struct fc_fcp_pkt *fsp)
+{
+	spin_unlock_bh(&fsp->scsi_pkt_lock);
+	fc_fcp_pkt_release(fsp);
+}
+
+static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, unsigned long delay)
+{
+	if (!(fsp->state & FC_SRB_COMPL))
+		mod_timer(&fsp->timer, jiffies + delay);
+}
+
+static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
+{
+	if (!fsp->seq_ptr)
+		return -EINVAL;
+
+	fsp->state |= FC_SRB_ABORT_PENDING;
+	return fsp->lp->tt.seq_exch_abort(fsp->seq_ptr, 0);
+}
+
+/*
+ * Retry command.
+ * An abort isn't needed.
+ */
+static void fc_fcp_retry_cmd(struct fc_fcp_pkt *fsp)
+{
+	if (fsp->seq_ptr) {
+		fsp->lp->tt.exch_done(fsp->seq_ptr);
+		fsp->seq_ptr = NULL;
+	}
+
+	fsp->state &= ~FC_SRB_ABORT_PENDING;
+	fsp->io_status = SUGGEST_RETRY << 24;
+	fsp->status_code = FC_ERROR;
+	fc_fcp_complete_locked(fsp);
+}
+
+/*
+ * Receive SCSI data from target.
+ * Called after receiving solicited data.
+ */
+static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	struct scsi_cmnd *sc = fsp->cmd;
+	struct fc_lport *lp = fsp->lp;
+	struct fcoe_dev_stats *stats;
+	struct fc_frame_header *fh;
+	size_t start_offset;
+	size_t offset;
+	u32 crc;
+	u32 copy_len = 0;
+	size_t len;
+	void *buf;
+	struct scatterlist *sg;
+	size_t remaining;
+
+	fh = fc_frame_header_get(fp);
+	offset = ntohl(fh->fh_parm_offset);
+	start_offset = offset;
+	len = fr_len(fp) - sizeof(*fh);
+	buf = fc_frame_payload_get(fp, 0);
+
+	if (offset + len > fsp->data_len) {
+		/*
+		 * this should never happen
+		 */
+		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
+		    fc_frame_crc_check(fp))
+			goto crc_err;
+		FC_DEBUG_FCP("data received past end. len %zx offset %zx "
+			     "data_len %x\n", len, offset, fsp->data_len);
+		fc_fcp_retry_cmd(fsp);
+		return;
+	}
+	if (offset != fsp->xfer_len)
+		fsp->state |= FC_SRB_DISCONTIG;
+
+	crc = 0;
+	if (fr_flags(fp) & FCPHF_CRC_UNCHECKED)
+		crc = crc32(~0, (u8 *) fh, sizeof(*fh));
+
+	sg = scsi_sglist(sc);
+	remaining = len;
+
+	while (remaining > 0 && sg) {
+		size_t off;
+		void *page_addr;
+		size_t sg_bytes;
+
+		if (offset >= sg->length) {
+			offset -= sg->length;
+			sg = sg_next(sg);
+			continue;
+		}
+		sg_bytes = min(remaining, sg->length - offset);
+
+		/*
+		 * The scatterlist item may be bigger than PAGE_SIZE,
+		 * but we are limited to mapping PAGE_SIZE at a time.
+		 */
+		off = offset + sg->offset;
+		sg_bytes = min(sg_bytes, (size_t)
+			       (PAGE_SIZE - (off & ~PAGE_MASK)));
+		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT),
+					KM_SOFTIRQ0);
+		if (!page_addr)
+			break;		/* XXX panic? */
+
+		if (fr_flags(fp) & FCPHF_CRC_UNCHECKED)
+			crc = crc32(crc, buf, sg_bytes);
+		memcpy((char *)page_addr + (off & ~PAGE_MASK), buf,
+		       sg_bytes);
+
+		kunmap_atomic(page_addr, KM_SOFTIRQ0);
+		buf += sg_bytes;
+		offset += sg_bytes;
+		remaining -= sg_bytes;
+		copy_len += sg_bytes;
+	}
+
+	if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
+		buf = fc_frame_payload_get(fp, 0);
+		if (len % 4) {
+			crc = crc32(crc, buf + len, 4 - (len % 4));
+			len += 4 - (len % 4);
+		}
+
+		if (~crc != le32_to_cpu(*(__le32 *)(buf + len))) {
+crc_err:
+			stats = lp->dev_stats[smp_processor_id()];
+			stats->ErrorFrames++;
+			if (stats->InvalidCRCCount++ < 5)
+				FC_DBG("CRC error on data frame\n");
+			/*
+			 * Assume the frame is total garbage.
+			 * We may have copied it over the good part
+			 * of the buffer.
+			 * If so, we need to retry the entire operation.
+			 * Otherwise, ignore it.
+			 */
+			if (fsp->state & FC_SRB_DISCONTIG)
+				fc_fcp_retry_cmd(fsp);
+			return;
+		}
+	}
+
+	if (fsp->xfer_contig_end == start_offset)
+		fsp->xfer_contig_end += copy_len;
+	fsp->xfer_len += copy_len;
+
+	/*
+	 * In the very rare event that this data arrived after the response
+	 * and completes the transfer, call the completion handler.
+	 */
+	if (unlikely(fsp->state & FC_SRB_RCV_STATUS) &&
+	    fsp->xfer_len == fsp->data_len - fsp->scsi_resid)
+		fc_fcp_complete_locked(fsp);
+}
+
+/*
+ * fc_fcp_send_data -  Send SCSI data to target.
+ * @fsp: ptr to fc_fcp_pkt
+ * @sp: ptr to this sequence
+ * @offset: starting offset for this data request
+ * @seq_blen: the burst length for this data request
+ *
+ * Called after receiving a Transfer Ready data descriptor.
+ * if LLD is capable of seq offload then send down seq_blen
+ * size of data in single frame, otherwise send multiple FC
+ * frames of max FC frame payload supported by target port.
+ *
+ * Returns : 0 for success.
+ */
+static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
+			    size_t offset, size_t seq_blen)
+{
+	struct fc_exch *ep;
+	struct scsi_cmnd *sc;
+	struct scatterlist *sg;
+	struct fc_frame *fp = NULL;
+	struct fc_lport *lp = fsp->lp;
+	size_t remaining;
+	size_t t_blen;
+	size_t tlen;
+	size_t sg_bytes;
+	size_t frame_offset, fh_parm_offset;
+	int error;
+	void *data = NULL;
+	void *page_addr;
+	int using_sg = lp->sg_supp;
+	u32 f_ctl;
+
+	WARN_ON(seq_blen <= 0);
+	if (unlikely(offset + seq_blen > fsp->data_len)) {
+		/* this should never happen */
+		FC_DEBUG_FCP("xfer-ready past end. seq_blen %zx offset %zx\n",
+			     seq_blen, offset);
+		fc_fcp_send_abort(fsp);
+		return 0;
+	} else if (offset != fsp->xfer_len) {
+		/* Out of Order Data Request - no problem, but unexpected. */
+		FC_DEBUG_FCP("xfer-ready non-contiguous. "
+			     "seq_blen %zx offset %zx\n", seq_blen, offset);
+	}
+
+	/*
+	 * if LLD is capable of seq_offload then set transport
+	 * burst length (t_blen) to seq_blen, otherwise set t_blen
+	 * to max FC frame payload previously set in fsp->max_payload.
+	 */
+	t_blen = lp->seq_offload ? seq_blen : fsp->max_payload;
+	WARN_ON(t_blen < FC_MIN_MAX_PAYLOAD);
+	if (t_blen > 512)
+		t_blen &= ~(512 - 1);	/* round down to block size */
+	WARN_ON(t_blen < FC_MIN_MAX_PAYLOAD);	/* won't go below 256 */
+	sc = fsp->cmd;
+
+	remaining = seq_blen;
+	fh_parm_offset = frame_offset = offset;
+	tlen = 0;
+	seq = lp->tt.seq_start_next(seq);
+	f_ctl = FC_FC_REL_OFF;
+	WARN_ON(!seq);
+
+	/*
+	 * If a get_page()/put_page() will fail, don't use sg lists
+	 * in the fc_frame structure.
+	 *
+	 * The put_page() may be long after the I/O has completed
+	 * in the case of FCoE, since the network driver does it
+	 * via free_skb().  See the test in free_pages_check().
+	 *
+	 * Test this case with 'dd </dev/zero >/dev/st0 bs=64k'.
+	 */
+	if (using_sg) {
+		for (sg = scsi_sglist(sc); sg; sg = sg_next(sg)) {
+			if (page_count(sg_page(sg)) == 0 ||
+			    (sg_page(sg)->flags & (1 << PG_lru |
+						   1 << PG_private |
+						   1 << PG_locked |
+						   1 << PG_active |
+						   1 << PG_slab |
+						   1 << PG_swapcache |
+						   1 << PG_writeback |
+						   1 << PG_reserved |
+						   1 << PG_buddy))) {
+				using_sg = 0;
+				break;
+			}
+		}
+	}
+	sg = scsi_sglist(sc);
+
+	while (remaining > 0 && sg) {
+		if (offset >= sg->length) {
+			offset -= sg->length;
+			sg = sg_next(sg);
+			continue;
+		}
+		if (!fp) {
+			tlen = min(t_blen, remaining);
+
+			/*
+			 * TODO.  Temporary workaround.	 fc_seq_send() can't
+			 * handle odd lengths in non-linear skbs.
+			 * This will be the final fragment only.
+			 */
+			if (tlen % 4)
+				using_sg = 0;
+			if (using_sg) {
+				fp = _fc_frame_alloc(lp, 0);
+				if (!fp)
+					return -ENOMEM;
+			} else {
+				fp = fc_frame_alloc(lp, tlen);
+				if (!fp)
+					return -ENOMEM;
+
+				data = (void *)(fr_hdr(fp)) +
+					sizeof(struct fc_frame_header);
+			}
+			fh_parm_offset = frame_offset;
+			fr_max_payload(fp) = fsp->max_payload;
+		}
+		sg_bytes = min(tlen, sg->length - offset);
+		if (using_sg) {
+			WARN_ON(skb_shinfo(fp_skb(fp))->nr_frags >
+				FC_FRAME_SG_LEN);
+			get_page(sg_page(sg));
+			skb_fill_page_desc(fp_skb(fp),
+					   skb_shinfo(fp_skb(fp))->nr_frags,
+					   sg_page(sg), sg->offset + offset,
+					   sg_bytes);
+			fp_skb(fp)->data_len += sg_bytes;
+			fr_len(fp) += sg_bytes;
+			fp_skb(fp)->truesize += PAGE_SIZE;
+		} else {
+			size_t off = offset + sg->offset;
+
+			/*
+			 * The scatterlist item may be bigger than PAGE_SIZE,
+			 * but we must not cross pages inside the kmap.
+			 */
+			sg_bytes = min(sg_bytes, (size_t) (PAGE_SIZE -
+							   (off & ~PAGE_MASK)));
+			page_addr = kmap_atomic(sg_page(sg) +
+						(off >> PAGE_SHIFT),
+						KM_SOFTIRQ0);
+			memcpy(data, (char *)page_addr + (off & ~PAGE_MASK),
+			       sg_bytes);
+			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			data += sg_bytes;
+		}
+		offset += sg_bytes;
+		frame_offset += sg_bytes;
+		tlen -= sg_bytes;
+		remaining -= sg_bytes;
+
+		if (tlen)
+			continue;
+
+		/*
+		 * Send sequence with transfer sequence initiative in case
+		 * this is last FCP frame of the sequence.
+		 */
+		if (remaining == 0)
+			f_ctl |= FC_FC_SEQ_INIT | FC_FC_END_SEQ;
+
+		ep = fc_seq_exch(seq);
+		fc_fill_fc_hdr(fp, FC_RCTL_DD_SOL_DATA, ep->did, ep->sid,
+			       FC_TYPE_FCP, f_ctl, fh_parm_offset);
+
+		/*
+		 * send fragment using for a sequence.
+		 */
+		error = lp->tt.seq_send(lp, seq, fp);
+		if (error) {
+			WARN_ON(1);		/* send error should be rare */
+			fc_fcp_retry_cmd(fsp);
+			return 0;
+		}
+		fp = NULL;
+	}
+	fsp->xfer_len += seq_blen;	/* premature count? */
+	return 0;
+}
+
+static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	int ba_done = 1;
+	struct fc_ba_rjt *brp;
+	struct fc_frame_header *fh;
+
+	fh = fc_frame_header_get(fp);
+	switch (fh->fh_r_ctl) {
+	case FC_RCTL_BA_ACC:
+		break;
+	case FC_RCTL_BA_RJT:
+		brp = fc_frame_payload_get(fp, sizeof(*brp));
+		if (brp && brp->br_reason == FC_BA_RJT_LOG_ERR)
+			break;
+		/* fall thru */
+	default:
+		/*
+		 * we will let the command timeout
+		 * and scsi-ml recover in this case,
+		 * therefore cleared the ba_done flag.
+		 */
+		ba_done = 0;
+	}
+
+	if (ba_done) {
+		fsp->state |= FC_SRB_ABORTED;
+		fsp->state &= ~FC_SRB_ABORT_PENDING;
+
+		if (fsp->wait_for_comp)
+			complete(&fsp->tm_done);
+		else
+			fc_fcp_complete_locked(fsp);
+	}
+}
+
+/*
+ * fc_fcp_reduce_can_queue - drop can_queue
+ * @lp: lport to drop queueing for
+ *
+ * If we are getting memory allocation failures, then we may
+ * be trying to execute too many commands. We let the running
+ * commands complete or timeout, then try again with a reduced
+ * can_queue. Eventually we will hit the point where we run
+ * on all reserved structs.
+ */
+static void fc_fcp_reduce_can_queue(struct fc_lport *lp)
+{
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
+	unsigned long flags;
+	int can_queue;
+
+	spin_lock_irqsave(lp->host->host_lock, flags);
+	if (si->throttled)
+		goto done;
+	si->throttled = 1;
+
+	can_queue = lp->host->can_queue;
+	can_queue >>= 1;
+	if (!can_queue)
+		can_queue = 1;
+	lp->host->can_queue = can_queue;
+	shost_printk(KERN_ERR, lp->host, "Could not allocate frame.\n"
+		     "Reducing can_queue to %d.\n", can_queue);
+done:
+	spin_unlock_irqrestore(lp->host->host_lock, flags);
+}
+
+/*
+ * exch mgr calls this routine to process scsi
+ * exchanges.
+ *
+ * Return   : None
+ * Context  : called from Soft IRQ context
+ *	      can not called holding list lock
+ */
+static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)arg;
+	struct fc_lport *lp;
+	struct fc_frame_header *fh;
+	struct fcp_txrdy *dd;
+	u8 r_ctl;
+	int rc = 0;
+
+	if (IS_ERR(fp))
+		goto errout;
+
+	fh = fc_frame_header_get(fp);
+	r_ctl = fh->fh_r_ctl;
+	lp = fsp->lp;
+
+	if (!(lp->state & LPORT_ST_READY))
+		goto out;
+	if (fc_fcp_lock_pkt(fsp))
+		goto out;
+	fsp->last_pkt_time = jiffies;
+
+	if (fh->fh_type == FC_TYPE_BLS) {
+		fc_fcp_abts_resp(fsp, fp);
+		goto unlock;
+	}
+
+	if (fsp->state & (FC_SRB_ABORTED | FC_SRB_ABORT_PENDING))
+		goto unlock;
+
+	if (r_ctl == FC_RCTL_DD_DATA_DESC) {
+		/*
+		 * received XFER RDY from the target
+		 * need to send data to the target
+		 */
+		WARN_ON(fr_flags(fp) & FCPHF_CRC_UNCHECKED);
+		dd = fc_frame_payload_get(fp, sizeof(*dd));
+		WARN_ON(!dd);
+
+		rc = fc_fcp_send_data(fsp, seq,
+				      (size_t) ntohl(dd->ft_data_ro),
+				      (size_t) ntohl(dd->ft_burst_len));
+		if (!rc)
+			seq->rec_data = fsp->xfer_len;
+		else if (rc == -ENOMEM)
+			fsp->state |= FC_SRB_NOMEM;
+	} else if (r_ctl == FC_RCTL_DD_SOL_DATA) {
+		/*
+		 * received a DATA frame
+		 * next we will copy the data to the system buffer
+		 */
+		WARN_ON(fr_len(fp) < sizeof(*fh));	/* len may be 0 */
+		fc_fcp_recv_data(fsp, fp);
+		seq->rec_data = fsp->xfer_contig_end;
+	} else if (r_ctl == FC_RCTL_DD_CMD_STATUS) {
+		WARN_ON(fr_flags(fp) & FCPHF_CRC_UNCHECKED);
+
+		fc_fcp_resp(fsp, fp);
+	} else {
+		FC_DBG("unexpected frame.  r_ctl %x\n", r_ctl);
+	}
+unlock:
+	fc_fcp_unlock_pkt(fsp);
+out:
+	fc_frame_free(fp);
+errout:
+	if (IS_ERR(fp))
+		fc_fcp_error(fsp, fp);
+	else if (rc == -ENOMEM)
+		fc_fcp_reduce_can_queue(lp);
+}
+
+static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	struct fc_frame_header *fh;
+	struct fcp_resp *fc_rp;
+	struct fcp_resp_ext *rp_ex;
+	struct fcp_resp_rsp_info *fc_rp_info;
+	u32 plen;
+	u32 expected_len;
+	u32 respl = 0;
+	u32 snsl = 0;
+	u8 flags = 0;
+
+	plen = fr_len(fp);
+	fh = (struct fc_frame_header *)fr_hdr(fp);
+	if (unlikely(plen < sizeof(*fh) + sizeof(*fc_rp)))
+		goto len_err;
+	plen -= sizeof(*fh);
+	fc_rp = (struct fcp_resp *)(fh + 1);
+	fsp->cdb_status = fc_rp->fr_status;
+	flags = fc_rp->fr_flags;
+	fsp->scsi_comp_flags = flags;
+	expected_len = fsp->data_len;
+
+	if (unlikely((flags & ~FCP_CONF_REQ) || fc_rp->fr_status)) {
+		rp_ex = (void *)(fc_rp + 1);
+		if (flags & (FCP_RSP_LEN_VAL | FCP_SNS_LEN_VAL)) {
+			if (plen < sizeof(*fc_rp) + sizeof(*rp_ex))
+				goto len_err;
+			fc_rp_info = (struct fcp_resp_rsp_info *)(rp_ex + 1);
+			if (flags & FCP_RSP_LEN_VAL) {
+				respl = ntohl(rp_ex->fr_rsp_len);
+				if (respl != sizeof(*fc_rp_info))
+					goto len_err;
+				if (fsp->wait_for_comp) {
+					/* Abuse cdb_status for rsp code */
+					fsp->cdb_status = fc_rp_info->rsp_code;
+					complete(&fsp->tm_done);
+					/*
+					 * tmfs will not have any scsi cmd so
+					 * exit here
+					 */
+					return;
+				} else
+					goto err;
+			}
+			if (flags & FCP_SNS_LEN_VAL) {
+				snsl = ntohl(rp_ex->fr_sns_len);
+				if (snsl > SCSI_SENSE_BUFFERSIZE)
+					snsl = SCSI_SENSE_BUFFERSIZE;
+				memcpy(fsp->cmd->sense_buffer,
+				       (char *)fc_rp_info + respl, snsl);
+			}
+		}
+		if (flags & (FCP_RESID_UNDER | FCP_RESID_OVER)) {
+			if (plen < sizeof(*fc_rp) + sizeof(rp_ex->fr_resid))
+				goto len_err;
+			if (flags & FCP_RESID_UNDER) {
+				fsp->scsi_resid = ntohl(rp_ex->fr_resid);
+				/*
+				 * The cmnd->underflow is the minimum number of
+				 * bytes that must be transfered for this
+				 * command.  Provided a sense condition is not
+				 * present, make sure the actual amount
+				 * transferred is at least the underflow value
+				 * or fail.
+				 */
+				if (!(flags & FCP_SNS_LEN_VAL) &&
+				    (fc_rp->fr_status == 0) &&
+				    (scsi_bufflen(fsp->cmd) -
+				     fsp->scsi_resid) < fsp->cmd->underflow)
+					goto err;
+				expected_len -= fsp->scsi_resid;
+			} else {
+				fsp->status_code = FC_ERROR;
+			}
+		}
+	}
+	fsp->state |= FC_SRB_RCV_STATUS;
+
+	/*
+	 * Check for missing or extra data frames.
+	 */
+	if (unlikely(fsp->xfer_len != expected_len)) {
+		if (fsp->xfer_len < expected_len) {
+			/*
+			 * Some data may be queued locally,
+			 * Wait a at least one jiffy to see if it is delivered.
+			 * If this expires without data, we may do SRR.
+			 */
+			fc_fcp_timer_set(fsp, 2);
+			return;
+		}
+		fsp->status_code = FC_DATA_OVRRUN;
+		FC_DBG("tgt %6x xfer len %zx greater than expected len %x. "
+		       "data len %x\n",
+		       fsp->rport->port_id,
+		       fsp->xfer_len, expected_len, fsp->data_len);
+	}
+	fc_fcp_complete_locked(fsp);
+	return;
+
+len_err:
+	FC_DBG("short FCP response. flags 0x%x len %u respl %u snsl %u\n",
+	       flags, fr_len(fp), respl, snsl);
+err:
+	fsp->status_code = FC_ERROR;
+	fc_fcp_complete_locked(fsp);
+}
+
+/**
+ * fc_fcp_complete_locked - complete processing of a fcp packet
+ * @fsp:	fcp packet
+ *
+ * This function may sleep if a timer is pending. The packet lock must be
+ * held, and the host lock must not be held.
+ */
+static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
+{
+	struct fc_lport *lp = fsp->lp;
+	struct fc_seq *seq;
+	struct fc_exch *ep;
+	u32 f_ctl;
+
+	if (fsp->state & FC_SRB_ABORT_PENDING)
+		return;
+
+	if (fsp->state & FC_SRB_ABORTED) {
+		if (!fsp->status_code)
+			fsp->status_code = FC_CMD_ABORTED;
+	} else {
+		/*
+		 * Test for transport underrun, independent of response
+		 * underrun status.
+		 */
+		if (fsp->xfer_len < fsp->data_len && !fsp->io_status &&
+		    (!(fsp->scsi_comp_flags & FCP_RESID_UNDER) ||
+		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid)) {
+			fsp->status_code = FC_DATA_UNDRUN;
+			fsp->io_status = SUGGEST_RETRY << 24;
+		}
+	}
+
+	seq = fsp->seq_ptr;
+	if (seq) {
+		fsp->seq_ptr = NULL;
+		if (unlikely(fsp->scsi_comp_flags & FCP_CONF_REQ)) {
+			struct fc_frame *conf_frame;
+			struct fc_seq *csp;
+
+			csp = lp->tt.seq_start_next(seq);
+			conf_frame = fc_frame_alloc(fsp->lp, 0);
+			if (conf_frame) {
+				f_ctl = FC_FC_SEQ_INIT;
+				f_ctl |= FC_FC_LAST_SEQ | FC_FC_END_SEQ;
+				ep = fc_seq_exch(seq);
+				fc_fill_fc_hdr(conf_frame, FC_RCTL_DD_SOL_CTL,
+					       ep->did, ep->sid,
+					       FC_TYPE_FCP, f_ctl, 0);
+				lp->tt.seq_send(lp, csp, conf_frame);
+			}
+		}
+		lp->tt.exch_done(seq);
+	}
+	fc_io_compl(fsp);
+}
+
+static void fc_fcp_cleanup_cmd(struct fc_fcp_pkt *fsp, int error)
+{
+	struct fc_lport *lp = fsp->lp;
+
+	if (fsp->seq_ptr) {
+		lp->tt.exch_done(fsp->seq_ptr);
+		fsp->seq_ptr = NULL;
+	}
+	fsp->status_code = error;
+}
+
+/**
+ * fc_fcp_cleanup_each_cmd - run fn on each active command
+ * @lp:		logical port
+ * @id:		target id
+ * @lun:	lun
+ * @error:	fsp status code
+ *
+ * If lun or id is -1, they are ignored.
+ */
+static void fc_fcp_cleanup_each_cmd(struct fc_lport *lp, unsigned int id,
+				    unsigned int lun, int error)
+{
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
+	struct fc_fcp_pkt *fsp;
+	struct scsi_cmnd *sc_cmd;
+	unsigned long flags;
+
+	spin_lock_irqsave(lp->host->host_lock, flags);
+restart:
+	list_for_each_entry(fsp, &si->scsi_pkt_queue, list) {
+		sc_cmd = fsp->cmd;
+		if (id != -1 && scmd_id(sc_cmd) != id)
+			continue;
+
+		if (lun != -1 && sc_cmd->device->lun != lun)
+			continue;
+
+		fc_fcp_pkt_hold(fsp);
+		spin_unlock_irqrestore(lp->host->host_lock, flags);
+
+		if (!fc_fcp_lock_pkt(fsp)) {
+			fc_fcp_cleanup_cmd(fsp, error);
+			fc_io_compl(fsp);
+			fc_fcp_unlock_pkt(fsp);
+		}
+
+		fc_fcp_pkt_release(fsp);
+		spin_lock_irqsave(lp->host->host_lock, flags);
+		/*
+		 * while we dropped the lock multiple pkts could
+		 * have been released, so we have to start over.
+		 */
+		goto restart;
+	}
+	spin_unlock_irqrestore(lp->host->host_lock, flags);
+}
+
+static void fc_fcp_abort_io(struct fc_lport *lp)
+{
+	fc_fcp_cleanup_each_cmd(lp, -1, -1, FC_HRD_ERROR);
+}
+
+/**
+ * fc_fcp_pkt_send - send a fcp packet to the lower level.
+ * @lp:		fc lport
+ * @fsp:	fc packet.
+ *
+ * This is called by upper layer protocol.
+ * Return   : zero for success and -1 for failure
+ * Context  : called from queuecommand which can be called from process
+ *	      or scsi soft irq.
+ * Locks    : called with the host lock and irqs disabled.
+ */
+static int fc_fcp_pkt_send(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
+{
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
+	int rc;
+
+	fsp->cmd->SCp.ptr = (char *)fsp;
+	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
+	fsp->cdb_cmd.fc_flags = fsp->req_flags & ~FCP_CFL_LEN_MASK;
+
+	int_to_scsilun(fsp->cmd->device->lun,
+		       (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
+	memcpy(fsp->cdb_cmd.fc_cdb, fsp->cmd->cmnd, fsp->cmd->cmd_len);
+	list_add_tail(&fsp->list, &si->scsi_pkt_queue);
+
+	spin_unlock_irq(lp->host->host_lock);
+	rc = lp->tt.fcp_cmd_send(lp, fsp, fc_fcp_recv);
+	spin_lock_irq(lp->host->host_lock);
+	if (rc)
+		list_del(&fsp->list);
+
+	return rc;
+}
+
+static int fc_fcp_cmd_send(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
+			   void (*resp)(struct fc_seq *,
+					struct fc_frame *fp,
+					void *arg))
+{
+	struct fc_frame *fp;
+	struct fc_seq *seq;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rp;
+	const size_t len = sizeof(fsp->cdb_cmd);
+	int rc = 0;
+
+	if (fc_fcp_lock_pkt(fsp))
+		return 0;
+
+	fp = fc_frame_alloc(lp, sizeof(fsp->cdb_cmd));
+	if (!fp) {
+		rc = -1;
+		goto unlock;
+	}
+
+	memcpy(fc_frame_payload_get(fp, len), &fsp->cdb_cmd, len);
+	fr_cmd(fp) = fsp->cmd;
+	rport = fsp->rport;
+	fsp->max_payload = rport->maxframe_size;
+	rp = rport->dd_data;
+
+	fc_fill_fc_hdr(fp, FC_RCTL_DD_UNSOL_CMD, rport->port_id,
+		       fc_host_port_id(rp->local_port->host), FC_TYPE_FCP,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	seq = lp->tt.exch_seq_send(lp, fp, resp, fc_fcp_pkt_destroy, fsp, 0);
+	if (!seq) {
+		fc_frame_free(fp);
+		rc = -1;
+		goto unlock;
+	}
+	fsp->last_pkt_time = jiffies;
+	fsp->seq_ptr = seq;
+	fc_fcp_pkt_hold(fsp);	/* hold for fc_fcp_pkt_destroy */
+
+	setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
+	fc_fcp_timer_set(fsp,
+			 (fsp->tgt_flags & FC_RP_FLAGS_REC_SUPPORTED) ?
+			 FC_SCSI_REC_TOV : FC_SCSI_ER_TIMEOUT);
+unlock:
+	fc_fcp_unlock_pkt(fsp);
+	return rc;
+}
+
+/*
+ * transport error handler
+ */
+static void fc_fcp_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	int error = PTR_ERR(fp);
+
+	if (fc_fcp_lock_pkt(fsp))
+		return;
+
+	switch (error) {
+	case -FC_EX_CLOSED:
+		fc_fcp_retry_cmd(fsp);
+		goto unlock;
+	default:
+		FC_DBG("unknown error %ld\n", PTR_ERR(fp));
+	}
+	/*
+	 * clear abort pending, because the lower layer
+	 * decided to force completion.
+	 */
+	fsp->state &= ~FC_SRB_ABORT_PENDING;
+	fsp->status_code = FC_CMD_PLOGO;
+	fc_fcp_complete_locked(fsp);
+unlock:
+	fc_fcp_unlock_pkt(fsp);
+}
+
+/*
+ * Scsi abort handler- calls to send an abort
+ * and then wait for abort completion
+ */
+static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
+{
+	int rc = FAILED;
+
+	if (fc_fcp_send_abort(fsp))
+		return FAILED;
+
+	init_completion(&fsp->tm_done);
+	fsp->wait_for_comp = 1;
+
+	spin_unlock_bh(&fsp->scsi_pkt_lock);
+	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+	spin_lock_bh(&fsp->scsi_pkt_lock);
+	fsp->wait_for_comp = 0;
+
+	if (!rc) {
+		FC_DBG("target abort cmd  failed\n");
+		rc = FAILED;
+	} else if (fsp->state & FC_SRB_ABORTED) {
+		FC_DBG("target abort cmd  passed\n");
+		rc = SUCCESS;
+		fc_fcp_complete_locked(fsp);
+	}
+
+	return rc;
+}
+
+/*
+ * Retry LUN reset after resource allocation failed.
+ */
+static void fc_lun_reset_send(unsigned long data)
+{
+	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
+	struct fc_lport *lp = fsp->lp;
+	if (lp->tt.fcp_cmd_send(lp, fsp, fc_tm_done)) {
+		if (fsp->recov_retry++ >= FC_MAX_RECOV_RETRY)
+			return;
+		if (fc_fcp_lock_pkt(fsp))
+			return;
+		setup_timer(&fsp->timer, fc_lun_reset_send, (unsigned long)fsp);
+		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		fc_fcp_unlock_pkt(fsp);
+	}
+}
+
+/*
+ * Scsi device reset handler- send a LUN RESET to the device
+ * and wait for reset reply
+ */
+static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
+			unsigned int id, unsigned int lun)
+{
+	int rc;
+
+	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
+	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
+	int_to_scsilun(lun, (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
+
+	fsp->wait_for_comp = 1;
+	init_completion(&fsp->tm_done);
+
+	fc_lun_reset_send((unsigned long)fsp);
+
+	/*
+	 * wait for completion of reset
+	 * after that make sure all commands are terminated
+	 */
+	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+
+	spin_lock_bh(&fsp->scsi_pkt_lock);
+	fsp->state |= FC_SRB_COMPL;
+	spin_unlock_bh(&fsp->scsi_pkt_lock);
+
+	del_timer_sync(&fsp->timer);
+
+	spin_lock_bh(&fsp->scsi_pkt_lock);
+	if (fsp->seq_ptr) {
+		lp->tt.exch_done(fsp->seq_ptr);
+		fsp->seq_ptr = NULL;
+	}
+	fsp->wait_for_comp = 0;
+	spin_unlock_bh(&fsp->scsi_pkt_lock);
+
+	if (!rc) {
+		FC_DBG("lun reset failed\n");
+		return FAILED;
+	}
+
+	/* cdb_status holds the tmf's rsp code */
+	if (fsp->cdb_status != FCP_TMF_CMPL)
+		return FAILED;
+
+	FC_DBG("lun reset to lun %u completed\n", lun);
+	fc_fcp_cleanup_each_cmd(lp, id, lun, FC_CMD_ABORTED);
+	return SUCCESS;
+}
+
+/*
+ * Task Managment response handler
+ */
+static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fc_fcp_pkt *fsp = arg;
+	struct fc_frame_header *fh;
+
+	if (IS_ERR(fp)) {
+		/*
+		 * If there is an error just let it timeout or wait
+		 * for TMF to be aborted if it timedout.
+		 *
+		 * scsi-eh will escalate for when either happens.
+		 */
+		return;
+	}
+
+	if (fc_fcp_lock_pkt(fsp))
+		return;
+
+	/*
+	 * raced with eh timeout handler.
+	 */
+	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
+		spin_unlock_bh(&fsp->scsi_pkt_lock);
+		return;
+	}
+
+	fh = fc_frame_header_get(fp);
+	if (fh->fh_type != FC_TYPE_BLS)
+		fc_fcp_resp(fsp, fp);
+	fsp->seq_ptr = NULL;
+	fsp->lp->tt.exch_done(seq);
+	fc_frame_free(fp);
+	fc_fcp_unlock_pkt(fsp);
+}
+
+static void fc_fcp_cleanup(struct fc_lport *lp)
+{
+	fc_fcp_cleanup_each_cmd(lp, -1, -1, FC_ERROR);
+}
+
+/*
+ * fc_fcp_timeout: called by OS timer function.
+ *
+ * The timer has been inactivated and must be reactivated if desired
+ * using fc_fcp_timer_set().
+ *
+ * Algorithm:
+ *
+ * If REC is supported, just issue it, and return.  The REC exchange will
+ * complete or time out, and recovery can continue at that point.
+ *
+ * Otherwise, if the response has been received without all the data,
+ * it has been ER_TIMEOUT since the response was received.
+ *
+ * If the response has not been received,
+ * we see if data was received recently.  If it has been, we continue waiting,
+ * otherwise, we abort the command.
+ */
+static void fc_fcp_timeout(unsigned long data)
+{
+	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
+	struct fc_rport *rport = fsp->rport;
+	struct fc_rport_libfc_priv *rp = rport->dd_data;
+
+	if (fc_fcp_lock_pkt(fsp))
+		return;
+
+	if (fsp->cdb_cmd.fc_tm_flags)
+		goto unlock;
+
+	fsp->state |= FC_SRB_FCP_PROCESSING_TMO;
+
+	if (rp->flags & FC_RP_FLAGS_REC_SUPPORTED)
+		fc_fcp_rec(fsp);
+	else if (time_after_eq(fsp->last_pkt_time + (FC_SCSI_ER_TIMEOUT / 2),
+			       jiffies))
+		fc_fcp_timer_set(fsp, FC_SCSI_ER_TIMEOUT);
+	else if (fsp->state & FC_SRB_RCV_STATUS)
+		fc_fcp_complete_locked(fsp);
+	else
+		fc_timeout_error(fsp);
+	fsp->state &= ~FC_SRB_FCP_PROCESSING_TMO;
+unlock:
+	fc_fcp_unlock_pkt(fsp);
+}
+
+/*
+ * Send a REC ELS request
+ */
+static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
+{
+	struct fc_lport *lp;
+	struct fc_frame *fp;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rp;
+
+	lp = fsp->lp;
+	rport = fsp->rport;
+	rp = rport->dd_data;
+	if (!fsp->seq_ptr || rp->rp_state != RPORT_ST_READY) {
+		fsp->status_code = FC_HRD_ERROR;
+		fsp->io_status = SUGGEST_RETRY << 24;
+		fc_fcp_complete_locked(fsp);
+		return;
+	}
+	fp = fc_frame_alloc(lp, sizeof(struct fc_els_rec));
+	if (!fp)
+		goto retry;
+
+	fr_seq(fp) = fsp->seq_ptr;
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rport->port_id,
+		       fc_host_port_id(rp->local_port->host), FC_TYPE_ELS,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+	if (lp->tt.elsct_send(lp, rport, fp, ELS_REC, fc_fcp_rec_resp,
+			      fsp, jiffies_to_msecs(FC_SCSI_REC_TOV))) {
+		fc_fcp_pkt_hold(fsp);		/* hold while REC outstanding */
+		return;
+	}
+	fc_frame_free(fp);
+retry:
+	if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
+		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+	else
+		fc_timeout_error(fsp);
+}
+
+/*
+ * Receive handler for REC ELS frame
+ * if it is a reject then let the scsi layer to handle
+ * the timeout. if it is a LS_ACC then if the io was not completed
+ * then set the timeout and return otherwise complete the exchange
+ * and tell the scsi layer to restart the I/O.
+ */
+static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)arg;
+	struct fc_els_rec_acc *recp;
+	struct fc_els_ls_rjt *rjt;
+	u32 e_stat;
+	u8 opcode;
+	u32 offset;
+	enum dma_data_direction data_dir;
+	enum fc_rctl r_ctl;
+	struct fc_rport_libfc_priv *rp;
+
+	if (IS_ERR(fp)) {
+		fc_fcp_rec_error(fsp, fp);
+		return;
+	}
+
+	if (fc_fcp_lock_pkt(fsp))
+		goto out;
+
+	fsp->recov_retry = 0;
+	opcode = fc_frame_payload_op(fp);
+	if (opcode == ELS_LS_RJT) {
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		switch (rjt->er_reason) {
+		default:
+			FC_DEBUG_FCP("device %x unexpected REC reject "
+				     "reason %d expl %d\n",
+				     fsp->rport->port_id, rjt->er_reason,
+				     rjt->er_explan);
+			/* fall through */
+		case ELS_RJT_UNSUP:
+			FC_DEBUG_FCP("device does not support REC\n");
+			rp = fsp->rport->dd_data;
+			/*
+			 * if we do not spport RECs or got some bogus
+			 * reason then resetup timer so we check for
+			 * making progress.
+			 */
+			rp->flags &= ~FC_RP_FLAGS_REC_SUPPORTED;
+			fc_fcp_timer_set(fsp, FC_SCSI_ER_TIMEOUT);
+			break;
+		case ELS_RJT_LOGIC:
+		case ELS_RJT_UNAB:
+			/*
+			 * If no data transfer, the command frame got dropped
+			 * so we just retry.  If data was transferred, we
+			 * lost the response but the target has no record,
+			 * so we abort and retry.
+			 */
+			if (rjt->er_explan == ELS_EXPL_OXID_RXID &&
+			    fsp->xfer_len == 0) {
+				fc_fcp_retry_cmd(fsp);
+				break;
+			}
+			fc_timeout_error(fsp);
+			break;
+		}
+	} else if (opcode == ELS_LS_ACC) {
+		if (fsp->state & FC_SRB_ABORTED)
+			goto unlock_out;
+
+		data_dir = fsp->cmd->sc_data_direction;
+		recp = fc_frame_payload_get(fp, sizeof(*recp));
+		offset = ntohl(recp->reca_fc4value);
+		e_stat = ntohl(recp->reca_e_stat);
+
+		if (e_stat & ESB_ST_COMPLETE) {
+
+			/*
+			 * The exchange is complete.
+			 *
+			 * For output, we must've lost the response.
+			 * For input, all data must've been sent.
+			 * We lost may have lost the response
+			 * (and a confirmation was requested) and maybe
+			 * some data.
+			 *
+			 * If all data received, send SRR
+			 * asking for response.	 If partial data received,
+			 * or gaps, SRR requests data at start of gap.
+			 * Recovery via SRR relies on in-order-delivery.
+			 */
+			if (data_dir == DMA_TO_DEVICE) {
+				r_ctl = FC_RCTL_DD_CMD_STATUS;
+			} else if (fsp->xfer_contig_end == offset) {
+				r_ctl = FC_RCTL_DD_CMD_STATUS;
+			} else {
+				offset = fsp->xfer_contig_end;
+				r_ctl = FC_RCTL_DD_SOL_DATA;
+			}
+			fc_fcp_srr(fsp, r_ctl, offset);
+		} else if (e_stat & ESB_ST_SEQ_INIT) {
+
+			/*
+			 * The remote port has the initiative, so just
+			 * keep waiting for it to complete.
+			 */
+			fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		} else {
+
+			/*
+			 * The exchange is incomplete, we have seq. initiative.
+			 * Lost response with requested confirmation,
+			 * lost confirmation, lost transfer ready or
+			 * lost write data.
+			 *
+			 * For output, if not all data was received, ask
+			 * for transfer ready to be repeated.
+			 *
+			 * If we received or sent all the data, send SRR to
+			 * request response.
+			 *
+			 * If we lost a response, we may have lost some read
+			 * data as well.
+			 */
+			r_ctl = FC_RCTL_DD_SOL_DATA;
+			if (data_dir == DMA_TO_DEVICE) {
+				r_ctl = FC_RCTL_DD_CMD_STATUS;
+				if (offset < fsp->data_len)
+					r_ctl = FC_RCTL_DD_DATA_DESC;
+			} else if (offset == fsp->xfer_contig_end) {
+				r_ctl = FC_RCTL_DD_CMD_STATUS;
+			} else if (fsp->xfer_contig_end < offset) {
+				offset = fsp->xfer_contig_end;
+			}
+			fc_fcp_srr(fsp, r_ctl, offset);
+		}
+	}
+unlock_out:
+	fc_fcp_unlock_pkt(fsp);
+out:
+	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding REC */
+	fc_frame_free(fp);
+}
+
+/*
+ * Handle error response or timeout for REC exchange.
+ */
+static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	int error = PTR_ERR(fp);
+
+	if (fc_fcp_lock_pkt(fsp))
+		goto out;
+
+	switch (error) {
+	case -FC_EX_CLOSED:
+		fc_fcp_retry_cmd(fsp);
+		break;
+
+	default:
+		FC_DBG("REC %p fid %x error unexpected error %d\n",
+		       fsp, fsp->rport->port_id, error);
+		fsp->status_code = FC_CMD_PLOGO;
+		/* fall through */
+
+	case -FC_EX_TIMEOUT:
+		/*
+		 * Assume REC or LS_ACC was lost.
+		 * The exchange manager will have aborted REC, so retry.
+		 */
+		FC_DBG("REC fid %x error error %d retry %d/%d\n",
+		       fsp->rport->port_id, error, fsp->recov_retry,
+		       FC_MAX_RECOV_RETRY);
+		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
+			fc_fcp_rec(fsp);
+		else
+			fc_timeout_error(fsp);
+		break;
+	}
+	fc_fcp_unlock_pkt(fsp);
+out:
+	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding REC */
+}
+
+/*
+ * Time out error routine:
+ * abort's the I/O close the exchange and
+ * send completion notification to scsi layer
+ */
+static void fc_timeout_error(struct fc_fcp_pkt *fsp)
+{
+	fsp->status_code = FC_CMD_TIME_OUT;
+	fsp->cdb_status = 0;
+	fsp->io_status = 0;
+	/*
+	 * if this fails then we let the scsi command timer fire and
+	 * scsi-ml escalate.
+	 */
+	fc_fcp_send_abort(fsp);
+}
+
+/*
+ * Sequence retransmission request.
+ * This is called after receiving status but insufficient data, or
+ * when expecting status but the request has timed out.
+ */
+static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
+{
+	struct fc_lport *lp = fsp->lp;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rp;
+	struct fc_exch *ep = fc_seq_exch(fsp->seq_ptr);
+	struct fc_seq *seq;
+	struct fcp_srr *srr;
+	struct fc_frame *fp;
+	u8 cdb_op;
+
+	rport = fsp->rport;
+	rp = rport->dd_data;
+	cdb_op = fsp->cdb_cmd.fc_cdb[0];
+
+	if (!(rp->flags & FC_RP_FLAGS_RETRY) || rp->rp_state != RPORT_ST_READY)
+		goto retry;			/* shouldn't happen */
+	fp = fc_frame_alloc(lp, sizeof(*srr));
+	if (!fp)
+		goto retry;
+
+	srr = fc_frame_payload_get(fp, sizeof(*srr));
+	memset(srr, 0, sizeof(*srr));
+	srr->srr_op = ELS_SRR;
+	srr->srr_ox_id = htons(ep->oxid);
+	srr->srr_rx_id = htons(ep->rxid);
+	srr->srr_r_ctl = r_ctl;
+	srr->srr_rel_off = htonl(offset);
+
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS4_REQ, rport->port_id,
+		       fc_host_port_id(rp->local_port->host), FC_TYPE_FCP,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	seq = lp->tt.exch_seq_send(lp, fp, fc_fcp_srr_resp, NULL,
+				   fsp, jiffies_to_msecs(FC_SCSI_REC_TOV));
+	if (!seq) {
+		fc_frame_free(fp);
+		goto retry;
+	}
+	fsp->recov_seq = seq;
+	fsp->xfer_len = offset;
+	fsp->xfer_contig_end = offset;
+	fsp->state &= ~FC_SRB_RCV_STATUS;
+	fc_fcp_pkt_hold(fsp);		/* hold for outstanding SRR */
+	return;
+retry:
+	fc_fcp_retry_cmd(fsp);
+}
+
+/*
+ * Handle response from SRR.
+ */
+static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fc_fcp_pkt *fsp = arg;
+	struct fc_frame_header *fh;
+
+	if (IS_ERR(fp)) {
+		fc_fcp_srr_error(fsp, fp);
+		return;
+	}
+
+	if (fc_fcp_lock_pkt(fsp))
+		goto out;
+
+	fh = fc_frame_header_get(fp);
+	/*
+	 * BUG? fc_fcp_srr_error calls exch_done which would release
+	 * the ep. But if fc_fcp_srr_error had got -FC_EX_TIMEOUT,
+	 * then fc_exch_timeout would be sending an abort. The exch_done
+	 * call by fc_fcp_srr_error would prevent fc_exch.c from seeing
+	 * an abort response though.
+	 */
+	if (fh->fh_type == FC_TYPE_BLS) {
+		fc_fcp_unlock_pkt(fsp);
+		return;
+	}
+
+	fsp->recov_seq = NULL;
+	switch (fc_frame_payload_op(fp)) {
+	case ELS_LS_ACC:
+		fsp->recov_retry = 0;
+		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		break;
+	case ELS_LS_RJT:
+	default:
+		fc_timeout_error(fsp);
+		break;
+	}
+	fc_fcp_unlock_pkt(fsp);
+	fsp->lp->tt.exch_done(seq);
+out:
+	fc_frame_free(fp);
+	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding SRR */
+}
+
+static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+{
+	if (fc_fcp_lock_pkt(fsp))
+		goto out;
+	fsp->lp->tt.exch_done(fsp->recov_seq);
+	fsp->recov_seq = NULL;
+	switch (PTR_ERR(fp)) {
+	case -FC_EX_TIMEOUT:
+		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
+			fc_fcp_rec(fsp);
+		else
+			fc_timeout_error(fsp);
+		break;
+	case -FC_EX_CLOSED:			/* e.g., link failure */
+		/* fall through */
+	default:
+		fc_fcp_retry_cmd(fsp);
+		break;
+	}
+	fc_fcp_unlock_pkt(fsp);
+out:
+	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding SRR */
+}
+
+static inline int fc_fcp_lport_queue_ready(struct fc_lport *lp)
+{
+	/* lock ? */
+	return (lp->state == LPORT_ST_READY) && (lp->link_status & FC_LINK_UP);
+}
+
+/**
+ * fc_queuecommand - The queuecommand function of the scsi template
+ * @cmd:	struct scsi_cmnd to be executed
+ * @done:	Callback function to be called when cmd is completed
+ *
+ * this is the i/o strategy routine, called by the scsi layer
+ * this routine is called with holding the host_lock.
+ */
+int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
+{
+	struct fc_lport *lp;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_fcp_pkt *fsp;
+	struct fc_rport_libfc_priv *rp;
+	int rval;
+	int rc = 0;
+	struct fcoe_dev_stats *stats;
+
+	lp = shost_priv(sc_cmd->device->host);
+
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		sc_cmd->result = rval;
+		done(sc_cmd);
+		goto out;
+	}
+
+	if (!*(struct fc_remote_port **)rport->dd_data) {
+		/*
+		 * rport is transitioning from blocked/deleted to
+		 * online
+		 */
+		sc_cmd->result = DID_IMM_RETRY << 16;
+		done(sc_cmd);
+		goto out;
+	}
+
+	rp = rport->dd_data;
+
+	if (!fc_fcp_lport_queue_ready(lp)) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	fsp = fc_fcp_pkt_alloc(lp, GFP_ATOMIC);
+	if (fsp == NULL) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	/*
+	 * build the libfc request pkt
+	 */
+	fsp->cmd = sc_cmd;	/* save the cmd */
+	fsp->lp = lp;		/* save the softc ptr */
+	fsp->rport = rport;	/* set the remote port ptr */
+	sc_cmd->scsi_done = done;
+
+	/*
+	 * set up the transfer length
+	 */
+	fsp->data_len = scsi_bufflen(sc_cmd);
+	fsp->xfer_len = 0;
+
+	/*
+	 * setup the data direction
+	 */
+	stats = lp->dev_stats[smp_processor_id()];
+	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		fsp->req_flags = FC_SRB_READ;
+		stats->InputRequests++;
+		stats->InputMegabytes = fsp->data_len;
+	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
+		fsp->req_flags = FC_SRB_WRITE;
+		stats->OutputRequests++;
+		stats->OutputMegabytes = fsp->data_len;
+	} else {
+		fsp->req_flags = 0;
+		stats->ControlRequests++;
+	}
+
+	fsp->tgt_flags = rp->flags;
+
+	init_timer(&fsp->timer);
+	fsp->timer.data = (unsigned long)fsp;
+
+	/*
+	 * send it to the lower layer
+	 * if we get -1 return then put the request in the pending
+	 * queue.
+	 */
+	rval = fc_fcp_pkt_send(lp, fsp);
+	if (rval != 0) {
+		fsp->state = FC_SRB_FREE;
+		fc_fcp_pkt_release(fsp);
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+	}
+out:
+	return rc;
+}
+EXPORT_SYMBOL(fc_queuecommand);
+
+/**
+ * fc_io_compl -  Handle responses for completed commands
+ * @fsp:	scsi packet
+ *
+ * Translates a error to a Linux SCSI error.
+ *
+ * The fcp packet lock must be held when calling.
+ */
+static void fc_io_compl(struct fc_fcp_pkt *fsp)
+{
+	struct fc_fcp_internal *si;
+	struct scsi_cmnd *sc_cmd;
+	struct fc_lport *lp;
+	unsigned long flags;
+
+	fsp->state |= FC_SRB_COMPL;
+	if (!(fsp->state & FC_SRB_FCP_PROCESSING_TMO)) {
+		spin_unlock_bh(&fsp->scsi_pkt_lock);
+		del_timer_sync(&fsp->timer);
+		spin_lock_bh(&fsp->scsi_pkt_lock);
+	}
+
+	lp = fsp->lp;
+	si = fc_get_scsi_internal(lp);
+	spin_lock_irqsave(lp->host->host_lock, flags);
+	if (!fsp->cmd) {
+		spin_unlock_irqrestore(lp->host->host_lock, flags);
+		return;
+	}
+
+	/*
+	 * if a command timed out while we had to try and throttle IO
+	 * and it is now getting cleaned up, then we are about to
+	 * try again so clear the throttled flag incase we get more
+	 * time outs.
+	 */
+	if (si->throttled && fsp->state & FC_SRB_NOMEM)
+		si->throttled = 0;
+
+	sc_cmd = fsp->cmd;
+	fsp->cmd = NULL;
+
+	if (!sc_cmd->SCp.ptr) {
+		spin_unlock_irqrestore(lp->host->host_lock, flags);
+		return;
+	}
+
+	CMD_SCSI_STATUS(sc_cmd) = fsp->cdb_status;
+	switch (fsp->status_code) {
+	case FC_COMPLETE:
+		if (fsp->cdb_status == 0) {
+			/*
+			 * good I/O status
+			 */
+			sc_cmd->result = DID_OK << 16;
+			if (fsp->scsi_resid)
+				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+		} else if (fsp->cdb_status == QUEUE_FULL) {
+			struct scsi_device *tmp_sdev;
+			struct scsi_device *sdev = sc_cmd->device;
+
+			shost_for_each_device(tmp_sdev, sdev->host) {
+				if (tmp_sdev->id != sdev->id)
+					continue;
+
+				if (tmp_sdev->queue_depth > 1) {
+					scsi_track_queue_full(tmp_sdev,
+							      tmp_sdev->
+							      queue_depth - 1);
+				}
+			}
+			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+		} else {
+			/*
+			 * transport level I/O was ok but scsi
+			 * has non zero status
+			 */
+			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+		}
+		break;
+	case FC_ERROR:
+		sc_cmd->result = DID_ERROR << 16;
+		break;
+	case FC_DATA_UNDRUN:
+		if (fsp->cdb_status == 0) {
+			/*
+			 * scsi status is good but transport level
+			 * underrun. for read it should be an error??
+			 */
+			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+		} else {
+			/*
+			 * scsi got underrun, this is an error
+			 */
+			CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+			sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
+		}
+		break;
+	case FC_DATA_OVRRUN:
+		/*
+		 * overrun is an error
+		 */
+		sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
+		break;
+	case FC_CMD_ABORTED:
+		sc_cmd->result = (DID_ABORT << 16) | fsp->io_status;
+		break;
+	case FC_CMD_TIME_OUT:
+		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
+		break;
+	case FC_CMD_RESET:
+		sc_cmd->result = (DID_RESET << 16);
+		break;
+	case FC_HRD_ERROR:
+		sc_cmd->result = (DID_NO_CONNECT << 16);
+		break;
+	default:
+		sc_cmd->result = (DID_ERROR << 16);
+		break;
+	}
+
+	list_del(&fsp->list);
+	sc_cmd->SCp.ptr = NULL;
+	sc_cmd->scsi_done(sc_cmd);
+	spin_unlock_irqrestore(lp->host->host_lock, flags);
+
+	/* release ref from initial allocation in queue command */
+	fc_fcp_pkt_release(fsp);
+}
+
+/**
+ * fc_fcp_complete - complete processing of a fcp packet
+ * @fsp:	fcp packet
+ *
+ * This function may sleep if a fsp timer is pending.
+ * The host lock must not be held by caller.
+ */
+void fc_fcp_complete(struct fc_fcp_pkt *fsp)
+{
+	if (fc_fcp_lock_pkt(fsp))
+		return;
+
+	fc_fcp_complete_locked(fsp);
+	fc_fcp_unlock_pkt(fsp);
+}
+EXPORT_SYMBOL(fc_fcp_complete);
+
+/**
+ * fc_eh_abort - Abort a command...from scsi host template
+ * @sc_cmd:	scsi command to abort
+ *
+ * send ABTS to the target device  and wait for the response
+ * sc_cmd is the pointer to the command to be aborted.
+ */
+int fc_eh_abort(struct scsi_cmnd *sc_cmd)
+{
+	struct fc_fcp_pkt *fsp;
+	struct fc_lport *lp;
+	int rc = FAILED;
+	unsigned long flags;
+
+	lp = shost_priv(sc_cmd->device->host);
+	if (lp->state != LPORT_ST_READY)
+		return rc;
+	else if (!(lp->link_status & FC_LINK_UP))
+		return rc;
+
+	spin_lock_irqsave(lp->host->host_lock, flags);
+	fsp = CMD_SP(sc_cmd);
+	if (!fsp) {
+		/* command completed while scsi eh was setting up */
+		spin_unlock_irqrestore(lp->host->host_lock, flags);
+		return SUCCESS;
+	}
+	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */
+	fc_fcp_pkt_hold(fsp);
+	spin_unlock_irqrestore(lp->host->host_lock, flags);
+
+	if (fc_fcp_lock_pkt(fsp)) {
+		/* completed while we were waiting for timer to be deleted */
+		rc = SUCCESS;
+		goto release_pkt;
+	}
+
+	rc = fc_fcp_pkt_abort(lp, fsp);
+	fc_fcp_unlock_pkt(fsp);
+
+release_pkt:
+	fc_fcp_pkt_release(fsp);
+	return rc;
+}
+EXPORT_SYMBOL(fc_eh_abort);
+
+/**
+ * fc_eh_device_reset: Reset a single LUN
+ * @sc_cmd:	scsi command
+ *
+ * Set from scsi host template to send tm cmd to the target and wait for the
+ * response.
+ */
+int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
+{
+	struct fc_lport *lp;
+	struct fc_fcp_pkt *fsp;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	int rc = FAILED;
+	struct fc_rport_libfc_priv *rp;
+	int rval;
+
+	rval = fc_remote_port_chkready(rport);
+	if (rval)
+		goto out;
+
+	rp = rport->dd_data;
+	lp = shost_priv(sc_cmd->device->host);
+
+	if (lp->state != LPORT_ST_READY)
+		return rc;
+
+	fsp = fc_fcp_pkt_alloc(lp, GFP_NOIO);
+	if (fsp == NULL) {
+		FC_DBG("could not allocate scsi_pkt\n");
+		sc_cmd->result = DID_NO_CONNECT << 16;
+		goto out;
+	}
+
+	/*
+	 * Build the libfc request pkt. Do not set the scsi cmnd, because
+	 * the sc passed in is not setup for execution like when sent
+	 * through the queuecommand callout.
+	 */
+	fsp->lp = lp;		/* save the softc ptr */
+	fsp->rport = rport;	/* set the remote port ptr */
+
+	/*
+	 * flush outstanding commands
+	 */
+	rc = fc_lun_reset(lp, fsp, scmd_id(sc_cmd), sc_cmd->device->lun);
+	fsp->state = FC_SRB_FREE;
+	fc_fcp_pkt_release(fsp);
+
+out:
+	return rc;
+}
+EXPORT_SYMBOL(fc_eh_device_reset);
+
+/**
+ * fc_eh_host_reset - The reset function will reset the ports on the host.
+ * @sc_cmd:	scsi command
+ */
+int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
+{
+	struct Scsi_Host *shost = sc_cmd->device->host;
+	struct fc_lport *lp = shost_priv(shost);
+	unsigned long wait_tmo;
+
+	lp->tt.lport_reset(lp);
+	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
+	while (!fc_fcp_lport_queue_ready(lp) && time_before(jiffies, wait_tmo))
+		msleep(1000);
+
+	if (fc_fcp_lport_queue_ready(lp)) {
+		shost_printk(KERN_INFO, shost, "Host reset succeeded.\n");
+		return SUCCESS;
+	} else {
+		shost_printk(KERN_INFO, shost, "Host reset failed. "
+			     "lport not ready.\n");
+		return FAILED;
+	}
+}
+EXPORT_SYMBOL(fc_eh_host_reset);
+
+/**
+ * fc_slave_alloc - configure queue depth
+ * @sdev:	scsi device
+ *
+ * Configures queue depth based on host's cmd_per_len. If not set
+ * then we use the libfc default.
+ */
+int fc_slave_alloc(struct scsi_device *sdev)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	int queue_depth;
+
+	if (!rport || fc_remote_port_chkready(rport))
+		return -ENXIO;
+
+	if (sdev->tagged_supported) {
+		if (sdev->host->hostt->cmd_per_lun)
+			queue_depth = sdev->host->hostt->cmd_per_lun;
+		else
+			queue_depth = FC_FCP_DFLT_QUEUE_DEPTH;
+		scsi_activate_tcq(sdev, queue_depth);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fc_slave_alloc);
+
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	return sdev->queue_depth;
+}
+EXPORT_SYMBOL(fc_change_queue_depth);
+
+int fc_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+EXPORT_SYMBOL(fc_change_queue_type);
+
+void fc_fcp_destroy(struct fc_lport *lp)
+{
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
+
+	if (!list_empty(&si->scsi_pkt_queue))
+		printk(KERN_ERR "Leaked scsi packets.\n");
+
+	mempool_destroy(si->scsi_pkt_pool);
+	kfree(si);
+	lp->scsi_priv = NULL;
+}
+EXPORT_SYMBOL(fc_fcp_destroy);
+
+int fc_fcp_init(struct fc_lport *lp)
+{
+	int rc;
+	struct fc_fcp_internal *si;
+
+	if (!lp->tt.fcp_cmd_send)
+		lp->tt.fcp_cmd_send = fc_fcp_cmd_send;
+
+	if (!lp->tt.fcp_cleanup)
+		lp->tt.fcp_cleanup = fc_fcp_cleanup;
+
+	if (!lp->tt.fcp_abort_io)
+		lp->tt.fcp_abort_io = fc_fcp_abort_io;
+
+	si = kzalloc(sizeof(struct fc_fcp_internal), GFP_KERNEL);
+	if (!si)
+		return -ENOMEM;
+	lp->scsi_priv = si;
+	INIT_LIST_HEAD(&si->scsi_pkt_queue);
+
+	si->scsi_pkt_pool = mempool_create_slab_pool(2, scsi_pkt_cachep);
+	if (!si->scsi_pkt_pool) {
+		rc = -ENOMEM;
+		goto free_internal;
+	}
+	return 0;
+
+free_internal:
+	kfree(si);
+	return rc;
+}
+EXPORT_SYMBOL(fc_fcp_init);
+
+static int __init libfc_init(void)
+{
+	int rc;
+
+	scsi_pkt_cachep = kmem_cache_create("libfc_fcp_pkt",
+					    sizeof(struct fc_fcp_pkt),
+					    0, SLAB_HWCACHE_ALIGN, NULL);
+	if (scsi_pkt_cachep == NULL) {
+		FC_DBG("Unable to allocate SRB cache...module load failed!");
+		return -ENOMEM;
+	}
+
+	rc = fc_setup_exch_mgr();
+	if (rc)
+		goto destroy_pkt_cache;
+
+	rc = fc_setup_rport();
+	if (rc)
+		goto destroy_em;
+
+	return rc;
+destroy_em:
+	fc_destroy_exch_mgr();
+destroy_pkt_cache:
+	kmem_cache_destroy(scsi_pkt_cachep);
+	return rc;
+}
+
+static void __exit libfc_exit(void)
+{
+	kmem_cache_destroy(scsi_pkt_cachep);
+	fc_destroy_exch_mgr();
+	fc_destroy_rport();
+}
+
+module_init(libfc_init);
+module_exit(libfc_exit);
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
new file mode 100644
index 0000000..0bbeff2
--- /dev/null
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * Frame allocation.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/crc32.h>
+
+#include <scsi/fc_frame.h>
+
+/*
+ * Check the CRC in a frame.
+ */
+u32 fc_frame_crc_check(struct fc_frame *fp)
+{
+	u32 crc;
+	u32 error;
+	const u8 *bp;
+	unsigned int len;
+
+	WARN_ON(!fc_frame_is_linear(fp));
+	fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+	len = (fr_len(fp) + 3) & ~3;	/* round up length to include fill */
+	bp = (const u8 *) fr_hdr(fp);
+	crc = ~crc32(~0, bp, len);
+	error = crc ^ *(u32 *) (bp + len);
+	return error;
+}
+EXPORT_SYMBOL(fc_frame_crc_check);
+
+/*
+ * Allocate a frame intended to be sent via fcoe_xmit.
+ * Get an sk_buff for the frame and set the length.
+ */
+struct fc_frame *__fc_frame_alloc(size_t len)
+{
+	struct fc_frame *fp;
+	struct sk_buff *skb;
+
+	WARN_ON((len % sizeof(u32)) != 0);
+	len += sizeof(struct fc_frame_header);
+	skb = dev_alloc_skb(len + FC_FRAME_HEADROOM + FC_FRAME_TAILROOM);
+	if (!skb)
+		return NULL;
+	fp = (struct fc_frame *) skb;
+	fc_frame_init(fp);
+	skb_reserve(skb, FC_FRAME_HEADROOM);
+	skb_put(skb, len);
+	return fp;
+}
+EXPORT_SYMBOL(__fc_frame_alloc);
+
+
+struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
+{
+	struct fc_frame *fp;
+	size_t fill;
+
+	fill = payload_len % 4;
+	if (fill != 0)
+		fill = 4 - fill;
+	fp = __fc_frame_alloc(payload_len + fill);
+	if (fp) {
+		memset((char *) fr_hdr(fp) + payload_len, 0, fill);
+		/* trim is OK, we just allocated it so there are no fragments */
+		skb_trim(fp_skb(fp),
+			 payload_len + sizeof(struct fc_frame_header));
+	}
+	return fp;
+}
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
new file mode 100644
index 0000000..083d57b
--- /dev/null
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -0,0 +1,1525 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * General locking notes:
+ *
+ * The lport and rport blocks both have mutexes that are used to protect
+ * the port objects states. The main motivation for this protection is that
+ * we don't want to be preparing a request/response in one context while
+ * another thread "resets" the port in question. For example, if the lport
+ * block is sending a SCR request to the directory server we don't want
+ * the lport to be reset before we fill out the frame header's port_id. The
+ * problem is that a reset would cause the lport's port_id to reset to 0.
+ * If we don't protect the lport we'd spew incorrect frames.
+ *
+ * At the time of this writing there are two primary mutexes, one for the
+ * lport and one for the rport. Since the lport uses the rport and makes
+ * calls into that block the rport should never make calls that would cause
+ * the lport's mutex to be locked. In other words, the lport's mutex is
+ * considered the outer lock and the rport's lock is considered the inner
+ * lock. The bottom line is that you can hold a lport's mutex and then
+ * hold the rport's mutex, but not the other way around.
+ *
+ * The only complication to this rule is the callbacks from the rport to
+ * the lport's event_callback function. When rports become READY they make
+ * a callback to the lport so that it can track them. In the case of the
+ * directory server that callback might cause the lport to change its
+ * state, implying that the lport mutex would need to be held. This problem
+ * was solved by serializing the rport notifications to the lport and the
+ * callback is made without holding the rport's lock.
+ *
+ * lport locking notes:
+ *
+ * The critical sections protected by the lport's mutex are quite broad and
+ * may be improved upon in the future. The lport code and its locking doesn't
+ * influence the I/O path, so excessive locking doesn't penalize I/O
+ * performance.
+ *
+ * The strategy is to lock whenever processing a request or response. Note
+ * that every _enter_* function corresponds to a state change. They generally
+ * change the lports state and then sends a request out on the wire. We lock
+ * before calling any of these functions to protect that state change. This
+ * means that the entry points into the lport block to manage the locks while
+ * the state machine can transition between states (i.e. _enter_* functions)
+ * while always staying protected.
+ *
+ * When handling responses we also hold the lport mutex broadly. When the
+ * lport receives the response frame it locks the mutex and then calls the
+ * appropriate handler for the particuar response. Generally a response will
+ * trigger a state change and so the lock must already be held.
+ *
+ * Retries also have to consider the locking. The retries occur from a work
+ * context and the work function will lock the lport and then retry the state
+ * (i.e. _enter_* function).
+ *
+ * The implication to all of this is that each lport can only process one
+ * state at a time.
+ */
+
+#include <linux/timer.h>
+#include <asm/unaligned.h>
+
+#include <scsi/fc/fc_gs.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+/* Fabric IDs to use for point-to-point mode, chosen on whims. */
+#define FC_LOCAL_PTP_FID_LO   0x010101
+#define FC_LOCAL_PTP_FID_HI   0x010102
+
+#define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/
+
+static int fc_lport_debug;
+
+#define FC_DEBUG_LPORT(fmt...)			\
+	do {					\
+		if (fc_lport_debug)		\
+			FC_DBG(fmt);		\
+	} while (0)
+
+static void fc_lport_error(struct fc_lport *, struct fc_frame *);
+
+static void fc_lport_enter_reset(struct fc_lport *);
+static void fc_lport_enter_flogi(struct fc_lport *);
+static void fc_lport_enter_dns(struct fc_lport *);
+static void fc_lport_enter_rpn_id(struct fc_lport *);
+static void fc_lport_enter_rft_id(struct fc_lport *);
+static void fc_lport_enter_scr(struct fc_lport *);
+static void fc_lport_enter_ready(struct fc_lport *);
+static void fc_lport_enter_logo(struct fc_lport *);
+
+static const char *fc_lport_state_names[] = {
+	[LPORT_ST_NONE] =     "none",
+	[LPORT_ST_FLOGI] =    "FLOGI",
+	[LPORT_ST_DNS] =      "dNS",
+	[LPORT_ST_RPN_ID] =   "RPN_ID",
+	[LPORT_ST_RFT_ID] =   "RFT_ID",
+	[LPORT_ST_SCR] =      "SCR",
+	[LPORT_ST_READY] =    "Ready",
+	[LPORT_ST_LOGO] =     "LOGO",
+	[LPORT_ST_RESET] =    "reset",
+};
+
+static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
+{
+	fc_frame_free(fp);
+	return 0;
+}
+
+/**
+ * fc_lport_rport_event - Event handler for rport events
+ * @lport: The lport which is receiving the event
+ * @rport: The rport which the event has occured on
+ * @event: The event that occured
+ *
+ * Locking Note: The rport lock should not be held when calling
+ *		 this function.
+ */
+static void fc_lport_rport_event(struct fc_lport *lport,
+				 struct fc_rport *rport,
+				 enum fc_lport_event event)
+{
+	FC_DEBUG_LPORT("Received a %d event for port (%6x)\n", event,
+		       rport->port_id);
+
+	switch (event) {
+	case RPORT_EV_CREATED:
+		if (rport->port_id == FC_FID_DIR_SERV) {
+			mutex_lock(&lport->lp_mutex);
+			if (lport->state == LPORT_ST_DNS) {
+				lport->dns_rp = rport;
+				fc_lport_enter_rpn_id(lport);
+			} else {
+				FC_DEBUG_LPORT("Received an CREATED event on "
+					       "port (%6x) for the directory "
+					       "server, but the lport is not "
+					       "in the DNS state, it's in the "
+					       "%d state", rport->port_id,
+					       lport->state);
+				lport->tt.rport_logoff(rport);
+			}
+			mutex_unlock(&lport->lp_mutex);
+		} else
+			FC_DEBUG_LPORT("Received an event for port (%6x) "
+				       "which is not the directory server\n",
+				       rport->port_id);
+		break;
+	case RPORT_EV_LOGO:
+	case RPORT_EV_FAILED:
+	case RPORT_EV_STOP:
+		if (rport->port_id == FC_FID_DIR_SERV) {
+			mutex_lock(&lport->lp_mutex);
+			lport->dns_rp = NULL;
+			mutex_unlock(&lport->lp_mutex);
+
+		} else
+			FC_DEBUG_LPORT("Received an event for port (%6x) "
+				       "which is not the directory server\n",
+				       rport->port_id);
+		break;
+	case RPORT_EV_NONE:
+		break;
+	}
+}
+
+/**
+ * fc_lport_state - Return a string which represents the lport's state
+ * @lport: The lport whose state is to converted to a string
+ */
+static const char *fc_lport_state(struct fc_lport *lport)
+{
+	const char *cp;
+
+	cp = fc_lport_state_names[lport->state];
+	if (!cp)
+		cp = "unknown";
+	return cp;
+}
+
+/**
+ * fc_lport_ptp_setup - Create an rport for point-to-point mode
+ * @lport: The lport to attach the ptp rport to
+ * @fid: The FID of the ptp rport
+ * @remote_wwpn: The WWPN of the ptp rport
+ * @remote_wwnn: The WWNN of the ptp rport
+ */
+static void fc_lport_ptp_setup(struct fc_lport *lport,
+			       u32 remote_fid, u64 remote_wwpn,
+			       u64 remote_wwnn)
+{
+	struct fc_disc_port dp;
+
+	dp.lp = lport;
+	dp.ids.port_id = remote_fid;
+	dp.ids.port_name = remote_wwpn;
+	dp.ids.node_name = remote_wwnn;
+	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
+	if (lport->ptp_rp) {
+		lport->tt.rport_logoff(lport->ptp_rp);
+		lport->ptp_rp = NULL;
+	}
+
+	lport->ptp_rp = fc_rport_rogue_create(&dp);
+
+	lport->tt.rport_login(lport->ptp_rp);
+
+	fc_lport_enter_ready(lport);
+}
+
+void fc_get_host_port_type(struct Scsi_Host *shost)
+{
+	/* TODO - currently just NPORT */
+	fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+}
+EXPORT_SYMBOL(fc_get_host_port_type);
+
+void fc_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct fc_lport *lp = shost_priv(shost);
+
+	if ((lp->link_status & FC_LINK_UP) == FC_LINK_UP)
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+}
+EXPORT_SYMBOL(fc_get_host_port_state);
+
+void fc_get_host_speed(struct Scsi_Host *shost)
+{
+	struct fc_lport *lport = shost_priv(shost);
+
+	fc_host_speed(shost) = lport->link_speed;
+}
+EXPORT_SYMBOL(fc_get_host_speed);
+
+struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
+{
+	int i;
+	struct fc_host_statistics *fcoe_stats;
+	struct fc_lport *lp = shost_priv(shost);
+	struct timespec v0, v1;
+
+	fcoe_stats = &lp->host_stats;
+	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
+
+	jiffies_to_timespec(jiffies, &v0);
+	jiffies_to_timespec(lp->boot_time, &v1);
+	fcoe_stats->seconds_since_last_reset = (v0.tv_sec - v1.tv_sec);
+
+	for_each_online_cpu(i) {
+		struct fcoe_dev_stats *stats = lp->dev_stats[i];
+		if (stats == NULL)
+			continue;
+		fcoe_stats->tx_frames += stats->TxFrames;
+		fcoe_stats->tx_words += stats->TxWords;
+		fcoe_stats->rx_frames += stats->RxFrames;
+		fcoe_stats->rx_words += stats->RxWords;
+		fcoe_stats->error_frames += stats->ErrorFrames;
+		fcoe_stats->invalid_crc_count += stats->InvalidCRCCount;
+		fcoe_stats->fcp_input_requests += stats->InputRequests;
+		fcoe_stats->fcp_output_requests += stats->OutputRequests;
+		fcoe_stats->fcp_control_requests += stats->ControlRequests;
+		fcoe_stats->fcp_input_megabytes += stats->InputMegabytes;
+		fcoe_stats->fcp_output_megabytes += stats->OutputMegabytes;
+		fcoe_stats->link_failure_count += stats->LinkFailureCount;
+	}
+	fcoe_stats->lip_count = -1;
+	fcoe_stats->nos_count = -1;
+	fcoe_stats->loss_of_sync_count = -1;
+	fcoe_stats->loss_of_signal_count = -1;
+	fcoe_stats->prim_seq_protocol_err_count = -1;
+	fcoe_stats->dumped_frames = -1;
+	return fcoe_stats;
+}
+EXPORT_SYMBOL(fc_get_host_stats);
+
+/*
+ * Fill in FLOGI command for request.
+ */
+static void
+fc_lport_flogi_fill(struct fc_lport *lport, struct fc_els_flogi *flogi,
+		    unsigned int op)
+{
+	struct fc_els_csp *sp;
+	struct fc_els_cssp *cp;
+
+	memset(flogi, 0, sizeof(*flogi));
+	flogi->fl_cmd = (u8) op;
+	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
+	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	sp = &flogi->fl_csp;
+	sp->sp_hi_ver = 0x20;
+	sp->sp_lo_ver = 0x20;
+	sp->sp_bb_cred = htons(10);	/* this gets set by gateway */
+	sp->sp_bb_data = htons((u16) lport->mfs);
+	cp = &flogi->fl_cssp[3 - 1];	/* class 3 parameters */
+	cp->cp_class = htons(FC_CPC_VALID | FC_CPC_SEQ);
+	if (op != ELS_FLOGI) {
+		sp->sp_features = htons(FC_SP_FT_CIRO);
+		sp->sp_tot_seq = htons(255);	/* seq. we accept */
+		sp->sp_rel_off = htons(0x1f);
+		sp->sp_e_d_tov = htonl(lport->e_d_tov);
+
+		cp->cp_rdfs = htons((u16) lport->mfs);
+		cp->cp_con_seq = htons(255);
+		cp->cp_open_seq = 1;
+	}
+}
+
+/*
+ * Add a supported FC-4 type.
+ */
+static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
+{
+	__be32 *mp;
+
+	mp = &lport->fcts.ff_type_map[type / FC_NS_BPW];
+	*mp = htonl(ntohl(*mp) | 1UL << (type % FC_NS_BPW));
+}
+
+/**
+ * fc_lport_recv_rlir_req - Handle received Registered Link Incident Report.
+ * @lport: Fibre Channel local port recieving the RLIR
+ * @sp: current sequence in the RLIR exchange
+ * @fp: RLIR request frame
+ *
+ * Locking Note: The lport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
+				   struct fc_lport *lport)
+{
+	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
+		       fc_lport_state(lport));
+
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_lport_recv_echo_req - Handle received ECHO request
+ * @lport: Fibre Channel local port recieving the ECHO
+ * @sp: current sequence in the ECHO exchange
+ * @fp: ECHO request frame
+ *
+ * Locking Note: The lport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
+				   struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+	struct fc_exch *ep = fc_seq_exch(sp);
+	unsigned int len;
+	void *pp;
+	void *dp;
+	u32 f_ctl;
+
+	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
+		       fc_lport_state(lport));
+
+	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
+	pp = fc_frame_payload_get(in_fp, len);
+
+	if (len < sizeof(__be32))
+		len = sizeof(__be32);
+
+	fp = fc_frame_alloc(lport, len);
+	if (fp) {
+		dp = fc_frame_payload_get(fp, len);
+		memcpy(dp, pp, len);
+		*((u32 *)dp) = htonl(ELS_LS_ACC << 24);
+		sp = lport->tt.seq_start_next(sp);
+		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
+		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+			       FC_TYPE_ELS, f_ctl, 0);
+		lport->tt.seq_send(lport, sp, fp);
+	}
+	fc_frame_free(in_fp);
+}
+
+/**
+ * fc_lport_recv_echo_req - Handle received Request Node ID data request
+ * @lport: Fibre Channel local port recieving the RNID
+ * @sp: current sequence in the RNID exchange
+ * @fp: RNID request frame
+ *
+ * Locking Note: The lport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
+				   struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+	struct fc_exch *ep = fc_seq_exch(sp);
+	struct fc_els_rnid *req;
+	struct {
+		struct fc_els_rnid_resp rnid;
+		struct fc_els_rnid_cid cid;
+		struct fc_els_rnid_gen gen;
+	} *rp;
+	struct fc_seq_els_data rjt_data;
+	u8 fmt;
+	size_t len;
+	u32 f_ctl;
+
+	FC_DEBUG_LPORT("Received RNID request while in state %s\n",
+		       fc_lport_state(lport));
+
+	req = fc_frame_payload_get(in_fp, sizeof(*req));
+	if (!req) {
+		rjt_data.fp = NULL;
+		rjt_data.reason = ELS_RJT_LOGIC;
+		rjt_data.explan = ELS_EXPL_NONE;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	} else {
+		fmt = req->rnid_fmt;
+		len = sizeof(*rp);
+		if (fmt != ELS_RNIDF_GEN ||
+		    ntohl(lport->rnid_gen.rnid_atype) == 0) {
+			fmt = ELS_RNIDF_NONE;	/* nothing to provide */
+			len -= sizeof(rp->gen);
+		}
+		fp = fc_frame_alloc(lport, len);
+		if (fp) {
+			rp = fc_frame_payload_get(fp, len);
+			memset(rp, 0, len);
+			rp->rnid.rnid_cmd = ELS_LS_ACC;
+			rp->rnid.rnid_fmt = fmt;
+			rp->rnid.rnid_cid_len = sizeof(rp->cid);
+			rp->cid.rnid_wwpn = htonll(lport->wwpn);
+			rp->cid.rnid_wwnn = htonll(lport->wwnn);
+			if (fmt == ELS_RNIDF_GEN) {
+				rp->rnid.rnid_sid_len = sizeof(rp->gen);
+				memcpy(&rp->gen, &lport->rnid_gen,
+				       sizeof(rp->gen));
+			}
+			sp = lport->tt.seq_start_next(sp);
+			f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
+			f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+			fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+				       FC_TYPE_ELS, f_ctl, 0);
+			lport->tt.seq_send(lport, sp, fp);
+		}
+	}
+	fc_frame_free(in_fp);
+}
+
+/**
+ * fc_lport_recv_logo_req - Handle received fabric LOGO request
+ * @lport: Fibre Channel local port recieving the LOGO
+ * @sp: current sequence in the LOGO exchange
+ * @fp: LOGO request frame
+ *
+ * Locking Note: The lport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_lport_recv_logo_req(struct fc_seq *sp, struct fc_frame *fp,
+				   struct fc_lport *lport)
+{
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	fc_lport_enter_reset(lport);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_fabric_login - Start the lport state machine
+ * @lport: The lport that should log into the fabric
+ *
+ * Locking Note: This function should not be called
+ *		 with the lport lock held.
+ */
+int fc_fabric_login(struct fc_lport *lport)
+{
+	int rc = -1;
+
+	mutex_lock(&lport->lp_mutex);
+	if (lport->state == LPORT_ST_NONE) {
+		fc_lport_enter_reset(lport);
+		rc = 0;
+	}
+	mutex_unlock(&lport->lp_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL(fc_fabric_login);
+
+/**
+ * fc_linkup - Handler for transport linkup events
+ * @lport: The lport whose link is up
+ */
+void fc_linkup(struct fc_lport *lport)
+{
+	FC_DEBUG_LPORT("Link is up for port (%6x)\n",
+		       fc_host_port_id(lport->host));
+
+	mutex_lock(&lport->lp_mutex);
+	if ((lport->link_status & FC_LINK_UP) != FC_LINK_UP) {
+		lport->link_status |= FC_LINK_UP;
+
+		if (lport->state == LPORT_ST_RESET)
+			fc_lport_enter_flogi(lport);
+	}
+	mutex_unlock(&lport->lp_mutex);
+}
+EXPORT_SYMBOL(fc_linkup);
+
+/**
+ * fc_linkdown - Handler for transport linkdown events
+ * @lport: The lport whose link is down
+ */
+void fc_linkdown(struct fc_lport *lport)
+{
+	mutex_lock(&lport->lp_mutex);
+	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
+		       fc_host_port_id(lport->host));
+
+	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP) {
+		lport->link_status &= ~(FC_LINK_UP);
+		fc_lport_enter_reset(lport);
+		lport->tt.fcp_cleanup(lport);
+	}
+	mutex_unlock(&lport->lp_mutex);
+}
+EXPORT_SYMBOL(fc_linkdown);
+
+/**
+ * fc_pause - Pause the flow of frames
+ * @lport: The lport to be paused
+ */
+void fc_pause(struct fc_lport *lport)
+{
+	mutex_lock(&lport->lp_mutex);
+	lport->link_status |= FC_PAUSE;
+	mutex_unlock(&lport->lp_mutex);
+}
+EXPORT_SYMBOL(fc_pause);
+
+/**
+ * fc_unpause - Unpause the flow of frames
+ * @lport: The lport to be unpaused
+ */
+void fc_unpause(struct fc_lport *lport)
+{
+	mutex_lock(&lport->lp_mutex);
+	lport->link_status &= ~(FC_PAUSE);
+	mutex_unlock(&lport->lp_mutex);
+}
+EXPORT_SYMBOL(fc_unpause);
+
+/**
+ * fc_fabric_logoff - Logout of the fabric
+ * @lport:	      fc_lport pointer to logoff the fabric
+ *
+ * Return value:
+ *	0 for success, -1 for failure
+ **/
+int fc_fabric_logoff(struct fc_lport *lport)
+{
+	lport->tt.disc_stop_final(lport);
+	mutex_lock(&lport->lp_mutex);
+	fc_lport_enter_logo(lport);
+	mutex_unlock(&lport->lp_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(fc_fabric_logoff);
+
+/**
+ * fc_lport_destroy - unregister a fc_lport
+ * @lport:	      fc_lport pointer to unregister
+ *
+ * Return value:
+ *	None
+ * Note:
+ * exit routine for fc_lport instance
+ * clean-up all the allocated memory
+ * and free up other system resources.
+ *
+ **/
+int fc_lport_destroy(struct fc_lport *lport)
+{
+	lport->tt.frame_send = fc_frame_drop;
+	lport->tt.fcp_abort_io(lport);
+	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	return 0;
+}
+EXPORT_SYMBOL(fc_lport_destroy);
+
+int fc_set_mfs(struct fc_lport *lport, u32 mfs)
+{
+	unsigned int old_mfs;
+	int rc = -1;
+
+	mutex_lock(&lport->lp_mutex);
+
+	old_mfs = lport->mfs;
+
+	if (mfs >= FC_MIN_MAX_FRAME) {
+		mfs &= ~3;
+		WARN_ON((size_t) mfs < FC_MIN_MAX_FRAME);
+		if (mfs > FC_MAX_FRAME)
+			mfs = FC_MAX_FRAME;
+		mfs -= sizeof(struct fc_frame_header);
+		lport->mfs = mfs;
+		rc = 0;
+	}
+
+	if (!rc && mfs < old_mfs)
+		fc_lport_enter_reset(lport);
+
+	mutex_unlock(&lport->lp_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL(fc_set_mfs);
+
+/**
+ * fc_lport_disc_callback - Callback for discovery events
+ * @lport: FC local port
+ * @event: The discovery event
+ */
+void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
+{
+	switch (event) {
+	case DISC_EV_SUCCESS:
+		FC_DEBUG_LPORT("Got a SUCCESS event for port (%6x)\n",
+			       fc_host_port_id(lport->host));
+		break;
+	case DISC_EV_FAILED:
+		FC_DEBUG_LPORT("Got a FAILED event for port (%6x)\n",
+			       fc_host_port_id(lport->host));
+		mutex_lock(&lport->lp_mutex);
+		fc_lport_enter_reset(lport);
+		mutex_unlock(&lport->lp_mutex);
+		break;
+	case DISC_EV_NONE:
+		WARN_ON(1);
+		break;
+	}
+}
+
+/**
+ * fc_rport_enter_ready - Enter the ready state and start discovery
+ * @lport: Fibre Channel local port that is ready
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_ready(struct fc_lport *lport)
+{
+	FC_DEBUG_LPORT("Port (%6x) entered Ready from state %s\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_READY);
+
+	lport->tt.disc_start(fc_lport_disc_callback, lport);
+}
+
+/**
+ * fc_lport_recv_flogi_req - Receive a FLOGI request
+ * @sp_in: The sequence the FLOGI is on
+ * @rx_fp: The frame the FLOGI is in
+ * @lport: The lport that recieved the request
+ *
+ * A received FLOGI request indicates a point-to-point connection.
+ * Accept it with the common service parameters indicating our N port.
+ * Set up to do a PLOGI if we have the higher-number WWPN.
+ *
+ * Locking Note: The lport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
+				    struct fc_frame *rx_fp,
+				    struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+	struct fc_frame_header *fh;
+	struct fc_seq *sp;
+	struct fc_exch *ep;
+	struct fc_els_flogi *flp;
+	struct fc_els_flogi *new_flp;
+	u64 remote_wwpn;
+	u32 remote_fid;
+	u32 local_fid;
+	u32 f_ctl;
+
+	FC_DEBUG_LPORT("Received FLOGI request while in state %s\n",
+		       fc_lport_state(lport));
+
+	fh = fc_frame_header_get(rx_fp);
+	remote_fid = ntoh24(fh->fh_s_id);
+	flp = fc_frame_payload_get(rx_fp, sizeof(*flp));
+	if (!flp)
+		goto out;
+	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
+	if (remote_wwpn == lport->wwpn) {
+		FC_DBG("FLOGI from port with same WWPN %llx "
+		       "possible configuration error\n", remote_wwpn);
+		goto out;
+	}
+	FC_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
+
+	/*
+	 * XXX what is the right thing to do for FIDs?
+	 * The originator might expect our S_ID to be 0xfffffe.
+	 * But if so, both of us could end up with the same FID.
+	 */
+	local_fid = FC_LOCAL_PTP_FID_LO;
+	if (remote_wwpn < lport->wwpn) {
+		local_fid = FC_LOCAL_PTP_FID_HI;
+		if (!remote_fid || remote_fid == local_fid)
+			remote_fid = FC_LOCAL_PTP_FID_LO;
+	} else if (!remote_fid) {
+		remote_fid = FC_LOCAL_PTP_FID_HI;
+	}
+
+	fc_host_port_id(lport->host) = local_fid;
+
+	fp = fc_frame_alloc(lport, sizeof(*flp));
+	if (fp) {
+		sp = lport->tt.seq_start_next(fr_seq(rx_fp));
+		new_flp = fc_frame_payload_get(fp, sizeof(*flp));
+		fc_lport_flogi_fill(lport, new_flp, ELS_FLOGI);
+		new_flp->fl_cmd = (u8) ELS_LS_ACC;
+
+		/*
+		 * Send the response.  If this fails, the originator should
+		 * repeat the sequence.
+		 */
+		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
+		ep = fc_seq_exch(sp);
+		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+			       FC_TYPE_ELS, f_ctl, 0);
+		lport->tt.seq_send(lport, sp, fp);
+
+	} else {
+		fc_lport_error(lport, fp);
+	}
+	fc_lport_ptp_setup(lport, remote_fid, remote_wwpn,
+			   get_unaligned_be64(&flp->fl_wwnn));
+
+	lport->tt.disc_start(fc_lport_disc_callback, lport);
+
+out:
+	sp = fr_seq(rx_fp);
+	fc_frame_free(rx_fp);
+}
+
+/**
+ * fc_lport_recv_req - The generic lport request handler
+ * @lport: The lport that received the request
+ * @sp: The sequence the request is on
+ * @fp: The frame the request is in
+ *
+ * This function will see if the lport handles the request or
+ * if an rport should handle the request.
+ *
+ * Locking Note: This function should not be called with the lport
+ *		 lock held becuase it will grab the lock.
+ */
+static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
+			      struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	void (*recv) (struct fc_seq *, struct fc_frame *, struct fc_lport *);
+	struct fc_rport *rport;
+	u32 s_id;
+	u32 d_id;
+	struct fc_seq_els_data rjt_data;
+
+	mutex_lock(&lport->lp_mutex);
+
+	/*
+	 * Handle special ELS cases like FLOGI, LOGO, and
+	 * RSCN here.  These don't require a session.
+	 * Even if we had a session, it might not be ready.
+	 */
+	if (fh->fh_type == FC_TYPE_ELS && fh->fh_r_ctl == FC_RCTL_ELS_REQ) {
+		/*
+		 * Check opcode.
+		 */
+		recv = NULL;
+		switch (fc_frame_payload_op(fp)) {
+		case ELS_FLOGI:
+			recv = fc_lport_recv_flogi_req;
+			break;
+		case ELS_LOGO:
+			fh = fc_frame_header_get(fp);
+			if (ntoh24(fh->fh_s_id) == FC_FID_FLOGI)
+				recv = fc_lport_recv_logo_req;
+			break;
+		case ELS_RSCN:
+			recv = lport->tt.disc_recv_req;
+			break;
+		case ELS_ECHO:
+			recv = fc_lport_recv_echo_req;
+			break;
+		case ELS_RLIR:
+			recv = fc_lport_recv_rlir_req;
+			break;
+		case ELS_RNID:
+			recv = fc_lport_recv_rnid_req;
+			break;
+		}
+
+		if (recv)
+			recv(sp, fp, lport);
+		else {
+			/*
+			 * Find session.
+			 * If this is a new incoming PLOGI, we won't find it.
+			 */
+			s_id = ntoh24(fh->fh_s_id);
+			d_id = ntoh24(fh->fh_d_id);
+
+			rport = lport->tt.rport_lookup(lport, s_id);
+			if (rport) {
+				lport->tt.rport_recv_req(sp, fp, rport);
+				put_device(&rport->dev); /* hold from lookup */
+			} else {
+				rjt_data.fp = NULL;
+				rjt_data.reason = ELS_RJT_UNAB;
+				rjt_data.explan = ELS_EXPL_NONE;
+				lport->tt.seq_els_rsp_send(sp,
+							   ELS_LS_RJT,
+							   &rjt_data);
+				fc_frame_free(fp);
+			}
+		}
+	} else {
+		FC_DBG("dropping invalid frame (eof %x)\n", fr_eof(fp));
+		fc_frame_free(fp);
+	}
+	mutex_unlock(&lport->lp_mutex);
+
+	/*
+	 *  The common exch_done for all request may not be good
+	 *  if any request requires longer hold on exhange. XXX
+	 */
+	lport->tt.exch_done(sp);
+}
+
+/**
+ * fc_lport_reset - Reset an lport
+ * @lport: The lport which should be reset
+ *
+ * Locking Note: This functions should not be called with the
+ *		 lport lock held.
+ */
+int fc_lport_reset(struct fc_lport *lport)
+{
+	mutex_lock(&lport->lp_mutex);
+	fc_lport_enter_reset(lport);
+	mutex_unlock(&lport->lp_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(fc_lport_reset);
+
+/**
+ * fc_rport_enter_reset - Reset the local port
+ * @lport: Fibre Channel local port to be reset
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_reset(struct fc_lport *lport)
+{
+	FC_DEBUG_LPORT("Port (%6x) entered RESET state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_RESET);
+
+	if (lport->dns_rp)
+		lport->tt.rport_logoff(lport->dns_rp);
+
+	if (lport->ptp_rp) {
+		lport->tt.rport_logoff(lport->ptp_rp);
+		lport->ptp_rp = NULL;
+	}
+
+	lport->tt.disc_stop(lport);
+
+	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	fc_host_fabric_name(lport->host) = 0;
+	fc_host_port_id(lport->host) = 0;
+
+	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP)
+		fc_lport_enter_flogi(lport);
+}
+
+/**
+ * fc_lport_error - Handler for any errors
+ * @lport: The fc_lport object
+ * @fp: The frame pointer
+ *
+ * If the error was caused by a resource allocation failure
+ * then wait for half a second and retry, otherwise retry
+ * after the e_d_tov time.
+ */
+static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
+{
+	unsigned long delay = 0;
+	FC_DEBUG_LPORT("Error %ld in state %s, retries %d\n",
+		       PTR_ERR(fp), fc_lport_state(lport),
+		       lport->retry_count);
+
+	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
+		/*
+		 * Memory allocation failure, or the exchange timed out.
+		 *  Retry after delay
+		 */
+		if (lport->retry_count < lport->max_retry_count) {
+			lport->retry_count++;
+			if (!fp)
+				delay = msecs_to_jiffies(500);
+			else
+				delay =	msecs_to_jiffies(lport->e_d_tov);
+
+			schedule_delayed_work(&lport->retry_work, delay);
+		} else {
+			switch (lport->state) {
+			case LPORT_ST_NONE:
+			case LPORT_ST_READY:
+			case LPORT_ST_RESET:
+			case LPORT_ST_RPN_ID:
+			case LPORT_ST_RFT_ID:
+			case LPORT_ST_SCR:
+			case LPORT_ST_DNS:
+			case LPORT_ST_FLOGI:
+			case LPORT_ST_LOGO:
+				fc_lport_enter_reset(lport);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * fc_lport_rft_id_resp - Handle response to Register Fibre
+ *			  Channel Types by ID (RPN_ID) request
+ * @sp: current sequence in RPN_ID exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel host port instance
+ *
+ * Locking Note: This function will be called without the lport lock
+ * held, but it will lock, call an _enter_* function or fc_lport_error
+ * and then unlock the lport.
+ */
+static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
+				 void *lp_arg)
+{
+	struct fc_lport *lport = lp_arg;
+	struct fc_frame_header *fh;
+	struct fc_ct_hdr *ct;
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&lport->lp_mutex);
+
+	FC_DEBUG_LPORT("Received a RFT_ID response\n");
+
+	if (lport->state != LPORT_ST_RFT_ID) {
+		FC_DBG("Received a RFT_ID response, but in state %s\n",
+		       fc_lport_state(lport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
+	fh = fc_frame_header_get(fp);
+	ct = fc_frame_payload_get(fp, sizeof(*ct));
+
+	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
+	    ct->ct_fs_type == FC_FST_DIR &&
+	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
+	    ntohs(ct->ct_cmd) == FC_FS_ACC)
+		fc_lport_enter_scr(lport);
+	else
+		fc_lport_error(lport, fp);
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_lport_rpn_id_resp - Handle response to Register Port
+ *			  Name by ID (RPN_ID) request
+ * @sp: current sequence in RPN_ID exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel host port instance
+ *
+ * Locking Note: This function will be called without the lport lock
+ * held, but it will lock, call an _enter_* function or fc_lport_error
+ * and then unlock the lport.
+ */
+static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
+				 void *lp_arg)
+{
+	struct fc_lport *lport = lp_arg;
+	struct fc_frame_header *fh;
+	struct fc_ct_hdr *ct;
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&lport->lp_mutex);
+
+	FC_DEBUG_LPORT("Received a RPN_ID response\n");
+
+	if (lport->state != LPORT_ST_RPN_ID) {
+		FC_DBG("Received a RPN_ID response, but in state %s\n",
+		       fc_lport_state(lport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
+	fh = fc_frame_header_get(fp);
+	ct = fc_frame_payload_get(fp, sizeof(*ct));
+	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
+	    ct->ct_fs_type == FC_FST_DIR &&
+	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
+	    ntohs(ct->ct_cmd) == FC_FS_ACC)
+		fc_lport_enter_rft_id(lport);
+	else
+		fc_lport_error(lport, fp);
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_lport_scr_resp - Handle response to State Change Register (SCR) request
+ * @sp: current sequence in SCR exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel lport port instance that sent the registration request
+ *
+ * Locking Note: This function will be called without the lport lock
+ * held, but it will lock, call an _enter_* function or fc_lport_error
+ * and then unlock the lport.
+ */
+static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
+			      void *lp_arg)
+{
+	struct fc_lport *lport = lp_arg;
+	u8 op;
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&lport->lp_mutex);
+
+	FC_DEBUG_LPORT("Received a SCR response\n");
+
+	if (lport->state != LPORT_ST_SCR) {
+		FC_DBG("Received a SCR response, but in state %s\n",
+		       fc_lport_state(lport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC)
+		fc_lport_enter_ready(lport);
+	else
+		fc_lport_error(lport, fp);
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_lport_enter_scr - Send a State Change Register (SCR) request
+ * @lport: Fibre Channel local port to register for state changes
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_scr(struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+
+	FC_DEBUG_LPORT("Port (%6x) entered SCR state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_SCR);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_scr));
+	if (!fp) {
+		fc_lport_error(lport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_SCR,
+				  fc_lport_scr_resp, lport, lport->e_d_tov))
+		fc_lport_error(lport, fp);
+}
+
+/**
+ * fc_lport_enter_rft_id - Register FC4-types with the name server
+ * @lport: Fibre Channel local port to register
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_rft_id(struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+	struct fc_ns_fts *lps;
+	int i;
+
+	FC_DEBUG_LPORT("Port (%6x) entered RFT_ID state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
+
+	lps = &lport->fcts;
+	i = sizeof(lps->ff_type_map) / sizeof(lps->ff_type_map[0]);
+	while (--i >= 0)
+		if (ntohl(lps->ff_type_map[i]) != 0)
+			break;
+	if (i < 0) {
+		/* nothing to register, move on to SCR */
+		fc_lport_enter_scr(lport);
+		return;
+	}
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_ct_hdr) +
+			    sizeof(struct fc_ns_rft));
+	if (!fp) {
+		fc_lport_error(lport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, NULL, fp, FC_NS_RFT_ID,
+				  fc_lport_rft_id_resp,
+				  lport, lport->e_d_tov))
+		fc_lport_error(lport, fp);
+}
+
+/**
+ * fc_rport_enter_rft_id - Register port name with the name server
+ * @lport: Fibre Channel local port to register
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_rpn_id(struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+
+	FC_DEBUG_LPORT("Port (%6x) entered RPN_ID state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_RPN_ID);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_ct_hdr) +
+			    sizeof(struct fc_ns_rn_id));
+	if (!fp) {
+		fc_lport_error(lport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, NULL, fp, FC_NS_RPN_ID,
+				  fc_lport_rpn_id_resp,
+				  lport, lport->e_d_tov))
+		fc_lport_error(lport, fp);
+}
+
+/**
+ * fc_rport_enter_dns - Create a rport to the name server
+ * @lport: Fibre Channel local port requesting a rport for the name server
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_dns(struct fc_lport *lport)
+{
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata;
+	struct fc_disc_port dp;
+
+	dp.ids.port_id = FC_FID_DIR_SERV;
+	dp.ids.port_name = -1;
+	dp.ids.node_name = -1;
+	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
+	dp.lp = lport;
+
+	FC_DEBUG_LPORT("Port (%6x) entered DNS state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_DNS);
+
+	rport = fc_rport_rogue_create(&dp);
+	if (!rport)
+		goto err;
+
+	rdata = rport->dd_data;
+	rdata->event_callback = fc_lport_rport_event;
+	lport->tt.rport_login(rport);
+	return;
+
+err:
+	fc_lport_error(lport, NULL);
+}
+
+/**
+ * fc_lport_timeout - Handler for the retry_work timer.
+ * @work: The work struct of the fc_lport
+ */
+static void fc_lport_timeout(struct work_struct *work)
+{
+	struct fc_lport *lport =
+		container_of(work, struct fc_lport,
+			     retry_work.work);
+
+	mutex_lock(&lport->lp_mutex);
+
+	switch (lport->state) {
+	case LPORT_ST_NONE:
+	case LPORT_ST_READY:
+	case LPORT_ST_RESET:
+		WARN_ON(1);
+		break;
+	case LPORT_ST_FLOGI:
+		fc_lport_enter_flogi(lport);
+		break;
+	case LPORT_ST_DNS:
+		fc_lport_enter_dns(lport);
+		break;
+	case LPORT_ST_RPN_ID:
+		fc_lport_enter_rpn_id(lport);
+		break;
+	case LPORT_ST_RFT_ID:
+		fc_lport_enter_rft_id(lport);
+		break;
+	case LPORT_ST_SCR:
+		fc_lport_enter_scr(lport);
+		break;
+	case LPORT_ST_LOGO:
+		fc_lport_enter_logo(lport);
+		break;
+	}
+
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_lport_logo_resp - Handle response to LOGO request
+ * @sp: current sequence in LOGO exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel lport port instance that sent the LOGO request
+ *
+ * Locking Note: This function will be called without the lport lock
+ * held, but it will lock, call an _enter_* function or fc_lport_error
+ * and then unlock the lport.
+ */
+static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
+			       void *lp_arg)
+{
+	struct fc_lport *lport = lp_arg;
+	u8 op;
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&lport->lp_mutex);
+
+	FC_DEBUG_LPORT("Received a LOGO response\n");
+
+	if (lport->state != LPORT_ST_LOGO) {
+		FC_DBG("Received a LOGO response, but in state %s\n",
+		       fc_lport_state(lport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC)
+		fc_lport_enter_reset(lport);
+	else
+		fc_lport_error(lport, fp);
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_rport_enter_logo - Logout of the fabric
+ * @lport: Fibre Channel local port to be logged out
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_logo(struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+	struct fc_els_logo *logo;
+
+	FC_DEBUG_LPORT("Port (%6x) entered LOGO state from %s state\n",
+		       fc_host_port_id(lport->host), fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_LOGO);
+
+	/* DNS session should be closed so we can release it here */
+	if (lport->dns_rp)
+		lport->tt.rport_logoff(lport->dns_rp);
+
+	fp = fc_frame_alloc(lport, sizeof(*logo));
+	if (!fp) {
+		fc_lport_error(lport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_LOGO, fc_lport_logo_resp,
+				  lport, lport->e_d_tov))
+		fc_lport_error(lport, fp);
+}
+
+/**
+ * fc_lport_flogi_resp - Handle response to FLOGI request
+ * @sp: current sequence in FLOGI exchange
+ * @fp: response frame
+ * @lp_arg: Fibre Channel lport port instance that sent the FLOGI request
+ *
+ * Locking Note: This function will be called without the lport lock
+ * held, but it will lock, call an _enter_* function or fc_lport_error
+ * and then unlock the lport.
+ */
+static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
+				void *lp_arg)
+{
+	struct fc_lport *lport = lp_arg;
+	struct fc_frame_header *fh;
+	struct fc_els_flogi *flp;
+	u32 did;
+	u16 csp_flags;
+	unsigned int r_a_tov;
+	unsigned int e_d_tov;
+	u16 mfs;
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&lport->lp_mutex);
+
+	FC_DEBUG_LPORT("Received a FLOGI response\n");
+
+	if (lport->state != LPORT_ST_FLOGI) {
+		FC_DBG("Received a FLOGI response, but in state %s\n",
+		       fc_lport_state(lport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
+	fh = fc_frame_header_get(fp);
+	did = ntoh24(fh->fh_d_id);
+	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
+
+		FC_DEBUG_LPORT("Assigned fid %x\n", did);
+		fc_host_port_id(lport->host) = did;
+
+		flp = fc_frame_payload_get(fp, sizeof(*flp));
+		if (flp) {
+			mfs = ntohs(flp->fl_csp.sp_bb_data) &
+				FC_SP_BB_DATA_MASK;
+			if (mfs >= FC_SP_MIN_MAX_PAYLOAD &&
+			    mfs < lport->mfs)
+				lport->mfs = mfs;
+			csp_flags = ntohs(flp->fl_csp.sp_features);
+			r_a_tov = ntohl(flp->fl_csp.sp_r_a_tov);
+			e_d_tov = ntohl(flp->fl_csp.sp_e_d_tov);
+			if (csp_flags & FC_SP_FT_EDTR)
+				e_d_tov /= 1000000;
+			if ((csp_flags & FC_SP_FT_FPORT) == 0) {
+				if (e_d_tov > lport->e_d_tov)
+					lport->e_d_tov = e_d_tov;
+				lport->r_a_tov = 2 * e_d_tov;
+				FC_DBG("Point-to-Point mode\n");
+				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
+						   get_unaligned_be64(
+							   &flp->fl_wwpn),
+						   get_unaligned_be64(
+							   &flp->fl_wwnn));
+			} else {
+				lport->e_d_tov = e_d_tov;
+				lport->r_a_tov = r_a_tov;
+				fc_host_fabric_name(lport->host) =
+					get_unaligned_be64(&flp->fl_wwnn);
+				fc_lport_enter_dns(lport);
+			}
+		}
+
+		if (flp) {
+			csp_flags = ntohs(flp->fl_csp.sp_features);
+			if ((csp_flags & FC_SP_FT_FPORT) == 0) {
+				lport->tt.disc_start(fc_lport_disc_callback,
+						     lport);
+			}
+		}
+	} else {
+		FC_DBG("bad FLOGI response\n");
+	}
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
+ * fc_rport_enter_flogi - Send a FLOGI request to the fabric manager
+ * @lport: Fibre Channel local port to be logged in to the fabric
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+void fc_lport_enter_flogi(struct fc_lport *lport)
+{
+	struct fc_frame *fp;
+
+	FC_DEBUG_LPORT("Processing FLOGI state\n");
+
+	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
+	if (!fp)
+		return fc_lport_error(lport, fp);
+
+	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_FLOGI,
+				  fc_lport_flogi_resp, lport, lport->e_d_tov))
+		fc_lport_error(lport, fp);
+}
+
+/* Configure a fc_lport */
+int fc_lport_config(struct fc_lport *lport)
+{
+	INIT_DELAYED_WORK(&lport->retry_work, fc_lport_timeout);
+	mutex_init(&lport->lp_mutex);
+
+	fc_lport_state_enter(lport, LPORT_ST_NONE);
+
+	fc_lport_add_fc4_type(lport, FC_TYPE_FCP);
+	fc_lport_add_fc4_type(lport, FC_TYPE_CT);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_lport_config);
+
+int fc_lport_init(struct fc_lport *lport)
+{
+	if (!lport->tt.lport_recv)
+		lport->tt.lport_recv = fc_lport_recv_req;
+
+	if (!lport->tt.lport_reset)
+		lport->tt.lport_reset = fc_lport_reset;
+
+	fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
+	fc_host_node_name(lport->host) = lport->wwnn;
+	fc_host_port_name(lport->host) = lport->wwpn;
+	fc_host_supported_classes(lport->host) = FC_COS_CLASS3;
+	memset(fc_host_supported_fc4s(lport->host), 0,
+	       sizeof(fc_host_supported_fc4s(lport->host)));
+	fc_host_supported_fc4s(lport->host)[2] = 1;
+	fc_host_supported_fc4s(lport->host)[7] = 1;
+
+	/* This value is also unchanging */
+	memset(fc_host_active_fc4s(lport->host), 0,
+	       sizeof(fc_host_active_fc4s(lport->host)));
+	fc_host_active_fc4s(lport->host)[2] = 1;
+	fc_host_active_fc4s(lport->host)[7] = 1;
+	fc_host_maxframe_size(lport->host) = lport->mfs;
+	fc_host_supported_speeds(lport->host) = 0;
+	if (lport->link_supported_speeds & FC_PORTSPEED_1GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_1GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_lport_init);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
new file mode 100644
index 0000000..de03a15
--- /dev/null
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -0,0 +1,1277 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+/*
+ * This file contains all processing regarding fc_rports. It contains the
+ * rport state machine and does all rport interaction with the transport class.
+ * There should be no other places in libfc that interact directly with the
+ * transport class in regards to adding and deleting rports.
+ *
+ * fc_rport's represent N_Port's within the fabric.
+ *
+ * rport locking notes:
+ *
+ * The rport should never hold the rport mutex and then lock the lport
+ * mutex. The rport's mutex is considered lesser than the lport's mutex, so
+ * the lport mutex can be held before locking the rport mutex, but not the
+ * other way around. See the comment block at the top of fc_lport.c for more
+ * details.
+ *
+ * The locking strategy is similar to the lport's strategy. The lock protects
+ * the rport's states and is held and released by the entry points to the rport
+ * block. All _enter_* functions correspond to rport states and expect the rport
+ * mutex to be locked before calling them. This means that rports only handle
+ * one request or response at a time, since they're not critical for the I/O
+ * path this potential over-use of the mutex is acceptable.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/rcupdate.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <asm/unaligned.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+static int fc_rport_debug;
+
+#define FC_DEBUG_RPORT(fmt...)			\
+	do {					\
+		if (fc_rport_debug)		\
+			FC_DBG(fmt);		\
+	} while (0)
+
+struct workqueue_struct *rport_event_queue;
+
+static void fc_rport_enter_plogi(struct fc_rport *);
+static void fc_rport_enter_prli(struct fc_rport *);
+static void fc_rport_enter_rtv(struct fc_rport *);
+static void fc_rport_enter_ready(struct fc_rport *);
+static void fc_rport_enter_logo(struct fc_rport *);
+
+static void fc_rport_recv_plogi_req(struct fc_rport *,
+				    struct fc_seq *, struct fc_frame *);
+static void fc_rport_recv_prli_req(struct fc_rport *,
+				   struct fc_seq *, struct fc_frame *);
+static void fc_rport_recv_prlo_req(struct fc_rport *,
+				   struct fc_seq *, struct fc_frame *);
+static void fc_rport_recv_logo_req(struct fc_rport *,
+				   struct fc_seq *, struct fc_frame *);
+static void fc_rport_timeout(struct work_struct *);
+static void fc_rport_error(struct fc_rport *, struct fc_frame *);
+static void fc_rport_work(struct work_struct *);
+
+static const char *fc_rport_state_names[] = {
+	[RPORT_ST_NONE] = "None",
+	[RPORT_ST_INIT] = "Init",
+	[RPORT_ST_PLOGI] = "PLOGI",
+	[RPORT_ST_PRLI] = "PRLI",
+	[RPORT_ST_RTV] = "RTV",
+	[RPORT_ST_READY] = "Ready",
+	[RPORT_ST_LOGO] = "LOGO",
+};
+
+struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
+{
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rdata;
+	rport = kzalloc(sizeof(*rport) + sizeof(*rdata), GFP_KERNEL);
+
+	if (!rport)
+		return NULL;
+
+	rdata = RPORT_TO_PRIV(rport);
+
+	rport->dd_data = rdata;
+	rport->port_id = dp->ids.port_id;
+	rport->port_name = dp->ids.port_name;
+	rport->node_name = dp->ids.node_name;
+	rport->roles = dp->ids.roles;
+	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
+	/*
+	 * init the device, so other code can manipulate the rport as if
+	 * it came from the fc class. We also do an extra get because
+	 * libfc will free this rport instead of relying on the normal
+	 * refcounting.
+	 *
+	 * Note: all this libfc rogue rport code will be removed for
+	 * upstream so it fine that this is really ugly and hacky right now.
+	 */
+	device_initialize(&rport->dev);
+	get_device(&rport->dev);
+
+	mutex_init(&rdata->rp_mutex);
+	rdata->local_port = dp->lp;
+	rdata->trans_state = FC_PORTSTATE_ROGUE;
+	rdata->rp_state = RPORT_ST_INIT;
+	rdata->event = RPORT_EV_NONE;
+	rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
+	rdata->event_callback = NULL;
+	rdata->e_d_tov = dp->lp->e_d_tov;
+	rdata->r_a_tov = dp->lp->r_a_tov;
+	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
+	INIT_WORK(&rdata->event_work, fc_rport_work);
+	/*
+	 * For good measure, but not necessary as we should only
+	 * add REAL rport to the lport list.
+	 */
+	INIT_LIST_HEAD(&rdata->peers);
+
+	return rport;
+}
+
+void fc_rport_rogue_destroy(struct fc_rport *rport)
+{
+	kfree(rport);
+}
+
+/**
+ * fc_rport_state - return a string for the state the rport is in
+ * @rport: The rport whose state we want to get a string for
+ */
+static const char *fc_rport_state(struct fc_rport *rport)
+{
+	const char *cp;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+
+	cp = fc_rport_state_names[rdata->rp_state];
+	if (!cp)
+		cp = "Unknown";
+	return cp;
+}
+
+/**
+ * fc_set_rport_loss_tmo - Set the remote port loss timeout in seconds.
+ * @rport: Pointer to Fibre Channel remote port structure
+ * @timeout: timeout in seconds
+ */
+void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
+{
+	if (timeout)
+		rport->dev_loss_tmo = timeout + 5;
+	else
+		rport->dev_loss_tmo = 30;
+}
+EXPORT_SYMBOL(fc_set_rport_loss_tmo);
+
+/**
+ * fc_plogi_get_maxframe - Get max payload from the common service parameters
+ * @flp: FLOGI payload structure
+ * @maxval: upper limit, may be less than what is in the service parameters
+ */
+static unsigned int
+fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
+{
+	unsigned int mfs;
+
+	/*
+	 * Get max payload from the common service parameters and the
+	 * class 3 receive data field size.
+	 */
+	mfs = ntohs(flp->fl_csp.sp_bb_data) & FC_SP_BB_DATA_MASK;
+	if (mfs >= FC_SP_MIN_MAX_PAYLOAD && mfs < maxval)
+		maxval = mfs;
+	mfs = ntohs(flp->fl_cssp[3 - 1].cp_rdfs);
+	if (mfs >= FC_SP_MIN_MAX_PAYLOAD && mfs < maxval)
+		maxval = mfs;
+	return maxval;
+}
+
+/**
+ * fc_rport_state_enter - Change the rport's state
+ * @rport: The rport whose state should change
+ * @new: The new state of the rport
+ *
+ * Locking Note: Called with the rport lock held
+ */
+static void fc_rport_state_enter(struct fc_rport *rport,
+				 enum fc_rport_state new)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	if (rdata->rp_state != new)
+		rdata->retries = 0;
+	rdata->rp_state = new;
+}
+
+static void fc_rport_work(struct work_struct *work)
+{
+	struct fc_rport_libfc_priv *rdata =
+		container_of(work, struct fc_rport_libfc_priv, event_work);
+	enum fc_lport_event event;
+	enum fc_rport_trans_state trans_state;
+	struct fc_lport *lport = rdata->local_port;
+	void (*event_callback)(struct fc_lport *, struct fc_rport *,
+			       enum fc_lport_event);
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
+
+	mutex_lock(&rdata->rp_mutex);
+	event = rdata->event;
+	event_callback = rdata->event_callback;
+
+	if (event == RPORT_EV_CREATED) {
+		struct fc_rport *new_rport;
+		struct fc_rport_libfc_priv *new_rdata;
+		struct fc_rport_identifiers ids;
+
+		ids.port_id = rport->port_id;
+		ids.roles = rport->roles;
+		ids.port_name = rport->port_name;
+		ids.node_name = rport->node_name;
+
+		mutex_unlock(&rdata->rp_mutex);
+
+		new_rport = fc_remote_port_add(lport->host, 0, &ids);
+		if (new_rport) {
+			/*
+			 * Switch from the rogue rport to the rport
+			 * returned by the FC class.
+			 */
+			new_rport->maxframe_size = rport->maxframe_size;
+
+			new_rdata = new_rport->dd_data;
+			new_rdata->e_d_tov = rdata->e_d_tov;
+			new_rdata->r_a_tov = rdata->r_a_tov;
+			new_rdata->event_callback = rdata->event_callback;
+			new_rdata->local_port = rdata->local_port;
+			new_rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
+			new_rdata->trans_state = FC_PORTSTATE_REAL;
+			mutex_init(&new_rdata->rp_mutex);
+			INIT_DELAYED_WORK(&new_rdata->retry_work,
+					  fc_rport_timeout);
+			INIT_LIST_HEAD(&new_rdata->peers);
+			INIT_WORK(&new_rdata->event_work, fc_rport_work);
+
+			fc_rport_state_enter(new_rport, RPORT_ST_READY);
+		} else {
+			FC_DBG("Failed to create the rport for port "
+			       "(%6x).\n", ids.port_id);
+			event = RPORT_EV_FAILED;
+		}
+		fc_rport_rogue_destroy(rport);
+		rport = new_rport;
+		rdata = new_rport->dd_data;
+		if (event_callback)
+			event_callback(lport, rport, event);
+	} else if ((event == RPORT_EV_FAILED) ||
+		   (event == RPORT_EV_LOGO) ||
+		   (event == RPORT_EV_STOP)) {
+		trans_state = rdata->trans_state;
+		mutex_unlock(&rdata->rp_mutex);
+		if (event_callback)
+			event_callback(lport, rport, event);
+		if (trans_state == FC_PORTSTATE_ROGUE)
+			fc_rport_rogue_destroy(rport);
+		else
+			fc_remote_port_delete(rport);
+	} else
+		mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_login - Start the remote port login state machine
+ * @rport: Fibre Channel remote port
+ *
+ * Locking Note: Called without the rport lock held. This
+ * function will hold the rport lock, call an _enter_*
+ * function and then unlock the rport.
+ */
+int fc_rport_login(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Login to port (%6x)\n", rport->port_id);
+
+	fc_rport_enter_plogi(rport);
+
+	mutex_unlock(&rdata->rp_mutex);
+
+	return 0;
+}
+
+/**
+ * fc_rport_logoff - Logoff and remove an rport
+ * @rport: Fibre Channel remote port to be removed
+ *
+ * Locking Note: Called without the rport lock held. This
+ * function will hold the rport lock, call an _enter_*
+ * function and then unlock the rport.
+ */
+int fc_rport_logoff(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
+
+	fc_rport_enter_logo(rport);
+
+	/*
+	 * Change the state to NONE so that we discard
+	 * the response.
+	 */
+	fc_rport_state_enter(rport, RPORT_ST_NONE);
+
+	cancel_delayed_work_sync(&rdata->retry_work);
+
+	rdata->event = RPORT_EV_STOP;
+	queue_work(rport_event_queue, &rdata->event_work);
+
+	mutex_unlock(&rdata->rp_mutex);
+
+	return 0;
+}
+
+/**
+ * fc_rport_enter_ready - The rport is ready
+ * @rport: Fibre Channel remote port that is ready
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_ready(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+
+	fc_rport_state_enter(rport, RPORT_ST_READY);
+
+	FC_DEBUG_RPORT("Port (%6x) is Ready\n", rport->port_id);
+
+	rdata->event = RPORT_EV_CREATED;
+	queue_work(rport_event_queue, &rdata->event_work);
+}
+
+/**
+ * fc_rport_timeout - Handler for the retry_work timer.
+ * @work: The work struct of the fc_rport_libfc_priv
+ *
+ * Locking Note: Called without the rport lock held. This
+ * function will hold the rport lock, call an _enter_*
+ * function and then unlock the rport.
+ */
+static void fc_rport_timeout(struct work_struct *work)
+{
+	struct fc_rport_libfc_priv *rdata =
+		container_of(work, struct fc_rport_libfc_priv, retry_work.work);
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
+
+	mutex_lock(&rdata->rp_mutex);
+
+	switch (rdata->rp_state) {
+	case RPORT_ST_PLOGI:
+		fc_rport_enter_plogi(rport);
+		break;
+	case RPORT_ST_PRLI:
+		fc_rport_enter_prli(rport);
+		break;
+	case RPORT_ST_RTV:
+		fc_rport_enter_rtv(rport);
+		break;
+	case RPORT_ST_LOGO:
+		fc_rport_enter_logo(rport);
+		break;
+	case RPORT_ST_READY:
+	case RPORT_ST_INIT:
+	case RPORT_ST_NONE:
+		break;
+	}
+	put_device(&rport->dev);
+
+	mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_error - Handler for any errors
+ * @rport: The fc_rport object
+ * @fp: The frame pointer
+ *
+ * If the error was caused by a resource allocation failure
+ * then wait for half a second and retry, otherwise retry
+ * immediately.
+ *
+ * Locking Note: The rport lock is expected to be held before
+ * calling this routine
+ */
+static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	unsigned long delay = 0;
+
+	FC_DEBUG_RPORT("Error %ld in state %s, retries %d\n",
+		       PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
+
+	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
+		/*
+		 * Memory allocation failure, or the exchange timed out.
+		 *  Retry after delay
+		 */
+		if (rdata->retries < rdata->local_port->max_retry_count) {
+			rdata->retries++;
+			if (!fp)
+				delay = msecs_to_jiffies(500);
+			get_device(&rport->dev);
+			schedule_delayed_work(&rdata->retry_work, delay);
+		} else {
+			switch (rdata->rp_state) {
+			case RPORT_ST_PLOGI:
+			case RPORT_ST_PRLI:
+			case RPORT_ST_LOGO:
+				rdata->event = RPORT_EV_FAILED;
+				queue_work(rport_event_queue,
+					   &rdata->event_work);
+				break;
+			case RPORT_ST_RTV:
+				fc_rport_enter_ready(rport);
+				break;
+			case RPORT_ST_NONE:
+			case RPORT_ST_READY:
+			case RPORT_ST_INIT:
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * fc_rport_plogi_recv_resp - Handle incoming ELS PLOGI response
+ * @sp: current sequence in the PLOGI exchange
+ * @fp: response frame
+ * @rp_arg: Fibre Channel remote port
+ *
+ * Locking Note: This function will be called without the rport lock
+ * held, but it will lock, call an _enter_* function or fc_rport_error
+ * and then unlock the rport.
+ */
+static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
+				void *rp_arg)
+{
+	struct fc_rport *rport = rp_arg;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_els_flogi *plp;
+	unsigned int tov;
+	u16 csp_seq;
+	u16 cssp_seq;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
+		       rport->port_id);
+
+	if (rdata->rp_state != RPORT_ST_PLOGI) {
+		FC_DBG("Received a PLOGI response, but in state %s\n",
+		       fc_rport_state(rport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC &&
+	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
+		rport->port_name = get_unaligned_be64(&plp->fl_wwpn);
+		rport->node_name = get_unaligned_be64(&plp->fl_wwnn);
+
+		tov = ntohl(plp->fl_csp.sp_e_d_tov);
+		if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
+			tov /= 1000;
+		if (tov > rdata->e_d_tov)
+			rdata->e_d_tov = tov;
+		csp_seq = ntohs(plp->fl_csp.sp_tot_seq);
+		cssp_seq = ntohs(plp->fl_cssp[3 - 1].cp_con_seq);
+		if (cssp_seq < csp_seq)
+			csp_seq = cssp_seq;
+		rdata->max_seq = csp_seq;
+		rport->maxframe_size =
+			fc_plogi_get_maxframe(plp, lport->mfs);
+
+		/*
+		 * If the rport is one of the well known addresses
+		 * we skip PRLI and RTV and go straight to READY.
+		 */
+		if (rport->port_id >= FC_FID_DOM_MGR)
+			fc_rport_enter_ready(rport);
+		else
+			fc_rport_enter_prli(rport);
+	} else
+		fc_rport_error(rport, fp);
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_enter_plogi - Send Port Login (PLOGI) request to peer
+ * @rport: Fibre Channel remote port to send PLOGI to
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_plogi(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+
+	FC_DEBUG_RPORT("Port (%6x) entered PLOGI state from %s state\n",
+		       rport->port_id, fc_rport_state(rport));
+
+	fc_rport_state_enter(rport, RPORT_ST_PLOGI);
+
+	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
+	if (!fp) {
+		fc_rport_error(rport, fp);
+		return;
+	}
+	rdata->e_d_tov = lport->e_d_tov;
+
+	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PLOGI,
+				  fc_rport_plogi_resp, rport, lport->e_d_tov))
+		fc_rport_error(rport, fp);
+}
+
+/**
+ * fc_rport_prli_resp - Process Login (PRLI) response handler
+ * @sp: current sequence in the PRLI exchange
+ * @fp: response frame
+ * @rp_arg: Fibre Channel remote port
+ *
+ * Locking Note: This function will be called without the rport lock
+ * held, but it will lock, call an _enter_* function or fc_rport_error
+ * and then unlock the rport.
+ */
+static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
+			       void *rp_arg)
+{
+	struct fc_rport *rport = rp_arg;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+	u32 roles = FC_RPORT_ROLE_UNKNOWN;
+	u32 fcp_parm = 0;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
+		       rport->port_id);
+
+	if (rdata->rp_state != RPORT_ST_PRLI) {
+		FC_DBG("Received a PRLI response, but in state %s\n",
+		       fc_rport_state(rport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC) {
+		pp = fc_frame_payload_get(fp, sizeof(*pp));
+		if (pp && pp->prli.prli_spp_len >= sizeof(pp->spp)) {
+			fcp_parm = ntohl(pp->spp.spp_params);
+			if (fcp_parm & FCP_SPPF_RETRY)
+				rdata->flags |= FC_RP_FLAGS_RETRY;
+		}
+
+		rport->supported_classes = FC_COS_CLASS3;
+		if (fcp_parm & FCP_SPPF_INIT_FCN)
+			roles |= FC_RPORT_ROLE_FCP_INITIATOR;
+		if (fcp_parm & FCP_SPPF_TARG_FCN)
+			roles |= FC_RPORT_ROLE_FCP_TARGET;
+
+		rport->roles = roles;
+		fc_rport_enter_rtv(rport);
+
+	} else {
+		FC_DBG("Bad ELS response\n");
+		rdata->event = RPORT_EV_FAILED;
+		queue_work(rport_event_queue, &rdata->event_work);
+	}
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_logo_resp - Logout (LOGO) response handler
+ * @sp: current sequence in the LOGO exchange
+ * @fp: response frame
+ * @rp_arg: Fibre Channel remote port
+ *
+ * Locking Note: This function will be called without the rport lock
+ * held, but it will lock, call an _enter_* function or fc_rport_error
+ * and then unlock the rport.
+ */
+static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
+			       void *rp_arg)
+{
+	struct fc_rport *rport = rp_arg;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
+		       rport->port_id);
+
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
+	if (rdata->rp_state != RPORT_ST_LOGO) {
+		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
+			       fc_rport_state(rport));
+		goto out;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC) {
+		fc_rport_enter_rtv(rport);
+	} else {
+		FC_DBG("Bad ELS response\n");
+		rdata->event = RPORT_EV_LOGO;
+		queue_work(rport_event_queue, &rdata->event_work);
+	}
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_enter_prli - Send Process Login (PRLI) request to peer
+ * @rport: Fibre Channel remote port to send PRLI to
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_prli(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+	struct fc_frame *fp;
+
+	FC_DEBUG_RPORT("Port (%6x) entered PRLI state from %s state\n",
+		       rport->port_id, fc_rport_state(rport));
+
+	fc_rport_state_enter(rport, RPORT_ST_PRLI);
+
+	fp = fc_frame_alloc(lport, sizeof(*pp));
+	if (!fp) {
+		fc_rport_error(rport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PRLI,
+				  fc_rport_prli_resp, rport, lport->e_d_tov))
+		fc_rport_error(rport, fp);
+}
+
+/**
+ * fc_rport_els_rtv_resp - Request Timeout Value response handler
+ * @sp: current sequence in the RTV exchange
+ * @fp: response frame
+ * @rp_arg: Fibre Channel remote port
+ *
+ * Many targets don't seem to support this.
+ *
+ * Locking Note: This function will be called without the rport lock
+ * held, but it will lock, call an _enter_* function or fc_rport_error
+ * and then unlock the rport.
+ */
+static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
+			      void *rp_arg)
+{
+	struct fc_rport *rport = rp_arg;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
+		       rport->port_id);
+
+	if (rdata->rp_state != RPORT_ST_RTV) {
+		FC_DBG("Received a RTV response, but in state %s\n",
+		       fc_rport_state(rport));
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC) {
+		struct fc_els_rtv_acc *rtv;
+		u32 toq;
+		u32 tov;
+
+		rtv = fc_frame_payload_get(fp, sizeof(*rtv));
+		if (rtv) {
+			toq = ntohl(rtv->rtv_toq);
+			tov = ntohl(rtv->rtv_r_a_tov);
+			if (tov == 0)
+				tov = 1;
+			rdata->r_a_tov = tov;
+			tov = ntohl(rtv->rtv_e_d_tov);
+			if (toq & FC_ELS_RTV_EDRES)
+				tov /= 1000000;
+			if (tov == 0)
+				tov = 1;
+			rdata->e_d_tov = tov;
+		}
+	}
+
+	fc_rport_enter_ready(rport);
+
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+}
+
+/**
+ * fc_rport_enter_rtv - Send Request Timeout Value (RTV) request to peer
+ * @rport: Fibre Channel remote port to send RTV to
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_rtv(struct fc_rport *rport)
+{
+	struct fc_frame *fp;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+
+	FC_DEBUG_RPORT("Port (%6x) entered RTV state from %s state\n",
+		       rport->port_id, fc_rport_state(rport));
+
+	fc_rport_state_enter(rport, RPORT_ST_RTV);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_rtv));
+	if (!fp) {
+		fc_rport_error(rport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, rport, fp, ELS_RTV,
+				     fc_rport_rtv_resp, rport, lport->e_d_tov))
+		fc_rport_error(rport, fp);
+}
+
+/**
+ * fc_rport_enter_logo - Send Logout (LOGO) request to peer
+ * @rport: Fibre Channel remote port to send LOGO to
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_logo(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+
+	FC_DEBUG_RPORT("Port (%6x) entered LOGO state from %s state\n",
+		       rport->port_id, fc_rport_state(rport));
+
+	fc_rport_state_enter(rport, RPORT_ST_LOGO);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_logo));
+	if (!fp) {
+		fc_rport_error(rport, fp);
+		return;
+	}
+
+	if (!lport->tt.elsct_send(lport, rport, fp, ELS_LOGO,
+				  fc_rport_logo_resp, rport, lport->e_d_tov))
+		fc_rport_error(rport, fp);
+}
+
+
+/**
+ * fc_rport_recv_req - Receive a request from a rport
+ * @sp: current sequence in the PLOGI exchange
+ * @fp: response frame
+ * @rp_arg: Fibre Channel remote port
+ *
+ * Locking Note: Called without the rport lock held. This
+ * function will hold the rport lock, call an _enter_*
+ * function and then unlock the rport.
+ */
+void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
+		       struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+
+	struct fc_frame_header *fh;
+	struct fc_seq_els_data els_data;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	els_data.fp = NULL;
+	els_data.explan = ELS_EXPL_NONE;
+	els_data.reason = ELS_RJT_NONE;
+
+	fh = fc_frame_header_get(fp);
+
+	if (fh->fh_r_ctl == FC_RCTL_ELS_REQ && fh->fh_type == FC_TYPE_ELS) {
+		op = fc_frame_payload_op(fp);
+		switch (op) {
+		case ELS_PLOGI:
+			fc_rport_recv_plogi_req(rport, sp, fp);
+			break;
+		case ELS_PRLI:
+			fc_rport_recv_prli_req(rport, sp, fp);
+			break;
+		case ELS_PRLO:
+			fc_rport_recv_prlo_req(rport, sp, fp);
+			break;
+		case ELS_LOGO:
+			fc_rport_recv_logo_req(rport, sp, fp);
+			break;
+		case ELS_RRQ:
+			els_data.fp = fp;
+			lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
+			break;
+		case ELS_REC:
+			els_data.fp = fp;
+			lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
+			break;
+		default:
+			els_data.reason = ELS_RJT_UNSUP;
+			lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+			break;
+		}
+	}
+
+	mutex_unlock(&rdata->rp_mutex);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_rport_recv_plogi_req - Handle incoming Port Login (PLOGI) request
+ * @rport: Fibre Channel remote port that initiated PLOGI
+ * @sp: current sequence in the PLOGI exchange
+ * @fp: PLOGI request frame
+ *
+ * Locking Note: The rport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_rport_recv_plogi_req(struct fc_rport *rport,
+				    struct fc_seq *sp, struct fc_frame *rx_fp)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp = rx_fp;
+	struct fc_exch *ep;
+	struct fc_frame_header *fh;
+	struct fc_els_flogi *pl;
+	struct fc_seq_els_data rjt_data;
+	u32 sid;
+	u64 wwpn;
+	u64 wwnn;
+	enum fc_els_rjt_reason reject = 0;
+	u32 f_ctl;
+	rjt_data.fp = NULL;
+
+	fh = fc_frame_header_get(fp);
+
+	FC_DEBUG_RPORT("Received PLOGI request from port (%6x) "
+		       "while in state %s\n", ntoh24(fh->fh_s_id),
+		       fc_rport_state(rport));
+
+	sid = ntoh24(fh->fh_s_id);
+	pl = fc_frame_payload_get(fp, sizeof(*pl));
+	if (!pl) {
+		FC_DBG("incoming PLOGI from %x too short\n", sid);
+		WARN_ON(1);
+		/* XXX TBD: send reject? */
+		fc_frame_free(fp);
+		return;
+	}
+	wwpn = get_unaligned_be64(&pl->fl_wwpn);
+	wwnn = get_unaligned_be64(&pl->fl_wwnn);
+
+	/*
+	 * If the session was just created, possibly due to the incoming PLOGI,
+	 * set the state appropriately and accept the PLOGI.
+	 *
+	 * If we had also sent a PLOGI, and if the received PLOGI is from a
+	 * higher WWPN, we accept it, otherwise an LS_RJT is sent with reason
+	 * "command already in progress".
+	 *
+	 * XXX TBD: If the session was ready before, the PLOGI should result in
+	 * all outstanding exchanges being reset.
+	 */
+	switch (rdata->rp_state) {
+	case RPORT_ST_INIT:
+		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
+			       "- reject\n", sid, wwpn);
+		reject = ELS_RJT_UNSUP;
+		break;
+	case RPORT_ST_PLOGI:
+		FC_DEBUG_RPORT("incoming PLOGI from %x in PLOGI state %d\n",
+			       sid, rdata->rp_state);
+		if (wwpn < lport->wwpn)
+			reject = ELS_RJT_INPROG;
+		break;
+	case RPORT_ST_PRLI:
+	case RPORT_ST_READY:
+		FC_DEBUG_RPORT("incoming PLOGI from %x in logged-in state %d "
+			       "- ignored for now\n", sid, rdata->rp_state);
+		/* XXX TBD - should reset */
+		break;
+	case RPORT_ST_NONE:
+	default:
+		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
+			       "state %d\n", sid, rdata->rp_state);
+		break;
+	}
+
+	if (reject) {
+		rjt_data.reason = reject;
+		rjt_data.explan = ELS_EXPL_NONE;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+		fc_frame_free(fp);
+	} else {
+		fp = fc_frame_alloc(lport, sizeof(*pl));
+		if (fp == NULL) {
+			fp = rx_fp;
+			rjt_data.reason = ELS_RJT_UNAB;
+			rjt_data.explan = ELS_EXPL_NONE;
+			lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+			fc_frame_free(fp);
+		} else {
+			sp = lport->tt.seq_start_next(sp);
+			WARN_ON(!sp);
+			fc_rport_set_name(rport, wwpn, wwnn);
+
+			/*
+			 * Get session payload size from incoming PLOGI.
+			 */
+			rport->maxframe_size =
+				fc_plogi_get_maxframe(pl, lport->mfs);
+			fc_frame_free(rx_fp);
+			fc_plogi_fill(lport, fp, ELS_LS_ACC);
+
+			/*
+			 * Send LS_ACC.	 If this fails,
+			 * the originator should retry.
+			 */
+			f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
+			f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+			ep = fc_seq_exch(sp);
+			fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+				       FC_TYPE_ELS, f_ctl, 0);
+			lport->tt.seq_send(lport, sp, fp);
+			if (rdata->rp_state == RPORT_ST_PLOGI)
+				fc_rport_enter_prli(rport);
+		}
+	}
+}
+
+/**
+ * fc_rport_recv_prli_req - Handle incoming Process Login (PRLI) request
+ * @rport: Fibre Channel remote port that initiated PRLI
+ * @sp: current sequence in the PRLI exchange
+ * @fp: PRLI request frame
+ *
+ * Locking Note: The rport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_rport_recv_prli_req(struct fc_rport *rport,
+				   struct fc_seq *sp, struct fc_frame *rx_fp)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_exch *ep;
+	struct fc_frame *fp;
+	struct fc_frame_header *fh;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+	struct fc_els_spp *rspp;	/* request service param page */
+	struct fc_els_spp *spp;	/* response spp */
+	unsigned int len;
+	unsigned int plen;
+	enum fc_els_rjt_reason reason = ELS_RJT_UNAB;
+	enum fc_els_rjt_explan explan = ELS_EXPL_NONE;
+	enum fc_els_spp_resp resp;
+	struct fc_seq_els_data rjt_data;
+	u32 f_ctl;
+	u32 fcp_parm;
+	u32 roles = FC_RPORT_ROLE_UNKNOWN;
+	rjt_data.fp = NULL;
+
+	fh = fc_frame_header_get(rx_fp);
+
+	FC_DEBUG_RPORT("Received PRLI request from port (%6x) "
+		       "while in state %s\n", ntoh24(fh->fh_s_id),
+		       fc_rport_state(rport));
+
+	switch (rdata->rp_state) {
+	case RPORT_ST_PRLI:
+	case RPORT_ST_READY:
+		reason = ELS_RJT_NONE;
+		break;
+	default:
+		break;
+	}
+	len = fr_len(rx_fp) - sizeof(*fh);
+	pp = fc_frame_payload_get(rx_fp, sizeof(*pp));
+	if (pp == NULL) {
+		reason = ELS_RJT_PROT;
+		explan = ELS_EXPL_INV_LEN;
+	} else {
+		plen = ntohs(pp->prli.prli_len);
+		if ((plen % 4) != 0 || plen > len) {
+			reason = ELS_RJT_PROT;
+			explan = ELS_EXPL_INV_LEN;
+		} else if (plen < len) {
+			len = plen;
+		}
+		plen = pp->prli.prli_spp_len;
+		if ((plen % 4) != 0 || plen < sizeof(*spp) ||
+		    plen > len || len < sizeof(*pp)) {
+			reason = ELS_RJT_PROT;
+			explan = ELS_EXPL_INV_LEN;
+		}
+		rspp = &pp->spp;
+	}
+	if (reason != ELS_RJT_NONE ||
+	    (fp = fc_frame_alloc(lport, len)) == NULL) {
+		rjt_data.reason = reason;
+		rjt_data.explan = explan;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	} else {
+		sp = lport->tt.seq_start_next(sp);
+		WARN_ON(!sp);
+		pp = fc_frame_payload_get(fp, len);
+		WARN_ON(!pp);
+		memset(pp, 0, len);
+		pp->prli.prli_cmd = ELS_LS_ACC;
+		pp->prli.prli_spp_len = plen;
+		pp->prli.prli_len = htons(len);
+		len -= sizeof(struct fc_els_prli);
+
+		/*
+		 * Go through all the service parameter pages and build
+		 * response.  If plen indicates longer SPP than standard,
+		 * use that.  The entire response has been pre-cleared above.
+		 */
+		spp = &pp->spp;
+		while (len >= plen) {
+			spp->spp_type = rspp->spp_type;
+			spp->spp_type_ext = rspp->spp_type_ext;
+			spp->spp_flags = rspp->spp_flags & FC_SPP_EST_IMG_PAIR;
+			resp = FC_SPP_RESP_ACK;
+			if (rspp->spp_flags & FC_SPP_RPA_VAL)
+				resp = FC_SPP_RESP_NO_PA;
+			switch (rspp->spp_type) {
+			case 0:	/* common to all FC-4 types */
+				break;
+			case FC_TYPE_FCP:
+				fcp_parm = ntohl(rspp->spp_params);
+				if (fcp_parm * FCP_SPPF_RETRY)
+					rdata->flags |= FC_RP_FLAGS_RETRY;
+				rport->supported_classes = FC_COS_CLASS3;
+				if (fcp_parm & FCP_SPPF_INIT_FCN)
+					roles |= FC_RPORT_ROLE_FCP_INITIATOR;
+				if (fcp_parm & FCP_SPPF_TARG_FCN)
+					roles |= FC_RPORT_ROLE_FCP_TARGET;
+				rport->roles = roles;
+
+				spp->spp_params =
+					htonl(lport->service_params);
+				break;
+			default:
+				resp = FC_SPP_RESP_INVL;
+				break;
+			}
+			spp->spp_flags |= resp;
+			len -= plen;
+			rspp = (struct fc_els_spp *)((char *)rspp + plen);
+			spp = (struct fc_els_spp *)((char *)spp + plen);
+		}
+
+		/*
+		 * Send LS_ACC.	 If this fails, the originator should retry.
+		 */
+		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
+		f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+		ep = fc_seq_exch(sp);
+		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+			       FC_TYPE_ELS, f_ctl, 0);
+		lport->tt.seq_send(lport, sp, fp);
+
+		/*
+		 * Get lock and re-check state.
+		 */
+		switch (rdata->rp_state) {
+		case RPORT_ST_PRLI:
+			fc_rport_enter_ready(rport);
+			break;
+		case RPORT_ST_READY:
+			break;
+		default:
+			break;
+		}
+	}
+	fc_frame_free(rx_fp);
+}
+
+/**
+ * fc_rport_recv_prlo_req - Handle incoming Process Logout (PRLO) request
+ * @rport: Fibre Channel remote port that initiated PRLO
+ * @sp: current sequence in the PRLO exchange
+ * @fp: PRLO request frame
+ *
+ * Locking Note: The rport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
+				   struct fc_frame *fp)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+
+	struct fc_frame_header *fh;
+	struct fc_seq_els_data rjt_data;
+
+	fh = fc_frame_header_get(fp);
+
+	FC_DEBUG_RPORT("Received PRLO request from port (%6x) "
+		       "while in state %s\n", ntoh24(fh->fh_s_id),
+		       fc_rport_state(rport));
+
+	rjt_data.fp = NULL;
+	rjt_data.reason = ELS_RJT_UNAB;
+	rjt_data.explan = ELS_EXPL_NONE;
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_rport_recv_logo_req - Handle incoming Logout (LOGO) request
+ * @rport: Fibre Channel remote port that initiated LOGO
+ * @sp: current sequence in the LOGO exchange
+ * @fp: LOGO request frame
+ *
+ * Locking Note: The rport lock is exected to be held before calling
+ * this function.
+ */
+static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
+				   struct fc_frame *fp)
+{
+	struct fc_frame_header *fh;
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+
+	fh = fc_frame_header_get(fp);
+
+	FC_DEBUG_RPORT("Received LOGO request from port (%6x) "
+		       "while in state %s\n", ntoh24(fh->fh_s_id),
+		       fc_rport_state(rport));
+
+	rdata->event = RPORT_EV_LOGO;
+	queue_work(rport_event_queue, &rdata->event_work);
+
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	fc_frame_free(fp);
+}
+
+static void fc_rport_flush_queue(void)
+{
+	flush_workqueue(rport_event_queue);
+}
+
+
+int fc_rport_init(struct fc_lport *lport)
+{
+	if (!lport->tt.rport_login)
+		lport->tt.rport_login = fc_rport_login;
+
+	if (!lport->tt.rport_logoff)
+		lport->tt.rport_logoff = fc_rport_logoff;
+
+	if (!lport->tt.rport_recv_req)
+		lport->tt.rport_recv_req = fc_rport_recv_req;
+
+	if (!lport->tt.rport_flush_queue)
+		lport->tt.rport_flush_queue = fc_rport_flush_queue;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_rport_init);
+
+int fc_setup_rport()
+{
+	rport_event_queue = create_singlethread_workqueue("fc_rport_eq");
+	if (!rport_event_queue)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(fc_setup_rport);
+
+void fc_destroy_rport()
+{
+	destroy_workqueue(rport_event_queue);
+}
+EXPORT_SYMBOL(fc_destroy_rport);
+
+void fc_rport_terminate_io(struct fc_rport *rport)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+
+	lport->tt.exch_mgr_reset(lport->emp, 0, rport->port_id);
+	lport->tt.exch_mgr_reset(lport->emp, rport->port_id, 0);
+}
+EXPORT_SYMBOL(fc_rport_terminate_io);
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
new file mode 100644
index 0000000..6300f55
--- /dev/null
+++ b/include/scsi/fc_encode.h
@@ -0,0 +1,309 @@
+/*
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _FC_ENCODE_H_
+#define _FC_ENCODE_H_
+#include <asm/unaligned.h>
+
+struct fc_ns_rft {
+	struct fc_ns_fid fid;	/* port ID object */
+	struct fc_ns_fts fts;	/* FC4-types object */
+};
+
+struct fc_ct_req {
+	struct fc_ct_hdr hdr;
+	union {
+		struct fc_ns_gid_ft gid;
+		struct fc_ns_rn_id  rn;
+		struct fc_ns_rft rft;
+	} payload;
+};
+
+/**
+ * fill FC header fields in specified fc_frame
+ */
+static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
+				  u32 did, u32 sid, enum fc_fh_type type,
+				  u32 f_ctl, u32 parm_offset)
+{
+	struct fc_frame_header *fh;
+
+	fh = fc_frame_header_get(fp);
+	WARN_ON(r_ctl == 0);
+	fh->fh_r_ctl = r_ctl;
+	hton24(fh->fh_d_id, did);
+	hton24(fh->fh_s_id, sid);
+	fh->fh_type = type;
+	hton24(fh->fh_f_ctl, f_ctl);
+	fh->fh_cs_ctl = 0;
+	fh->fh_df_ctl = 0;
+	fh->fh_parm_offset = htonl(parm_offset);
+}
+
+/**
+ * fc_ct_hdr_fill- fills ct header and reset ct payload
+ * returns pointer to ct request.
+ */
+static inline struct fc_ct_req *fc_ct_hdr_fill(const struct fc_frame *fp,
+					       unsigned int op, size_t req_size)
+{
+	struct fc_ct_req *ct;
+	size_t ct_plen;
+
+	ct_plen  = sizeof(struct fc_ct_hdr) + req_size;
+	ct = fc_frame_payload_get(fp, ct_plen);
+	memset(ct, 0, ct_plen);
+	ct->hdr.ct_rev = FC_CT_REV;
+	ct->hdr.ct_fs_type = FC_FST_DIR;
+	ct->hdr.ct_fs_subtype = FC_NS_SUBTYPE;
+	ct->hdr.ct_cmd = htons((u16) op);
+	return ct;
+}
+
+/**
+ * fc_ct_fill - Fill in a name service request frame
+ */
+static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
+		      unsigned int op, enum fc_rctl *r_ctl, u32 *did,
+		      enum fc_fh_type *fh_type)
+{
+	struct fc_ct_req *ct;
+
+	switch (op) {
+	case FC_NS_GPN_FT:
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_gid_ft));
+		ct->payload.gid.fn_fc4_type = FC_TYPE_FCP;
+		break;
+
+	case FC_NS_RFT_ID:
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rft));
+		hton24(ct->payload.rft.fid.fp_fid,
+		       fc_host_port_id(lport->host));
+		ct->payload.rft.fts = lport->fcts;
+		break;
+
+	case FC_NS_RPN_ID:
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
+		hton24(ct->payload.rn.fr_fid.fp_fid,
+		       fc_host_port_id(lport->host));
+		ct->payload.rft.fts = lport->fcts;
+		put_unaligned_be64(lport->wwpn, &ct->payload.rn.fr_wwn);
+		break;
+
+	default:
+		FC_DBG("Invalid op code %x \n", op);
+		return -EINVAL;
+	}
+	*r_ctl = FC_RCTL_DD_UNSOL_CTL;
+	*did = FC_FID_DIR_SERV;
+	*fh_type = FC_TYPE_CT;
+	return 0;
+}
+
+/**
+ * fc_plogi_fill - Fill in plogi request frame
+ */
+static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
+				 unsigned int op)
+{
+	struct fc_els_flogi *plogi;
+	struct fc_els_csp *csp;
+	struct fc_els_cssp *cp;
+
+	plogi = fc_frame_payload_get(fp, sizeof(*plogi));
+	memset(plogi, 0, sizeof(*plogi));
+	plogi->fl_cmd = (u8) op;
+	put_unaligned_be64(lport->wwpn, &plogi->fl_wwpn);
+	put_unaligned_be64(lport->wwnn, &plogi->fl_wwnn);
+
+	csp = &plogi->fl_csp;
+	csp->sp_hi_ver = 0x20;
+	csp->sp_lo_ver = 0x20;
+	csp->sp_bb_cred = htons(10);	/* this gets set by gateway */
+	csp->sp_bb_data = htons((u16) lport->mfs);
+	cp = &plogi->fl_cssp[3 - 1];	/* class 3 parameters */
+	cp->cp_class = htons(FC_CPC_VALID | FC_CPC_SEQ);
+	csp->sp_features = htons(FC_SP_FT_CIRO);
+	csp->sp_tot_seq = htons(255);	/* seq. we accept */
+	csp->sp_rel_off = htons(0x1f);
+	csp->sp_e_d_tov = htonl(lport->e_d_tov);
+
+	cp->cp_rdfs = htons((u16) lport->mfs);
+	cp->cp_con_seq = htons(255);
+	cp->cp_open_seq = 1;
+}
+
+/**
+ * fc_flogi_fill - Fill in a flogi request frame.
+ */
+static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_csp *sp;
+	struct fc_els_cssp *cp;
+	struct fc_els_flogi *flogi;
+
+	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
+	memset(flogi, 0, sizeof(*flogi));
+	flogi->fl_cmd = (u8) ELS_FLOGI;
+	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
+	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	sp = &flogi->fl_csp;
+	sp->sp_hi_ver = 0x20;
+	sp->sp_lo_ver = 0x20;
+	sp->sp_bb_cred = htons(10);	/* this gets set by gateway */
+	sp->sp_bb_data = htons((u16) lport->mfs);
+	cp = &flogi->fl_cssp[3 - 1];	/* class 3 parameters */
+	cp->cp_class = htons(FC_CPC_VALID | FC_CPC_SEQ);
+}
+
+/**
+ * fc_logo_fill - Fill in a logo request frame.
+ */
+static inline void fc_logo_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_logo *logo;
+
+	logo = fc_frame_payload_get(fp, sizeof(*logo));
+	memset(logo, 0, sizeof(*logo));
+	logo->fl_cmd = ELS_LOGO;
+	hton24(logo->fl_n_port_id, fc_host_port_id(lport->host));
+	logo->fl_n_port_wwn = htonll(lport->wwpn);
+}
+
+/**
+ * fc_rtv_fill - Fill in RTV (read timeout value) request frame.
+ */
+static inline void fc_rtv_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_rtv *rtv;
+
+	rtv = fc_frame_payload_get(fp, sizeof(*rtv));
+	memset(rtv, 0, sizeof(*rtv));
+	rtv->rtv_cmd = ELS_RTV;
+}
+
+/**
+ * fc_rec_fill - Fill in rec request frame
+ */
+static inline void fc_rec_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_rec *rec;
+	struct fc_exch *ep = fc_seq_exch(fr_seq(fp));
+
+	rec = fc_frame_payload_get(fp, sizeof(*rec));
+	memset(rec, 0, sizeof(*rec));
+	rec->rec_cmd = ELS_REC;
+	hton24(rec->rec_s_id, fc_host_port_id(lport->host));
+	rec->rec_ox_id = htons(ep->oxid);
+	rec->rec_rx_id = htons(ep->rxid);
+}
+
+/**
+ * fc_prli_fill - Fill in prli request frame
+ */
+static inline void fc_prli_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+
+	pp = fc_frame_payload_get(fp, sizeof(*pp));
+	memset(pp, 0, sizeof(*pp));
+	pp->prli.prli_cmd = ELS_PRLI;
+	pp->prli.prli_spp_len = sizeof(struct fc_els_spp);
+	pp->prli.prli_len = htons(sizeof(*pp));
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR;
+	pp->spp.spp_params = htonl(lport->service_params);
+}
+
+/**
+ * fc_scr_fill - Fill in a scr request frame.
+ */
+static inline void fc_scr_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_scr *scr;
+
+	scr = fc_frame_payload_get(fp, sizeof(*scr));
+	memset(scr, 0, sizeof(*scr));
+	scr->scr_cmd = ELS_SCR;
+	scr->scr_reg_func = ELS_SCRF_FULL;
+}
+
+/**
+ * fc_els_fill - Fill in an ELS  request frame
+ */
+static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
+		       struct fc_frame *fp, unsigned int op,
+		       enum fc_rctl *r_ctl, u32 *did, enum fc_fh_type *fh_type)
+{
+	switch (op) {
+	case ELS_PLOGI:
+		fc_plogi_fill(lport, fp, ELS_PLOGI);
+		*did = rport->port_id;
+		break;
+
+	case ELS_FLOGI:
+		fc_flogi_fill(lport, fp);
+		*did = FC_FID_FLOGI;
+		break;
+
+	case ELS_LOGO:
+		fc_logo_fill(lport, fp);
+		*did = FC_FID_FLOGI;
+		/*
+		 * if rport is valid then it
+		 * is port logo, therefore
+		 * set did to rport id.
+		 */
+		if (rport)
+			*did = rport->port_id;
+		break;
+
+	case ELS_RTV:
+		fc_rtv_fill(lport, fp);
+		*did = rport->port_id;
+		break;
+
+	case ELS_REC:
+		fc_rec_fill(lport, fp);
+		*did = rport->port_id;
+		break;
+
+	case ELS_PRLI:
+		fc_prli_fill(lport, fp);
+		*did = rport->port_id;
+		break;
+
+	case ELS_SCR:
+		fc_scr_fill(lport, fp);
+		*did = FC_FID_FCTRL;
+		break;
+
+	default:
+		FC_DBG("Invalid op code %x \n", op);
+		return -EINVAL;
+	}
+
+	*r_ctl = FC_RCTL_ELS_REQ;
+	*fh_type = FC_TYPE_ELS;
+	return 0;
+}
+#endif /* _FC_ENCODE_H_ */
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
new file mode 100644
index 0000000..dc5f734
--- /dev/null
+++ b/include/scsi/fc_frame.h
@@ -0,0 +1,239 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _FC_FRAME_H_
+#define _FC_FRAME_H_
+
+#include <linux/scatterlist.h>
+#include <linux/skbuff.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_fcp.h>
+#include <scsi/fc/fc_encaps.h>
+
+/*
+ * The fc_frame interface is used to pass frame data between functions.
+ * The frame includes the data buffer, length, and SOF / EOF delimiter types.
+ * A pointer to the port structure of the receiving port is also includeded.
+ */
+
+#define	FC_FRAME_HEADROOM	32	/* headroom for VLAN + FCoE headers */
+#define	FC_FRAME_TAILROOM	8	/* trailer space for FCoE */
+
+/*
+ * Information about an individual fibre channel frame received or to be sent.
+ * The buffer may be in up to 4 additional non-contiguous sections,
+ * but the linear section must hold the frame header.
+ */
+#define FC_FRAME_SG_LEN		4	/* scatter/gather list maximum length */
+
+#define fp_skb(fp)	(&((fp)->skb))
+#define fr_hdr(fp)	((fp)->skb.data)
+#define fr_len(fp)	((fp)->skb.len)
+#define fr_cb(fp)	((struct fcoe_rcv_info *)&((fp)->skb.cb[0]))
+#define fr_dev(fp)	(fr_cb(fp)->fr_dev)
+#define fr_seq(fp)	(fr_cb(fp)->fr_seq)
+#define fr_sof(fp)	(fr_cb(fp)->fr_sof)
+#define fr_eof(fp)	(fr_cb(fp)->fr_eof)
+#define fr_flags(fp)	(fr_cb(fp)->fr_flags)
+#define fr_max_payload(fp)	(fr_cb(fp)->fr_max_payload)
+#define fr_cmd(fp)	(fr_cb(fp)->fr_cmd)
+#define fr_dir(fp)	(fr_cmd(fp)->sc_data_direction)
+
+struct fc_frame {
+	struct sk_buff skb;
+};
+
+struct fcoe_rcv_info {
+	struct packet_type  *ptype;
+	struct fc_lport	*fr_dev;	/* transport layer private pointer */
+	struct fc_seq	*fr_seq;	/* for use with exchange manager */
+	struct scsi_cmnd *fr_cmd;	/* for use of scsi command */
+	enum fc_sof	fr_sof;		/* start of frame delimiter */
+	enum fc_eof	fr_eof;		/* end of frame delimiter */
+	u8		fr_flags;	/* flags - see below */
+	u16		fr_max_payload;	/* max FC payload */
+};
+
+/*
+ * Get fc_frame pointer for an skb that's already been imported.
+ */
+static inline struct fcoe_rcv_info *fcoe_dev_from_skb(const struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct fcoe_rcv_info) > sizeof(skb->cb));
+	return (struct fcoe_rcv_info *) skb->cb;
+}
+
+/*
+ * fr_flags.
+ */
+#define	FCPHF_CRC_UNCHECKED	0x01	/* CRC not computed, still appended */
+
+/*
+ * Initialize a frame.
+ * We don't do a complete memset here for performance reasons.
+ * The caller must set fr_free, fr_hdr, fr_len, fr_sof, and fr_eof eventually.
+ */
+static inline void fc_frame_init(struct fc_frame *fp)
+{
+	fr_dev(fp) = NULL;
+	fr_seq(fp) = NULL;
+	fr_flags(fp) = 0;
+}
+
+struct fc_frame *fc_frame_alloc_fill(struct fc_lport *, size_t payload_len);
+
+struct fc_frame *__fc_frame_alloc(size_t payload_len);
+
+/*
+ * Get frame for sending via port.
+ */
+static inline struct fc_frame *_fc_frame_alloc(struct fc_lport *dev,
+					       size_t payload_len)
+{
+	return __fc_frame_alloc(payload_len);
+}
+
+/*
+ * Allocate fc_frame structure and buffer.  Set the initial length to
+ * payload_size + sizeof (struct fc_frame_header).
+ */
+static inline struct fc_frame *fc_frame_alloc(struct fc_lport *dev, size_t len)
+{
+	struct fc_frame *fp;
+
+	/*
+	 * Note: Since len will often be a constant multiple of 4,
+	 * this check will usually be evaluated and eliminated at compile time.
+	 */
+	if ((len % 4) != 0)
+		fp = fc_frame_alloc_fill(dev, len);
+	else
+		fp = _fc_frame_alloc(dev, len);
+	return fp;
+}
+
+/*
+ * Free the fc_frame structure and buffer.
+ */
+static inline void fc_frame_free(struct fc_frame *fp)
+{
+	kfree_skb(fp_skb(fp));
+}
+
+static inline int fc_frame_is_linear(struct fc_frame *fp)
+{
+	return !skb_is_nonlinear(fp_skb(fp));
+}
+
+/*
+ * Get frame header from message in fc_frame structure.
+ * This hides a cast and provides a place to add some checking.
+ */
+static inline
+struct fc_frame_header *fc_frame_header_get(const struct fc_frame *fp)
+{
+	WARN_ON(fr_len(fp) < sizeof(struct fc_frame_header));
+	return (struct fc_frame_header *) fr_hdr(fp);
+}
+
+/*
+ * Get frame payload from message in fc_frame structure.
+ * This hides a cast and provides a place to add some checking.
+ * The len parameter is the minimum length for the payload portion.
+ * Returns NULL if the frame is too short.
+ *
+ * This assumes the interesting part of the payload is in the first part
+ * of the buffer for received data.  This may not be appropriate to use for
+ * buffers being transmitted.
+ */
+static inline void *fc_frame_payload_get(const struct fc_frame *fp,
+					 size_t len)
+{
+	void *pp = NULL;
+
+	if (fr_len(fp) >= sizeof(struct fc_frame_header) + len)
+		pp = fc_frame_header_get(fp) + 1;
+	return pp;
+}
+
+/*
+ * Get frame payload opcode (first byte) from message in fc_frame structure.
+ * This hides a cast and provides a place to add some checking. Return 0
+ * if the frame has no payload.
+ */
+static inline u8 fc_frame_payload_op(const struct fc_frame *fp)
+{
+	u8 *cp;
+
+	cp = fc_frame_payload_get(fp, sizeof(u8));
+	if (!cp)
+		return 0;
+	return *cp;
+
+}
+
+/*
+ * Get FC class from frame.
+ */
+static inline enum fc_class fc_frame_class(const struct fc_frame *fp)
+{
+	return fc_sof_class(fr_sof(fp));
+}
+
+/*
+ * Check the CRC in a frame.
+ * The CRC immediately follows the last data item *AFTER* the length.
+ * The return value is zero if the CRC matches.
+ */
+u32 fc_frame_crc_check(struct fc_frame *);
+
+static inline u8 fc_frame_rctl(const struct fc_frame *fp)
+{
+	return fc_frame_header_get(fp)->fh_r_ctl;
+}
+
+static inline bool fc_frame_is_cmd(const struct fc_frame *fp)
+{
+	return fc_frame_rctl(fp) == FC_RCTL_DD_UNSOL_CMD;
+}
+
+static inline bool fc_frame_is_read(const struct fc_frame *fp)
+{
+	if (fc_frame_is_cmd(fp) && fr_cmd(fp))
+		return fr_dir(fp) == DMA_FROM_DEVICE;
+	return false;
+}
+
+static inline bool fc_frame_is_write(const struct fc_frame *fp)
+{
+	if (fc_frame_is_cmd(fp) && fr_cmd(fp))
+		return fr_dir(fp) == DMA_TO_DEVICE;
+	return false;
+}
+
+/*
+ * Check for leaks.
+ * Print the frame header of any currently allocated frame, assuming there
+ * should be none at this point.
+ */
+void fc_frame_leak_check(void);
+
+#endif /* _FC_FRAME_H_ */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
new file mode 100644
index 0000000..dac03e2
--- /dev/null
+++ b/include/scsi/libfc.h
@@ -0,0 +1,917 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
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
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _LIBFC_H_
+#define _LIBFC_H_
+
+#include <linux/timer.h>
+#include <linux/if.h>
+
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+
+#include <scsi/fc/fc_fcp.h>
+#include <scsi/fc/fc_ns.h>
+#include <scsi/fc/fc_els.h>
+#include <scsi/fc/fc_gs.h>
+
+#include <scsi/fc_frame.h>
+
+#define LIBFC_DEBUG
+
+#ifdef LIBFC_DEBUG
+/* Log messages */
+#define FC_DBG(fmt, args...)						\
+	do {								\
+		printk(KERN_INFO "%s " fmt, __func__, ##args);		\
+	} while (0)
+#else
+#define FC_DBG(fmt, args...)
+#endif
+
+/*
+ * libfc error codes
+ */
+#define	FC_NO_ERR	0	/* no error */
+#define	FC_EX_TIMEOUT	1	/* Exchange timeout */
+#define	FC_EX_CLOSED	2	/* Exchange closed */
+
+/* some helpful macros */
+
+#define ntohll(x) be64_to_cpu(x)
+#define htonll(x) cpu_to_be64(x)
+
+#define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
+
+#define hton24(p, v)	do {			\
+		p[0] = (((v) >> 16) & 0xFF);	\
+		p[1] = (((v) >> 8) & 0xFF);	\
+		p[2] = ((v) & 0xFF);		\
+	} while (0)
+
+/*
+ * FC HBA status
+ */
+#define FC_PAUSE		    (1 << 1)
+#define FC_LINK_UP		    (1 << 0)
+
+enum fc_lport_state {
+	LPORT_ST_NONE = 0,
+	LPORT_ST_FLOGI,
+	LPORT_ST_DNS,
+	LPORT_ST_RPN_ID,
+	LPORT_ST_RFT_ID,
+	LPORT_ST_SCR,
+	LPORT_ST_READY,
+	LPORT_ST_LOGO,
+	LPORT_ST_RESET
+};
+
+enum fc_disc_event {
+	DISC_EV_NONE = 0,
+	DISC_EV_SUCCESS,
+	DISC_EV_FAILED
+};
+
+enum fc_lport_event {
+	RPORT_EV_NONE = 0,
+	RPORT_EV_CREATED,
+	RPORT_EV_FAILED,
+	RPORT_EV_STOP,
+	RPORT_EV_LOGO
+};
+
+enum fc_rport_state {
+	RPORT_ST_NONE = 0,
+	RPORT_ST_INIT,		/* initialized */
+	RPORT_ST_PLOGI,		/* waiting for PLOGI completion */
+	RPORT_ST_PRLI,		/* waiting for PRLI completion */
+	RPORT_ST_RTV,		/* waiting for RTV completion */
+	RPORT_ST_READY,		/* ready for use */
+	RPORT_ST_LOGO,		/* port logout sent */
+};
+
+enum fc_rport_trans_state {
+	FC_PORTSTATE_ROGUE,
+	FC_PORTSTATE_REAL,
+};
+
+/**
+ * struct fc_disc_port - temporary discovery port to hold rport identifiers
+ * @lp: Fibre Channel host port instance
+ * @peers: node for list management during discovery and RSCN processing
+ * @ids: identifiers structure to pass to fc_remote_port_add()
+ * @rport_work: work struct for starting the rport state machine
+ */
+struct fc_disc_port {
+	struct fc_lport             *lp;
+	struct list_head            peers;
+	struct fc_rport_identifiers ids;
+	struct work_struct	    rport_work;
+};
+
+/**
+ * struct fc_rport_libfc_priv - libfc internal information about a remote port
+ * @local_port: Fibre Channel host port instance
+ * @rp_state: state tracks progress of PLOGI, PRLI, and RTV exchanges
+ * @flags: REC and RETRY supported flags
+ * @max_seq: maximum number of concurrent sequences
+ * @retries: retry count in current state
+ * @e_d_tov: error detect timeout value (in msec)
+ * @r_a_tov: resource allocation timeout value (in msec)
+ * @rp_mutex: mutex protects rport
+ * @retry_work:
+ * @event_callback: Callback for rport READY, FAILED or LOGO
+ */
+struct fc_rport_libfc_priv {
+	struct fc_lport		*local_port;
+	enum fc_rport_state rp_state;
+	u16			flags;
+	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
+	#define FC_RP_FLAGS_RETRY		(1 << 1)
+	u16		max_seq;
+	unsigned int	retries;
+	unsigned int	e_d_tov;
+	unsigned int	r_a_tov;
+	enum fc_rport_trans_state trans_state;
+	struct mutex    rp_mutex;
+	struct delayed_work	retry_work;
+	enum fc_lport_event     event;
+	void (*event_callback)(struct fc_lport *,
+			       struct fc_rport *,
+			       enum fc_lport_event);
+	struct list_head         peers;
+	struct work_struct       event_work;
+};
+
+#define PRIV_TO_RPORT(x)						\
+	(struct fc_rport *)((void *)x - sizeof(struct fc_rport));
+#define RPORT_TO_PRIV(x)						\
+	(struct fc_rport_libfc_priv *)((void *)x + sizeof(struct fc_rport));
+
+struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *);
+void fc_rport_rogue_destroy(struct fc_rport *);
+
+static inline void fc_rport_set_name(struct fc_rport *rport, u64 wwpn, u64 wwnn)
+{
+	rport->node_name = wwnn;
+	rport->port_name = wwpn;
+}
+
+/*
+ * fcoe stats structure
+ */
+struct fcoe_dev_stats {
+	u64		SecondsSinceLastReset;
+	u64		TxFrames;
+	u64		TxWords;
+	u64		RxFrames;
+	u64		RxWords;
+	u64		ErrorFrames;
+	u64		DumpedFrames;
+	u64		LinkFailureCount;
+	u64		LossOfSignalCount;
+	u64		InvalidTxWordCount;
+	u64		InvalidCRCCount;
+	u64		InputRequests;
+	u64		OutputRequests;
+	u64		ControlRequests;
+	u64		InputMegabytes;
+	u64		OutputMegabytes;
+};
+
+/*
+ * els data is used for passing ELS respone specific
+ * data to send ELS response mainly using infomation
+ * in exchange and sequence in EM layer.
+ */
+struct fc_seq_els_data {
+	struct fc_frame *fp;
+	enum fc_els_rjt_reason reason;
+	enum fc_els_rjt_explan explan;
+};
+
+/*
+ * FCP request structure, one for each scsi cmd request
+ */
+struct fc_fcp_pkt {
+	/*
+	 * housekeeping stuff
+	 */
+	struct fc_lport *lp;	/* handle to hba struct */
+	u16		state;		/* scsi_pkt state state */
+	u16		tgt_flags;	/* target flags	 */
+	atomic_t	ref_cnt;	/* fcp pkt ref count */
+	spinlock_t	scsi_pkt_lock;	/* Must be taken before the host lock
+					 * if both are held at the same time */
+	/*
+	 * SCSI I/O related stuff
+	 */
+	struct scsi_cmnd *cmd;		/* scsi command pointer. set/clear
+					 * under host lock */
+	struct list_head list;		/* tracks queued commands. access under
+					 * host lock */
+	/*
+	 * timeout related stuff
+	 */
+	struct timer_list timer;	/* command timer */
+	struct completion tm_done;
+	int	wait_for_comp;
+	unsigned long	start_time;	/* start jiffie */
+	unsigned long	end_time;	/* end jiffie */
+	unsigned long	last_pkt_time;	 /* jiffies of last frame received */
+
+	/*
+	 * scsi cmd and data transfer information
+	 */
+	u32		data_len;
+	/*
+	 * transport related veriables
+	 */
+	struct fcp_cmnd cdb_cmd;
+	size_t		xfer_len;
+	u32		xfer_contig_end; /* offset of end of contiguous xfer */
+	u16		max_payload;	/* max payload size in bytes */
+
+	/*
+	 * scsi/fcp return status
+	 */
+	u32		io_status;	/* SCSI result upper 24 bits */
+	u8		cdb_status;
+	u8		status_code;	/* FCP I/O status */
+	/* bit 3 Underrun bit 2: overrun */
+	u8		scsi_comp_flags;
+	u32		req_flags;	/* bit 0: read bit:1 write */
+	u32		scsi_resid;	/* residule length */
+
+	struct fc_rport	*rport;		/* remote port pointer */
+	struct fc_seq	*seq_ptr;	/* current sequence pointer */
+	/*
+	 * Error Processing
+	 */
+	u8		recov_retry;	/* count of recovery retries */
+	struct fc_seq	*recov_seq;	/* sequence for REC or SRR */
+};
+
+/*
+ * Structure and function definitions for managing Fibre Channel Exchanges
+ * and Sequences
+ *
+ * fc_exch holds state for one exchange and links to its active sequence.
+ *
+ * fc_seq holds the state for an individual sequence.
+ */
+
+struct fc_exch_mgr;
+
+/*
+ * Sequence.
+ */
+struct fc_seq {
+	u8	id;		/* seq ID */
+	u16	ssb_stat;	/* status flags for sequence status block */
+	u16	cnt;		/* frames sent so far on sequence */
+	u32	f_ctl;		/* F_CTL flags for frames */
+	u32	rec_data;	/* FC-4 value for REC */
+};
+
+#define FC_EX_DONE		(1 << 0) /* ep is completed */
+#define FC_EX_RST_CLEANUP	(1 << 1) /* reset is forcing completion */
+
+/*
+ * Exchange.
+ *
+ * Locking notes: The ex_lock protects changes to the following fields:
+ *	esb_stat, f_ctl, seq.ssb_stat, seq.f_ctl.
+ *	seq_id
+ *	sequence allocation
+ *
+ */
+struct fc_exch {
+	struct fc_exch_mgr *em;		/* exchange manager */
+	u32		state;		/* internal driver state */
+	u16		xid;		/* our exchange ID */
+	struct list_head	ex_list;	/* free or busy list linkage */
+	spinlock_t	ex_lock;	/* lock covering exchange state */
+	atomic_t	ex_refcnt;	/* reference counter */
+	struct delayed_work timeout_work; /* timer for upper level protocols */
+	struct fc_lport	*lp;		/* fc device instance */
+	u16		oxid;		/* originator's exchange ID */
+	u16		rxid;		/* responder's exchange ID */
+	u32		oid;		/* originator's FCID */
+	u32		sid;		/* source FCID */
+	u32		did;		/* destination FCID */
+	u32		esb_stat;	/* exchange status for ESB */
+	u32		r_a_tov;	/* r_a_tov from rport (msec) */
+	u8		seq_id;		/* next sequence ID to use */
+	u32		f_ctl;		/* F_CTL flags for sequences */
+	u8		fh_type;	/* frame type */
+	enum fc_class	class;		/* class of service */
+	struct fc_seq	seq;		/* single sequence */
+	/*
+	 * Handler for responses to this current exchange.
+	 */
+	void		(*resp)(struct fc_seq *, struct fc_frame *, void *);
+	void		(*destructor)(struct fc_seq *, void *);
+	/*
+	 * arg is passed as void pointer to exchange
+	 * resp and destructor handlers
+	 */
+	void		*arg;
+};
+#define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
+
+struct libfc_function_template {
+
+	/**
+	 * Mandatory Fields
+	 *
+	 * These handlers must be implemented by the LLD.
+	 */
+
+	/*
+	 * Interface to send a FC frame
+	 */
+	int (*frame_send)(struct fc_lport *lp, struct fc_frame *fp);
+
+	/**
+	 * Optional Fields
+	 *
+	 * The LLD may choose to implement any of the following handlers.
+	 * If LLD doesn't specify hander and leaves its pointer NULL then
+	 * the default libfc function will be used for that handler.
+	 */
+
+	/**
+	 * ELS/CT interfaces
+	 */
+
+	/*
+	 * elsct_send - sends ELS/CT frame
+	 */
+	struct fc_seq *(*elsct_send)(struct fc_lport *lport,
+				     struct fc_rport *rport,
+				     struct fc_frame *fp,
+				     unsigned int op,
+				     void (*resp)(struct fc_seq *,
+					     struct fc_frame *fp,
+					     void *arg),
+				     void *arg, u32 timer_msec);
+	/**
+	 * Exhance Manager interfaces
+	 */
+
+	/*
+	 * Send the FC frame payload using a new exchange and sequence.
+	 *
+	 * The frame pointer with some of the header's fields must be
+	 * filled before calling exch_seq_send(), those fields are,
+	 *
+	 * - routing control
+	 * - FC port did
+	 * - FC port sid
+	 * - FC header type
+	 * - frame control
+	 * - parameter or relative offset
+	 *
+	 * The exchange response handler is set in this routine to resp()
+	 * function pointer. It can be called in two scenarios: if a timeout
+	 * occurs or if a response frame is received for the exchange. The
+	 * fc_frame pointer in response handler will also indicate timeout
+	 * as error using IS_ERR related macros.
+	 *
+	 * The exchange destructor handler is also set in this routine.
+	 * The destructor handler is invoked by EM layer when exchange
+	 * is about to free, this can be used by caller to free its
+	 * resources along with exchange free.
+	 *
+	 * The arg is passed back to resp and destructor handler.
+	 *
+	 * The timeout value (in msec) for an exchange is set if non zero
+	 * timer_msec argument is specified. The timer is canceled when
+	 * it fires or when the exchange is done. The exchange timeout handler
+	 * is registered by EM layer.
+	 */
+	struct fc_seq *(*exch_seq_send)(struct fc_lport *lp,
+					struct fc_frame *fp,
+					void (*resp)(struct fc_seq *sp,
+						     struct fc_frame *fp,
+						     void *arg),
+					void (*destructor)(struct fc_seq *sp,
+							   void *arg),
+					void *arg, unsigned int timer_msec);
+
+	/*
+	 * send a frame using existing sequence and exchange.
+	 */
+	int (*seq_send)(struct fc_lport *lp, struct fc_seq *sp,
+			struct fc_frame *fp);
+
+	/*
+	 * Send ELS response using mainly infomation
+	 * in exchange and sequence in EM layer.
+	 */
+	void (*seq_els_rsp_send)(struct fc_seq *sp, enum fc_els_cmd els_cmd,
+				 struct fc_seq_els_data *els_data);
+
+	/*
+	 * Abort an exchange and sequence. Generally called because of a
+	 * exchange timeout or an abort from the upper layer.
+	 *
+	 * A timer_msec can be specified for abort timeout, if non-zero
+	 * timer_msec value is specified then exchange resp handler
+	 * will be called with timeout error if no response to abort.
+	 */
+	int (*seq_exch_abort)(const struct fc_seq *req_sp,
+			      unsigned int timer_msec);
+
+	/*
+	 * Indicate that an exchange/sequence tuple is complete and the memory
+	 * allocated for the related objects may be freed.
+	 */
+	void (*exch_done)(struct fc_seq *sp);
+
+	/*
+	 * Assigns a EM and a free XID for an new exchange and then
+	 * allocates a new exchange and sequence pair.
+	 * The fp can be used to determine free XID.
+	 */
+	struct fc_exch *(*exch_get)(struct fc_lport *lp, struct fc_frame *fp);
+
+	/*
+	 * Release previously assigned XID by exch_get API.
+	 * The LLD may implement this if XID is assigned by LLD
+	 * in exch_get().
+	 */
+	void (*exch_put)(struct fc_lport *lp, struct fc_exch_mgr *mp,
+			 u16 ex_id);
+
+	/*
+	 * Start a new sequence on the same exchange/sequence tuple.
+	 */
+	struct fc_seq *(*seq_start_next)(struct fc_seq *sp);
+
+	/*
+	 * Reset an exchange manager, completing all sequences and exchanges.
+	 * If s_id is non-zero, reset only exchanges originating from that FID.
+	 * If d_id is non-zero, reset only exchanges sending to that FID.
+	 */
+	void (*exch_mgr_reset)(struct fc_exch_mgr *,
+			       u32 s_id, u32 d_id);
+
+	void (*rport_flush_queue)(void);
+	/**
+	 * Local Port interfaces
+	 */
+
+	/*
+	 * Receive a frame to a local port.
+	 */
+	void (*lport_recv)(struct fc_lport *lp, struct fc_seq *sp,
+			   struct fc_frame *fp);
+
+	int (*lport_reset)(struct fc_lport *);
+
+	/**
+	 * Remote Port interfaces
+	 */
+
+	/*
+	 * Initiates the RP state machine. It is called from the LP module.
+	 * This function will issue the following commands to the N_Port
+	 * identified by the FC ID provided.
+	 *
+	 * - PLOGI
+	 * - PRLI
+	 * - RTV
+	 */
+	int (*rport_login)(struct fc_rport *rport);
+
+	/*
+	 * Logoff, and remove the rport from the transport if
+	 * it had been added. This will send a LOGO to the target.
+	 */
+	int (*rport_logoff)(struct fc_rport *rport);
+
+	/*
+	 * Recieve a request from a remote port.
+	 */
+	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
+			       struct fc_rport *);
+
+	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
+
+	/**
+	 * FCP interfaces
+	 */
+
+	/*
+	 * Send a fcp cmd from fsp pkt.
+	 * Called with the SCSI host lock unlocked and irqs disabled.
+	 *
+	 * The resp handler is called when FCP_RSP received.
+	 *
+	 */
+	int (*fcp_cmd_send)(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
+			    void (*resp)(struct fc_seq *, struct fc_frame *fp,
+					 void *arg));
+
+	/*
+	 * Used at least durring linkdown and reset
+	 */
+	void (*fcp_cleanup)(struct fc_lport *lp);
+
+	/*
+	 * Abort all I/O on a local port
+	 */
+	void (*fcp_abort_io)(struct fc_lport *lp);
+
+	/**
+	 * Discovery interfaces
+	 */
+
+	void (*disc_recv_req)(struct fc_seq *,
+			      struct fc_frame *, struct fc_lport *);
+
+	/*
+	 * Start discovery for a local port.
+	 */
+	void (*disc_start)(void (*disc_callback)(struct fc_lport *,
+						 enum fc_disc_event),
+			   struct fc_lport *);
+
+	/*
+	 * Stop discovery for a given lport. This will remove
+	 * all discovered rports
+	 */
+	void (*disc_stop) (struct fc_lport *);
+
+	/*
+	 * Stop discovery for a given lport. This will block
+	 * until all discovered rports are deleted from the
+	 * FC transport class
+	 */
+	void (*disc_stop_final) (struct fc_lport *);
+};
+
+struct fc_lport {
+	struct list_head list;
+
+	/* Associations */
+	struct Scsi_Host	*host;
+	struct fc_exch_mgr	*emp;
+	struct fc_rport		*dns_rp;
+	struct fc_rport		*ptp_rp;
+	void			*scsi_priv;
+
+	/* Operational Information */
+	struct libfc_function_template tt;
+	u16			link_status;
+	enum fc_lport_state	state;
+	unsigned long		boot_time;
+
+	struct fc_host_statistics host_stats;
+	struct fcoe_dev_stats	*dev_stats[NR_CPUS];
+	u64			wwpn;
+	u64			wwnn;
+	u8			retry_count;
+
+	/* Capabilities */
+	u32			sg_supp:1;	/* scatter gather supported */
+	u32			seq_offload:1;	/* seq offload supported */
+	u32			crc_offload:1;	/* crc offload supported */
+	u32			lro_enabled:1;	/* large receive offload */
+	u32			mfs;	        /* max FC payload size */
+	unsigned int		service_params;
+	unsigned int		e_d_tov;
+	unsigned int		r_a_tov;
+	u8			max_retry_count;
+	u16			link_speed;
+	u16			link_supported_speeds;
+	u16			lro_xid;	/* max xid for fcoe lro */
+	struct fc_ns_fts	fcts;	        /* FC-4 type masks */
+	struct fc_els_rnid_gen	rnid_gen;	/* RNID information */
+
+	/* Semaphores */
+	struct mutex lp_mutex;
+
+	/* Miscellaneous */
+	struct delayed_work	retry_work;
+	struct delayed_work	disc_work;
+};
+
+/**
+ * FC_LPORT HELPER FUNCTIONS
+ *****************************/
+static inline void *lport_priv(const struct fc_lport *lp)
+{
+	return (void *)(lp + 1);
+}
+
+static inline int fc_lport_test_ready(struct fc_lport *lp)
+{
+	return lp->state == LPORT_ST_READY;
+}
+
+static inline void fc_set_wwnn(struct fc_lport *lp, u64 wwnn)
+{
+	lp->wwnn = wwnn;
+}
+
+static inline void fc_set_wwpn(struct fc_lport *lp, u64 wwnn)
+{
+	lp->wwpn = wwnn;
+}
+
+static inline void fc_lport_state_enter(struct fc_lport *lp,
+					enum fc_lport_state state)
+{
+	if (state != lp->state)
+		lp->retry_count = 0;
+	lp->state = state;
+}
+
+
+/**
+ * LOCAL PORT LAYER
+ *****************************/
+int fc_lport_init(struct fc_lport *lp);
+
+/*
+ * Destroy the specified local port by finding and freeing all
+ * fc_rports associated with it and then by freeing the fc_lport
+ * itself.
+ */
+int fc_lport_destroy(struct fc_lport *lp);
+
+/*
+ * Logout the specified local port from the fabric
+ */
+int fc_fabric_logoff(struct fc_lport *lp);
+
+/*
+ * Initiate the LP state machine. This handler will use fc_host_attr
+ * to store the FLOGI service parameters, so fc_host_attr must be
+ * initialized before calling this handler.
+ */
+int fc_fabric_login(struct fc_lport *lp);
+
+/*
+ * The link is up for the given local port.
+ */
+void fc_linkup(struct fc_lport *);
+
+/*
+ * Link is down for the given local port.
+ */
+void fc_linkdown(struct fc_lport *);
+
+/*
+ * Pause and unpause traffic.
+ */
+void fc_pause(struct fc_lport *);
+void fc_unpause(struct fc_lport *);
+
+/*
+ * Configure the local port.
+ */
+int fc_lport_config(struct fc_lport *);
+
+/*
+ * Reset the local port.
+ */
+int fc_lport_reset(struct fc_lport *);
+
+/*
+ * Set the mfs or reset
+ */
+int fc_set_mfs(struct fc_lport *lp, u32 mfs);
+
+
+/**
+ * REMOTE PORT LAYER
+ *****************************/
+int fc_rport_init(struct fc_lport *lp);
+void fc_rport_terminate_io(struct fc_rport *rp);
+
+/**
+ * DISCOVERY LAYER
+ *****************************/
+int fc_disc_init(struct fc_lport *lp);
+
+
+/**
+ * SCSI LAYER
+ *****************************/
+/*
+ * Initialize the SCSI block of libfc
+ */
+int fc_fcp_init(struct fc_lport *);
+
+/*
+ * This section provides an API which allows direct interaction
+ * with the SCSI-ml. Each of these functions satisfies a function
+ * pointer defined in Scsi_Host and therefore is always called
+ * directly from the SCSI-ml.
+ */
+int fc_queuecommand(struct scsi_cmnd *sc_cmd,
+		    void (*done)(struct scsi_cmnd *));
+
+/*
+ * complete processing of a fcp packet
+ *
+ * This function may sleep if a fsp timer is pending.
+ * The host lock must not be held by caller.
+ */
+void fc_fcp_complete(struct fc_fcp_pkt *fsp);
+
+/*
+ * Send an ABTS frame to the target device. The sc_cmd argument
+ * is a pointer to the SCSI command to be aborted.
+ */
+int fc_eh_abort(struct scsi_cmnd *sc_cmd);
+
+/*
+ * Reset a LUN by sending send the tm cmd to the target.
+ */
+int fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
+
+/*
+ * Reset the host adapter.
+ */
+int fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
+
+/*
+ * Check rport status.
+ */
+int fc_slave_alloc(struct scsi_device *sdev);
+
+/*
+ * Adjust the queue depth.
+ */
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth);
+
+/*
+ * Change the tag type.
+ */
+int fc_change_queue_type(struct scsi_device *sdev, int tag_type);
+
+/*
+ * Free memory pools used by the FCP layer.
+ */
+void fc_fcp_destroy(struct fc_lport *);
+
+/**
+ * ELS/CT interface
+ *****************************/
+/*
+ * Initializes ELS/CT interface
+ */
+int fc_elsct_init(struct fc_lport *lp);
+
+
+/**
+ * EXCHANGE MANAGER LAYER
+ *****************************/
+/*
+ * Initializes Exchange Manager related
+ * function pointers in struct libfc_function_template.
+ */
+int fc_exch_init(struct fc_lport *lp);
+
+/*
+ * Allocates an Exchange Manager (EM).
+ *
+ * The EM manages exchanges for their allocation and
+ * free, also allows exchange lookup for received
+ * frame.
+ *
+ * The class is used for initializing FC class of
+ * allocated exchange from EM.
+ *
+ * The min_xid and max_xid will limit new
+ * exchange ID (XID) within this range for
+ * a new exchange.
+ * The LLD may choose to have multiple EMs,
+ * e.g. one EM instance per CPU receive thread in LLD.
+ * The LLD can use exch_get() of struct libfc_function_template
+ * to specify XID for a new exchange within
+ * a specified EM instance.
+ *
+ * The em_idx to uniquely identify an EM instance.
+ */
+struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
+				      enum fc_class class,
+				      u16 min_xid,
+				      u16 max_xid);
+
+/*
+ * Free an exchange manager.
+ */
+void fc_exch_mgr_free(struct fc_exch_mgr *mp);
+
+/*
+ * Receive a frame on specified local port and exchange manager.
+ */
+void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
+		  struct fc_frame *fp);
+
+/*
+ * This function is for exch_seq_send function pointer in
+ * struct libfc_function_template, see comment block on
+ * exch_seq_send for description of this function.
+ */
+struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
+				struct fc_frame *fp,
+				void (*resp)(struct fc_seq *sp,
+					     struct fc_frame *fp,
+					     void *arg),
+				void (*destructor)(struct fc_seq *sp,
+						   void *arg),
+				void *arg, u32 timer_msec);
+
+/*
+ * send a frame using existing sequence and exchange.
+ */
+int fc_seq_send(struct fc_lport *lp, struct fc_seq *sp, struct fc_frame *fp);
+
+/*
+ * Send ELS response using mainly infomation
+ * in exchange and sequence in EM layer.
+ */
+void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
+			 struct fc_seq_els_data *els_data);
+
+/*
+ * This function is for seq_exch_abort function pointer in
+ * struct libfc_function_template, see comment block on
+ * seq_exch_abort for description of this function.
+ */
+int fc_seq_exch_abort(const struct fc_seq *req_sp, unsigned int timer_msec);
+
+/*
+ * Indicate that an exchange/sequence tuple is complete and the memory
+ * allocated for the related objects may be freed.
+ */
+void fc_exch_done(struct fc_seq *sp);
+
+/*
+ * Assigns a EM and XID for a frame and then allocates
+ * a new exchange and sequence pair.
+ * The fp can be used to determine free XID.
+ */
+struct fc_exch *fc_exch_get(struct fc_lport *lp, struct fc_frame *fp);
+
+/*
+ * Allocate a new exchange and sequence pair.
+ * if ex_id is zero then next free exchange id
+ * from specified exchange manger mp will be assigned.
+ */
+struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
+			      struct fc_frame *fp, u16 ex_id);
+/*
+ * Start a new sequence on the same exchange as the supplied sequence.
+ */
+struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
+
+/*
+ * Reset an exchange manager, completing all sequences and exchanges.
+ * If s_id is non-zero, reset only exchanges originating from that FID.
+ * If d_id is non-zero, reset only exchanges sending to that FID.
+ */
+void fc_exch_mgr_reset(struct fc_exch_mgr *, u32 s_id, u32 d_id);
+
+/*
+ * Functions for fc_functions_template
+ */
+void fc_get_host_speed(struct Scsi_Host *shost);
+void fc_get_host_port_type(struct Scsi_Host *shost);
+void fc_get_host_port_state(struct Scsi_Host *shost);
+void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout);
+struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);
+
+/*
+ * module setup functions.
+ */
+int fc_setup_exch_mgr(void);
+void fc_destroy_exch_mgr(void);
+int fc_setup_rport(void);
+void fc_destroy_rport(void);
+
+#endif /* _LIBFC_H_ */

