From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/qla2xxx/: make some functions static
Date: Thu, 22 Jun 2006 00:54:58 +0200
Message-ID: <20060621225458.GQ9111@stusta.de>
References: <20060621034857.35cfe36f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:25355 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751521AbWFUWzB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 18:55:01 -0400
Content-Disposition: inline
In-Reply-To: <20060621034857.35cfe36f.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, rolandd@cisco.com, linux-driver@qlogic.com
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org, linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 03:48:57AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-rc6-mm2:
>...
>  git-infiniband.patch
>...
>  git trees
>...

This patch makes some needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ------
 drivers/scsi/qla2xxx/qla_init.c |    8 +++++---
 drivers/scsi/qla2xxx/qla_iocb.c |    3 ++-
 3 files changed, 7 insertions(+), 10 deletions(-)

--- linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_gbl.h.old	2006-06-22 00:48:35.000000000 +0200
+++ linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_gbl.h	2006-06-22 00:50:32.000000000 +0200
@@ -31,13 +31,9 @@
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
 
@@ -80,8 +76,6 @@
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
-extern void qla2x00_isp_cmd(scsi_qla_host_t *);
-
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
--- linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_init.c.old	2006-06-22 00:48:58.000000000 +0200
+++ linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_init.c	2006-06-22 00:49:50.000000000 +0200
@@ -39,6 +39,8 @@
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 
+static int qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev);
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -1701,7 +1703,7 @@
  *
  * Returns a pointer to the allocated fcport, or NULL, if none available.
  */
-fc_port_t *
+static fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t flags)
 {
 	fc_port_t *fcport;
@@ -2497,7 +2499,7 @@
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
 {
 	int	rval;
@@ -3472,7 +3474,7 @@
 	return (rval);
 }
 
-int
+static int
 qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
 	int	rval;
--- linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_iocb.c.old	2006-06-22 00:50:42.000000000 +0200
+++ linux-2.6.17-mm1-full/drivers/scsi/qla2xxx/qla_iocb.c	2006-06-22 00:51:00.000000000 +0200
@@ -15,6 +15,7 @@
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
 static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
 static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
+static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -574,7 +575,7 @@
  *
  * Note: The caller must hold the hardware lock before calling this routine.
  */
-void
+static void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;

