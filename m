From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [17/18] qla2xxx: Bus reset handler fixes
Date: Mon, 21 Jun 2004 23:01:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622060103.GA8531@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:7562 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266610AbUFVF5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:57:19 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1853 04/06/21 15:34:37 andrew.vasquez@apc.qlogic.com +1 -0
  Fix incorrect return-code check in bus-reset error handler.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_os.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:40:37 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:40:37 -07:00
@@ -147,7 +147,7 @@
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
-static uint8_t qla2x00_loop_reset(scsi_qla_host_t *ha);
+static int qla2x00_loop_reset(scsi_qla_host_t *ha);
 static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
 static int qla2x00_proc_info(struct Scsi_Host *, char *, char **,
@@ -1568,7 +1568,7 @@
 	}
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_loop_reset(ha)) 
+		if (qla2x00_loop_reset(ha) == QLA_SUCCESS) 
 			rval = SUCCESS;
 	}
 
@@ -1683,10 +1683,10 @@
 * Returns:
 *      0 = success
 */
-static uint8_t
+static int
 qla2x00_loop_reset(scsi_qla_host_t *ha)
 {
-	uint8_t  status = QLA_SUCCESS;
+	int status = QLA_SUCCESS;
 	uint16_t t;
 	os_tgt_t        *tq;
 
