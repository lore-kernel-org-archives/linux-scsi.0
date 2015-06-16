From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] iSCSI: let session recovery_tmo sysfs writes persist across recovery
Date: Tue, 16 Jun 2015 16:07:13 -0700
Message-ID: <1434496033-4601-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBM6YQKWAKGQENDVQZ7A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

The iSCSI session recovery_tmo setting is writeable in sysfs, but it's
also set every time a connection is established when parameters are set
from iscsid over netlink.  That results in the timeout being reset to
the default value after every recovery.

The DM multipath tools want to use the sysfs interface to lower the
default timeout when there are multiple paths to fail over.  It has
caused confusion that we have a writeable sysfs value that seem to keep
resetting itself.

This patch adds an in-kernel flag that gets set once a sysfs write
occurs, and then ignores netlink parameter setting once it's been
modified via the sysfs interface.  My thinking here is that the sysfs
interface is much simpler for external tools to influence the session
timeout, but if we're going to allow it to be modified directly we
should ensure that setting is maintained.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 11 ++++++++---
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 67d43e3..35ef55f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2040,6 +2040,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	session->transport = transport;
 	session->creator = -1;
 	session->recovery_tmo = 120;
+	session->recovery_tmo_sysfs_override = false;
 	session->state = ISCSI_SESSION_FREE;
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
 	INIT_LIST_HEAD(&session->sess_list);
@@ -2784,7 +2785,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	switch (ev->u.set_param.param) {
 	case ISCSI_PARAM_SESS_RECOVERY_TMO:
 		sscanf(data, "%d", &value);
-		session->recovery_tmo = value;
+		if (!session->recovery_tmo_sysfs_override)
+			session->recovery_tmo = value;
 		break;
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
@@ -4047,13 +4049,15 @@ store_priv_session_##field(struct device *dev,				\
 	if ((session->state == ISCSI_SESSION_FREE) ||			\
 	    (session->state == ISCSI_SESSION_FAILED))			\
 		return -EBUSY;						\
-	if (strncmp(buf, "off", 3) == 0)				\
+	if (strncmp(buf, "off", 3) == 0) {				\
 		session->field = -1;					\
-	else {								\
+		session->field##_sysfs_override = true;			\
+	} else {							\
 		val = simple_strtoul(buf, &cp, 0);			\
 		if (*cp != '\0' && *cp != '\n')				\
 			return -EINVAL;					\
 		session->field = val;					\
+		session->field##_sysfs_override = true;			\
 	}								\
 	return count;							\
 }
@@ -4064,6 +4068,7 @@ store_priv_session_##field(struct device *dev,				\
 static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 			show_priv_session_##field,			\
 			store_priv_session_##field)
+
 iscsi_priv_session_rw_attr(recovery_tmo, "%d");
 
 static struct attribute *iscsi_session_attrs[] = {
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 2555ee5..6183d20 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -241,6 +241,7 @@ struct iscsi_cls_session {
 
 	/* recovery fields */
 	int recovery_tmo;
+	bool recovery_tmo_sysfs_override;
 	struct delayed_work recovery_work;
 
 	unsigned int target_id;
-- 
2.1.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
