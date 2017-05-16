From: firogm@gmail.com
Subject: [PATCH] scsi: sg: Fix mismatch in sg_get_rq_mark
Date: Tue, 16 May 2017 22:52:44 +0800
Message-ID: <20170516145244.19402-1-firogm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: dvyukov@google.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, syzkaller@googlegroups.com, linux-kernel@vger.kernel.org, Firo Yang <firogm@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Firo Yang <firogm@gmail.com>

This bug was reported by Andrey Konovalov with syzkaller:

Call Trace:
 sg_finish_rem_req+0x2a6/0x320 drivers/scsi/sg.c:1839
 sg_new_read+0x3c/0x430 drivers/scsi/sg.c:567
 sg_read+0x866/0x1830 drivers/scsi/sg.c:455
 __vfs_read+0x5c3/0x750 fs/read_write.c:450
 vfs_read+0x11e/0x350 fs/read_write.c:473
 SYSC_read fs/read_write.c:589
 SyS_read+0xfb/0x230 fs/read_write.c:582
 entry_SYSCALL_64_fastpath+0x1f/0xbe arch/x86/entry/entry_64.S:204

If there is nothing matched in the loop of list_for_each_entry,
at last the iteration variable 'resp' will point to
list_entry(&sfp->rq_list, typeof(resp), entry); it's not a valid
Sg_request. Finnally, 'resp' will be wrongly returned to the caller
function.

To fix it, add another return variable to record the correct
match and return it to the caller function.

Signed-off-by: Firo Yang <firogm@gmail.com>
---
 drivers/scsi/sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0a38ba0..74a9188 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2065,7 +2065,7 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 static Sg_request *
 sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 {
-	Sg_request *resp;
+	Sg_request *resp, *ret_resp = NULL;
 	unsigned long iflags;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -2074,11 +2074,12 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 		if ((1 == resp->done) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
 			resp->done = 2;	/* guard against other readers */
+			ret_resp =  resp;
 			break;
 		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return ret_resp;
 }
 
 /* always adds to end of list */
-- 
2.9.4
