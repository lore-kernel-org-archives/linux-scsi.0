From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 28/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159622E.1090000@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:50123 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267783AbUI1NIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:08:06 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD86W03436
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:08:06 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD85m31423
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:08:05 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (4074-4146)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#20 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c ====
--- /tmp/tmp.28312.0	2004-09-27 16:29:42.047114560 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c	2004-09-03 11:46:36.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#20 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#21 $
   */

  #include "aic7xxx_osm.h"
@@ -179,10 +179,8 @@
  		return (ENOMEM);
  	strcpy(name, buf);
  	ahc = ahc_alloc(&aic7xxx_driver_template, name);
-	if (ahc == NULL) {
-		free(name, M_DEVBUF);
+	if (ahc == NULL)
  		return (ENOMEM);
-	}
  	ahc->dev_softc = dev;
  	if (aic_set_dma_mask(ahc, 0xFFFFFFFF) != 0
         /*|| aic_set_consistent_dma_mask(ahc, 0xFFFFFFFF) != 0 */) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#213 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.28312.1	2004-09-27 16:29:43.002969248 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-09-03 13:59:54.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#213 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#215 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -1102,7 +1102,7 @@
  		       ahd_name(ahd));
  		return (0);
  	} else if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
-		&& cmd->device->type != -1) {
+		&& cmd->device->type != (char) -1) {
  		/*
  		 * Configure devices that have already successfully
  		 * completed an inquiry. This  handles the case of
@@ -1669,6 +1669,8 @@

  	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
  	recovery_cmd = malloc(sizeof(struct scsi_cmnd), M_DEVBUF, M_WAITOK);
+	if (!recovery_cmd)
+		return (FAILED);
  	memset(recovery_cmd, 0, sizeof(struct scsi_cmnd));
  	recovery_cmd->device = cmd->device;
  	recovery_cmd->scsi_done = ahd_linux_dev_reset_complete;
@@ -1684,10 +1686,12 @@
  				   cmd->device->lun, /*alloc*/FALSE);
  	if (dev == NULL) {
  		ahd_entrypoint_unlock(ahd, &s);
+		free(recovery_cmd, M_DEVBUF);
  		return (FAILED);
  	}
  	if ((scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX)) == NULL) {
  		ahd_entrypoint_unlock(ahd, &s);
+		free(recovery_cmd, M_DEVBUF);
  		return (FAILED);
  	}
  	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
@@ -3120,7 +3124,7 @@
  				break;
  			}
  			if (status & SSQ_DELAY)
-				scsi_sleep(1 * HZ);
+				ssleep(1);

  			break;
  		case SS_START:
@@ -3290,7 +3294,7 @@
  			}
  			if (targ->dv_state_retry <= 10) {
  				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					scsi_sleep(ahd->our_id*HZ/10);
+					msleep(ahd->our_id*100);
  				break;
  			}
  #ifdef AHD_DEBUG
@@ -3334,7 +3338,7 @@
  				targ->dv_state_retry--;
  			} else if (targ->dv_state_retry < 60) {
  				if ((status & SSQ_DELAY) != 0)
-					scsi_sleep(1 * HZ);
+					ssleep(1);
  			} else {
  #ifdef AHD_DEBUG
  				if (ahd_debug & AHD_SHOW_DV) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_reg.h#88 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped ====
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_reg_print.c#66 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped ====
--- /tmp/tmp.28312.2	2004-09-27 16:29:43.548886256 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	2004-09-10 16:32:31.000000000 -0400
@@ -2,8 +2,8 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#118 $
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#75 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $
   */

  #include "aic79xx_osm.h"
@@ -3382,6 +3382,7 @@
  }

  static ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
  	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
  	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
  };
@@ -3389,7 +3390,7 @@
  int
  ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
  {
-	return (ahd_print_register(SEQ_FLAGS2_parse_table, 2, "SEQ_FLAGS2",
+	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
  	    0x14d, regvalue, cur_col, wrap));
  }

@@ -3450,6 +3451,20 @@
  }

  int
+ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
+	    0x160, regvalue, cur_col, wrap));
+}
+
+int
+ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
+	    0x162, regvalue, cur_col, wrap));
+}
+
+int
  ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
  {
  	return (ahd_print_register(NULL, 0, "SCB_BASE",
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_seq.h#89 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped ====
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#276 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.28312.3	2004-09-27 16:29:44.331767240 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-09-03 13:38:02.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#276 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#277 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -2794,7 +2794,7 @@
  				break;
  			}
  			if (status & SSQ_DELAY)
-				scsi_sleep(1 * HZ);
+				ssleep(1);

  			break;
  		case SS_START:
@@ -2964,7 +2964,7 @@
  			}
  			if (targ->dv_state_retry <= 10) {
  				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					scsi_sleep(ahc->our_id*HZ/10);
+					msleep(ahc->our_id*100);
  				break;
  			}
  #ifdef AHC_DEBUG
@@ -3008,7 +3008,7 @@
  				targ->dv_state_retry--;
  			} else if (targ->dv_state_retry < 60) {
  				if ((status & SSQ_DELAY) != 0)
-					scsi_sleep(1 * HZ);
+					ssleep(1);
  			} else {
  #ifdef AHC_DEBUG
  				if (ahc_debug & AHC_SHOW_DV) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_reg.h#30 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped ====
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_reg_print.c#16 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped ====
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_seq.h#31 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped ====
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#42 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.28312.4	2004-09-27 16:29:44.762701728 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2004-09-03 14:20:36.000000000 -0400
@@ -2341,4 +2341,9 @@
          }
  }

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9)
+#define ssleep(a)  scsi_sleep((a)*HZ)
+#define msleep(a)  scsi_sleep((a))
+#endif
+
  #endif /*_AICLIB_H */


