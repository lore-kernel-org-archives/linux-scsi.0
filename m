From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [SCSI] bfa: Fix endian bug in bfad_iocmd_debug_fw_core().
Date: Tue,  6 Mar 2012 22:36:59 +0530
Message-ID: <1331053619-7211-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: huangj@brocade.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Casting pointer from native data type to other type is
endian-sensitive.

"iocmd->offset"  is 64 bit but we use only first 32 bit.
It works in little-endian system but in big-endian system
it will break.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/bfa/bfad_bsg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 530de2b..c4edc63 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -1918,6 +1918,7 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 	struct bfa_bsg_debug_s *iocmd = (struct bfa_bsg_debug_s *)cmd;
 	void	*iocmd_bufptr;
 	unsigned long	flags;
+	u32 offset;
 
 	if (bfad_chk_iocmd_sz(payload_len, sizeof(struct bfa_bsg_debug_s),
 			BFA_DEBUG_FW_CORE_CHUNK_SZ) != BFA_STATUS_OK) {
@@ -1935,8 +1936,10 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 
 	iocmd_bufptr = (char *)iocmd + sizeof(struct bfa_bsg_debug_s);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	offset = iocmd->offset;
 	iocmd->status = bfa_ioc_debug_fwcore(&bfad->bfa.ioc, iocmd_bufptr,
-				(u32 *)&iocmd->offset, &iocmd->bufsz);
+				&offset, &iocmd->bufsz);
+	iocmd->offset = offset;
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 out:
 	return 0;
-- 
1.7.4.4
