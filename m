From: mchristi@redhat.com
Subject: [PATCH 19/32] block: add helper to get data dir from op
Date: Wed,  4 Nov 2015 16:08:16 -0600
Message-ID: <1446674909-5371-20-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

In later patches the op will no longer be a bitmap, so we will
not have REQ_WRITE set for all non reads like discard, flush,
and write same. Drivers will still want to treat them as writes
for accounting reasons, so this patch adds a helper to translate
a op to a data direction.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19c2e94..cf5f518 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -586,6 +586,18 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
+/*
+ * Non REQ_OP_WRITE requests like discard, write same, etc, are
+ * considered WRITEs.
+ */
+static inline int op_to_data_dir(int op)
+{
+	if (op == REQ_OP_READ)
+		return READ;
+	else
+		return WRITE;
+}
+
 #define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
 
 /*
-- 
1.8.3.1
