From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/16] qla2xxx: Replace schedule_timeout().
Date: Fri, 26 Aug 2005 19:10:10 -0700 (PDT)
Message-ID: <20050827021010.27275.75380.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42600 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751623AbVH0CKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:10:11 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Replace schedule_timeout().
From: Nishanth Aravamudan <nacc@us.ibm.com>
Date: 1125377408 -0700

Replace schedule_timeout() with
msleep()/msleep_interruptible() as appropriate, to guarantee the task
delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

e7a48fd7d795d483405f7b30990e3745a2668288
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -502,14 +502,13 @@ qc24_fail_command:
 static int
 qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
 {
-#define ABORT_POLLING_PERIOD	HZ
-#define ABORT_WAIT_ITER		((10 * HZ) / (ABORT_POLLING_PERIOD))
+#define ABORT_POLLING_PERIOD	1000
+#define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	int ret = QLA_SUCCESS;
 
 	while (CMD_SP(cmd)) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(ABORT_POLLING_PERIOD);
+		msleep(ABORT_POLLING_PERIOD);
 
 		if (--wait_iter)
 			break;
@@ -1960,7 +1959,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	unsigned long	wtime;/* max wait time if mbx cmd is busy. */
+	unsigned int	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
 		/* error */
@@ -1969,11 +1968,9 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	}
 
 	/* Make sure all other threads are stopped. */
-	wtime = 60 * HZ;
-	while (ha->dpc_wait && wtime) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		wtime = schedule_timeout(wtime);
-	}
+	wtime = 60 * 1000;
+	while (ha->dpc_wait && wtime)
+		wtime = msleep_interruptible(wtime);
 
 	/* free ioctl memory */
 	qla2x00_free_ioctl_mem(ha);
@@ -2504,15 +2501,15 @@ qla2x00_timer(scsi_qla_host_t *ha)
 int
 qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
 {
-	const unsigned int step = HZ/10;
+	const unsigned int step = 100; /* msecs */
+	unsigned int iterations = jiffies_to_msecs(timeout)/100;
 
 	do {
 		if (!down_trylock(sema))
 			return 0;
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (schedule_timeout(step))
+		if (msleep_interruptible(step))
 			break;
-	} while ((timeout -= step) > 0);
+	} while (--iterations >= 0);
 
 	return -ETIMEDOUT;
 }

-- 
Andrew Vasquez
