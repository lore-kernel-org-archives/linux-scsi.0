From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [1/3]   qla2xxx: remove internal queuing.
Date: Fri, 04 Feb 2005 13:52:40 -0800
Message-ID: <1107553960.15462.1.camel@plap.san.rr.com>
References: <1107544908.14183.11.camel@plap.san.rr.com>
	 <1107545071.14183.15.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch02.qlogic.com ([198.70.193.200]:9533 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S266084AbVBDVwX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 16:52:23 -0500
In-Reply-To: <1107545071.14183.15.camel@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: andrew.vasquez@qlogic.com

Small incremental patch which fixes some annoyances sighted by Christoph
Hellwig.

      * Correct backing-out of msleep() calls 
      * remove superfluous return in qla2xxx_slave_destroy.


Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>


===== drivers/scsi/qla2xxx/qla_os.c 1.56 vs edited =====
--- 1.56/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 10:24:28 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 13:26:23 -08:00
@@ -467,8 +467,7 @@ qla2x00_wait_for_hba_online(scsi_qla_hos
 	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
 	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ);
+		msleep(1000);
 	}
 	if (ha->flags.online) 
 		return_status = QLA_SUCCESS; 
@@ -509,8 +508,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
 	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ);
+		msleep(1000);
 		if (time_after_eq(jiffies, loop_timeout)) {
 			return_status = QLA_FUNCTION_FAILED;
 			break;
@@ -1064,7 +1062,6 @@ static void
 qla2xxx_slave_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata = NULL;
-	return;
 }
 
 /**

