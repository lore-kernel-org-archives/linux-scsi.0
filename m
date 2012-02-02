From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] bnx2i: use kthread_create_on_node()
Date: Thu, 02 Feb 2012 14:03:22 +0100
Message-ID: <1328187802.2279.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37685 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2BBND0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2012 08:03:26 -0500
Received: by wics10 with SMTP id s10so1732255wic.19
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2012 05:03:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, Benjamin Li <benli@broadcom.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

bnx2i_percpu_thread_create() create per cpu kthread, and should use
proper NUMA aware API.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: Benjamin Li <benli@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 1a947f1..62c8c0a 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -393,8 +393,9 @@ static void bnx2i_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(bnx2i_percpu, cpu);
 
-	thread = kthread_create(bnx2i_percpu_io_thread, (void *)p,
-				"bnx2i_thread/%d", cpu);
+	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
+					cpu_to_node(cpu),
+					"bnx2i_thread/%d", cpu);
 	/* bind thread to the cpu */
 	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);


