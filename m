From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/18]  qla2xxx: Correct residual counts
Date: Mon, 21 Jun 2004 22:49:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622054946.GA8392@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:36549 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266589AbUFVFqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:46:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1838 04/06/03 15:24:43 andrew.vasquez@apc.qlogic.com +2 -0
  Problem reported/corrected by Tony Battersby [tonyb@cybernetics.com]:
  
  o The qla2xxx driver calculates data transfer residuals
    for some but not all circumstances.  The patch below
    adds data transfer residual calculations for the
    remaining cases.
  
  o Interrogate the proper cmnd[] array when determining
    the transfer direction.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |   13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00
@@ -43,7 +43,7 @@
 	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		cflags = CF_READ;
 	else {
-		switch (cmd->data_cmnd[0]) {
+		switch (cmd->cmnd[0]) {
 		case WRITE_6:
 		case WRITE_10:
 		case WRITE_12:
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:36:37 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:36:37 -07:00
@@ -827,7 +827,7 @@
 	uint16_t	comp_status;
 	uint16_t	scsi_status;
 	uint8_t		lscsi_status;
-	uint32_t	resid;
+	int32_t		resid;
 	uint8_t		sense_sz = 0;
 	uint16_t	rsp_info_len;
 
@@ -948,6 +948,11 @@
 			cp->result = DID_OK << 16;
 			break;
 		}
+		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
+			resid = le32_to_cpu(pkt->residual_length);
+			cp->resid = resid;
+			CMD_RESID_LEN(cp) = resid;
+		}
 		if (lscsi_status == SS_BUSY_CONDITION) {
 			cp->result = DID_BUS_BUSY << 16 | lscsi_status;
 			break;
@@ -1009,7 +1014,10 @@
 		    ha->host_no, t, l, comp_status, scsi_status));
 
 		resid = le32_to_cpu(pkt->residual_length);
-		CMD_RESID_LEN(cp) = resid;
+		if (scsi_status & SS_RESIDUAL_UNDER) {
+			cp->resid = resid;
+			CMD_RESID_LEN(cp) = resid;
+		}
 
 		/*
 		 * Check to see if SCSI Status is non zero. If so report SCSI 
@@ -1085,7 +1093,6 @@
 			}
 
 			/* Handle mid-layer underflow */
-			cp->resid = resid;
 			if ((unsigned)(cp->request_bufflen - resid) <
 			    cp->underflow) {
 				qla_printk(KERN_INFO, ha,
