From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/11] scsi/fcoe: lock online CPUs in fcoe_percpu_clean()
Date: Fri, 11 Mar 2016 16:28:53 +0100
Message-ID: <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37929 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbcCKP30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:26 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

for_each_possible_cpu() with a cpu_online() + `thread' check possibly does
the job. But there is a tiny race: Say CPU5 is reported online but is
going down. And after fcoe_percpu_clean() saw that CPU5 is online it
decided to enqueue a packet. After dev_alloc_skb() returned a skb
that CPU is offline (or say the notifier destroyed the kthread). So we
would OOps because `thread' is NULL.
An alternative would be to lock the CPUs during our loop (so no CPU is
going away) and then we iterate over the online mask.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0efe7112fc1f..2b0d207f4b2b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2461,12 +2461,10 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 	struct sk_buff *skb;
 	unsigned int cpu;
 
-	for_each_possible_cpu(cpu) {
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
 		pp = &per_cpu(fcoe_percpu, cpu);
 
-		if (!pp->thread || !cpu_online(cpu))
-			continue;
-
 		skb = dev_alloc_skb(0);
 		if (!skb)
 			continue;
@@ -2481,6 +2479,7 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 
 		wait_for_completion(&fcoe_flush_completion);
 	}
+	put_online_cpus();
 }
 
 /**
-- 
2.7.0

