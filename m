From: Bill Kuzeja <William.Kuzeja@stratus.com>
Subject: [PATCH] qla2xxx: Fix scsi scan hang triggered if adapter fails during init
Date: Fri, 21 Oct 2016 16:45:27 -0400
Message-ID: <1477082727-29137-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s12p02o149.mxlogic.net ([208.65.145.72]:41200 "EHLO
        s12p02o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbcJUUyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 16:54:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, Bill Kuzeja <William.Kuzeja@stratus.com>

A system can get hung task timeouts if a qlogic board fails during
initialization (if the board breaks again or fails the init). The hang
involves the scsi scan.

In a nutshell, since commit beb9e315e6e0 ("qla2xxx: Prevent removal and
board_disable race"):

...it is possible to have freed ha (base_vha->hw) early by a call to
qla2x00_remove_one when pdev->enable_cnt equals zero:

       if (!atomic_read(&pdev->enable_cnt)) {
               scsi_host_put(base_vha->host);
               kfree(ha);
               pci_set_drvdata(pdev, NULL);
               return;

Almost always, the scsi_host_put above frees the vha structure
(attached to the end of the Scsi_Host we're putting) since it's the
last put, and life is good.  However, if we are entering this routine
because the adapter has broken sometime during initialization AND a
scsi scan is already in progress (and has done its own scsi_host_get),
vha will not be freed. What's worse, the scsi scan will access
the freed ha structure through qla2xxx_scan_finished:

        if (time > vha->hw->loop_reset_delay * HZ)
                return 1;

The scsi scan keeps checking to see if a scan is complete by calling
qla2xxx_scan_finished. There is a timeout value that limits the length
of time a scan can take (hw->loop_reset_delay, usually set to 5
seconds), but this definition is in the data structure (hw) that can
get freed early.

This can yield unpredictable results, the worst of which is that the
scsi scan can hang indefinitely. This happens when the freed structure
gets reused and loop_reset_delay gets overwritten with garbage, which
the scan obliviously uses as its timeout value.

The fix for this is simple: at the top of qla2xxx_scan_finished, check
for the UNLOADING bit in the vha structure (_vha is not freed
at this point).  If UNLOADING is set, we exit the scan for this adapter
immediately. After this last reference to the ha structure, we'll exit
the scan for this adapter, and continue on.

This problem is hard to hit, but I have run into it doing negative
testing many times now (with a test specifically designed to bring it
out), so I can verify that this fix works. My testing has been against
a RHEL7 driver variant, but the bug and patch are equally relevant to
to the upstream driver.

Fixes: beb9e315e6e0 ("qla2xxx: Prevent removal and board_disable race")
Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ace65db..4d99c3b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2341,6 +2341,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return 1;
 	if (!vha->host)
 		return 1;
 	if (time > vha->hw->loop_reset_delay * HZ)
-- 
1.8.3.1

