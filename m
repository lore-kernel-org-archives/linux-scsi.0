From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] consolidate legacy typedefs in one place
Date: Fri, 6 Jun 2003 16:44:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606144406.GB23608@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:49109 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261797AbTFFOag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:30:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Make the scsi midlayer header typedef clean and consolidate all
those backwards-compat typedefs in scsi_typedefs.h.  It's still
included at the bottom of scsi.h and will probably stay there
at least for 2.6 - but the scsi core already compiles without
it and the new splitted headers won't include this implicitly
anymore.


diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Thu Jun  5 18:46:05 2003
+++ b/drivers/scsi/hosts.h	Thu Jun  5 18:46:05 2003
@@ -103,7 +103,7 @@
     /*
      * ioctl interface
      */
-    int (*ioctl)(Scsi_Device *dev, int cmd, void *arg);
+    int (*ioctl)(struct scsi_device *dev, int cmd, void *arg);
 
     /*
      * The command function takes a target, a command (this is a SCSI
@@ -116,7 +116,7 @@
      * 2    host error return.
      * 3    mid level error return
      */
-    int (* command)(Scsi_Cmnd *);
+    int (* command)(struct scsi_cmnd *);
 
     /*
      * The QueueCommand function works in a similar manner
@@ -151,7 +151,7 @@
      *   I/O pressure in the system if there are no other outstanding
      *   commands.
      * */
-    int (* queuecommand)(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+    int (* queuecommand)(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
 
     /*
      * This is an error handling strategy routine.  You don't need to
@@ -169,10 +169,10 @@
      * this function should and should not be attempting to do.
      */
      int (*eh_strategy_handler)(struct Scsi_Host *);
-     int (*eh_abort_handler)(Scsi_Cmnd *);
-     int (*eh_device_reset_handler)(Scsi_Cmnd *);
-     int (*eh_bus_reset_handler)(Scsi_Cmnd *);
-     int (*eh_host_reset_handler)(Scsi_Cmnd *);
+     int (*eh_abort_handler)(struct scsi_cmnd *);
+     int (*eh_device_reset_handler)(struct scsi_cmnd *);
+     int (*eh_bus_reset_handler)(struct scsi_cmnd *);
+     int (*eh_host_reset_handler)(struct scsi_cmnd *);
 
     /*
      * Old EH handlers, no longer used. Make them warn the user of old
@@ -206,13 +206,13 @@
      * slave_destroy() routine at a minimum in order to avoid leaking memory
      * each time a device is tore down.
      */
-    int (* slave_alloc)(Scsi_Device *);
+    int (* slave_alloc)(struct scsi_device *);
 
     /*
      * slave_configure()  -  Optional
      * 
      * Once the device has responded to an INQUIRY and we know the device
-     * is online, we call into the low level driver with the Scsi_Device *
+     * is online, we call into the low level driver with the struct scsi_device *
      * If the low level device driver implements this function, it *must*
      * perform the task of setting the queue depth on the device.  All other
      * tasks are optional and depend on what the driver supports and various
@@ -237,7 +237,7 @@
      *     device, so don't leave any loose memory hanging around, clean
      *     up after yourself before returning non-0
      */
-    int (* slave_configure)(Scsi_Device *);
+    int (* slave_configure)(struct scsi_device *);
 
     /*
      * slave_destroy()  -  Optional
@@ -248,7 +248,7 @@
      * The low level driver is responsible for freeing any memory it allocated
      * in the slave_alloc or slave_configure calls. 
      */
-    void (* slave_destroy)(Scsi_Device *);
+    void (* slave_destroy)(struct scsi_device *);
 
     /*
      * This function determines the bios parameters for a given
@@ -369,10 +369,7 @@
     struct list_head legacy_hosts;
 };
 
-typedef struct scsi_host_template Scsi_Host_Template;
-
-struct Scsi_Host
-{
+struct Scsi_Host {
 /* private: */
     /*
      * This information is private to the scsi mid-layer.  Wrapping it in a
@@ -520,8 +517,8 @@
  * thing.  This physical pseudo-device isn't real and won't be available
  * from any high-level drivers.
  */
-extern void scsi_free_host_dev(Scsi_Device *);
-extern Scsi_Device * scsi_get_host_dev(struct Scsi_Host *);
+extern void scsi_free_host_dev(struct scsi_device *);
+extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
@@ -581,9 +578,9 @@
  * @pun:	SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  **/
-static inline Scsi_Device *scsi_find_device(struct Scsi_Host *shost,
+static inline struct scsi_device *scsi_find_device(struct Scsi_Host *shost,
                                             int channel, int pun, int lun) {
-        Scsi_Device *sdev;
+        struct scsi_device *sdev;
 
 	list_for_each_entry (sdev, &shost->my_devices, siblings)
                 if (sdev->channel == channel && sdev->id == pun
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Thu Jun  5 18:46:05 2003
+++ b/drivers/scsi/scsi.h	Thu Jun  5 18:46:05 2003
@@ -212,33 +212,20 @@
  */
 #define SCSI_DEFAULT_MAX_SECTORS	1024
 
-/*
- * This is the crap from the old error handling code.  We have it in a special
- * place so that we can more easily delete it later on.
- */
-#include "scsi_obsolete.h"
 
-/*
- * Forward-declaration of structs for prototypes.
- */
 struct Scsi_Host;
+struct scsi_cmnd;
+struct scsi_device;
 struct scsi_target;
 struct scatterlist;
 
 /*
- * Add some typedefs so that we can prototyope a bunch of the functions.
- */
-typedef struct scsi_device Scsi_Device;
-typedef struct scsi_cmnd Scsi_Cmnd;
-typedef struct scsi_request Scsi_Request;
-
-/*
  * These are the error handling functions defined in scsi_error.c
  */
-extern void scsi_add_timer(Scsi_Cmnd * SCset, int timeout,
-			   void (*complete) (Scsi_Cmnd *));
-extern int scsi_delete_timer(Scsi_Cmnd * SCset);
-extern int scsi_block_when_processing_errors(Scsi_Device *);
+extern void scsi_add_timer(struct scsi_cmnd *, int,
+			   void (*)(struct scsi_cmnd *));
+extern int scsi_delete_timer(struct scsi_cmnd *);
+extern int scsi_block_when_processing_errors(struct scsi_device *);
 extern void scsi_sleep(int);
 
 /*
@@ -251,16 +238,15 @@
 /*
  * Prototypes for functions in scsi_lib.c
  */
-extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
-			       int block_sectors);
+extern void scsi_io_completion(struct scsi_cmnd *, int, int);
 
 /*
  * Prototypes for functions in scsi.c
  */
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
 extern void scsi_put_command(struct scsi_cmnd *cmd);
-extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
-extern int scsi_track_queue_full(Scsi_Device *, int);
+extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
+extern int scsi_track_queue_full(struct scsi_device *, int);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern void scsi_set_device_offline(struct scsi_device *);
@@ -268,12 +254,12 @@
 /*
  * Newer request-based interfaces.
  */
-extern Scsi_Request *scsi_allocate_request(Scsi_Device *);
-extern void scsi_release_request(Scsi_Request *);
-extern void scsi_wait_req(Scsi_Request *, const void *cmnd,
+extern struct scsi_request *scsi_allocate_request(struct scsi_device *);
+extern void scsi_release_request(struct scsi_request *);
+extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
 			  void *buffer, unsigned bufflen,
 			  int timeout, int retries);
-extern void scsi_do_req(Scsi_Request *, const void *cmnd,
+extern void scsi_do_req(struct scsi_request *, const void *cmnd,
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
@@ -290,10 +276,10 @@
  * Prototypes for functions in constants.c
  * Some of these used to live in constants.h
  */
-extern void print_Scsi_Cmnd (Scsi_Cmnd *);
+extern void print_Scsi_Cmnd(struct scsi_cmnd *);
 extern void print_command(unsigned char *);
-extern void print_sense(const char *, Scsi_Cmnd *);
-extern void print_req_sense(const char *, Scsi_Request *);
+extern void print_sense(const char *, struct scsi_cmnd *);
+extern void print_req_sense(const char *, struct scsi_request *);
 extern void print_driverbyte(int scsiresult);
 extern void print_hostbyte(int scsiresult);
 extern void print_status(unsigned char status);
@@ -323,13 +309,13 @@
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 	struct Scsi_Host *host;
-	request_queue_t *request_queue;
+	struct request_queue *request_queue;
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	spinlock_t sdev_lock;           /* also the request queue_lock */
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
-        Scsi_Cmnd *current_cmnd;	/* currently active command */
+	struct scsi_cmnd *current_cmnd;	/* currently active command */
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short last_queue_full_depth; /* These two are used by */
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
@@ -400,7 +386,7 @@
 	container_of(d, struct scsi_device, sdev_driverfs_dev)
 
 
-typedef struct scsi_pointer {
+struct scsi_pointer {
 	char *ptr;		/* data pointer */
 	int this_residual;	/* left in this buffer */
 	struct scatterlist *buffer;	/* which buffer */
@@ -413,7 +399,7 @@
 	volatile int have_data_in;
 	volatile int sent_command;
 	volatile int phase;
-} Scsi_Pointer;
+};
 
 /*
  * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
@@ -431,8 +417,8 @@
 						 * (auto-sense) */
 
 	struct Scsi_Host *sr_host;
-	Scsi_Device *sr_device;
-	Scsi_Cmnd *sr_command;
+	struct scsi_device *sr_device;
+	struct scsi_cmnd *sr_command;
 	struct request *sr_request;	/* A copy of the command we are
 				   working on */
 	unsigned sr_bufflen;	/* Size of data buffer */
@@ -466,7 +452,7 @@
 	struct scsi_device *device;
 	unsigned short state;
 	unsigned short owner;
-	Scsi_Request *sc_request;
+	struct scsi_request *sc_request;
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
@@ -560,7 +546,7 @@
 	 * Everything else should be left alone. 
 	 */
 
-	Scsi_Pointer SCp;	/* Scratchpad used by some host adapters */
+	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
 
 	unsigned char *host_scribble;	/* The host adapter is allowed to
 					   * call scsi_malloc and get some memory
@@ -590,7 +576,7 @@
 #define SCSI_TRY_RESET_BUS	2
 #define SCSI_TRY_RESET_HOST	3
 
-extern int scsi_reset_provider(Scsi_Device *, int);
+extern int scsi_reset_provider(struct scsi_device *, int);
 
 #define MSG_SIMPLE_TAG	0x20
 #define MSG_HEAD_TAG	0x21
@@ -608,11 +594,12 @@
  *	the device could cope with and the real queue depth
  *	would be adjustable from 0 to depth.
  **/
-static inline void scsi_activate_tcq(Scsi_Device *SDpnt, int depth) {
-        if(SDpnt->tagged_supported) {
-		if(!blk_queue_tagged(SDpnt->request_queue))
-			blk_queue_init_tags(SDpnt->request_queue, depth);
-		scsi_adjust_queue_depth(SDpnt, MSG_ORDERED_TAG, depth);
+static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
+{
+        if (sdev->tagged_supported) {
+		if (!blk_queue_tagged(sdev->request_queue))
+			blk_queue_init_tags(sdev->request_queue, depth);
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
         }
 }
 
@@ -620,10 +607,11 @@
  * scsi_deactivate_tcq - turn off tag command queueing
  * @SDpnt:	device to turn off TCQ for
  **/
-static inline void scsi_deactivate_tcq(Scsi_Device *SDpnt, int depth) {
-	if(blk_queue_tagged(SDpnt->request_queue))
-		blk_queue_free_tags(SDpnt->request_queue);
-	scsi_adjust_queue_depth(SDpnt, 0, depth);
+static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
+{
+	if (blk_queue_tagged(sdev->request_queue))
+		blk_queue_free_tags(sdev->request_queue);
+	scsi_adjust_queue_depth(sdev, 0, depth);
 }
 
 /**
@@ -636,20 +624,20 @@
  *	particular request.  Returns the size of the tag message.
  *	May return 0 if TCQ is disabled for this device.
  **/
-static inline int scsi_populate_tag_msg(Scsi_Cmnd *SCpnt, char *msg) {
-        struct request *req = SCpnt->request;
-
-        if(!blk_rq_tagged(req))
-                return 0;
+static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
+{
+        struct request *req = cmd->request;
+
+        if (blk_rq_tagged(req)) {
+		if (req->flags & REQ_HARDBARRIER)
+        	        *msg++ = MSG_ORDERED_TAG;
+        	else
+        	        *msg++ = MSG_SIMPLE_TAG;
+        	*msg++ = req->tag;
+        	return 2;
+	}
 
-	if (req->flags & REQ_HARDBARRIER)
-                *msg++ = MSG_ORDERED_TAG;
-        else
-                *msg++ = MSG_SIMPLE_TAG;
-
-        *msg++ = SCpnt->request->tag;
-
-        return 2;
+	return 0;
 }
 
 /**
@@ -660,27 +648,34 @@
  * Notes:
  *	Only works with tags allocated by the generic blk layer.
  **/
-static inline Scsi_Cmnd *scsi_find_tag(Scsi_Device *SDpnt, int tag) {
+static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
+{
 
         struct request *req;
 
-        if(tag == SCSI_NO_TAG)
-                /* single command, look in space */
-                return SDpnt->current_cmnd;
-
-        req = blk_queue_find_tag(SDpnt->request_queue, tag);
+        if (tag != SCSI_NO_TAG) {
+        	req = blk_queue_find_tag(sdev->request_queue, tag);
+	        return req ? (struct scsi_cmnd *)req->special : NULL;
+	}
 
-        if(req == NULL)
-                return NULL;
-
-        return (Scsi_Cmnd *)req->special;
+	/* single command, look in space */
+	return sdev->current_cmnd;
 }
 
-int scsi_set_medium_removal(Scsi_Device *dev, char state);
+int scsi_set_medium_removal(struct scsi_device *dev, char state);
 
 extern int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
 					    struct device_attribute *attr);
 extern int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***class_attrs,
 					     struct class_device_attribute *attr);
+
+/*
+ * This is the crap from the old error handling code.  We have it in a special
+ * place so that we can more easily delete it later on.
+ */
+#include "scsi_obsolete.h"
+
+/* obsolete typedef junk. */
+#include "scsi_typedefs.h"
 
 #endif /* _SCSI_H */
diff -Nru a/drivers/scsi/scsi_typedefs.h b/drivers/scsi/scsi_typedefs.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_typedefs.h	Thu Jun  5 18:47:24 2003
@@ -0,0 +1,6 @@
+
+typedef struct scsi_host_template Scsi_Host_Template;
+typedef struct scsi_device Scsi_Device;
+typedef struct scsi_cmnd Scsi_Cmnd;
+typedef struct scsi_request Scsi_Request;
+typedef struct scsi_pointer Scsi_Pointer;
