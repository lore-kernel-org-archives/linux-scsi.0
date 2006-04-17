From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] FC Transport : Async Events via netlink interface
Date: Mon, 17 Apr 2006 16:44:21 -0400
Message-ID: <1145306661.4151.0.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64448 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751241AbWDQUoL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 16:44:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k3HKi9rv016410
	for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2006 13:44:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[netdev folks copied to review the use of the netlink interface]

This patch adds HBAAPI async event support to the FC transport.

Events are pushed to userspace via Netlink. This is per the previous
RFC comments given in :
  http://marc.theaimsgroup.com/?l=linux-scsi&m=114062896729418&w=2

This patch contains the following changes:
  - Add Netlink support to the FC transport
  - Creates a new file "include/scsi/scsi_netlink_fc.h", which
    contains the user-space visible portion of the FC transport
    netlink messaging
  - Allow user apps to register to receive async events
  - Add the fc_host_event_post() interface to post async events
  - A couple of misc fixes:
     - From the prior event post: small dev_loss_tmo mods, with the
       main fix to validate the module parameter on load.
     - Fix fc_user_scan() so it safely walks the rport list

Using netlink worked out very well, and solves the multiple receiver issue.
Also looks very extensible for additional HBAAPI function support.

-- james s

PS: Comments on Kconfig change appreciated. I don't have much experience on
  changing the kernel config and build process.



Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2006-03-29 11:53:24.000000000 -0500
+++ b/drivers/scsi/Kconfig	2006-04-17 12:03:31.000000000 -0400
@@ -221,7 +221,7 @@ config SCSI_SPI_ATTRS
 
 config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
-	depends on SCSI
+	depends on SCSI && NET && NETFILTER && NETFILTER_NETLINK
 	help
 	  If you wish to export transport-specific information about
 	  each attached FiberChannel device to sysfs, say Y.
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-04-10 09:02:15.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-04-17 11:24:53.000000000 -0400
@@ -33,9 +33,17 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_cmnd.h>
 #include "scsi_priv.h"
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <linux/security.h>
+#include <net/sock.h>
+#include <net/netlink.h>
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 
+#define get_list_head_entry(pos, head, member) 		\
+	pos = list_entry((head)->next, typeof(*pos), member)
+
 /*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
@@ -132,6 +140,29 @@ fc_enum_name_match(tgtid_bind_type, fc_t
 #define FC_BINDTYPE_MAX_NAMELEN	30
 

+/* Convert fc_host_event_code values to ascii string name */
+static const struct {
+	enum fc_host_event_code		value;
+	char				*name;
+} fc_host_event_code_names[] = {
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
+fc_enum_name_search(host_event_code, fc_host_event_code,
+		fc_host_event_code_names)
+#define FC_HOST_EVENT_CODE_MAX_NAMELEN	30
+
+
 #define fc_bitfield_name_search(title, table)			\
 static ssize_t							\
 get_fc_##title##_names(u32 table_key, char *buf)		\
@@ -368,9 +399,9 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  *   should insulate the loss of a remote port.
  *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
  */
-static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+static unsigned int fc_modp_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
 
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
+module_param_named(dev_loss_tmo, fc_modp_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
@@ -378,19 +409,366 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 

+/**
+ * Netlink Infrastructure
+ **/
+
+#include <scsi/scsi_netlink_fc.h>
+
+struct fc_nl_user {
+	struct list_head ulist;
+	int pid;
+	u32 flags;
+};
+
+/* fc_nl_user flags values */
+#define FC_NL_UF_EVENTS		0x01
+
+static struct sock *fc_nl_sock;
+static DEFINE_SPINLOCK(fc_nl_lock);
+static u32 fc_event_seq;
+static struct list_head fc_nl_user_list;
+
+#define FC_NL_GROUP_CNT		0
+
+static inline struct fc_nl_user *
+fc_find_user(int pid)
+{
+	struct fc_nl_user *nluser;
+
+	list_for_each_entry(nluser, &fc_nl_user_list, ulist)
+		if (nluser->pid == pid)
+			return nluser;
+	return NULL;
+}
+
+static struct fc_nl_user *
+fc_add_user(int pid, int uflag)
+{
+	struct fc_nl_user *nluser, *newuser;
+	unsigned long flags;
+
+	/* pre-guess we need to add a user struct */
+	newuser = kzalloc(sizeof(struct fc_nl_user), GFP_KERNEL);
+
+	spin_lock_irqsave(&fc_nl_lock, flags);
+
+	nluser = fc_find_user(pid);
+	if (!nluser) {
+		if (newuser) {
+			newuser->pid = pid;
+			newuser->flags = uflag;
+			list_add_tail(&newuser->ulist, &fc_nl_user_list);
+		} 
+	} else
+		nluser->flags |= uflag;
+
+	spin_unlock_irqrestore(&fc_nl_lock, flags);
+
+	if (nluser) {
+		kfree(newuser);
+		return nluser;
+	}
+
+	return newuser;
+}
+
+static void
+fc_del_user(int pid, int uflag)
+{
+	struct fc_nl_user *nluser;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fc_nl_lock, flags);
+
+	nluser = fc_find_user(pid);
+	if (nluser) {
+		nluser->flags &= ~uflag;
+		if (!nluser->flags)
+			list_del(&nluser->ulist);
+	}
+
+	spin_unlock_irqrestore(&fc_nl_lock, flags);
+
+	if (nluser && !nluser->flags)
+		kfree(nluser);
+}
+
+static int
+fc_handle_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, int rcvlen)
+{
+	struct fc_nl_hdr *fch = NLMSG_DATA(nlh);
+	struct fc_nl_user *nluser;
+	int err = 0, pid;
+
+	pid = nlh->nlmsg_pid;
+
+	switch (fch->msgtype) {
+	case FC_NL_EVENTS_REG:
+		nluser = fc_add_user(pid, FC_NL_UF_EVENTS);
+		if (!nluser) {
+			printk(KERN_WARNING "%s: EVT REG failed\n",
+				__FUNCTION__);
+			err = -ENOMEM;
+		}
+		break;
+
+	case FC_NL_EVENTS_DEREG:
+		fc_del_user(pid, FC_NL_UF_EVENTS);
+		break;
+
+	default:
+		printk(KERN_WARNING "%s: unknown msg type 0x%x len %d\n",
+			 __FUNCTION__, fch->msgtype, rcvlen);
+		err = -EBADR;
+		break;
+	}
+
+	return err;
+}
+
+static void
+fc_nl_rcv_msg(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh;
+	struct fc_nl_hdr *fch;
+	uint32_t rlen;
+	int err;
+
+	while (skb->len >= NLMSG_SPACE(0)) {
+		err = 0;
+
+		nlh = (struct nlmsghdr *) skb->data;
+		if ((nlh->nlmsg_len < (sizeof(*nlh) + sizeof(*fch))) ||
+		    (skb->len < nlh->nlmsg_len)) {
+			printk(KERN_WARNING "%s: discarding partial skb\n",
+				 __FUNCTION__);
+			return;
+		}
+
+		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (rlen > skb->len)
+			rlen = skb->len;
+
+		if (nlh->nlmsg_type != FC_TRANSPORT_MSG) {
+			err = -EBADMSG;
+			goto next_msg;
+		}
+
+		fch = NLMSG_DATA(nlh);
+		if (fch->version != FC_NETLINK_API_VERSION) {
+			err = -EPROTOTYPE;
+			goto next_msg;
+		}
+
+		if (security_netlink_recv(skb)) {
+			err = -EPERM;
+			goto next_msg;
+		}
+
+		err = fc_handle_nl_rcv_msg(skb, nlh, rlen);
+
+next_msg:
+		if ((err) || (nlh->nlmsg_flags & NLM_F_ACK))
+			netlink_ack(skb, nlh, err);
+
+		skb_pull(skb, rlen);
+	}
+}
+
+static void
+fc_nl_rcv(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
+		fc_nl_rcv_msg(skb);
+		kfree_skb(skb);
+	}
+}
+
+static int
+fc_nl_rcv_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	if ((event == NETLINK_URELEASE) &&
+	    (n->protocol == NETLINK_FCTRANSPORT) && (n->pid))
+		fc_del_user(n->pid, 0xFFFFFFFF);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block fc_netlink_notifier = {
+	.notifier_call  = fc_nl_rcv_nl_event,
+};
+
+
+static void
+fc_send_event(struct fc_nl_user *nluser, struct fc_nl_event *event)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr	*nlh;
+	struct fc_nl_event *evt;
+	const char *name, *fn;
+	u32 len = NLMSG_SPACE(sizeof(*event));
+	int err;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		err = -ENOBUFS;
+		fn = "alloc_skb";
+		goto send_fail;
+	}
+
+	nlh = nlmsg_put(skb, nluser->pid, 0, FC_TRANSPORT_MSG,
+			len - sizeof(*nlh), 0);
+	if (!nlh) {
+		err = -ENOBUFS;
+		fn = "nlmsg_put";
+		goto send_fail;
+	}
+	evt = NLMSG_DATA(nlh);
+	memcpy(evt, event, sizeof(*event));
+
+	err = nlmsg_unicast(fc_nl_sock, skb, nluser->pid);
+	if (err < 0) {
+		fn = "nlmsg_unicast";
+		goto send_fail;
+	}
+
+	return;
+
+send_fail:
+	name = get_fc_host_event_code_name(event->event_code);
+	printk(KERN_WARNING
+		"%s: Dropped Event to PID %d : %s data 0x%08x : %s : err %d\n",
+		__FUNCTION__, nluser->pid, (name) ? name : "<unknown>",
+		event->event_data, fn, err);
+	return;
+}
+
+/**
+ * fc_host_event_post - called to post an even on an fc_host.
+ *
+ * @shost:	host the event occurred on
+ * @event:	event being posted
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ *
+ *      We always reserve one element in the event list so that the
+ *      ring logic is easier (e.g. empty is get=put, full is put+1=get)
+ **/
+void
+fc_host_event_post(struct Scsi_Host *shost,
+		enum fc_host_event_code event_code, u32 event_data)
+{
+	struct fc_nl_user *nluser, *next_nluser;
+	struct fc_nl_event *event;
+	struct timeval tv;
+	unsigned long flags;
+	u32 seq;
+
+	if (!fc_nl_sock || list_empty(&fc_nl_user_list))
+		return;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event) {
+		const char *name = get_fc_host_event_code_name(event_code);
+		printk(KERN_WARNING
+			"%s: Dropped Event : %s data 0x%08x - ENOMEM\n",
+			__FUNCTION__, (name) ? name : "<unknown>", event_data);
+		return;
+	}
+
+	spin_lock_irqsave(&fc_nl_lock, flags);
+	seq = fc_event_seq++;
+	spin_unlock_irqrestore(&fc_nl_lock, flags);
+	do_gettimeofday(&tv);
+
+	event->fcnlh.msgtype = FC_NL_ASYNC_EVENT;
+	event->fcnlh.version = FC_NETLINK_API_VERSION;
+	event->fcnlh.reserved1 = 0;
+	event->fcnlh.reserved2 = 0;
+	event->seq_num = seq;
+	event->host_no = shost->host_no;
+	event->event_code = event_code;
+	event->event_data = event_data;
+	event->tv_sec = tv.tv_sec;
+	event->tv_usec = tv.tv_usec;
+
+	list_for_each_entry_safe(nluser, next_nluser, &fc_nl_user_list, ulist) {
+		if (nluser->flags & FC_NL_UF_EVENTS)
+			fc_send_event(nluser, event);
+	}
+	
+	kfree(event);
+}
+EXPORT_SYMBOL(fc_host_event_post);
+
+
 static __init int fc_transport_init(void)
 {
-	int error = transport_class_register(&fc_host_class);
+	int error;
+
+	/* fix any module parameters */
+
+	if ((fc_modp_dev_loss_tmo < 1) ||
+	    (fc_modp_dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)) {
+		printk(KERN_WARNING
+			"%s: dev_loss_tmo out of range, setting to max (%d)\n",
+			__FUNCTION__, SCSI_DEVICE_BLOCK_MAX_TIMEOUT);
+		fc_modp_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+	}
+
+	INIT_LIST_HEAD(&fc_nl_user_list);
+
+	/* register the transport classes */
+
+	error = transport_class_register(&fc_host_class);
 	if (error)
 		return error;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
-		return error;
-	return transport_class_register(&fc_transport_class);
+		goto rport_class_out;
+	error = transport_class_register(&fc_transport_class);
+	if (error)
+		goto transport_class_out;
+
+	error = netlink_register_notifier(&fc_netlink_notifier);
+	if (error)
+		goto register_out;
+
+	fc_nl_sock = netlink_kernel_create(NETLINK_FCTRANSPORT, FC_NL_GROUP_CNT,
+					fc_nl_rcv, THIS_MODULE);
+	if (!fc_nl_sock) {
+		error = -ENOBUFS;
+	} else
+		return error;		/* successful return */
+
+	netlink_unregister_notifier(&fc_netlink_notifier);
+register_out:
+	transport_class_unregister(&fc_transport_class);
+transport_class_out:
+	transport_class_unregister(&fc_rport_class);
+rport_class_out:
+	transport_class_unregister(&fc_host_class);
+
+	return error;
 }
 
 static void __exit fc_transport_exit(void)
 {
+	struct fc_nl_user *nluser;
+
+	sock_release(fc_nl_sock->sk_socket);
+	netlink_unregister_notifier(&fc_netlink_notifier);
+	while (!list_empty(&fc_nl_user_list)) {
+		get_list_head_entry(nluser, &fc_nl_user_list, ulist);
+		list_del(&nluser->ulist);
+		kfree(nluser);
+	}
 	transport_class_unregister(&fc_transport_class);
 	transport_class_unregister(&fc_rport_class);
 	transport_class_unregister(&fc_host_class);
@@ -874,9 +1252,6 @@ show_fc_private_host_tgtid_bind_type(str
 	return snprintf(buf, FC_BINDTYPE_MAX_NAMELEN, "%s\n", name);
 }
 
-#define get_list_head_entry(pos, head, member) 		\
-	pos = list_entry((head)->next, typeof(*pos), member)
-
 static ssize_t
 store_fc_private_host_tgtid_bind_type(struct class_device *cdev,
 	const char *buf, size_t count)
@@ -1142,14 +1517,24 @@ fc_timed_out(struct scsi_cmnd *scmd)
 }
 
 /*
- * Must be called with shost->host_lock held
+ * fc_user_scan - Sysfs interface to scan
+ *
+ * @shost:	The scsi host scan to occur on
+ * @channel:	Channel # to scan
+ * @id:		Target ID # to scan
+ * @lun:	Lun # to scan
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
  */
-static int fc_user_scan(struct Scsi_Host *shost, uint channel,
+static int
+fc_user_scan(struct Scsi_Host *shost, uint channel,
 		uint id, uint lun)
 {
-	struct fc_rport *rport;
+	struct fc_rport *rport, *next_rport;
 
-	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
+	list_for_each_entry_safe(rport, next_rport,
+			&fc_host_rports(shost), peers) {
 		if (rport->scsi_target_id == -1)
 			continue;
 
@@ -1278,6 +1663,7 @@ void fc_release_transport(struct scsi_tr
 }
 EXPORT_SYMBOL(fc_release_transport);
 
+
 /**
  * fc_queue_work - Queue work to the fc_host workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
@@ -1514,7 +1900,7 @@ fc_rport_create(struct Scsi_Host *shost,
 
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->dev_loss_tmo = fc_dev_loss_tmo;
+	rport->dev_loss_tmo = fc_modp_dev_loss_tmo;
 	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
 	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
 	rport->port_id = ids->port_id;
diff -upNr a/include/linux/netlink.h b/include/linux/netlink.h
--- a/include/linux/netlink.h	2006-04-12 12:52:37.000000000 -0400
+++ b/include/linux/netlink.h	2006-04-12 12:53:01.000000000 -0400
@@ -21,6 +21,8 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
+/* leave room for NETLINK_DM (DM Events) and NETLINK_TGT (SCSI Target) */
+#define NETLINK_FCTRANSPORT	19	/* SCSI FC Transport */
 
 #define MAX_LINKS 32		
 
diff -upNr a/include/scsi/scsi_netlink_fc.h b/include/scsi/scsi_netlink_fc.h
--- a/include/scsi/scsi_netlink_fc.h	1969-12-31 19:00:00.000000000 -0500
+++ b/include/scsi/scsi_netlink_fc.h	2006-04-17 09:51:08.000000000 -0400
@@ -0,0 +1,57 @@
+/* 
+ *  FiberChannel transport Netlink Interface
+ *
+ *  Copyright (C) 2006   James Smart, Emulex Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+#ifndef SCSI_NETLINK_FC_H
+#define SCSI_NETLINK_FC_H
+
+#define FC_NETLINK_API_VERSION		1
+
+/* Single Netlink Message type to send all FC Transport messages */
+#define FC_TRANSPORT_MSG		NLMSG_MIN_TYPE + 1
+
+/* FC transport header - found at the front of all FC_TRANSPORT_MSG messages */
+struct fc_nl_hdr {
+	uint16_t msgtype;
+	uint16_t version;
+	uint16_t reserved1;
+	uint16_t reserved2;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+/* FC Transport Message Types */
+	/* user -> kernel */
+#define FC_NL_EVENTS_REG		0x0001
+#define FC_NL_EVENTS_DEREG		0x0002
+	/* kernel -> user */
+#define FC_NL_ASYNC_EVENT		0x0100
+
+/* Asynchronous Event Message */
+struct fc_nl_event {
+	struct fc_nl_hdr fcnlh;
+	uint32_t seq_num;
+	uint32_t host_no;
+	uint32_t event_code;
+	uint32_t event_data;
+	uint64_t tv_sec;
+	uint64_t tv_usec;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+
+#endif /* SCSI_NETLINK_FC_H */
+
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-04-10 08:46:47.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-04-17 11:42:20.000000000 -0400
@@ -285,6 +285,30 @@ struct fc_host_statistics {
 

 /*
+ * FC Event Codes - Polled and Async, following FC HBAAPI v2.0 guidelines
+ */
+
+/*
+ * fc_host_event_code: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_host_event_code  {
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
+
+/*
  * FC Local Port (Host) Attributes
  *
  * Attributes are based on HBAAPI V2.0 definitions.
@@ -493,6 +517,15 @@ fc_remote_port_chkready(struct fc_rport 
 }
 

+static inline u64 wwn_to_u64(u8 *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+	    (u64)wwn[6] <<  8 | (u64)wwn[7];
+}
+
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
@@ -502,13 +535,8 @@ struct fc_rport *fc_remote_port_add(stru
 void fc_remote_port_delete(struct fc_rport  *rport);
 void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
 int scsi_is_fc_rport(const struct device *);
+void fc_host_event_post(struct Scsi_Host *shost,
+		enum fc_host_event_code event_code, u32 event_data);
 
-static inline u64 wwn_to_u64(u8 *wwn)
-{
-	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
-	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
-	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
-	    (u64)wwn[6] <<  8 | (u64)wwn[7];
-}
 
 #endif /* SCSI_TRANSPORT_FC_H */



