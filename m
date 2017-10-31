From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/9] iscsi: convert flashnode devices from bus to class
Date: Tue, 31 Oct 2017 15:41:02 -0700
Message-ID: <20171031224104.17735-8-cleech@redhat.com>
References: <20171031224104.17735-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBJXY4PHQKGQEUIPW7BY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20171031224104.17735-1-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA4XXX iSCSI DRIVER" <QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The flashnode session and connection devices should be filtered by net
namespace along with the iscsi_host, but we can't do that with a bus
device.  As these don't use any of the bus matching functionality, they
make more sense as a class device anyway.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
 drivers/scsi/scsi_transport_iscsi.c | 36 +++++++++++++++---------------------
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 770313d0b986..55a729568873 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7164,7 +7164,7 @@ static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev, void *data)
 {
 	struct iscsi_bus_flash_session *fnode_sess;
 
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fbec3a019f00..b053d57a482d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1060,6 +1060,12 @@ static const struct device_type iscsi_flashnode_sess_dev_type = {
 	.release = iscsi_flashnode_sess_release,
 };
 
+bool iscsi_is_flashnode_session_dev(struct device *dev)
+{
+	return dev->type == &iscsi_flashnode_sess_dev_type;
+}
+EXPORT_SYMBOL_GPL(iscsi_is_flashnode_session_dev);
+
 /* flash node connection attrs show */
 #define iscsi_flashnode_conn_attr_show(type, name, param)		\
 static ssize_t								\
@@ -1246,20 +1252,8 @@ static const struct device_type iscsi_flashnode_conn_dev_type = {
 	.release = iscsi_flashnode_conn_release,
 };
 
-static struct bus_type iscsi_flashnode_bus;
-
-int iscsi_flashnode_bus_match(struct device *dev,
-				     struct device_driver *drv)
-{
-	if (dev->bus == &iscsi_flashnode_bus)
-		return 1;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iscsi_flashnode_bus_match);
-
-static struct bus_type iscsi_flashnode_bus = {
+static struct class iscsi_flashnode_bus = {
 	.name = "iscsi_flashnode",
-	.match = &iscsi_flashnode_bus_match,
 };
 
 /**
@@ -1290,7 +1284,7 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 	fnode_sess->transport = transport;
 	fnode_sess->target_id = index;
 	fnode_sess->dev.type = &iscsi_flashnode_sess_dev_type;
-	fnode_sess->dev.bus = &iscsi_flashnode_bus;
+	fnode_sess->dev.class = &iscsi_flashnode_bus;
 	fnode_sess->dev.parent = &shost->shost_gendev;
 	dev_set_name(&fnode_sess->dev, "flashnode_sess-%u:%u",
 		     shost->host_no, index);
@@ -1338,7 +1332,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	fnode_conn->transport = transport;
 	fnode_conn->dev.type = &iscsi_flashnode_conn_dev_type;
-	fnode_conn->dev.bus = &iscsi_flashnode_bus;
+	fnode_conn->dev.class = &iscsi_flashnode_bus;
 	fnode_conn->dev.parent = &fnode_sess->dev;
 	dev_set_name(&fnode_conn->dev, "flashnode_conn-%u:%u:0",
 		     shost->host_no, fnode_sess->target_id);
@@ -1371,7 +1365,7 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  */
 static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
-	return dev->bus == &iscsi_flashnode_bus;
+	return dev->type == &iscsi_flashnode_conn_dev_type;
 }
 
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
@@ -1385,7 +1379,7 @@ static int flashnode_match_index(struct device *dev, void *data)
 	struct iscsi_bus_flash_session *fnode_sess = NULL;
 	int ret = 0;
 
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		goto exit_match_index;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
@@ -1491,7 +1485,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_flashnode_sess);
 
 static int iscsi_iter_destroy_flashnode_fn(struct device *dev, void *data)
 {
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		return 0;
 
 	iscsi_destroy_flashnode_sess(iscsi_dev_to_flash_session(dev));
@@ -4752,7 +4746,7 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	err = bus_register(&iscsi_flashnode_bus);
+	err = class_register(&iscsi_flashnode_bus);
 	if (err)
 		goto unregister_session_class;
 
@@ -4773,7 +4767,7 @@ static __init int iscsi_transport_init(void)
 unregister_pernet_subsys:
 	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -4793,7 +4787,7 @@ static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_eh_timer_workq);
 	unregister_pernet_subsys(&iscsi_net_ops);
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 601e8633d495..2f461896e91f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -489,6 +489,8 @@ iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 extern struct device *
 iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
 
+extern bool iscsi_is_flashnode_session_dev(struct device *dev);
+
 extern char *
 iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
 extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
-- 
2.9.5

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
