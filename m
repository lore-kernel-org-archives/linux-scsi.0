From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/6] tgt: add I_T nexus support
Date: Wed, 11 Jul 2007 15:08:17 +0900
Message-ID: <20070711150817A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56155 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760068AbXGKGMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

tgt uses scsi_host as I_T nexus. This works for ibmvstgt because it
creates one scsi_host for one initiator. However, other target drivers
don't work like that.

This adds I_T nexus support, which enable one scsi_host to handle
multiple initiators. New scsi_tgt_it_nexus_create/destroy functions
are expected be called transport classes. For example, ibmvstgt
creates an initiator remote port, then the srp transport calls
tgt_it_nexus_create. tgt doesn't manages I_T nexus, instead it tells
tgtd, user-space daemon, to create a new I_T nexus.

On the receiving the response from tgtd, tgt calls
shost->transportt->it_nexus_response. transports should notify a
lld. The srp transport uses it_nexus_response callback in
srp_function_template to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_tgt_if.c    |   42 +++++++++++++++++++--
 drivers/scsi/scsi_tgt_lib.c   |   83 ++++++++++++++++++++++++++++++++++------
 drivers/scsi/scsi_tgt_priv.h  |   22 +++++++----
 include/scsi/scsi_host.h      |    2 +-
 include/scsi/scsi_tgt.h       |    8 ++-
 include/scsi/scsi_tgt_if.h    |   35 +++++++++++++----
 include/scsi/scsi_transport.h |    6 +++
 7 files changed, 161 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index ca22ddf..9815a1a 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -102,7 +102,8 @@ static int tgt_uspace_send_event(u32 typ
 	return 0;
 }
 
-int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun, u64 tag)
+int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 itn_id,
+			     struct scsi_lun *lun, u64 tag)
 {
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	struct tgt_event ev;
@@ -110,6 +111,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_req.host_no = shost->host_no;
+	ev.p.cmd_req.itn_id = itn_id;
 	ev.p.cmd_req.data_len = cmd->request_bufflen;
 	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
 	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
@@ -127,7 +129,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi
 	return err;
 }
 
-int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag)
+int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 itn_id, u64 tag)
 {
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	struct tgt_event ev;
@@ -135,6 +137,7 @@ int scsi_tgt_uspace_send_status(struct s
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_done.host_no = shost->host_no;
+	ev.p.cmd_done.itn_id = itn_id;
 	ev.p.cmd_done.tag = tag;
 	ev.p.cmd_done.result = cmd->result;
 
@@ -149,14 +152,15 @@ int scsi_tgt_uspace_send_status(struct s
 	return err;
 }
 
-int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
-				  struct scsi_lun *scsilun, void *data)
+int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 itn_id, int function,
+				  u64 tag, struct scsi_lun *scsilun, void *data)
 {
 	struct tgt_event ev;
 	int err;
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.tsk_mgmt_req.host_no = host_no;
+	ev.p.tsk_mgmt_req.itn_id = itn_id;
 	ev.p.tsk_mgmt_req.function = function;
 	ev.p.tsk_mgmt_req.tag = tag;
 	memcpy(ev.p.tsk_mgmt_req.lun, scsilun, sizeof(ev.p.tsk_mgmt_req.lun));
@@ -172,6 +176,29 @@ int scsi_tgt_uspace_send_tsk_mgmt(int ho
 	return err;
 }
 
+int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 itn_id,
+					  int function, char *initiator_id)
+{
+	struct tgt_event ev;
+	int err;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.p.it_nexus_req.host_no = host_no;
+	ev.p.it_nexus_req.function = function;
+	ev.p.it_nexus_req.itn_id = itn_id;
+	if (initiator_id)
+		strncpy(ev.p.it_nexus_req.initiator_id, initiator_id,
+			sizeof(ev.p.it_nexus_req.initiator_id));
+
+	dprintk("%d %x %llx\n", host_no, function, (unsigned long long)itn_id);
+
+	err = tgt_uspace_send_event(TGT_KEVENT_IT_NEXUS_REQ, &ev);
+	if (err)
+		eprintk("tx buf is full, could not send\n");
+
+	return err;
+}
+
 static int event_recv_msg(struct tgt_event *ev)
 {
 	int err = 0;
@@ -179,6 +206,7 @@ static int event_recv_msg(struct tgt_eve
 	switch (ev->hdr.type) {
 	case TGT_UEVENT_CMD_RSP:
 		err = scsi_tgt_kspace_exec(ev->p.cmd_rsp.host_no,
+					   ev->p.cmd_rsp.itn_id,
 					   ev->p.cmd_rsp.result,
 					   ev->p.cmd_rsp.tag,
 					   ev->p.cmd_rsp.uaddr,
@@ -189,9 +217,15 @@ static int event_recv_msg(struct tgt_eve
 		break;
 	case TGT_UEVENT_TSK_MGMT_RSP:
 		err = scsi_tgt_kspace_tsk_mgmt(ev->p.tsk_mgmt_rsp.host_no,
+					       ev->p.tsk_mgmt_rsp.itn_id,
 					       ev->p.tsk_mgmt_rsp.mid,
 					       ev->p.tsk_mgmt_rsp.result);
 		break;
+	case TGT_UEVENT_IT_NEXUS_RSP:
+		err = scsi_tgt_kspace_it_nexus_rsp(ev->p.it_nexus_rsp.host_no,
+						   ev->p.it_nexus_rsp.itn_id,
+						   ev->p.it_nexus_rsp.result);
+		break;
 	default:
 		eprintk("unknown type %d\n", ev->hdr.type);
 		err = -EINVAL;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2570f48..7d15173 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -27,6 +27,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_tgt.h>
 
 #include "scsi_tgt_priv.h"
@@ -46,6 +47,7 @@ struct scsi_tgt_cmd {
 
 	struct list_head hash_list;
 	struct request *rq;
+	u64 itn_id;
 	u64 tag;
 };
 
@@ -185,12 +187,13 @@ static void scsi_tgt_cmd_destroy(struct
 }
 
 static void init_scsi_tgt_cmd(struct request *rq, struct scsi_tgt_cmd *tcmd,
-			      u64 tag)
+			      u64 itn_id, u64 tag)
 {
 	struct scsi_tgt_queuedata *qdata = rq->q->queuedata;
 	unsigned long flags;
 	struct list_head *head;
 
+	tcmd->itn_id = itn_id;
 	tcmd->tag = tag;
 	tcmd->bio = NULL;
 	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy);
@@ -301,14 +304,14 @@ EXPORT_SYMBOL_GPL(scsi_tgt_cmd_to_host);
  * @scsilun:	scsi lun
  * @tag:	unique value to identify this command for tmf
  */
-int scsi_tgt_queue_command(struct scsi_cmnd *cmd, struct scsi_lun *scsilun,
-			   u64 tag)
+int scsi_tgt_queue_command(struct scsi_cmnd *cmd, u64 itn_id,
+			   struct scsi_lun *scsilun, u64 tag)
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
 	int err;
 
-	init_scsi_tgt_cmd(cmd->request, tcmd, tag);
-	err = scsi_tgt_uspace_send_cmd(cmd, scsilun, tag);
+	init_scsi_tgt_cmd(cmd->request, tcmd, itn_id, tag);
+	err = scsi_tgt_uspace_send_cmd(cmd, itn_id, scsilun, tag);
 	if (err)
 		cmd_hashlist_del(cmd);
 
@@ -326,7 +329,7 @@ static void scsi_tgt_cmd_done(struct scs
 
 	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
 
-	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
+	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
 	if (cmd->request_buffer)
 		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
@@ -459,7 +462,7 @@ static struct request *tgt_cmd_hash_look
 	return rq;
 }
 
-int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
+int scsi_tgt_kspace_exec(int host_no, u64 itn_id, int result, u64 tag,
 			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
 			 u32 sense_len, u8 rw)
 {
@@ -541,21 +544,22 @@ done:
 	return err;
 }
 
-int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, int function, u64 tag,
-			      struct scsi_lun *scsilun, void *data)
+int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, u64 itn_id,
+			      int function, u64 tag, struct scsi_lun *scsilun,
+			      void *data)
 {
 	int err;
 
 	/* TODO: need to retry if this fails. */
-	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, function,
-					    tag, scsilun, data);
+	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, itn_id,
+					    function, tag, scsilun, data);
 	if (err < 0)
 		eprintk("The task management request lost!\n");
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_tgt_tsk_mgmt_request);
 
-int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result)
+int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 itn_id, u64 mid, int result)
 {
 	struct Scsi_Host *shost;
 	int err = -EINVAL;
@@ -573,7 +577,60 @@ int scsi_tgt_kspace_tsk_mgmt(int host_no
 		goto done;
 	}
 
-	err = shost->hostt->tsk_mgmt_response(mid, result);
+	err = shost->hostt->tsk_mgmt_response(shost, itn_id, mid, result);
+done:
+	scsi_host_put(shost);
+	return err;
+}
+
+int scsi_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+			     char *initiator)
+{
+	int err;
+
+	/* TODO: need to retry if this fails. */
+	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no, itn_id, 0,
+						    initiator);
+	if (err < 0)
+		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+			shost->host_no, (unsigned long long)itn_id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_create);
+
+int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	int err;
+
+	/* TODO: need to retry if this fails. */
+	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no,
+						    itn_id, 1, NULL);
+	if (err < 0)
+		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+			shost->host_no, (unsigned long long)itn_id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_destroy);
+
+int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 itn_id, int result)
+{
+	struct Scsi_Host *shost;
+	int err = -EINVAL;
+
+	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
+
+	shost = scsi_host_lookup(host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "Could not find host no %d\n", host_no);
+		return err;
+	}
+
+	if (!shost->uspace_req_q) {
+		printk(KERN_ERR "Not target scsi host %d\n", host_no);
+		goto done;
+	}
+
+	err = shost->transportt->it_nexus_response(shost, itn_id, result);
 done:
 	scsi_host_put(shost);
 	return err;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index e9e6db1..cb92888 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -15,12 +15,18 @@ #define dprintk(fmt, args...)
 extern void scsi_tgt_if_exit(void);
 extern int scsi_tgt_if_init(void);
 
-extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun,
-				    u64 tag);
-extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag);
-extern int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
-				unsigned long uaddr, u32 len, unsigned long sense_uaddr,
-				u32 sense_len, u8 rw);
-extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
+extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 it_nexus_id,
+				    struct scsi_lun *lun, u64 tag);
+extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 it_nexus_id,
+				       u64 tag);
+extern int scsi_tgt_kspace_exec(int host_no, u64 it_nexus_id, int result, u64 tag,
+				unsigned long uaddr, u32 len,
+				unsigned long sense_uaddr, u32 sense_len, u8 rw);
+extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 it_nexus_id,
+					 int function, u64 tag,
 					 struct scsi_lun *scsilun, void *data);
-extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result);
+extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 it_nexus_id,
+				    u64 mid, int result);
+extern int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 it_nexus_id,
+						 int function, char *initiator);
+extern int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 it_nexus_id, int result);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba07cf7..dcf4a20 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -146,7 +146,7 @@ #endif
 				  void (*done)(struct scsi_cmnd *));
 
 	/* Used as callback for the completion of task management request. */
-	int (* tsk_mgmt_response)(u64 mid, int result);
+	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64 mid, int result);
 
 	/*
 	 * This is an error handling strategy routine.  You don't need to
diff --git a/include/scsi/scsi_tgt.h b/include/scsi/scsi_tgt.h
index 4f44279..d0fefb9 100644
--- a/include/scsi/scsi_tgt.h
+++ b/include/scsi/scsi_tgt.h
@@ -11,9 +11,11 @@ struct scsi_lun;
 extern struct Scsi_Host *scsi_tgt_cmd_to_host(struct scsi_cmnd *);
 extern int scsi_tgt_alloc_queue(struct Scsi_Host *);
 extern void scsi_tgt_free_queue(struct Scsi_Host *);
-extern int scsi_tgt_queue_command(struct scsi_cmnd *, struct scsi_lun *, u64);
-extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, int, u64, struct scsi_lun *,
-				     void *);
+extern int scsi_tgt_queue_command(struct scsi_cmnd *, u64, struct scsi_lun *, u64);
+extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, u64, int, u64,
+				     struct scsi_lun *, void *);
 extern struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *,
 					       enum dma_data_direction,	gfp_t);
 extern void scsi_host_put_command(struct Scsi_Host *, struct scsi_cmnd *);
+extern int scsi_tgt_it_nexus_create(struct Scsi_Host *, u64, char *);
+extern int scsi_tgt_it_nexus_destroy(struct Scsi_Host *, u64);
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index 4cf9dff..f2ee7c2 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -23,13 +23,15 @@ #ifndef __SCSI_TARGET_IF_H
 #define __SCSI_TARGET_IF_H
 
 /* user -> kernel */
-#define	TGT_UEVENT_CMD_RSP	0x0001
-#define	TGT_UEVENT_TSK_MGMT_RSP	0x0002
+#define	TGT_UEVENT_CMD_RSP		0x0001
+#define	TGT_UEVENT_IT_NEXUS_RSP		0x0002
+#define	TGT_UEVENT_TSK_MGMT_RSP		0x0003
 
 /* kernel -> user */
-#define	TGT_KEVENT_CMD_REQ	0x1001
-#define	TGT_KEVENT_CMD_DONE	0x1002
-#define	TGT_KEVENT_TSK_MGMT_REQ	0x1003
+#define	TGT_KEVENT_CMD_REQ		0x1001
+#define	TGT_KEVENT_CMD_DONE		0x1002
+#define	TGT_KEVENT_IT_NEXUS_REQ		0x1003
+#define	TGT_KEVENT_TSK_MGMT_REQ		0x1004
 
 struct tgt_event_hdr {
 	uint16_t version;
@@ -46,6 +48,7 @@ struct tgt_event {
 		struct {
 			int host_no;
 			int result;
+			aligned_u64 itn_id;
 			aligned_u64 tag;
 			aligned_u64 uaddr;
 			aligned_u64 sense_uaddr;
@@ -55,15 +58,22 @@ struct tgt_event {
 		} cmd_rsp;
 		struct {
 			int host_no;
-			aligned_u64 mid;
 			int result;
+			aligned_u64 itn_id;
+			aligned_u64 mid;
 		} tsk_mgmt_rsp;
-
+		struct {
+			__s32 host_no;
+			__s32 result;
+			aligned_u64 itn_id;
+			__u32 function;
+		} it_nexus_rsp;
 
 		/* kernel -> user */
 		struct {
 			int host_no;
 			uint32_t data_len;
+			aligned_u64 itn_id;
 			uint8_t scb[16];
 			uint8_t lun[8];
 			int attribute;
@@ -71,16 +81,25 @@ struct tgt_event {
 		} cmd_req;
 		struct {
 			int host_no;
-			aligned_u64 tag;
 			int result;
+			aligned_u64 itn_id;
+			aligned_u64 tag;
 		} cmd_done;
 		struct {
 			int host_no;
 			int function;
+			aligned_u64 itn_id;
 			aligned_u64 tag;
 			uint8_t lun[8];
 			aligned_u64 mid;
 		} tsk_mgmt_req;
+		struct {
+			__s32 host_no;
+			__u32 function;
+			aligned_u64 itn_id;
+			__u32 max_cmds;
+			__u8 initiator_id[16];
+		} it_nexus_req;
 	} p;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 3c18baa..af5b3e1 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -65,6 +65,12 @@ struct scsi_transport_template {
 	 * EH_NOT_HANDLED	Begin normal error recovery
 	 */
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+
+	/*
+	 * Used as callback for the completion of i_t_nexus request
+	 * for target drivers.
+	 */
+	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
 };
 
 #define transport_class_to_shost(tc) \
-- 
1.4.3.2

