From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] fcoe: use kthread_create_on_node
Date: Fri, 29 Jul 2011 09:00:25 +0200
Message-ID: <1311922825.7845.18.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-kernel <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Neerav Parikh <Neerav.Parikh@intel.com>, Kiran Patil <kiran.patil@intel.com>
List-Id: linux-scsi@vger.kernel.org

Since fcoe_percpu_thread_create() creates percpu kthread, it makes sense
to use kthread_create_on_node() to get proper NUMA affinity for kthread
stack.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neerav Parikh <Neerav.Parikh@intel.com>
CC: Kiran Patil <kiran.patil@intel.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/fcoe/fcoe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 204fa8d..a9dab1f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1118,8 +1118,9 @@ static void fcoe_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(fcoe_percpu, cpu);
 
-	thread = kthread_create(fcoe_percpu_receive_thread,
-				(void *)p, "fcoethread/%d", cpu);
+	thread = kthread_create_on_node(fcoe_percpu_receive_thread,
+					(void *)p, cpu_to_node(cpu),
+					"fcoethread/%d", cpu);
 
 	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);
