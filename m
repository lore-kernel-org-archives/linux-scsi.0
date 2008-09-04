From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [RFC 1/2] scsi_transport_fc: pass through support through bsg interface
Date: Wed, 3 Sep 2008 19:55:13 -0700
Message-ID: <66E945FC-7033-4D66-9FD9-78731EE97AF6@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: multipart/mixed; boundary=Apple-Mail-4--475938107
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39122 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYIDCzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 22:55:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Robert W Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>


--Apple-Mail-4--475938107
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index cb971f0..a3c10ef 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -43,6 +43,13 @@ static void fc_vport_sched_delete(struct  
work_struct *work);
  static int fc_vport_setup(struct Scsi_Host *shost, int channel,
  	struct device *pdev, struct fc_vport_identifiers  *ids,
  	struct fc_vport **vport);
+static void fc_service_timedout(unsigned long);
+static void fc_service_done(struct fc_service *);
+static int
+fc_service_handler(struct Scsi_Host *, struct fc_rport *, struct  
request *);
+static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);
+
+struct kmem_cache *fc_service_cache;

  /*
   * Redefine so that we can have same named attributes in the
@@ -642,6 +649,11 @@ static __init int fc_transport_init(void)
  	error = transport_class_register(&fc_rport_class);
  	if (error)
  		return error;
+	fc_service_cache = kmem_cache_create("fc_service",
+					     sizeof(struct fc_service),
+					     0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fc_service_cache)
+		return -ENOMEM;
  	return transport_class_register(&fc_transport_class);
  }

@@ -651,6 +663,7 @@ static void __exit fc_transport_exit(void)
  	transport_class_unregister(&fc_rport_class);
  	transport_class_unregister(&fc_host_class);
  	transport_class_unregister(&fc_vport_class);
+	kmem_cache_destroy(fc_service_cache);
  }

  /*
@@ -2057,6 +2070,9 @@ fc_attach_transport(struct fc_function_template  
*ft)

  	i->f = ft;

+	/* for FC services (FC-CT, ELS, etc.) */
+	i->f->fc_service_handler = fc_service_handler;
+
  	/* Transport uses the shost workq for scsi scanning */
  	i->t.create_work_queue = 1;

@@ -2406,12 +2422,235 @@ fc_rport_final_delete(struct work_struct *work)

  	transport_remove_device(dev);
  	device_del(dev);
+	fc_bsg_remove(shost, rport);
  	transport_destroy_device(dev);
  	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
  	put_device(dev);			/* for self-reference */
  }


+static void fc_service_timedout(unsigned long _service)
+{
+	struct fc_service *service = (void *) _service;
+	unsigned long flags;
+
+	spin_lock_irqsave(&service->service_state_lock, flags);
+	if (!(service->service_state_flags & FC_SERVICE_STATE_DONE))
+		service->service_state_flags |= FC_SERVICE_STATE_ABORTED;
+	spin_unlock_irqrestore(&service->service_state_lock, flags);
+
+	complete(&service->completion);
+}
+
+static void fc_service_done(struct fc_service *service)
+{
+	if (!del_timer_sync(&service->timer)) {
+		printk(KERN_ERR "ERROR: FC timed out for rport %p\n",
+		    service->rport);
+		return;
+	}
+	complete(&service->completion);
+}
+
+static int
+issue_fc_service(struct fc_rport *rport, void *req, int req_size,
+    void *resp, int resp_size, void *service_reply)
+{
+	int res = -ECOMM;
+	struct fc_service *service = NULL;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_frame_header *frame = req;
+
+	if (!((frame->fh_type == FC_FRAME_TYPE_ELS) ||
+	    (frame->fh_type == FC_FRAME_TYPE_FC_CT))) {
+		printk(KERN_ERR "ERROR: invalid FC service type = %2x\n",
+		    frame->fh_type);
+		return -EINVAL;
+	}
+
+	if (frame->fh_type == FC_FRAME_TYPE_ELS) {
+		if (!i->f->execute_fc_els_service)
+			goto ex_err;
+	} else if (frame->fh_type == FC_FRAME_TYPE_FC_CT) {
+		if (!i->f->execute_fc_ct_service)
+			goto ex_err;
+	}
+
+	service = fc_alloc_service();
+	if (!service)
+		return -ENOMEM;
+
+	service->service_type = frame->fh_type;
+	service->ct_frame = (struct fc_ct_frame *) req;
+	service->req_size = req_size;
+	service->response = resp;
+	service->resp_size = resp_size;
+	service->rport = rport;
+	/* sense area of the request structure */
+	service->reply_seq = service_reply;
+	service->service_done = fc_service_done;
+
+	service->timer.data = (unsigned long) service;
+	service->timer.function = fc_service_timedout;
+	service->timer.expires = jiffies + FC_SERVICE_TIMEOUT*HZ;
+
+	sg_init_one(&service->sg_req, req, req_size);
+	sg_init_one(&service->sg_resp, resp, resp_size);
+
+	add_timer(&service->timer);
+
+	if (service->service_type == FC_FRAME_TYPE_ELS)
+		res = i->f->execute_fc_els_service(service);
+	else if (service->service_type == FC_FRAME_TYPE_FC_CT)
+		res = i->f->execute_fc_ct_service(service);
+
+	if (res) {
+		del_timer(&service->timer);
+		printk(KERN_ERR "ERROR: executing FC service failed:%d\n",
+		    res);
+		goto ex_err;
+	}
+
+	wait_for_completion(&service->completion);
+
+	if ((service->service_state_flags & FC_SERVICE_STATE_ABORTED)) {
+		printk(KERN_ERR "ERROR: FC service timed out or aborted\n");
+		i->f->abort_fc_service(service);
+		if (!(service->service_state_flags &
+		     FC_SERVICE_STATE_DONE)) {
+			printk(KERN_ERR "ERROR: FC service aborted"
+			    " and not done\n");
+			goto ex_err;
+		}
+	}
+	if (service->status.resp == FC_SERVICE_COMPLETE)
+		res = 0;
+	else {
+		printk(KERN_ERR "ERROR: FC service to rport %p"
+		    " response: 0x%x\n", rport, service->status.resp);
+		fc_free_service(service);
+		service = NULL;
+		return res;
+	}
+ex_err:
+	if (service != NULL)
+		fc_free_service(service);
+
+	return res;
+}
+
+static int
+fc_service_handler(struct Scsi_Host *shost, struct fc_rport *rport,
+			  struct request *req)
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
+	/* ELS doesn't support multiple SG */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk(KERN_WARNING "ERROR: multiple segments req %u,"
+		    " rsp %u  are not supported for ELS services\n",
+		    req->bio->bi_vcnt, rsp->bio->bi_vcnt);
+		return -EINVAL;
+	}
+
+	ret = issue_fc_service(rport, bio_data(req->bio), req->data_len,
+			bio_data(rsp->bio), rsp->data_len, req->sense);
+
+	if (ret > 0) {
+		/* positive number is the untransferred residual */
+		rsp->data_len = ret;
+		req->data_len = 0;
+		ret = 0;
+	} else if (ret == 0) {
+		rsp->data_len = 0;
+		req->data_len = 0;
+	}
+
+	return ret;
+}
+
+static void fc_service_request(struct request_queue *q)
+{
+	struct request *req;
+	struct fc_rport *rport = q->queuedata;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int (*handler)(struct Scsi_Host *, struct fc_rport *,
+		       struct request *);
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		blkdev_dequeue_request(req);
+		spin_unlock_irq(q->queue_lock);
+		handler = to_fc_internal
+			(shost->transportt)->f->fc_service_handler;
+		if (handler)
+			req->errors = handler(shost, rport, req);
+
+		spin_lock_irq(q->queue_lock);
+		req->end_io(req, req->errors);
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
+	if (!to_fc_internal(shost->transportt)->f->fc_service_handler)
+		return 0;
+
+	if (!rport) {
+		printk(KERN_ERR "ERROR: rport is NULL\n");
+		return -ENOMEM;
+	}
+
+	q = blk_init_queue(fc_service_request, NULL);
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
+
  /**
   * fc_rport_create - allocates and creates a remote FC port.
   * @shost:	scsi host the remote port is connected to.
@@ -2471,8 +2710,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	else
  		rport->scsi_target_id = -1;
  	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */

+	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
  	spin_unlock_irqrestore(shost->host_lock, flags);

  	dev = &rport->dev;
@@ -2491,6 +2730,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
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
index 21018a4..5cef236 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -32,7 +32,7 @@
  #include <scsi/scsi_netlink.h>

  struct scsi_transport_template;
-
+extern struct kmem_cache *fc_service_cache;

  /*
   * FC Port definitions - Following FC HBAAPI guidelines
@@ -352,6 +352,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
   	struct delayed_work fail_io_work;
   	struct work_struct stgt_delete_work;
  	struct work_struct rport_delete_work;
+	struct request_queue *q;
  } __attribute__((aligned(sizeof(unsigned long))));

  /* bit field values for struct fc_rport "flags" field: */
@@ -514,6 +515,134 @@ struct fc_host_attrs {
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
+enum service_response {
+	FC_SERVICE_COMPLETE,
+	FC_SERVICE_ERROR = -1,
+};
+
+#define FC_SERVICE_STATE_PENDING      1
+#define FC_SERVICE_STATE_DONE         2
+#define FC_SERVICE_STATE_ABORTED      4
+#define FC_SERVICE_AT_INITIATOR       16
+
+struct fc_service_status {
+	enum service_response resp;
+	int  error;
+	int  buf_valid_size;
+
+	u8   buf[FC_STATUS_BUF_SIZE];
+
+	u32  residual;
+};
+
+/* NOTE - fc_frame_header is already defined in open-fcoe-upstream  
branch */
+/*
+ * Frame header
+ */
+struct fc_frame_header {
+	__u8          fh_r_ctl;	/* routing control */
+	__u8          fh_d_id[3];	/* Destination ID */
+
+	__u8          fh_cs_ctl;	/* class of service control / pri */
+	__u8          fh_s_id[3];	/* Source ID */
+
+	__u8          fh_type;		/* see enum fc_fh_type below */
+	__u8          fh_f_ctl[3];	/* frame control */
+
+	__u8          fh_seq_id;	/* sequence ID */
+	__u8          fh_df_ctl;	/* data field control */
+	__be16        fh_seq_cnt;	/* sequence count */
+
+	__be16        fh_ox_id;		/* originator exchange ID */
+	__be16        fh_rx_id;		/* responder exchange ID */
+	__be32        fh_parm_offset;	/* parameter or relative offset */
+};
+
+/* TBD - fc_els_hdr to move to ~/include/scsi/fc/fc_els.h */
+struct fc_els_hdr {
+	__u8	els_cmd;
+	__u8	els_param[3];
+};
+
+/* NOTE - fc_ct_hdr is already defined in open-fcoe-upstream branch */
+/*
+ * Fibre Channel Services - Common Transport.
+ * From T11.org FC-GS-2 Rev 5.3 November 1998.
+ */
+
+struct fc_ct_hdr {
+	__u8		ct_rev;		/* revision */
+	__u8		ct_in_id[3];	/* N_Port ID of original requestor */
+	__u8		ct_fs_type;	/* type of fibre channel service */
+	__u8		ct_fs_subtype;	/* subtype */
+	__u8		ct_options;
+	__u8		_ct_resvd1;
+	__be16		ct_cmd;		/* command / response code */
+	__be16		ct_mr_size;	/* maximum / residual size */
+	__u8		_ct_resvd2;
+	__u8		ct_reason;	/* reject reason */
+	__u8		ct_explan;	/* reason code explanation */
+	__u8		ct_vendor;	/* vendor unique data */
+};
+
+struct fc_els_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_els_hdr els_hdr;
+	u32 els_cmd[4];
+};
+
+struct fc_ct_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_ct_hdr ct_hdr;
+	u32 ct_cmd[1];
+};
+
+#define FC_SERVICE_TIMEOUT 10
+
+struct fc_service {
+	struct fc_rport *rport;
+	struct list_head      list;
+
+	spinlock_t   service_state_lock;
+	unsigned     service_state_flags;
+
+	enum   fc_frame_type   service_type;
+
+	/* Used by the discovery code. */
+	struct timer_list     timer;
+	struct completion     completion;
+
+	union {
+		struct fc_ct_frame *ct_frame;
+		struct fc_els_frame *els_frame;
+	};
+	int req_size;
+	void *response;
+	int resp_size;
+
+	struct scatterlist sg_req;
+	struct scatterlist sg_resp;
+
+	struct fc_service_status status;
+	void *reply_seq;   /* pointer to sense area of request */
+	void   (*service_done)(struct fc_service *);
+
+	void *lld_pkt;
+	struct work_struct abort_work;
+};
+
  #define shost_to_fc_host(x) \
  	((struct fc_host_attrs *)(x)->shost_data)

@@ -612,6 +741,14 @@ struct fc_function_template {
  	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
  	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);

+	/* fibre-channel services */
+	int	(*fc_service_handler)(struct Scsi_Host *,
+				      struct fc_rport *rport,
+				      struct request *);
+	int	(*execute_fc_els_service)(struct fc_service *);
+	int	(*execute_fc_ct_service)(struct fc_service *);
+	int	(*abort_fc_service)(struct fc_service *);
+
  	/* allocation lengths for host-specific data */
  	u32	 			dd_fcrport_size;
  	u32	 			dd_fcvport_size;
@@ -732,6 +869,33 @@ fc_vport_set_state(struct fc_vport *vport, enum  
fc_vport_state new_state)
  	vport->vport_state = new_state;
  }

+static inline struct fc_service *
+fc_alloc_service(void)
+{
+	struct fc_service *service =
+	    kmem_cache_zalloc(fc_service_cache, GFP_KERNEL);
+
+	if (!service)
+		return NULL;
+
+	INIT_LIST_HEAD(&service->list);
+	spin_lock_init(&service->service_state_lock);
+	service->service_state_flags = FC_SERVICE_STATE_PENDING;
+	init_timer(&service->timer);
+	init_completion(&service->completion);
+
+	return service;
+}
+
+static inline void
+fc_free_service(struct fc_service *service)
+{
+	if (service) {
+		BUG_ON(!list_empty(&service->list));
+		kmem_cache_free(fc_service_cache, service);
+	}
+}
+

  struct scsi_transport_template *fc_attach_transport(
  			struct fc_function_template *);
---

--Apple-Mail-4--475938107
Content-Disposition: attachment;
	filename=bidi-support-transport.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="bidi-support-transport.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index cb971f0..a3c10ef 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -43,6 +43,13 @@ static void fc_vport_sched_delete(struct work_struct *work);
 static int fc_vport_setup(struct Scsi_Host *shost, int channel,
 	struct device *pdev, struct fc_vport_identifiers  *ids,
 	struct fc_vport **vport);
+static void fc_service_timedout(unsigned long);
+static void fc_service_done(struct fc_service *);
+static int
+fc_service_handler(struct Scsi_Host *, struct fc_rport *, struct request *);
+static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);
+
+struct kmem_cache *fc_service_cache;
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -642,6 +649,11 @@ static __init int fc_transport_init(void)
 	error = transport_class_register(&fc_rport_class);
 	if (error)
 		return error;
+	fc_service_cache = kmem_cache_create("fc_service",
+					     sizeof(struct fc_service),
+					     0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fc_service_cache)
+		return -ENOMEM;
 	return transport_class_register(&fc_transport_class);
 }
 
@@ -651,6 +663,7 @@ static void __exit fc_transport_exit(void)
 	transport_class_unregister(&fc_rport_class);
 	transport_class_unregister(&fc_host_class);
 	transport_class_unregister(&fc_vport_class);
+	kmem_cache_destroy(fc_service_cache);
 }
 
 /*
@@ -2057,6 +2070,9 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	i->f = ft;
 
+	/* for FC services (FC-CT, ELS, etc.) */
+	i->f->fc_service_handler = fc_service_handler;
+
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
 
@@ -2406,12 +2422,235 @@ fc_rport_final_delete(struct work_struct *work)
 
 	transport_remove_device(dev);
 	device_del(dev);
+	fc_bsg_remove(shost, rport);
 	transport_destroy_device(dev);
 	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
 	put_device(dev);			/* for self-reference */
 }
 
 
+static void fc_service_timedout(unsigned long _service)
+{
+	struct fc_service *service = (void *) _service;
+	unsigned long flags;
+
+	spin_lock_irqsave(&service->service_state_lock, flags);
+	if (!(service->service_state_flags & FC_SERVICE_STATE_DONE))
+		service->service_state_flags |= FC_SERVICE_STATE_ABORTED;
+	spin_unlock_irqrestore(&service->service_state_lock, flags);
+
+	complete(&service->completion);
+}
+
+static void fc_service_done(struct fc_service *service)
+{
+	if (!del_timer_sync(&service->timer)) {
+		printk(KERN_ERR "ERROR: FC timed out for rport %p\n",
+		    service->rport);
+		return;
+	}
+	complete(&service->completion);
+}
+
+static int
+issue_fc_service(struct fc_rport *rport, void *req, int req_size,
+    void *resp, int resp_size, void *service_reply)
+{
+	int res = -ECOMM;
+	struct fc_service *service = NULL;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_frame_header *frame = req;
+
+	if (!((frame->fh_type == FC_FRAME_TYPE_ELS) ||
+	    (frame->fh_type == FC_FRAME_TYPE_FC_CT))) {
+		printk(KERN_ERR "ERROR: invalid FC service type = %2x\n",
+		    frame->fh_type);
+		return -EINVAL;
+	}
+
+	if (frame->fh_type == FC_FRAME_TYPE_ELS) {
+		if (!i->f->execute_fc_els_service)
+			goto ex_err;
+	} else if (frame->fh_type == FC_FRAME_TYPE_FC_CT) {
+		if (!i->f->execute_fc_ct_service)
+			goto ex_err;
+	}
+
+	service = fc_alloc_service();
+	if (!service)
+		return -ENOMEM;
+
+	service->service_type = frame->fh_type;
+	service->ct_frame = (struct fc_ct_frame *) req;
+	service->req_size = req_size;
+	service->response = resp;
+	service->resp_size = resp_size;
+	service->rport = rport;
+	/* sense area of the request structure */
+	service->reply_seq = service_reply;
+	service->service_done = fc_service_done;
+
+	service->timer.data = (unsigned long) service;
+	service->timer.function = fc_service_timedout;
+	service->timer.expires = jiffies + FC_SERVICE_TIMEOUT*HZ;
+
+	sg_init_one(&service->sg_req, req, req_size);
+	sg_init_one(&service->sg_resp, resp, resp_size);
+
+	add_timer(&service->timer);
+
+	if (service->service_type == FC_FRAME_TYPE_ELS)
+		res = i->f->execute_fc_els_service(service);
+	else if (service->service_type == FC_FRAME_TYPE_FC_CT)
+		res = i->f->execute_fc_ct_service(service);
+
+	if (res) {
+		del_timer(&service->timer);
+		printk(KERN_ERR "ERROR: executing FC service failed:%d\n",
+		    res);
+		goto ex_err;
+	}
+
+	wait_for_completion(&service->completion);
+
+	if ((service->service_state_flags & FC_SERVICE_STATE_ABORTED)) {
+		printk(KERN_ERR "ERROR: FC service timed out or aborted\n");
+		i->f->abort_fc_service(service);
+		if (!(service->service_state_flags &
+		     FC_SERVICE_STATE_DONE)) {
+			printk(KERN_ERR "ERROR: FC service aborted"
+			    " and not done\n");
+			goto ex_err;
+		}
+	}
+	if (service->status.resp == FC_SERVICE_COMPLETE)
+		res = 0;
+	else {
+		printk(KERN_ERR "ERROR: FC service to rport %p"
+		    " response: 0x%x\n", rport, service->status.resp);
+		fc_free_service(service);
+		service = NULL;
+		return res;
+	}
+ex_err:
+	if (service != NULL)
+		fc_free_service(service);
+
+	return res;
+}
+
+static int
+fc_service_handler(struct Scsi_Host *shost, struct fc_rport *rport,
+			  struct request *req)
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
+	/* ELS doesn't support multiple SG */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk(KERN_WARNING "ERROR: multiple segments req %u,"
+		    " rsp %u  are not supported for ELS services\n",
+		    req->bio->bi_vcnt, rsp->bio->bi_vcnt);
+		return -EINVAL;
+	}
+
+	ret = issue_fc_service(rport, bio_data(req->bio), req->data_len,
+			bio_data(rsp->bio), rsp->data_len, req->sense);
+
+	if (ret > 0) {
+		/* positive number is the untransferred residual */
+		rsp->data_len = ret;
+		req->data_len = 0;
+		ret = 0;
+	} else if (ret == 0) {
+		rsp->data_len = 0;
+		req->data_len = 0;
+	}
+
+	return ret;
+}
+
+static void fc_service_request(struct request_queue *q)
+{
+	struct request *req;
+	struct fc_rport *rport = q->queuedata;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int (*handler)(struct Scsi_Host *, struct fc_rport *,
+		       struct request *);
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		blkdev_dequeue_request(req);
+		spin_unlock_irq(q->queue_lock);
+		handler = to_fc_internal
+			(shost->transportt)->f->fc_service_handler;
+		if (handler)
+			req->errors = handler(shost, rport, req);
+
+		spin_lock_irq(q->queue_lock);
+		req->end_io(req, req->errors);
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
+	if (!to_fc_internal(shost->transportt)->f->fc_service_handler)
+		return 0;
+
+	if (!rport) {
+		printk(KERN_ERR "ERROR: rport is NULL\n");
+		return -ENOMEM;
+	}
+
+	q = blk_init_queue(fc_service_request, NULL);
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
+
 /**
  * fc_rport_create - allocates and creates a remote FC port.
  * @shost:	scsi host the remote port is connected to.
@@ -2471,8 +2710,8 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	else
 		rport->scsi_target_id = -1;
 	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
 
+	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	dev = &rport->dev;
@@ -2491,6 +2730,8 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
+	fc_bsg_initialize(shost, rport);
+
 	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 		/* initiate a scan of the target */
 		rport->flags |= FC_RPORT_SCAN_PENDING;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 21018a4..5cef236 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -32,7 +32,7 @@
 #include <scsi/scsi_netlink.h>
 
 struct scsi_transport_template;
-
+extern struct kmem_cache *fc_service_cache;
 
 /*
  * FC Port definitions - Following FC HBAAPI guidelines
@@ -352,6 +352,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
  	struct delayed_work fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
+	struct request_queue *q;
 } __attribute__((aligned(sizeof(unsigned long))));
 
 /* bit field values for struct fc_rport "flags" field: */
@@ -514,6 +515,134 @@ struct fc_host_attrs {
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
+enum service_response {
+	FC_SERVICE_COMPLETE,
+	FC_SERVICE_ERROR = -1,
+};
+
+#define FC_SERVICE_STATE_PENDING      1
+#define FC_SERVICE_STATE_DONE         2
+#define FC_SERVICE_STATE_ABORTED      4
+#define FC_SERVICE_AT_INITIATOR       16
+
+struct fc_service_status {
+	enum service_response resp;
+	int  error;
+	int  buf_valid_size;
+
+	u8   buf[FC_STATUS_BUF_SIZE];
+
+	u32  residual;
+};
+
+/* NOTE - fc_frame_header is already defined in open-fcoe-upstream branch */
+/*
+ * Frame header
+ */
+struct fc_frame_header {
+	__u8          fh_r_ctl;	/* routing control */
+	__u8          fh_d_id[3];	/* Destination ID */
+
+	__u8          fh_cs_ctl;	/* class of service control / pri */
+	__u8          fh_s_id[3];	/* Source ID */
+
+	__u8          fh_type;		/* see enum fc_fh_type below */
+	__u8          fh_f_ctl[3];	/* frame control */
+
+	__u8          fh_seq_id;	/* sequence ID */
+	__u8          fh_df_ctl;	/* data field control */
+	__be16        fh_seq_cnt;	/* sequence count */
+
+	__be16        fh_ox_id;		/* originator exchange ID */
+	__be16        fh_rx_id;		/* responder exchange ID */
+	__be32        fh_parm_offset;	/* parameter or relative offset */
+};
+
+/* TBD - fc_els_hdr to move to ~/include/scsi/fc/fc_els.h */
+struct fc_els_hdr {
+	__u8	els_cmd;
+	__u8	els_param[3];
+};
+
+/* NOTE - fc_ct_hdr is already defined in open-fcoe-upstream branch */
+/*
+ * Fibre Channel Services - Common Transport.
+ * From T11.org FC-GS-2 Rev 5.3 November 1998.
+ */
+
+struct fc_ct_hdr {
+	__u8		ct_rev;		/* revision */
+	__u8		ct_in_id[3];	/* N_Port ID of original requestor */
+	__u8		ct_fs_type;	/* type of fibre channel service */
+	__u8		ct_fs_subtype;	/* subtype */
+	__u8		ct_options;
+	__u8		_ct_resvd1;
+	__be16		ct_cmd;		/* command / response code */
+	__be16		ct_mr_size;	/* maximum / residual size */
+	__u8		_ct_resvd2;
+	__u8		ct_reason;	/* reject reason */
+	__u8		ct_explan;	/* reason code explanation */
+	__u8		ct_vendor;	/* vendor unique data */
+};
+
+struct fc_els_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_els_hdr els_hdr;
+	u32 els_cmd[4];
+};
+
+struct fc_ct_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_ct_hdr ct_hdr;
+	u32 ct_cmd[1];
+};
+
+#define FC_SERVICE_TIMEOUT 10
+
+struct fc_service {
+	struct fc_rport *rport;
+	struct list_head      list;
+
+	spinlock_t   service_state_lock;
+	unsigned     service_state_flags;
+
+	enum   fc_frame_type   service_type;
+
+	/* Used by the discovery code. */
+	struct timer_list     timer;
+	struct completion     completion;
+
+	union {
+		struct fc_ct_frame *ct_frame;
+		struct fc_els_frame *els_frame;
+	};
+	int req_size;
+	void *response;
+	int resp_size;
+
+	struct scatterlist sg_req;
+	struct scatterlist sg_resp;
+
+	struct fc_service_status status;
+	void *reply_seq;   /* pointer to sense area of request */
+	void   (*service_done)(struct fc_service *);
+
+	void *lld_pkt;
+	struct work_struct abort_work;
+};
+
 #define shost_to_fc_host(x) \
 	((struct fc_host_attrs *)(x)->shost_data)
 
@@ -612,6 +741,14 @@ struct fc_function_template {
 	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
 
+	/* fibre-channel services */
+	int	(*fc_service_handler)(struct Scsi_Host *,
+				      struct fc_rport *rport,
+				      struct request *);
+	int	(*execute_fc_els_service)(struct fc_service *);
+	int	(*execute_fc_ct_service)(struct fc_service *);
+	int	(*abort_fc_service)(struct fc_service *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 	u32	 			dd_fcvport_size;
@@ -732,6 +869,33 @@ fc_vport_set_state(struct fc_vport *vport, enum fc_vport_state new_state)
 	vport->vport_state = new_state;
 }
 
+static inline struct fc_service *
+fc_alloc_service(void)
+{
+	struct fc_service *service =
+	    kmem_cache_zalloc(fc_service_cache, GFP_KERNEL);
+
+	if (!service)
+		return NULL;
+
+	INIT_LIST_HEAD(&service->list);
+	spin_lock_init(&service->service_state_lock);
+	service->service_state_flags = FC_SERVICE_STATE_PENDING;
+	init_timer(&service->timer);
+	init_completion(&service->completion);
+
+	return service;
+}
+
+static inline void
+fc_free_service(struct fc_service *service)
+{
+	if (service) {
+		BUG_ON(!list_empty(&service->list));
+		kmem_cache_free(fc_service_cache, service);
+	}
+}
+
 
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);

--Apple-Mail-4--475938107
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-4--475938107--
