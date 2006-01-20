From: andrew.vasquez@qlogic.com
Subject: [PATCH 2/3] qla2xxx: Correct issue where the rport's upcall was not being made after relogin.
Date: Fri, 20 Jan 2006 14:53:19 -0800
Message-ID: <11377975941332-git-send-email-andrew.vasquez@qlogic.com>
References: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33457 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932262AbWATWxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 17:53:20 -0500
In-Reply-To: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mdr@sgi.com
Cc: andrew.vasquez@qlogic.com

A target can LOGO an initiator at any time (i.e. during I/O,
due to a controller hicup, or as a simple authentication
mechanism after an initial CDB command), when this occurs,
the driver attempts to relogin (PLOGI) to the device via the
DPC thread.  Add code to make the appropriate upcall to the
FC transport layer (fc_remote_port_add()) upon successful
completion of the PLOGI.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    3 +--
 drivers/scsi/qla2xxx/qla_os.c   |    9 ++-------
 3 files changed, 4 insertions(+), 9 deletions(-)

139779240d1bebb1ddbdfb4289a7e3ebb558fb7d
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0c1ec14..35266bd 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -51,6 +51,7 @@ extern void qla2x00_update_fcports(scsi_
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
+extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c7caec..16c8892 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -32,7 +32,6 @@ static int qla2x00_fw_ready(scsi_qla_hos
 static int qla2x00_configure_hba(scsi_qla_host_t *);
 static int qla2x00_configure_loop(scsi_qla_host_t *);
 static int qla2x00_configure_local_loop(scsi_qla_host_t *);
-static void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_configure_fabric(scsi_qla_host_t *);
 static int qla2x00_find_all_fabric_devs(scsi_qla_host_t *, struct list_head *);
 static int qla2x00_device_resync(scsi_qla_host_t *);
@@ -2039,7 +2038,7 @@ qla2x00_probe_for_all_luns(scsi_qla_host
  * Context:
  *	Kernel context.
  */
-static void
+void
 qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	uint16_t	index;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 089e0f5..5866a7c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2250,13 +2250,8 @@ qla2x00_do_dpc(void *data)
 						DEBUG(printk("scsi(%ld): port login OK: logged in ID 0x%x\n",
 						    ha->host_no, fcport->loop_id));
 
-						fcport->port_login_retry_count =
-						    ha->port_down_retry_count * PORT_RETRY_TIME;
-						atomic_set(&fcport->state, FCS_ONLINE);
-						atomic_set(&fcport->port_down_timer,
-						    ha->port_down_retry_count * PORT_RETRY_TIME);
-
-						fcport->login_retry = 0;
+						qla2x00_update_fcport(ha,
+						    fcport);
 					} else if (status == 1) {
 						set_bit(RELOGIN_NEEDED, &ha->dpc_flags);
 						/* retry the login again */
-- 
1.1.4.ge755


