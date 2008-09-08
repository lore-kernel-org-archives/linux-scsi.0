From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] mptfc: do not return host busy in queuecommand
Date: Mon,  8 Sep 2008 15:41:59 -0500
Message-ID: <1220906519-17649-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYIHUnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2008 16:43:00 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m88KgDpo012988
	for <linux-scsi@vger.kernel.org>; Mon, 8 Sep 2008 16:42:34 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88Kg2Op030498
	for <linux-scsi@vger.kernel.org>; Mon, 8 Sep 2008 16:42:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

This reverts
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git;a=commitdiff;h=d2dee934ea40e45135715d2d6ecc863af5620148

I goofed and meant to return SCSI_MLQUEUE_TARGET_BUSY but
wrote SCSI_MLQUEUE_HOST_BUSY. And actually when we are starting
up IO we do not want to reutrn either, because there will probably
not be any IO in the queue and we will have to wait for
the host/target_blocked counter to hit zero, before we can send IO.

This patch was made over scsi-post.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/message/fusion/mptfc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e9ab90f..c3c24fd 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -665,8 +665,11 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
-	if (unlikely(!ri))
-		return SCSI_MLQUEUE_HOST_BUSY;
+	if (unlikely(!ri)) {
+		SCpnt->result = DID_IMM_RETRY << 16;
+		done(SCpnt);
+		return 0;
+	}
 
 	return mptscsih_qcmd(SCpnt,done);
 }
-- 
1.5.5.1

