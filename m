From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] aacraid: Fix potential null access
Date: Tue, 14 Mar 2017 09:20:19 -0700
Message-ID: <20170314162019.716-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:31881
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751082AbdCNW5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 18:57:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Tomas Henzl <thezl@redhat.com>

Currently command threads fails to return ioctls commands for older
controller versions, since it returns when all the fibs have been
allocated. Another issue is even all the fibs have not been allocated,
the correct allocated fibs is not updated nor freed.

Fixes: 113156bcea9ef1e6 (scsi: aacraid: Reworked aac_command_thread)
Reported-by: Tomas Henzl <thezl@redhat.com>

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3ad042..c8172f1 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2056,7 +2056,6 @@ static int fillup_pools(struct aac_dev *dev, struct hw_fib **hw_fib_pool,
 {
 	struct hw_fib **hw_fib_p;
 	struct fib **fib_p;
-	int rcode = 1;
 
 	hw_fib_p = hw_fib_pool;
 	fib_p = fib_pool;
@@ -2074,11 +2073,11 @@ static int fillup_pools(struct aac_dev *dev, struct hw_fib **hw_fib_pool,
 		}
 	}
 
+	/*
+	 * Get the actual number of allocated fibs
+	 */
 	num = hw_fib_p - hw_fib_pool;
-	if (!num)
-		rcode = 0;
-
-	return rcode;
+	return num;
 }
 
 static void wakeup_fibctx_threads(struct aac_dev *dev,
@@ -2186,7 +2185,6 @@ static void aac_process_events(struct aac_dev *dev)
 	struct fib *fib;
 	unsigned long flags;
 	spinlock_t *t_lock;
-	unsigned int rcode;
 
 	t_lock = dev->queues->queue[HostNormCmdQueue].lock;
 	spin_lock_irqsave(t_lock, flags);
@@ -2269,8 +2267,8 @@ static void aac_process_events(struct aac_dev *dev)
 		 * Fill up fib pointer pools with actual fibs
 		 * and hw_fibs
 		 */
-		rcode = fillup_pools(dev, hw_fib_pool, fib_pool, num);
-		if (!rcode)
+		num = fillup_pools(dev, hw_fib_pool, fib_pool, num);
+		if (!num)
 			goto free_mem;
 
 		/*
-- 
1.8.3.1
