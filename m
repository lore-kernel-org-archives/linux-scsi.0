From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 02/18] bnx2fc: Bug fixes in
 percpu_thread_create/destroy
Date: Thu, 4 Aug 2011 17:38:36 -0700
Message-ID: <1312504732-4572-3-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2238 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab1HEAjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:08 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Look up p->work_list to process cq completions, and correct the error check for
thread creation.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ea1e6cc..a4770d9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2122,7 +2122,7 @@ static void bnx2fc_percpu_thread_create(unsigned int cpu)
 				(void *)p,
 				"bnx2fc_thread/%d", cpu);
 	/* bind thread to the cpu */
-	if (likely(!IS_ERR(p->iothread))) {
+	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);
 		p->iothread = thread;
 		wake_up_process(thread);
@@ -2134,7 +2134,6 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 	struct bnx2fc_percpu_s *p;
 	struct task_struct *thread;
 	struct bnx2fc_work *work, *tmp;
-	LIST_HEAD(work_list);
 
 	BNX2FC_MISC_DBG("destroying io thread for CPU %d\n", cpu);
 
@@ -2146,7 +2145,7 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 
 
 	/* Free all work in the list */
-	list_for_each_entry_safe(work, tmp, &work_list, list) {
+	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
 		list_del_init(&work->list);
 		bnx2fc_process_cq_compl(work->tgt, work->wqe);
 		kfree(work);
-- 
1.7.0.6


