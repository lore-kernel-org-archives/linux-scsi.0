From: <kgudipat@brocade.com>
Subject: [PATCH 2/9] bfa: Modify ISR to process pending completions
Date: Tue, 13 Mar 2012 17:38:15 -0700
Message-ID: <1331685495-21139-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34860 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759598Ab2CNAi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 20:38:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to the driver ISR to process any pending completions even if
	  the RME bit is not set in the interrupt status register.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 4bd546b..035c9d5 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -231,16 +231,19 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 	}
 }
 
-static inline void
+bfa_boolean_t
 bfa_isr_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
 	u32	pi, ci;
 	struct list_head *waitq;
+	bfa_boolean_t ret;
 
 	ci = bfa_rspq_ci(bfa, qid);
 	pi = bfa_rspq_pi(bfa, qid);
 
+	ret = (ci != pi);
+
 	while (ci != pi) {
 		m = bfa_rspq_elem(bfa, qid, ci);
 		WARN_ON(m->mhdr.msg_class >= BFI_MC_MAX);
@@ -260,6 +263,8 @@ bfa_isr_rspq(struct bfa_s *bfa, int qid)
 	waitq = bfa_reqq(bfa, qid);
 	if (!list_empty(waitq))
 		bfa_reqq_resume(bfa, qid);
+
+	return ret;
 }
 
 static inline void
@@ -320,6 +325,7 @@ bfa_intx(struct bfa_s *bfa)
 {
 	u32 intr, qintr;
 	int queue;
+	bfa_boolean_t rspq_comp = BFA_FALSE;
 
 	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 
@@ -332,11 +338,12 @@ bfa_intx(struct bfa_s *bfa)
 	 */
 	if (bfa->queue_process) {
 		for (queue = 0; queue < BFI_IOC_MAX_CQS; queue++)
-			bfa_isr_rspq(bfa, queue);
+			if (bfa_isr_rspq(bfa, queue))
+				rspq_comp = BFA_TRUE;
 	}
 
 	if (!intr)
-		return BFA_TRUE;
+		return (qintr | rspq_comp) ? BFA_TRUE : BFA_FALSE;
 
 	/*
 	 * CPE completion queue interrupt
-- 
1.7.3.rc1

