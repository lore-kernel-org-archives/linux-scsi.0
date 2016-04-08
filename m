From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] drivers/scsi/fnic/fnic_scsi.c: Deinline fnic_queue_abort_io_req, save 1792 bytes
Date: Fri,  8 Apr 2016 20:58:43 +0200
Message-ID: <1460141926-13069-2-git-send-email-dvlasenk@redhat.com>
References: <1460141926-13069-1-git-send-email-dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460141926-13069-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This function compiles to 511 bytes of machine code.

Abort commands are not time-critical at all.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Hiral Patel <hiralpat@cisco.com>
CC: Suma Ramars <sramars@cisco.com>
CC: Brian Uchino <buchino@cisco.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 266b909..0a3edee 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1435,7 +1435,7 @@ wq_copy_cleanup_scsi_cmd:
 	}
 }
 
-static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
+static int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 					  u32 task_req, u8 *fc_lun,
 					  struct fnic_io_req *io_req)
 {
-- 
2.1.0
