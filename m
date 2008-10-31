From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 1/2] FC pass through support - revised III
Date: Fri, 31 Oct 2008 08:34:35 -0700
Message-ID: <6026BA47-0809-4AE1-9565-82F2453349B0@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-55-199455961
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41068 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYJaPei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Oct 2008 11:34:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>


--Apple-Mail-55-199455961
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Attachment is also available at the bottom.
---
 From 47f113766853dcabec329013fd1c2eb9e04f8c92 Mon Sep 17 00:00:00 2001
From: root <root@linux-atl-00.qlogic.com>
Date: Fri, 31 Oct 2008 08:13:15 -0700
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
  drivers/scsi/scsi_transport_fc.c |  212 +++++++++++++++++++++++++++++ 
++++++++-
  include/scsi/scsi_transport_fc.h |   79 ++++++++++++++-
  2 files changed, 288 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index 1e71abf..a0c1430 100644
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
@@ -2413,11 +2418,214 @@ fc_rport_final_delete(struct work_struct *work)

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
+
+	blk_end_bidi_request(service->req,
+	    service->srv_reply.status ? -EIO : 0, blk_rq_bytes(service->req),
+	    service->req->next_rq ? blk_rq_bytes(service->req->next_rq) : 0);
+
+	kfree(service->sg_req);
+	kfree(service->sg_rsp);
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
+	service = kzalloc(sizeof(struct fc_service), GFP_KERNEL);
+	if (!service)
+		return -ENOMEM;
+
+	req->special = service;
+	service->rport = rport;
+	service->req = req;
+	service->q = q;
+	service->srv_request = srv_request;
+
+	service->sg_req =
+	    kzalloc(sizeof(struct scatterlist) * req->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->sg_req, req->nr_phys_segments);
+	service->req_sg_cnt =
+	    blk_rq_map_sg(q, req, service->sg_req);
+	service->req_size = req->data_len;
+
+	service->sg_rsp =
+	    kzalloc(sizeof(struct scatterlist) * rsp->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->sg_rsp, rsp->nr_phys_segments);
+	service->rsp_sg_cnt =
+	    blk_rq_map_sg(q, rsp, service->sg_rsp);
+	service->rsp_size = rsp->data_len;
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
@@ -2478,8 +2686,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
channel,
  	else
  		rport->scsi_target_id = -1;
  	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */

+	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
  	spin_unlock_irqrestore(shost->host_lock, flags);

  	dev = &rport->dev;
@@ -2498,6 +2706,8 @@ fc_rport_create(struct Scsi_Host *shost, int  
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
index 49d8913..8367d48 100644
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
@@ -515,6 +515,78 @@ struct fc_host_attrs {
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
+	u8   reserved0;
+	u8   reserved1;
+	u8   reserved2;
+	u32  reserved3[3];
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
+
+	struct fc_service_request *srv_request;
+	struct scatterlist *sg_req;
+	int   req_sg_cnt;
+	int   req_size;
+	struct scatterlist *sg_rsp;
+	int   rsp_sg_cnt;
+	int   rsp_size;
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

@@ -613,6 +685,10 @@ struct fc_function_template {
  	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
  	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);

+	/* fc service handler */
+	int	(*execute_fc_service)(struct fc_service *);
+	int	(*abort_fc_service)(struct fc_service *);
+
  	/* allocation lengths for host-specific data */
  	u32	 			dd_fcrport_size;
  	u32	 			dd_fcvport_size;
@@ -736,7 +812,6 @@ fc_vport_set_state(struct fc_vport *vport, enum  
fc_vport_state new_state)
  	vport->vport_state = new_state;
  }

-
  struct scsi_transport_template *fc_attach_transport(
  			struct fc_function_template *);
  void fc_release_transport(struct scsi_transport_template *);
-- 
1.6.0.2


--Apple-Mail-55-199455961
Content-Disposition: attachment;
	filename=0001-scsi_transport_fc-FC-pass-through-support.patch
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="0001-scsi_transport_fc-FC-pass-through-support.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2047f113766853dcabec329013fd1c2eb9e04f8c92=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20root=20<root@linux-atl-00.qlogic.com>=0ADate:=20=
Fri,=2031=20Oct=202008=2008:13:15=20-0700=0ASubject:=20[PATCH]=20=
scsi_transport_fc:=20FC=20pass=20through=20support=0A=0AThis=20patch=20=
will=20add=20FC=20pass=20through=20support.=0AThe=20FC=20pass=20through=20=
support=20is=20service=20request=20handling=20mechanism=0Afor=20FC=20=
specification=20defined=20services=20including,=0A-=20Link=20Services=20=
(Basic=20LS,=20Extended=20LS)=0A-=20Generic=20Services=20(FC-CT=20-=20=
Common=20Transport)=0AThe=20support=20utilize=20BSG=20(Block=20layer=20=
SCSI=20Generic)=20interface=20with=0Abidi=20(bi-directional)=20nature=20=
in=20handling=20the=20service=20requests.=0A=0AThis=20patch=20added=20=
following=20featues=20in=20the=20support=0A-=20FC=20service=20structure=20=
has=20defined=20to=20transport=20service=20requests=0A-=20Handles=20the=20=
service=20request=20in=20asynchronous=20manner=20-=20LLD=0A-=20Timeout=20=
capability=0A-=20Abort=20capability=0A=0ASigned-off-by:=20Seokmann=20Ju=20=
<seokmann.ju@qlogic.com>=0A---=0A=20drivers/scsi/scsi_transport_fc.c=20|=20=
=20212=20+++++++++++++++++++++++++++++++++++++-=0A=20=
include/scsi/scsi_transport_fc.h=20|=20=20=2079=20++++++++++++++-=0A=202=20=
files=20changed,=20288=20insertions(+),=203=20deletions(-)=0A=0Adiff=20=
--git=20a/drivers/scsi/scsi_transport_fc.c=20=
b/drivers/scsi/scsi_transport_fc.c=0Aindex=201e71abf..a0c1430=20100644=0A=
---=20a/drivers/scsi/scsi_transport_fc.c=0A+++=20=
b/drivers/scsi/scsi_transport_fc.c=0A@@=20-43,6=20+43,11=20@@=20static=20=
void=20fc_vport_sched_delete(struct=20work_struct=20*work);=0A=20static=20=
int=20fc_vport_setup(struct=20Scsi_Host=20*shost,=20int=20channel,=0A=20=09=
struct=20device=20*pdev,=20struct=20fc_vport_identifiers=20=20*ids,=0A=20=
=09struct=20fc_vport=20**vport);=0A+static=20enum=20blk_eh_timer_return=20=
fc_service_timeout(struct=20request=20*req);=0A+static=20void=20=
fc_service_done(struct=20fc_service=20*);=0A+static=20int=20=
fc_service_handler(struct=20Scsi_Host=20*,=20struct=20fc_rport=20*,=0A+=20=
=20=20=20struct=20request=20*,=20struct=20request_queue=20*);=0A+static=20=
void=20fc_bsg_remove(struct=20Scsi_Host=20*,=20struct=20fc_rport=20*);=0A=
=20=0A=20/*=0A=20=20*=20Redefine=20so=20that=20we=20can=20have=20same=20=
named=20attributes=20in=20the=0A@@=20-2413,11=20+2418,214=20@@=20=
fc_rport_final_delete(struct=20work_struct=20*work)=0A=20=0A=20=09=
transport_remove_device(dev);=0A=20=09device_del(dev);=0A+=09=
fc_bsg_remove(shost,=20rport);=0A=20=09transport_destroy_device(dev);=0A=20=
=09put_device(&shost->shost_gendev);=09/*=20for=20fc_host->rport=20list=20=
*/=0A=20=09put_device(dev);=09=09=09/*=20for=20self-reference=20*/=0A=20=
}=0A=20=0A+static=20enum=20blk_eh_timer_return=20=
fc_service_timeout(struct=20request=20*req)=0A+{=0A+=09struct=20=
fc_service=20*service=20=3D=20(void=20*)=20req->special;=0A+=09struct=20=
Scsi_Host=20*shost=20=3D=20rport_to_shost(service->rport);=0A+=09struct=20=
fc_internal=20*i=20=3D=20to_fc_internal(shost->transportt);=0A+=09=
unsigned=20long=20flags;=0A+=09int=20res=20=3D=200;=0A+=0A+=09if=20=
(service->rport->port_state=20=3D=3D=20FC_PORTSTATE_BLOCKED)=0A+=09=09=
return=20BLK_EH_RESET_TIMER;=0A+=0A+=09=
spin_lock_irqsave(&service->service_state_lock,=20flags);=0A+=09if=20=
(!(service->service_state_flag=20&=20FC_SERVICE_STATE_DONE))=0A+=09=09=
service->service_state_flag=20|=3D=20FC_SERVICE_STATE_TIMEOUT;=0A+=09=
spin_unlock_irqrestore(&service->service_state_lock,=20flags);=0A+=0A+=09=
if=20(i->f->abort_fc_service)=0A+=09=09res=20=3D=20=
i->f->abort_fc_service(service);=0A+=0A+=09if=20(res)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20issuing=20FC=20service=20to=20the=20LLD=20"=0A=
+=09=09"failed=20with=20status=20%d\n",=20res);=0A+=09=09=
fc_service_done(service);=0A+=09}=0A+=0A+=09/*=20the=20blk_end_sync_io()=20=
doesn't=20check=20the=20error=20*/=0A+=09return=20BLK_EH_NOT_HANDLED;=0A=
+}=0A+=0A+static=20void=20fc_service_done(struct=20fc_service=20=
*service)=0A+{=0A+=0A+=09if=20(service->service_state_flag=20!=3D=20=
FC_SERVICE_STATE_DONE)=20{=0A+=09=09if=20(service->service_state_flag=20=
=3D=3D=20FC_SERVICE_STATE_TIMEOUT)=0A+=09=09=09printk(KERN_ERR=20"ERROR:=20=
FC=20service=20timed=20out\n");=0A+=09=09else=20if=20=
(service->service_state_flag=20=3D=3D=0A+=09=09=20=20=20=20=
FC_SERVICE_STATE_ABORTED)=0A+=09=09=09printk(KERN_ERR=20"ERROR:=20FC=20=
service=20aborted\n");=0A+=09=09else=0A+=09=09=09printk(KERN_ERR=20=
"ERROR:=20FC=20service=20not=20finished\n");=0A+=09}=0A+=0A+=09if=20=
(service->srv_reply.status=20!=3D=20FC_SERVICE_COMPLETE)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20FC=20service=20to=20rport=20%p=20failed=20=
with"=0A+=09=09=20=20=20=20"=20status=200x%x\n",=20service->rport,=0A+=09=
=09=20=20=20=20service->srv_reply.status);=0A+=09}=0A+=0A+=09=
service->req->errors=20=3D=20service->srv_reply.status;=0A+=0A+=09=
blk_end_bidi_request(service->req,=0A+=09=20=20=20=20=
service->srv_reply.status=20?=20-EIO=20:=200,=20=
blk_rq_bytes(service->req),=0A+=09=20=20=20=20service->req->next_rq=20?=20=
blk_rq_bytes(service->req->next_rq)=20:=200);=0A+=0A+=09=
kfree(service->sg_req);=0A+=09kfree(service->sg_rsp);=0A+=09=
kfree(service);=0A+}=0A+=0A+static=20int=0A+issue_fc_service(struct=20=
fc_rport=20*rport,=20struct=20request=20*req,=0A+=20=20=20=20struct=20=
request=20*rsp,=20struct=20request_queue=20*q)=0A+{=0A+=09int=20res=20=3D=20=
-ECOMM;=0A+=09struct=20fc_service=20*service;=0A+=09struct=20Scsi_Host=20=
*shost=20=3D=20rport_to_shost(rport);=0A+=09struct=20fc_internal=20*i=20=
=3D=20to_fc_internal(shost->transportt);=0A+=09struct=20=
fc_service_request=20*srv_request=20=3D=20(struct=20fc_service_request=20=
*)=0A+=09=20=20=20=20req->cmd;=0A+=0A+=09service=20=3D=20=
kzalloc(sizeof(struct=20fc_service),=20GFP_KERNEL);=0A+=09if=20=
(!service)=0A+=09=09return=20-ENOMEM;=0A+=0A+=09req->special=20=3D=20=
service;=0A+=09service->rport=20=3D=20rport;=0A+=09service->req=20=3D=20=
req;=0A+=09service->q=20=3D=20q;=0A+=09service->srv_request=20=3D=20=
srv_request;=0A+=0A+=09service->sg_req=20=3D=0A+=09=20=20=20=20=
kzalloc(sizeof(struct=20scatterlist)=20*=20req->nr_phys_segments,=0A+=09=20=
=20=20=20GFP_KERNEL);=0A+=09sg_init_table(service->sg_req,=20=
req->nr_phys_segments);=0A+=09service->req_sg_cnt=20=3D=0A+=09=20=20=20=20=
blk_rq_map_sg(q,=20req,=20service->sg_req);=0A+=09service->req_size=20=3D=20=
req->data_len;=0A+=0A+=09service->sg_rsp=20=3D=0A+=09=20=20=20=20=
kzalloc(sizeof(struct=20scatterlist)=20*=20rsp->nr_phys_segments,=0A+=09=20=
=20=20=20GFP_KERNEL);=0A+=09sg_init_table(service->sg_rsp,=20=
rsp->nr_phys_segments);=0A+=09service->rsp_sg_cnt=20=3D=0A+=09=20=20=20=20=
blk_rq_map_sg(q,=20rsp,=20service->sg_rsp);=0A+=09service->rsp_size=20=3D=20=
rsp->data_len;=0A+=0A+=09/*=20sense=20area=20of=20the=20request=20=
structure=20*/=0A+=09service->reply_seq=20=3D=20req->sense;=0A+=09=
service->service_done=20=3D=20fc_service_done;=0A+=09=
service->service_state_flag=20=3D=20FC_SERVICE_STATE_PENDING;=0A+=0A+=09=
if=20(i->f->execute_fc_service)=0A+=09=09res=20=3D=20=
i->f->execute_fc_service(service);=0A+=0A+=09if=20(res)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20issuing=20FC=20service=20to=20the=20LLD=20"=0A=
+=09=09"failed=20with=20status=20%d\n",=20res);=0A+=09=09=
fc_service_done(service);=0A+=09=09return=20res;=0A+=09}=0A+=0A+=09=
return=200;=0A+}=0A+=0A+static=20int=0A+fc_service_handler(struct=20=
Scsi_Host=20*shost,=20struct=20fc_rport=20*rport,=0A+=09=09=09=20=20=
struct=20request=20*req,=20struct=20request_queue=20*q)=0A+{=0A+=09int=20=
ret;=0A+=09struct=20request=20*rsp=20=3D=20req->next_rq;=0A+=0A+=09if=20=
(!rsp)=20{=0A+=09=09printk(KERN_ERR=20"ERROR:=20space=20for=20a=20FC=20=
service"=0A+=09=09=20=20=20"=20response=20is=20missing\n");=0A+=09=09=
return=20-EINVAL;=0A+=09}=0A+=0A+=09ret=20=3D=20issue_fc_service(rport,=20=
req,=20rsp,=20q);=0A+=0A+=09return=20ret;=0A+}=0A+=0A+static=20void=20=
fc_service_dispatch(struct=20request_queue=20*q)=0A+{=0A+=09struct=20=
request=20*req;=0A+=09struct=20fc_rport=20*rport=20=3D=20q->queuedata;=0A=
+=09struct=20Scsi_Host=20*shost=20=3D=20rport_to_shost(rport);=0A+=0A+=09=
while=20(!blk_queue_plugged(q))=20{=0A+=09=09req=20=3D=20=
elv_next_request(q);=0A+=09=09if=20(!req)=0A+=09=09=09break;=0A+=0A+=09=09=
blkdev_dequeue_request(req);=0A+=09=09spin_unlock_irq(q->queue_lock);=0A=
+=0A+=09=09fc_service_handler(shost,=20rport,=20req,=20q);=0A+=0A+=09=09=
spin_lock_irq(q->queue_lock);=0A+=09}=0A+}=0A+=0A+static=20int=0A=
+fc_bsg_initialize(struct=20Scsi_Host=20*shost,=20struct=20fc_rport=20=
*rport)=0A+{=0A+=09struct=20request_queue=20*q;=0A+=09int=20error;=0A+=09=
struct=20device=20*dev;=0A+=09const=20char=20*name;=0A+=09void=20=
(*release)(struct=20device=20*);=0A+=0A+=09if=20(!rport)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20rport=20is=20NULL\n");=0A+=09=09return=20=
-ENOMEM;=0A+=09}=0A+=0A+=09q=20=3D=20blk_init_queue(fc_service_dispatch,=20=
NULL);=0A+=09if=20(!q)=0A+=09=09return=20-ENOMEM;=0A+=0A+=09dev=20=3D=20=
&rport->dev;=0A+=09name=20=3D=20dev->bus_id;=0A+=09release=20=3D=20NULL;=0A=
+=0A+=09error=20=3D=20bsg_register_queue(q,=20dev,=20name,=20release);=0A=
+=09if=20(error)=20{=0A+=09=09blk_cleanup_queue(q);=0A+=09=09return=20=
-ENOMEM;=0A+=09}=0A+=0A+=09blk_queue_max_hw_segments(q,=20=
shost->sg_tablesize);=0A+=09blk_queue_max_phys_segments(q,=20=
SCSI_MAX_SG_CHAIN_SEGMENTS);=0A+=09blk_queue_rq_timed_out(q,=20=
fc_service_timeout);=0A+=09blk_queue_rq_timeout(q,=20=
BLK_DEFAULT_SG_TIMEOUT);=0A+=0A+=09rport->q=20=3D=20q;=0A+=09=
q->queuedata=20=3D=20rport;=0A+=09=
queue_flag_set_unlocked(QUEUE_FLAG_BIDI,=20q);=0A+=0A+=09return=200;=0A=
+}=0A+=0A+static=20void=0A+fc_bsg_remove(struct=20Scsi_Host=20*shost,=20=
struct=20fc_rport=20*rport)=0A+{=0A+=09struct=20request_queue=20*q=20=3D=20=
rport->q;=0A+=0A+=09if=20(!q)=0A+=09=09return;=0A+=0A+=09=
bsg_unregister_queue(q);=0A+}=0A=20=0A=20/**=0A=20=20*=20fc_rport_create=20=
-=20allocates=20and=20creates=20a=20remote=20FC=20port.=0A@@=20-2478,8=20=
+2686,8=20@@=20fc_rport_create(struct=20Scsi_Host=20*shost,=20int=20=
channel,=0A=20=09else=0A=20=09=09rport->scsi_target_id=20=3D=20-1;=0A=20=09=
list_add_tail(&rport->peers,=20&fc_host->rports);=0A-=09=
get_device(&shost->shost_gendev);=09/*=20for=20fc_host->rport=20list=20=
*/=0A=20=0A+=09get_device(&shost->shost_gendev);=09/*=20for=20=
fc_host->rport=20list=20*/=0A=20=09=
spin_unlock_irqrestore(shost->host_lock,=20flags);=0A=20=0A=20=09dev=20=3D=
=20&rport->dev;=0A@@=20-2498,6=20+2706,8=20@@=20fc_rport_create(struct=20=
Scsi_Host=20*shost,=20int=20channel,=0A=20=09transport_add_device(dev);=0A=
=20=09transport_configure_device(dev);=0A=20=0A+=09=
fc_bsg_initialize(shost,=20rport);=0A+=0A=20=09if=20(rport->roles=20&=20=
FC_PORT_ROLE_FCP_TARGET)=20{=0A=20=09=09/*=20initiate=20a=20scan=20of=20=
the=20target=20*/=0A=20=09=09rport->flags=20|=3D=20=
FC_RPORT_SCAN_PENDING;=0Adiff=20--git=20=
a/include/scsi/scsi_transport_fc.h=20b/include/scsi/scsi_transport_fc.h=0A=
index=2049d8913..8367d48=20100644=0A---=20=
a/include/scsi/scsi_transport_fc.h=0A+++=20=
b/include/scsi/scsi_transport_fc.h=0A@@=20-33,7=20+33,6=20@@=0A=20=0A=20=
struct=20scsi_transport_template;=0A=20=0A-=0A=20/*=0A=20=20*=20FC=20=
Port=20definitions=20-=20Following=20FC=20HBAAPI=20guidelines=0A=20=20*=0A=
@@=20-352,6=20+351,7=20@@=20struct=20fc_rport=20{=09/*=20aka=20=
fc_starget_attrs=20*/=0A=20=20=09struct=20delayed_work=20fail_io_work;=0A=
=20=20=09struct=20work_struct=20stgt_delete_work;=0A=20=09struct=20=
work_struct=20rport_delete_work;=0A+=09struct=20request_queue=20*q;=0A=20=
}=20__attribute__((aligned(sizeof(unsigned=20long))));=0A=20=0A=20/*=20=
bit=20field=20values=20for=20struct=20fc_rport=20"flags"=20field:=20*/=0A=
@@=20-515,6=20+515,78=20@@=20struct=20fc_host_attrs=20{=0A=20=09struct=20=
workqueue_struct=20*devloss_work_q;=0A=20};=0A=20=0A+#define=20=
FC_STATUS_BUF_SIZE=2096=0A+=0A+enum=20fc_frame_type=20{=0A+=09=
FC_FRAME_TYPE_BS,=0A+=09FC_FRAME_TYPE_ELS,=0A+=09FC_FRAME_TYPE_IEC=20=3D=20=
4,=0A+=09FC_FRAME_TYPE_IP,=0A+=09FC_FRAME_TYPE_FCP=20=3D=208,=0A+=09=
FC_FRAME_TYPE_GPP,=0A+=09FC_FRAME_TYPE_FC_CT=20=3D=200x20,=0A+};=0A+=0A=
+enum=20fc_service_status=20{=0A+=09FC_SERVICE_COMPLETE,=0A+=09=
FC_SERVICE_TIMEOUT,=0A+=09FC_SERVICE_ABORT,=0A+=09=
FC_SERVICE_UNSUPPORTED,=0A+=09FC_SERVICE_ERROR=20=3D=20-1,=0A+};=0A+=0A=
+#define=20FC_SERVICE_STATE_PENDING=20=20=20=20=20=201=0A+#define=20=
FC_SERVICE_STATE_DONE=20=20=20=20=20=20=20=20=202=0A+#define=20=
FC_SERVICE_STATE_ABORTED=20=20=20=20=20=204=0A+#define=20=
FC_SERVICE_STATE_TIMEOUT=20=20=20=20=20=208=0A+=0A+#define=20=
FC_SERVICE_TIMEOUT=2010=0A+=0A+/*=20request=20(CDB)=20structure=20of=20=
the=20sg_io_v4=20*/=0A+struct=20fc_service_request=20{=0A+=09u8=20=20=20=
request_type;=0A+=09u8=20=20=20reserved0;=0A+=09u8=20=20=20reserved1;=0A=
+=09u8=20=20=20reserved2;=0A+=09u32=20=20reserved3[3];=0A+};=0A+=0A+/*=20=
response=20=20(request=20sense=20data)=20structure=20of=20the=20sg_io_v4=20=
*/=0A+struct=20fc_service_reply=20{=0A+=09enum=20fc_service_status=20=
status;=0A+=09u16=20=20error_code;=0A+=09u16=20=20additional_error_code;=0A=
+=09u32=20=20residual;=0A+};=0A+=0A+struct=20fc_service=20{=0A+=09struct=20=
fc_rport=20=20*rport;=0A+=09struct=20list_head=20list;=0A+=0A+=09=
spinlock_t=20=20=20service_state_lock;=0A+=09unsigned=20=20=20=20=20=
service_state_flag;=0A+=0A+=09struct=20request=20*req;=0A+=09struct=20=
request_queue=20*q;=0A+=0A+=09/*=20Used=20by=20the=20discovery=20code.=20=
*/=0A+=09struct=20completion=20=20completion;=0A+=0A+=09struct=20=
fc_service_request=20*srv_request;=0A+=09struct=20scatterlist=20*sg_req;=0A=
+=09int=20=20=20req_sg_cnt;=0A+=09int=20=20=20req_size;=0A+=09struct=20=
scatterlist=20*sg_rsp;=0A+=09int=20=20=20rsp_sg_cnt;=0A+=09int=20=20=20=
rsp_size;=0A+=0A+=09struct=20fc_service_reply=20srv_reply;=0A+=09void=20=20=
*reply_seq;=20=20=20/*=20pointer=20to=20sense=20area=20of=20request=20*/=0A=
+=09void=20=20(*service_done)(struct=20fc_service=20*);=0A+=0A+=09void=20=
*lld_pkt;=0A+};=0A+=0A=20#define=20shost_to_fc_host(x)=20\=0A=20=09=
((struct=20fc_host_attrs=20*)(x)->shost_data)=0A=20=0A@@=20-613,6=20=
+685,10=20@@=20struct=20fc_function_template=20{=0A=20=09int=20=20=20=20=20=
(*=20tsk_mgmt_response)(struct=20Scsi_Host=20*,=20u64,=20u64,=20int);=0A=20=
=09int=20=20=20=20=20(*=20it_nexus_response)(struct=20Scsi_Host=20*,=20=
u64,=20int);=0A=20=0A+=09/*=20fc=20service=20handler=20*/=0A+=09int=09=
(*execute_fc_service)(struct=20fc_service=20*);=0A+=09int=09=
(*abort_fc_service)(struct=20fc_service=20*);=0A+=0A=20=09/*=20=
allocation=20lengths=20for=20host-specific=20data=20*/=0A=20=09u32=09=20=09=
=09=09dd_fcrport_size;=0A=20=09u32=09=20=09=09=09dd_fcvport_size;=0A@@=20=
-736,7=20+812,6=20@@=20fc_vport_set_state(struct=20fc_vport=20*vport,=20=
enum=20fc_vport_state=20new_state)=0A=20=09vport->vport_state=20=3D=20=
new_state;=0A=20}=0A=20=0A-=0A=20struct=20scsi_transport_template=20=
*fc_attach_transport(=0A=20=09=09=09struct=20fc_function_template=20*);=0A=
=20void=20fc_release_transport(struct=20scsi_transport_template=20*);=0A=
--=20=0A1.6.0.2=0A=0A=

--Apple-Mail-55-199455961--
