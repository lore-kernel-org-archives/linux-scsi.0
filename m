From: andrew.vasquez@qlogic.com
Subject: [PATCH 14/15] qla2xxx: Disable port-type RSCN handling via driver state-machine.
Date: Fri, 13 Jan 2006 17:05:58 -0800
Message-ID: <11372007531330-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9254 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945939AbWANBF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:59 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Given the semantic changes in both the device-model and
fc-transport APIs, the driver's handling of port-type RSCNs
via a series of ADISCs and PLOGIs can cause series of
badness ranging from unexpectedly device loss to devices not
being discovered.

In the interim, disable (via a module-parameter) this
feature and allow RSCN management to continue to occur
within the driver's DPC thread.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 drivers/scsi/qla2xxx/qla_isr.c  |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c   |    6 ++++++
 4 files changed, 11 insertions(+), 2 deletions(-)

5c8a3bc356e1b56bfbb6ae25f67c22adc134e353
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7872c11..32be4c1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,6 +62,7 @@ extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
+extern int ql2xprocessrscn;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8635bd1..a91fea6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2653,7 +2653,8 @@ qla2x00_device_resync(scsi_qla_host_t *h
 
 		switch (format) {
 		case 0:
-			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
+			if (ql2xprocessrscn &&
+			    !IS_QLA2100(ha) && !IS_QLA2200(ha) &&
 			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
 			    !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 			    ha->flags.init_done) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8a539dd..f63af08 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -519,7 +519,8 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		 * us, create a new entry in our rscn fcports list and handle
 		 * the event like an RSCN.
 		 */
-		if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
+		if (ql2xprocessrscn &&
+		    !IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
 		    !IS_QLA6322(ha) && !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 		    ha->flags.init_done && mb[1] != 0xffff &&
 		    ((ha->operating_mode == P2P && mb[1] != 0) ||
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2430430..4916847 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -71,6 +71,12 @@ MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registratons "
 		"Default is 0 - no FDMI. 1 - perfom FDMI.");
 
+int ql2xprocessrscn;
+module_param(ql2xprocessrscn, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xprocessrscn,
+		"Option to enable port RSCN handling via a series of less"
+		"fabric intrusive ADISCs and PLOGIs.");
+
 /*
  * SCSI host template entry points
  */
-- 
1.1.1-g4c34


