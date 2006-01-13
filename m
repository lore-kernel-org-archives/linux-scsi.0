From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/10] iscsi: seperate iscsi interface from setup functions
Date: Thu, 12 Jan 2006 23:08:39 -0600
Message-ID: <1137128919.9508.39.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:944 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964925AbWAMFJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:09:06 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D594xA016454
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:09:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie <michaelc@cs.wisc.edu>"

HW iscsi LLDs like qla4xxx cannot use the iscsi class becuase
the scsi_host is tied to the interface and class code. This patch
just seperates the session and connection creation code from
the sysfs and netlink interface code so that HW iscsi can use
the class.

This is also fixes a couple refcount bugs that can be triggered
when users have a sysfs file open, close the session, then
read or write to the file.


Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b9d2bb8..1261a4f 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -164,6 +164,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
 libata-objs	:= libata-core.o libata-scsi.o
+scsi_transport_iscsi-objs := libiscsi.o iscsi_if.o
 
 # Files generated that shall be removed upon make clean
 clean-files :=	53c7xx_d.h 53c700_d.h	\
diff --git a/drivers/scsi/iscsi_if.c b/drivers/scsi/iscsi_if.c
new file mode 100644
index 0000000..5fb6457
--- /dev/null
+++ b/drivers/scsi/iscsi_if.c
@@ -0,0 +1,1093 @@
+/*
+ * iSCSI transport class definitions
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
+#include <linux/mempool.h>
+#include <net/tcp.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/iscsi_if.h>
+
+#define ISCSI_SESSION_ATTRS 8
+#define ISCSI_CONN_ATTRS 6
+
+struct iscsi_internal {
+	struct scsi_transport_template t;
+	struct iscsi_transport *iscsi_transport;
+	struct list_head list;
+	/*
+	 * List of sessions for this transport
+	 */
+	struct list_head sessions;
+	/*
+	 * based on transport capabilities, at register time we set these
+	 * bits to tell the transport class it wants attributes displayed
+	 * in sysfs or that it can support different iSCSI Data-Path
+	 * capabilities
+	 */
+	uint32_t param_mask;
+
+	struct class_device cdev;
+	/*
+	 * We do not have any private or other attrs.
+	 */
+	struct transport_container conn_cont;
+	struct class_device_attribute *conn_attrs[ISCSI_CONN_ATTRS + 1];
+	struct transport_container session_cont;
+	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
+};
+
+/*
+ * list of registered transports and lock that must
+ * be held while accessing list. The iscsi_transport_lock must
+ * be acquired after the rx_queue_sema.
+ */
+static LIST_HEAD(iscsi_transports);
+static DEFINE_SPINLOCK(iscsi_transport_lock);
+
+#define to_iscsi_internal(tmpl) \
+	container_of(tmpl, struct iscsi_internal, t)
+
+#define cdev_to_iscsi_internal(_cdev) \
+	container_of(_cdev, struct iscsi_internal, cdev)
+
+static void iscsi_transport_release(struct class_device *cdev)
+{
+	struct iscsi_internal *priv = cdev_to_iscsi_internal(cdev);
+	kfree(priv);
+}
+
+/*
+ * iscsi_transport_class represents the iscsi_transports that are
+ * registered.
+ */
+static struct class iscsi_transport_class = {
+	.name = "iscsi_transport",
+	.release = iscsi_transport_release,
+};
+
+static ssize_t
+show_transport_handle(struct class_device *cdev, char *buf)
+{
+	struct iscsi_internal *priv = cdev_to_iscsi_internal(cdev);
+	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->iscsi_transport));
+}
+static CLASS_DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
+
+#define show_transport_attr(name, format)				\
+static ssize_t								\
+show_transport_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct iscsi_internal *priv = cdev_to_iscsi_internal(cdev);	\
+	return sprintf(buf, format"\n", priv->iscsi_transport->name);	\
+}									\
+static CLASS_DEVICE_ATTR(name, S_IRUGO, show_transport_##name, NULL);
+
+show_transport_attr(caps, "0x%x");
+show_transport_attr(max_lun, "%d");
+show_transport_attr(max_conn, "%d");
+show_transport_attr(max_cmd_len, "%d");
+
+static struct attribute *iscsi_transport_attrs[] = {
+	&class_device_attr_handle.attr,
+	&class_device_attr_caps.attr,
+	&class_device_attr_max_lun.attr,
+	&class_device_attr_max_conn.attr,
+	&class_device_attr_max_cmd_len.attr,
+	NULL,
+};
+
+static struct attribute_group iscsi_transport_group = {
+	.attrs = iscsi_transport_attrs,
+};
+
+static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
+			       "iscsi_session",
+			       NULL,
+			       NULL,
+			       NULL);
+
+static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
+			       "iscsi_connection",
+			       NULL,
+			       NULL,
+			       NULL);
+
+static struct sock *nls;
+static int daemon_pid;
+static DECLARE_MUTEX(rx_queue_sema);
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
+static struct mempool_zone *z_reply;
+
+/*
+ * Z_MAX_* - actual mempool size allocated at the mempool_zone_init() time
+ * Z_HIWAT_* - zone's high watermark when if_error bit will be set to -ENOMEM
+ *             so daemon will notice OOM on NETLINK tranposrt level and will
+ *             be able to predict or change operational behavior
+ */
+#define Z_MAX_REPLY	8
+#define Z_HIWAT_REPLY	6
+#define Z_MAX_PDU	8
+#define Z_HIWAT_PDU	6
+#define Z_MAX_ERROR	16
+#define Z_HIWAT_ERROR	12
+
+static LIST_HEAD(connlist);
+static DEFINE_SPINLOCK(connlock);
+
+/*
+ * can we replace this with some sort of container of use
+ */
+static struct iscsi_cls_conn*
+iscsi_if_find_conn(uint64_t key)
+{
+	unsigned long flags;
+	struct iscsi_cls_conn *conn;
+
+	spin_lock_irqsave(&connlock, flags);
+	list_for_each_entry(conn, &connlist, conn_list)
+		if (conn->connh == key) {
+			spin_unlock_irqrestore(&connlock, flags);
+			return conn;
+		}
+	spin_unlock_irqrestore(&connlock, flags);
+	return NULL;
+}
+
+static struct iscsi_internal *
+iscsi_if_transport_lookup(struct iscsi_transport *tt)
+{
+	struct iscsi_internal *priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iscsi_transport_lock, flags);
+	list_for_each_entry(priv, &iscsi_transports, list) {
+		if (tt == priv->iscsi_transport) {
+			spin_unlock_irqrestore(&iscsi_transport_lock, flags);
+			return priv;
+		}
+	}
+	spin_unlock_irqrestore(&iscsi_transport_lock, flags);
+	return NULL;
+}
+
+static inline struct list_head *skb_to_lh(struct sk_buff *skb)
+{
+	return (struct list_head *)&skb->cb;
+}
+
+static void*
+mempool_zone_alloc_skb(unsigned int gfp_mask, void *pool_data)
+{
+	struct mempool_zone *zone = pool_data;
+
+	return alloc_skb(zone->size, gfp_mask);
+}
+
+static void
+mempool_zone_free_skb(void *element, void *pool_data)
+{
+	kfree_skb(element);
+}
+
+static void
+mempool_zone_complete(struct mempool_zone *zone)
+{
+	unsigned long flags;
+	struct list_head *lh, *n;
+
+	spin_lock_irqsave(&zone->freelock, flags);
+	list_for_each_safe(lh, n, &zone->freequeue) {
+		struct sk_buff *skb = (struct sk_buff *)((char *)lh -
+				offsetof(struct sk_buff, cb));
+		if (!skb_shared(skb)) {
+			list_del(skb_to_lh(skb));
+			mempool_free(skb, zone->pool);
+			atomic_dec(&zone->allocated);
+		}
+	}
+	spin_unlock_irqrestore(&zone->freelock, flags);
+}
+
+static struct mempool_zone *
+mempool_zone_init(unsigned max, unsigned size, unsigned hiwat)
+{
+	struct mempool_zone *zp;
+
+	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
+	if (!zp)
+		return NULL;
+
+	zp->pool = mempool_create(max, mempool_zone_alloc_skb,
+				  mempool_zone_free_skb, zp);
+	if (!zp->pool) {
+		kfree(zp);
+		return NULL;
+	}
+
+	zp->size = size;
+	zp->hiwat = hiwat;
+
+	INIT_LIST_HEAD(&zp->freequeue);
+	spin_lock_init(&zp->freelock);
+	atomic_set(&zp->allocated, 0);
+
+	return zp;
+}
+
+static void mempool_zone_destroy(struct mempool_zone *zp)
+{
+	mempool_destroy(zp->pool);
+	kfree(zp);
+}
+
+static struct sk_buff*
+mempool_zone_get_skb(struct mempool_zone *zone)
+{
+	struct sk_buff *skb;
+
+	skb = mempool_alloc(zone->pool, GFP_ATOMIC);
+	if (skb)
+		atomic_inc(&zone->allocated);
+	return skb;
+}
+
+static int
+iscsi_unicast_skb(struct mempool_zone *zone, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int rc;
+
+	skb_get(skb);
+	rc = netlink_unicast(nls, skb, daemon_pid, MSG_DONTWAIT);
+	if (rc < 0) {
+		mempool_free(skb, zone->pool);
+		printk(KERN_ERR "iscsi: can not unicast skb (%d)\n", rc);
+		return rc;
+	}
+
+	spin_lock_irqsave(&zone->freelock, flags);
+	list_add(skb_to_lh(skb), &zone->freequeue);
+	spin_unlock_irqrestore(&zone->freelock, flags);
+
+	return 0;
+}
+
+int iscsi_recv_pdu(iscsi_connh_t connh, struct iscsi_hdr *hdr,
+		   char *data, uint32_t data_size)
+{
+	struct nlmsghdr	*nlh;
+	struct sk_buff *skb;
+	struct iscsi_uevent *ev;
+	struct iscsi_cls_conn *conn;
+	char *pdu;
+	int len = NLMSG_SPACE(sizeof(*ev) + sizeof(struct iscsi_hdr) +
+			      data_size);
+
+	conn = iscsi_if_find_conn(connh);
+	BUG_ON(!conn);
+
+	mempool_zone_complete(conn->z_pdu);
+
+	skb = mempool_zone_get_skb(conn->z_pdu);
+	if (!skb) {
+		iscsi_conn_error(connh, ISCSI_ERR_CONN_FAILED);
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not deliver "
+			   "control PDU: OOM\n");
+		return -ENOMEM;
+	}
+
+	nlh = __nlmsg_put(skb, daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	memset(ev, 0, sizeof(*ev));
+	ev->transport_handle = iscsi_handle(conn->transport);
+	ev->type = ISCSI_KEVENT_RECV_PDU;
+	if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
+		ev->iferror = -ENOMEM;
+	ev->r.recv_req.conn_handle = connh;
+	pdu = (char*)ev + sizeof(*ev);
+	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
+	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
+
+	return iscsi_unicast_skb(conn->z_pdu, skb);
+}
+EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
+
+void iscsi_conn_error(iscsi_connh_t connh, enum iscsi_err error)
+{
+	struct nlmsghdr	*nlh;
+	struct sk_buff	*skb;
+	struct iscsi_uevent *ev;
+	struct iscsi_cls_conn *conn;
+	int len = NLMSG_SPACE(sizeof(*ev));
+
+	conn = iscsi_if_find_conn(connh);
+	BUG_ON(!conn);
+
+	mempool_zone_complete(conn->z_error);
+
+	skb = mempool_zone_get_skb(conn->z_error);
+	if (!skb) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: gracefully ignored "
+			  "conn error (%d)\n", error);
+		return;
+	}
+
+	nlh = __nlmsg_put(skb, daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	ev->transport_handle = iscsi_handle(conn->transport);
+	ev->type = ISCSI_KEVENT_CONN_ERROR;
+	if (atomic_read(&conn->z_error->allocated) >= conn->z_error->hiwat)
+		ev->iferror = -ENOMEM;
+	ev->r.connerror.error = error;
+	ev->r.connerror.conn_handle = connh;
+
+	iscsi_unicast_skb(conn->z_error, skb);
+
+	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
+		   error);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_error);
+
+static int
+iscsi_if_send_reply(int pid, int seq, int type, int done, int multi,
+		      void *payload, int size)
+{
+	struct sk_buff	*skb;
+	struct nlmsghdr	*nlh;
+	int len = NLMSG_SPACE(size);
+	int flags = multi ? NLM_F_MULTI : 0;
+	int t = done ? NLMSG_DONE : type;
+
+	mempool_zone_complete(z_reply);
+
+	skb = mempool_zone_get_skb(z_reply);
+	/*
+	 * FIXME:
+	 * user is supposed to react on iferror == -ENOMEM;
+	 * see iscsi_if_rx().
+	 */
+	BUG_ON(!skb);
+
+	nlh = __nlmsg_put(skb, pid, seq, t, (len - sizeof(*nlh)), 0);
+	nlh->nlmsg_flags = flags;
+	memcpy(NLMSG_DATA(nlh), payload, size);
+	return iscsi_unicast_skb(z_reply, skb);
+}
+
+/*
+ * iSCSI Session's hostdata organization:
+ *
+ *    *------------------* <== hostdata_session(host->hostdata)
+ *    | ptr to class sess|
+ *    |------------------| <== iscsi_hostdata(host->hostdata)
+ *    | transport's data |
+ *    *------------------*
+ */
+
+#define hostdata_privsize(_t)	(sizeof(unsigned long) + _t->hostdata_size + \
+				 _t->hostdata_size % sizeof(unsigned long))
+
+#define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
+
+static int
+iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
+{
+	struct iscsi_transport *transport = priv->iscsi_transport;
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	int err;
+
+	shost = scsi_host_alloc(transport->host_template,
+				hostdata_privsize(transport));
+	if (!shost) {
+		printk(KERN_ERR "iscsi: can not allocate SCSI host for "
+			"session\n");
+		return -ENOMEM;
+	}
+
+	shost->max_id = 1;
+	shost->max_channel = 0;
+	shost->max_lun = transport->max_lun;
+	shost->max_cmd_len = transport->max_cmd_len;
+	shost->transportt = &priv->t;
+
+	err = scsi_add_host(shost, NULL);
+	if (err)
+		goto free_host;
+
+	session = iscsi_create_session(shost, transport, shost->host_no,
+				       ev->u.c_session.initial_cmdsn);
+	if (!session) {
+		ev->r.c_session_ret.session_handle = iscsi_handle(NULL);
+		err = -ENOMEM;
+		goto remove_host;
+	}
+
+	*(unsigned long*)shost->hostdata = (unsigned long)session;
+	ev->r.c_session_ret.session_handle = iscsi_handle(iscsi_hostdata(shost->hostdata));
+	ev->r.c_session_ret.sid = shost->host_no;
+	return 0;
+
+remove_host:
+	scsi_remove_host(shost);
+free_host:
+	scsi_host_put(shost);
+	return err;
+}
+
+static int
+iscsi_if_destroy_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
+{
+	struct Scsi_Host *shost;
+	struct iscsi_cls_session *session;
+
+	shost = scsi_host_lookup(ev->u.d_session.sid);
+	if (shost == ERR_PTR(-ENXIO))
+		return -EEXIST;
+
+	scsi_remove_host(shost);
+
+	session = hostdata_session(shost->hostdata);
+	iscsi_destroy_session(session);
+
+	/* ref from host alloc */
+	scsi_host_put(shost);
+	/* ref from host lookup */
+	scsi_host_put(shost);
+	return 0;
+}
+
+static int
+iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+{
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	struct iscsi_cls_conn *conn;
+	unsigned long flags;
+	int error = -ENOMEM;
+
+	shost = scsi_host_lookup(ev->u.c_conn.sid);
+	if (shost == ERR_PTR(-ENXIO))
+		return -EEXIST;
+	session = hostdata_session(shost->hostdata);
+
+	conn = iscsi_create_conn(session, ev->u.c_conn.cid);
+	if (!conn)
+		goto release_ref;
+
+	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
+			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
+				    sizeof(struct iscsi_hdr) +
+				    DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH),
+			Z_HIWAT_PDU);
+	if (!conn->z_pdu) {
+		dev_printk(KERN_ERR, &session->dev, "iscsi: can not allocate "
+			   "pdu zone for new conn\n");
+		goto destroy_conn;
+	}
+
+	conn->z_error = mempool_zone_init(Z_MAX_ERROR,
+			NLMSG_SPACE(sizeof(struct iscsi_uevent)),
+			Z_HIWAT_ERROR);
+	if (!conn->z_error) {
+		dev_printk(KERN_ERR, &session->dev, "iscsi: can not allocate "
+			   "error zone for new conn\n");
+		goto free_pdu_pool;
+	}
+
+	ev->r.handle = conn->connh = iscsi_handle(conn->dd_data);
+
+	spin_lock_irqsave(&connlock, flags);
+	list_add(&conn->conn_list, &connlist);
+	conn->active = 1;
+	spin_unlock_irqrestore(&connlock, flags);
+
+	scsi_host_put(shost);
+	return 0;
+
+free_pdu_pool:
+	mempool_zone_destroy(conn->z_pdu);
+destroy_conn:
+	iscsi_destroy_conn(conn);
+release_ref:
+	scsi_host_put(shost);
+	return error;
+}
+
+static int
+iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+{
+	unsigned long flags;
+	struct iscsi_cls_conn *conn;
+
+	conn = iscsi_if_find_conn(ev->u.d_conn.conn_handle);
+	if (!conn)
+		return -EEXIST;
+
+	spin_lock_irqsave(&connlock, flags);
+	conn->active = 0;
+	list_del(&conn->conn_list);
+	spin_unlock_irqrestore(&connlock, flags);
+
+	mempool_zone_destroy(conn->z_pdu);
+	mempool_zone_destroy(conn->z_error);
+
+	iscsi_destroy_conn(conn);
+	return 0;
+}
+
+static int
+iscsi_if_get_stats(struct iscsi_transport *transport, struct sk_buff *skb,
+		   struct nlmsghdr *nlh)
+{
+	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
+	struct iscsi_stats *stats;
+	struct sk_buff *skbstat;
+	struct iscsi_cls_conn *conn;
+	struct nlmsghdr	*nlhstat;
+	struct iscsi_uevent *evstat;
+	int len = NLMSG_SPACE(sizeof(*ev) +
+			      sizeof(struct iscsi_stats) +
+			      sizeof(struct iscsi_stats_custom) *
+			      ISCSI_STATS_CUSTOM_MAX);
+	int err = 0;
+
+	conn = iscsi_if_find_conn(ev->u.get_stats.conn_handle);
+	if (!conn)
+		return -EEXIST;
+
+	do {
+		int actual_size;
+
+		mempool_zone_complete(conn->z_pdu);
+
+		skbstat = mempool_zone_get_skb(conn->z_pdu);
+		if (!skbstat) {
+			dev_printk(KERN_ERR, &conn->dev, "iscsi: can not "
+				   "deliver stats: OOM\n");
+			return -ENOMEM;
+		}
+
+		nlhstat = __nlmsg_put(skbstat, daemon_pid, 0, 0,
+				      (len - sizeof(*nlhstat)), 0);
+		evstat = NLMSG_DATA(nlhstat);
+		memset(evstat, 0, sizeof(*evstat));
+		evstat->transport_handle = iscsi_handle(conn->transport);
+		evstat->type = nlh->nlmsg_type;
+		if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
+			evstat->iferror = -ENOMEM;
+		evstat->u.get_stats.conn_handle =
+			ev->u.get_stats.conn_handle;
+		stats = (struct iscsi_stats *)
+			((char*)evstat + sizeof(*evstat));
+		memset(stats, 0, sizeof(*stats));
+
+		transport->get_stats(ev->u.get_stats.conn_handle, stats);
+		actual_size = NLMSG_SPACE(sizeof(struct iscsi_uevent) +
+					  sizeof(struct iscsi_stats) +
+					  sizeof(struct iscsi_stats_custom) *
+					  stats->custom_length);
+		actual_size -= sizeof(*nlhstat);
+		actual_size = NLMSG_LENGTH(actual_size);
+		skb_trim(skb, NLMSG_ALIGN(actual_size));
+		nlhstat->nlmsg_len = actual_size;
+
+		err = iscsi_unicast_skb(conn->z_pdu, skbstat);
+	} while (err < 0 && err != -ECONNREFUSED);
+
+	return err;
+}
+
+static int
+iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	int err = 0;
+	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
+	struct iscsi_transport *transport = NULL;
+	struct iscsi_internal *priv;
+
+	if (NETLINK_CREDS(skb)->uid)
+		return -EPERM;
+
+	priv = iscsi_if_transport_lookup(iscsi_ptr(ev->transport_handle));
+	if (!priv)
+		return -EINVAL;
+	transport = priv->iscsi_transport;
+
+	daemon_pid = NETLINK_CREDS(skb)->pid;
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_CREATE_SESSION:
+		err = iscsi_if_create_session(priv, ev);
+		break;
+	case ISCSI_UEVENT_DESTROY_SESSION:
+		err = iscsi_if_destroy_session(priv, ev);
+		break;
+	case ISCSI_UEVENT_CREATE_CONN:
+		err = iscsi_if_create_conn(transport, ev);
+		break;
+	case ISCSI_UEVENT_DESTROY_CONN:
+		err = iscsi_if_destroy_conn(transport, ev);
+		break;
+	case ISCSI_UEVENT_BIND_CONN:
+		if (!iscsi_if_find_conn(ev->u.b_conn.conn_handle))
+			return -EEXIST;
+		ev->r.retcode = transport->bind_conn(
+			ev->u.b_conn.session_handle,
+			ev->u.b_conn.conn_handle,
+			ev->u.b_conn.transport_fd,
+			ev->u.b_conn.is_leading);
+		break;
+	case ISCSI_UEVENT_SET_PARAM:
+		if (!iscsi_if_find_conn(ev->u.set_param.conn_handle))
+			return -EEXIST;
+		ev->r.retcode = transport->set_param(
+			ev->u.set_param.conn_handle,
+			ev->u.set_param.param, ev->u.set_param.value);
+		break;
+	case ISCSI_UEVENT_START_CONN:
+		if (!iscsi_if_find_conn(ev->u.start_conn.conn_handle))
+			return -EEXIST;
+		ev->r.retcode = transport->start_conn(
+			ev->u.start_conn.conn_handle);
+		break;
+	case ISCSI_UEVENT_STOP_CONN:
+		if (!iscsi_if_find_conn(ev->u.stop_conn.conn_handle))
+			return -EEXIST;
+		transport->stop_conn(ev->u.stop_conn.conn_handle,
+			ev->u.stop_conn.flag);
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		if (!iscsi_if_find_conn(ev->u.send_pdu.conn_handle))
+			return -EEXIST;
+		ev->r.retcode = transport->send_pdu(
+		       ev->u.send_pdu.conn_handle,
+		       (struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
+		       (char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
+			ev->u.send_pdu.data_size);
+		break;
+	case ISCSI_UEVENT_GET_STATS:
+		err = iscsi_if_get_stats(transport, skb, nlh);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+/* Get message from skb (based on rtnetlink_rcv_skb).  Each message is
+ * processed by iscsi_if_recv_msg.  Malformed skbs with wrong length are
+ * discarded silently.  */
+static void
+iscsi_if_rx(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+
+	down(&rx_queue_sema);
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		while (skb->len >= NLMSG_SPACE(0)) {
+			int err;
+			uint32_t rlen;
+			struct nlmsghdr	*nlh;
+			struct iscsi_uevent *ev;
+
+			nlh = (struct nlmsghdr *)skb->data;
+			if (nlh->nlmsg_len < sizeof(*nlh) ||
+			    skb->len < nlh->nlmsg_len) {
+				break;
+			}
+			ev = NLMSG_DATA(nlh);
+			rlen = NLMSG_ALIGN(nlh->nlmsg_len);
+			if (rlen > skb->len)
+				rlen = skb->len;
+			err = iscsi_if_recv_msg(skb, nlh);
+			if (err) {
+				ev->type = ISCSI_KEVENT_IF_ERROR;
+				ev->iferror = err;
+			}
+			do {
+				/*
+				 * special case for GET_STATS:
+				 * on success - sending reply and stats from
+				 * inside of if_recv_msg(),
+				 * on error - fall through.
+				 */
+				if (ev->type == ISCSI_UEVENT_GET_STATS && !err)
+					break;
+				err = iscsi_if_send_reply(
+					NETLINK_CREDS(skb)->pid, nlh->nlmsg_seq,
+					nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
+				if (atomic_read(&z_reply->allocated) >=
+						z_reply->hiwat)
+					ev->iferror = -ENOMEM;
+			} while (err < 0 && err != -ECONNREFUSED);
+			skb_pull(skb, rlen);
+		}
+		kfree_skb(skb);
+	}
+	up(&rx_queue_sema);
+}
+
+#define iscsi_cdev_to_conn(_cdev) \
+	iscsi_dev_to_conn(_cdev->dev)
+
+/*
+ * iSCSI connection attrs
+ */
+#define iscsi_conn_int_attr_show(param, format)				\
+static ssize_t								\
+show_conn_int_param_##param(struct class_device *cdev, char *buf)	\
+{									\
+	uint32_t value = 0;						\
+	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
+	struct iscsi_transport *t = conn->transport;			\
+									\
+	t->get_conn_param(conn->dd_data, param, &value);		\
+	return snprintf(buf, 20, format"\n", value);			\
+}
+
+#define iscsi_conn_int_attr(field, param, format)			\
+	iscsi_conn_int_attr_show(param, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_conn_int_param_##param, NULL);
+
+iscsi_conn_int_attr(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH, "%u");
+iscsi_conn_int_attr(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH, "%u");
+iscsi_conn_int_attr(header_digest, ISCSI_PARAM_HDRDGST_EN, "%d");
+iscsi_conn_int_attr(data_digest, ISCSI_PARAM_DATADGST_EN, "%d");
+iscsi_conn_int_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN, "%d");
+iscsi_conn_int_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN, "%d");
+
+#define iscsi_cdev_to_session(_cdev) \
+	iscsi_dev_to_session(_cdev->dev)
+
+/*
+ * iSCSI session attrs
+ */
+#define iscsi_session_int_attr_show(param, format)			\
+static ssize_t								\
+show_session_int_param_##param(struct class_device *cdev, char *buf)	\
+{									\
+	uint32_t value = 0;						\
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);	\
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
+	struct iscsi_transport *t = session->transport;			\
+									\
+	t->get_session_param(shost, param, &value);			\
+	return snprintf(buf, 20, format"\n", value);			\
+}
+
+#define iscsi_session_int_attr(field, param, format)			\
+	iscsi_session_int_attr_show(param, format)			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_int_param_##param, NULL);
+
+iscsi_session_int_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN, "%d");
+iscsi_session_int_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T, "%hu");
+iscsi_session_int_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN, "%d");
+iscsi_session_int_attr(first_burst_len, ISCSI_PARAM_FIRST_BURST, "%u");
+iscsi_session_int_attr(max_burst_len, ISCSI_PARAM_MAX_BURST, "%u");
+iscsi_session_int_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN, "%d");
+iscsi_session_int_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN, "%d");
+iscsi_session_int_attr(erl, ISCSI_PARAM_ERL, "%d");
+
+#define SETUP_SESSION_RD_ATTR(field, param)				\
+	if (priv->param_mask & (1 << param)) {				\
+		priv->session_attrs[count] = &class_device_attr_##field;\
+		count++;						\
+	}
+
+#define SETUP_CONN_RD_ATTR(field, param)				\
+	if (priv->param_mask & (1 << param)) {				\
+		priv->conn_attrs[count] = &class_device_attr_##field;	\
+		count++;						\
+	}
+
+static int iscsi_session_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	struct iscsi_internal *priv;
+
+	if (!iscsi_is_session_dev(dev))
+		return 0;
+
+	session = iscsi_dev_to_session(dev);
+	shost = iscsi_session_to_shost(session);
+	if (!shost->transportt)
+		return 0;
+
+	priv = to_iscsi_internal(shost->transportt);
+	if (priv->session_cont.ac.class != &iscsi_session_class.class)
+		return 0;
+
+	return &priv->session_cont.ac == cont;
+}
+
+static int iscsi_conn_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn;
+	struct Scsi_Host *shost;
+	struct iscsi_internal *priv;
+
+	if (!iscsi_is_conn_dev(dev))
+		return 0;
+
+	conn = iscsi_dev_to_conn(dev);
+	session = iscsi_dev_to_session(conn->dev.parent);
+	shost = iscsi_session_to_shost(session);
+
+	if (!shost->transportt)
+		return 0;
+
+	priv = to_iscsi_internal(shost->transportt);
+	if (priv->conn_cont.ac.class != &iscsi_connection_class.class)
+		return 0;
+
+	return &priv->conn_cont.ac == cont;
+}
+
+struct scsi_transport_template *
+iscsi_register_transport(struct iscsi_transport *tt)
+{
+	struct iscsi_internal *priv;
+	unsigned long flags;
+	int count = 0, err;
+
+	BUG_ON(!tt);
+
+	priv = iscsi_if_transport_lookup(tt);
+	if (priv)
+		return NULL;
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+	memset(priv, 0, sizeof(*priv));
+	INIT_LIST_HEAD(&priv->list);
+	INIT_LIST_HEAD(&priv->sessions);
+	priv->iscsi_transport = tt;
+
+	priv->cdev.class = &iscsi_transport_class;
+	snprintf(priv->cdev.class_id, BUS_ID_SIZE, "%s", tt->name);
+	err = class_device_register(&priv->cdev);
+	if (err)
+		goto free_priv;
+
+	err = sysfs_create_group(&priv->cdev.kobj, &iscsi_transport_group);
+	if (err)
+		goto unregister_cdev;
+
+	/* setup parameters mask */
+	priv->param_mask = 0xFFFFFFFF;
+	if (!(tt->caps & CAP_MULTI_R2T))
+		priv->param_mask &= ~(1 << ISCSI_PARAM_MAX_R2T);
+	if (!(tt->caps & CAP_HDRDGST))
+		priv->param_mask &= ~(1 << ISCSI_PARAM_HDRDGST_EN);
+	if (!(tt->caps & CAP_DATADGST))
+		priv->param_mask &= ~(1 << ISCSI_PARAM_DATADGST_EN);
+	if (!(tt->caps & CAP_MARKERS)) {
+		priv->param_mask &= ~(1 << ISCSI_PARAM_IFMARKER_EN);
+		priv->param_mask &= ~(1 << ISCSI_PARAM_OFMARKER_EN);
+	}
+
+	/* connection parameters */
+	priv->conn_cont.ac.attrs = &priv->conn_attrs[0];
+	priv->conn_cont.ac.class = &iscsi_connection_class.class;
+	priv->conn_cont.ac.match = iscsi_conn_match;
+	transport_container_register(&priv->conn_cont);
+
+	SETUP_CONN_RD_ATTR(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH);
+	SETUP_CONN_RD_ATTR(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH);
+	SETUP_CONN_RD_ATTR(header_digest, ISCSI_PARAM_HDRDGST_EN);
+	SETUP_CONN_RD_ATTR(data_digest, ISCSI_PARAM_DATADGST_EN);
+	SETUP_CONN_RD_ATTR(ifmarker, ISCSI_PARAM_IFMARKER_EN);
+	SETUP_CONN_RD_ATTR(ofmarker, ISCSI_PARAM_OFMARKER_EN);
+
+	BUG_ON(count > ISCSI_CONN_ATTRS);
+	priv->conn_attrs[count] = NULL;
+	count = 0;
+
+	/* session parameters */
+	priv->session_cont.ac.attrs = &priv->session_attrs[0];
+	priv->session_cont.ac.class = &iscsi_session_class.class;
+	priv->session_cont.ac.match = iscsi_session_match;
+	transport_container_register(&priv->session_cont);
+
+	SETUP_SESSION_RD_ATTR(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN);
+	SETUP_SESSION_RD_ATTR(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T);
+	SETUP_SESSION_RD_ATTR(immediate_data, ISCSI_PARAM_IMM_DATA_EN);
+	SETUP_SESSION_RD_ATTR(first_burst_len, ISCSI_PARAM_FIRST_BURST);
+	SETUP_SESSION_RD_ATTR(max_burst_len, ISCSI_PARAM_MAX_BURST);
+	SETUP_SESSION_RD_ATTR(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN);
+	SETUP_SESSION_RD_ATTR(data_seq_in_order,ISCSI_PARAM_DATASEQ_INORDER_EN)
+	SETUP_SESSION_RD_ATTR(erl, ISCSI_PARAM_ERL);
+
+	BUG_ON(count > ISCSI_SESSION_ATTRS);
+	priv->session_attrs[count] = NULL;
+
+	spin_lock_irqsave(&iscsi_transport_lock, flags);
+	list_add(&priv->list, &iscsi_transports);
+	spin_unlock_irqrestore(&iscsi_transport_lock, flags);
+
+	printk(KERN_NOTICE "iscsi: registered transport (%s)\n", tt->name);
+	return &priv->t;
+
+unregister_cdev:
+	class_device_unregister(&priv->cdev);
+free_priv:
+	kfree(priv);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iscsi_register_transport);
+
+int iscsi_unregister_transport(struct iscsi_transport *tt)
+{
+	struct iscsi_internal *priv;
+	unsigned long flags;
+
+	BUG_ON(!tt);
+
+	down(&rx_queue_sema);
+
+	priv = iscsi_if_transport_lookup(tt);
+	BUG_ON (!priv);
+
+	spin_lock_irqsave(&iscsi_transport_lock, flags);
+	list_del(&priv->list);
+	spin_unlock_irqrestore(&iscsi_transport_lock, flags);
+
+	transport_container_unregister(&priv->conn_cont);
+	transport_container_unregister(&priv->session_cont);
+
+	sysfs_remove_group(&priv->cdev.kobj, &iscsi_transport_group);
+	class_device_unregister(&priv->cdev);
+	up(&rx_queue_sema);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
+
+static int
+iscsi_rcv_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	if (event == NETLINK_URELEASE &&
+	    n->protocol == NETLINK_ISCSI && n->pid) {
+		struct iscsi_cls_conn *conn;
+		unsigned long flags;
+
+		mempool_zone_complete(z_reply);
+		spin_lock_irqsave(&connlock, flags);
+		list_for_each_entry(conn, &connlist, conn_list) {
+			mempool_zone_complete(conn->z_error);
+			mempool_zone_complete(conn->z_pdu);
+		}
+		spin_unlock_irqrestore(&connlock, flags);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block iscsi_nl_notifier = {
+	.notifier_call	= iscsi_rcv_nl_event,
+};
+
+static __init int iscsi_transport_init(void)
+{
+	int err;
+
+	err = class_register(&iscsi_transport_class);
+	if (err)
+		return err;
+
+	err = transport_class_register(&iscsi_connection_class);
+	if (err)
+		goto unregister_transport_class;
+
+	err = transport_class_register(&iscsi_session_class);
+	if (err)
+		goto unregister_conn_class;
+
+	err = netlink_register_notifier(&iscsi_nl_notifier);
+	if (err)
+		goto unregister_session_class;
+
+	nls = netlink_kernel_create(NETLINK_ISCSI, 1, iscsi_if_rx,
+			THIS_MODULE);
+	if (!nls) {
+		err = -ENOBUFS;
+		goto unregister_notifier;
+	}
+
+	z_reply = mempool_zone_init(Z_MAX_REPLY,
+		NLMSG_SPACE(sizeof(struct iscsi_uevent)), Z_HIWAT_REPLY);
+	if (z_reply)
+		return 0;
+
+	sock_release(nls->sk_socket);
+unregister_notifier:
+	netlink_unregister_notifier(&iscsi_nl_notifier);
+unregister_session_class:
+	transport_class_unregister(&iscsi_session_class);
+unregister_conn_class:
+	transport_class_unregister(&iscsi_connection_class);
+unregister_transport_class:
+	class_unregister(&iscsi_transport_class);
+	return err;
+}
+
+static void __exit iscsi_transport_exit(void)
+{
+	mempool_zone_destroy(z_reply);
+	sock_release(nls->sk_socket);
+	netlink_unregister_notifier(&iscsi_nl_notifier);
+	transport_class_unregister(&iscsi_connection_class);
+	transport_class_unregister(&iscsi_session_class);
+	class_unregister(&iscsi_transport_class);
+}
+
+module_init(iscsi_transport_init);
+module_exit(iscsi_transport_exit);
+
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
+	      "Dmitry Yusupov <dmitry_yus@yahoo.com>, "
+	      "Alex Aizman <itn780@yahoo.com>");
+MODULE_DESCRIPTION("iSCSI Transport Interface");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0acc4b2..ccffd98 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2435,17 +2435,13 @@ iscsi_pool_free(struct iscsi_queue *q, v
 	kfree(items);
 }
 
-static iscsi_connh_t
-iscsi_conn_create(iscsi_sessionh_t sessionh, uint32_t conn_idx)
+static int 
+iscsi_conn_create(struct Scsi_Host *shost, void *conndata, uint32_t conn_idx)
 {
-	struct iscsi_session *session = iscsi_ptr(sessionh);
-	struct iscsi_conn *conn = NULL;
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_conn *conn = conndata;
 
-	conn = kmalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
-	if (conn == NULL)
-		goto conn_alloc_fail;
 	memset(conn, 0, sizeof(struct iscsi_conn));
-
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	conn->id = conn_idx;
@@ -2507,7 +2503,7 @@ iscsi_conn_create(iscsi_sessionh_t sessi
 	mutex_init(&conn->xmitmutex);
 	init_waitqueue_head(&conn->ehwait);
 
-	return iscsi_handle(conn);
+	return 0;
 
 max_recv_dlenght_alloc_fail:
 	spin_lock_bh(&session->lock);
@@ -2523,15 +2519,13 @@ immqueue_alloc_fail:
 writequeue_alloc_fail:
 	kfifo_free(conn->xmitqueue);
 xmitqueue_alloc_fail:
-	kfree(conn);
-conn_alloc_fail:
-	return iscsi_handle(NULL);
+	return -ENOMEM;
 }
 
 static void
-iscsi_conn_destroy(iscsi_connh_t connh)
+iscsi_conn_destroy(void *data)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = data;
 	struct iscsi_session *session = conn->session;
 	unsigned long flags;
 
@@ -2626,7 +2620,6 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	kfifo_free(conn->writequeue);
 	kfifo_free(conn->immqueue);
 	kfifo_free(conn->mgmtqueue);
-	kfree(conn);
 }
 
 static int
@@ -3257,17 +3250,14 @@ static struct scsi_host_template iscsi_s
 	.this_id		= -1,
 };
 
-static iscsi_sessionh_t
-iscsi_session_create(uint32_t initial_cmdsn, struct Scsi_Host *host)
+static int
+iscsi_session_create(struct Scsi_Host *shost, uint32_t initial_cmdsn)
 {
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	int cmd_i;
-	struct iscsi_session *session;
 
-	session = iscsi_hostdata(host->hostdata);
 	memset(session, 0, sizeof(struct iscsi_session));
-
-	session->host = host;
-	session->id = host->host_no;
+	session->host =  shost;
 	session->state = ISCSI_STATE_LOGGED_IN;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = ISCSI_XMIT_CMDS_MAX;
@@ -3311,7 +3301,7 @@ iscsi_session_create(uint32_t initial_cm
 	if (iscsi_r2tpool_alloc(session))
 		goto r2tpool_alloc_fail;
 
-	return iscsi_handle(session);
+	return 0;
 
 r2tpool_alloc_fail:
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
@@ -3321,15 +3311,15 @@ immdata_alloc_fail:
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 cmdpool_alloc_fail:
-	return iscsi_handle(NULL);
+	return -ENOMEM;
 }
 
 static void
-iscsi_session_destroy(iscsi_sessionh_t sessionh)
+iscsi_session_destroy(struct Scsi_Host *shost)
 {
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	int cmd_i;
 	struct iscsi_data_task *dtask, *n;
-	struct iscsi_session *session = iscsi_ptr(sessionh);
 
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
@@ -3493,25 +3483,12 @@ iscsi_conn_set_param(iscsi_connh_t connh
 }
 
 static int
-iscsi_conn_get_param(iscsi_connh_t connh, enum iscsi_param param,
-		     uint32_t *value)
+iscsi_session_get_param(struct Scsi_Host *shost,
+			enum iscsi_param param, uint32_t *value)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
-	struct iscsi_session *session = conn->session;
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 
 	switch(param) {
-	case ISCSI_PARAM_MAX_RECV_DLENGTH:
-		*value = conn->max_recv_dlength;
-		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		*value = conn->max_xmit_dlength;
-		break;
-	case ISCSI_PARAM_HDRDGST_EN:
-		*value = conn->hdrdgst_en;
-		break;
-	case ISCSI_PARAM_DATADGST_EN:
-		*value = conn->datadgst_en;
-		break;
 	case ISCSI_PARAM_INITIAL_R2T_EN:
 		*value = session->initial_r2t_en;
 		break;
@@ -3549,6 +3526,31 @@ iscsi_conn_get_param(iscsi_connh_t connh
 	return 0;
 }
 
+static int
+iscsi_conn_get_param(void *data, enum iscsi_param param, uint32_t *value)
+{
+	struct iscsi_conn *conn = data;
+
+	switch(param) {
+	case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		*value = conn->max_recv_dlength;
+		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		*value = conn->max_xmit_dlength;
+		break;
+	case ISCSI_PARAM_HDRDGST_EN:
+		*value = conn->hdrdgst_en;
+		break;
+	case ISCSI_PARAM_DATADGST_EN:
+		*value = conn->datadgst_en;
+		break;
+	default:
+		return ISCSI_ERR_PARAM_NOT_FOUND;
+	}
+
+	return 0;
+}
+
 static void
 iscsi_conn_get_stats(iscsi_connh_t connh, struct iscsi_stats *stats)
 {
@@ -3593,6 +3595,7 @@ static struct iscsi_transport iscsi_tcp_
 				  | CAP_DATADGST,
 	.host_template		= &iscsi_sht,
 	.hostdata_size		= sizeof(struct iscsi_session),
+	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
 	.max_cmd_len		= ISCSI_TCP_MAX_CMD_LEN,
 	.create_session		= iscsi_session_create,
@@ -3601,7 +3604,8 @@ static struct iscsi_transport iscsi_tcp_
 	.bind_conn		= iscsi_conn_bind,
 	.destroy_conn		= iscsi_conn_destroy,
 	.set_param		= iscsi_conn_set_param,
-	.get_param		= iscsi_conn_get_param,
+	.get_conn_param		= iscsi_conn_get_param,
+	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
@@ -3611,8 +3615,6 @@ static struct iscsi_transport iscsi_tcp_
 static int __init
 iscsi_tcp_init(void)
 {
-	int error;
-
 	if (iscsi_max_lun < 1) {
 		printk(KERN_ERR "Invalid max_lun value of %u\n", iscsi_max_lun);
 		return -EINVAL;
@@ -3625,11 +3627,10 @@ iscsi_tcp_init(void)
 	if (!taskcache)
 		return -ENOMEM;
 
-	error = iscsi_register_transport(&iscsi_tcp_transport);
-	if (error)
+	if (!iscsi_register_transport(&iscsi_tcp_transport))
 		kmem_cache_destroy(taskcache);
 
-	return error;
+	return 0;
 }
 
 static void __exit
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
new file mode 100644
index 0000000..9c9412f
--- /dev/null
+++ b/drivers/scsi/libiscsi.c
@@ -0,0 +1,206 @@
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
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
+
+static void iscsi_session_release(struct device *dev)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev);
+	struct iscsi_transport *transport = session->transport;
+	struct Scsi_Host *shost;
+
+	shost = iscsi_session_to_shost(session);
+	scsi_host_put(shost);
+	kfree(session);
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
+ * @shost: scsi host
+ * @transport: iscsi transport
+ * @isid: iscsi isid
+ * @initial_cmdsn: initial iSCSI CmdSN
+ *
+ * This can be called from a LLD or iscsi_interface
+ **/
+struct iscsi_cls_session *
+iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
+		     uint32_t isid, uint32_t initial_cmdsn)
+{
+	struct iscsi_cls_session *session;
+	int err;
+
+	if (!try_module_get(transport->owner))
+		return NULL;
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		goto module_put;
+	session->transport = transport;
+
+	/* initialize session */
+	if (transport->create_session) {
+		err = transport->create_session(shost, initial_cmdsn);
+		if (err)
+			goto free_session;
+	}
+
+	/* this is released in the dev's release function */
+	scsi_host_get(shost);
+	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u", isid);
+	session->dev.parent = &shost->shost_gendev;
+	session->dev.release = iscsi_session_release;
+	err = device_register(&session->dev);
+	if (err) {
+		dev_printk(KERN_ERR, &session->dev, "iscsi: could not "
+			   "register session's dev\n");
+		goto destroy_session;
+	}
+	transport_register_device(&session->dev);
+
+	return session;
+
+destroy_session:
+	if (transport->destroy_session)
+		transport->destroy_session(shost);
+free_session:
+	kfree(session);
+module_put:
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
+int iscsi_destroy_session(struct iscsi_cls_session *session)
+{
+	struct iscsi_transport *transport = session->transport;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+
+	if (transport->destroy_session)
+		transport->destroy_session(shost);
+
+	transport_unregister_device(&session->dev);
+	device_unregister(&session->dev);
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_destroy_session);
+
+static void iscsi_conn_release(struct device *dev)
+{
+	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
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
+struct iscsi_cls_conn *
+iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
+{
+	struct iscsi_transport *transport = session->transport;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_cls_conn *conn;
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
+int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(conn->dev.parent);
+	struct iscsi_transport *transport = session->transport;
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
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index be1bc79..c4160fa 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -168,6 +168,10 @@ typedef uint64_t iscsi_connh_t;		/* iSCS
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
+/**
+ * iscsi_hostdata - get LLD hostdata from scsi_host
+ * @_hostdata: pointer to scsi host's hostdata
+ **/
 #define iscsi_hostdata(_hostdata) ((void*)_hostdata + sizeof(unsigned long))
 
 /*
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f25041c..9a8f9f2 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -23,8 +23,13 @@
 #ifndef SCSI_TRANSPORT_ISCSI_H
 #define SCSI_TRANSPORT_ISCSI_H
 
+#include <linux/device.h>
 #include <scsi/iscsi_if.h>
 
+struct scsi_transport_template;
+struct Scsi_Host;
+struct mempool_zone;
+
 /**
  * struct iscsi_transport - iSCSI Transport template
  *
@@ -48,23 +53,31 @@ struct iscsi_transport {
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
+	int (*create_session) (struct Scsi_Host *shost,
+			       uint32_t initial_cmdsn);
+	void (*destroy_session) (struct Scsi_Host *shost);
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
@@ -73,7 +86,7 @@ struct iscsi_transport {
 /*
  * transport registration upcalls
  */
-extern int iscsi_register_transport(struct iscsi_transport *tt);
+extern struct scsi_transport_template *iscsi_register_transport(struct iscsi_transport *tt);
 extern int iscsi_unregister_transport(struct iscsi_transport *tt);
 
 /*
@@ -83,4 +96,44 @@ extern void iscsi_conn_error(iscsi_connh
 extern int iscsi_recv_pdu(iscsi_connh_t conn, struct iscsi_hdr *hdr,
 			  char *data, uint32_t data_size);
 
+struct iscsi_cls_conn {
+	struct list_head conn_list;	/* item in connlist */
+	void *dd_data;			/* LLD private data */
+	struct iscsi_transport *transport;
+	iscsi_connh_t connh;
+	int active;			/* must be accessed with the connlock */
+	struct device dev;		/* sysfs transport/container device */
+	struct mempool_zone *z_error;
+	struct mempool_zone *z_pdu;
+	struct list_head freequeue;
+};
+
+#define iscsi_dev_to_conn(_dev) \
+	container_of(_dev, struct iscsi_cls_conn, dev)
+
+struct iscsi_cls_session {
+	struct list_head list;	/* item in session_list */
+	struct iscsi_transport *transport;
+	struct device dev;	/* sysfs transport/container device */
+};
+
+#define iscsi_dev_to_session(_dev) \
+	container_of(_dev, struct iscsi_cls_session, dev)
+
+#define iscsi_session_to_shost(_session) \
+	dev_to_shost(_session->dev.parent)
+
+/*
+ * session and connection calls
+ */
+extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
+				struct iscsi_transport *t, uint32_t isid,
+				uint32_t initial_cmdsn);
+extern int iscsi_destroy_session(struct iscsi_cls_session *session);
+extern int iscsi_is_session_dev(const struct device *dev);
+extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
+					    uint32_t cid);
+extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
+extern int iscsi_is_conn_dev(const struct device *dev);
+
 #endif


