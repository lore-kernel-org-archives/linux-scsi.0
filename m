From: michaelc@cs.wisc.edu
Subject: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Tue, 31 Mar 2009 13:47:55 -0500
Message-ID: <12385252751209-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48628 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763215AbZCaSsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Mar 2009 14:48:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch passes userspace scsi command errors so userspace can
handle events like REPORT_LUNS_DATA_CHANGED or CAPACITY_DATA_CHANGED.
I also hooked it into the QUEUE_FULL parsing so that when we get this
error userspace will begin to track devices and eventually ramp them
up (ramp down is still in the kernel but could also be moved).

Why not just do it in the kernel? After open-iscsi, I would love
to put almost everything in the kernel, because its split has been
fun to support :) However, for some of the operations we must handle
userspace might be easier. I am not 100% sure though and that is one
of the reasons this is a RFC.

Rescanning a target port is pretty easy today in the kernel. We can
just kick off a thread and run scsi_scan_target. However, in userspace
there are already tools that will also handle the removal of old
devices.

And where it really gets hairy is with handling device size changes.
Here is some doc on how to resize the disk when iscsi is used:
http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5.2/html/Online_Storage_Reconfiguration_Guide/online-iscsi-resizing.html

For FC or SAS the process is similar. Instead of running some iscsi tool
to rescan devices you can just write to the devices's rescan sysfs attr
(that is all iscsiadm is doing). Then the multipath steps are the same.
And then there is the filesystem which will need to be resized too.

Going forward, if this is ok, I think we could also start passing
userspace DID_TRANSPORT* errors so something like multipath can do
something with it like fail paths. I could also add some scsi_mod sysfs
interface to control which errors get sent to userspace and how often
(something like a ratelimit printk so userspace does not get flooded).

I did a really hacky userspace handler to get started and test the
kernel code but I am too embarrased of it to post it :) If you want
to see it just email me off list.

Patch was made over linus's git tree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c   |   83 +++++++++++++++++++++++++++++++++++++++----
 include/scsi/scsi_netlink.h |   25 ++++++++++++-
 2 files changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..8a4d10e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <net/netlink.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -33,6 +34,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_netlink.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -214,9 +216,71 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 #endif
 
 /**
+ * scsi_post_cmd_error - Pass scsi command failure info to userspace parser
+ * @scmd: scsi command
+ */
+static void scsi_post_cmd_error(struct scsi_cmnd *scmd)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct scsi_nl_cmd_err_event *ev;
+	struct scsi_sense_hdr sshdr;
+	u32 len, skblen;
+	u16 sense_len = 0;
+
+	if (!scsi_nl_sock)
+		return;
+
+	if (status_byte(scmd->result) == CHECK_CONDITION &&
+	    scsi_command_normalize_sense(scmd, &sshdr))
+		sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	len = SCSI_NL_MSGALIGN(sizeof(*ev) + sense_len);
+	skblen = NLMSG_SPACE(len);
+
+	skb = alloc_skb(skblen, GFP_ATOMIC);
+	if (!skb) {
+		scmd_printk(KERN_INFO, scmd, "Could not pass sense to "
+			    "userspace. Could not allocate buffer.\n");
+		return;
+	}
+
+	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
+			skblen - sizeof(*nlh), 0);
+	if (!nlh) {
+		scmd_printk(KERN_INFO, scmd, "Could not pass sense to "
+			    "userspace. Could not setup buffer space.\n");
+		goto free_skb;
+	}
+
+	ev = NLMSG_DATA(nlh);
+	INIT_SCSI_NL_HDR(&ev->snlh, 0, SCSI_NL_CMD_ERR, len);
+	ev->seconds = get_seconds();
+	ev->host_no = scmd->device->host->host_no;
+	ev->id = scmd->device->id;
+	ev->channel = scmd->device->channel;
+	ev->lun = scmd->device->lun;
+
+	ev->status = scmd->result & 0xff;
+	ev->masked_status = status_byte(scmd->result);
+	ev->msg_status = msg_byte(scmd->result);
+	ev->host_status = host_byte(scmd->result);
+	ev->driver_status = driver_byte(scmd->result);
+	ev->sense_len = sense_len;
+
+	if (sense_len)
+		memcpy(&ev[1], scmd->sense_buffer, sense_len);
+	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_CMD_ERR, GFP_ATOMIC);
+	return;
+
+free_skb:
+	kfree_skb(skb);
+}
+
+/**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
- *
+ * @post_err:	bool indicating whether to notify userspace
  * Return value:
  * 	SUCCESS or FAILED or NEEDS_RETRY
  *
@@ -224,7 +288,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  *	When a deferred error is detected the current command has
  *	not been executed and needs retrying.
  */
-static int scsi_check_sense(struct scsi_cmnd *scmd)
+static int scsi_check_sense(struct scsi_cmnd *scmd, bool post_err)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
@@ -232,6 +296,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (post_err)
+		scsi_post_cmd_error(scmd);
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
@@ -354,7 +421,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * is valid, we have a pretty good idea of what to do.
 		 * if not, we mark it as FAILED.
 		 */
-		return scsi_check_sense(scmd);
+		return scsi_check_sense(scmd, 1);
 	}
 	if (host_byte(scmd->result) != DID_OK)
 		return FAILED;
@@ -374,7 +441,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
-		return scsi_check_sense(scmd);
+		return scsi_check_sense(scmd, 1);
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
 	case INTERMEDIATE_C_GOOD:
@@ -382,8 +449,9 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
-	case BUSY:
 	case QUEUE_FULL:
+		scsi_post_cmd_error(scmd);
+	case BUSY:
 	case RESERVATION_CONFLICT:
 	default:
 		return FAILED;
@@ -951,7 +1019,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
-			    scsi_check_sense(scmd) == FAILED ) {
+			    scsi_check_sense(scmd, 0) == FAILED ) {
 				stu_scmd = scmd;
 				break;
 			}
@@ -1380,6 +1448,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case QUEUE_FULL:
+		scsi_post_cmd_error(scmd);
 		/*
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
@@ -1398,7 +1467,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case TASK_ABORTED:
 		goto maybe_retry;
 	case CHECK_CONDITION:
-		rtn = scsi_check_sense(scmd);
+		rtn = scsi_check_sense(scmd, 1);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
 		/* if rtn == FAILED, we have no sense information;
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..2cac0f5 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -35,8 +35,8 @@
 /* SCSI Transport Broadcast Groups */
 	/* leaving groups 0 and 1 unassigned */
 #define SCSI_NL_GRP_FC_EVENTS		(1<<2)		/* Group 2 */
-#define SCSI_NL_GRP_CNT			3
-
+#define SCSI_NL_GRP_CMD_ERR		(1<<3)
+#define SCSI_NL_GRP_CNT			4
 
 /* SCSI_TRANSPORT_MSG event message header */
 struct scsi_nl_hdr {
@@ -65,6 +65,7 @@ struct scsi_nl_hdr {
  */
 	/* kernel -> user */
 #define SCSI_NL_SHOST_VENDOR			0x0001
+#define SCSI_NL_CMD_ERR				0x0002
 	/* user -> kernel */
 /* SCSI_NL_SHOST_VENDOR msgtype is kernel->user and user->kernel */
 
@@ -76,6 +77,26 @@ struct scsi_nl_hdr {
 /* macro to round up message lengths to 8byte boundary */
 #define SCSI_NL_MSGALIGN(len)		(((len) + 7) & ~7)
 
+/*
+ * SCSI CMD error event:
+ *   SCSI_NL_CMD_ERR
+ *
+ * Note: The sense buffer is placed after this structure.
+ */
+struct scsi_nl_cmd_err_event {
+	struct scsi_nl_hdr snlh;	/* must be 1st element ! */
+	uint64_t seconds;
+	uint64_t host_no;
+	uint64_t lun;
+	uint32_t channel;
+	uint32_t id;
+	uint16_t sense_len;		/* len of sense buffer */	
+	uint8_t status;			/* scsi status */
+	uint8_t masked_status;		/* shifted, masked scsi status */
+	uint8_t msg_status;		/* messaging level data (optional) */
+	uint8_t host_status;		/* errors from host adapter */
+	uint8_t driver_status;		/* errors from software driver */
+} __attribute__((aligned(sizeof(uint64_t))));
 
 /*
  * SCSI HOST Vendor Unique messages :
-- 
1.6.0.6

