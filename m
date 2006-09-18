From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptspi : Usefull code for debuging domain validation
Date: Mon, 18 Sep 2006 17:46:35 -0600
Message-ID: <20060918234635.GC7576@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38604 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030273AbWIRXtR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 19:49:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Domain validation can be enabled by uncommenting MPT_DEBUG_DV
in the driver Makefile, and recompiling.

Bump driver version to 3.04.02.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2006-09-12 18:21:05.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2006-09-18 16:24:12.000000000 -0600
@@ -8,6 +8,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_INIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
+#EXTRA_CFLAGS += -DMPT_DEBUG_DV
 
 #
 # driver/module specifics...
@@ -20,8 +21,6 @@
 #CFLAGS_mptbase.o += -DMPT_DEBUG_RESET
 #
 #  For mptscsih:
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_DV
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_NEGO
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_TM
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_REPLY
diff -uarpN b/drivers/message/fusion/linux_compat.h a/drivers/message/fusion/linux_compat.h
--- b/drivers/message/fusion/linux_compat.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/linux_compat.h	2006-09-18 16:18:49.000000000 -0600
@@ -13,6 +13,7 @@ static int inline scsi_device_online(str
 }
 #endif
 
+#define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
 
 /*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif /* _LINUX_COMPAT_H */
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-09-18 16:07:46.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-09-18 16:21:21.000000000 -0600
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.01"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.01"
+#define MPT_LINUX_VERSION_COMMON	"3.04.02"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.02"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -790,18 +790,6 @@ typedef struct _mpt_sge {
 #define ddvprintk(x)
 #endif
 
-#ifdef MPT_DEBUG_NEGO
-#define dnegoprintk(x)  printk x
-#else
-#define dnegoprintk(x)
-#endif
-
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
-#define ddvtprintk(x)  printk x
-#else
-#define ddvtprintk(x)
-#endif
-
 #ifdef MPT_DEBUG_IOCTL
 #define dctlprintk(x) printk x
 #else
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-09-18 16:13:52.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-09-18 16:20:30.000000000 -0600
@@ -2276,7 +2276,7 @@ mptscsih_slave_alloc(struct scsi_device 
 		if (hd->ioc->bus_type == SPI && sdev->channel == 0 &&
 		    hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
 			vtarget->raidVolume = 1;
-			ddvtprintk((KERN_INFO
+			ddvprintk((KERN_INFO
 				    "RAID Volume @ id %d\n", sdev->id));
 		}
 	}
@@ -2735,7 +2735,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 		status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
 		scsi_status = pReply->SCSIStatus;
 
-		ddvtprintk((KERN_NOTICE "  IOCStatus=%04xh, SCSIState=%02xh, SCSIStatus=%02xh, IOCLogInfo=%08xh\n",
+		ddvprintk((KERN_NOTICE "  IOCStatus=%04xh, SCSIState=%02xh, SCSIStatus=%02xh, IOCLogInfo=%08xh\n",
 			     status, pReply->SCSIState, scsi_status,
 			     le32_to_cpu(pReply->IOCLogInfo)));
 
@@ -2821,7 +2821,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 		}	/* switch(status) */
 
-		ddvtprintk((KERN_NOTICE "  completionCode set to %08xh\n",
+		ddvprintk((KERN_NOTICE "  completionCode set to %08xh\n",
 				completionCode));
 	} /* end of address reply case */
 
@@ -2865,7 +2865,7 @@ mptscsih_timer_expired(unsigned long dat
 			 * If new eh code, do nothing. Wait for OS cmd timeout
 			 *	for bus reset.
 			 */
-			ddvtprintk((MYIOC_s_NOTE_FMT "DV Cmd Timeout: NoOp\n", hd->ioc->name));
+			ddvprintk((MYIOC_s_NOTE_FMT "DV Cmd Timeout: NoOp\n", hd->ioc->name));
 		} else {
 			/* Perform a FW reload */
 			if (mpt_HardResetHandler(hd->ioc, NO_SLEEP) < 0) {
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-09-18 16:12:57.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-09-18 16:23:05.000000000 -0600
@@ -65,6 +65,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_dbg.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -527,7 +528,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
 	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
-			hd->ioc->name, action, io->id));
+			hd->ioc->name, pReq->Action, disk));
 
 	hd->pLocal = NULL;
 	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
@@ -625,6 +626,12 @@ static int mptspi_slave_configure(struct
 
 	mptspi_initTarget(hd, vtarget, sdev);
 
+	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
+		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
+		sdev->id, spi_min_period(scsi_target(sdev)),
+	       	spi_max_offset(scsi_target(sdev)),
+	       	spi_max_width(scsi_target(sdev))));
+
 	if ((sdev->channel == 1 ||
 	     !(hd->ioc->raid_data.isRaid & (1 << sdev->id))) &&
 	    !spi_initial_dv(sdev->sdev_target))
@@ -633,6 +640,36 @@ static int mptspi_slave_configure(struct
 	return 0;
 }
 
+static int
+mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+{
+
+#ifdef MPT_DEBUG_DV
+	if (spi_dv_pending(scsi_target(SCpnt->device)))
+		scsi_print_command(SCpnt);
+#endif
+
+	return mptscsih_qcmd(SCpnt,done);
+}
+
+static void
+mptspi_print_nego(struct _MPT_SCSI_HOST *hd, struct scsi_target *starget, u32 ii)
+{
+	ddvprintk((MYIOC_s_INFO_FMT "id=%d Requested = 0x%08x"
+	    " ( %s factor = 0x%02x @ offset = 0x%02x %s%s%s%s%s%s%s%s)\n",
+	    hd->ioc->name, starget->id, ii,
+	    ii & MPI_SCSIDEVPAGE0_NP_WIDE ? "Wide ": "",
+	    ((ii >> 8) & 0xFF), ((ii >> 16) & 0xFF),
+	    ii & MPI_SCSIDEVPAGE0_NP_IU ? "IU ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_DT ? "DT ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_QAS ? "QAS ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_HOLD_MCS ? "HOLDMCS ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_WR_FLOW ? "WRFLOW ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_RD_STRM ? "RDSTRM ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_RTI ? "RTI ": "",
+	    ii & MPI_SCSIDEVPAGE0_NP_PCOMP_EN ? "PCOMP ": ""));
+}
+
 static void mptspi_slave_destroy(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = scsi_target(sdev);
@@ -660,7 +697,7 @@ static struct scsi_host_template mptspi_
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptscsih_qcmd,
+	.queuecommand			= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
 	.slave_alloc			= mptspi_slave_alloc,
 	.slave_configure		= mptspi_slave_configure,
@@ -728,6 +765,8 @@ static int mptspi_write_spi_device_pg1(s
 	pg1->Header.PageNumber = hdr.PageNumber;
 	pg1->Header.PageType = hdr.PageType;
 
+	mptspi_print_nego(hd, starget, le32_to_cpu(pg1->RequestedParameters));
+
 	if (mpt_config(ioc, &cfg)) {
 		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
 		goto out_free;
