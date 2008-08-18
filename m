From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Mon, 18 Aug 2008 12:04:21 -0700
Message-ID: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:31186 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762604AbYHRTEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2008 15:04:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Robert W Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

This is a patch for the FC transport in an effort to support pass  
through services based on previous discussion as below,
http://marc.info/?t=121569558300005&r=1&w=2

Following are remarks for the changes,
- the SMP in the SAS transport has referenced, so the layout of the  
changes are quite similar to it
- at this stage, the ELS/CT service packet serviced one at a time,  
synchronously
- there is dedicated handler in the LLDD for ELS and CT, respectively
- the sense data area of the 'request' structure will hold service reply
- device files are created in following directories for each of  
discovered initiator/targets,
	= /sys/class/bsg/rport-<host_no>:<bus>-<id>
	= /dev/rport-<host_no>:<bus>-<id>

And following are to-dos,
- abort mechanism
- asynchronous packet handling
- detailing error handling, etc.

The patch has created against scsi-misc.
With this patch, qla2xxx is under testing for the feature.

Thank you,
Seokmann
---
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index 56823fd..44f6a9e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -40,6 +40,7 @@

  static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
  static void fc_vport_sched_delete(struct work_struct *work);
+static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);

  /*
   * This is a temporary carrier for creating a vport. It will  
eventually
@@ -67,6 +68,12 @@ struct fc_vport_identifiers {
  static int fc_vport_create(struct Scsi_Host *shost, int channel,
  	struct device *pdev, struct fc_vport_identifiers  *ids,
  	struct fc_vport **vport);
+static void fc_service_timedout(unsigned long);
+static void fc_service_done(struct fc_service *);
+static int
+fc_service_handler(struct Scsi_Host *, struct fc_rport *, struct  
request *);
+
+struct kmem_cache *fc_service_cache;

  /*
   * Redefine so that we can have same named attributes in the
@@ -666,6 +673,11 @@ static __init int fc_transport_init(void)
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

@@ -675,6 +687,7 @@ static void __exit fc_transport_exit(void)
  	transport_class_unregister(&fc_rport_class);
  	transport_class_unregister(&fc_host_class);
  	transport_class_unregister(&fc_vport_class);
+	kmem_cache_destroy(fc_service_cache);
  }

  /*
@@ -2081,6 +2094,9 @@ fc_attach_transport(struct fc_function_template  
*ft)

  	i->f = ft;

+	/* for FC services (FC-CT, ELS, etc.) */
+	i->f->fc_service_handler = fc_service_handler;
+
  	/* Transport uses the shost workq for scsi scanning */
  	i->t.create_work_queue = 1;

@@ -2430,12 +2446,234 @@ fc_rport_final_delete(struct work_struct *work)

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
+	if (!del_timer(&service->timer))
+		return;
+	complete (&service->completion);
+}
+
+static int
+issue_fc_service(struct fc_rport *rport, void *req, int req_size,
+    void *resp, int resp_size, void *service_reply)
+{
+	int res, retry;
+	struct fc_service *service = NULL;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_frame_header *frame = req;
+
+	if ((frame->fh_type == FC_FRAME_TYPE_ELS) ||
+	    (frame->fh_type == FC_FRAME_TYPE_FC_CT))
+		service->service_type = frame->fh_type;
+	else {
+		printk(KERN_ERR "invalid FC service type = %2x\n",
+		    frame->fh_type);
+		return -EINVAL;
+	}
+
+	service = fc_alloc_service(GFP_KERNEL);
+	if (!service)
+		return -ENOMEM;
+
+	service->ct_frame = (struct fc_ct_frame *) req;
+	service->req_size = req_size;
+	service->response = resp;
+	service->resp_size = resp_size;
+	service->rport = rport;
+	/* sense area of the request structure */
+	service->reply = service_reply;
+	service->service_done = fc_service_done;
+
+	service->timer.data = (unsigned long) service;
+	service->timer.function = fc_service_timedout;
+	service->timer.expires = jiffies + FC_SERVICE_TIMEOUT*HZ;
+
+	add_timer(&service->timer);
+
+	if (service->service_type == FC_FRAME_TYPE_ELS)
+		res = i->f->execute_fc_els_service(service);
+	else if (service->service_type == FC_FRAME_TYPE_FC_CT)
+		res = i->f->execute_fc_ct_service(service);
+	else
+		printk(KERN_WARNING "%s: ERROR: invalid "
+		    "FC service type = %2x\n", __func__,
+		    service->service_type);
+
+	if (res) {
+		del_timer(&service->timer);
+		printk(KERN_ERR "executing FC service failed:%d\n", res);
+		goto ex_err;
+	}
+
+	wait_for_completion(&service->completion);
+
+	res = -ECOMM;
+	if ((service->service_state_flags & FC_SERVICE_STATE_ABORTED)) {
+		printk(KERN_ERR "FC service timed out or aborted\n");
+		i->f->abort_fc_service(service);
+		if (!(service->service_state_flags &
+		     FC_SERVICE_STATE_DONE)) {
+			printk(KERN_ERR "FC service aborted and not done\n");
+			goto ex_err;
+		}
+	}
+	if (service->service_status.resp == FC_SERVICE_COMPLETE)
+		res = 0;
+	else {
+		printk(KERN_ERR "%s: FC service to rport %p"
+		    " response: 0x%x", __func__, rport,
+		    service->service_status.resp);
+		fc_free_service(service);
+		service = NULL;
+	}
+ex_err:
+	BUG_ON(retry == 3 && service != NULL);
+	if (service != NULL) {
+		fc_free_service(service);
+	}
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
+		printk("%s: space for a FC service response is missing\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	/* do we need to support multiple segments? */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk("%s: multiple segments req %u %u, rsp %u %u\n",
+		       __func__, req->bio->bi_vcnt, req->data_len,
+		       rsp->bio->bi_vcnt, rsp->data_len);
+		return -EINVAL;
+	}
+
+	ret = issue_fc_service(rport, bio_data(req->bio), req->data_len,
+			       bio_data(rsp->bio), rsp->data_len, req->sense);
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
+
+		spin_unlock_irq(q->queue_lock);
+
+		handler = to_fc_internal(shost->transportt)->f->fc_service_handler;
+		if (handler)
+			req->errors = handler(shost, rport, req);
+
+		spin_lock_irq(q->queue_lock);
+
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
+	if (!to_fc_internal(shost->transportt)->f->fc_service_handler) {
+		printk("%s can't handle FC service requests\n", shost->hostt->name);
+		return 0;
+	}
+
+	if (!rport) {
+		printk(KERN_WARNING " ERROR: rport is NULL\n");
+		return -ENOMEM;
+	}
+
+	q = blk_init_queue(fc_service_request, NULL);
+	dev = &rport->dev;
+	name = dev->bus_id;
+	release = NULL;
+
+	if (!q)
+		return -ENOMEM;
+
+	error = bsg_register_queue(q, dev, name, release);
+	if (error) {
+		blk_cleanup_queue(q);
+		return -ENOMEM;
+	}
+
+	rport->q = q;
+
+	q->queuedata = rport;
+
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
+	if (!q) {
+		printk(KERN_WARNING "%s: ERROR: invalid queue\n",
+		    __func__);
+		return;
+	}
+
+	bsg_unregister_queue(q);
+}
+
  /**
   * fc_rport_create - allocates and creates a remote FC port.
   * @shost:	scsi host the remote port is connected to.
@@ -2495,6 +2733,7 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	else
  		rport->scsi_target_id = -1;
  	list_add_tail(&rport->peers, &fc_host->rports);
+
  	get_device(&shost->shost_gendev);	/* for fc_host->rport list */

  	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2515,6 +2754,9 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	transport_add_device(dev);
  	transport_configure_device(dev);

+	if (fc_bsg_initialize(shost, rport))
+		printk("fail to a bsg device %s\n", rport->dev.bus_id);
+
  	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
  		/* initiate a scan of the target */
  		rport->flags |= FC_RPORT_SCAN_PENDING;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/ 
scsi_transport_fc.h
index 878373c..f54e067 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -32,7 +32,7 @@
  #include <scsi/scsi_netlink.h>

  struct scsi_transport_template;
-
+extern struct kmem_cache *fc_service_cache;

  /*
   * FC Port definitions - Following FC HBAAPI guidelines
@@ -333,6 +333,8 @@ struct fc_rport {	/* aka fc_starget_attrs */
   	struct delayed_work fail_io_work;
   	struct work_struct stgt_delete_work;
  	struct work_struct rport_delete_work;
+	
+	struct request_queue *q;
  } __attribute__((aligned(sizeof(unsigned long))));

  /* bit field values for struct fc_rport "flags" field: */
@@ -495,6 +497,129 @@ struct fc_host_attrs {
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
+	FC_SERVICE_UNDELIVERED = -1,
+};
+
+#define FC_SERVICE_STATE_PENDING      1
+#define FC_SERVICE_STATE_DONE         2
+#define FC_SERVICE_STATE_ABORTED      4
+#define FC_SERVICE_AT_INITIATOR       16
+
+struct fc_service_status {
+	enum service_response resp;
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
+struct fc_ct_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_ct_hdr ct_hdr;
+	u32 ct_cmd[1];
+};
+
+struct fc_els_frame {
+	struct fc_frame_header fc_hdr;
+	struct fc_els_hdr els_hdr;
+	u32 els_cmd[4];
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
+	struct fc_service_status service_status;
+	void *reply;   /* pointer to sense area of request */
+	void   (*service_done)(struct fc_service *);
+
+	struct work_struct abort_work;
+};
+
  #define shost_to_fc_host(x) \
  	((struct fc_host_attrs *)(x)->shost_data)

@@ -593,6 +718,14 @@ struct fc_function_template {
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
@@ -713,6 +846,31 @@ fc_vport_set_state(struct fc_vport *vport, enum  
fc_vport_state new_state)
  	vport->vport_state = new_state;
  }

+static inline struct fc_service *
+fc_alloc_service(gfp_t flags)
+{
+	struct fc_service *service = kmem_cache_zalloc(fc_service_cache,  
flags);
+
+	if (service) {
+		INIT_LIST_HEAD(&service->list);
+		spin_lock_init(&service->service_state_lock);
+		service->service_state_flags = FC_SERVICE_STATE_PENDING;
+		init_timer(&service->timer);
+		init_completion(&service->completion);
+	}
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
