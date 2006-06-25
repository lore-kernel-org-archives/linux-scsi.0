From: akpm@osdl.org
Subject: [patch 06/26] drivers/scsi/qla2xxx/: make some more functions static
Date: Sun, 25 Jun 2006 01:58:45 -0700
Message-ID: <200606250858.k5P8wjnl021190@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38037 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932106AbWFYI7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 04:59:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, andrew.vasquez@qlogic.com


From: Adrian Bunk <bunk@stusta.de>

Make some needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ------
 drivers/scsi/qla2xxx/qla_init.c |    8 +++++---
 drivers/scsi/qla2xxx/qla_iocb.c |    3 ++-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_gbl.h~drivers-scsi-qla2xxx-make-more-some-functions-static drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h~drivers-scsi-qla2xxx-make-more-some-functions-static
+++ a/drivers/scsi/qla2xxx/qla_gbl.h
@@ -31,13 +31,9 @@ extern void qla2x00_update_fw_options(st
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
-extern int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
-
-extern fc_port_t *qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t);
 
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
 
-extern int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
@@ -80,8 +76,6 @@ extern void qla2xxx_wake_dpc(scsi_qla_ho
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
-extern void qla2x00_isp_cmd(scsi_qla_host_t *);
-
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
diff -puN drivers/scsi/qla2xxx/qla_init.c~drivers-scsi-qla2xxx-make-more-some-functions-static drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~drivers-scsi-qla2xxx-make-more-some-functions-static
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -39,6 +39,8 @@ static int qla2x00_fabric_dev_login(scsi
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 
+static int qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev);
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -1701,7 +1703,7 @@ qla2x00_rport_del(void *data)
  *
  * Returns a pointer to the allocated fcport, or NULL, if none available.
  */
-fc_port_t *
+static fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t flags)
 {
 	fc_port_t *fcport;
@@ -2498,7 +2500,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
 {
 	int	rval;
@@ -3473,7 +3475,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	return (rval);
 }
 
-int
+static int
 qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
 	int	rval;
diff -puN drivers/scsi/qla2xxx/qla_iocb.c~drivers-scsi-qla2xxx-make-more-some-functions-static drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c~drivers-scsi-qla2xxx-make-more-some-functions-static
+++ a/drivers/scsi/qla2xxx/qla_iocb.c
@@ -15,6 +15,7 @@ static inline uint16_t qla2x00_get_cmd_d
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
 static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
 static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
+static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -574,7 +575,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
  *
  * Note: The caller must hold the hardware lock before calling this routine.
  */
-void
+static void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
_
