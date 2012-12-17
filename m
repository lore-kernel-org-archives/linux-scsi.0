From: Masatake YAMATO <yamato@redhat.com>
Subject: [RESEND2 PATCH] libiscsi: avoid unnecessary multiple NULL
 assignments
Date: Mon, 17 Dec 2012 17:08:54 +0900 (JST)
Message-ID: <20121217.170854.1401098659349665391.yamato@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In iscsi_free_task, NULL is assigned to task->sc twice: before and
after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
with session->lock, so multiple NULL assignments cause no trouble. But
people reading the source code may be confused.

The second NULL assignment comes from commit:

    3e5c28ad0391389959ccae81c938c7533efb3490

It seems that the line after kfifo_in invocation was introduced
accidentally.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..7aacf3a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -507,7 +507,6 @@ static void iscsi_free_task(struct iscsi_task *task)
 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
-		task->sc = NULL;
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
-- 
1.7.11.7
