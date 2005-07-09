From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [KJ] [PATCH 13/14] scsi/qla2xxx: use msleep{,
	interruptible}() instead of schedule_timeout()
Date: Fri, 8 Jul 2005 17:16:20 -0700
Message-ID: <20050709001620.GS2596@us.ibm.com>
References: <20050709000324.GD2596@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============20391982447031998=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20050709000324.GD2596@us.ibm.com>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: andrew.vasquez@qlogic.com
Cc: Kernel-Janitors <kernel-janitors@lists.osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============20391982447031998==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Nishanth Aravamudan <nacc@us.ibm.com>

Description: Replace schedule_timeout() with
msleep()/msleep_interruptible() as appropriate, to guarantee the task
delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 qla_os.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff -urp 2.6.13-rc2-kj/drivers/scsi/qla2xxx/qla_os.c 2.6.13-rc2-kj-dev/drivers/scsi/qla2xxx/qla_os.c
--- 2.6.13-rc2-kj/drivers/scsi/qla2xxx/qla_os.c	2005-07-08 13:01:12.000000000 -0700
+++ 2.6.13-rc2-kj-dev/drivers/scsi/qla2xxx/qla_os.c	2005-07-06 19:27:01.000000000 -0700
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

--===============20391982447031998==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============20391982447031998==--
