From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/6] bnx2fc: use kthread_create_on_node
Date: Mon, 4 Jun 2012 16:15:42 -0700
Message-ID: <1338851747-7240-2-git-send-email-bprakash@broadcom.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3583 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761185Ab2FDXQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2012 19:16:03 -0400
In-Reply-To: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Eric Dumazet <eric.dumazet@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Eric Dumazet <eric.dumazet@gmail.com>

Since bnx2fc_percpu_thread_create() creates percpu kthread, it makes
sense to use kthread_create_on_node() to get proper NUMA affinity for
kthread stack.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f52f668..dd28af7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2290,9 +2290,9 @@ static void bnx2fc_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(bnx2fc_percpu, cpu);
 
-	thread = kthread_create(bnx2fc_percpu_io_thread,
-				(void *)p,
-				"bnx2fc_thread/%d", cpu);
+	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
+					(void *)p, cpu_to_node(cpu),
+					"bnx2fc_thread/%d", cpu);
 	/* bind thread to the cpu */
 	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);
-- 
1.7.0.6


