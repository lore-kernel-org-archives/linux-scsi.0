From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 1/5 RESEND] add libiscsi
Date: Sun, 20 Nov 2005 15:27:58 -0600
Message-ID: <1132522078.7983.18.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:5250 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932112AbVKTV2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 16:28:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org

Add libiscsi code. These functions are usable by HW or SW iscsi
LLDs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff -Naurp linux-2.6.15-rc2/drivers/scsi/libiscsi.c linux-2.6.15-rc2.diff/drivers/scsi/libiscsi.c
--- linux-2.6.15-rc2/drivers/scsi/libiscsi.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.15-rc2.diff/drivers/scsi/libiscsi.c	2005-11-20 15:06:49.000000000 -0600
@@ -0,0 +1,473 @@
+/*
+ * iSCSI lib functions
+ *
+ * Copyright (C) IBM Corporation, 2004
+ * Copyright (C) Mike Christie, 2004 - 2005
+ * Copyright (C) Dmitry Yusupov, 2004 - 2005
+ * Copyright (C) Alex Aizman, 2004 - 2005
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/iscsi_session.h>
+
+#define dev_to_ihost(_dev) \
+	container_of(_dev, struct iscsi_host, dev)
+
+static LIST_HEAD(iscsi_hosts);
+static DEFINE_SPINLOCK(iscsi_hosts_lock);
+
+static void iscsi_host_release(struct device *dev)
+{
+	struct iscsi_host *ihost = dev_to_ihost(dev);
+	kfree(ihost);
+}
+
+/**
+ * iscsi_alloc_iscsi_host - allocate iscsi host
+ * iscsi_transport: iscsi_transport
+ * scsi_transport: scsi_transport returned from iscsi transport registration
+ * gpf: allocation mask
+ *
+ * HW iSCSI LLDs should allocte one of these per PCI device in their probe.
+ * SW iSCSI can allocate one per module/node or one per resource if it
+ * is being bound to HW resrouce.
+ **/
+struct iscsi_host *
+iscsi_alloc_iscsi_host(struct iscsi_transport *iscsi_transport,
+		       struct scsi_transport_template *scsi_transport)
+{
+	struct iscsi_host *ihost;
+	struct device *dev;
+
+	ihost = kzalloc(sizeof(*ihost) + iscsi_transport->ihostdata_size,
+			GFP_KERNEL);
+	if (!ihost)
+		return NULL;
+
+	ihost->scsi_transport = scsi_transport;
+	ihost->iscsi_transport = iscsi_transport;
+	/*
+	 * The LLD can set the can_queue to HW resource per card limit
+	 * or per target (for virtual LLDs) and we make sure the
+	 * the correct number of commands gets to them.
+	 */
+	ihost->cmds_per_iscsihost = iscsi_transport->host_template->can_queue;
+	INIT_LIST_HEAD(&ihost->sessions);
+	INIT_LIST_HEAD(&ihost->list);
+	spin_lock_init(&ihost->session_lock);
+
+	if (iscsi_transport->ihostdata_size)
+		ihost->dd_data = &ihost[1];
+
+	dev = &ihost->dev;
+	device_initialize(dev);
+	dev->release = iscsi_host_release;
+	return ihost;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_alloc_iscsi_host);
+
+/**
+ * iscsi_add_iscsi_host - complete setup by adding the host
+ * @ihost: iscsi host
+ * @dev: parent device
+ * @name: if there is no parent, name must be a unique name for this host
+ *
+ * This should be called after the host has been setup.
+ **/
+int iscsi_add_iscsi_host(struct iscsi_host *ihost, struct device *dev,
+			 const char *name)
+{
+	unsigned long flags;
+	int err;
+
+	if (dev) {
+		strlcpy(ihost->dev.bus_id, dev->bus_id, BUS_ID_SIZE);
+		ihost->dev.parent = dev;
+	} else {
+		strlcpy(ihost->dev.bus_id, name, BUS_ID_SIZE);
+		ihost->dev.parent = &platform_bus;
+	}
+
+	err = device_add(&ihost->dev);
+	if (err)
+		return err;	
+
+	spin_lock_irqsave(&iscsi_hosts_lock, flags);
+	list_add(&ihost->list, &iscsi_hosts);
+	spin_unlock_irqrestore(&iscsi_hosts_lock, flags);
+
+	return err;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_add_iscsi_host);
+
+/**
+ * iscsi_remove_iscsi_host - remove iscsi host
+ * @ihost: iscsi host
+ **/
+void iscsi_remove_iscsi_host(struct iscsi_host *ihost)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&iscsi_hosts_lock, flags);
+	list_del(&ihost->list);
+	spin_unlock_irqrestore(&iscsi_hosts_lock, flags);
+	device_del(&ihost->dev);
+}
+
+EXPORT_SYMBOL_GPL(iscsi_remove_iscsi_host);
+
+static void iscsi_task_done(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct iscsi_session *session = hostdata_session(sdev->host->hostdata);
+	unsigned long flags;
+
+	/*
+	 * Bleh. Must think of something else
+	 */
+	spin_lock_irqsave(&session->ihost->session_lock, flags);
+	session->ihost->cmds_queued--;
+	spin_unlock_irqrestore(&session->ihost->session_lock, flags);
+
+	cmd->scsi_done(cmd);
+}
+
+/**
+ * iscsi_scsi_queuecmd - queue command to scsi_host
+ * @cmd: scsi cmd
+ * @done: scsi done function
+ *
+ * At this time we only check that scsi limits are honored. When iSER and
+ * Qlogic are closer to being merged we can move more state checking
+ * (iscsi eh state and iscsi sequence number checks) and iscsi_task
+ * allocation here so we can all share that code. Hopefully, we can
+ * share some TMF code with SAS.
+ **/
+int iscsi_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+{
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct iscsi_session *session = hostdata_session(shost->hostdata);
+	struct iscsi_host *ihost = session->ihost;
+	int ret = 0;
+
+	spin_unlock(shost->host_lock);
+	spin_lock(&ihost->session_lock);
+
+	if (ihost->cmds_queued >= ihost->cmds_per_iscsihost) {
+		ret = SCSI_MLQUEUE_HOST_BUSY;		
+		goto done;
+	}
+	ihost->cmds_queued++;
+
+	cmd->scsi_done = done;
+	ret = ihost->iscsi_transport->execute_task(cmd, iscsi_task_done);
+	if (!ret)
+		goto done;
+	ihost->cmds_queued--;
+
+	switch (ret) {
+	case ISCSI_FAILURE_WINDOW_CLOSED:
+		ret = SCSI_MLQUEUE_HOST_BUSY;
+		break;
+	default:
+		cmd->result = (DID_NO_CONNECT << 16);
+		cmd->resid = cmd->request_bufflen;
+		done(cmd);
+		ret = 0;
+	}
+
+done:
+	spin_unlock(&ihost->session_lock);
+	spin_lock(shost->host_lock);
+	return ret;	
+}
+
+EXPORT_SYMBOL_GPL(iscsi_scsi_queuecmd);
+
+struct iscsi_host *iscsi_find_iscsi_host(const char *bus_id)
+{
+	unsigned long flags;
+	struct iscsi_host *ihost;
+
+	spin_lock_irqsave(&iscsi_hosts_lock, flags);
+	list_for_each_entry(ihost, &iscsi_hosts, list) {
+		if (!strncmp(ihost->dev.bus_id, bus_id, BUS_ID_SIZE))
+			goto done;
+	}
+	ihost = NULL;
+ done:
+	spin_unlock_irqrestore(&iscsi_hosts_lock, flags);
+	return ihost;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_find_iscsi_host);
+
+/**
+ * iscsi_host_put - release handle to iscsi host
+ * @ihost: iscsi host
+ **/
+void iscsi_host_put(struct iscsi_host *ihost)
+{
+	put_device(&ihost->dev);
+}
+
+EXPORT_SYMBOL_GPL(iscsi_host_put);
+
+/*
+ * iSCSI Session's hostdata organization:
+ *
+ *    *------------------* <== host->hostdata
+ *    | transport        |
+ *    |------------------| <== iscsi_hostdata(host->hostdata)
+ *    | transport's data |
+ *    |------------------| <== hostdata_session(host->hostdata)
+ *    | classes's data   |
+ *    *------------------*
+ */
+
+#define hostdata_privsize(_t)	(sizeof(unsigned long) + _t->hostdata_size + \
+				 _t->hostdata_size % sizeof(unsigned long) + \
+				 sizeof(struct iscsi_session))
+
+static void iscsi_session_release(struct device *dev)
+{
+	struct iscsi_session *session = iscsi_dev_to_session(dev);
+	struct iscsi_transport *transport = session->ihost->iscsi_transport;
+	struct Scsi_Host *shost;
+
+	shost = iscsi_session_to_shost(session);
+	scsi_host_put(shost);
+	module_put(transport->owner);
+}
+
+int iscsi_is_session_dev(const struct device *dev)
+{
+	return dev->release == iscsi_session_release;
+}
+
+/**
+ * iscsi_create_session - create iscsi class session
+ * @ihost: iscsi host
+ * @initial_cmdsn: initial iSCSI CmdSN
+ *
+ * This can be called from a LLD or iscsi_interface
+ **/
+struct iscsi_session *
+iscsi_create_session(struct iscsi_host *ihost, uint32_t initial_cmdsn)
+{
+	struct iscsi_transport *transport = ihost->iscsi_transport;
+	struct iscsi_session *session;
+	struct Scsi_Host *shost;
+	unsigned long flags;
+	int err;
+
+	if (!try_module_get(transport->owner))
+		return NULL;
+
+	shost = scsi_host_alloc(transport->host_template,
+				hostdata_privsize(transport));
+	if (!shost) {
+		printk(KERN_ERR "iscsi: can not allocate SCSI host for "
+		       "session\n");
+		goto out_module_put;
+	}
+
+	shost->max_id = 1;
+	shost->max_channel = 0;
+	shost->max_lun = transport->max_lun;
+	shost->max_cmd_len = transport->max_cmd_len;
+	shost->transportt = ihost->scsi_transport;
+
+	/* store struct iscsi_transport in hostdata */
+	*(uint64_t*)shost->hostdata = iscsi_handle(transport);
+
+	/* initialize session */
+	if (transport->create_session) {
+		err = transport->create_session(ihost, shost, initial_cmdsn);
+		if (err)
+			goto out_host_put;
+	}
+
+	session = hostdata_session(shost->hostdata);
+	INIT_LIST_HEAD(&session->list);
+	session->ihost = ihost;
+
+	err = scsi_add_host(shost, &ihost->dev);
+	if (err)
+		goto out_destroy_session;
+
+	/* this is released in the dev's release function */
+	scsi_host_get(shost);
+	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u", shost->host_no);
+	session->dev.parent = &shost->shost_gendev;
+	session->dev.release = iscsi_session_release;
+	err = device_register(&session->dev);
+	if (err) {
+		dev_printk(KERN_ERR, &session->dev, "iscsi: could not "
+			   "register session's dev\n");
+		goto out_remove_host;
+	}
+	transport_register_device(&session->dev);
+
+
+	/* add this session to the list of active sessions */
+	spin_lock_irqsave(&ihost->session_lock, flags);
+	list_add(&session->list, &ihost->sessions);
+	spin_unlock_irqrestore(&ihost->session_lock, flags);
+
+	return session;
+
+out_remove_host:
+	scsi_remove_host(shost);
+out_destroy_session:
+	if (transport->destroy_session)
+		transport->destroy_session(ihost, shost);
+out_host_put:
+	scsi_host_put(shost);
+out_module_put:
+	module_put(transport->owner);
+	return NULL;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_create_session);
+
+/**
+ * iscsi_destroy_session - destroy iscsi session
+ * @session: iscsi_session
+ *
+ * Can be called by a LLD or iscsi_interface. There must not be
+ * any running connections.
+ **/
+int iscsi_destroy_session(struct iscsi_session *session)
+{
+	struct iscsi_host *ihost = session->ihost;
+	struct iscsi_transport *transport = ihost->iscsi_transport;
+	struct Scsi_Host *shost;
+	unsigned long flags;
+
+	shost = iscsi_session_to_shost(session);
+	scsi_remove_host(shost);
+
+	if (transport->destroy_session)
+		transport->destroy_session(session->ihost, shost);
+
+	transport_unregister_device(&session->dev);
+	device_unregister(&session->dev);
+
+	/* remove this session from the list of active sessions */
+	spin_lock_irqsave(&ihost->session_lock, flags);
+	list_del(&session->list);
+	spin_unlock_irqrestore(&ihost->session_lock, flags);
+
+	/*
+	 * ref from host alloc (there was an extra get from the session->dev
+	 * relased in driver model release
+	 */
+	scsi_host_put(shost);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_destroy_session);
+
+static void iscsi_conn_release(struct device *dev)
+{
+	struct iscsi_conn *conn = iscsi_dev_to_conn(dev);
+	struct device *parent = conn->dev.parent;
+
+	kfree(conn);
+	put_device(parent);
+}
+
+int iscsi_is_conn_dev(const struct device *dev)
+{
+	return dev->release == iscsi_conn_release;
+}
+
+struct iscsi_conn *
+iscsi_create_conn(struct iscsi_session *session, uint32_t cid)
+{
+	struct iscsi_transport *transport = session->ihost->iscsi_transport;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_conn *conn;
+	int err;
+
+	conn = kzalloc(sizeof(*conn) + transport->conndata_size, GFP_KERNEL);
+	if (!conn)
+		return NULL;
+
+	if (transport->conndata_size)
+		conn->dd_data = &conn[1];
+
+	INIT_LIST_HEAD(&conn->conn_list);
+	conn->transport = transport;
+
+	if (transport->create_conn) {
+		if (transport->create_conn(shost, conn->dd_data, cid))
+			goto free_conn;
+	}
+
+	/* this is released in the dev's release function */
+	if (!get_device(&session->dev))
+		goto destroy_conn;
+	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "connection%d:%u",
+		 shost->host_no, cid);
+	conn->dev.parent = &session->dev;
+	conn->dev.release = iscsi_conn_release;
+	err = device_register(&conn->dev);
+	if (err) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: could not register "
+			   "connection's dev\n");
+		goto release_parent_ref;
+	}
+	transport_register_device(&conn->dev);
+	return conn;
+
+release_parent_ref:
+	put_device(&session->dev);
+destroy_conn:
+	if (transport->destroy_conn)
+		transport->destroy_conn(conn->dd_data);
+free_conn:
+	kfree(conn);
+	return NULL;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_create_conn);
+
+int iscsi_destroy_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = iscsi_dev_to_session(conn->dev.parent);
+	struct iscsi_transport *transport = session->ihost->iscsi_transport;
+
+	if (transport->destroy_conn)
+		transport->destroy_conn(conn->dd_data);
+
+	transport_unregister_device(&conn->dev);
+	device_unregister(&conn->dev);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
diff -Naurp linux-2.6.15-rc2/include/scsi/iscsi_session.h linux-2.6.15-rc2.diff/include/scsi/iscsi_session.h
--- linux-2.6.15-rc2/include/scsi/iscsi_session.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.15-rc2.diff/include/scsi/iscsi_session.h	2005-11-20 15:07:09.000000000 -0600
@@ -0,0 +1,90 @@
+/*
+ * iSCSI session and connection management functions and defnitions
+ *
+ * Copyright (C) IBM Corporation, 2004
+ * Copyright (C) Mike Christie, 2004 - 2005
+ * Copyright (C) Dmitry Yusupov, 2004 - 2005
+ * Copyright (C) Alex Aizman, 2004 - 2005
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef SCSI_LIBISCSI_ISCSI_H
+#define SCSI_LIBISCSI_ISCSI_H
+
+#include <linux/mempool.h>
+#include <linux/device.h>
+#include <scsi/iscsi_if.h>
+
+struct iscsi_transport;
+struct iscsi_host;
+
+struct mempool_zone {
+	mempool_t *pool;
+	atomic_t allocated;
+	int size;
+	int hiwat;
+	struct list_head freequeue;
+	spinlock_t freelock;
+};
+
+struct iscsi_conn {
+	struct list_head conn_list;	/* item in connlist */
+	void *dd_data;			/* LLD private data */
+	struct iscsi_transport *transport;
+	iscsi_connh_t connh;
+	int active;			/* must be accessed with the connlock */
+	struct device dev;		/* sysfs transport/container device */
+	struct mempool_zone z_error;
+	struct mempool_zone z_pdu;
+	struct list_head freequeue;
+};
+
+#define iscsi_dev_to_conn(_dev) \
+	container_of(_dev, struct iscsi_conn, dev)
+
+struct iscsi_session {
+	struct list_head list;	/* item in session_list */
+	struct iscsi_host *ihost;
+	struct device dev;	/* sysfs transport/container device */
+};
+
+/**
+ * hostdata_session - get libiscsi session from hostdata
+ * @_hostdata: scsi host hostdata
+ **/
+#define hostdata_session(_hostdata) ((void*)_hostdata + sizeof(unsigned long) + \
+			((struct iscsi_transport *) \
+			iscsi_ptr(*(uint64_t *)_hostdata))->hostdata_size)
+
+#define iscsi_dev_to_session(_dev) \
+	container_of(_dev, struct iscsi_session, dev)
+
+#define iscsi_session_to_shost(_session) \
+	dev_to_shost(_session->dev.parent)
+
+/*
+ * session and connection calls
+ */
+extern struct iscsi_session *iscsi_create_session(struct iscsi_host *ihost,
+						  uint32_t initial_cmdsn);
+extern int iscsi_destroy_session(struct iscsi_session *session);
+extern int iscsi_is_session_dev(const struct device *dev);
+extern struct iscsi_conn *iscsi_create_conn(struct iscsi_session *session,
+					    uint32_t cid);
+extern int iscsi_destroy_conn(struct iscsi_conn *conn);
+extern int iscsi_is_conn_dev(const struct device *dev);
+
+
+#endif
diff -Naurp linux-2.6.15-rc2/include/scsi/scsi_transport_iscsi.h linux-2.6.15-rc2.diff/include/scsi/scsi_transport_iscsi.h
--- linux-2.6.15-rc2/include/scsi/scsi_transport_iscsi.h	2005-11-19 21:25:03.000000000 -0600
+++ linux-2.6.15-rc2.diff/include/scsi/scsi_transport_iscsi.h	2005-11-20 15:07:20.000000000 -0600
@@ -25,6 +25,11 @@
 
 #include <scsi/iscsi_if.h>
 
+struct scsi_transport_template;
+struct Scsi_Host;
+struct scsi_cmnd;
+struct iscsi_host;
+
 /**
  * struct iscsi_transport - iSCSI Transport template
  *
@@ -48,35 +53,87 @@ struct iscsi_transport {
 	char *name;
 	unsigned int caps;
 	struct scsi_host_template *host_template;
+	/* LLD session/scsi_host data size */
 	int hostdata_size;
+	/* LLD iscsi_host data size */
+	int ihostdata_size;
+	/* LLD connection data size */
+	int conndata_size;
 	int max_lun;
 	unsigned int max_conn;
 	unsigned int max_cmd_len;
-	iscsi_sessionh_t (*create_session) (uint32_t initial_cmdsn,
-					    struct Scsi_Host *shost);
-	void (*destroy_session) (iscsi_sessionh_t session);
-	iscsi_connh_t (*create_conn) (iscsi_sessionh_t session, uint32_t cid);
+	int (*create_session) (struct iscsi_host *ihost,
+			       struct Scsi_Host *shost,
+			       uint32_t initial_cmdsn);
+	void (*destroy_session) (struct iscsi_host *ihost,
+				struct Scsi_Host *shost);
+	int (*create_conn) (struct Scsi_Host *shost, void *conndata,
+			    uint32_t cid);
 	int (*bind_conn) (iscsi_sessionh_t session, iscsi_connh_t conn,
 			  uint32_t transport_fd, int is_leading);
 	int (*start_conn) (iscsi_connh_t conn);
 	void (*stop_conn) (iscsi_connh_t conn, int flag);
-	void (*destroy_conn) (iscsi_connh_t conn);
+	void (*destroy_conn) (void *conndata);
 	int (*set_param) (iscsi_connh_t conn, enum iscsi_param param,
 			  uint32_t value);
-	int (*get_param) (iscsi_connh_t conn, enum iscsi_param param,
-			  uint32_t *value);
+	int (*get_conn_param) (void *conndata, enum iscsi_param param,
+			       uint32_t *value);
+	int (*get_session_param) (struct Scsi_Host *shost,
+				  enum iscsi_param param, uint32_t *value);
 	int (*send_pdu) (iscsi_connh_t conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
 	void (*get_stats) (iscsi_connh_t conn, struct iscsi_stats *stats);
+	int (*execute_task) (struct scsi_cmnd *cmd,
+			     void (*done)(struct scsi_cmnd *));
+};
+
+struct iscsi_host {
+	struct iscsi_transport *iscsi_transport;
+	struct scsi_transport_template *scsi_transport;
+
+	struct device dev;
+	struct list_head list;
+	struct list_head sessions;
+	spinlock_t session_lock;
+
+	void *dd_data;
+
+	int cmds_per_iscsihost;
+	int cmds_queued;
+};
+
+/*
+ * iSCSI LLD execute_task return codes
+ * (TODO make more iscsi/SAMish when SAS code is merged)
+ */
+enum {
+	ISCSI_FAILURE_BAD_HOST = 1,
+	ISCSI_FAILURE_SESSION_FAILED,
+	ISCSI_FAILURE_SESSION_FREED,
+	ISCSI_FAILURE_WINDOW_CLOSED,
+	ISCSI_FAILURE_SESSION_TERMINATE,
 };
 
 /*
  * transport registration upcalls
  */
-extern int iscsi_register_transport(struct iscsi_transport *tt);
+extern struct scsi_transport_template *iscsi_register_transport(struct iscsi_transport *tt);
 extern int iscsi_unregister_transport(struct iscsi_transport *tt);
 
 /*
+ * iscsi host setup/destroy/queue calls
+ */
+extern struct iscsi_host *iscsi_alloc_iscsi_host(struct iscsi_transport *xpt,
+				struct scsi_transport_template *scsi_transport);
+extern int iscsi_add_iscsi_host(struct iscsi_host *ihost, struct device *dev,
+				const char *name);
+extern void iscsi_remove_iscsi_host(struct iscsi_host *ihost);
+extern void iscsi_host_put(struct iscsi_host *ihost);
+extern struct iscsi_host *iscsi_find_iscsi_host(const char *bus_id);
+extern int iscsi_scsi_queuecmd(struct scsi_cmnd *cmd,
+			       void (*done)(struct scsi_cmnd *));
+
+/*
  * control plane upcalls
  */
 extern void iscsi_conn_error(iscsi_connh_t conn, enum iscsi_err error);


