From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 13/28] libsas: prevent double completion of scmds from eh
Date: Thu, 22 Dec 2011 18:59:36 -0800
Message-ID: <20111223025936.21827.3264.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10847 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1LWC7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 21:59:37 -0500
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

We invoke task->task_done() to free the task in the eh case, but at thi=
s
point we are prepared for scsi_eh_flush_done_q() to finish off the scmd=
=2E

Introduce sas_end_task() to capture the final response status from the
lldd and free the task.

Also take the opportunity to kill this warning.
drivers/scsi/libsas/sas_scsi_host.c: In function =E2=80=98sas_end_task=E2=
=80=99:
drivers/scsi/libsas/sas_scsi_host.c:102:3: warning: case value =E2=80=98=
2=E2=80=99 not in enumerated type =E2=80=98enum exec_status=E2=80=99 [-=
Wswitch]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   61 +++++++++++++++++++--------=
--------
 include/scsi/libsas.h               |    5 ++-
 2 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/=
sas_scsi_host.c
index 5e9fa99..6ee9826 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -49,27 +49,12 @@
 #include <linux/scatterlist.h>
 #include <linux/libata.h>
=20
-/* ---------- SCSI Host glue ---------- */
-
-static void sas_scsi_task_done(struct sas_task *task)
+/* record final status and free the task */
+static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 {
 	struct task_status_struct *ts =3D &task->task_status;
-	struct scsi_cmnd *sc =3D task->uldd_task;
 	int hs =3D 0, stat =3D 0;
=20
-	if (unlikely(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-		/* Aborted tasks will be completed by the error handler */
-		SAS_DPRINTK("task done but aborted\n");
-		return;
-	}
-
-	if (unlikely(!sc)) {
-		SAS_DPRINTK("task_done called with non existing SCSI cmnd!\n");
-		list_del_init(&task->list);
-		sas_free_task(task);
-		return;
-	}
-
 	if (ts->resp =3D=3D SAS_TASK_UNDELIVERED) {
 		/* transport error */
 		hs =3D DID_NO_CONNECT;
@@ -124,10 +109,32 @@ static void sas_scsi_task_done(struct sas_task *t=
ask)
 			break;
 		}
 	}
-	ASSIGN_SAS_TASK(sc, NULL);
+
 	sc->result =3D (hs << 16) | stat;
+	ASSIGN_SAS_TASK(sc, NULL);
 	list_del_init(&task->list);
 	sas_free_task(task);
+}
+
+static void sas_scsi_task_done(struct sas_task *task)
+{
+	struct scsi_cmnd *sc =3D task->uldd_task;
+
+	if (unlikely(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+		/* Aborted tasks will be completed by the error handler */
+		SAS_DPRINTK("task done but aborted\n");
+		return;
+	}
+
+	if (unlikely(!sc)) {
+		SAS_DPRINTK("task_done called with non existing SCSI cmnd!\n");
+		list_del_init(&task->list);
+		sas_free_task(task);
+		return;
+	}
+
+	ASSIGN_SAS_TASK(sc, NULL);
+	sas_end_task(sc, task);
 	sc->scsi_done(sc);
 }
=20
@@ -236,18 +243,16 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *c=
md)
 	struct sas_task *task =3D TO_SAS_TASK(cmd);
 	struct sas_ha_struct *sas_ha =3D SHOST_TO_SAS_HA(cmd->device->host);
=20
-	/* remove the aborted task flag to allow the task to be
-	 * completed now. At this point, we only get called following
-	 * an actual abort of the task, so we should be guaranteed not
-	 * to be racing with any completions from the LLD (hence we
-	 * don't need the task state lock to clear the flag) */
-	task->task_state_flags &=3D ~SAS_TASK_STATE_ABORTED;
-	/* Now call task_done.  However, task will be free'd after
-	 * this */
-	task->task_done(task);
+	/* At this point, we only get called following an actual abort
+	 * of the task, so we should be guaranteed not to be racing with
+	 * any completions from the LLD.  Task is freed after this.
+	 */
+	sas_end_task(cmd, task);
+
 	/* now finish the command and move it on to the error
 	 * handler done list, this also takes it off the
-	 * error handler pending list */
+	 * error handler pending list.
+	 */
 	scsi_eh_finish_cmd(cmd, &sas_ha->eh_done_q);
 }
=20
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index d100503..6e9ad20 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -447,7 +447,10 @@ enum service_response {
 };
=20
 enum exec_status {
-	/* The SAM_STAT_.. codes fit in the lower 6 bits */
+	/* The SAM_STAT_.. codes fit in the lower 6 bits, alias some of
+	 * them here to silence 'case value not in enumerated type' warnings
+	 */
+	__SAM_STAT_CHECK_CONDITION =3D SAM_STAT_CHECK_CONDITION,
=20
 	SAS_DEV_NO_RESPONSE =3D 0x80,
 	SAS_DATA_UNDERRUN,

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
