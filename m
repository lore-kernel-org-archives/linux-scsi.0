From: Bill Kuzeja <William.Kuzeja@stratus.com>
Subject: [PATCH] qla2xxx: Fix extraneous ref on sp's after adapter break
Date: Thu, 25 May 2017 15:26:31 -0400
Message-ID: <1495740391-33124-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us-smtp-delivery-131.mimecast.com ([63.128.21.131]:32076 "EHLO
        us-smtp-delivery-131.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757921AbdEYTdD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 May 2017 15:33:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com

Hung task timeouts can result if a qlogic board breaks unexpectedly while
running I/O. These tasks become hung because command srb reference counts
are not going to zero, hence the affected srbs and commands do not get 
freed. This fix accounts for this extra reference in the srbs in the case 
of a board failure. 

Fixes: a465537ad1a4 ("qla2xxx: Disable the adapter and skip error recovery in case of register disconnect")
Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
---

I encountered this hang during by adapter break testing (on Stratus
hardware, we need to survive adapter breaks). I noticed that we wait
indefinitely for several commands which all have outstanding
references to them, but which have all followed this code path:

qla2x00_abort_all_cmds
   qla2xxx_eh_abort
       Exit early because qla2x00_isp_reg_stat is non-zero.

Note that before calling qla2xxx_eh_abort from this path, we do an extra
sp_get(sp), which takes out another reference on the current sp. If we
do not early exit immediately from qla2xxx_eh_abort, we'll get rid of this
extra reference through the abort - which is the normal case.

However, if we exit immediately, this extra sp_get is never dereferenced.
Each one of the commands flowing through this code will be stuck forever,
resulting in hung tasks.

This early exit in qla2xxx_eh_abort was introduced by this commit:

commit a465537ad1a4 ("qla2xxx: Disable the adapter and skip error recovery in case of register disconnect.")

The solution for this is somewhat tricky because qla2xxx_eh_abort can be
invoked from the scsi error handler as well as qla2x00_abort_all_cmds.
I originally thought of having qla2xxx_eh_abort remove the extra reference
before early exiting, but not knowing the context of its invocation,
this seemed dangerous.

Alternatively we could also just remove the early exit case from
qla2xxx_eh_abort, but the aforementioned commit was put in for a reason, so 
that doesn't seem correct either.

The right thing to do seems to be putting the fix in qla2x00_abort_all_cmds,
checking the conditions we where we have exited early from qla2xxx_eh_abort
before removing the extra reference.

---
 drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c79579..1a93365 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1632,7 +1632,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
-	int que, cnt;
+	int que, cnt, status;
 	unsigned long flags;
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -1662,8 +1662,12 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 					 */
 					sp_get(sp);
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					status = qla2xxx_eh_abort(GET_CMD_SP(sp));
 					spin_lock_irqsave(&ha->hardware_lock, flags);
+					/* Get rid of extra reference if immediate exit
+					 * from ql2xxx_eh_abort */
+					if (status == FAILED && (qla2x00_isp_reg_stat(ha)))
+						atomic_dec(&sp->ref_count);
 				}
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(sp, res);
-- 
1.8.3.1
