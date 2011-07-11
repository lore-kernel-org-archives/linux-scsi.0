From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Fixed kernel panic due to illegal usage of
 sc->request->cpu
Date: Mon, 11 Jul 2011 11:14:55 -0700
Message-ID: <1310408095-11882-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3243 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504Ab1GKSPV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 14:15:21 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

A kernel panic was observed when passing the sc->request->cpu = -1 to
retrieve the per_cpu variable pointer:
 #0 [ffff880011203960] machine_kexec at ffffffff81022bc3
 #1 [ffff8800112039b0] crash_kexec at ffffffff81088630
 #2 [ffff880011203a80] __die at ffffffff8139ea20
 #3 [ffff880011203aa0] no_context at ffffffff8102f3a7
 #4 [ffff880011203ae0] __bad_area_nosemaphore at ffffffff8102f665
 #5 [ffff880011203ba0] retint_signal at ffffffff8139dd1f
 #6 [ffff880011203cc8] bnx2i_indicate_kcqe at ffffffffa03dc4f2
 #7 [ffff880011203da8] service_kcqes at ffffffffa03cb04f
 #8 [ffff880011203e68] cnic_service_bnx2x_kcq at ffffffffa03cb14a
 #9 [ffff880011203e88] cnic_service_bnx2x_bh at ffffffffa03cb1b3

The problem lies in the sg_io (and perhaps sg_scsi_ioctl) call to
blk_get_request->get_request/wait->blk_alloc_request->blk_rq_init which
re-initializes the request->cpu to -1.  There is no assignment for cpu from
that to the request_fn call to low level drivers.

When this happens, the sc->request->cpu will be using the init value of
-1.  This will create a kernel panic when it hits bnx2i because the code
refers it to get the per_cpu variables ptr.

This change is to put in a guard against that and also for cases when
CONFIG_SMP/BIO_CPU_AFFINE is not enabled.  In those cases, the cpu
affinitization code would not get run in __make_request either; hence
the request->cpu will remain a -1 also.

This bug was created from commit:  b5cf6b63f73abdc051035f0050b367beeb2ef94c

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 5c55a75..622383d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1225,6 +1225,10 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 	if (!sc)
 		return bnx2i_mtask_xmit(conn, task);
 
+	if (!blk_rq_cpu_valid(sc->request)) {
+		sc->request->cpu = get_cpu();
+		put_cpu();
+	}
 	bnx2i_setup_cmd_wqe_template(cmd);
 	cmd->req.op_code = ISCSI_OP_SCSI_CMD;
 	cmd->conn = bnx2i_conn;
-- 
1.7.0.5


