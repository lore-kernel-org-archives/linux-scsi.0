From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Thu, 14 Jan 2016 16:46:02 -0500
Message-ID: <20160114214602.GC3520@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:36279 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbcANVqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2016 16:46:04 -0500
Received: by mail-yk0-f172.google.com with SMTP id v14so429167638ykd.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2016 13:46:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

SCSI command completion path bumps ioerr_cnt whenever scsi_cmd->result
isn't zero; unfortunately, this means that non-error sense reporting
bumps the counter too.  This is pronounced with ATA passthrough
commands because most of them explicitly request the resulting
taskfile to be transported via sense data bumping the count
unconditionally.

Don't bump the counter if scsi_cmd->result simply indicates that sense
data is available.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <dsj@fb.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa6b2c4..e90e3f7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1622,7 +1622,8 @@ static void scsi_softirq_done(struct request *rq)
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	atomic_inc(&cmd->device->iodone_cnt);
-	if (cmd->result)
+	if (cmd->result &&
+	    cmd->result != ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION))
 		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
