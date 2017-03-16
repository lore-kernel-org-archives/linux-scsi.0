From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/3] Introduce starget_for_all_devices() and shost_for_all_devices()
Date: Thu, 16 Mar 2017 13:56:49 -0700
Message-ID: <20170316205650.3322-3-bart.vanassche@sandisk.com>
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
 drivers/scsi/scsi.c        | 52 +++++++++++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_device.h | 22 ++++++++++++++++++--
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 5ac16fecbdab..ea408da8de29 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -640,9 +640,11 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * @data:	Opaque passed to each function call.
  * @fn:		Function to call on each device
  *
- * This traverses over each device of @starget.  The devices have
- * a reference that must be released by scsi_host_put when breaking
- * out of the loop.
+ * This traverses over each device of @starget except the devices that are in
+ * state SDEV_DEL or SDEV_CANCEL. The devices have a reference that must be
+ * released by scsi_device_put() when breaking out of the loop. If the LLD
+ * associated with the devices is being unloaded, @fn is not called for any
+ * device.
  */
 void starget_for_each_device(struct scsi_target *starget, void *data,
 		     void (*fn)(struct scsi_device *, void *))
@@ -659,6 +661,50 @@ void starget_for_each_device(struct scsi_target *starget, void *data,
 EXPORT_SYMBOL(starget_for_each_device);
 
 /**
+ * scsi_device_get_any() - get a reference to @sdev even if it is being deleted
+ *
+ * See also scsi_device_get().
+ */
+static int scsi_device_get_any(struct scsi_device *sdev)
+{
+	return get_device(&sdev->sdev_gendev) ? 0 : -ENXIO;
+}
+
+/**
+ * scsi_device_put_any() - drop a reference obtained by scsi_device_get_any()
+ *
+ * See also scsi_device_put().
+ */
+static void scsi_device_put_any(struct scsi_device *sdev)
+{
+	put_device(&sdev->sdev_gendev);
+}
+
+/**
+ * starget_for_all_devices - helper to walk all devices of a target
+ * @starget:	target whose devices we want to iterate over.
+ * @data:	Pointer passed to each function call.
+ * @fn:		Function to call on each device
+ *
+ * This traverses over each device of @starget, including the devices in state
+ * SDEV_DEL or SDEV_ANY. The devices have a reference that must be released by
+ * scsi_device_put_any() when breaking out of the loop.
+ */
+void starget_for_all_devices(struct scsi_target *starget, void *data,
+			     void (*fn)(struct scsi_device *, void *))
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
+	shost_for_all_devices(sdev, shost, scsi_device_get_any,
+			      scsi_device_put_any)
+		if (sdev->channel == starget->channel &&
+		    sdev->id == starget->id)
+			fn(sdev, data);
+}
+EXPORT_SYMBOL(starget_for_all_devices);
+
+/**
  * __starget_for_each_device - helper to walk all devices of a target (UNLOCKED)
  * @starget:	target whose devices we want to iterate over.
  * @data:	parameter for callback @fn()
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 434b617c9f76..cd6a5383e9b7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -328,6 +328,8 @@ extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
 							  u64);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
+extern void starget_for_all_devices(struct scsi_target *, void *,
+				    void (*fn)(struct scsi_device *, void *));
 extern void __starget_for_each_device(struct scsi_target *, void *,
 				      void (*fn)(struct scsi_device *,
 						 void *));
@@ -339,6 +341,22 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 					void (*put)(struct scsi_device *));
 
 /**
+ * shost_for_all_devices - iterate over all devices of a host
+ * @sdev: the &struct scsi_device to use as a cursor
+ * @shost: the &struct scsi_host to iterate over
+ * @get: function that obtains a reference to a device and returns 0 upon
+ *       success
+ * @put: function that drops a device reference.
+ *
+ * Iterator that returns each device attached to @shost.  This loop
+ * takes a reference on each device and releases it at the end.  If
+ * you break out of the loop, you must call @put(sdev).
+ */
+#define shost_for_all_devices(sdev, shost, get, put)			\
+	for ((sdev) = NULL; ((sdev) = __scsi_iterate_devices((shost), (sdev), \
+	     (get), (put))) != NULL; )
+
+/**
  * shost_for_each_device - iterate over all devices of a host
  * @sdev: the &struct scsi_device to use as a cursor
  * @shost: the &struct scsi_host to iterate over
@@ -348,8 +366,8 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
  * you break out of the loop, you must call scsi_device_put(sdev).
  */
 #define shost_for_each_device(sdev, shost)			\
-	for ((sdev) = NULL; ((sdev) = __scsi_iterate_devices((shost), (sdev), \
-	     scsi_device_get, scsi_device_put)) != NULL; )
+	shost_for_all_devices((sdev), (shost), scsi_device_get,	\
+			      scsi_device_put)
 
 /**
  * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
-- 
2.12.0
