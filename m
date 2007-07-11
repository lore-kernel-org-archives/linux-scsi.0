From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 4/6] tgt: convert libsrp and ibmvstgt to use srp_transport
Date: Wed, 11 Jul 2007 15:08:21 +0900
Message-ID: <20070711150821F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56192 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbXGKGMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This converts libsrp and ibmvstgt to use srp transport.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig             |    2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c |   58 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/libsrp.c            |    5 ++-
 include/scsi/libsrp.h            |    2 +-
 4 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index ede8395..0a2a25a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -838,7 +838,7 @@ config SCSI_IBMVSCSI
 
 config SCSI_IBMVSCSIS
 	tristate "IBM Virtual SCSI Server support"
-	depends on PPC_PSERIES && SCSI_TGT && SCSI_SRP
+	depends on PPC_PSERIES && SCSI_TGT && SCSI_SRP && SCSI_SRP_ATTRS
 	help
 	  This is the SRP target driver for IBM pSeries virtual environments.
 
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 8ba7dd0..4ee6e41 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -25,6 +25,7 @@ #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_srp.h>
 #include <scsi/scsi_tgt.h>
 #include <scsi/libsrp.h>
 #include <asm/hvcall.h>
@@ -68,9 +69,12 @@ struct vio_port {
 	unsigned long liobn;
 	unsigned long riobn;
 	struct srp_target *target;
+
+	struct srp_rport *rport;
 };
 
 static struct workqueue_struct *vtgtd;
+static struct scsi_transport_template *ibmvstgt_transport_template;
 
 /*
  * These are fixed for the system and come from the Open Firmware device tree.
@@ -188,6 +192,7 @@ static int send_rsp(struct iu_entry *iue
 static void handle_cmd_queue(struct srp_target *target)
 {
 	struct Scsi_Host *shost = target->shost;
+	struct srp_rport *rport = target_to_port(target)->rport;
 	struct iu_entry *iue;
 	struct srp_cmd *cmd;
 	unsigned long flags;
@@ -200,7 +205,8 @@ retry:
 		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
 			spin_unlock_irqrestore(&target->lock, flags);
 			cmd = iue->sbuf->buf;
-			err = srp_cmd_queue(shost, cmd, iue, 0);
+			err = srp_cmd_queue(shost, cmd, iue,
+					    (unsigned long)rport, 0);
 			if (err) {
 				eprintk("cannot queue cmd %p %d\n", cmd, err);
 				srp_iu_put(iue);
@@ -359,6 +365,16 @@ static void process_login(struct iu_entr
 	union viosrp_iu *iu = vio_iu(iue);
 	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
 	uint64_t tag = iu->srp.rsp.tag;
+	struct Scsi_Host *shost = iue->target->shost;
+	struct srp_target *target = host_to_srp_target(shost);
+	struct vio_port *vport = target_to_port(target);
+	struct srp_rport_identifiers ids;
+
+	memset(&ids, 0, sizeof(ids));
+	sprintf(ids.port_id, "%x", vport->dma_dev->unit_address);
+	ids.roles = SRP_RPORT_ROLE_INITIATOR;
+	if (!vport->rport)
+		vport->rport = srp_rport_add(shost, &ids);
 
 	/* TODO handle case that requested size is wrong and
 	 * buffer format is wrong
@@ -412,7 +428,9 @@ static int process_tsk_mgmt(struct iu_en
 		fn = 0;
 	}
 	if (fn)
-		scsi_tgt_tsk_mgmt_request(iue->target->shost, fn,
+		scsi_tgt_tsk_mgmt_request(iue->target->shost,
+					  (unsigned long)iue->target->shost,
+					  fn,
 					  iu->srp.tsk_mgmt.task_tag,
 					  (struct scsi_lun *) &iu->srp.tsk_mgmt.lun,
 					  iue);
@@ -721,7 +739,8 @@ static int ibmvstgt_eh_abort_handler(str
 	return 0;
 }
 
-static int ibmvstgt_tsk_mgmt_response(u64 mid, int result)
+static int ibmvstgt_tsk_mgmt_response(struct Scsi_Host *shost,
+				      u64 itn_id, u64 mid, int result)
 {
 	struct iu_entry *iue = (struct iu_entry *) ((void *) mid);
 	union viosrp_iu *iu = vio_iu(iue);
@@ -747,6 +766,20 @@ static int ibmvstgt_tsk_mgmt_response(u6
 	return 0;
 }
 
+static int ibmvstgt_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
+				      int result)
+{
+	struct srp_target *target = host_to_srp_target(shost);
+	struct vio_port *vport = target_to_port(target);
+
+	if (result) {
+		eprintk("%p %d\n", shost, result);
+		srp_rport_del(vport->rport);
+		vport->rport = NULL;
+	}
+	return 0;
+}
+
 static ssize_t system_id_show(struct class_device *cdev, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", system_id);
@@ -804,6 +837,7 @@ static int ibmvstgt_probe(struct vio_dev
 	shost = scsi_host_alloc(&ibmvstgt_sht, sizeof(struct srp_target));
 	if (!shost)
 		goto free_vport;
+	shost->transportt = ibmvstgt_transport_template;
 	err = scsi_tgt_alloc_queue(shost);
 	if (err)
 		goto put_host;
@@ -837,8 +871,8 @@ static int ibmvstgt_probe(struct vio_dev
 	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto destroy_queue;
-	return 0;
 
+	return 0;
 destroy_queue:
 	crq_queue_destroy(target);
 free_srp_target:
@@ -857,6 +891,7 @@ static int ibmvstgt_remove(struct vio_de
 	struct vio_port *vport = target->ldata;
 
 	crq_queue_destroy(target);
+	srp_remove_host(shost);
 	scsi_remove_host(shost);
 	scsi_tgt_free_queue(shost);
 	srp_target_free(target);
@@ -909,15 +944,24 @@ static int get_system_info(void)
 	return 0;
 }
 
+static struct srp_function_template ibmvstgt_transport_functions = {
+	.it_nexus_response = ibmvstgt_it_nexus_response,
+};
+
 static int ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
 	printk("IBM eServer i/pSeries Virtual SCSI Target Driver\n");
 
+	ibmvstgt_transport_template =
+		srp_attach_transport(&ibmvstgt_transport_functions);
+	if (!ibmvstgt_transport_template)
+		return err;
+
 	vtgtd = create_workqueue("ibmvtgtd");
 	if (!vtgtd)
-		return err;
+		goto release_transport;
 
 	err = get_system_info();
 	if (err)
@@ -928,9 +972,10 @@ static int ibmvstgt_init(void)
 		goto destroy_wq;
 
 	return 0;
-
 destroy_wq:
 	destroy_workqueue(vtgtd);
+release_transport:
+	srp_release_transport(ibmvstgt_transport_template);
 	return err;
 }
 
@@ -940,6 +985,7 @@ static void ibmvstgt_exit(void)
 
 	destroy_workqueue(vtgtd);
 	vio_unregister_driver(&ibmvstgt_driver);
+	srp_release_transport(ibmvstgt_transport_template);
 }
 
 MODULE_DESCRIPTION("IBM Virtual SCSI Target");
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 732446e..2ad0a27 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -392,7 +392,7 @@ static int vscsis_data_length(struct srp
 }
 
 int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
-		  u64 addr)
+		  u64 itn_id, u64 addr)
 {
 	enum dma_data_direction dir;
 	struct scsi_cmnd *sc;
@@ -428,7 +428,8 @@ int srp_cmd_queue(struct Scsi_Host *shos
 	sc->request_bufflen = len;
 	sc->request_buffer = (void *) (unsigned long) addr;
 	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, (struct scsi_lun *) &cmd->lun, cmd->tag);
+	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
+				     cmd->tag);
 	if (err)
 		scsi_host_put_command(shost, sc);
 
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index d143171..ba615e4 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -59,7 +59,7 @@ extern void srp_target_free(struct srp_t
 extern struct iu_entry *srp_iu_get(struct srp_target *);
 extern void srp_iu_put(struct iu_entry *);
 
-extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64);
+extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64);
 extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
 			     srp_rdma_t, int, int);
 
-- 
1.4.3.2

