From: domen@coderock.org
Subject: [patch 1/1] scsi/qla2xxx: use msleep{, interruptible}() instead of schedule_timeout()
Date: Thu, 14 Jul 2005 23:43:14 +0200
Message-ID: <20050714214313.644836000@homer>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:65184 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S263148AbVGNVnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 17:43:35 -0400
Content-Disposition: inline; filename=msleep-drivers_scsi_qla2xxx_qla_os
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>, domen@coderock.org

From: Nishanth Aravamudan <nacc@us.ibm.com>


From: Nishanth Aravamudan <nacc@us.ibm.com>

Replace schedule_timeout() with
msleep()/msleep_interruptible() as appropriate, to guarantee the task
delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>

---
 qla_os.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

Index: quilt/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- quilt.orig/drivers/scsi/qla2xxx/qla_os.c
+++ quilt/drivers/scsi/qla2xxx/qla_os.c
@@ -347,14 +347,13 @@ qc_fail_command:
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
@@ -1693,7 +1692,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	unsigned long	wtime;/* max wait time if mbx cmd is busy. */
+	unsigned int	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
 		/* error */
@@ -1702,11 +1701,9 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
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
@@ -2250,15 +2247,15 @@ qla2x00_timer(scsi_qla_host_t *ha)
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
