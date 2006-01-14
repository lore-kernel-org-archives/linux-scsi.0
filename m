From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 6/8] iscsi: seperate iscsi interface from setup
	functions
Date: Fri, 13 Jan 2006 18:05:50 -0600
Message-ID: <1137197150.2720.38.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32948 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423152AbWANAGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:06:19 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E06H8l021736
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:06:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie <michaelc@cs.wisc.edu>"

This is the second version of the patch to address Christoph's comments.
Instead of doing the lib, I just kept everything in scsi_trnapsort_iscsi.c
like the FC and SPI class. This was becuase the driver model and sysfs
class is tied to the session and connection setup so separating did not
buy very much at this time.

The reason for this patch was becuase HW iscsi LLDs like qla4xxx cannot
use the iscsi class becuase the scsi_host was tied to the interface and
class code. This patch just seperates the session from scsi host so
that LLDs that allocate the host per some resource like pci device
can still use the class.

This is also fixes a couple refcount bugs that can be triggered
when users have a sysfs file open, close the session, then
read or write to the file.


Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0acc4b2..f81f305 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2435,17 +2435,20 @@ iscsi_pool_free(struct iscsi_queue *q, v
 	kfree(items);
 }
 
-static iscsi_connh_t
-iscsi_conn_create(iscsi_sessionh_t sessionh, uint32_t conn_idx)
+static struct iscsi_cls_conn *
+iscsi_conn_create(struct Scsi_Host *shost, uint32_t conn_idx)
 {
-	struct iscsi_session *session = iscsi_ptr(sessionh);
-	struct iscsi_conn *conn = NULL;
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_conn *conn;
+	struct iscsi_cls_conn *cls_conn;
+
+	cls_conn = iscsi_create_conn(hostdata_session(shost->hostdata),
+				     conn_idx);
+	if (!cls_conn)
+		return NULL;
+	conn = cls_conn->dd_data;
 
-	conn = kmalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
-	if (conn == NULL)
-		goto conn_alloc_fail;
 	memset(conn, 0, sizeof(struct iscsi_conn));
-
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	conn->id = conn_idx;
@@ -2507,7 +2510,7 @@ iscsi_conn_create(iscsi_sessionh_t sessi
 	mutex_init(&conn->xmitmutex);
 	init_waitqueue_head(&conn->ehwait);
 
-	return iscsi_handle(conn);
+	return cls_conn;
 
 max_recv_dlenght_alloc_fail:
 	spin_lock_bh(&session->lock);
@@ -2523,15 +2526,14 @@ immqueue_alloc_fail:
 writequeue_alloc_fail:
 	kfifo_free(conn->xmitqueue);
 xmitqueue_alloc_fail:
-	kfree(conn);
-conn_alloc_fail:
-	return iscsi_handle(NULL);
+	iscsi_destroy_conn(cls_conn);
+	return NULL;
 }
 
 static void
-iscsi_conn_destroy(iscsi_connh_t connh)
+iscsi_conn_destroy(struct iscsi_cls_conn *cls_conn)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 	unsigned long flags;
 
@@ -2626,7 +2628,8 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	kfifo_free(conn->writequeue);
 	kfifo_free(conn->immqueue);
 	kfifo_free(conn->mgmtqueue);
-	kfree(conn);
+
+	iscsi_destroy_conn(cls_conn);
 }
 
 static int
@@ -3257,17 +3260,23 @@ static struct scsi_host_template iscsi_s
 	.this_id		= -1,
 };
 
-static iscsi_sessionh_t
-iscsi_session_create(uint32_t initial_cmdsn, struct Scsi_Host *host)
+static struct iscsi_transport iscsi_tcp_transport;
+
+static struct Scsi_Host *
+iscsi_session_create(struct scsi_transport_template *scsit,
+		     uint32_t initial_cmdsn)
 {
-	int cmd_i;
+	struct Scsi_Host *shost;
 	struct iscsi_session *session;
+	int cmd_i;
 
-	session = iscsi_hostdata(host->hostdata);
-	memset(session, 0, sizeof(struct iscsi_session));
+	shost = iscsi_transport_create_session(scsit, &iscsi_tcp_transport);
+	if (!shost)
+		return NULL; 
 
-	session->host = host;
-	session->id = host->host_no;
+	session = iscsi_hostdata(shost->hostdata);
+	memset(session, 0, sizeof(struct iscsi_session));
+	session->host = shost;
 	session->state = ISCSI_STATE_LOGGED_IN;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = ISCSI_XMIT_CMDS_MAX;
@@ -3311,7 +3320,7 @@ iscsi_session_create(uint32_t initial_cm
 	if (iscsi_r2tpool_alloc(session))
 		goto r2tpool_alloc_fail;
 
-	return iscsi_handle(session);
+	return shost;
 
 r2tpool_alloc_fail:
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
@@ -3321,15 +3330,15 @@ immdata_alloc_fail:
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 cmdpool_alloc_fail:
-	return iscsi_handle(NULL);
+	return NULL;
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
@@ -3345,6 +3354,8 @@ iscsi_session_destroy(iscsi_sessionh_t s
 	iscsi_r2tpool_free(session);
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
+
+	iscsi_transport_destroy_session(shost);
 }
 
 static int
@@ -3493,25 +3504,12 @@ iscsi_conn_set_param(iscsi_connh_t connh
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
@@ -3549,6 +3547,31 @@ iscsi_conn_get_param(iscsi_connh_t connh
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
@@ -3593,6 +3616,7 @@ static struct iscsi_transport iscsi_tcp_
 				  | CAP_DATADGST,
 	.host_template		= &iscsi_sht,
 	.hostdata_size		= sizeof(struct iscsi_session),
+	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
 	.max_cmd_len		= ISCSI_TCP_MAX_CMD_LEN,
 	.create_session		= iscsi_session_create,
@@ -3601,7 +3625,8 @@ static struct iscsi_transport iscsi_tcp_
 	.bind_conn		= iscsi_conn_bind,
 	.destroy_conn		= iscsi_conn_destroy,
 	.set_param		= iscsi_conn_set_param,
-	.get_param		= iscsi_conn_get_param,
+	.get_conn_param		= iscsi_conn_get_param,
+	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
@@ -3611,8 +3636,6 @@ static struct iscsi_transport iscsi_tcp_
 static int __init
 iscsi_tcp_init(void)
 {
-	int error;
-
 	if (iscsi_max_lun < 1) {
 		printk(KERN_ERR "Invalid max_lun value of %u\n", iscsi_max_lun);
 		return -EINVAL;
@@ -3625,11 +3648,10 @@ iscsi_tcp_init(void)
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
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 50ed88f..45e3163 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -21,12 +21,9 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/module.h>
-#include <linux/string.h>
-#include <linux/slab.h>
 #include <linux/mempool.h>
 #include <linux/mutex.h>
 #include <net/tcp.h>
-
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -46,11 +43,6 @@ struct iscsi_internal {
 	 */
 	struct list_head sessions;
 	/*
-	 * lock to serialize access to the sessions list which must
-	 * be taken after the rx_queue_mutex
-	 */
-	spinlock_t session_lock;
-	/*
 	 * based on transport capabilities, at register time we set these
 	 * bits to tell the transport class it wants attributes displayed
 	 * in sysfs or that it can support different iSCSI Data-Path
@@ -157,7 +149,7 @@ struct mempool_zone {
 	spinlock_t freelock;
 };
 
-static struct mempool_zone z_reply;
+static struct mempool_zone *z_reply;
 
 /*
  * Z_MAX_* - actual mempool size allocated at the mempool_zone_init() time
@@ -172,50 +164,270 @@ static struct mempool_zone z_reply;
 #define Z_MAX_ERROR	16
 #define Z_HIWAT_ERROR	12
 
-struct iscsi_if_conn {
-	struct list_head conn_list;	/* item in connlist */
-	struct list_head session_list;	/* item in session->connections */
-	iscsi_connh_t connh;
-	int active;			/* must be accessed with the connlock */
-	struct Scsi_Host *host;		/* originated shost */
-	struct device dev;		/* sysfs transport/container device */
-	struct iscsi_transport *transport;
-	struct mempool_zone z_error;
-	struct mempool_zone z_pdu;
-	struct list_head freequeue;
-};
+static LIST_HEAD(connlist);
+static DEFINE_SPINLOCK(connlock);
 
-#define iscsi_dev_to_if_conn(_dev) \
-	container_of(_dev, struct iscsi_if_conn, dev)
+/*
+ * The following functions can be used by LLDs that allocate
+ * their own scsi_hosts or by software iscsi LLDs
+ */
+static void iscsi_session_release(struct device *dev)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev);
+	struct iscsi_transport *transport = session->transport;
+	struct Scsi_Host *shost;
 
-#define iscsi_cdev_to_if_conn(_cdev) \
-	iscsi_dev_to_if_conn(_cdev->dev)
+	shost = iscsi_session_to_shost(session);
+	scsi_host_put(shost);
+	kfree(session);
+	module_put(transport->owner);
+}
 
-static LIST_HEAD(connlist);
-static DEFINE_SPINLOCK(connlock);
+static int iscsi_is_session_dev(const struct device *dev)
+{
+	return dev->release == iscsi_session_release;
+}
 
-struct iscsi_if_session {
-	struct list_head list;	/* item in session_list */
-	struct list_head connections;
-	iscsi_sessionh_t sessionh;
-	struct iscsi_transport *transport;
-	struct device dev;	/* sysfs transport/container device */
-};
+/**
+ * iscsi_create_session - create iscsi class session
+ * @shost: scsi host
+ * @transport: iscsi transport
+ *
+ * This can be called from a LLD or iscsi_transport
+ **/
+struct iscsi_cls_session *
+iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport)
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
+	/* this is released in the dev's release function */
+	scsi_host_get(shost);
+	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u", shost->host_no);
+	session->dev.parent = &shost->shost_gendev;
+	session->dev.release = iscsi_session_release;
+	err = device_register(&session->dev);
+	if (err) {
+		dev_printk(KERN_ERR, &session->dev, "iscsi: could not "
+			   "register session's dev\n");
+		goto free_session;
+	}
+	transport_register_device(&session->dev);
+
+	return session;
+
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
+ * Can be called by a LLD or iscsi_transport. There must not be
+ * any running connections.
+ **/
+int iscsi_destroy_session(struct iscsi_cls_session *session)
+{
+	transport_unregister_device(&session->dev);
+	device_unregister(&session->dev);
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
+static int iscsi_is_conn_dev(const struct device *dev)
+{
+	return dev->release == iscsi_conn_release;
+}
+
+/**
+ * iscsi_create_conn - create iscsi class connection
+ * @session: iscsi cls session
+ * @cid: connection id
+ *
+ * This can be called from a LLD or iscsi_transport. The connection
+ * is child of the session so cid must be unique for all connections
+ * on the session.
+ **/
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
+	/* this is released in the dev's release function */
+	if (!get_device(&session->dev))
+		goto free_conn;
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
+free_conn:
+	kfree(conn);
+	return NULL;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_create_conn);
+
+/**
+ * iscsi_destroy_conn - destroy iscsi class connection
+ * @session: iscsi cls session
+ *
+ * This can be called from a LLD or iscsi_transport.
+ **/
+int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
+{
+	transport_unregister_device(&conn->dev);
+	device_unregister(&conn->dev);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
+
+/*
+ * These functions are used only by software iscsi_transports
+ * which do not allocate and more their scsi_hosts since this
+ * is initiated from userspace.
+ */
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
+/**
+ * iscsi_transport_create_session - create iscsi cls session and host
+ * scsit: scsi transport template
+ * transport: iscsi transport template
+ *
+ * This can be used by software iscsi_transports that allocate
+ * a session per scsi host.
+ **/
+struct Scsi_Host *
+iscsi_transport_create_session(struct scsi_transport_template *scsit,
+			       struct iscsi_transport *transport)
+{
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(transport->host_template,
+				hostdata_privsize(transport));
+	if (!shost) {
+		printk(KERN_ERR "iscsi: can not allocate SCSI host for "
+			"session\n");
+		return NULL;
+	}
+
+	shost->max_id = 1;
+	shost->max_channel = 0;
+	shost->max_lun = transport->max_lun;
+	shost->max_cmd_len = transport->max_cmd_len;
+	shost->transportt = scsit;
+
+	if (scsi_add_host(shost, NULL))
+		goto free_host;
+
+	session = iscsi_create_session(shost, transport);
+	if (!session)
+		goto remove_host;
 
-#define iscsi_dev_to_if_session(_dev) \
-	container_of(_dev, struct iscsi_if_session, dev)
+	*(unsigned long*)shost->hostdata = (unsigned long)session;
+	return shost;
+
+remove_host:
+	scsi_remove_host(shost);
+free_host:
+	scsi_host_put(shost);
+	return NULL;
+}
 
-#define iscsi_cdev_to_if_session(_cdev) \
-	iscsi_dev_to_if_session(_cdev->dev)
+EXPORT_SYMBOL_GPL(iscsi_transport_create_session);
 
-#define iscsi_if_session_to_shost(_session) \
-	dev_to_shost(_session->dev.parent)
+/**
+ * iscsi_transport_destroy_session - destroy session and scsi host
+ * shost: scsi host
+ *
+ * This can be used by software iscsi_transports that allocate
+ * a session per scsi host.
+ **/
+int iscsi_transport_destroy_session(struct Scsi_Host *shost)
+{
+	struct iscsi_cls_session *session;
 
-static struct iscsi_if_conn*
+	scsi_remove_host(shost);
+	session = hostdata_session(shost->hostdata);
+	iscsi_destroy_session(session);
+	/* ref from host alloc */
+	scsi_host_put(shost);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(iscsi_transport_destroy_session);
+
+/*
+ * iscsi interface functions
+ */
+static struct iscsi_cls_conn*
 iscsi_if_find_conn(uint64_t key)
 {
 	unsigned long flags;
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_conn *conn;
 
 	spin_lock_irqsave(&connlock, flags);
 	list_for_each_entry(conn, &connlist, conn_list)
@@ -250,7 +462,7 @@ static inline struct list_head *skb_to_l
 }
 
 static void*
-mempool_zone_alloc_skb(gfp_t gfp_mask, void *pool_data)
+mempool_zone_alloc_skb(unsigned int gfp_mask, void *pool_data)
 {
 	struct mempool_zone *zone = pool_data;
 
@@ -282,14 +494,21 @@ mempool_zone_complete(struct mempool_zon
 	spin_unlock_irqrestore(&zone->freelock, flags);
 }
 
-static int
-mempool_zone_init(struct mempool_zone *zp, unsigned max, unsigned size,
-		unsigned hiwat)
+static struct mempool_zone *
+mempool_zone_init(unsigned max, unsigned size, unsigned hiwat)
 {
+	struct mempool_zone *zp;
+
+	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
+	if (!zp)
+		return NULL;
+
 	zp->pool = mempool_create(max, mempool_zone_alloc_skb,
 				  mempool_zone_free_skb, zp);
-	if (!zp->pool)
-		return -ENOMEM;
+	if (!zp->pool) {
+		kfree(zp);
+		return NULL;
+	}
 
 	zp->size = size;
 	zp->hiwat = hiwat;
@@ -298,9 +517,14 @@ mempool_zone_init(struct mempool_zone *z
 	spin_lock_init(&zp->freelock);
 	atomic_set(&zp->allocated, 0);
 
-	return 0;
+	return zp;
 }
 
+static void mempool_zone_destroy(struct mempool_zone *zp)
+{
+	mempool_destroy(zp->pool);
+	kfree(zp);
+}
 
 static struct sk_buff*
 mempool_zone_get_skb(struct mempool_zone *zone)
@@ -340,7 +564,7 @@ int iscsi_recv_pdu(iscsi_connh_t connh, 
 	struct nlmsghdr	*nlh;
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_conn *conn;
 	char *pdu;
 	int len = NLMSG_SPACE(sizeof(*ev) + sizeof(struct iscsi_hdr) +
 			      data_size);
@@ -348,13 +572,13 @@ int iscsi_recv_pdu(iscsi_connh_t connh, 
 	conn = iscsi_if_find_conn(connh);
 	BUG_ON(!conn);
 
-	mempool_zone_complete(&conn->z_pdu);
+	mempool_zone_complete(conn->z_pdu);
 
-	skb = mempool_zone_get_skb(&conn->z_pdu);
+	skb = mempool_zone_get_skb(conn->z_pdu);
 	if (!skb) {
 		iscsi_conn_error(connh, ISCSI_ERR_CONN_FAILED);
-		printk(KERN_ERR "iscsi%d: can not deliver control PDU: OOM\n",
-		       conn->host->host_no);
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not deliver "
+			   "control PDU: OOM\n");
 		return -ENOMEM;
 	}
 
@@ -363,14 +587,14 @@ int iscsi_recv_pdu(iscsi_connh_t connh, 
 	memset(ev, 0, sizeof(*ev));
 	ev->transport_handle = iscsi_handle(conn->transport);
 	ev->type = ISCSI_KEVENT_RECV_PDU;
-	if (atomic_read(&conn->z_pdu.allocated) >= conn->z_pdu.hiwat)
+	if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
 		ev->iferror = -ENOMEM;
 	ev->r.recv_req.conn_handle = connh;
 	pdu = (char*)ev + sizeof(*ev);
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
 
-	return iscsi_unicast_skb(&conn->z_pdu, skb);
+	return iscsi_unicast_skb(conn->z_pdu, skb);
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
@@ -379,18 +603,18 @@ void iscsi_conn_error(iscsi_connh_t conn
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_conn *conn;
 	int len = NLMSG_SPACE(sizeof(*ev));
 
 	conn = iscsi_if_find_conn(connh);
 	BUG_ON(!conn);
 
-	mempool_zone_complete(&conn->z_error);
+	mempool_zone_complete(conn->z_error);
 
-	skb = mempool_zone_get_skb(&conn->z_error);
+	skb = mempool_zone_get_skb(conn->z_error);
 	if (!skb) {
-		printk(KERN_ERR "iscsi%d: gracefully ignored conn error (%d)\n",
-		       conn->host->host_no, error);
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: gracefully ignored "
+			  "conn error (%d)\n", error);
 		return;
 	}
 
@@ -398,15 +622,15 @@ void iscsi_conn_error(iscsi_connh_t conn
 	ev = NLMSG_DATA(nlh);
 	ev->transport_handle = iscsi_handle(conn->transport);
 	ev->type = ISCSI_KEVENT_CONN_ERROR;
-	if (atomic_read(&conn->z_error.allocated) >= conn->z_error.hiwat)
+	if (atomic_read(&conn->z_error->allocated) >= conn->z_error->hiwat)
 		ev->iferror = -ENOMEM;
 	ev->r.connerror.error = error;
 	ev->r.connerror.conn_handle = connh;
 
-	iscsi_unicast_skb(&conn->z_error, skb);
+	iscsi_unicast_skb(conn->z_error, skb);
 
-	printk(KERN_INFO "iscsi%d: detected conn error (%d)\n",
-	       conn->host->host_no, error);
+	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
+		   error);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_error);
 
@@ -420,9 +644,9 @@ iscsi_if_send_reply(int pid, int seq, in
 	int flags = multi ? NLM_F_MULTI : 0;
 	int t = done ? NLMSG_DONE : type;
 
-	mempool_zone_complete(&z_reply);
+	mempool_zone_complete(z_reply);
 
-	skb = mempool_zone_get_skb(&z_reply);
+	skb = mempool_zone_get_skb(z_reply);
 	/*
 	 * FIXME:
 	 * user is supposed to react on iferror == -ENOMEM;
@@ -433,366 +657,197 @@ iscsi_if_send_reply(int pid, int seq, in
 	nlh = __nlmsg_put(skb, pid, seq, t, (len - sizeof(*nlh)), 0);
 	nlh->nlmsg_flags = flags;
 	memcpy(NLMSG_DATA(nlh), payload, size);
-	return iscsi_unicast_skb(&z_reply, skb);
+	return iscsi_unicast_skb(z_reply, skb);
 }
 
-/*
- * iSCSI Session's hostdata organization:
- *
- *    *------------------* <== host->hostdata
- *    | transport        |
- *    |------------------| <== iscsi_hostdata(host->hostdata)
- *    | transport's data |
- *    |------------------| <== hostdata_session(host->hostdata)
- *    | interface's data |
- *    *------------------*
- */
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
 
-#define hostdata_privsize(_t)	(sizeof(unsigned long) + _t->hostdata_size + \
-				 _t->hostdata_size % sizeof(unsigned long) + \
-				 sizeof(struct iscsi_if_session))
+	conn = iscsi_if_find_conn(ev->u.get_stats.conn_handle);
+	if (!conn)
+		return -EEXIST;
 
-#define hostdata_session(_hostdata) ((void*)_hostdata + sizeof(unsigned long) + \
-			((struct iscsi_transport *) \
-			 iscsi_ptr(*(uint64_t *)_hostdata))->hostdata_size)
+	do {
+		int actual_size;
 
-static void iscsi_if_session_dev_release(struct device *dev)
-{
-	struct iscsi_if_session *session = iscsi_dev_to_if_session(dev);
-	struct iscsi_transport *transport = session->transport;
-	struct Scsi_Host *shost = iscsi_if_session_to_shost(session);
-	struct iscsi_if_conn *conn, *tmp;
-	unsigned long flags;
+		mempool_zone_complete(conn->z_pdu);
 
-	/* now free connections */
-	spin_lock_irqsave(&connlock, flags);
-	list_for_each_entry_safe(conn, tmp, &session->connections,
-				 session_list) {
-		list_del(&conn->session_list);
-		mempool_destroy(conn->z_pdu.pool);
-		mempool_destroy(conn->z_error.pool);
-		kfree(conn);
-	}
-	spin_unlock_irqrestore(&connlock, flags);
-	scsi_host_put(shost);
-	module_put(transport->owner);
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
 }
 
 static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
-	struct iscsi_if_session *session;
 	struct Scsi_Host *shost;
-	unsigned long flags;
-	int error;
-
-	if (!try_module_get(transport->owner))
-		return -EPERM;
 
-	shost = scsi_host_alloc(transport->host_template,
-				hostdata_privsize(transport));
-	if (!shost) {
-		ev->r.c_session_ret.session_handle = iscsi_handle(NULL);
-		printk(KERN_ERR "iscsi: can not allocate SCSI host for "
-		       "session\n");
-		error = -ENOMEM;
-		goto out_module_put;
-	}
-	shost->max_id = 1;
-	shost->max_channel = 0;
-	shost->max_lun = transport->max_lun;
-	shost->max_cmd_len = transport->max_cmd_len;
-	shost->transportt = &priv->t;
-
-	/* store struct iscsi_transport in hostdata */
-	*(uint64_t*)shost->hostdata = ev->transport_handle;
+	if (!transport->create_session)
+		return -EINVAL;
 
-	ev->r.c_session_ret.session_handle = transport->create_session(
-					ev->u.c_session.initial_cmdsn, shost);
-	if (ev->r.c_session_ret.session_handle == iscsi_handle(NULL)) {
-		error = 0;
-		goto out_host_put;
-	}
+	shost = transport->create_session(&priv->t,
+					  ev->u.c_session.initial_cmdsn);
+	if (!shost)
+		return -ENOMEM;
 
-	/* host_no becomes assigned SID */
+	ev->r.c_session_ret.session_handle = iscsi_handle(iscsi_hostdata(shost->hostdata));
 	ev->r.c_session_ret.sid = shost->host_no;
-	/* initialize session */
-	session = hostdata_session(shost->hostdata);
-	INIT_LIST_HEAD(&session->connections);
-	INIT_LIST_HEAD(&session->list);
-	session->sessionh = ev->r.c_session_ret.session_handle;
-	session->transport = transport;
-
-	error = scsi_add_host(shost, NULL);
-	if (error)
-		goto out_destroy_session;
-
-	/*
-	 * this is released in the dev's release function)
-	 */
-	scsi_host_get(shost);
-	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u", shost->host_no);
-	session->dev.parent = &shost->shost_gendev;
-	session->dev.release = iscsi_if_session_dev_release;
-	error = device_register(&session->dev);
-	if (error) {
-		printk(KERN_ERR "iscsi: could not register session%d's dev\n",
-		       shost->host_no);
-		goto out_remove_host;
-	}
-	transport_register_device(&session->dev);
-
-	/* add this session to the list of active sessions */
-	spin_lock_irqsave(&priv->session_lock, flags);
-	list_add(&session->list, &priv->sessions);
-	spin_unlock_irqrestore(&priv->session_lock, flags);
-
 	return 0;
-
-out_remove_host:
-	scsi_remove_host(shost);
-out_destroy_session:
-	transport->destroy_session(ev->r.c_session_ret.session_handle);
-	ev->r.c_session_ret.session_handle = iscsi_handle(NULL);
-out_host_put:
-	scsi_host_put(shost);
-out_module_put:
-	module_put(transport->owner);
-	return error;
 }
 
 static int
 iscsi_if_destroy_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
+
 	struct Scsi_Host *shost;
-	struct iscsi_if_session *session;
-	unsigned long flags;
-	struct iscsi_if_conn *conn;
-	int error = 0;
+
+	if (!transport->destroy_session)
+		return -EINVAL;
 
 	shost = scsi_host_lookup(ev->u.d_session.sid);
 	if (shost == ERR_PTR(-ENXIO))
 		return -EEXIST;
-	session = hostdata_session(shost->hostdata);
 
-	/* check if we have active connections */
-	spin_lock_irqsave(&connlock, flags);
-	list_for_each_entry(conn, &session->connections, session_list) {
-		if (conn->active) {
-			printk(KERN_ERR "iscsi%d: can not destroy session: "
-			       "has active connection (%p)\n",
-			       shost->host_no, iscsi_ptr(conn->connh));
-			spin_unlock_irqrestore(&connlock, flags);
-			error = EIO;
-			goto out_release_ref;
-		}
-	}
-	spin_unlock_irqrestore(&connlock, flags);
-
-	scsi_remove_host(shost);
-	transport->destroy_session(ev->u.d_session.session_handle);
-	transport_unregister_device(&session->dev);
-	device_unregister(&session->dev);
-
-	/* remove this session from the list of active sessions */
-	spin_lock_irqsave(&priv->session_lock, flags);
-	list_del(&session->list);
-	spin_unlock_irqrestore(&priv->session_lock, flags);
-
-	/* ref from host alloc */
-	scsi_host_put(shost);
-out_release_ref:
-	/* ref from host lookup */
-	scsi_host_put(shost);
-	return error;
-}
-
-static void iscsi_if_conn_dev_release(struct device *dev)
-{
-	struct iscsi_if_conn *conn = iscsi_dev_to_if_conn(dev);
-	struct Scsi_Host *shost = conn->host;
-
-	scsi_host_put(shost);
+	if (transport->destroy_session)
+		transport->destroy_session(shost);
+        /* ref from host lookup */
+        scsi_host_put(shost);
+	return 0;
 }
 
 static int
-iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
-{
-	struct iscsi_if_session *session;
+iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev){
 	struct Scsi_Host *shost;
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_conn *conn;
 	unsigned long flags;
-	int error;
+
+	if (!transport->create_conn)
+		return -EINVAL;
 
 	shost = scsi_host_lookup(ev->u.c_conn.sid);
 	if (shost == ERR_PTR(-ENXIO))
 		return -EEXIST;
-	session = hostdata_session(shost->hostdata);
 
-	conn = kmalloc(sizeof(struct iscsi_if_conn), GFP_KERNEL);
-	if (!conn) {
-		error = -ENOMEM;
-		goto out_release_ref;
-	}
-	memset(conn, 0, sizeof(struct iscsi_if_conn));
-	INIT_LIST_HEAD(&conn->session_list);
-	INIT_LIST_HEAD(&conn->conn_list);
-	conn->host = shost;
-	conn->transport = transport;
+	conn = transport->create_conn(shost, ev->u.c_conn.cid);
+	if (!conn)
+		goto release_ref;
 
-	error = mempool_zone_init(&conn->z_pdu, Z_MAX_PDU,
+	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
 			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
 				    sizeof(struct iscsi_hdr) +
 				    DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH),
 			Z_HIWAT_PDU);
-	if (error) {
-		printk(KERN_ERR "iscsi%d: can not allocate pdu zone for new "
-		       "conn\n", shost->host_no);
-		goto out_free_conn;
+	if (!conn->z_pdu) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
+			   "pdu zone for new conn\n");
+		goto destroy_conn;
 	}
-	error = mempool_zone_init(&conn->z_error, Z_MAX_ERROR,
+
+	conn->z_error = mempool_zone_init(Z_MAX_ERROR,
 			NLMSG_SPACE(sizeof(struct iscsi_uevent)),
 			Z_HIWAT_ERROR);
-	if (error) {
-		printk(KERN_ERR "iscsi%d: can not allocate error zone for "
-		       "new conn\n", shost->host_no);
-		goto out_free_pdu_pool;
-	}
-
-	ev->r.handle = transport->create_conn(ev->u.c_conn.session_handle,
-					ev->u.c_conn.cid);
-	if (!ev->r.handle) {
-		error = -ENODEV;
-		goto out_free_error_pool;
+	if (!conn->z_error) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
+			   "error zone for new conn\n");
+		goto free_pdu_pool;
 	}
 
-	conn->connh = ev->r.handle;
-
-	/*
-	 * this is released in the dev's release function
-	 */
-	if (!scsi_host_get(shost))
-		goto out_destroy_conn;
-	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "connection%d:%u",
-		 shost->host_no, ev->u.c_conn.cid);
-	conn->dev.parent = &session->dev;
-	conn->dev.release = iscsi_if_conn_dev_release;
-	error = device_register(&conn->dev);
-	if (error) {
-		printk(KERN_ERR "iscsi%d: could not register connections%u "
-		       "dev\n", shost->host_no, ev->u.c_conn.cid);
-		goto out_release_parent_ref;
-	}
-	transport_register_device(&conn->dev);
+	ev->r.handle = conn->connh = iscsi_handle(conn->dd_data);
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
-	list_add(&conn->session_list, &session->connections);
 	conn->active = 1;
 	spin_unlock_irqrestore(&connlock, flags);
 
 	scsi_host_put(shost);
 	return 0;
 
-out_release_parent_ref:
+free_pdu_pool:
+	mempool_zone_destroy(conn->z_pdu);
+destroy_conn:
+	if (transport->destroy_conn)
+		transport->destroy_conn(conn->dd_data);
+release_ref:
 	scsi_host_put(shost);
-out_destroy_conn:
-	transport->destroy_conn(ev->r.handle);
-out_free_error_pool:
-	mempool_destroy(conn->z_error.pool);
-out_free_pdu_pool:
-	mempool_destroy(conn->z_pdu.pool);
-out_free_conn:
-	kfree(conn);
-out_release_ref:
-	scsi_host_put(shost);
-	return error;
+	return -ENOMEM;
 }
 
 static int
 iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	unsigned long flags;
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_conn *conn;
+	struct mempool_zone *z_error, *z_pdu;
 
 	conn = iscsi_if_find_conn(ev->u.d_conn.conn_handle);
 	if (!conn)
 		return -EEXIST;
 
-	transport->destroy_conn(ev->u.d_conn.conn_handle);
+	if (!transport->destroy_conn)
+		return -EINVAL;
 
 	spin_lock_irqsave(&connlock, flags);
 	conn->active = 0;
 	list_del(&conn->conn_list);
 	spin_unlock_irqrestore(&connlock, flags);
 
-	transport_unregister_device(&conn->dev);
-	device_unregister(&conn->dev);
-	return 0;
-}
-
-static int
-iscsi_if_get_stats(struct iscsi_transport *transport, struct sk_buff *skb,
-		   struct nlmsghdr *nlh)
-{
-	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
-	struct iscsi_stats *stats;
-	struct sk_buff *skbstat;
-	struct iscsi_if_conn *conn;
-	struct nlmsghdr	*nlhstat;
-	struct iscsi_uevent *evstat;
-	int len = NLMSG_SPACE(sizeof(*ev) +
-			      sizeof(struct iscsi_stats) +
-			      sizeof(struct iscsi_stats_custom) *
-			      ISCSI_STATS_CUSTOM_MAX);
-	int err = 0;
-
-	conn = iscsi_if_find_conn(ev->u.get_stats.conn_handle);
-	if (!conn)
-		return -EEXIST;
-
-	do {
-		int actual_size;
-
-		mempool_zone_complete(&conn->z_pdu);
-
-		skbstat = mempool_zone_get_skb(&conn->z_pdu);
-		if (!skbstat) {
-			printk(KERN_ERR "iscsi%d: can not deliver stats: OOM\n",
-			       conn->host->host_no);
-			return -ENOMEM;
-		}
-
-		nlhstat = __nlmsg_put(skbstat, daemon_pid, 0, 0,
-				      (len - sizeof(*nlhstat)), 0);
-		evstat = NLMSG_DATA(nlhstat);
-		memset(evstat, 0, sizeof(*evstat));
-		evstat->transport_handle = iscsi_handle(conn->transport);
-		evstat->type = nlh->nlmsg_type;
-		if (atomic_read(&conn->z_pdu.allocated) >= conn->z_pdu.hiwat)
-			evstat->iferror = -ENOMEM;
-		evstat->u.get_stats.conn_handle =
-			ev->u.get_stats.conn_handle;
-		stats = (struct iscsi_stats *)
-			((char*)evstat + sizeof(*evstat));
-		memset(stats, 0, sizeof(*stats));
+	z_pdu = conn->z_pdu;
+	z_error = conn->z_error;
 
-		transport->get_stats(ev->u.get_stats.conn_handle, stats);
-		actual_size = NLMSG_SPACE(sizeof(struct iscsi_uevent) +
-					  sizeof(struct iscsi_stats) +
-					  sizeof(struct iscsi_stats_custom) *
-					  stats->custom_length);
-		actual_size -= sizeof(*nlhstat);
-		actual_size = NLMSG_LENGTH(actual_size);
-		skb_trim(skb, NLMSG_ALIGN(actual_size));
-		nlhstat->nlmsg_len = actual_size;
+	if (transport->destroy_conn)
+		transport->destroy_conn(conn);
 
-		err = iscsi_unicast_skb(&conn->z_pdu, skbstat);
-	} while (err < 0 && err != -ECONNREFUSED);
+	mempool_zone_destroy(z_pdu);
+	mempool_zone_destroy(z_error);
 
-	return err;
+	return 0;
 }
 
 static int
@@ -916,8 +971,8 @@ iscsi_if_rx(struct sock *sk, int len)
 				err = iscsi_if_send_reply(
 					NETLINK_CREDS(skb)->pid, nlh->nlmsg_seq,
 					nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
-				if (atomic_read(&z_reply.allocated) >=
-						z_reply.hiwat)
+				if (atomic_read(&z_reply->allocated) >=
+						z_reply->hiwat)
 					ev->iferror = -ENOMEM;
 			} while (err < 0 && err != -ECONNREFUSED);
 			skb_pull(skb, rlen);
@@ -927,6 +982,9 @@ iscsi_if_rx(struct sock *sk, int len)
 	mutex_unlock(&rx_queue_mutex);
 }
 
+#define iscsi_cdev_to_conn(_cdev) \
+	iscsi_dev_to_conn(_cdev->dev)
+
 /*
  * iSCSI connection attrs
  */
@@ -935,12 +993,10 @@ static ssize_t								\
 show_conn_int_param_##param(struct class_device *cdev, char *buf)	\
 {									\
 	uint32_t value = 0;						\
-	struct iscsi_if_conn *conn = iscsi_cdev_to_if_conn(cdev);	\
-	struct iscsi_internal *priv;					\
+	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
+	struct iscsi_transport *t = conn->transport;			\
 									\
-	priv = to_iscsi_internal(conn->host->transportt);		\
-	if (priv->param_mask & (1 << param))				\
-		priv->iscsi_transport->get_param(conn->connh, param, &value); \
+	t->get_conn_param(conn->dd_data, param, &value);		\
 	return snprintf(buf, 20, format"\n", value);			\
 }
 
@@ -955,6 +1011,9 @@ iscsi_conn_int_attr(data_digest, ISCSI_P
 iscsi_conn_int_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN, "%d");
 iscsi_conn_int_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN, "%d");
 
+#define iscsi_cdev_to_session(_cdev) \
+	iscsi_dev_to_session(_cdev->dev)
+
 /*
  * iSCSI session attrs
  */
@@ -963,20 +1022,11 @@ static ssize_t								\
 show_session_int_param_##param(struct class_device *cdev, char *buf)	\
 {									\
 	uint32_t value = 0;						\
-	struct iscsi_if_session *session = iscsi_cdev_to_if_session(cdev); \
-	struct Scsi_Host *shost = iscsi_if_session_to_shost(session);	\
-	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt); \
-	struct iscsi_if_conn *conn = NULL;				\
-	unsigned long  flags;						\
-									\
-	spin_lock_irqsave(&connlock, flags);				\
-	if (!list_empty(&session->connections))				\
-		conn = list_entry(session->connections.next,		\
-				  struct iscsi_if_conn, session_list);	\
-	spin_unlock_irqrestore(&connlock, flags);			\
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);	\
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
+	struct iscsi_transport *t = session->transport;			\
 									\
-	if (conn && (priv->param_mask & (1 << param)))			\
-		priv->iscsi_transport->get_param(conn->connh, param, &value);\
+	t->get_session_param(shost, param, &value);			\
 	return snprintf(buf, 20, format"\n", value);			\
 }
 
@@ -1005,23 +1055,18 @@ iscsi_session_int_attr(erl, ISCSI_PARAM_
 		count++;						\
 	}
 
-static int iscsi_is_session_dev(const struct device *dev)
-{
-	return dev->release == iscsi_if_session_dev_release;
-}
-
 static int iscsi_session_match(struct attribute_container *cont,
 			   struct device *dev)
 {
-	struct iscsi_if_session *session;
+	struct iscsi_cls_session *session;
 	struct Scsi_Host *shost;
 	struct iscsi_internal *priv;
 
 	if (!iscsi_is_session_dev(dev))
 		return 0;
 
-	session = iscsi_dev_to_if_session(dev);
-	shost = iscsi_if_session_to_shost(session);
+	session = iscsi_dev_to_session(dev);
+	shost = iscsi_session_to_shost(session);
 	if (!shost->transportt)
 		return 0;
 
@@ -1032,23 +1077,21 @@ static int iscsi_session_match(struct at
 	return &priv->session_cont.ac == cont;
 }
 
-static int iscsi_is_conn_dev(const struct device *dev)
-{
-	return dev->release == iscsi_if_conn_dev_release;
-}
-
 static int iscsi_conn_match(struct attribute_container *cont,
 			   struct device *dev)
 {
-	struct iscsi_if_conn *conn;
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn;
 	struct Scsi_Host *shost;
 	struct iscsi_internal *priv;
 
 	if (!iscsi_is_conn_dev(dev))
 		return 0;
 
-	conn = iscsi_dev_to_if_conn(dev);
-	shost = conn->host;
+	conn = iscsi_dev_to_conn(dev);
+	session = iscsi_dev_to_session(conn->dev.parent);
+	shost = iscsi_session_to_shost(session);
+
 	if (!shost->transportt)
 		return 0;
 
@@ -1059,7 +1102,8 @@ static int iscsi_conn_match(struct attri
 	return &priv->conn_cont.ac == cont;
 }
 
-int iscsi_register_transport(struct iscsi_transport *tt)
+struct scsi_transport_template *
+iscsi_register_transport(struct iscsi_transport *tt)
 {
 	struct iscsi_internal *priv;
 	unsigned long flags;
@@ -1069,15 +1113,14 @@ int iscsi_register_transport(struct iscs
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
-		return -EEXIST;
+		return NULL;
 
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return -ENOMEM;
+		return NULL;
 	memset(priv, 0, sizeof(*priv));
 	INIT_LIST_HEAD(&priv->list);
 	INIT_LIST_HEAD(&priv->sessions);
-	spin_lock_init(&priv->session_lock);
 	priv->iscsi_transport = tt;
 
 	priv->cdev.class = &iscsi_transport_class;
@@ -1143,13 +1186,13 @@ int iscsi_register_transport(struct iscs
 	spin_unlock_irqrestore(&iscsi_transport_lock, flags);
 
 	printk(KERN_NOTICE "iscsi: registered transport (%s)\n", tt->name);
-	return 0;
+	return &priv->t;
 
 unregister_cdev:
 	class_device_unregister(&priv->cdev);
 free_priv:
 	kfree(priv);
-	return err;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_register_transport);
 
@@ -1165,14 +1208,6 @@ int iscsi_unregister_transport(struct is
 	priv = iscsi_if_transport_lookup(tt);
 	BUG_ON (!priv);
 
-	spin_lock_irqsave(&priv->session_lock, flags);
-	if (!list_empty(&priv->sessions)) {
-		spin_unlock_irqrestore(&priv->session_lock, flags);
-		mutex_unlock(&rx_queue_mutex);
-		return -EPERM;
-	}
-	spin_unlock_irqrestore(&priv->session_lock, flags);
-
 	spin_lock_irqsave(&iscsi_transport_lock, flags);
 	list_del(&priv->list);
 	spin_unlock_irqrestore(&iscsi_transport_lock, flags);
@@ -1195,14 +1230,14 @@ iscsi_rcv_nl_event(struct notifier_block
 
 	if (event == NETLINK_URELEASE &&
 	    n->protocol == NETLINK_ISCSI && n->pid) {
-		struct iscsi_if_conn *conn;
+		struct iscsi_cls_conn *conn;
 		unsigned long flags;
 
-		mempool_zone_complete(&z_reply);
+		mempool_zone_complete(z_reply);
 		spin_lock_irqsave(&connlock, flags);
 		list_for_each_entry(conn, &connlist, conn_list) {
-			mempool_zone_complete(&conn->z_error);
-			mempool_zone_complete(&conn->z_pdu);
+			mempool_zone_complete(conn->z_error);
+			mempool_zone_complete(conn->z_pdu);
 		}
 		spin_unlock_irqrestore(&connlock, flags);
 	}
@@ -1235,15 +1270,15 @@ static __init int iscsi_transport_init(v
 		goto unregister_session_class;
 
 	nls = netlink_kernel_create(NETLINK_ISCSI, 1, iscsi_if_rx,
-				    THIS_MODULE);
+			THIS_MODULE);
 	if (!nls) {
 		err = -ENOBUFS;
 		goto unregister_notifier;
 	}
 
-	err = mempool_zone_init(&z_reply, Z_MAX_REPLY,
+	z_reply = mempool_zone_init(Z_MAX_REPLY,
 		NLMSG_SPACE(sizeof(struct iscsi_uevent)), Z_HIWAT_REPLY);
-	if (!err)
+	if (z_reply)
 		return 0;
 
 	sock_release(nls->sk_socket);
@@ -1260,7 +1295,7 @@ unregister_transport_class:
 
 static void __exit iscsi_transport_exit(void)
 {
-	mempool_destroy(z_reply.pool);
+	mempool_zone_destroy(z_reply);
 	sock_release(nls->sk_socket);
 	netlink_unregister_notifier(&iscsi_nl_notifier);
 	transport_class_unregister(&iscsi_connection_class);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index be1bc79..3e5cb5a 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -168,6 +168,12 @@ typedef uint64_t iscsi_connh_t;		/* iSCS
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
+#define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
+
+/**
+ * iscsi_hostdata - get LLD hostdata from scsi_host
+ * @_hostdata: pointer to scsi host's hostdata
+ **/
 #define iscsi_hostdata(_hostdata) ((void*)_hostdata + sizeof(unsigned long))
 
 /*
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f25041c..16602a5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -23,8 +23,14 @@
 #ifndef SCSI_TRANSPORT_ISCSI_H
 #define SCSI_TRANSPORT_ISCSI_H
 
+#include <linux/device.h>
 #include <scsi/iscsi_if.h>
 
+struct scsi_transport_template;
+struct Scsi_Host;
+struct mempool_zone;
+struct iscsi_cls_conn;
+
 /**
  * struct iscsi_transport - iSCSI Transport template
  *
@@ -48,23 +54,31 @@ struct iscsi_transport {
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
+	struct Scsi_Host *(*create_session) (struct scsi_transport_template *t,
+					     uint32_t initial_cmdsn);
+	void (*destroy_session) (struct Scsi_Host *shost);
+	struct iscsi_cls_conn *(*create_conn) (struct Scsi_Host *shost,
+				uint32_t cid);
 	int (*bind_conn) (iscsi_sessionh_t session, iscsi_connh_t conn,
 			  uint32_t transport_fd, int is_leading);
 	int (*start_conn) (iscsi_connh_t conn);
 	void (*stop_conn) (iscsi_connh_t conn, int flag);
-	void (*destroy_conn) (iscsi_connh_t conn);
+	void (*destroy_conn) (struct iscsi_cls_conn *conn);
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
@@ -73,7 +87,7 @@ struct iscsi_transport {
 /*
  * transport registration upcalls
  */
-extern int iscsi_register_transport(struct iscsi_transport *tt);
+extern struct scsi_transport_template *iscsi_register_transport(struct iscsi_transport *tt);
 extern int iscsi_unregister_transport(struct iscsi_transport *tt);
 
 /*
@@ -83,4 +97,49 @@ extern void iscsi_conn_error(iscsi_connh
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
+ * session and connection functions that can be used by HW iSCSI LLDs
+ */
+extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
+				struct iscsi_transport *t);
+extern int iscsi_destroy_session(struct iscsi_cls_session *session);
+extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
+					    uint32_t cid);
+extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
+
+/*
+ * session functions used by software iscsi
+ */
+extern struct Scsi_Host *
+iscsi_transport_create_session(struct scsi_transport_template *scsit,
+                               struct iscsi_transport *transport);
+extern int iscsi_transport_destroy_session(struct Scsi_Host *shost);
+
 #endif


