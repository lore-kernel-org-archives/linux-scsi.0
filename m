From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Don't schedule the DPC routine to perform an issue-lip request.
Date: Thu, 17 Jan 2008 09:02:12 -0800
Message-ID: <1200589340-19499-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYAQRCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:33 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

As the driver depends on the DPC routine to handle bottom-half
loop resynchronization in order to recover from the issue-lip
request.  The issue_lip call is sleeping context capable, so just
issue the reset function there.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 ++
 drivers/scsi/qla2xxx/qla_os.c   |    3 +--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e3bda8f..22b3868 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -958,7 +958,7 @@ qla2x00_issue_lip(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = shost_priv(shost);
 
-	set_bit(LOOP_RESET_NEEDED, &ha->dpc_flags);
+	qla2x00_loop_reset(ha);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5b381dc..f6917b9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -65,6 +65,8 @@ extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
 extern int num_hosts;
 
+extern int qla2x00_loop_reset(scsi_qla_host_t *);
+
 /*
  * Global Functions in qla_mid.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ab7abe0..bb2d3d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -105,7 +105,6 @@ static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
-static int qla2x00_loop_reset(scsi_qla_host_t *ha);
 static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
@@ -1060,7 +1059,7 @@ eh_host_reset_lock:
 * Returns:
 *      0 = success
 */
-static int
+int
 qla2x00_loop_reset(scsi_qla_host_t *ha)
 {
 	int ret;
-- 
1.5.4.rc3.14.g44397

