From: giridhar.malavali@qlogic.com
Subject: [PATCH 5/9] qla2xxx: Retrieve firmware's maximum number of supported FCFs.
Date: Tue, 13 Oct 2009 15:16:49 -0700
Message-ID: <1255472213-472-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49693 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760783AbZJMWYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:16 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   13 +++++++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 14e0562..e218513 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -247,7 +247,7 @@ qla2x00_get_id_list(scsi_qla_host_t *, void *, dma_addr_t, uint16_t *);
 
 extern int
 qla2x00_get_resource_cnts(scsi_qla_host_t *, uint16_t *, uint16_t *,
-    uint16_t *, uint16_t *, uint16_t *);
+    uint16_t *, uint16_t *, uint16_t *, uint16_t *);
 
 extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c2494ca..c8b24b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1203,7 +1203,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				}
 				qla2x00_get_resource_cnts(vha, NULL,
 				    &ha->fw_xcb_count, NULL, NULL,
-				    &ha->max_npiv_vports);
+				    &ha->max_npiv_vports, NULL);
 
 				if (!fw_major_version && ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(vha);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b6202fe..a10d41b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2006,7 +2006,7 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
 int
 qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
     uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt,
-    uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports)
+    uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports, uint16_t *max_fcfs)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2017,6 +2017,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (IS_QLA81XX(vha->hw))
+		mcp->in_mb |= MBX_12;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -2027,9 +2029,10 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 		    vha->host_no, mcp->mb[0]));
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
-		    "mb7=%x mb10=%x mb11=%x.\n", __func__, vha->host_no,
-		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7],
-		    mcp->mb[10], mcp->mb[11]));
+		    "mb7=%x mb10=%x mb11=%x mb12=%x.\n", __func__,
+		    vha->host_no, mcp->mb[1], mcp->mb[2], mcp->mb[3],
+		    mcp->mb[6], mcp->mb[7], mcp->mb[10], mcp->mb[11],
+		    mcp->mb[12]));
 
 		if (cur_xchg_cnt)
 			*cur_xchg_cnt = mcp->mb[3];
@@ -2041,6 +2044,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 			*orig_iocb_cnt = mcp->mb[10];
 		if (vha->hw->flags.npiv_supported && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
+		if (IS_QLA81XX(vha->hw) && max_fcfs)
+			*max_fcfs = mcp->mb[12];
 	}
 
 	return (rval);
-- 
1.6.2.rc1.30.gd43c

