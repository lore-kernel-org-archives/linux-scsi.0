From: <nilesh.javali@qlogic.com>
Subject: [PATCH 1/2] bnx2i: Fixed firmware assert, during target logout.
Date: Tue, 19 May 2015 05:51:57 -0400
Message-ID: <1432029118-25867-1-git-send-email-nilesh.javali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13691 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbbESKgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 06:36:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: nilesh.javali@qlogic.com, giridhar.malavali@qlogic.com, QLogic-Storage-Upstream@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Fix the firmware assert, during target logout in
case driver received FIN from target before waiting for
asyncronous response.

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index e53078d..1b8a971 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2093,7 +2093,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	else
 		/* wait for option-2 conn teardown */
 		wait_event_interruptible(bnx2i_ep->ofld_wait,
-				 bnx2i_ep->state != EP_STATE_DISCONN_START);
+				((bnx2i_ep->state != EP_STATE_DISCONN_START)
+				&& (bnx2i_ep->state != EP_STATE_TCP_FIN_RCVD)));
 
 	if (signal_pending(current))
 		flush_signals(current);
-- 
1.8.2.GIT

