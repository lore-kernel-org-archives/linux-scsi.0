From: James Bottomley <JBottomley@Novell.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Date: Wed, 27 Jan 2010 11:51:30 -0600
Message-ID: <1264614691.3075.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755782Ab0A0Rvq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is just a few minor fixes ... the biggest are that the BSG device
will actually now work in compat (32 on 64 bit mode).  It had previously
failed because of structure packing and that aacraid has eliminated a
failure mode from management FIB use (which the raid status daemons
use).

The update is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Anatolij Gustschin (1):
      mptsas: Fix issue with chain pools allocation on katmai

Andrew Vasquez (2):
      qla2xxx: Perform fast mailbox read of flash regardless of size nor address alignment.
      qla2xxx: Correct FCP2 recovery handling.

Boaz Harrosh (1):
      scsi_lib: Fix bug in completion of bidi commands

Christof Schmitt (2):
      zfcp: Fix linebreak in hba trace
      zfcp: Issue zfcp_fc_wka_port_put after FC CT BSG request

Giridhar Malavali (1):
      qla2xxx: Update version number to 8.03.01-k10.

Hannes Reinecke (1):
      aic79xx: check for non-NULL scb in ahd_handle_nonpkt_busfree

Harish Zunjarrao (1):
      fc-transport: Use packed modifier for fc_bsg_request structure.

Heiko Carstens (1):
      zfcp: add missing compat ptr conversion

James Bottomley (1):
      lpfc: fix file permissions

Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
      aacraid: fix File System going into read-only mode

Swen Schillig (3):
      zfcp: Set hardware timeout as requested by BSG request.
      zfcp: Introduce bsg_timeout callback.
      scsi_transport_fc: Allow LLD to reset FC BSG timeout

The diffstat:

 drivers/message/fusion/mptbase.c    |    2 
 drivers/s390/scsi/zfcp_cfdc.c       |    9 +++
 drivers/s390/scsi/zfcp_dbf.c        |    2 
 drivers/s390/scsi/zfcp_ext.h        |    5 +-
 drivers/s390/scsi/zfcp_fc.c         |   84 ++++++++++++++++++++++++------------
 drivers/s390/scsi/zfcp_fc.h         |    2 
 drivers/s390/scsi/zfcp_fsf.c        |   19 ++++----
 drivers/s390/scsi/zfcp_scsi.c       |    1 
 drivers/scsi/aacraid/aachba.c       |   52 +++++++++++++++++-----
 drivers/scsi/aacraid/aacraid.h      |    5 +-
 drivers/scsi/aacraid/commctrl.c     |   28 ++++++------
 drivers/scsi/aacraid/comminit.c     |    6 ++
 drivers/scsi/aacraid/commsup.c      |   72 ++++++++++++++++++++++++++----
 drivers/scsi/aacraid/dpcsup.c       |   36 ++++++++++++---
 drivers/scsi/aic7xxx/aic79xx_core.c |   53 +++++++++++++---------
 drivers/scsi/qla2xxx/qla_def.h      |    3 -
 drivers/scsi/qla2xxx/qla_init.c     |   12 ++---
 drivers/scsi/qla2xxx/qla_os.c       |   12 ++---
 drivers/scsi/qla2xxx/qla_sup.c      |    3 +
 drivers/scsi/qla2xxx/qla_version.h  |    2 
 drivers/scsi/scsi_lib.c             |    2 
 drivers/scsi/scsi_transport_fc.c    |    5 +-
 include/scsi/scsi_bsg_fc.h          |    2 
 23 files changed, 291 insertions(+), 126 deletions(-)

Full diff is below

James

---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 85bc6a6..44d2037 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4330,6 +4330,8 @@ initChainBuffers(MPT_ADAPTER *ioc)
 
 	if (ioc->bus_type == SPI)
 		num_chain *= MPT_SCSI_CAN_QUEUE;
+	else if (ioc->bus_type == SAS)
+		num_chain *= MPT_SAS_CAN_QUEUE;
 	else
 		num_chain *= MPT_FC_CAN_QUEUE;
 
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index f932400..0eb6eef 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include "zfcp_def.h"
 #include "zfcp_ext.h"
@@ -163,7 +164,7 @@ static void zfcp_cfdc_req_to_sense(struct zfcp_cfdc_data *data,
 }
 
 static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
-				unsigned long buffer)
+				unsigned long arg)
 {
 	struct zfcp_cfdc_data *data;
 	struct zfcp_cfdc_data __user *data_user;
@@ -175,7 +176,11 @@ static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
 	if (command != ZFCP_CFDC_IOC)
 		return -ENOTTY;
 
-	data_user = (void __user *) buffer;
+	if (is_compat_task())
+		data_user = compat_ptr(arg);
+	else
+		data_user = (void __user *)arg;
+
 	if (!data_user)
 		return -EINVAL;
 
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 8445095..7369c89 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -327,7 +327,7 @@ static void zfcp_dbf_hba_view_response(char **p,
 			break;
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
 		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
-		p += sprintf(*p, "\n");
+		*p += sprintf(*p, "\n");
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 03dec83..66bdb34 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -108,6 +108,7 @@ extern void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
+extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
@@ -129,9 +130,9 @@ extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *, struct zfcp_fsf_ct_els *,
-			    mempool_t *);
+			    mempool_t *, unsigned int);
 extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
-			     struct zfcp_fsf_ct_els *);
+			     struct zfcp_fsf_ct_els *, unsigned int);
 extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
 					  struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index ac5e3b7..0f7b493 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -258,7 +258,8 @@ static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
 	gid_pn->gid_pn_req.gid_pn.fn_wwpn = port->wwpn;
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &gid_pn->ct,
-			       adapter->pool.gid_pn_req);
+			       adapter->pool.gid_pn_req,
+			       ZFCP_FC_CTELS_TMO);
 	if (!ret) {
 		wait_for_completion(&completion);
 		zfcp_fc_ns_gid_pn_eval(gid_pn);
@@ -421,7 +422,8 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	hton24(adisc->adisc_req.adisc_port_id,
 	       fc_host_port_id(adapter->scsi_host));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els);
+	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els,
+				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_data.adisc_cache, adisc);
 
@@ -532,7 +534,8 @@ static int zfcp_fc_send_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
 
-	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL);
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL,
+			       ZFCP_FC_CTELS_TMO);
 	if (!ret)
 		wait_for_completion(&completion);
 	return ret;
@@ -677,6 +680,44 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	job->job_done(job);
 }
 
+static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
+{
+	u32 preamble_word1;
+	u8 gs_type;
+	struct zfcp_adapter *adapter;
+
+	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	gs_type = (preamble_word1 & 0xff000000) >> 24;
+
+	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
+
+	switch (gs_type) {
+	case FC_FST_ALIAS:
+		return &adapter->gs->as;
+	case FC_FST_MGMT:
+		return &adapter->gs->ms;
+	case FC_FST_TIME:
+		return &adapter->gs->ts;
+		break;
+	case FC_FST_DIR:
+		return &adapter->gs->ds;
+		break;
+	default:
+		return NULL;
+	}
+}
+
+static void zfcp_fc_ct_job_handler(void *data)
+{
+	struct fc_bsg_job *job = data;
+	struct zfcp_fc_wka_port *wka_port;
+
+	wka_port = zfcp_fc_job_wka_port(job);
+	zfcp_fc_wka_port_put(wka_port);
+
+	zfcp_fc_ct_els_job_handler(data);
+}
+
 static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
@@ -695,43 +736,27 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 	} else
 		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
 
-	return zfcp_fsf_send_els(adapter, d_id, els);
+	els->handler = zfcp_fc_ct_els_job_handler;
+	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
 }
 
 static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
 			       struct zfcp_adapter *adapter)
 {
 	int ret;
-	u8 gs_type;
 	struct zfcp_fsf_ct_els *ct = job->dd_data;
 	struct zfcp_fc_wka_port *wka_port;
-	u32 preamble_word1;
 
-	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
-	gs_type = (preamble_word1 & 0xff000000) >> 24;
-
-	switch (gs_type) {
-	case FC_FST_ALIAS:
-		wka_port = &adapter->gs->as;
-		break;
-	case FC_FST_MGMT:
-		wka_port = &adapter->gs->ms;
-		break;
-	case FC_FST_TIME:
-		wka_port = &adapter->gs->ts;
-		break;
-	case FC_FST_DIR:
-		wka_port = &adapter->gs->ds;
-		break;
-	default:
-		return -EINVAL; /* no such service */
-	}
+	wka_port = zfcp_fc_job_wka_port(job);
+	if (!wka_port)
+		return -EINVAL;
 
 	ret = zfcp_fc_wka_port_get(wka_port);
 	if (ret)
 		return ret;
 
-	ret = zfcp_fsf_send_ct(wka_port, ct, NULL);
+	ct->handler = zfcp_fc_ct_job_handler;
+	ret = zfcp_fsf_send_ct(wka_port, ct, NULL, job->req->timeout / HZ);
 	if (ret)
 		zfcp_fc_wka_port_put(wka_port);
 
@@ -752,7 +777,6 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 
 	ct_els->req = job->request_payload.sg_list;
 	ct_els->resp = job->reply_payload.sg_list;
-	ct_els->handler = zfcp_fc_ct_els_job_handler;
 	ct_els->handler_data = job;
 
 	switch (job->request->msgcode) {
@@ -767,6 +791,12 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	}
 }
 
+int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *job)
+{
+	/* hardware tracks timeout, reset bsg timeout to not interfere */
+	return -EAGAIN;
+}
+
 int zfcp_fc_gs_setup(struct zfcp_adapter *adapter)
 {
 	struct zfcp_fc_wka_ports *wka_ports;
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index cb2a366..0747b08 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -27,6 +27,8 @@
 #define ZFCP_FC_GPN_FT_MAX_ENT	  (ZFCP_FC_GPN_FT_NUM_BUFS * \
 					(ZFCP_FC_GPN_FT_ENT_PAGE + 1))
 
+#define ZFCP_FC_CTELS_TMO	(2 * FC_DEF_R_A_TOV / 1000)
+
 /**
  * struct zfcp_fc_gid_pn_req - container for ct header plus gid_pn request
  * @ct_hdr: FC GS common transport header
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 482dcd9..e8fb4d9 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1068,20 +1068,20 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
 				 struct scatterlist *sg_req,
 				 struct scatterlist *sg_resp,
-				 int max_sbals)
+				 int max_sbals, unsigned int timeout)
 {
 	int ret;
-	unsigned int fcp_chan_timeout;
 
 	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
 	if (ret)
 		return ret;
 
 	/* common settings for ct/gs and els requests */
-	fcp_chan_timeout = 2 * FC_DEF_R_A_TOV / 1000;
+	if (timeout > 255)
+		timeout = 255; /* max value accepted by hardware */
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.support.timeout = fcp_chan_timeout;
-	zfcp_fsf_start_timer(req, (fcp_chan_timeout + 10) * HZ);
+	req->qtcb->bottom.support.timeout = timeout;
+	zfcp_fsf_start_timer(req, (timeout + 10) * HZ);
 
 	return 0;
 }
@@ -1092,7 +1092,8 @@ static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
  * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
  */
 int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
-		     struct zfcp_fsf_ct_els *ct, mempool_t *pool)
+		     struct zfcp_fsf_ct_els *ct, mempool_t *pool,
+		     unsigned int timeout)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
@@ -1111,7 +1112,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
-				    FSF_MAX_SBALS_PER_REQ);
+				    FSF_MAX_SBALS_PER_REQ, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1188,7 +1189,7 @@ skip_fsfstatus:
  * @els: pointer to struct zfcp_send_els with data for the command
  */
 int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
-		      struct zfcp_fsf_ct_els *els)
+		      struct zfcp_fsf_ct_els *els, unsigned int timeout)
 {
 	struct zfcp_fsf_req *req;
 	struct zfcp_qdio *qdio = adapter->qdio;
@@ -1206,7 +1207,7 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2);
+	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2, timeout);
 
 	if (ret)
 		goto failed_send;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 771cc53..8e6fc68 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -652,6 +652,7 @@ struct fc_function_template zfcp_transport_functions = {
 	.show_host_port_state = 1,
 	.show_host_active_fc4s = 1,
 	.bsg_request = zfcp_fc_exec_bsg_job,
+	.bsg_timeout = zfcp_fc_timeout_bsg_job,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 2a88985..7e26ebc 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -293,7 +293,10 @@ int aac_get_config_status(struct aac_dev *dev, int commit_flag)
 			status = -EINVAL;
 		}
 	}
-	aac_fib_complete(fibptr);
+	/* Do not set XferState to zero unless receives a response from F/W */
+	if (status >= 0)
+		aac_fib_complete(fibptr);
+
 	/* Send a CT_COMMIT_CONFIG to enable discovery of devices */
 	if (status >= 0) {
 		if ((aac_commit == 1) || commit_flag) {
@@ -310,13 +313,18 @@ int aac_get_config_status(struct aac_dev *dev, int commit_flag)
 				    FsaNormal,
 				    1, 1,
 				    NULL, NULL);
-			aac_fib_complete(fibptr);
+			/* Do not set XferState to zero unless
+			 * receives a response from F/W */
+			if (status >= 0)
+				aac_fib_complete(fibptr);
 		} else if (aac_commit == 0) {
 			printk(KERN_WARNING
 			  "aac_get_config_status: Foreign device configurations are being ignored\n");
 		}
 	}
-	aac_fib_free(fibptr);
+	/* FIB should be freed only after getting the response from the F/W */
+	if (status != -ERESTARTSYS)
+		aac_fib_free(fibptr);
 	return status;
 }
 
@@ -355,7 +363,9 @@ int aac_get_containers(struct aac_dev *dev)
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
 		aac_fib_complete(fibptr);
 	}
-	aac_fib_free(fibptr);
+	/* FIB should be freed only after getting the response from the F/W */
+	if (status != -ERESTARTSYS)
+		aac_fib_free(fibptr);
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
@@ -1245,8 +1255,12 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			 NULL);
 
 	if (rcode < 0) {
-		aac_fib_complete(fibptr);
-		aac_fib_free(fibptr);
+		/* FIB should be freed only after
+		 * getting the response from the F/W */
+		if (rcode != -ERESTARTSYS) {
+			aac_fib_complete(fibptr);
+			aac_fib_free(fibptr);
+		}
 		return rcode;
 	}
 	memcpy(&dev->adapter_info, info, sizeof(*info));
@@ -1270,6 +1284,12 @@ int aac_get_adapter_info(struct aac_dev* dev)
 
 		if (rcode >= 0)
 			memcpy(&dev->supplement_adapter_info, sinfo, sizeof(*sinfo));
+		if (rcode == -ERESTARTSYS) {
+			fibptr = aac_fib_alloc(dev);
+			if (!fibptr)
+				return -ENOMEM;
+		}
+
 	}
 
 
@@ -1470,9 +1490,11 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			  (dev->scsi_host_ptr->sg_tablesize * 8) + 112;
 		}
 	}
-
-	aac_fib_complete(fibptr);
-	aac_fib_free(fibptr);
+	/* FIB should be freed only after getting the response from the F/W */
+	if (rcode != -ERESTARTSYS) {
+		aac_fib_complete(fibptr);
+		aac_fib_free(fibptr);
+	}
 
 	return rcode;
 }
@@ -1633,6 +1655,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	 *	Alocate and initialize a Fib
 	 */
 	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
+		printk(KERN_WARNING "aac_read: fib allocation failed\n");
 		return -1;
 	}
 
@@ -1712,9 +1735,14 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
-		scsicmd->result = DID_ERROR << 16;
-		scsicmd->scsi_done(scsicmd);
-		return 0;
+		/* FIB temporarily unavailable,not catastrophic failure */
+
+		/* scsicmd->result = DID_ERROR << 16;
+		 * scsicmd->scsi_done(scsicmd);
+		 * return 0;
+		 */
+		printk(KERN_WARNING "aac_write: fib allocation failed\n");
+		return -1;
 	}
 
 	status = aac_adapter_write(cmd_fibcontext, scsicmd, lba, count, fua);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 83986ed..619c02d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 2461
+# define AAC_DRIVER_BUILD 24702
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -1036,6 +1036,9 @@ struct aac_dev
 	u8			printf_enabled;
 	u8			in_reset;
 	u8			msi;
+	int			management_fib_count;
+	spinlock_t		manage_lock;
+
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0391d75..9c0c911 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -153,7 +153,7 @@ cleanup:
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib_va = hw_fib;
 	}
-	if (retval != -EINTR)
+	if (retval != -ERESTARTSYS)
 		aac_fib_free(fibptr);
 	return retval;
 }
@@ -322,7 +322,7 @@ return_fib:
 		}
 		if (f.wait) {
 			if(down_interruptible(&fibctx->wait_sem) < 0) {
-				status = -EINTR;
+				status = -ERESTARTSYS;
 			} else {
 				/* Lock again and retry */
 				spin_lock_irqsave(&dev->fib_lock, flags);
@@ -593,10 +593,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				u64 addr;
 				void* p;
 				if (upsg->sg[i].count >
-				    (dev->adapter_info.options &
+				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
-				      65536) {
+				      65536)) {
 					rcode = -EINVAL;
 					goto cleanup;
 				}
@@ -645,10 +645,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				u64 addr;
 				void* p;
 				if (usg->sg[i].count >
-				    (dev->adapter_info.options &
+				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
-				      65536) {
+				      65536)) {
 					rcode = -EINVAL;
 					goto cleanup;
 				}
@@ -695,10 +695,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				uintptr_t addr;
 				void* p;
 				if (usg->sg[i].count >
-				    (dev->adapter_info.options &
+				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
-				      65536) {
+				      65536)) {
 					rcode = -EINVAL;
 					goto cleanup;
 				}
@@ -734,10 +734,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				dma_addr_t addr;
 				void* p;
 				if (upsg->sg[i].count >
-				    (dev->adapter_info.options &
+				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
-				      65536) {
+				      65536)) {
 					rcode = -EINVAL;
 					goto cleanup;
 				}
@@ -772,8 +772,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		psg->count = cpu_to_le32(sg_indx+1);
 		status = aac_fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
-	if (status == -EINTR) {
-		rcode = -EINTR;
+	if (status == -ERESTARTSYS) {
+		rcode = -ERESTARTSYS;
 		goto cleanup;
 	}
 
@@ -810,7 +810,7 @@ cleanup:
 	for(i=0; i <= sg_indx; i++){
 		kfree(sg_list[i]);
 	}
-	if (rcode != -EINTR) {
+	if (rcode != -ERESTARTSYS) {
 		aac_fib_complete(srbfib);
 		aac_fib_free(srbfib);
 	}
@@ -848,7 +848,7 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 	 */
 
 	status = aac_dev_ioctl(dev, cmd, arg);
-	if(status != -ENOTTY)
+	if (status != -ENOTTY)
 		return status;
 
 	switch (cmd) {
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 666d515..a726148 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -194,7 +194,9 @@ int aac_send_shutdown(struct aac_dev * dev)
 
 	if (status >= 0)
 		aac_fib_complete(fibctx);
-	aac_fib_free(fibctx);
+	/* FIB should be freed only after getting the response from the F/W */
+	if (status != -ERESTARTSYS)
+		aac_fib_free(fibctx);
 	return status;
 }
 
@@ -304,6 +306,8 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	/*
 	 *	Check the preferred comm settings, defaults from template.
 	 */
+	dev->management_fib_count = 0;
+	spin_lock_init(&dev->manage_lock);
 	dev->max_fib_size = sizeof(struct hw_fib);
 	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
 		- sizeof(struct aac_fibhdr)
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 956261f..94d2954 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -189,7 +189,14 @@ struct fib *aac_fib_alloc(struct aac_dev *dev)
 
 void aac_fib_free(struct fib *fibptr)
 {
-	unsigned long flags;
+	unsigned long flags, flagsv;
+
+	spin_lock_irqsave(&fibptr->event_lock, flagsv);
+	if (fibptr->done == 2) {
+		spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
+		return;
+	}
+	spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
 
 	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
 	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
@@ -390,6 +397,8 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	unsigned long flags = 0;
 	unsigned long qflags;
+	unsigned long mflags = 0;
+
 
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
@@ -471,9 +480,31 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	if (!dev->queues)
 		return -EBUSY;
 
-	if(wait)
+	if (wait) {
+
+		spin_lock_irqsave(&dev->manage_lock, mflags);
+		if (dev->management_fib_count >= AAC_NUM_MGT_FIB) {
+			printk(KERN_INFO "No management Fibs Available:%d\n",
+						dev->management_fib_count);
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+			return -EBUSY;
+		}
+		dev->management_fib_count++;
+		spin_unlock_irqrestore(&dev->manage_lock, mflags);
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-	aac_adapter_deliver(fibptr);
+	}
+
+	if (aac_adapter_deliver(fibptr) != 0) {
+		printk(KERN_ERR "aac_fib_send: returned -EBUSY\n");
+		if (wait) {
+			spin_unlock_irqrestore(&fibptr->event_lock, flags);
+			spin_lock_irqsave(&dev->manage_lock, mflags);
+			dev->management_fib_count--;
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+		}
+		return -EBUSY;
+	}
+
 
 	/*
 	 *	If the caller wanted us to wait for response wait now.
@@ -516,14 +547,15 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				udelay(5);
 			}
 		} else if (down_interruptible(&fibptr->event_wait)) {
-			fibptr->done = 2;
-			up(&fibptr->event_wait);
+			/* Do nothing ... satisfy
+			 * down_interruptible must_check */
 		}
+
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if ((fibptr->done == 0) || (fibptr->done == 2)) {
+		if (fibptr->done == 0) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
-			return -EINTR;
+			return -ERESTARTSYS;
 		}
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 		BUG_ON(fibptr->done == 0);
@@ -689,6 +721,7 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 
 int aac_fib_complete(struct fib *fibptr)
 {
+	unsigned long flags;
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 
 	/*
@@ -709,6 +742,13 @@ int aac_fib_complete(struct fib *fibptr)
 	 *	command is complete that we had sent to the adapter and this
 	 *	cdb could be reused.
 	 */
+	spin_lock_irqsave(&fibptr->event_lock, flags);
+	if (fibptr->done == 2) {
+		spin_unlock_irqrestore(&fibptr->event_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&fibptr->event_lock, flags);
+
 	if((hw_fib->header.XferState & cpu_to_le32(SentFromHost)) &&
 		(hw_fib->header.XferState & cpu_to_le32(AdapterProcessed)))
 	{
@@ -1355,7 +1395,10 @@ int aac_reset_adapter(struct aac_dev * aac, int forced)
 
 			if (status >= 0)
 				aac_fib_complete(fibctx);
-			aac_fib_free(fibctx);
+			/* FIB should be freed only after getting
+			 * the response from the F/W */
+			if (status != -ERESTARTSYS)
+				aac_fib_free(fibctx);
 		}
 	}
 
@@ -1759,6 +1802,7 @@ int aac_command_thread(void *data)
 				struct fib *fibptr;
 
 				if ((fibptr = aac_fib_alloc(dev))) {
+					int status;
 					__le32 *info;
 
 					aac_fib_init(fibptr);
@@ -1769,15 +1813,21 @@ int aac_command_thread(void *data)
 
 					*info = cpu_to_le32(now.tv_sec);
 
-					(void)aac_fib_send(SendHostTime,
+					status = aac_fib_send(SendHostTime,
 						fibptr,
 						sizeof(*info),
 						FsaNormal,
 						1, 1,
 						NULL,
 						NULL);
-					aac_fib_complete(fibptr);
-					aac_fib_free(fibptr);
+					/* Do not set XferState to zero unless
+					 * receives a response from F/W */
+					if (status >= 0)
+						aac_fib_complete(fibptr);
+					/* FIB should be freed only after
+					 * getting the response from the F/W */
+					if (status != -ERESTARTSYS)
+						aac_fib_free(fibptr);
 				}
 				difference = (long)(unsigned)update_interval*HZ;
 			} else {
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index abc9ef5..9c7408f 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -57,9 +57,9 @@ unsigned int aac_response_normal(struct aac_queue * q)
 	struct hw_fib * hwfib;
 	struct fib * fib;
 	int consumed = 0;
-	unsigned long flags;
+	unsigned long flags, mflags;
 
-	spin_lock_irqsave(q->lock, flags);	
+	spin_lock_irqsave(q->lock, flags);
 	/*
 	 *	Keep pulling response QEs off the response queue and waking
 	 *	up the waiters until there are no more QEs. We then return
@@ -125,12 +125,21 @@ unsigned int aac_response_normal(struct aac_queue * q)
 		} else {
 			unsigned long flagv;
 			spin_lock_irqsave(&fib->event_lock, flagv);
-			if (!fib->done)
+			if (!fib->done) {
 				fib->done = 1;
-			up(&fib->event_wait);
+				up(&fib->event_wait);
+			}
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
+
+			spin_lock_irqsave(&dev->manage_lock, mflags);
+			dev->management_fib_count--;
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
 			if (fib->done == 2) {
+				spin_lock_irqsave(&fib->event_lock, flagv);
+				fib->done = 0;
+				spin_unlock_irqrestore(&fib->event_lock, flagv);
 				aac_fib_complete(fib);
 				aac_fib_free(fib);
 			}
@@ -232,6 +241,7 @@ unsigned int aac_command_normal(struct aac_queue *q)
 
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 {
+	unsigned long mflags;
 	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
 	if ((index & 0x00000002L)) {
 		struct hw_fib * hw_fib;
@@ -320,11 +330,25 @@ unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 			unsigned long flagv;
 	  		dprintk((KERN_INFO "event_wait up\n"));
 			spin_lock_irqsave(&fib->event_lock, flagv);
-			if (!fib->done)
+			if (!fib->done) {
 				fib->done = 1;
-			up(&fib->event_wait);
+				up(&fib->event_wait);
+			}
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
+
+			spin_lock_irqsave(&dev->manage_lock, mflags);
+			dev->management_fib_count--;
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
+			if (fib->done == 2) {
+				spin_lock_irqsave(&fib->event_lock, flagv);
+				fib->done = 0;
+				spin_unlock_irqrestore(&fib->event_lock, flagv);
+				aac_fib_complete(fib);
+				aac_fib_free(fib);
+			}
+
 		}
 		return 0;
 	}
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 4d419c1..78971db 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3171,13 +3171,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 				tinfo->curr.transport_version = 2;
 				tinfo->goal.transport_version = 2;
 				tinfo->goal.ppr_options = 0;
-				/*
-				 * Remove any SCBs in the waiting for selection
-				 * queue that may also be for this target so
-				 * that command ordering is preserved.
-				 */
-				ahd_freeze_devq(ahd, scb);
-				ahd_qinfifo_requeue_tail(ahd, scb);
+				if (scb != NULL) {
+					/*
+					 * Remove any SCBs in the waiting
+					 * for selection queue that may
+					 * also be for this target so that
+					 * command ordering is preserved.
+					 */
+					ahd_freeze_devq(ahd, scb);
+					ahd_qinfifo_requeue_tail(ahd, scb);
+				}
 				printerror = 0;
 			}
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, FALSE)
@@ -3194,13 +3197,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 				      MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_CUR|AHD_TRANS_GOAL,
 				      /*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, FALSE)
 			&& ppr_busfree == 0) {
@@ -3217,13 +3223,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 					/*ppr_options*/0,
 					AHD_TRANS_CUR|AHD_TRANS_GOAL,
 					/*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_IDE_BUSFREE) != 0
 			&& ahd_sent_msg(ahd, AHDMSG_1B,
@@ -3251,7 +3260,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 	 * the message phases.  We check it last in case we
 	 * had to send some other message that caused a busfree.
 	 */
-	if (printerror != 0
+	if (scb != NULL && printerror != 0
 	 && (lastphase == P_MESGIN || lastphase == P_MESGOUT)
 	 && ((ahd->msg_flags & MSG_FLAG_EXPECT_PPR_BUSFREE) != 0)) {
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
old mode 100755
new mode 100644
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
old mode 100755
new mode 100644
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 608e675..1263d97 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1586,8 +1586,7 @@ typedef struct fc_port {
  */
 #define FCF_FABRIC_DEVICE	BIT_0
 #define FCF_LOGIN_NEEDED	BIT_1
-#define FCF_TAPE_PRESENT	BIT_2
-#define FCF_FCP2_DEVICE		BIT_3
+#define FCF_FCP2_DEVICE		BIT_2
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4a0eac..3f8e849 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -205,7 +205,7 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
-		if (fcport->flags & FCF_TAPE_PRESENT)
+		if (fcport->flags & FCF_FCP2_DEVICE)
 			opts |= BIT_1;
 		rval = qla2x00_get_port_database(vha, fcport, opts);
 		if (rval != QLA_SUCCESS)
@@ -2726,7 +2726,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 
 		/*
 		 * Logout all previous fabric devices marked lost, except
-		 * tape devices.
+		 * FCP2 devices.
 		 */
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
@@ -2739,7 +2739,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
-				    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
+				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
 					ha->isp_ops->fabric_logout(vha,
@@ -3018,7 +3018,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			fcport->d_id.b24 = new_fcport->d_id.b24;
 			fcport->flags |= FCF_LOGIN_NEEDED;
 			if (fcport->loop_id != FC_NO_LOOP_ID &&
-			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
+			    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
 				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
@@ -3272,9 +3272,9 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
-		/* Send an ADISC to tape devices.*/
+		/* Send an ADISC to FCP2 devices.*/
 		opts = 0;
-		if (fcport->flags & FCF_TAPE_PRESENT)
+		if (fcport->flags & FCF_FCP2_DEVICE)
 			opts |= BIT_1;
 		rval = qla2x00_get_port_database(vha, fcport, opts);
 		if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 209f50e..8529eb1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1188,7 +1188,6 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
-	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
@@ -1197,8 +1196,6 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 		scsi_deactivate_tcq(sdev, req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
-	if (sdev->type == TYPE_TAPE)
-		fcport->flags |= FCF_TAPE_PRESENT;
 
 	return 0;
 }
@@ -2805,7 +2802,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 
 			fcport->login_retry--;
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
-				if (fcport->flags & FCF_TAPE_PRESENT)
+				if (fcport->flags & FCF_FCP2_DEVICE)
 					ha->isp_ops->fabric_logout(vha,
 							fcport->loop_id,
 							fcport->d_id.b.domain,
@@ -3141,7 +3138,10 @@ qla2x00_timer(scsi_qla_host_t *vha)
 			if (!IS_QLA2100(ha) && vha->link_down_timeout)
 				atomic_set(&vha->loop_state, LOOP_DEAD);
 
-			/* Schedule an ISP abort to return any tape commands. */
+			/*
+			 * Schedule an ISP abort to return any FCP2-device
+			 * commands.
+			 */
 			/* NPIV - scan physical port only */
 			if (!vha->vp_idx) {
 				spin_lock_irqsave(&ha->hardware_lock,
@@ -3158,7 +3158,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 					if (sp->ctx)
 						continue;
 					sfcp = sp->fcport;
-					if (!(sfcp->flags & FCF_TAPE_PRESENT))
+					if (!(sfcp->flags & FCF_FCP2_DEVICE))
 						continue;
 
 					set_bit(ISP_ABORT_NEEDED,
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 010e69b..371dc89 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2292,11 +2292,14 @@ qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	uint32_t faddr, left, burst;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA25XX(ha) || IS_QLA81XX(ha))
+		goto try_fast;
 	if (offset & 0xfff)
 		goto slow_read;
 	if (length < OPTROM_BURST_SIZE)
 		goto slow_read;
 
+try_fast:
 	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 	    &optrom_dma, GFP_KERNEL);
 	if (!optrom) {
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index a65dd95..ed36279 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.01-k9"
+#define QLA2XXX_VERSION      "8.03.01-k10"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d892768..c664242 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -749,9 +749,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 */
 			req->next_rq->resid_len = scsi_in(cmd)->resid;
 
+			scsi_release_buffers(cmd);
 			blk_end_request_all(req, 0);
 
-			scsi_release_buffers(cmd);
 			scsi_next_command(cmd);
 			return;
 		}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index ddfcecd..653f22a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3527,7 +3527,10 @@ fc_bsg_job_timeout(struct request *req)
 	if (!done && i->f->bsg_timeout) {
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
-		if (err)
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
 				"abort failed with status %d\n", err);
 	}
diff --git a/include/scsi/scsi_bsg_fc.h b/include/scsi/scsi_bsg_fc.h
index a4b2333..91a4e4f 100644
--- a/include/scsi/scsi_bsg_fc.h
+++ b/include/scsi/scsi_bsg_fc.h
@@ -292,7 +292,7 @@ struct fc_bsg_request {
 		struct fc_bsg_rport_els		r_els;
 		struct fc_bsg_rport_ct		r_ct;
 	} rqst_data;
-};
+} __attribute__((packed));
 
 
 /* response (request sense data) structure of the sg_io_v4 */
