From: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Fri, 12 Feb 2016 09:38:53 -0800
Message-ID: <1455298733-18651-1-git-send-email-lduncan@suse.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD54HHNYIIINPMXYWUCRUBDQJRD72-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The scsi_transport_iscsi module already uses the ida_simple
routines for managing the target ID, if requested to do
so. This change replaces an ever-increasing atomic integer
that tracks the session ID itself with the ida_simple
family of routines. This means that the session ID
will be reclaimed and can be reused when the session
is freed.

Note that no maximum is placed on this value, though
user-space currently only seems to use the lower 24-bits.
It seems better to handle this in user space, though,
than to limit the value range for the session ID here.

Signed-off-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441481623fb9..50a10bf214a8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -79,7 +79,8 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
+static DEFINE_IDA(iscsi_session_id_ida);
+
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
 static DEFINE_IDA(iscsi_sess_ida);
@@ -2074,7 +2075,12 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	int err;
 
 	ihost = shost->shost_data;
-	session->sid = atomic_add_return(1, &iscsi_session_nr);
+	session->sid = ida_simple_get(&iscsi_session_id_ida, 0, 0, GFP_KERNEL);
+	if (session->sid < 0) {
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "Failure in Session ID Allocation\n");
+		return session->sid;
+	}
 
 	if (target_id == ISCSI_MAX_TARGET) {
 		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
@@ -2082,7 +2088,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		if (id < 0) {
 			iscsi_cls_session_printk(KERN_ERR, session,
 					"Failure in Target ID Allocation\n");
-			return id;
+			err = id;
+			goto release_session_id_ida;
 		}
 		session->target_id = (unsigned int)id;
 		session->ida_used = true;
@@ -2109,6 +2116,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 release_ida:
 	if (session->ida_used)
 		ida_simple_remove(&iscsi_sess_ida, session->target_id);
+release_session_id_ida:
+	ida_simple_remove(&iscsi_session_id_ida, session->target_id);
 
 	return err;
 }
@@ -2214,6 +2223,7 @@ void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
 	iscsi_session_event(session, ISCSI_KEVENT_DESTROY_SESSION);
+	ida_simple_remove(&iscsi_session_id_ida, session->target_id);
 	put_device(&session->dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_free_session);
@@ -4524,8 +4534,6 @@ static __init int iscsi_transport_init(void)
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
-	atomic_set(&iscsi_session_nr, 0);
-
 	err = class_register(&iscsi_transport_class);
 	if (err)
 		return err;
@@ -4598,6 +4606,7 @@ static void __exit iscsi_transport_exit(void)
 	class_unregister(&iscsi_endpoint_class);
 	class_unregister(&iscsi_iface_class);
 	class_unregister(&iscsi_transport_class);
+	ida_destroy(&iscsi_session_id_ida);
 }
 
 module_init(iscsi_transport_init);
-- 
2.1.4

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
