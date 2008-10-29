From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 1/2] scsi_transport_fc: FC pass through support - revised II
Date: Wed, 29 Oct 2008 05:48:03 -0700
Message-ID: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:46223 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYJ2MsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 08:48:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>

 From f32b386a61a23f408974f2289cd34200f59401e1 Mon Sep 17 00:00:00 2001
From: root <root@linux-atl-00.qlogic.com>
Date: Tue, 28 Oct 2008 19:27:15 -0700
Subject: [PATCH] scsi_transport_fc: FC pass through support

This patch will add FC pass through support.
The FC pass through support is service request handling mechanism
for FC specification defined services including,
- Link Services (Basic LS, Extended LS)
- Generic Services (FC-CT - Common Transport)
The support utilize BSG (Block layer SCSI Generic) interface with
bidi (bi-directional) nature in handling the service requests.

This patch added following featues in the support
- FC service structure has defined to transport service requests
- Handles the service request in asynchronous manner - LLD
- Timeout capability
- Abort capability

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
  drivers/scsi/scsi_transport_fc.c |  216 +++++++++++++++++++++++++++++ 
++++++++-
  include/scsi/scsi_transport_fc.h |   81 ++++++++++++++-
  2 files changed, 294 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index 1e71abf..e26e8e0 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -43,6 +43,11 @@ static void fc_vport_sched_delete(struct  
work_struct *work);
  static int fc_vport_setup(struct Scsi_Host *shost, int channel,
  	struct device *pdev, struct fc_vport_identifiers  *ids,
  	struct fc_vport **vport);
+static enum blk_eh_timer_return fc_service_timeout(struct request  
*req);
+static void fc_service_done(struct fc_service *);
+static int fc_service_handler(struct Scsi_Host *, struct fc_rport *,
+    struct request *, struct request_queue *);
+static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);

  /*
   * Redefine so that we can have same named attributes in the
@@ -2413,11 +2418,218 @@ fc_rport_final_delete(struct work_struct *work)

  	transport_remove_device(dev);
  	device_del(dev);
+	fc_bsg_remove(shost, rport);
  	transport_destroy_device(dev);
  	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
  	put_device(dev);			/* for self-reference */
  }

+static enum blk_eh_timer_return fc_service_timeout(struct request *req)
+{
+	struct fc_service *service = (void *) req->special;
+	struct Scsi_Host *shost = rport_to_shost(service->rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	unsigned long flags;
+	int res = 0;
+
+	if (service->rport->port_state == FC_PORTSTATE_BLOCKED)
+		return BLK_EH_RESET_TIMER;
+
+	spin_lock_irqsave(&service->service_state_lock, flags);
+	if (!(service->service_state_flag & FC_SERVICE_STATE_DONE))
+		service->service_state_flag |= FC_SERVICE_STATE_TIMEOUT;
+	spin_unlock_irqrestore(&service->service_state_lock, flags);
+
+	if (i->f->abort_fc_service)
+		res = i->f->abort_fc_service(service);
+
+	if (res) {
+		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
+		"failed with status %d\n", res);
+		fc_service_done(service);
+	}
+
+	/* the blk_end_sync_io() doesn't check the error */
+	return BLK_EH_NOT_HANDLED;
+}
+
+static void fc_service_done(struct fc_service *service)
+{
+
+	if (service->service_state_flag != FC_SERVICE_STATE_DONE) {
+		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT)
+			printk(KERN_ERR "ERROR: FC service timed out\n");
+		else if (service->service_state_flag ==
+		    FC_SERVICE_STATE_ABORTED)
+			printk(KERN_ERR "ERROR: FC service aborted\n");
+		else
+			printk(KERN_ERR "ERROR: FC service not finished\n");
+	}
+
+	if (service->srv_reply.status != FC_SERVICE_COMPLETE) {
+		printk(KERN_ERR "ERROR: FC service to rport %p failed with"
+		    " status 0x%x\n", service->rport,
+		    service->srv_reply.status);
+	}
+
+	service->req->errors = service->srv_reply.status;
+	service->req->next_rq->errors = service->srv_reply.status;
+
+	blk_end_bidi_request(service->req, service->srv_reply.status,
+	    blk_rq_bytes(service->req),
+	    service->req->next_rq ? blk_rq_bytes(service->req->next_rq) : 0);
+
+	kfree(service->payload_dma);
+	kfree(service->response_dma);
+	kfree(service);
+}
+
+static int
+issue_fc_service(struct fc_rport *rport, struct request *req,
+    struct request *rsp, struct request_queue *q)
+{
+	int res = -ECOMM;
+	struct fc_service *service;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_service_request *srv_request = (struct fc_service_request *)
+	    req->cmd;
+
+	service = kzalloc(sizeof (struct fc_service), GFP_KERNEL);
+	if (!service)
+		return -ENOMEM;
+
+	req->special = service;
+	service->rport = rport;
+	service->req = req;
+	service->q = q;
+	service->srv_request = srv_request;
+	service->timeout = req->timeout;
+
+	service->payload_dma = (struct scatterlist *)
+	    kzalloc(sizeof (struct scatterlist) * req->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->payload_dma, req->nr_phys_segments);
+	service->payload_sg_cnt =
+	    blk_rq_map_sg(q, req, service->payload_dma);
+	service->payload = (void *) bio_data(req->bio);
+	service->payload_size = req->data_len;
+
+	service->response_dma = (struct scatterlist *)
+	    kzalloc(sizeof (struct scatterlist) * rsp->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->response_dma, rsp->nr_phys_segments);
+	service->response_sg_cnt =
+	    blk_rq_map_sg(q, rsp, service->response_dma);
+	service->response = bio_data(rsp->bio);
+	service->response_size = rsp->data_len;
+
+	/* sense area of the request structure */
+	service->reply_seq = req->sense;
+	service->service_done = fc_service_done;
+	service->service_state_flag = FC_SERVICE_STATE_PENDING;
+
+	if (i->f->execute_fc_service)
+		res = i->f->execute_fc_service(service);
+
+	if (res) {
+		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
+		"failed with status %d\n", res);
+		fc_service_done(service);
+		return res;
+	}
+
+	return 0;
+}
+
+static int
+fc_service_handler(struct Scsi_Host *shost, struct fc_rport *rport,
+			  struct request *req, struct request_queue *q)
+{
+	int ret;
+	struct request *rsp = req->next_rq;
+
+	if (!rsp) {
+		printk(KERN_ERR "ERROR: space for a FC service"
+		   " response is missing\n");
+		return -EINVAL;
+	}
+
+	ret = issue_fc_service(rport, req, rsp, q);
+
+	return ret;
+}
+
+static void fc_service_dispatch(struct request_queue *q)
+{
+	struct request *req;
+	struct fc_rport *rport = q->queuedata;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		blkdev_dequeue_request(req);
+		spin_unlock_irq(q->queue_lock);
+
+		fc_service_handler(shost, rport, req, q);
+
+		spin_lock_irq(q->queue_lock);
+	}
+}
+
+static int
+fc_bsg_initialize(struct Scsi_Host *shost, struct fc_rport *rport)
+{
+	struct request_queue *q;
+	int error;
+	struct device *dev;
+	const char *name;
+	void (*release)(struct device *);
+
+	if (!rport) {
+		printk(KERN_ERR "ERROR: rport is NULL\n");
+		return -ENOMEM;
+	}
+
+	q = blk_init_queue(fc_service_dispatch, NULL);
+	if (!q)
+		return -ENOMEM;
+
+	dev = &rport->dev;
+	name = dev->bus_id;
+	release = NULL;
+
+	error = bsg_register_queue(q, dev, name, release);
+	if (error) {
+		blk_cleanup_queue(q);
+		return -ENOMEM;
+	}
+
+	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+	blk_queue_rq_timed_out(q, fc_service_timeout);
+	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
+
+	rport->q = q;
+	q->queuedata = rport;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+
+	return 0;
+}
+
+static void
+fc_bsg_remove(struct Scsi_Host *shost, struct fc_rport *rport)
+{
+	struct request_queue *q = rport->q;
+
+	if (!q)
+		return;
+
+	bsg_unregister_queue(q);
+}

  /**
   * fc_rport_create - allocates and creates a remote FC port.
@@ -2478,8 +2690,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	else
  		rport->scsi_target_id = -1;
  	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */

+	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
  	spin_unlock_irqrestore(shost->host_lock, flags);

  	dev = &rport->dev;
@@ -2498,6 +2710,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	transport_add_device(dev);
  	transport_configure_device(dev);

+	fc_bsg_initialize(shost, rport);
+
  	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
  		/* initiate a scan of the target */
  		rport->flags |= FC_RPORT_SCAN_PENDING;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/ 
scsi_transport_fc.h
index 49d8913..68104f5 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -33,7 +33,6 @@

  struct scsi_transport_template;

-
  /*
   * FC Port definitions - Following FC HBAAPI guidelines
   *
@@ -352,6 +351,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
   	struct delayed_work fail_io_work;
   	struct work_struct stgt_delete_work;
  	struct work_struct rport_delete_work;
+	struct request_queue *q;
  } __attribute__((aligned(sizeof(unsigned long))));

  /* bit field values for struct fc_rport "flags" field: */
@@ -515,6 +515,80 @@ struct fc_host_attrs {
  	struct workqueue_struct *devloss_work_q;
  };

+#define FC_STATUS_BUF_SIZE 96
+
+enum fc_frame_type {
+	FC_FRAME_TYPE_BS,
+	FC_FRAME_TYPE_ELS,
+	FC_FRAME_TYPE_IEC = 4,
+	FC_FRAME_TYPE_IP,
+	FC_FRAME_TYPE_FCP = 8,
+	FC_FRAME_TYPE_GPP,
+	FC_FRAME_TYPE_FC_CT = 0x20,
+};
+
+enum fc_service_status {
+	FC_SERVICE_COMPLETE,
+	FC_SERVICE_TIMEOUT,
+	FC_SERVICE_ABORT,
+	FC_SERVICE_UNSUPPORTED,
+	FC_SERVICE_ERROR = -1,
+};
+
+#define FC_SERVICE_STATE_PENDING      1
+#define FC_SERVICE_STATE_DONE         2
+#define FC_SERVICE_STATE_ABORTED      4
+#define FC_SERVICE_STATE_TIMEOUT      8
+
+#define FC_SERVICE_TIMEOUT 10
+
+/* request (CDB) structure of the sg_io_v4 */
+struct fc_service_request {
+	u8   request_type;
+	u8   timeout;
+	u8   reserved0;
+	u8   reserved1;
+};
+
+/* response  (request sense data) structure of the sg_io_v4 */
+struct fc_service_reply {
+	enum fc_service_status status;
+	u16  error_code;
+	u16  additional_error_code;
+	u32  residual;
+};
+
+struct fc_service {
+	struct fc_rport  *rport;
+	struct list_head list;
+
+	spinlock_t   service_state_lock;
+	unsigned     service_state_flag;
+
+	struct request *req;
+	struct request_queue *q;
+
+	/* Used by the discovery code. */
+	struct completion  completion;
+	int  timeout;
+
+	struct fc_service_request *srv_request;
+	void  *payload;
+	struct scatterlist *payload_dma;
+	int   payload_sg_cnt;
+	int   payload_size;
+	void  *response;
+	struct scatterlist *response_dma;
+	int   response_sg_cnt;
+	int   response_size;
+
+	struct fc_service_reply srv_reply;
+	void  *reply_seq;   /* pointer to sense area of request */
+	void  (*service_done)(struct fc_service *);
+
+	void *lld_pkt;
+};
+
  #define shost_to_fc_host(x) \
  	((struct fc_host_attrs *)(x)->shost_data)

@@ -613,6 +687,10 @@ struct fc_function_template {
  	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
  	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);

+	/* fc service handler */
+	int	(*execute_fc_service)(struct fc_service *);
+	int	(*abort_fc_service)(struct fc_service *);
+
  	/* allocation lengths for host-specific data */
  	u32	 			dd_fcrport_size;
  	u32	 			dd_fcvport_size;
@@ -736,7 +814,6 @@ fc_vport_set_state(struct fc_vport *vport, enum  
fc_vport_state new_state)
  	vport->vport_state = new_state;
  }

-
  struct scsi_transport_template *fc_attach_transport(
  			struct fc_function_template *);
  void fc_release_transport(struct scsi_transport_template *);
-- 
1.6.0.2


