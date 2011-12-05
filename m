From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi class: export pid of process that created
Date: Mon,  5 Dec 2011 16:44:01 -0600
Message-ID: <1323125041-29490-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab1LEWhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Dec 2011 17:37:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch was made over scsi-rc-fixes but could go to scsi-misc-2.6.

There could be multiple userspace entities creating/destroying/
recoverying sessions and also the kernel's iscsi drivers could
be doing this too. If the userspace apps do try to manage the kernel
ones it can get the driver/fw out of sync and cause the user to
loose the root disk, oopses or ping ponging becasue userspace
wants to do one thing but the kernel manager thought we
are trying to do another.

This patch fixes the problem by just exporting the pid of
the entity that created the session. Userspace programs like
iscsid, iscsiadm, iscsistart, qlogic's tools, etc, can then
figure out which sessions they own and only manage them.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   21 +++++++++++++++++++--
 include/scsi/scsi_transport_iscsi.h |    5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 96029e6..c1b172b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1030,6 +1030,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 		return NULL;
 
 	session->transport = transport;
+	session->creator = -1;
 	session->recovery_tmo = 120;
 	session->state = ISCSI_SESSION_FREE;
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
@@ -1634,8 +1635,9 @@ EXPORT_SYMBOL_GPL(iscsi_session_event);
 
 static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
-			struct iscsi_uevent *ev, uint32_t initial_cmdsn,
-			uint16_t cmds_max, uint16_t queue_depth)
+			struct iscsi_uevent *ev, pid_t pid,
+			uint32_t initial_cmdsn,	uint16_t cmds_max,
+			uint16_t queue_depth)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
@@ -1646,6 +1648,7 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 	if (!session)
 		return -ENOMEM;
 
+	session->creator = pid;
 	shost = iscsi_session_to_shost(session);
 	ev->r.c_session_ret.host_no = shost->host_no;
 	ev->r.c_session_ret.sid = session->sid;
@@ -1938,6 +1941,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ep, ev,
+					      NETLINK_CREDS(skb)->pid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
@@ -1950,6 +1954,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		}
 
 		err = iscsi_if_create_session(priv, ep, ev,
+					NETLINK_CREDS(skb)->pid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
@@ -2298,6 +2303,15 @@ show_priv_session_state(struct device *dev, struct device_attribute *attr,
 }
 static ISCSI_CLASS_ATTR(priv_sess, state, S_IRUGO, show_priv_session_state,
 			NULL);
+static ssize_t
+show_priv_session_creator(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev->parent);
+	return sprintf(buf, "%d\n", session->creator);
+}
+static ISCSI_CLASS_ATTR(priv_sess, creator, S_IRUGO, show_priv_session_creator,
+			NULL);
 
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
@@ -2367,6 +2381,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_targetalias.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
+	&dev_attr_priv_sess_creator.attr,
 	NULL,
 };
 
@@ -2424,6 +2439,8 @@ static mode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
 		return S_IRUGO;
+	else if (attr == &dev_attr_priv_sess_creator.attr)
+		return S_IRUGO;
 	else {
 		WARN_ONCE(1, "Invalid session attr");
 		return 0;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 5994bcc..c54cedc 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -211,6 +211,11 @@ struct iscsi_cls_session {
 	unsigned int target_id;
 	bool ida_used;
 
+	/*
+	 * pid of userspace process that created session or -1 if
+	 * created by the kernel.
+	 */
+	pid_t creator;
 	int state;
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
-- 
1.7.6

