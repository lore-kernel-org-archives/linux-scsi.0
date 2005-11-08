From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/5]  qla2xxx: Correct abort issue during loop-down state.
Date: 8 Nov 2005 14:37:34 -0800
Message-ID: <20051108223730.25189.28174.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46157 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030372AbVKHWhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:37:34 -0500
In-Reply-To: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Correct issue where abort I/O command was not being issued
when the loop-state was down.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_mbx.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

applies-to: febf2a72fcf76529105e8ab310eab3a2acc28a03
9d259fa1908df5e1e912c5d0af904e19481f856f
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0e963bf..9746cd1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -868,10 +868,6 @@ qla2x00_abort_command(scsi_qla_host_t *h
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no);)
 
 	fcport = sp->fcport;
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
-	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
-		return 1;
-	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
@@ -2181,10 +2177,6 @@ qla24xx_abort_command(scsi_qla_host_t *h
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
 	fcport = sp->fcport;
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
-	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
-		return QLA_FUNCTION_FAILED;
-	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
---
0.99.9.GIT

-- 
Andrew Vasquez
