From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] drivers: scsi: qla2xxx: Remove redundant declaration in 'qla_gbl.h'
Date: Sat, 01 Nov 2014 19:46:12 +0800
Message-ID: <5454C804.50407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40456 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaKALkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Nov 2014 07:40:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Remove 2 redundant extern inline functions: qla8044_set_qsnt_ready() and
qla8044_need_reset_handler(). At present, within upstream next kernel
source code, they are only used within "drivers/scsi/qla2xxx/qla_nx2.c".

The related error and warnings (with allmodconfig under tile):

    CC [M]  drivers/scsi/qla2xxx/qla_nx2.o
  drivers/scsi/qla2xxx/qla_nx2.c:1633:1: error: static declaration of 'qla8044_need_reset_handler' follows non-static declaration
   qla8044_need_reset_handler(struct scsi_qla_host *vha)
   ^
  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
                   from drivers/scsi/qla2xxx/qla_nx2.c:11:
  drivers/scsi/qla2xxx/qla_gbl.h:756:20: note: previous declaration of 'qla8044_need_reset_handler' was here
   extern inline void qla8044_need_reset_handler(struct scsi_qla_host *vha);
                      ^
  drivers/scsi/qla2xxx/qla_gbl.h:756:20: warning: inline function 'qla8044_need_reset_handler' declared but never defined
  make[3]: *** [drivers/scsi/qla2xxx/qla_nx2.o] Error 1
  make[2]: *** [drivers/scsi/qla2xxx] Error 2
  make[1]: *** [drivers/scsi] Error 2
  make: *** [drivers] Error 2

    CC [M]  drivers/scsi/qla2xxx/qla_tmpl.o
  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
                   from drivers/scsi/qla2xxx/qla_tmpl.c:7:
  drivers/scsi/qla2xxx/qla_gbl.h:755:20: warning: inline function 'qla8044_set_qsnt_ready' declared but never defined
   extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
                    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 --
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b1865a7..7686bfe 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -752,8 +752,6 @@ extern void qla8044_set_idc_dontreset(struct scsi_qla_host *ha);
 extern int qla8044_rd_direct(struct scsi_qla_host *vha, const uint32_t crb_reg);
 extern void qla8044_wr_direct(struct scsi_qla_host *vha,
 			      const uint32_t crb_reg, const uint32_t value);
-extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
-extern inline void qla8044_need_reset_handler(struct scsi_qla_host *vha);
 extern int qla8044_device_state_handler(struct scsi_qla_host *vha);
 extern void qla8044_clear_qsnt_ready(struct scsi_qla_host *vha);
 extern void qla8044_clear_drv_active(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 24a8528..ed4d6b6 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -238,7 +238,7 @@ qla8044_rmw_crb_reg(struct scsi_qla_host *vha,
 	return;
 }
 
-inline void
+static inline void
 qla8044_set_qsnt_ready(struct scsi_qla_host *vha)
 {
 	uint32_t qsnt_state;
-- 
1.9.3
