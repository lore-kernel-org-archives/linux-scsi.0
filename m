From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] qla4xxx: pass timeout as HZ independent value
Date: Wed, 27 May 2015 22:10:26 +0200
Message-ID: <1432757426-6459-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

schedule_timeout_* takes a timeout in jiffies but the code currently is
passing in a constant which makes this timeout HZ dependent, so pass it
through msecs_to_jiffies() to fix this up.

patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y,
CONFIG_SCSI_QLA_ISCSI=m

Patch is against 4.1-rc5 (localversion-next is -next-20150527)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

As there is no documentation of the intended timeout it might be wrong
to convert it with msecs_to_jiffies as this can reduces the actual
jiffies value by at least a factor of 10 - so someone that knows this
driver needs to check on the actual value - but in any case it needs
to be passed in a HZ independent way.

 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 7c33658..7b53eab 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1569,7 +1569,7 @@ static int qla4_82xx_cmdpeg_ready(struct scsi_qla_host *ha, int pegtune_val)
 			    (val == PHAN_INITIALIZE_ACK))
 				return 0;
 			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(500);
+			schedule_timeout(msecs_to_jiffies(500));
 
 		} while (--retries);
 
-- 
1.7.10.4
