From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] scsi_lib: add NULL check to scsi_setup_blk_pc_cmnd
Date: Mon, 23 Jul 2012 13:32:20 -0400
Message-ID: <20120723173220.GA17767@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:50771 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2GWTJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2012 15:09:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

At least two slightly different paths can lead to a NULL pointer
dereference in scsi_prep_state_check and have been hit in practice.
1.
Call Trace:
 [<ffffffff812f8c4b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
 [<ffffffff81305108>] sd_prep_fn+0x568/0xdd0
 [<ffffffff8121c594>] blk_peek_request+0xb4/0x240
 [<ffffffff812f94fe>] scsi_request_fn+0x43e/0x4a0
 [<ffffffff8121621b>] __blk_run_queue+0x1b/0x20
 [<ffffffff81220638>] blk_execute_rq_nowait+0x68/0xc0
 [<ffffffff812206fd>] blk_execute_rq+0x6d/0x100
 [<ffffffff812f8f8c>] scsi_execute+0xfc/0x160
 [<ffffffff812f975a>] scsi_execute_req+0xca/0x140
 [<ffffffff81305a4e>] sd_revalidate_disk+0xde/0x1a00
 [<ffffffff8130749b>] sd_probe_async+0x12b/0x1d0
 ...
2.
Call Trace:
 [<ffffffff8130078b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
 [<ffffffff8130091d>] scsi_prep_fn+0x4d/0x60
 [<ffffffff81227794>] blk_peek_request+0xb4/0x240
 [<ffffffff813010cd>] scsi_request_fn+0x47d/0x4b0
 [<ffffffff81223bff>] __blk_run_queue+0x1f/0x80
 [<ffffffff8122b808>] blk_execute_rq_nowait+0x68/0xc0
 ...

This patch should fix both cases.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/scsi_lib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index bb216ff..5fb5a1c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1079,8 +1079,11 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
-	int ret = scsi_prep_state_check(sdev, req);
+	int ret;
 
+	if (!sdev)
+		return BLKPREP_KILL;
+	ret = scsi_prep_state_check(sdev, req);
 	if (ret != BLKPREP_OK)
 		return ret;
 
-- 
1.7.10.4

