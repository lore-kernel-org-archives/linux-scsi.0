From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 1/6] fcoe: use kthread_create_on_node
Date: Tue, 27 Sep 2011 21:37:52 -0700
Message-ID: <20110928043752.13004.68048.stgit@localhost6.localdomain6>
References: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33150 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1I1ErD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:47:03 -0400
In-Reply-To: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neerav Parikh <Neerav.Parikh@intel.com>, Kiran Patil <kiran.patil@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Yi Zou <yi.zou@intel.com>

From: Eric Dumazet <eric.dumazet@gmail.com>

Since fcoe_percpu_thread_create() creates percpu kthread, it makes sense
to use kthread_create_on_node() to get proper NUMA affinity for kthread
stack.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neerav Parikh <Neerav.Parikh@intel.com>
CC: Kiran Patil <kiran.patil@intel.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5d0e9a2..5a28940 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1135,8 +1135,9 @@ static void fcoe_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(fcoe_percpu, cpu);
 
-	thread = kthread_create(fcoe_percpu_receive_thread,
-				(void *)p, "fcoethread/%d", cpu);
+	thread = kthread_create_on_node(fcoe_percpu_receive_thread,
+					(void *)p, cpu_to_node(cpu),
+					"fcoethread/%d", cpu);
 
 	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);

