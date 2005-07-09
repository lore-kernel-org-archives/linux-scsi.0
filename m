From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [KJ] [PATCH 11/14] scsi/lpfc_scsi: use msleep() instead of
	schedule_timeout()
Date: Fri, 8 Jul 2005 17:14:58 -0700
Message-ID: <20050709001458.GQ2596@us.ibm.com>
References: <20050709000324.GD2596@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============15674706287876861=="
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
To: James.Bottomley@SteelEye.com
Cc: Kernel-Janitors <kernel-janitors@lists.osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============15674706287876861==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Nishanth Aravamudan <nacc@us.ibm.com>

Description: Replace schedule_timeout() with msleep() to guarantee the
task delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 lpfc_scsi.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff -urp 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c
--- 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 07:57:19.000000000 -0700
+++ 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 19:20:41.000000000 -0700
@@ -24,6 +24,7 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -885,8 +886,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		while (cmnd->host_scribble)
 		{
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(LPFC_ABORT_WAIT*HZ);
+			msleep(LPFC_ABORT_WAIT * 1000);
 			spin_lock_irq(phba->host->host_lock);
 			if (++loop_count
 			    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
@@ -952,8 +952,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout( HZ/2);
+			msleep(500);
 			spin_lock_irq(phba->host->host_lock);
 		}
 		if ((pnode) && (pnode->nlp_state == NLP_STE_MAPPED_NODE))
@@ -1011,8 +1010,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 				       cmnd->device->id, cmnd->device->lun,
 				       LPFC_CTX_LUN))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * 1000);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
@@ -1110,8 +1108,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 				&phba->sli.ring[phba->sli.fcp_ring],
 				0, 0, LPFC_CTX_HOST))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * HZ);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt

--===============15674706287876861==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============15674706287876861==--
