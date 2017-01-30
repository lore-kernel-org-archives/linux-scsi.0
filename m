From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] scsi: remove eh_timed_out methods in the transport template
Date: Mon, 30 Jan 2017 13:18:58 +0100
Message-ID: <1485778739-29036-4-git-send-email-hch@lst.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752771AbdA3MTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:19:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYAvT-0003oo-TT
        for linux-scsi@vger.kernel.org; Mon, 30 Jan 2017 12:19:16 +0000
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Instead define the timeout behavior purely based on the host_template
eh_timed_out method and wire up the existing transport implementations
in the host templates.  This also clears up the confusion that the
transport template method overrides the host template one, so some
drivers have to re-override the transport template one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-eh.c                  |  1 +
 drivers/ata/libata-transport.c           |  1 -
 drivers/ata/libata.h                     |  1 -
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/infiniband/ulp/srp/ib_srp.c      |  1 +
 drivers/message/fusion/mptfc.c           |  1 +
 drivers/message/fusion/mptsas.c          |  2 +-
 drivers/s390/scsi/zfcp_scsi.c            |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/bfa/bfad_im.c               |  2 ++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/csiostor/csio_scsi.c        |  2 ++
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/fcoe/fcoe.c                 |  1 +
 drivers/scsi/fnic/fnic_main.c            |  1 +
 drivers/scsi/ibmvscsi/ibmvfc.c           |  1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c         |  1 +
 drivers/scsi/iscsi_tcp.c                 |  1 +
 drivers/scsi/libiscsi.c                  |  5 ++---
 drivers/scsi/lpfc/lpfc_scsi.c            |  2 ++
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla2xxx/qla_os.c            |  1 +
 drivers/scsi/scsi_error.c                |  4 +---
 drivers/scsi/scsi_transport_fc.c         |  9 ++++-----
 drivers/scsi/scsi_transport_srp.c        |  5 ++---
 drivers/scsi/storvsc_drv.c               |  5 -----
 include/linux/libata.h                   |  2 ++
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport.h            | 11 -----------
 include/scsi/scsi_transport_fc.h         |  1 +
 include/scsi/scsi_transport_srp.h        |  1 +
 33 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0e1ec37..50ee10d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -549,6 +549,7 @@ enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
 	DPRINTK("EXIT, ret=%d\n", ret);
 	return ret;
 }
+EXPORT_SYMBOL(ata_scsi_timed_out);
 
 static void ata_eh_unload(struct ata_port *ap)
 {
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 7ef16c0..4669823 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -716,7 +716,6 @@ struct scsi_transport_template *ata_attach_transport(void)
 		return NULL;
 
 	i->t.eh_strategy_handler	= ata_scsi_error;
-	i->t.eh_timed_out		= ata_scsi_timed_out;
 	i->t.user_scan			= ata_scsi_user_scan;
 
 	i->t.host_attrs.ac.attrs = &i->port_attrs[0];
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 8f3a559..06d479d 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -159,7 +159,6 @@ extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
 extern void ata_internal_cmd_timed_out(struct ata_device *dev, u8 cmd);
 extern void ata_eh_acquire(struct ata_port *ap);
 extern void ata_eh_release(struct ata_port *ap);
-extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_eh_fastdrain_timerfn(unsigned long arg);
 extern void ata_qc_schedule_eh(struct ata_queued_cmd *qc);
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index e71af71..30a6985 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -994,6 +994,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.sg_tablesize           = ISCSI_ISER_DEF_SG_TABLESIZE,
 	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
+	.eh_timed_out		= iscsi_eh_cmd_timed_out,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 79bf484..36529e3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2869,6 +2869,7 @@ static struct scsi_host_template srp_template = {
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.change_queue_depth             = srp_change_queue_depth,
+	.eh_timed_out			= srp_timed_out,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index add6a3a..98eafae 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -119,6 +119,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.target_destroy			= mptfc_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
+	.eh_timed_out			= fc_eh_timed_out,
 	.eh_abort_handler		= mptfc_abort,
 	.eh_device_reset_handler	= mptfc_dev_reset,
 	.eh_bus_reset_handler		= mptfc_bus_reset,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7ee1667..4ce3336 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1983,6 +1983,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.target_destroy			= mptsas_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
+	.eh_timed_out			= mptsas_eh_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
@@ -5398,7 +5399,6 @@ mptsas_init(void)
 	    sas_attach_transport(&mptsas_transport_functions);
 	if (!mptsas_transport_template)
 		return -ENODEV;
-	mptsas_transport_template->eh_timed_out = mptsas_eh_timed_out;
 
 	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER,
 	    "mptscsih_io_done");
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 07ffdbb..0678cf7 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -330,6 +330,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.module			 = THIS_MODULE,
 	.name			 = "zfcp",
 	.queuecommand		 = zfcp_scsi_queuecommand,
+	.eh_timed_out		 = fc_eh_timed_out,
 	.eh_abort_handler	 = zfcp_scsi_eh_abort_handler,
 	.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
 	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b5112d6..6d67210 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -395,6 +395,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.change_queue_depth = scsi_change_queue_depth,
 	.slave_configure = beiscsi_slave_configure,
 	.target_alloc = iscsi_target_alloc,
+	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 02d8060..7eb0eef 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -813,6 +813,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.name = BFAD_DRIVER_NAME,
 	.info = bfad_im_info,
 	.queuecommand = bfad_im_queuecommand,
+	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
 	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
@@ -835,6 +836,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.name = BFAD_DRIVER_NAME,
 	.info = bfad_im_info,
 	.queuecommand = bfad_im_queuecommand,
+	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
 	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index c639d5a..b1e39f9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2947,6 +2947,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.module			= THIS_MODULE,
 	.name			= "QLogic Offload FCoE Initiator",
 	.queuecommand		= bnx2fc_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= bnx2fc_eh_abort,	  /* abts */
 	.eh_device_reset_handler = bnx2fc_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = bnx2fc_eh_target_reset, /* tgt reset */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 133901f..f32a66f 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2259,6 +2259,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.name			= "QLogic Offload iSCSI Initiator",
 	.proc_name		= "bnx2i",
 	.queuecommand		= iscsi_queuecommand,
+	.eh_timed_out		= iscsi_eh_cmd_timed_out,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 89a52b9..a1ff75f 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2270,6 +2270,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.name			= CSIO_DRV_DESC,
 	.proc_name		= KBUILD_MODNAME,
 	.queuecommand		= csio_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.slave_alloc		= csio_slave_alloc,
@@ -2289,6 +2290,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.name			= CSIO_DRV_DESC,
 	.proc_name		= KBUILD_MODNAME,
 	.queuecommand		= csio_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.slave_alloc		= csio_slave_alloc,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 33e8346..1880eb6 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -90,6 +90,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.sg_tablesize	= SG_ALL,
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
+	.eh_timed_out	= iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 9a2fdc3..3fb3f57 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -103,6 +103,7 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.sg_tablesize	= SG_ALL,
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
+	.eh_timed_out	= iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 59150ca..86af57f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -277,6 +277,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.name = "FCoE Driver",
 	.proc_name = FCOE_NAME,
 	.queuecommand = fc_queuecommand,
+	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = fc_eh_abort,
 	.eh_device_reset_handler = fc_eh_device_reset,
 	.eh_host_reset_handler = fc_eh_host_reset,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 58ce902..ba58b79 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -106,6 +106,7 @@ static struct scsi_host_template fnic_host_template = {
 	.module = THIS_MODULE,
 	.name = DRV_NAME,
 	.queuecommand = fnic_queuecommand,
+	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = fnic_abort_cmd,
 	.eh_device_reset_handler = fnic_device_reset,
 	.eh_host_reset_handler = fnic_host_reset,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 78b72c2..2c92dab 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3090,6 +3090,7 @@ static struct scsi_host_template driver_template = {
 	.name = "IBM POWER Virtual FC Adapter",
 	.proc_name = IBMVFC_NAME,
 	.queuecommand = ibmvfc_queuecommand,
+	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = ibmvfc_eh_abort_handler,
 	.eh_device_reset_handler = ibmvfc_eh_device_reset_handler,
 	.eh_target_reset_handler = ibmvfc_eh_target_reset_handler,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50cd011..1deb0a9 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2072,6 +2072,7 @@ static struct scsi_host_template driver_template = {
 	.name = "IBM POWER Virtual SCSI Adapter " IBMVSCSI_VERSION,
 	.proc_name = "ibmvscsi",
 	.queuecommand = ibmvscsi_queuecommand,
+	.eh_timed_out = srp_timed_out,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
 	.eh_host_reset_handler = ibmvscsi_eh_host_reset_handler,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ace4f1f..4228aba 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -967,6 +967,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
+	.eh_timed_out		= iscsi_eh_cmd_timed_out,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9b6fba..834d121 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1930,7 +1930,7 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 		return 0;
 }
 
-static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
+enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
 	struct iscsi_task *task = NULL, *running_task;
@@ -2063,6 +2063,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		     "timer reset" : "nh");
 	return rc;
 }
+EXPORT_SYMBOL_GPL(iscsi_eh_cmd_timed_out);
 
 static void iscsi_check_transport_timeouts(unsigned long data)
 {
@@ -2585,8 +2586,6 @@ int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 	if (!shost->cmd_per_lun)
 		shost->cmd_per_lun = ISCSI_DEF_CMD_PER_LUN;
 
-	if (!shost->transportt->eh_timed_out)
-		shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 	return scsi_add_host(shost, pdev);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_add);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ad350d9..071aceb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5923,6 +5923,7 @@ struct scsi_host_template lpfc_template = {
 	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
@@ -5949,6 +5950,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index d6a2054..8b25f0a 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -48,6 +48,7 @@ struct scsi_host_template qedi_host_template = {
 	.name = "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver",
 	.proc_name = QEDI_MODULE_NAME,
 	.queuecommand = iscsi_queuecommand,
+	.eh_timed_out = iscsi_eh_cmd_timed_out,
 	.eh_abort_handler = iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a000ec..d1f5863 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -262,6 +262,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2xxx_queuecommand,
 
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
 	.eh_target_reset_handler = qla2xxx_eh_target_reset,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 996e134..9d7bfbb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -279,9 +279,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	if (host->eh_deadline != -1 && !host->last_reset)
 		host->last_reset = jiffies;
 
-	if (host->transportt->eh_timed_out)
-		rtn = host->transportt->eh_timed_out(scmd);
-	else if (host->hostt->eh_timed_out)
+	if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_NOT_HANDLED) {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 03577bd..9a6ea6f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2055,7 +2055,7 @@ static int fc_vport_match(struct attribute_container *cont,
 
 
 /**
- * fc_timed_out - FC Transport I/O timeout intercept handler
+ * fc_eh_timed_out - FC Transport I/O timeout intercept handler
  * @scmd:	The SCSI command which timed out
  *
  * This routine protects against error handlers getting invoked while a
@@ -2076,8 +2076,8 @@ static int fc_vport_match(struct attribute_container *cont,
  * Notes:
  *	This routine assumes no locks are held on entry.
  */
-static enum blk_eh_timer_return
-fc_timed_out(struct scsi_cmnd *scmd)
+enum blk_eh_timer_return
+fc_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
@@ -2086,6 +2086,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
 
 	return BLK_EH_NOT_HANDLED;
 }
+EXPORT_SYMBOL(fc_eh_timed_out);
 
 /*
  * Called by fc_user_scan to locate an rport on the shost that
@@ -2211,8 +2212,6 @@ fc_attach_transport(struct fc_function_template *ft)
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
 
-	i->t.eh_timed_out = fc_timed_out;
-
 	i->t.user_scan = fc_user_scan;
 
 	/* target-mode drivers' functions */
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index b87a786..75b57a1 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -591,7 +591,7 @@ EXPORT_SYMBOL(srp_reconnect_rport);
  * Note: This function is called from soft-IRQ context and with the request
  * queue lock held.
  */
-static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
+enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
@@ -603,6 +603,7 @@ static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
 		i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
 		BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
 }
+EXPORT_SYMBOL(srp_timed_out);
 
 static void srp_rport_release(struct device *dev)
 {
@@ -820,8 +821,6 @@ srp_attach_transport(struct srp_function_template *ft)
 	if (!i)
 		return NULL;
 
-	i->t.eh_timed_out = srp_timed_out;
-
 	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
 	i->t.it_nexus_response = srp_it_nexus_response;
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 05526b7..1e4a7ce 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1774,11 +1774,6 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
-
-	/*
-	 * Install Hyper-V specific timeout handler.
-	 */
-	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c170be5..46e18c0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1130,6 +1130,7 @@ extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
+extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
@@ -1355,6 +1356,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.proc_name		= drv_name,			\
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
+	.eh_timed_out		= ata_scsi_timed_out,		\
 	.bios_param		= ata_std_bios_param,		\
 	.unlock_native_capacity	= ata_scsi_unlock_native_capacity, \
 	.sdev_attrs		= ata_common_sdev_attrs
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4d1c46a..b0e275d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -383,6 +383,7 @@ extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
+extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
 /*
  * iSCSI host helpers.
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 8129239..6c3bb9f 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -58,17 +58,6 @@ struct scsi_transport_template {
 	void (* eh_strategy_handler)(struct Scsi_Host *);
 
 	/*
-	 * This is an optional routine that allows the transport to become
-	 * involved when a scsi io timer fires. The return value tells the
-	 * timer routine how to finish the io timeout handling:
-	 * EH_HANDLED:		I fixed the error, please complete the command
-	 * EH_RESET_TIMER:	I need more time, reset the timer and
-	 *			begin counting again
-	 * EH_NOT_HANDLED	Begin normal error recovery
-	 */
-	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
-
-	/*
 	 * Used as callback for the completion of i_t_nexus request
 	 * for target drivers.
 	 */
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 924c8e6..b21b8aa5 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -808,6 +808,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
 
 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
 {
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index d40d3ef..20d9679 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -124,6 +124,7 @@ extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
 extern void srp_stop_rport_timers(struct srp_rport *rport);
+enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd);
 
 /**
  * srp_chkready() - evaluate the transport layer state before I/O
-- 
2.1.4

