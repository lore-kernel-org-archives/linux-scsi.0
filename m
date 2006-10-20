From: akpm@osdl.org
Subject: [patch 45/45] drivers/scsi: Handcrafted MIN/MAX macro removal
Date: Fri, 20 Oct 2006 14:48:40 -0700
Message-ID: <200610202148.k9KLmeXZ004210@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6279 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992855AbWJTVtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

Cleanups done to use min/max macros from kernel.h.  Handcrafted MIN/MAX
macros are changed to use macros in kernel.h

[akpm@osdl.org: fix warning]
Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h      |    8 --------
 drivers/scsi/aic7xxx/aic79xx_core.c |   22 +++++++++++-----------
 drivers/scsi/aic7xxx/aic79xx_osm.c  |    7 ++++---
 drivers/scsi/aic7xxx/aic7xxx.h      |    8 --------
 drivers/scsi/aic7xxx/aic7xxx_core.c |   18 +++++++++---------
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    4 ++--
 6 files changed, 26 insertions(+), 41 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic79xx.h
@@ -53,14 +53,6 @@ struct ahd_platform_data;
 struct scb_platform_data;
 
 /****************************** Useful Macros *********************************/
-#ifndef MAX
-#define MAX(a,b) (((a) > (b)) ? (a) : (b))
-#endif
-
-#ifndef MIN
-#define MIN(a,b) (((a) < (b)) ? (a) : (b))
-#endif
-
 #ifndef TRUE
 #define TRUE 1
 #endif
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2914,14 +2914,14 @@ ahd_devlimited_syncrate(struct ahd_softc
 		transinfo = &tinfo->goal;
 	*ppr_options &= (transinfo->ppr_options|MSG_EXT_PPR_PCOMP_EN);
 	if (transinfo->width == MSG_EXT_WDTR_BUS_8_BIT) {
-		maxsync = MAX(maxsync, AHD_SYNCRATE_ULTRA2);
+		maxsync = max(maxsync, (u_int)AHD_SYNCRATE_ULTRA2);
 		*ppr_options &= ~MSG_EXT_PPR_DT_REQ;
 	}
 	if (transinfo->period == 0) {
 		*period = 0;
 		*ppr_options = 0;
 	} else {
-		*period = MAX(*period, transinfo->period);
+		*period = max(*period, (u_int)transinfo->period);
 		ahd_find_syncrate(ahd, period, ppr_options, maxsync);
 	}
 }
@@ -2988,12 +2988,12 @@ ahd_validate_offset(struct ahd_softc *ah
 			maxoffset = MAX_OFFSET_PACED;
 	} else
 		maxoffset = MAX_OFFSET_NON_PACED;
-	*offset = MIN(*offset, maxoffset);
+	*offset = min(*offset, maxoffset);
 	if (tinfo != NULL) {
 		if (role == ROLE_TARGET)
-			*offset = MIN(*offset, tinfo->user.offset);
+			*offset = min(*offset, (u_int)tinfo->user.offset);
 		else
-			*offset = MIN(*offset, tinfo->goal.offset);
+			*offset = min(*offset, (u_int)tinfo->goal.offset);
 	}
 }
 
@@ -3019,9 +3019,9 @@ ahd_validate_width(struct ahd_softc *ahd
 	}
 	if (tinfo != NULL) {
 		if (role == ROLE_TARGET)
-			*bus_width = MIN(tinfo->user.width, *bus_width);
+			*bus_width = min((u_int)tinfo->user.width, *bus_width);
 		else
-			*bus_width = MIN(tinfo->goal.width, *bus_width);
+			*bus_width = min((u_int)tinfo->goal.width, *bus_width);
 	}
 }
 
@@ -6121,9 +6121,9 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 #endif
 	}
 
-	newcount = MIN(scb_data->sense_left, scb_data->scbs_left);
-	newcount = MIN(newcount, scb_data->sgs_left);
-	newcount = MIN(newcount, (AHD_SCB_MAX_ALLOC - scb_data->numscbs));
+	newcount = min(scb_data->sense_left, scb_data->scbs_left);
+	newcount = min(newcount, scb_data->sgs_left);
+	newcount = min(newcount, (AHD_SCB_MAX_ALLOC - scb_data->numscbs));
 	for (i = 0; i < newcount; i++) {
 		struct scb_platform_data *pdata;
 		u_int col_tag;
@@ -8737,7 +8737,7 @@ ahd_resolve_seqaddr(struct ahd_softc *ah
 		if (skip_addr > i) {
 			int end_addr;
 
-			end_addr = MIN(address, skip_addr);
+			end_addr = min(address, skip_addr);
 			address_offset += end_addr - i;
 			i = skip_addr;
 		} else {
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1812,9 +1812,9 @@ ahd_linux_handle_scsi_status(struct ahd_
 			u_int sense_offset;
 
 			if (scb->flags & SCB_SENSE) {
-				sense_size = MIN(sizeof(struct scsi_sense_data)
+				sense_size = min(sizeof(struct scsi_sense_data)
 					       - ahd_get_sense_residual(scb),
-						 sizeof(cmd->sense_buffer));
+						 (u_long)sizeof(cmd->sense_buffer));
 				sense_offset = 0;
 			} else {
 				/*
@@ -1823,7 +1823,8 @@ ahd_linux_handle_scsi_status(struct ahd_
 				 */
 				siu = (struct scsi_status_iu_header *)
 				    scb->sense_data;
-				sense_size = MIN(scsi_4btoul(siu->sense_length),
+				sense_size = min_t(size_t,
+						scsi_4btoul(siu->sense_length),
 						sizeof(cmd->sense_buffer));
 				sense_offset = SIU_SENSE_OFFSET(siu);
 			}
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic7xxx.h
--- a/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic7xxx.h
@@ -54,14 +54,6 @@ struct scb_platform_data;
 struct seeprom_descriptor;
 
 /****************************** Useful Macros *********************************/
-#ifndef MAX
-#define MAX(a,b) (((a) > (b)) ? (a) : (b))
-#endif
-
-#ifndef MIN
-#define MIN(a,b) (((a) < (b)) ? (a) : (b))
-#endif
-
 #ifndef TRUE
 #define TRUE 1
 #endif
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1671,7 +1671,7 @@ ahc_devlimited_syncrate(struct ahc_softc
 		transinfo = &tinfo->goal;
 	*ppr_options &= transinfo->ppr_options;
 	if (transinfo->width == MSG_EXT_WDTR_BUS_8_BIT) {
-		maxsync = MAX(maxsync, AHC_SYNCRATE_ULTRA2);
+		maxsync = max(maxsync, (u_int)AHC_SYNCRATE_ULTRA2);
 		*ppr_options &= ~MSG_EXT_PPR_DT_REQ;
 	}
 	if (transinfo->period == 0) {
@@ -1679,7 +1679,7 @@ ahc_devlimited_syncrate(struct ahc_softc
 		*ppr_options = 0;
 		return (NULL);
 	}
-	*period = MAX(*period, transinfo->period);
+	*period = max(*period, (u_int)transinfo->period);
 	return (ahc_find_syncrate(ahc, period, ppr_options, maxsync));
 }
 
@@ -1804,12 +1804,12 @@ ahc_validate_offset(struct ahc_softc *ah
 		else
 			maxoffset = MAX_OFFSET_8BIT;
 	}
-	*offset = MIN(*offset, maxoffset);
+	*offset = min(*offset, maxoffset);
 	if (tinfo != NULL) {
 		if (role == ROLE_TARGET)
-			*offset = MIN(*offset, tinfo->user.offset);
+			*offset = min(*offset, (u_int)tinfo->user.offset);
 		else
-			*offset = MIN(*offset, tinfo->goal.offset);
+			*offset = min(*offset, (u_int)tinfo->goal.offset);
 	}
 }
 
@@ -1835,9 +1835,9 @@ ahc_validate_width(struct ahc_softc *ahc
 	}
 	if (tinfo != NULL) {
 		if (role == ROLE_TARGET)
-			*bus_width = MIN(tinfo->user.width, *bus_width);
+			*bus_width = min((u_int)tinfo->user.width, *bus_width);
 		else
-			*bus_width = MIN(tinfo->goal.width, *bus_width);
+			*bus_width = min((u_int)tinfo->goal.width, *bus_width);
 	}
 }
 
@@ -4406,7 +4406,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 	physaddr = sg_map->sg_physaddr;
 
 	newcount = (PAGE_SIZE / (AHC_NSEG * sizeof(struct ahc_dma_seg)));
-	newcount = MIN(newcount, (AHC_SCB_MAX_ALLOC - scb_data->numscbs));
+	newcount = min(newcount, (AHC_SCB_MAX_ALLOC - scb_data->numscbs));
 	for (i = 0; i < newcount; i++) {
 		struct scb_platform_data *pdata;
 #ifndef __linux__
@@ -6442,7 +6442,7 @@ ahc_download_instr(struct ahc_softc *ahc
 			if (skip_addr > i) {
 				int end_addr;
 
-				end_addr = MIN(address, skip_addr);
+				end_addr = min(address, skip_addr);
 				address_offset += end_addr - i;
 				i = skip_addr;
 			} else {
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-handcrafted-min-max-macro-removal drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-handcrafted-min-max-macro-removal
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1875,9 +1875,9 @@ ahc_linux_handle_scsi_status(struct ahc_
 		if (scb->flags & SCB_SENSE) {
 			u_int sense_size;
 
-			sense_size = MIN(sizeof(struct scsi_sense_data)
+			sense_size = min(sizeof(struct scsi_sense_data)
 				       - ahc_get_sense_residual(scb),
-					 sizeof(cmd->sense_buffer));
+					 (u_long)sizeof(cmd->sense_buffer));
 			memcpy(cmd->sense_buffer,
 			       ahc_get_sense_buf(ahc, scb), sense_size);
 			if (sense_size < sizeof(cmd->sense_buffer))
_
