From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/12] qla2xxx: Remove port down retry count.
Date: Fri, 15 Oct 2010 11:27:39 -0700
Message-ID: <1287167269-8034-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36963 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756360Ab0JOSg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:29 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

This patch removes the use of the port down retry counter as a mechanism to
update a fcport state. The internal driver counter is a residual carry-over
from pre-FC-transport aware driver inteaction. The ql2xport_down_retry module
parameter and NVRAM set ha->port_down_retry_count remain in order to seed the
fc-host's default dev-loss-tmo.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++++
 drivers/scsi/qla2xxx/qla_def.h  |    2 --
 drivers/scsi/qla2xxx/qla_init.c |    8 --------
 drivers/scsi/qla2xxx/qla_os.c   |   30 ------------------------------
 4 files changed, 4 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2ff4342..a9ceb39 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1547,6 +1547,10 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	*((fc_port_t **)rport->dd_data) = NULL;
 	spin_unlock_irq(host->host_lock);
 
+	/* Now that the rport has been deleted, set the fcport state to
+	   FCS_DEVICE_DEAD */
+	atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1d3ad4..3a22eff 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1700,9 +1700,7 @@ typedef struct fc_port {
 	atomic_t state;
 	uint32_t flags;
 
-	int port_login_retry_count;
 	int login_retry;
-	atomic_t port_down_timer;
 
 	struct fc_rport *rport, *drport;
 	u32 supported_classes;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c8d0b12..8c48660 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2916,20 +2916,12 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 void
 qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	fcport->vha = vha;
 	fcport->login_retry = 0;
-	fcport->port_login_retry_count = ha->port_down_retry_count *
-	    PORT_RETRY_TIME;
-	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
-	    PORT_RETRY_TIME);
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
 	qla2x00_iidma_fcport(vha, fcport);
-
 	atomic_set(&fcport->state, FCS_ONLINE);
-
 	qla2x00_reg_remote_port(vha, fcport);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 318235f..9d248d0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3547,11 +3547,9 @@ void
 qla2x00_timer(scsi_qla_host_t *vha)
 {
 	unsigned long	cpu_flags = 0;
-	fc_port_t	*fcport;
 	int		start_dpc = 0;
 	int		index;
 	srb_t		*sp;
-	int		t;
 	uint16_t        w;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
@@ -3567,34 +3565,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	/* Hardware read to raise pending EEH errors during mailbox waits. */
 	if (!pci_channel_offline(ha->pdev))
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
-	/*
-	 * Ports - Port down timer.
-	 *
-	 * Whenever, a port is in the LOST state we start decrementing its port
-	 * down timer every second until it reaches zero. Once  it reaches zero
-	 * the port it marked DEAD.
-	 */
-	t = 0;
-	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (fcport->port_type != FCT_TARGET)
-			continue;
-
-		if (atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
-
-			if (atomic_read(&fcport->port_down_timer) == 0)
-				continue;
-
-			if (atomic_dec_and_test(&fcport->port_down_timer) != 0)
-				atomic_set(&fcport->state, FCS_DEVICE_DEAD);
-
-			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
-			    "%d remaining\n",
-			    vha->host_no,
-			    t, atomic_read(&fcport->port_down_timer)));
-		}
-		t++;
-	} /* End of for fcport  */
-
 
 	/* Loop down handler. */
 	if (atomic_read(&vha->loop_down_timer) > 0 &&
-- 
1.6.0.2

