From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.28-rc4
Date: Fri, 14 Nov 2008 11:25:39 -0600
Message-ID: <1226683539.3289.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60429 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYKNRZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2008 12:25:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the cumulative delta so far.  We have a couple of other bugzilla
fixes in the works, but I'll send them along later.  It's a set of bug
fixes for zfcp (S390) and qla2xxx plus a few other assorted oopses and
data corruption fixes.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (2):
      qla2xxx: Update version number to 8.02.01-k9.
      qla2xxx: Use pci_disable_rom() to manipulate PCI config space.

Christof Schmitt (6):
      zfcp: Fix hexdump data in s390dbf traces
      zfcp: Wait for port scan to complete when setting adapter online
      zfcp: Fix cast warning
      zfcp: Fix request list handling in error path
      zfcp: fix mempool usage for status_read requests
      zfcp: Dont clear reference from SCSI device to unit

FUJITA Tomonori (1):
      megaraid: fix mega_internal_command oops
Andrew Vasquez (2):
      qla2xxx: Update version number to 8.02.01-k9.
      qla2xxx: Use pci_disable_rom() to manipulate PCI config space.

Christof Schmitt (6):
      zfcp: Fix hexdump data in s390dbf traces
      zfcp: Wait for port scan to complete when setting adapter online
      zfcp: Fix cast warning
      zfcp: Fix request list handling in error path
      zfcp: fix mempool usage for status_read requests
      zfcp: Dont clear reference from SCSI device to unit

FUJITA Tomonori (1):
      megaraid: fix mega_internal_command oops

Heiko Carstens (1):
      zfcp: fix req_list_locking.

Lalit Chandivade (1):
      qla2xxx: Correct Atmel flash-part handling.

Martin Petermann (1):
      zfcp: fix erp timeout cleanup for port open requests

Michael Reed (1):
      qla2xxx: Return a FAILED status when abort mailbox-command fails.

Mike Christie (1):
      scsi_error regression: Fix idempotent command handling

Miquel van Smoorenburg (1):
      dpt_i2o: fix transferred data length for scsi_set_resid()

Shyam Sundar (1):
      qla2xxx: Do not honour max_vports from firmware for 2G ISPs and below.


The diffstat:

 drivers/s390/scsi/zfcp_aux.c       |    3 +-
 drivers/s390/scsi/zfcp_ccw.c       |    4 ++-
 drivers/s390/scsi/zfcp_dbf.c       |   42 ++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_dbf.h       |    8 +------
 drivers/s390/scsi/zfcp_erp.c       |    1 
 drivers/s390/scsi/zfcp_fsf.c       |   23 ++++++++------------
 drivers/s390/scsi/zfcp_scsi.c      |   12 +++-------
 drivers/scsi/dpt_i2o.c             |    4 +--
 drivers/scsi/megaraid.c            |   11 +++++++--
 drivers/scsi/megaraid.h            |    2 -
 drivers/scsi/qla2xxx/qla_def.h     |    1 
 drivers/scsi/qla2xxx/qla_init.c    |   26 ++++------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 -
 drivers/scsi/qla2xxx/qla_os.c      |    1 
 drivers/scsi/qla2xxx/qla_sup.c     |   19 ++++++----------
 drivers/scsi/qla2xxx/qla_version.h |    2 -
 drivers/scsi/scsi_error.c          |    5 ++--
 17 files changed, 67 insertions(+), 99 deletions(-)

And the full diff is attached below.

James

---

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 3b56220..3d4e3e3 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -610,7 +610,8 @@ struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, u64 wwpn,
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set(&port->refcount, 0);
 
-	dev_set_name(&port->sysfs_device, "0x%016llx", wwpn);
+	dev_set_name(&port->sysfs_device, "0x%016llx",
+		     (unsigned long long)wwpn);
 	port->sysfs_device.parent = &adapter->ccw_device->dev;
 
 	port->sysfs_device.release = zfcp_sysfs_port_release;
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index b04038c..951a8d4 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -116,7 +116,9 @@ static int zfcp_ccw_set_online(struct ccw_device *ccw_device)
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85,
 				NULL);
 	zfcp_erp_wait(adapter);
-	goto out;
+	up(&zfcp_data.config_sema);
+	flush_work(&adapter->scan_work);
+	return 0;
 
  out_scsi_register:
 	zfcp_erp_thread_kill(adapter);
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 060f5f2..31012d5 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -30,7 +30,7 @@ static void zfcp_dbf_hexdump(debug_info_t *dbf, void *to, int to_len,
 		dump->offset = offset;
 		dump->size = min(from_len - offset, room);
 		memcpy(dump->data, from + offset, dump->size);
-		debug_event(dbf, level, dump, dump->size);
+		debug_event(dbf, level, dump, dump->size + sizeof(*dump));
 	}
 }
 
@@ -108,7 +108,7 @@ static int zfcp_dbf_view_header(debug_info_t *id, struct debug_view *view,
 			     t.tv_sec, t.tv_nsec);
 		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
 	} else	{
-		zfcp_dbf_outd(&p, NULL, dump->data, dump->size, dump->offset,
+		zfcp_dbf_outd(&p, "", dump->data, dump->size, dump->offset,
 			      dump->total_size);
 		if ((dump->offset + dump->size) == dump->total_size)
 			p += sprintf(p, "\n");
@@ -366,6 +366,7 @@ static void zfcp_hba_dbf_view_response(char **p,
 			break;
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
 		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
+		p += sprintf(*p, "\n");
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
@@ -465,7 +466,8 @@ static int zfcp_hba_dbf_view_format(debug_info_t *id, struct debug_view *view,
 	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_hba_dbf_view_berr(&p, &r->u.berr);
 
-	p += sprintf(p, "\n");
+	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
+		p += sprintf(p, "\n");
 	return p - out_buf;
 }
 
@@ -880,6 +882,7 @@ void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
 	struct ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
+	int level = 3;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
@@ -896,9 +899,10 @@ void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
 	oct->options = hdr->options;
 	oct->max_res_size = hdr->max_res_size;
 	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
-		       ZFCP_DBF_CT_PAYLOAD);
-	memcpy(oct->payload, (void *)hdr + sizeof(struct ct_hdr), oct->len);
-	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+		       ZFCP_DBF_SAN_MAX_PAYLOAD);
+	debug_event(adapter->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+			 (void *)hdr + sizeof(struct ct_hdr), oct->len);
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -914,6 +918,7 @@ void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
 	struct ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
+	int level = 3;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
@@ -929,9 +934,10 @@ void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
 	rct->expl = hdr->reason_code_expl;
 	rct->vendor_unique = hdr->vendor_unique;
 	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
-		       ZFCP_DBF_CT_PAYLOAD);
-	memcpy(rct->payload, (void *)hdr + sizeof(struct ct_hdr), rct->len);
-	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+		       ZFCP_DBF_SAN_MAX_PAYLOAD);
+	debug_event(adapter->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+			 (void *)hdr + sizeof(struct ct_hdr), rct->len);
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -954,7 +960,7 @@ static void zfcp_san_dbf_event_els(const char *tag, int level,
 	rec->u.els.ls_code = ls_code;
 	debug_event(adapter->san_dbf, level, rec, sizeof(*rec));
 	zfcp_dbf_hexdump(adapter->san_dbf, rec, sizeof(*rec), level,
-			 buffer, min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD));
+			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -1008,8 +1014,6 @@ static int zfcp_san_dbf_view_format(debug_info_t *id, struct debug_view *view,
 				    char *out_buf, const char *in_buf)
 {
 	struct zfcp_san_dbf_record *r = (struct zfcp_san_dbf_record *)in_buf;
-	char *buffer = NULL;
-	int buflen = 0, total = 0;
 	char *p = out_buf;
 
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
@@ -1029,9 +1033,6 @@ static int zfcp_san_dbf_view_format(debug_info_t *id, struct debug_view *view,
 		zfcp_dbf_out(&p, "gs_subtype", "0x%02x", ct->gs_subtype);
 		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
 		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-		total = ct->len;
-		buffer = ct->payload;
-		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_san_dbf_record_ct_response *ct = &r->u.ct_resp;
 		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
@@ -1039,23 +1040,12 @@ static int zfcp_san_dbf_view_format(debug_info_t *id, struct debug_view *view,
 		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
 		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
 		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
-		total = ct->len;
-		buffer = ct->payload;
-		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_san_dbf_record_els *els = &r->u.els;
 		zfcp_dbf_out(&p, "ls_code", "0x%02x", els->ls_code);
-		total = els->len;
-		buffer = els->payload;
-		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
 	}
-
-	zfcp_dbf_outd(&p, "payload", buffer, buflen, 0, total);
-	if (buflen == total)
-		p += sprintf(p, "\n");
-
 	return p - out_buf;
 }
 
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index e8f4508..5d6b2df 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -163,8 +163,6 @@ struct zfcp_san_dbf_record_ct_request {
 	u8 options;
 	u16 max_res_size;
 	u32 len;
-#define ZFCP_DBF_CT_PAYLOAD	24
-	u8 payload[ZFCP_DBF_CT_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record_ct_response {
@@ -174,15 +172,11 @@ struct zfcp_san_dbf_record_ct_response {
 	u8 expl;
 	u8 vendor_unique;
 	u32 len;
-	u8 payload[ZFCP_DBF_CT_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record_els {
 	u8 ls_code;
 	u32 len;
-#define ZFCP_DBF_ELS_PAYLOAD	32
-#define ZFCP_DBF_ELS_MAX_PAYLOAD 1024
-	u8 payload[ZFCP_DBF_ELS_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record {
@@ -196,6 +190,8 @@ struct zfcp_san_dbf_record {
 		struct zfcp_san_dbf_record_ct_response ct_resp;
 		struct zfcp_san_dbf_record_els els;
 	} u;
+#define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
+	u8 payload[32];
 } __attribute__ ((packed));
 
 struct zfcp_scsi_dbf_record {
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 9040f73..35364f6 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -472,6 +472,7 @@ static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
 			zfcp_rec_dbf_event_action(142, act);
+			act->fsf_req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_rec_dbf_event_action(143, act);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 5ae1d49..d024442 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -683,6 +683,7 @@ static struct zfcp_fsf_req *zfcp_fsf_alloc_noqtcb(mempool_t *pool)
 	if (!req)
 		return NULL;
 	memset(req, 0, sizeof(*req));
+	req->pool = pool;
 	return req;
 }
 
@@ -769,28 +770,24 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	unsigned long flags;
 	int idx;
 
 	/* put allocated FSF request into hash table */
-	spin_lock(&adapter->req_list_lock);
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	idx = zfcp_reqlist_hash(req->req_id);
 	list_add_tail(&req->list, &adapter->req_list[idx]);
-	spin_unlock(&adapter->req_list_lock);
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	req->qdio_outb_usage = atomic_read(&req_q->count);
+	req->qdio_outb_usage = atomic_read(&adapter->req_q.count);
 	req->issued = get_clock();
 	if (zfcp_qdio_send(req)) {
-		/* Queues are down..... */
 		del_timer(&req->timer);
-		spin_lock(&adapter->req_list_lock);
-		zfcp_reqlist_remove(adapter, req);
-		spin_unlock(&adapter->req_list_lock);
-		/* undo changes in request queue made for this request */
-		atomic_add(req->sbal_number, &req_q->count);
-		req_q->first -= req->sbal_number;
-		req_q->first += QDIO_MAX_BUFFERS_PER_Q;
-		req_q->first %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
+		spin_lock_irqsave(&adapter->req_list_lock, flags);
+		/* lookup request again, list might have changed */
+		if (zfcp_reqlist_find_safe(adapter, req))
+			zfcp_reqlist_remove(adapter, req);
+		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 		zfcp_erp_adapter_reopen(adapter, 0, 116, req);
 		return -EIO;
 	}
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index ca8f85f..e46fd3e 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -24,14 +24,10 @@ char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
-	WARN_ON(!unit);
-	if (unit) {
-		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
-		sdpnt->hostdata = NULL;
-		unit->device = NULL;
-		zfcp_erp_unit_failed(unit, 12, NULL);
-		zfcp_unit_put(unit);
-	}
+	atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
+	unit->device = NULL;
+	zfcp_erp_unit_failed(unit, 12, NULL);
+	zfcp_unit_put(unit);
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8aba4fd..6194ed5 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2445,7 +2445,7 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 	hba_status = detailed_status >> 8;
 
 	// calculate resid for sg 
-	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
+	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+20));
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 
@@ -2456,7 +2456,7 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		case I2O_SCSI_DSC_SUCCESS:
 			cmd->result = (DID_OK << 16);
 			// handle underflow
-			if(readl(reply+5) < cmd->underflow ) {
+			if (readl(reply+20) < cmd->underflow) {
 				cmd->result = (DID_ERROR <<16);
 				printk(KERN_WARNING"%s: SCSI CMD underflow\n",pHba->name);
 			}
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 28c9da7..7dc62de 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4402,6 +4402,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scb_t	*scb;
 	int	rval;
 
+	scmd = scsi_allocate_command(GFP_KERNEL);
+	if (!scmd)
+		return -ENOMEM;
+
 	/*
 	 * The internal commands share one command id and hence are
 	 * serialized. This is so because we want to reserve maximum number of
@@ -4412,12 +4416,11 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));
 
-	scmd = &adapter->int_scmd;
-	memset(scmd, 0, sizeof(Scsi_Cmnd));
-
 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;
 
+	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
+	scmd->cmnd = adapter->int_cdb;
 	scmd->device->host = adapter->host;
 	scmd->host_scribble = (void *)scb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
@@ -4456,6 +4459,8 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 
 	mutex_unlock(&adapter->int_mtx);
 
+	scsi_free_command(GFP_KERNEL, scmd);
+
 	return rval;
 }
 
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..795201f 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -888,8 +888,8 @@ typedef struct {
 
 	u8	sglen;	/* f/w supported scatter-gather list length */
 
+	unsigned char int_cdb[MAX_COMMAND_SIZE];
 	scb_t			int_scb;
-	Scsi_Cmnd		int_scmd;
 	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */
 	struct completion	int_waitq;	/* wait queue for internal
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f25f41a..b971940 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2547,7 +2547,6 @@ typedef struct scsi_qla_host {
 	uint8_t		fcode_revision[16];
 	uint32_t	fw_revision[4];
 
-	uint16_t	fdt_odd_index;
 	uint32_t	fdt_wrt_disable;
 	uint32_t	fdt_erase_cmd;
 	uint32_t	fdt_block_size;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a470f2d..4218f20 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -140,7 +140,6 @@ int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -151,10 +150,7 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -174,7 +170,6 @@ int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t	w;
-	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -236,10 +231,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -259,7 +251,6 @@ int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -281,10 +272,7 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
 		pcie_set_readrq(ha->pdev, 2048);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 
@@ -306,7 +294,6 @@ int
 qla25xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 
 	pci_set_master(ha->pdev);
 	pci_try_set_mwi(ha->pdev);
@@ -320,10 +307,7 @@ qla25xx_pci_config(scsi_qla_host_t *ha)
 	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
 		pcie_set_readrq(ha->pdev, 2048);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 
@@ -980,7 +964,6 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
-				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
 				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
 				     IS_QLA84XX(ha)) &&
@@ -992,6 +975,7 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
+				qla2x00_resize_request_q(ha);
 
 				if (ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(ha);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 36bc685..3402746 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1964,7 +1964,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
-		if (max_npiv_vports)
+		if (ha->flags.npiv_supported && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 21dd182..3556720 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -728,6 +728,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (ha->isp_ops->abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
+			ret = FAILED;
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
 			    "mbx success.\n", __func__, ha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 90a1321..e4af678 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -722,6 +722,7 @@ done:
 static void
 qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 {
+#define FLASH_BLK_SIZE_4K	0x1000
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
 	const char *loc, *locations[] = { "MID", "FDT" };
@@ -755,7 +756,6 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 	loc = locations[1];
 	mid = le16_to_cpu(fdt->man_id);
 	fid = le16_to_cpu(fdt->id);
-	ha->fdt_odd_index = mid == 0x1f;
 	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
 	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
 	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
@@ -788,8 +788,7 @@ no_flash_data:
 		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
 		break;
 	case 0x1f: /* Atmel 26DF081A. */
-		ha->fdt_odd_index = 1;
-		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		ha->fdt_block_size = FLASH_BLK_SIZE_4K;
 		ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0320);
 		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0339);
 		ha->fdt_protect_sec_cmd = flash_conf_to_access_addr(0x0336);
@@ -801,9 +800,9 @@ no_flash_data:
 	}
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FDT[%s]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
+	    "pro=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
 	    ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
-	    ha->fdt_unprotect_sec_cmd, ha->fdt_odd_index, ha->fdt_wrt_disable,
+	    ha->fdt_unprotect_sec_cmd, ha->fdt_wrt_disable,
 	    ha->fdt_block_size));
 }
 
@@ -987,13 +986,9 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-		if (ha->fdt_odd_index) {
-			findex = faddr << 2;
-			fdata = findex & sec_mask;
-		} else {
-			findex = faddr;
-			fdata = (findex & sec_mask) << 2;
-		}
+
+		findex = faddr;
+		fdata = (findex & sec_mask) << 2;
 
 		/* Are we at the beginning of a sector? */
 		if ((findex & rest_addr) == 0) {
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index be5e299..eea6720 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k8"
+#define QLA2XXX_VERSION      "8.02.01-k9"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 94ed262..3863617 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1340,9 +1340,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * LLD/transport was disrupted during processing of the IO.
 		 * The transport class is now blocked/blocking,
 		 * and the transport will decide what to do with the IO
-		 * based on its timers and recovery capablilities.
+		 * based on its timers and recovery capablilities if
+		 * there are enough retries.
 		 */
-		return ADD_TO_MLQUEUE;
+		goto maybe_retry;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely


