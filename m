From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] more header reshuffling
Date: Mon, 9 Jun 2003 19:52:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609175244.GB2960@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:50319 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264590AbTFIRjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 13:39:08 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This creates scsi_eh.h, scsi_request.h and scsi_tcq.h


diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Sun Jun  8 22:03:00 2003
+++ b/drivers/scsi/hosts.h	Sun Jun  8 22:03:00 2003
@@ -30,9 +30,6 @@
 
 #include <scsi/scsi_host.h>
 
-extern void scsi_report_bus_reset(struct Scsi_Host *, int);
-extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
-
 struct scsi_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sun Jun  8 22:03:00 2003
+++ b/drivers/scsi/scsi.h	Sun Jun  8 22:03:00 2003
@@ -19,6 +19,9 @@
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_request.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
 
 /*
@@ -198,36 +201,6 @@
 struct scatterlist;
 
 /*
- * These are the error handling functions defined in scsi_error.c
- */
-extern void scsi_add_timer(struct scsi_cmnd *, int,
-			   void (*)(struct scsi_cmnd *));
-extern int scsi_delete_timer(struct scsi_cmnd *);
-extern int scsi_block_when_processing_errors(struct scsi_device *);
-extern void scsi_sleep(int);
-
-/*
- * Prototypes for functions in scsicam.c
- */
-extern int  scsi_partsize(unsigned char *buf, unsigned long capacity,
-                    unsigned int *cyls, unsigned int *hds,
-                    unsigned int *secs);
-
-/*
- * Newer request-based interfaces.
- */
-extern struct scsi_request *scsi_allocate_request(struct scsi_device *);
-extern void scsi_release_request(struct scsi_request *);
-extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
-			  void *buffer, unsigned bufflen,
-			  int timeout, int retries);
-extern void scsi_do_req(struct scsi_request *, const void *cmnd,
-			void *buffer, unsigned bufflen,
-			void (*done) (struct scsi_cmnd *),
-			int timeout, int retries);
-
-
-/*
  * Prototypes for functions in constants.c
  * Some of these used to live in constants.h
  */
@@ -243,140 +216,11 @@
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
 /*
- * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
- * having this is that requests that are injected into the queue as result
- * of things like ioctls and character devices shouldn't be using a
- * Scsi_Cmnd until such a time that the command is actually at the head
- * of the queue and being sent to the driver.
- */
-struct scsi_request {
-	int     sr_magic;
-	int     sr_result;	/* Status code from lower level driver */
-	unsigned char sr_sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
-						 * when CHECK CONDITION is
-						 * received on original command 
-						 * (auto-sense) */
-
-	struct Scsi_Host *sr_host;
-	struct scsi_device *sr_device;
-	struct scsi_cmnd *sr_command;
-	struct request *sr_request;	/* A copy of the command we are
-				   working on */
-	unsigned sr_bufflen;	/* Size of data buffer */
-	void *sr_buffer;		/* Data buffer */
-	int sr_allowed;
-	unsigned char sr_data_direction;
-	unsigned char sr_cmd_len;
-	unsigned char sr_cmnd[MAX_COMMAND_SIZE];
-	void (*sr_done) (struct scsi_cmnd *);	/* Mid-level done function */
-	int sr_timeout_per_command;
-	unsigned short sr_use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sr_sglist_len;	/* size of malloc'd scatter-gather list */
-	unsigned sr_underflow;	/* Return error if less than
-				   this amount is transferred */
- 	void * upper_private_data;	/* reserved for owner (usually upper
- 					   level driver) of this request */
-};
-
-/*
  * Definitions and prototypes used for scsi mid-level queue.
  */
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
-
-/*
- * Reset request from external source
- */
-#define SCSI_TRY_RESET_DEVICE	1
-#define SCSI_TRY_RESET_BUS	2
-#define SCSI_TRY_RESET_HOST	3
-
-extern int scsi_reset_provider(struct scsi_device *, int);
-
-#define MSG_SIMPLE_TAG	0x20
-#define MSG_HEAD_TAG	0x21
-#define MSG_ORDERED_TAG	0x22
-
-#define SCSI_NO_TAG	(-1)    /* identify no tag in use */
-
-/**
- * scsi_activate_tcq - turn on tag command queueing
- * @SDpnt:	device to turn on TCQ for
- * @depth:	queue depth
- *
- * Notes:
- *	Eventually, I hope depth would be the maximum depth
- *	the device could cope with and the real queue depth
- *	would be adjustable from 0 to depth.
- **/
-static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
-{
-        if (sdev->tagged_supported) {
-		if (!blk_queue_tagged(sdev->request_queue))
-			blk_queue_init_tags(sdev->request_queue, depth);
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
-        }
-}
-
-/**
- * scsi_deactivate_tcq - turn off tag command queueing
- * @SDpnt:	device to turn off TCQ for
- **/
-static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
-{
-	if (blk_queue_tagged(sdev->request_queue))
-		blk_queue_free_tags(sdev->request_queue);
-	scsi_adjust_queue_depth(sdev, 0, depth);
-}
-
-/**
- * scsi_populate_tag_msg - place a tag message in a buffer
- * @SCpnt:	pointer to the Scsi_Cmnd for the tag
- * @msg:	pointer to the area to place the tag
- *
- * Notes:
- *	designed to create the correct type of tag message for the 
- *	particular request.  Returns the size of the tag message.
- *	May return 0 if TCQ is disabled for this device.
- **/
-static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
-{
-        struct request *req = cmd->request;
-
-        if (blk_rq_tagged(req)) {
-		if (req->flags & REQ_HARDBARRIER)
-        	        *msg++ = MSG_ORDERED_TAG;
-        	else
-        	        *msg++ = MSG_SIMPLE_TAG;
-        	*msg++ = req->tag;
-        	return 2;
-	}
-
-	return 0;
-}
-
-/**
- * scsi_find_tag - find a tagged command by device
- * @SDpnt:	pointer to the ScSI device
- * @tag:	the tag number
- *
- * Notes:
- *	Only works with tags allocated by the generic blk layer.
- **/
-static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
-{
-
-        struct request *req;
-
-        if (tag != SCSI_NO_TAG) {
-        	req = blk_queue_find_tag(sdev->request_queue, tag);
-	        return req ? (struct scsi_cmnd *)req->special : NULL;
-	}
-
-	/* single command, look in space */
-	return sdev->current_cmnd;
-}
 
 extern int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
 					    struct device_attribute *attr);
diff -Nru a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_eh.h	Sun Jun  8 22:03:00 2003
@@ -0,0 +1,21 @@
+#ifndef _SCSI_SCSI_EH_H
+#define _SCSI_SCSI_EH_H
+
+extern void scsi_add_timer(struct scsi_cmnd *, int,
+			   void (*)(struct scsi_cmnd *));
+extern int scsi_delete_timer(struct scsi_cmnd *);
+extern void scsi_report_bus_reset(struct Scsi_Host *, int);
+extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
+extern int scsi_block_when_processing_errors(struct scsi_device *);
+extern void scsi_sleep(int);
+
+/*
+ * Reset request from external source
+ */
+#define SCSI_TRY_RESET_DEVICE	1
+#define SCSI_TRY_RESET_BUS	2
+#define SCSI_TRY_RESET_HOST	3
+
+extern int scsi_reset_provider(struct scsi_device *, int);
+
+#endif /* _SCSI_SCSI_EH_H */
diff -Nru a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_request.h	Sun Jun  8 22:03:00 2003
@@ -0,0 +1,58 @@
+#ifndef _SCSI_SCSI_REQUEST_H
+#define _SCSI_SCSI_REQUEST_H
+
+#include <scsi/scsi_cmnd.h>
+
+struct request;
+struct scsi_cmnd;
+struct scsi_device;
+struct Scsi_Host;
+
+
+/*
+ * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
+ * having this is that requests that are injected into the queue as result
+ * of things like ioctls and character devices shouldn't be using a
+ * Scsi_Cmnd until such a time that the command is actually at the head
+ * of the queue and being sent to the driver.
+ */
+struct scsi_request {
+	int     sr_magic;
+	int     sr_result;	/* Status code from lower level driver */
+	unsigned char sr_sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
+						 * when CHECK CONDITION is
+						 * received on original command 
+						 * (auto-sense) */
+
+	struct Scsi_Host *sr_host;
+	struct scsi_device *sr_device;
+	struct scsi_cmnd *sr_command;
+	struct request *sr_request;	/* A copy of the command we are
+				   working on */
+	unsigned sr_bufflen;	/* Size of data buffer */
+	void *sr_buffer;		/* Data buffer */
+	int sr_allowed;
+	unsigned char sr_data_direction;
+	unsigned char sr_cmd_len;
+	unsigned char sr_cmnd[MAX_COMMAND_SIZE];
+	void (*sr_done) (struct scsi_cmnd *);	/* Mid-level done function */
+	int sr_timeout_per_command;
+	unsigned short sr_use_sg;	/* Number of pieces of scatter-gather */
+	unsigned short sr_sglist_len;	/* size of malloc'd scatter-gather list */
+	unsigned sr_underflow;	/* Return error if less than
+				   this amount is transferred */
+ 	void *upper_private_data;	/* reserved for owner (usually upper
+ 					   level driver) of this request */
+};
+
+extern struct scsi_request *scsi_allocate_request(struct scsi_device *);
+extern void scsi_release_request(struct scsi_request *);
+extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
+			  void *buffer, unsigned bufflen,
+			  int timeout, int retries);
+extern void scsi_do_req(struct scsi_request *, const void *cmnd,
+			void *buffer, unsigned bufflen,
+			void (*done) (struct scsi_cmnd *),
+			int timeout, int retries);
+
+#endif /* _SCSI_SCSI_REQUEST_H */
diff -Nru a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_tcq.h	Sun Jun  8 22:03:00 2003
@@ -0,0 +1,94 @@
+#ifndef _SCSI_SCSI_TCQ_H
+#define _SCSI_SCSI_TCQ_H
+
+#include <linux/blkdev.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+
+#define MSG_SIMPLE_TAG	0x20
+#define MSG_HEAD_TAG	0x21
+#define MSG_ORDERED_TAG	0x22
+
+#define SCSI_NO_TAG	(-1)    /* identify no tag in use */
+
+
+/**
+ * scsi_activate_tcq - turn on tag command queueing
+ * @SDpnt:	device to turn on TCQ for
+ * @depth:	queue depth
+ *
+ * Notes:
+ *	Eventually, I hope depth would be the maximum depth
+ *	the device could cope with and the real queue depth
+ *	would be adjustable from 0 to depth.
+ **/
+static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
+{
+        if (sdev->tagged_supported) {
+		if (!blk_queue_tagged(sdev->request_queue))
+			blk_queue_init_tags(sdev->request_queue, depth);
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+        }
+}
+
+/**
+ * scsi_deactivate_tcq - turn off tag command queueing
+ * @SDpnt:	device to turn off TCQ for
+ **/
+static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
+{
+	if (blk_queue_tagged(sdev->request_queue))
+		blk_queue_free_tags(sdev->request_queue);
+	scsi_adjust_queue_depth(sdev, 0, depth);
+}
+
+/**
+ * scsi_populate_tag_msg - place a tag message in a buffer
+ * @SCpnt:	pointer to the Scsi_Cmnd for the tag
+ * @msg:	pointer to the area to place the tag
+ *
+ * Notes:
+ *	designed to create the correct type of tag message for the 
+ *	particular request.  Returns the size of the tag message.
+ *	May return 0 if TCQ is disabled for this device.
+ **/
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
+
+	return 0;
+}
+
+/**
+ * scsi_find_tag - find a tagged command by device
+ * @SDpnt:	pointer to the ScSI device
+ * @tag:	the tag number
+ *
+ * Notes:
+ *	Only works with tags allocated by the generic blk layer.
+ **/
+static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
+{
+
+        struct request *req;
+
+        if (tag != SCSI_NO_TAG) {
+        	req = blk_queue_find_tag(sdev->request_queue, tag);
+	        return req ? (struct scsi_cmnd *)req->special : NULL;
+	}
+
+	/* single command, look in space */
+	return sdev->current_cmnd;
+}
+
+#endif /* _SCSI_SCSI_TCQ_H */
