From: =?ISO-8859-2?Q?Ji=F8=ED_Pinkava?= <j-pi@seznam.cz>
Subject: [PATCH] scsi-sg: pass flag to inhibit setting LUN
Date: Thu, 02 Jan 2014 14:19:17 +0100
Message-ID: <52C56755.7060709@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.seznam.cz ([77.75.76.43]:60387 "EHLO smtp2.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABNdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jan 2014 08:33:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

Hi,

This patch implements support for inhibiting setting LUN number
for SCSI custom command send via /dev/sgX with ioctl(.., SG_IO, ...) call.

This solves problems with some devices which claim support of
SCSI v1/v2, but for some special purposes use custom commands
which does not conform with standard message format.
(Like mine Pentax digital single-lens reflex camera)
It does not affect devices with SCSI v3 or latter.

For this purpose was earlier introduced
SG_FLAG_LUN_INHIBIT / SG_FLAG_UNUSED_LUN_INHIBIT (glibc/kernel) flag,
but the implementation was lost in some earlier code refactor.

The only possible issue I see is current implementation supports only
SG driver but there is few more code paths where the similar ioctl can
be invoked
(eg. anny SCSI device?). I'm not sure about, feel free to say anything
about it.


---
 drivers/scsi/scsi.c       | 3 ++-
 drivers/scsi/sg.c         | 3 +++
 include/linux/blk_types.h | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fe0bcb1..f6d5fc9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -693,7 +693,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
      * If SCSI-2 or lower, store the LUN value in cmnd.
      */
     if (cmd->device->scsi_level <= SCSI_2 &&
-        cmd->device->scsi_level != SCSI_UNKNOWN) {
+        cmd->device->scsi_level != SCSI_UNKNOWN &&
+        !(cmd->request->cmd_flags & REQ_LUN_INHIBIT)) {
         cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
                    (cmd->device->lun << 5 & 0xe0);
     }
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..8e09015 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1663,6 +1663,9 @@ static int sg_start_req(Sg_request *srp, unsigned
char *cmd)
     rq->sense = srp->sense_b;
     rq->retries = SG_DEFAULT_RETRIES;
 
+    if (hp->flags & SG_FLAG_UNUSED_LUN_INHIBIT)
+        rq->cmd_flags |=  REQ_LUN_INHIBIT;
+
     if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
         return 0;
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 238ef0e..35d436b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -178,6 +178,7 @@ enum rq_flag_bits {
     __REQ_MIXED_MERGE,    /* merge of different types, fail separately */
     __REQ_KERNEL,         /* direct IO to kernel pages */
     __REQ_PM,        /* runtime pm request */
+    __REQ_LUN_INHIBIT,    /* pass through for
SG_FLAG_UNUSED_LUN_INHIBIT flag */
     __REQ_END,        /* last of chain of requests */
     __REQ_NR_BITS,        /* stops here */
 };
@@ -230,6 +231,7 @@ enum rq_flag_bits {
 #define REQ_SECURE        (1ULL << __REQ_SECURE)
 #define REQ_KERNEL        (1ULL << __REQ_KERNEL)
 #define REQ_PM            (1ULL << __REQ_PM)
+#define REQ_LUN_INHIBIT    (1ULL << __REQ_LUN_INHIBIT)
 #define REQ_END            (1ULL << __REQ_END)
 
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.8.5.2

