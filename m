From: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] scsi: scsi_transport_iscsi: use put_device() instead of kfree()
Date: Wed,  7 Mar 2018 17:07:33 +0530
Message-ID: <a77739e256b044c2e125e106165efc751ce4a0f6.1520422535.git.arvind.yadav.cs@gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBD76TE7NVICBBME677KAKGQE4EESF3A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Never directly free @dev after calling device_register(), even
if it returned an error! Always use put_device() to give up the
reference initialized.

Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4b52b4..aacb7ab 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -221,8 +221,10 @@ struct iscsi_endpoint *
 	ep->dev.class = &iscsi_endpoint_class;
 	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
 	err = device_register(&ep->dev);
-        if (err)
-                goto free_ep;
+	if (err) {
+		put_device(&ep->dev);
+		return NULL;
+	}
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -235,10 +237,6 @@ struct iscsi_endpoint *
 unregister_dev:
 	device_unregister(&ep->dev);
 	return NULL;
-
-free_ep:
-	kfree(ep);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
@@ -783,7 +781,7 @@ struct iscsi_iface *
 
 free_iface:
 	put_device(iface->dev.parent);
-	kfree(iface);
+	put_device(&iface->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_iface);
@@ -1260,7 +1258,7 @@ struct iscsi_bus_flash_session *
 	return fnode_sess;
 
 free_fnode_sess:
-	kfree(fnode_sess);
+	put_device(&fnode_sess->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_sess);
@@ -1308,7 +1306,7 @@ struct iscsi_bus_flash_conn *
 	return fnode_conn;
 
 free_fnode_conn:
-	kfree(fnode_conn);
+	put_device(&fnode_conn->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
@@ -2268,6 +2266,8 @@ struct iscsi_cls_conn *
 
 release_parent_ref:
 	put_device(&session->dev);
+	put_device(&conn->dev);
+	conn = NULL;
 free_conn:
 	kfree(conn);
 	return NULL;
@@ -4420,8 +4420,10 @@ struct scsi_transport_template *
 	priv->dev.class = &iscsi_transport_class;
 	dev_set_name(&priv->dev, "%s", tt->name);
 	err = device_register(&priv->dev);
-	if (err)
-		goto free_priv;
+	if (err) {
+		put_device(&priv->dev);
+		return NULL;
+	}
 
 	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
 	if (err)
@@ -4456,9 +4458,6 @@ struct scsi_transport_template *
 unregister_dev:
 	device_unregister(&priv->dev);
 	return NULL;
-free_priv:
-	kfree(priv);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_register_transport);
 
-- 
1.9.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
