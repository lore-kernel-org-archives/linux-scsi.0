From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/18] qla2xxx: prevent bounds-check bypass via speculative
 execution
Date: Fri, 05 Jan 2018 17:10:48 -0800
Message-ID: <151520104838.32271.7038801336240727574.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, peterz@infradead.org, netdev@vger.kernel.org, qla2xxx-upstream@qlogic.com, tglx@linutronix.de, torvalds@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Static analysis reports that 'handle' may be a user controlled value
that is used as a data dependency to read 'sp' from the
'req->outstanding_cmds' array.  In order to avoid potential leaks of
kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid value of 'sp'. In this
case 'sp' is directly dereferenced later in the function.

Based on an original patch by Elena Reshetova.

Cc: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d5da3981cefe..128b41de3784 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -9,6 +9,7 @@
 #include <linux/ktime.h>
 #include <linux/pci.h>
 #include <linux/ratelimit.h>
+#include <linux/compiler.h>
 #include <linux/vmalloc.h>
 #include <linux/bsg-lib.h>
 #include <scsi/scsi_tcq.h>
@@ -2275,7 +2276,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 static void
 qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 {
-	srb_t		*sp;
+	srb_t		*sp, **elem;
 	fc_port_t	*fcport;
 	struct scsi_cmnd *cp;
 	struct sts_entry_fx00 *sts;
@@ -2304,8 +2305,9 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	req = ha->req_q_map[que];
 
 	/* Validate handle. */
-	if (handle < req->num_outstanding_cmds)
-		sp = req->outstanding_cmds[handle];
+	if ((elem = nospec_array_ptr(req->outstanding_cmds, handle,
+					req->num_outstanding_cmds)))
+		sp = *elem;
 	else
 		sp = NULL;
 
@@ -2626,7 +2628,7 @@ static void
 qlafx00_multistatus_entry(struct scsi_qla_host *vha,
 	struct rsp_que *rsp, void *pkt)
 {
-	srb_t		*sp;
+	srb_t		*sp, **elem;
 	struct multi_sts_entry_fx00 *stsmfx;
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t handle, hindex, handle_count, i;
@@ -2655,8 +2657,9 @@ qlafx00_multistatus_entry(struct scsi_qla_host *vha,
 		req = ha->req_q_map[que];
 
 		/* Validate handle. */
-		if (handle < req->num_outstanding_cmds)
-			sp = req->outstanding_cmds[handle];
+		if ((elem = nospec_array_ptr(req->outstanding_cmds, handle,
+						req->num_outstanding_cmds)))
+			sp = *elem;
 		else
 			sp = NULL;
 
