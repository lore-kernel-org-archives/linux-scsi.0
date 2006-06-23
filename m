From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/13] qla2xxx: Remove no-op IOCTL codes and macros.
Date: Fri, 23 Jun 2006 16:11:00 -0700
Message-ID: <11511042551328-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42416 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752161AbWFWXLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:00 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    7 -------
 drivers/scsi/qla2xxx/qla_isr.c |   20 --------------------
 drivers/scsi/qla2xxx/qla_os.c  |   14 --------------
 3 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4edb5d1..9ff3298 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -286,13 +286,6 @@ extern void *qla24xx_prep_ms_fdmi_iocb(s
 extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 
 /*
- * Global Function Prototypes in qla_xioctl.c source file.
- */
-#define qla2x00_enqueue_aen(ha, cmd, mode)	do { } while (0)
-#define qla2x00_alloc_ioctl_mem(ha)		(0)
-#define qla2x00_free_ioctl_mem(ha)		do { } while (0)
-
-/*
  * Global Function Prototypes in qla_attr.c source file.
  */
 struct class_device_attribute;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b28ac0a..b9f01f7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -395,10 +395,6 @@ #define LS_UNKNOWN	2
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
 
 		ha->flags.management_server_logged_in = 0;
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_LIP_OCCURRED, NULL);
-
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
@@ -418,9 +414,6 @@ #define LS_UNKNOWN	2
 		    link_speed);
 
 		ha->flags.management_server_logged_in = 0;
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_LOOP_UP, NULL);
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
@@ -439,9 +432,6 @@ #define LS_UNKNOWN	2
 		ha->link_data_rate = LDR_UNKNOWN;
 		if (ql2xfdmienable)
 			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_LOOP_DOWN, NULL);
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
@@ -460,10 +450,6 @@ #define LS_UNKNOWN	2
 
 		ha->operating_mode = LOOP;
 		ha->flags.management_server_logged_in = 0;
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_LIP_RESET, NULL);
-
 		break;
 
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
@@ -545,9 +531,6 @@ #define LS_UNKNOWN	2
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_PORT_UPDATE, NULL);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
@@ -584,9 +567,6 @@ #define LS_UNKNOWN	2
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(RSCN_UPDATE, &ha->dpc_flags);
-
-		/* Update AEN queue. */
-		qla2x00_enqueue_aen(ha, MBA_RSCN_UPDATE, &mb[0]);
 		break;
 
 	/* case MBA_RIO_RESPONSE: */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index da84ee2..0c6e334 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1906,17 +1906,6 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 		}
 		memset(ha->init_cb, 0, ha->init_cb_size);
 
-		/* Allocate ioctl related memory. */
-		if (qla2x00_alloc_ioctl_mem(ha)) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - ioctl_mem\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
 		if (qla2x00_allocate_sp_pool(ha)) {
 			qla_printk(KERN_WARNING, ha,
 			    "Memory Allocation failed - "
@@ -2033,9 +2022,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		return;
 	}
 
-	/* free ioctl memory */
-	qla2x00_free_ioctl_mem(ha);
-
 	/* free sp pool */
 	qla2x00_free_sp_pool(ha);
 
-- 
1.4.1.rc1.gf603


