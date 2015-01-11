From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 1/4] scsi: add ability to adjust module reference for scsi host
Date: Sun, 11 Jan 2015 22:50:03 +0900
Message-ID: <1420984206-22341-2-git-send-email-akinobu.mita@gmail.com>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420984206-22341-1-git-send-email-akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

While accessing a scsi_device, the use count of the underlying LLDD module
is incremented.  The module reference is retrieved through .module field of
struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except ufs, unusual usb storage drivers, and sub drivers for esp_scsi.
These drivers consist with core driver and actual LLDDs, and
scsi_host_template is defined in the core driver.  So the actual LLDDs can
be unloaded even if the scsi_device is being accessed.

This adds .module field in struct Scsi_Host and let the module reference
be retrieved though it instead of struct scsi_host_template.  This allows
the actual LLDDs adjust module reference.

Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
No change from v2

 drivers/scsi/hosts.c     | 1 +
 drivers/scsi/scsi.c      | 4 ++--
 include/scsi/scsi_host.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..21f1442 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -411,6 +411,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	 */
 	shost->max_cmd_len = 12;
 	shost->hostt = sht;
+	shost->module = sht->module;
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e028854..5905b83 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -988,7 +988,7 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	/* We can fail this if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	try_module_get(sdev->host->module);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ EXPORT_SYMBOL(scsi_device_get);
 void scsi_device_put(struct scsi_device *sdev)
 {
 #ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
+	struct module *module = sdev->host->module;
 
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 019e668..5133f2f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -617,6 +617,7 @@ struct Scsi_Host {
 	 */
 	unsigned short max_cmd_len;
 
+	struct module *module;
 	int this_id;
 	int can_queue;
 	short cmd_per_lun;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
