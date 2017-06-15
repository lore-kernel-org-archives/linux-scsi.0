From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: Fix module removal due to stuck unmap_thread thread again
Date: Thu, 15 Jun 2017 15:05:31 +0800
Message-ID: <1497510331-17918-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Because the unmap code just after the schdule() returned may take
a long time and if the kthread_stop() is fired just when in this
routine, the module removal maybe stuck too.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index beb5f09..203bff1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1573,7 +1573,7 @@ static int unmap_thread_fn(void *data)
 	struct page *page;
 	int i;
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		DEFINE_WAIT(__wait);
 
 		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-- 
1.8.3.1
