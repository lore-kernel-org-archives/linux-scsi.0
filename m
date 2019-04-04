From: Ming Lin <minggr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 1/1] scsi: sd: associate sd_probe_domain with scsi_disk
Date: Thu,  4 Apr 2019 16:04:05 -0700
Message-ID: <1554419045-20873-2-git-send-email-minggr@gmail.com>
References: <1554419045-20873-1-git-send-email-minggr@gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDUKPZWVXUMBB6U2TLSQKGQESWQ3C2Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1554419045-20873-1-git-send-email-minggr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: wangqiang62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, caijin.laurence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: "wangqiang (AY)" <wangqiang62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

sd_remove() waits for the completion of async threads executing sd_probe_async of disks
on unrelated host adapters, rather than just the the async thread associated with the
scsi_disk being removed.

This patch makes sd_remove() just wait for the the async thread associated with the
scsi_disk being removed. And makes the operation of iscsid after received ISCSI_KEVENT_CONN_ERROR
be asynchronous by put the __iscsi_destroy_session() in work queue.

Signed-off-by: "wangqiang (AY)" <wangqiang62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 +++++++++++++-
 drivers/scsi/sd.c                   |  5 +++--
 drivers/scsi/sd.h                   |  3 +++
 include/scsi/scsi_transport_iscsi.h |  1 +
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0a82e93566dc..7e5782eb527b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2005,6 +2005,16 @@ void iscsi_block_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
+static void __iscsi_destroy_session(struct work_struct *work)
+{
+	struct iscsi_cls_session *session =
+		container_of(work, struct iscsi_cls_session,
+                                    destroy_work);
+	struct iscsi_transport *transport = session->transport;
+
+	transport->destroy_session(session);
+}
+
 static void __iscsi_unbind_session(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
@@ -2061,6 +2071,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	INIT_WORK(&session->block_work, __iscsi_block_session);
 	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
 	INIT_WORK(&session->scan_work, iscsi_scan_session);
+	INIT_WORK(&session->destroy_work, __iscsi_destroy_session);
 	spin_lock_init(&session->lock);
 
 	/* this is released in the dev's release function */
@@ -3536,7 +3547,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
 		if (session)
-			transport->destroy_session(session);
+			scsi_queue_work(iscsi_session_to_shost(session),
+					&session->destroy_work);
 		else
 			err = -EINVAL;
 		break;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2b2bc4b49d78..378f57142183 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3436,7 +3436,8 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
+	INIT_LIST_HEAD(&sdkp->sd_probe_domain.pending);
+	async_schedule_domain(sd_probe_async, sdkp, &sdkp->sd_probe_domain);
 
 	return 0;
 
@@ -3472,7 +3473,7 @@ static int sd_remove(struct device *dev)
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
+	async_synchronize_full_domain(&sdkp->sd_probe_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5796ace76225..f46a87ebd759 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -2,6 +2,8 @@
 #ifndef _SCSI_DISK_H
 #define _SCSI_DISK_H
 
+#include <linux/async.h>
+
 /*
  * More than enough for everybody ;)  The huge number of majors
  * is a leftover from 16bit dev_t days, we don't really need that
@@ -73,6 +75,7 @@ struct scsi_disk {
 	struct device	dev;
 	struct gendisk	*disk;
 	struct opal_dev *opal_dev;
+	struct async_domain sd_probe_domain;
 #ifdef CONFIG_BLK_DEV_ZONED
 	u32		nr_zones;
 	u32		zone_blocks;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b266d2a3bcb1..7830e1596ef3 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -238,6 +238,7 @@ struct iscsi_cls_session {
 	struct work_struct unblock_work;
 	struct work_struct scan_work;
 	struct work_struct unbind_work;
+	struct work_struct destroy_work;
 
 	/* recovery fields */
 	int recovery_tmo;
-- 
2.14.4.52.g320db32

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
