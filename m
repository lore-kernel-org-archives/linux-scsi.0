From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 2/2] csiostor : Remove __CSIO_DEBUG__ dead code
Date: Thu, 10 Sep 2015 16:03:52 -0700
Message-ID: <1441926232-16091-3-git-send-email-anish@chelsio.com>
References: <1441926232-16091-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:9461 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751114AbbIJXER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 19:04:17 -0400
In-Reply-To: <1441926232-16091-1-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, hare@suse.de, hch@lst.de, praveenm@chelsio.com, hariprasad@chelsio.com, Anish Bhatt <anish@chelsio.com>

Code guarded by __CSIO_DEBUG__ was dead code, fix via
csio_dbg now direcly calling dev_dbg, so output can be controlled
by changing kernel log level.

This dead code also enabled many BUG_ON() calls, use the preferred
WARN_ON() for any debug-only asserts instead.

Signed-off-by: Anish Bhatt <anish@chelsio.com>
---
 drivers/scsi/csiostor/csio_attr.c  | 2 +-
 drivers/scsi/csiostor/csio_defs.h  | 8 +-------
 drivers/scsi/csiostor/csio_hw.c    | 2 +-
 drivers/scsi/csiostor/csio_hw.h    | 6 +-----
 drivers/scsi/csiostor/csio_mb.c    | 2 +-
 drivers/scsi/csiostor/csio_rnode.c | 4 ++--
 drivers/scsi/csiostor/csio_scsi.c  | 2 --
 7 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index 2d1c4eb..e464e1c 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -71,7 +71,7 @@ csio_reg_rnode(struct csio_rnode *rn)
 
 	if (rn->role & CSIO_RNFR_INITIATOR || rn->role & CSIO_RNFR_TARGET) {
 		rport = rn->rport;
-		CSIO_ASSERT(rport != NULL);
+		BUG_ON(!rport);
 		goto update_role;
 	}
 
diff --git a/drivers/scsi/csiostor/csio_defs.h b/drivers/scsi/csiostor/csio_defs.h
index c38017b..c2325eb 100644
--- a/drivers/scsi/csiostor/csio_defs.h
+++ b/drivers/scsi/csiostor/csio_defs.h
@@ -110,12 +110,6 @@ csio_match_state(void *smp, void *state)
 	return (csio_get_state(smp) == (csio_sm_state_t)state);
 }
 
-#define	CSIO_ASSERT(cond)		BUG_ON(!(cond))
-
-#ifdef __CSIO_DEBUG__
-#define CSIO_DB_ASSERT(__c)		CSIO_ASSERT((__c))
-#else
-#define CSIO_DB_ASSERT(__c)
-#endif
+#define	CSIO_DB_ASSERT(cond)		WARN_ON(!(cond))
 
 #endif /* ifndef __CSIO_DEFS_H__ */
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..801b16d 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -735,7 +735,7 @@ csio_hw_fw_dload(struct csio_hw *hw, uint8_t *fw_data, uint32_t size)
 		goto out;
 
 	csio_dbg(hw, "Writing Flash .. start:%d end:%d\n",
-		    FW_IMG_START, FW_IMG_START + size);
+		    FLASH_FW_START, FLASH_FW_START + size);
 
 	addr = FLASH_FW_START;
 	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 029bef8..00ec5bc 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -562,12 +562,8 @@ csio_us_to_core_ticks(struct csio_hw *hw, uint32_t us)
 #define csio_warn(__hw, __fmt, ...)					\
 			dev_warn(&(__hw)->pdev->dev, __fmt, ##__VA_ARGS__)
 
-#ifdef __CSIO_DEBUG__
 #define csio_dbg(__hw, __fmt, ...)					\
-			csio_info((__hw), __fmt, ##__VA_ARGS__);
-#else
-#define csio_dbg(__hw, __fmt, ...)
-#endif
+			dev_dbg(&(__hw)->pdev->dev, __fmt, ##__VA_ARGS__);
 
 int csio_hw_wait_op_done_val(struct csio_hw *, int, uint32_t, int,
 			     int, int, uint32_t *);
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 9451787..6c3c2a5 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1511,7 +1511,7 @@ csio_mb_isr_handler(struct csio_hw *hw)
 #endif
 		}
 
-		CSIO_ASSERT(mbp != NULL);
+		BUG_ON(!mbp);
 
 		cmd = mbp->mb;
 		size = mbp->mb_size;
diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/csio_rnode.c
index e9c3b04..b735b90 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -363,7 +363,7 @@ csio_confirm_rnode(struct csio_lnode *ln, uint32_t rdev_flowid,
 						     "rnode is already"
 						     "active ssni:x%x\n",
 						     rdev_flowid);
-					CSIO_ASSERT(0);
+					BUG();
 				}
 				csio_rn_flowid(rn) = CSIO_INVALID_IDX;
 				rn = match_rn;
@@ -401,7 +401,7 @@ csio_confirm_rnode(struct csio_lnode *ln, uint32_t rdev_flowid,
 					     "wwpn:%llx ssni:x%x\n",
 					     wwn_to_u64(csio_rn_wwpn(rn)),
 					     rdev_flowid);
-				CSIO_ASSERT(0);
+				BUG();
 			}
 			csio_rn_flowid(rn) = CSIO_INVALID_IDX;
 			goto alloc_rnode;
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 2c4562d..bdaea91 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -552,9 +552,7 @@ csio_scsi_write(struct csio_ioreq *req)
 static inline void
 csio_setup_ddp(struct csio_scsim *scsim, struct csio_ioreq *req)
 {
-#ifdef __CSIO_DEBUG__
 	struct csio_hw *hw = req->lnode->hwp;
-#endif
 	struct scatterlist *sgel = NULL;
 	struct scsi_cmnd *scmnd = csio_scsi_cmnd(req);
 	uint64_t sg_addr = 0;
-- 
2.5.1

