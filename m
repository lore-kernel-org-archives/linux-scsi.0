From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] add iSCSI session creation sysfs attributes
Date: Mon, 24 Jan 2005 02:39:46 -0800
Message-ID: <41F4D072.5040800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050402060204010009070600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54424 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261405AbVAXKjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 05:39:53 -0500
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0OAdpf0007050
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 04:39:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050402060204010009070600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch built against scsi-misc-2.6 moves the
target iSCSI attributes to a new structure representing
a iSCSI session. The reason for doing this is to
create a interface that allows the Sourceforge iSCSI driver
to create and setup a session through sysfs (no more
IOCTL at all in our driver), display session info, and at the same
time share code and use the same interface HW iSCSI drivers would
use.

Here is an example using the interface. There is
one LLD specifc attribute that was placed
on our own class, becuase I was not sure if I could
put it on the transport class (it could be stuck
on the iscsi_host class in future patches). It is the
initial /sys/class/iscsi_sfnet/add_host that is used to
add a scsi host, since we do not have a pci_driver and probe
function like normal HW drivers. The rest of the
attrs are on the iSCSI transport classes and are used
for both read and write operations, so the interface
can be used for session creation and info passing.


[root@mina class]# echo 1 > iscsi_sfnet/add_host
[root@mina host11]# ls
add_session  device  initiator_alias  initiator_name
[root@mina host11]# echo -n iqn.1987-05.com.ibm > iscsi_host/host11/initiator_name
[root@mina iscsi_host]# echo 1 > host11/add_session
[root@mina host11]# ls
add_session  device  initiator_alias  initiator_name  session2
[root@mina class]# ls -l iscsi_session/session2/
total 0
--w-------  1 root root 4096 Jan 24 00:40 close_session
-rw-r--r--  1 root root 4096 Jan 24 00:40 data_digest
--w-------  1 root root 4096 Jan 24 00:40 establish_session
-rw-r--r--  1 root root 4096 Jan 24 00:40 first_burst_len
-rw-r--r--  1 root root 4096 Jan 24 00:40 header_digest
-rw-r--r--  1 root root 4096 Jan 24 00:40 immediate_data
-rw-r--r--  1 root root 4096 Jan 24 00:40 initial_r2t
-rw-r--r--  1 root root 4096 Jan 24 00:40 ip_address
-rw-r--r--  1 root root 4096 Jan 24 00:40 isid
-rw-r--r--  1 root root 4096 Jan 24 00:40 max_burst_len
-rw-r--r--  1 root root 4096 Jan 24 00:40 max_recv_data_segment_len
-rw-r--r--  1 root root 4096 Jan 24 00:40 port
--w-------  1 root root 4096 Jan 24 00:40 remove_session
lrwxrwxrwx  1 root root    0 Jan 24 00:40 host11 -> ../../../class/iscsi_host/host11
-r--r--r--  1 root root 4096 Jan 24 00:40 target_alias
-rw-r--r--  1 root root 4096 Jan 24 00:40 target_name
-rw-r--r--  1 root root 4096 Jan 24 00:40 tpgt
-rw-r--r--  1 root root 4096 Jan 24 00:40 tsih
[root@mina class]# echo -n iqn.1992-08.com.netapp:sn.99918398 > iscsi_session/session2/target_name
[root@mina class]# echo -n 192.168.1.3 > iscsi_session/session2/ip_address
[root@mina class]# echo 1 > iscsi_session/session2/establish_session
[root@mina class]# echo 1 > iscsi_session/session2/remove_session
[root@mina class]# echo 1 > scsi_host/host11/remove

Chap and update are temporarily disabled, but
will be added soon if this interface is ok. Also
there are no userspace tools yet... You have to
set things up by hand until I get some time :(

The Sourceforge iSCSI driver to use with the attached patch is here
http://www.cs.wisc.edu/~michaelc/iscsi/current/1-24-2005-scsi-misc/iscsi-sfnet-4.0.1.11-1.patch.gz
and was also built against scsi-misc-2.6. This patch removes the IOCTL
and removes the driver's session list.

--------------050402060204010009070600
Content-Type: text/x-patch;
 name="iscsi-class-setup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi-class-setup.patch"

diff -aurp scsi-misc-2.6/drivers/scsi/scsi_transport_iscsi.c scsi-misc-2.6.test/drivers/scsi/scsi_transport_iscsi.c
--- scsi-misc-2.6/drivers/scsi/scsi_transport_iscsi.c	2005-01-24 01:59:29.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/scsi_transport_iscsi.c	2005-01-24 02:11:45.000000000 -0800
@@ -19,14 +19,15 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/module.h>
+#include <linux/inet.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
-#define ISCSI_SESSION_ATTRS 20
-#define ISCSI_HOST_ATTRS 2
+#define ISCSI_SESSION_ATTRS 24
+#define ISCSI_HOST_ATTRS 3
 
 struct iscsi_internal {
 	struct scsi_transport_template t;
@@ -34,21 +35,61 @@ struct iscsi_internal {
 	/*
 	 * We do not have any private or other attrs.
 	 */
-	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
+	struct attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
+	struct attribute_group session_attr_group;
 	struct class_device_attribute *host_attrs[ISCSI_HOST_ATTRS + 1];
+
+	struct list_head shosts;
+	struct semaphore sem;
 };
 
 #define to_iscsi_internal(tmpl) container_of(tmpl, struct iscsi_internal, t)
 
-static void iscsi_transport_class_release(struct class_device *class_dev)
+static void iscsi_session_class_release(struct class_device *cdev)
 {
-	struct scsi_target *starget = transport_class_to_starget(class_dev);
-	put_device(&starget->dev);
-}
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
-struct class iscsi_transport_class = {
-	.name = "iscsi_transport_class",
-	.release = iscsi_transport_class_release,
+	if (i->fnt->release_session)
+		i->fnt->release_session(session);
+	scsi_host_put(shost);
+	kfree(session);
+}
+
+/**
+ * remove_session - remove a session
+ * session: session that has been added to the host
+ *
+ * Remove the session from the iscsi hosts's list of sessions.
+ * If the close_session functions is set then this will be
+ * called before the release_session.
+ *
+ * The iscsi hosts semaphore must be held.
+ **/
+static void remove_session(struct iscsi_class_session *session)
+{
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	if (list_empty(&session->list))
+		return;
+	list_del_init(&session->list);
+
+	if (i->fnt->close_session)
+		i->fnt->close_session(session);
+
+	sysfs_remove_link(&session->class_dev.kobj,
+			  shost->shost_classdev.class_id);
+	sysfs_remove_link(&shost->transport_classdev.kobj,
+			  session->class_dev.class_id);
+	sysfs_remove_group(&session->class_dev.kobj, &i->session_attr_group);
+	class_device_unregister(&session->class_dev);
+}
+
+static struct class iscsi_session_class = {
+	.name = "iscsi_session",
+	.release = iscsi_session_class_release,
 };
 
 static void iscsi_host_class_release(struct class_device *class_dev)
@@ -57,41 +98,125 @@ static void iscsi_host_class_release(str
 	put_device(&shost->shost_gendev);
 }
 
-struct class iscsi_host_class = {
+static struct class iscsi_host_class = {
 	.name = "iscsi_host",
 	.release = iscsi_host_class_release,
 };
 
+static int iscsi_setup_host(struct Scsi_Host *shost)
+{
+	struct iscsi_host *ishost = shost->shost_data;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	memset(ishost, 0, sizeof(*ishost));
+	ishost->shost = shost;
+	INIT_LIST_HEAD(&ishost->list);
+
+	down(&i->sem);
+	list_add_tail(&ishost->list, &i->shosts);
+	up(&i->sem);
+
+	INIT_LIST_HEAD(&ishost->sessions);
+	sema_init(&ishost->sem, 1);
+	return 0;
+}
+
+static void iscsi_destroy_host(struct Scsi_Host *shost)
+{
+	struct iscsi_host *ishost = shost->shost_data;
+	struct iscsi_class_session *session, *tmp;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	down(&i->sem);
+	list_del_init(&ishost->list);
+	up(&i->sem);
+
+	down(&ishost->sem);
+	list_for_each_entry_safe(session, tmp, &ishost->sessions, list)
+		remove_session(session);
+	up(&ishost->sem);
+}
+
+/**
+ * __iscsi_for_each_iscsi_host - iterate over all the hosts
+ * t: transport template
+ * fn: iterator function
+ *
+ * This function can only be used when the driver knows that
+ * new hosts cannot be added or removed
+ */
+int __iscsi_for_each_iscsi_host(struct scsi_transport_template *t,
+				int (*fn)(struct Scsi_Host *))
+{
+	struct iscsi_internal *i = to_iscsi_internal(t);
+	struct iscsi_host *ishost, *tmp;
+	struct Scsi_Host *shost;
+	int err = 0;
+
+	list_for_each_entry_safe(ishost, tmp, &i->shosts, list) {
+		shost = ishost->shost;
+		if (!scsi_host_get(shost))
+			continue;
+		err = fn(shost);
+		scsi_host_put(shost);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+EXPORT_SYMBOL(__iscsi_for_each_iscsi_host);
+
 /*
- * iSCSI target and session attrs
+ * iSCSI session attrs
  */
 #define iscsi_session_show_fn(field, format)				\
 									\
 static ssize_t								\
 show_session_##field(struct class_device *cdev, char *buf)		\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+	struct iscsi_class_session *session;				\
+	struct Scsi_Host *shost;					\
+	struct iscsi_internal *i;					\
+									\
+	session = transport_class_to_session(cdev);			\
+	shost = session->shost; 					\
+	i = to_iscsi_internal(shost->transportt);			\
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
-	return snprintf(buf, 20, format"\n", iscsi_##field(starget));	\
+		i->fnt->get_##field(session);				\
+	return snprintf(buf, 20, format"\n", iscsi_##field(session));	\
 }
 
-#define iscsi_session_rd_attr(field, format)				\
-	iscsi_session_show_fn(field, format)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_##field, NULL);
+#define iscsi_session_store_fn(field, format)				\
+									\
+static ssize_t								\
+store_session_##field(struct class_device *cdev, const char *buf,	\
+		      size_t count)					\
+{									\
+	struct iscsi_class_session *session;				\
+									\
+	session = transport_class_to_session(cdev);			\
+	sscanf(buf, format"\n", &iscsi_##field(session));		\
+	return count;							\
+}
 
-iscsi_session_rd_attr(tpgt, "%hu");
-iscsi_session_rd_attr(tsih, "%2x");
-iscsi_session_rd_attr(max_recv_data_segment_len, "%u");
-iscsi_session_rd_attr(max_burst_len, "%u");
-iscsi_session_rd_attr(first_burst_len, "%u");
-iscsi_session_rd_attr(def_time2wait, "%hu");
-iscsi_session_rd_attr(def_time2retain, "%hu");
-iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
-iscsi_session_rd_attr(erl, "%d");
+#define iscsi_session_attr(field, format)				\
+	iscsi_session_show_fn(field, format)				\
+	iscsi_session_store_fn(field, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_session_##field, store_session_##field);
+
+iscsi_session_attr(tpgt, "%hu");
+iscsi_session_attr(tsih, "%hu");
+iscsi_session_attr(max_recv_data_segment_len, "%u");
+iscsi_session_attr(max_burst_len, "%u");
+iscsi_session_attr(first_burst_len, "%u");
+iscsi_session_attr(def_time2wait, "%hu");
+iscsi_session_attr(def_time2retain, "%hu");
+iscsi_session_attr(max_outstanding_r2t, "%hu");
+iscsi_session_attr(erl, "%d");
 
 
 #define iscsi_session_show_bool_fn(field)				\
@@ -99,101 +224,186 @@ iscsi_session_rd_attr(erl, "%d");
 static ssize_t								\
 show_session_bool_##field(struct class_device *cdev, char *buf)		\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+	struct iscsi_class_session *session;				\
+	struct Scsi_Host *shost;					\
+	struct iscsi_internal *i;					\
+									\
+	session = transport_class_to_session(cdev);			\
+	shost = session->shost; 					\
+	i = to_iscsi_internal(shost->transportt);			\
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
+		i->fnt->get_##field(session);				\
 									\
-	if (iscsi_##field(starget))					\
+	if (iscsi_##field(session))					\
 		return sprintf(buf, "Yes\n");				\
 	return sprintf(buf, "No\n");					\
 }
 
-#define iscsi_session_rd_bool_attr(field)				\
-	iscsi_session_show_bool_fn(field)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_bool_##field, NULL);
+#define iscsi_session_store_bool_fn(field)				\
+									\
+static ssize_t								\
+store_session_bool_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	struct iscsi_class_session *session;				\
+									\
+	session = transport_class_to_session(cdev);			\
+	if (!strncmp(buf, "Yes", 3))					\
+		iscsi_##field(session) = 1;				\
+	else								\
+		iscsi_##field(session) = 0;				\
+	return count;							\
+}
 
-iscsi_session_rd_bool_attr(initial_r2t);
-iscsi_session_rd_bool_attr(immediate_data);
-iscsi_session_rd_bool_attr(data_pdu_in_order);
-iscsi_session_rd_bool_attr(data_sequence_in_order);
+#define iscsi_session_bool_attr(field)					\
+	iscsi_session_show_bool_fn(field)				\
+	iscsi_session_store_bool_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_session_bool_##field,			\
+			 store_session_bool_##field);
+
+iscsi_session_bool_attr(initial_r2t);
+iscsi_session_bool_attr(immediate_data);
+iscsi_session_bool_attr(data_pdu_in_order);
+iscsi_session_bool_attr(data_sequence_in_order);
 
+/*
+ * TODO add support for more digest combinations
+ */
 #define iscsi_session_show_digest_fn(field)				\
 									\
 static ssize_t								\
 show_##field(struct class_device *cdev, char *buf)			\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+	struct iscsi_class_session *session;				\
+	struct Scsi_Host *shost;					\
+	struct iscsi_internal *i;					\
+									\
+	session = transport_class_to_session(cdev);			\
+	shost = session->shost; 					\
+	i = to_iscsi_internal(shost->transportt);			\
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
+		i->fnt->get_##field(session);				\
 									\
-	if (iscsi_##field(starget))					\
+	if (iscsi_##field(session))					\
 		return sprintf(buf, "CRC32C\n");			\
 	return sprintf(buf, "None\n");					\
 }
 
-#define iscsi_session_rd_digest_attr(field)				\
+#define iscsi_session_store_digest_fn(field)				\
+									\
+static ssize_t								\
+store_##field(struct class_device *cdev, const char *buf, size_t count) \
+{									\
+	struct iscsi_class_session *session;				\
+									\
+	session = transport_class_to_session(cdev);			\
+	if (!strncmp(buf, "None", 4))					\
+		iscsi_##field(session) = 0;				\
+	else								\
+		iscsi_##field(session) = 1;				\
+	return count;							\
+}
+
+#define iscsi_session_digest_attr(field)				\
 	iscsi_session_show_digest_fn(field)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL);
+	iscsi_session_store_digest_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field,	\
+			 store_##field);
 
-iscsi_session_rd_digest_attr(header_digest);
-iscsi_session_rd_digest_attr(data_digest);
+iscsi_session_digest_attr(header_digest);
+iscsi_session_digest_attr(data_digest);
 
-static ssize_t
-show_port(struct class_device *cdev, char *buf)
+static ssize_t show_session_port(struct class_device *cdev, char *buf)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_port)
-		i->fnt->get_port(starget);
+		i->fnt->get_port(session);
 
-	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(starget)));
+	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(session)));
 }
-static CLASS_DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
 
-static ssize_t
-show_ip_address(struct class_device *cdev, char *buf)
+static ssize_t store_session_port(struct class_device *cdev, const char *buf,
+				  size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	u16 port;
+
+	sscanf(buf, "%hu\n", &port);
+	iscsi_port(session) = htons(port);
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(port, S_IRUGO | S_IWUSR, show_session_port,
+			 store_session_port);
+
+static ssize_t show_ip_address(struct class_device *cdev, char *buf)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_ip_address)
-		i->fnt->get_ip_address(starget);
+		i->fnt->get_ip_address(session);
 
-	if (iscsi_addr_type(starget) == AF_INET)
+	if (iscsi_addr_type(session) == AF_INET)
 		return sprintf(buf, "%u.%u.%u.%u\n",
-			       NIPQUAD(iscsi_sin_addr(starget)));
-	else if(iscsi_addr_type(starget) == AF_INET6)
+			       NIPQUAD(iscsi_sin_addr(session)));
+	else if(iscsi_addr_type(session) == AF_INET6)
 		return sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
-			       NIP6(iscsi_sin6_addr(starget)));
+			       NIP6(iscsi_sin6_addr(session)));
 	return -EINVAL;
 }
-static CLASS_DEVICE_ATTR(ip_address, S_IRUGO, show_ip_address, NULL);
 
-static ssize_t
-show_isid(struct class_device *cdev, char *buf)
+/*
+ * TODO find ipv6 version of in_aton and add support
+ */
+static ssize_t store_ip_address(struct class_device *cdev, const char *buf,
+				size_t count)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+
+	iscsi_addr_type(session) = AF_INET;
+	iscsi_sin_addr(session).s_addr = in_aton(buf);
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(ip_address, S_IRUGO | S_IWUSR, show_ip_address,
+			 store_ip_address);
+
+static ssize_t show_isid(struct class_device *cdev, char *buf)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_isid)
-		i->fnt->get_isid(starget);
+		i->fnt->get_isid(session);
 
 	return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
-		       iscsi_isid(starget)[0], iscsi_isid(starget)[1],
-		       iscsi_isid(starget)[2], iscsi_isid(starget)[3],
-		       iscsi_isid(starget)[4], iscsi_isid(starget)[5]);
+		       iscsi_isid(session)[0], iscsi_isid(session)[1],
+		       iscsi_isid(session)[2], iscsi_isid(session)[3],
+		       iscsi_isid(session)[4], iscsi_isid(session)[5]);
 }
-static CLASS_DEVICE_ATTR(isid, S_IRUGO, show_isid, NULL);
+
+static ssize_t store_isid(struct class_device *cdev, const char *buf,
+			  size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	int isid_len = sizeof(session->isid);
+
+	if (count < isid_len)
+		return -EINVAL;
+	memcpy(iscsi_isid(session), buf, sizeof(session->isid));
+	return isid_len;
+}
+
+static CLASS_DEVICE_ATTR(isid, S_IRUGO | S_IWUSR, show_isid, store_isid);
 
 /*
  * This is used for iSCSI names. Normally, we follow
@@ -207,23 +417,124 @@ static ssize_t								\
 show_session_str_##field(struct class_device *cdev, char *buf)		\
 {									\
 	ssize_t ret = 0;						\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+	struct iscsi_class_session *session;				\
+	struct Scsi_Host *shost;					\
+	struct iscsi_internal *i;					\
+									\
+	session = transport_class_to_session(cdev);			\
+	shost = session->shost; 					\
+	i = to_iscsi_internal(shost->transportt);			\
 									\
 	if (i->fnt->get_##field)					\
-		ret = i->fnt->get_##field(starget, buf, PAGE_SIZE);	\
+		ret = i->fnt->get_##field(session, buf, PAGE_SIZE);	\
+	return ret;							\
+}
+
+#define iscsi_session_store_str_fn(field)				\
+									\
+static ssize_t								\
+store_session_str_##field(struct class_device *cdev, const char *buf,	\
+			  size_t count)					\
+{									\
+	ssize_t ret = 0;						\
+	struct iscsi_class_session *session;				\
+	struct Scsi_Host *shost;					\
+	struct iscsi_internal *i;					\
+									\
+	session = transport_class_to_session(cdev);			\
+	shost = session->shost; 					\
+	i = to_iscsi_internal(shost->transportt);			\
+									\
+	if (i->fnt->set_##field)					\
+		ret = i->fnt->set_##field(session, buf, count);		\
 	return ret;							\
 }
 
+#define iscsi_session_str_attr(field)					\
+	iscsi_session_show_str_fn(field)				\
+	iscsi_session_store_str_fn(field)				\
+	static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,		\
+				 show_session_str_##field,		\
+				 store_session_str_##field);
+
 #define iscsi_session_rd_str_attr(field)				\
 	iscsi_session_show_str_fn(field)				\
 static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_str_##field, NULL);
 
-iscsi_session_rd_str_attr(target_name);
+iscsi_session_str_attr(target_name);
 iscsi_session_rd_str_attr(target_alias);
 
 /*
+ * Session management attrs
+ */
+static ssize_t store_remove_session(struct class_device *cdev, const char *buf,
+				    size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_host *ishost = shost->shost_data;
+
+	down(&ishost->sem);
+	remove_session(session);
+	up(&ishost->sem);
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(remove_session, S_IWUSR, NULL, store_remove_session);
+
+static ssize_t store_close_session(struct class_device *cdev, const char *buf,
+				   size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	if (i->fnt->close_session)
+		i->fnt->close_session(session);
+
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(close_session, S_IWUSR, NULL, store_close_session);
+
+static ssize_t store_establish_session(struct class_device *cdev,
+				       const char *buf, size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int err = count;
+
+	/*
+	 * TODO - we need a lock in case someone is estb a session
+	 * and setting a value at the same time.
+	 */
+	if (i->fnt->establish_session)
+		err = i->fnt->establish_session(session);
+
+	return err;
+}
+
+static CLASS_DEVICE_ATTR(establish_session, S_IWUSR, NULL,
+			 store_establish_session);
+
+static ssize_t store_update_session(struct class_device *cdev,
+				    const char *buf, size_t count)
+{
+	struct iscsi_class_session *session = transport_class_to_session(cdev);
+	struct Scsi_Host *shost = session->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int err = count;
+
+	if (i->fnt->update_session)
+		err = i->fnt->update_session(session);
+
+	return err;
+}
+
+static CLASS_DEVICE_ATTR(update_session, S_IWUSR, NULL, store_update_session);
+
+/*
  * iSCSI host attrs
  */
 
@@ -246,22 +557,179 @@ show_host_str_##field(struct class_devic
 	return ret;							\
 }
 
-#define iscsi_host_rd_str_attr(field)					\
+#define iscsi_host_store_str_fn(field)					\
+									\
+static ssize_t								\
+store_host_str_##field(struct class_device *cdev, const char *buf,	\
+		       size_t count)					\
+{									\
+	int ret = 0;							\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->set_##field)					\
+		ret = i->fnt->set_##field(shost, buf, count);		\
+	return ret;							\
+}
+
+#define iscsi_host_str_attr(field)					\
 	iscsi_host_show_str_fn(field)					\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_host_str_##field, NULL);
+	iscsi_host_store_str_fn(field)					\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_host_str_##field, store_host_str_##field);
 
-iscsi_host_rd_str_attr(initiator_name);
-iscsi_host_rd_str_attr(initiator_alias);
+iscsi_host_str_attr(initiator_name);
+iscsi_host_str_attr(initiator_alias);
 
-#define SETUP_SESSION_RD_ATTR(field)					\
+static void set_iscsi_defaults(struct iscsi_class_session *session)
+{
+	/*
+	 * these are the iSCSI RFC defaults. We will get them
+	 * from iscsi.h when that is merged
+	 */
+	iscsi_port(session) = htons(3260);
+	iscsi_tpgt(session) = 1;
+	iscsi_initial_r2t(session) = 1;
+	iscsi_immediate_data(session) = 1;
+	iscsi_max_recv_data_segment_len(session) = 8192;
+	iscsi_max_burst_len(session) = 262144;
+	iscsi_first_burst_len(session) = 65536;
+	iscsi_def_time2wait(session) = 2;
+	iscsi_def_time2retain(session) = 20;
+	iscsi_max_outstanding_r2t(session) = 1;
+	iscsi_data_pdu_in_order(session) = 1;
+	iscsi_data_sequence_in_order(session) = 1;
+}
+
+static atomic_t iscsi_num_sessions;
+
+/**
+ * store_add_session - add a session to the iscsi host
+ * @cdev: scsi hosts's transport class device
+ * @buf: junk
+ * @count: junk
+ *
+ * Add a session to the iscsi hosts list of sessions. This does
+ * not establish a session just yet. Instead it allocates and preps
+ * the session. See store_establish_session.
+ *
+ * HW drivers that perform discovery in FW will need this to be
+ * broken out into a new function and exported.
+ **/
+static ssize_t store_add_session(struct class_device *cdev, const char *buf,
+				 size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct iscsi_host *ishost = shost->shost_data;
+	struct iscsi_class_session *session;
+	struct iscsi_internal *i;
+	int err;
+	size_t size;
+
+	down(&ishost->sem);
+	/*
+	 * get a handle for the session since it references the
+	 * template's internal data (this is released in the class's
+	 * release function)
+	 */
+	shost = scsi_host_get(shost);
+	if (!shost) {
+		printk(KERN_ERR "iSCSI: could not get reference to shost\n");
+		err = -EINVAL;
+		goto release_sem;
+	}
+
+	i = to_iscsi_internal(shost->transportt);
+	size = sizeof(*session) + i->fnt->session_hostdata_size;
+	session = kmalloc(size, GFP_KERNEL);
+	if (!session) {
+		printk(KERN_ERR "iSCSI: could not allocate session\n");
+		err = -ENOMEM;
+		goto put_host;
+	}
+
+	memset(session, 0, size);
+	set_iscsi_defaults(session);
+	INIT_LIST_HEAD(&session->list);
+	session->shost = shost;
+	session->class_dev.class = &iscsi_session_class;
+	snprintf(session->class_dev.class_id, BUS_ID_SIZE, "session%d",
+		 atomic_inc_return(&iscsi_num_sessions));
+
+	if (i->fnt->setup_session) {
+		err = i->fnt->setup_session(session);
+		if (err) {
+			printk(KERN_ERR "iSCSI: session setup failed\n");
+			goto free_session;
+		}
+	}
+
+	err = class_device_register(&session->class_dev);
+	if (err) {
+		printk(KERN_ERR "iSCSI: could not register session classdev\n");
+		goto release_session;
+	}
+
+	err = sysfs_create_link(&shost->transport_classdev.kobj,
+				&session->class_dev.kobj,
+				session->class_dev.class_id);
+	if (err) {
+		printk(KERN_ERR "iSCSI: could not create symlink\n");
+		goto unregister_session;
+	}
+
+	err = sysfs_create_link(&session->class_dev.kobj,
+				&shost->transport_classdev.kobj,
+				shost->shost_classdev.class_id);
+	if (err) {
+		printk(KERN_ERR "iSCSI: could not create symlink\n");
+		goto remove_session_link;
+	}
+
+	err = sysfs_create_group(&session->class_dev.kobj,
+				 &i->session_attr_group);
+	if (err) {
+		printk(KERN_ERR "iSCSI: create session attr group failed\n");
+		goto remove_host_link;
+	}
+
+	list_add_tail(&session->list, &ishost->sessions);
+	up(&ishost->sem);
+	return count;
+
+ remove_host_link:
+	sysfs_remove_link(&session->class_dev.kobj,
+			  shost->shost_classdev.class_id);
+ remove_session_link:
+	sysfs_remove_link(&shost->transport_classdev.kobj,
+			  session->class_dev.class_id);
+ unregister_session:
+	class_device_unregister(&session->class_dev);
+ release_session:
+	if (i->fnt->release_session)
+		i->fnt->release_session(session);	
+ free_session:
+	kfree(session);
+ put_host:
+	scsi_host_put(shost);
+ release_sem:
+	up(&ishost->sem);
+	return err;
+}
+
+static CLASS_DEVICE_ATTR(add_session, S_IWUSR, NULL, store_add_session);
+
+#define SETUP_SESSION_ATTR(field)					\
 	if (i->fnt->show_##field) {					\
-		i->session_attrs[count] = &class_device_attr_##field;	\
+		i->session_attrs[count] = &class_device_attr_##field.attr; \
+		i->session_attrs[count]->owner = fnt->owner;		\
 		count++;						\
 	}
 
-#define SETUP_HOST_RD_ATTR(field)					\
+#define SETUP_HOST_ATTR(field)						\
 	if (i->fnt->show_##field) {					\
 		i->host_attrs[count] = &class_device_attr_##field;	\
+		i->host_attrs[count]->attr.owner = fnt->owner;		\
 		count++;						\
 	}
 
@@ -276,45 +744,49 @@ iscsi_attach_transport(struct iscsi_func
 		return NULL;
 
 	memset(i, 0, sizeof(struct iscsi_internal));
+	INIT_LIST_HEAD(&i->shosts);
+	sema_init(&i->sem, 1);
 	i->fnt = fnt;
 
-	i->t.target_attrs = &i->session_attrs[0];
-	i->t.target_class = &iscsi_transport_class;
-	i->t.target_setup = NULL;
-	i->t.target_size = sizeof(struct iscsi_class_session);
-
-	SETUP_SESSION_RD_ATTR(tsih);
-	SETUP_SESSION_RD_ATTR(isid);
-	SETUP_SESSION_RD_ATTR(header_digest);
-	SETUP_SESSION_RD_ATTR(data_digest);
-	SETUP_SESSION_RD_ATTR(target_name);
-	SETUP_SESSION_RD_ATTR(target_alias);
-	SETUP_SESSION_RD_ATTR(port);
-	SETUP_SESSION_RD_ATTR(tpgt);
-	SETUP_SESSION_RD_ATTR(ip_address);
-	SETUP_SESSION_RD_ATTR(initial_r2t);
-	SETUP_SESSION_RD_ATTR(immediate_data);
-	SETUP_SESSION_RD_ATTR(max_recv_data_segment_len);
-	SETUP_SESSION_RD_ATTR(max_burst_len);
-	SETUP_SESSION_RD_ATTR(first_burst_len);
-	SETUP_SESSION_RD_ATTR(def_time2wait);
-	SETUP_SESSION_RD_ATTR(def_time2retain);
-	SETUP_SESSION_RD_ATTR(max_outstanding_r2t);
-	SETUP_SESSION_RD_ATTR(data_pdu_in_order);
-	SETUP_SESSION_RD_ATTR(data_sequence_in_order);
-	SETUP_SESSION_RD_ATTR(erl);
+	SETUP_SESSION_ATTR(tsih);
+	SETUP_SESSION_ATTR(isid);
+	SETUP_SESSION_ATTR(header_digest);
+	SETUP_SESSION_ATTR(data_digest);
+	SETUP_SESSION_ATTR(target_name);
+	SETUP_SESSION_ATTR(target_alias);
+	SETUP_SESSION_ATTR(port);
+	SETUP_SESSION_ATTR(tpgt);
+	SETUP_SESSION_ATTR(ip_address);
+	SETUP_SESSION_ATTR(initial_r2t);
+	SETUP_SESSION_ATTR(immediate_data);
+	SETUP_SESSION_ATTR(max_recv_data_segment_len);
+	SETUP_SESSION_ATTR(max_burst_len);
+	SETUP_SESSION_ATTR(first_burst_len);
+	SETUP_SESSION_ATTR(def_time2wait);
+	SETUP_SESSION_ATTR(def_time2retain);
+	SETUP_SESSION_ATTR(max_outstanding_r2t);
+	SETUP_SESSION_ATTR(data_pdu_in_order);
+	SETUP_SESSION_ATTR(data_sequence_in_order);
+	SETUP_SESSION_ATTR(erl);
+	SETUP_SESSION_ATTR(close_session);
+	SETUP_SESSION_ATTR(remove_session);
+	SETUP_SESSION_ATTR(establish_session);
+	SETUP_SESSION_ATTR(update_session);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	i->session_attrs[count] = NULL;
+	i->session_attr_group.attrs = i->session_attrs;
 
 	i->t.host_attrs = &i->host_attrs[0];
 	i->t.host_class = &iscsi_host_class;
-	i->t.host_setup = NULL;
-	i->t.host_size = 0;
+	i->t.host_setup = iscsi_setup_host;
+	i->t.host_destroy = iscsi_destroy_host;
+	i->t.host_size = sizeof(struct iscsi_host);
 
 	count = 0;
-	SETUP_HOST_RD_ATTR(initiator_name);
-	SETUP_HOST_RD_ATTR(initiator_alias);
+	SETUP_HOST_ATTR(initiator_name);
+	SETUP_HOST_ATTR(initiator_alias);
+	SETUP_HOST_ATTR(add_session);
 
 	BUG_ON(count > ISCSI_HOST_ATTRS);
 	i->host_attrs[count] = NULL;
@@ -334,17 +806,19 @@ EXPORT_SYMBOL(iscsi_release_transport);
 
 static __init int iscsi_transport_init(void)
 {
-	int err = class_register(&iscsi_transport_class);
+	int err = class_register(&iscsi_session_class);
 
 	if (err)
 		return err;
+
+	atomic_set(&iscsi_num_sessions, 0);
 	return class_register(&iscsi_host_class);
 }
 
 static void __exit iscsi_transport_exit(void)
 {
 	class_unregister(&iscsi_host_class);
-	class_unregister(&iscsi_transport_class);
+	class_unregister(&iscsi_session_class);
 }
 
 module_init(iscsi_transport_init);
diff -aurp scsi-misc-2.6/include/scsi/scsi_transport_iscsi.h scsi-misc-2.6.test/include/scsi/scsi_transport_iscsi.h
--- scsi-misc-2.6/include/scsi/scsi_transport_iscsi.h	2005-01-24 01:59:35.000000000 -0800
+++ scsi-misc-2.6.test/include/scsi/scsi_transport_iscsi.h	2005-01-24 02:11:27.000000000 -0800
@@ -28,6 +28,11 @@
 struct scsi_transport_template;
 
 struct iscsi_class_session {
+	/*
+	 * iSCSI settings. Initially these are the requested
+	 * values. After a session is estbalished they are the
+	 * negotiated settings.
+	 */
 	uint8_t isid[6];
 	uint16_t tsih;
 	int header_digest;		/* 1 CRC32, 0 None */
@@ -50,103 +55,107 @@ struct iscsi_class_session {
 	int data_pdu_in_order;		/* 1 Yes, 0 No */
 	int data_sequence_in_order;	/* 1 Yes, 0 No */
 	int erl;
+
+	/*
+	 * Internal fields
+	 */
+	struct Scsi_Host *shost;
+	struct class_device class_dev;
+	struct list_head list;
+	/*
+	 * LLD private area, set the fnt session_hostdata_size field
+	 */
+	unsigned long session_data[0] __attribute__ ((aligned (sizeof(unsigned long))));
+};
+
+#define transport_class_to_session(cdev) \
+	container_of(cdev, struct iscsi_class_session, class_dev)
+
+struct iscsi_host {
+	struct Scsi_Host *shost;
+	struct list_head list;
+
+	struct list_head sessions;
+	struct semaphore sem;
 };
 
 /*
  * accessor macros
  */
-#define iscsi_isid(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->isid)
-#define iscsi_tsih(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->tsih)
-#define iscsi_header_digest(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->header_digest)
-#define iscsi_data_digest(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_digest)
-#define iscsi_port(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->port)
-#define iscsi_addr_type(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->addr_type)
-#define iscsi_sin_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin_addr)
-#define iscsi_sin6_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin6_addr)
-#define iscsi_tpgt(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->tpgt)
-#define iscsi_initial_r2t(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->initial_r2t)
-#define iscsi_immediate_data(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->immediate_data)
-#define iscsi_max_recv_data_segment_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_recv_data_segment_len)
-#define iscsi_max_burst_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_burst_len)
-#define iscsi_first_burst_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->first_burst_len)
-#define iscsi_def_time2wait(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2wait)
-#define iscsi_def_time2retain(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2retain)
-#define iscsi_max_outstanding_r2t(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_outstanding_r2t)
-#define iscsi_data_pdu_in_order(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_pdu_in_order)
-#define iscsi_data_sequence_in_order(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_sequence_in_order)
-#define iscsi_erl(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->erl)
+#define iscsi_isid(x) x->isid
+#define iscsi_tsih(x) x->tsih
+#define iscsi_header_digest(x) x->header_digest
+#define iscsi_data_digest(x) x->data_digest
+#define iscsi_port(x) x->port
+#define iscsi_addr_type(x) x->addr_type
+#define iscsi_sin_addr(x) x->u.sin_addr
+#define iscsi_sin6_addr(x) x->u.sin6_addr
+#define iscsi_tpgt(x) x->tpgt
+#define iscsi_initial_r2t(x) x->initial_r2t
+#define iscsi_immediate_data(x) x->immediate_data
+#define iscsi_max_recv_data_segment_len(x) x->max_recv_data_segment_len
+#define iscsi_max_burst_len(x) x->max_burst_len
+#define iscsi_first_burst_len(x) x->first_burst_len
+#define iscsi_def_time2wait(x) x->def_time2wait
+#define iscsi_def_time2retain(x) x->def_time2retain
+#define iscsi_max_outstanding_r2t(x) x->max_outstanding_r2t
+#define iscsi_data_pdu_in_order(x) x->data_pdu_in_order
+#define iscsi_data_sequence_in_order(x) x->data_sequence_in_order
+#define iscsi_erl(x) x->erl
 
 /*
  * The functions by which the transport class and the driver communicate
  */
 struct iscsi_function_template {
+	struct module *owner;
 	/*
-	 * target attrs
+	 * session attrs
 	 */
-	void (*get_isid)(struct scsi_target *);
-	void (*get_tsih)(struct scsi_target *);
-	void (*get_header_digest)(struct scsi_target *);
-	void (*get_data_digest)(struct scsi_target *);
-	void (*get_port)(struct scsi_target *);
-	void (*get_tpgt)(struct scsi_target *);
+	void (*get_isid)(struct iscsi_class_session *);
+	void (*get_tsih)(struct iscsi_class_session *);
+	void (*get_header_digest)(struct iscsi_class_session *);
+	void (*get_data_digest)(struct iscsi_class_session *);
+	void (*get_port)(struct iscsi_class_session *);
+	void (*get_tpgt)(struct iscsi_class_session *);
 	/*
 	 * In get_ip_address the lld must set the address and
 	 * the address type
 	 */
-	void (*get_ip_address)(struct scsi_target *);
+	void (*get_ip_address)(struct iscsi_class_session *);
 	/*
 	 * The lld should snprintf the name or alias to the buffer
 	 */
-	ssize_t (*get_target_name)(struct scsi_target *, char *, ssize_t);
-	ssize_t (*get_target_alias)(struct scsi_target *, char *, ssize_t);
-	void (*get_initial_r2t)(struct scsi_target *);
-	void (*get_immediate_data)(struct scsi_target *);
-	void (*get_max_recv_data_segment_len)(struct scsi_target *);
-	void (*get_max_burst_len)(struct scsi_target *);
-	void (*get_first_burst_len)(struct scsi_target *);
-	void (*get_def_time2wait)(struct scsi_target *);
-	void (*get_def_time2retain)(struct scsi_target *);
-	void (*get_max_outstanding_r2t)(struct scsi_target *);
-	void (*get_data_pdu_in_order)(struct scsi_target *);
-	void (*get_data_sequence_in_order)(struct scsi_target *);
-	void (*get_erl)(struct scsi_target *);
-
-	/*
-	 * host atts
-	 */
-
+	ssize_t (*get_target_name)(struct iscsi_class_session *, char *,
+				   ssize_t);
+	ssize_t (*set_target_name)(struct iscsi_class_session *, const char *,
+				   size_t);
+	ssize_t (*get_target_alias)(struct iscsi_class_session *, char *,
+				    ssize_t);
+	void (*get_initial_r2t)(struct iscsi_class_session *);
+	void (*get_immediate_data)(struct iscsi_class_session *);
+	void (*get_max_recv_data_segment_len)(struct iscsi_class_session *);
+	void (*get_max_burst_len)(struct iscsi_class_session *);
+	void (*get_first_burst_len)(struct iscsi_class_session *);
+	void (*get_def_time2wait)(struct iscsi_class_session *);
+	void (*get_def_time2retain)(struct iscsi_class_session *);
+	void (*get_max_outstanding_r2t)(struct iscsi_class_session *);
+	void (*get_data_pdu_in_order)(struct iscsi_class_session *);
+	void (*get_data_sequence_in_order)(struct iscsi_class_session *);
+	void (*get_erl)(struct iscsi_class_session *);
 	/*
-	 * The lld should snprintf the name or alias to the buffer
+	 * host attrs
 	 */
 	ssize_t (*get_initiator_alias)(struct Scsi_Host *, char *, ssize_t);
+	ssize_t (*set_initiator_alias)(struct Scsi_Host *, const char *,
+				       size_t);
 	ssize_t (*get_initiator_name)(struct Scsi_Host *, char *, ssize_t);
+	ssize_t (*set_initiator_name)(struct Scsi_Host *, const char *,
+				      size_t);
 	/*
 	 * The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
-	 * class. We could probably just test if a get_ fn was set
-	 * since we only use the values for sysfs but this is how
-	 * fc does it too.
+	 * class.
 	 */
 	unsigned long show_isid:1;
 	unsigned long show_tsih:1;
@@ -170,9 +179,50 @@ struct iscsi_function_template {
 	unsigned long show_erl:1;
 	unsigned long show_initiator_name:1;
 	unsigned long show_initiator_alias:1;
+
+	/*
+	 * session management functions
+	 */
+	/*
+	 * called when the a sessions is added
+	 */
+	unsigned long show_add_session:1;
+	int (*setup_session)(struct iscsi_class_session *);
+	/*
+	 * LLDs should close the session from this function.
+	 * It is called from the close session attr and from
+	 * remove session
+	 */
+	unsigned long show_remove_session:1;
+	unsigned long show_close_session:1;
+	void (*close_session)(struct iscsi_class_session *);
+	/*
+	 * LLDs should establish a session with the
+	 * settings in the iscsi_class_session structure
+	 */
+	unsigned long show_establish_session:1;
+	int (*establish_session)(struct iscsi_class_session *);
+	/*
+	 * LLDs should close the existing session then establish
+	 * a new session with the values in the iscsi_class_session
+	 * passed in.
+	 */
+	unsigned long show_update_session:1;
+	int (*update_session)(struct iscsi_class_session *);
+	/*
+	 * Allows a LLD to free any private resources allocated for
+	 * the session when there are no references to the session left
+	 */
+	void (*release_session)(struct iscsi_class_session *);
+
+	/*
+	 * LLD hostdata sizes
+	 */
+	size_t session_hostdata_size;
 };
 
 struct scsi_transport_template *iscsi_attach_transport(struct iscsi_function_template *);
 void iscsi_release_transport(struct scsi_transport_template *);
-
+int __iscsi_for_each_iscsi_host(struct scsi_transport_template *t,
+				int (*fn)(struct Scsi_Host *));
 #endif

--------------050402060204010009070600--
