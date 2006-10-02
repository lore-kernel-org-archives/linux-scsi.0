From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport is blocked.
Date: Mon,  2 Oct 2006 12:00:49 -0700
Message-ID: <11598156511007-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964966AbWJBTAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:55 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Stall error handler if attempting recovery while an rport is
blocked.  This avoids device offline scenarios due to errors in
the error handler.

Reference implementation from lpfc/mptfc.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cdc7fca..3ba8c23 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -589,6 +589,23 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 	return (return_status);
 }
 
+static void
+qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		msleep(1000);
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return;
+}
+
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -615,6 +632,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int wait = 0;
 
+	qla2x00_block_error_handler(cmd);
+
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
@@ -748,6 +767,8 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	unsigned int id, lun;
 	unsigned long serial;
 
+	qla2x00_block_error_handler(cmd);
+
 	ret = FAILED;
 
 	id = cmd->device->id;
@@ -877,6 +898,8 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	unsigned int id, lun;
 	unsigned long serial;
 
+	qla2x00_block_error_handler(cmd);
+
 	ret = FAILED;
 
 	id = cmd->device->id;
@@ -936,6 +959,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	unsigned int id, lun;
 	unsigned long serial;
 
+	qla2x00_block_error_handler(cmd);
+
 	ret = FAILED;
 
 	id = cmd->device->id;
-- 
1.4.2.3.gf59615

