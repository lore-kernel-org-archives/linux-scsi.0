From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/3] __scsi_iterate_devices(): Make the get and put functions arguments
Date: Thu, 16 Mar 2017 13:56:48 -0700
Message-ID: <20170316205650.3322-2-bart.vanassche@sandisk.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Tested-by: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi.c        |  8 +++++---
 include/scsi/scsi_device.h | 11 ++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7bfbcfa7af40..5ac16fecbdab 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -609,7 +609,9 @@ EXPORT_SYMBOL(scsi_device_put);
 
 /* helper for shost_for_each_device, see that for documentation */
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
-					   struct scsi_device *prev)
+					   struct scsi_device *prev,
+					   int (*get)(struct scsi_device *),
+					   void (*put)(struct scsi_device *))
 {
 	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
 	struct scsi_device *next = NULL;
@@ -619,7 +621,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	while (list->next != &shost->__devices) {
 		next = list_entry(list->next, struct scsi_device, siblings);
 		/* skip devices that we can't get a reference to */
-		if (!scsi_device_get(next))
+		if (!get(next))
 			break;
 		next = NULL;
 		list = list->next;
@@ -627,7 +629,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (prev)
-		scsi_device_put(prev);
+		put(prev);
 	return next;
 }
 EXPORT_SYMBOL(__scsi_iterate_devices);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 080c7ce9bae8..434b617c9f76 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -334,7 +334,9 @@ extern void __starget_for_each_device(struct scsi_target *, void *,
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
-						  struct scsi_device *);
+					struct scsi_device *,
+					int (*get)(struct scsi_device *),
+					void (*put)(struct scsi_device *));
 
 /**
  * shost_for_each_device - iterate over all devices of a host
@@ -345,10 +347,9 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
  * takes a reference on each device and releases it at the end.  If
  * you break out of the loop, you must call scsi_device_put(sdev).
  */
-#define shost_for_each_device(sdev, shost) \
-	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
-	     (sdev); \
-	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
+#define shost_for_each_device(sdev, shost)			\
+	for ((sdev) = NULL; ((sdev) = __scsi_iterate_devices((shost), (sdev), \
+	     scsi_device_get, scsi_device_put)) != NULL; )
 
 /**
  * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
-- 
2.12.0
