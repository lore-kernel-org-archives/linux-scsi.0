From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/9] - fusion - added mptspi debug
Date: Mon, 29 Jan 2007 09:44:06 -0700
Message-ID: <20070129164405.GA1892@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60533 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXA2Qna (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:43:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

helpfull debug for mptspi module

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/Makefile	2007-01-28 12:57:29.000000000 -0700
@@ -8,6 +8,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_INIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
+#EXTRA_CFLAGS += -DMPT_DEBUG_DV
 #EXTRA_CFLAGS += -DMPT_DEBUG_TM
 
 #
@@ -21,8 +22,6 @@
 #CFLAGS_mptbase.o += -DMPT_DEBUG_RESET
 #
 #  For mptscsih:
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_DV
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_NEGO
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_REPLY
 #
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
@@ -791,12 +791,6 @@ typedef struct _mpt_sge {
 #define ddvprintk(x)
 #endif
 
-#ifdef MPT_DEBUG_NEGO
-#define dnegoprintk(x)  printk x
-#else
-#define dnegoprintk(x)
-#endif
-
 #if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
 #define ddvtprintk(x)  printk x
 #else
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
@@ -65,6 +65,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_dbg.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -454,6 +455,56 @@ mptspi_target_destroy(struct scsi_target
 	starget->hostdata = NULL;
 }
 
+/**
+ *	mptspi_print_write_nego - negotiation parameters debug info that is being sent
+ *	@hd: Pointer to a SCSI HOST structure
+ *	@starget: SCSI target
+ *	@ii: negotiation parameters
+ *
+ */
+static void
+mptspi_print_write_nego(struct _MPT_SCSI_HOST *hd, struct scsi_target *starget, u32 ii)
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
+/**
+ *	mptspi_print_read_nego - negotiation parameters debug info that is being read
+ *	@hd: Pointer to a SCSI HOST structure
+ *	@starget: SCSI target
+ *	@ii: negotiation parameters
+ *
+ */
+static void
+mptspi_print_read_nego(struct _MPT_SCSI_HOST *hd, struct scsi_target *starget, u32 ii)
+{
+	ddvprintk((MYIOC_s_INFO_FMT "id=%d Read = 0x%08x"
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
 static int mptspi_read_spi_device_pg0(struct scsi_target *starget,
 			     struct _CONFIG_PAGE_SCSI_DEVICE_0 *pass_pg0)
 {
@@ -507,6 +558,8 @@ static int mptspi_read_spi_device_pg0(st
 	err = 0;
 	memcpy(pass_pg0, pg0, size);
 
+	mptspi_print_read_nego(hd, starget, le32_to_cpu(pg0->NegotiatedParameters));
+
  out_free:
 	dma_free_coherent(&ioc->pcidev->dev, size, pg0, pg0_dma);
 	return err;
@@ -681,6 +734,12 @@ static int mptspi_slave_configure(struct
 
 	mptspi_initTarget(hd, vtarget, sdev);
 
+	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
+		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
+		sdev->id, spi_min_period(scsi_target(sdev)),
+		spi_max_offset(scsi_target(sdev)),
+		spi_max_width(scsi_target(sdev))));
+
 	if ((sdev->channel == 1 ||
 	     !(mptspi_is_raid(hd, sdev->id))) &&
 	    !spi_initial_dv(sdev->sdev_target))
@@ -708,6 +767,11 @@ mptspi_qcmd(struct scsi_cmnd *SCpnt, voi
 		return 0;
 	}
 
+#ifdef MPT_DEBUG_DV
+	if (spi_dv_pending(scsi_target(SCpnt->device)))
+		scsi_print_command(SCpnt);
+#endif
+
 	return mptscsih_qcmd(SCpnt,done);
 }
 
@@ -806,6 +870,8 @@ static int mptspi_write_spi_device_pg1(s
 	pg1->Header.PageNumber = hdr.PageNumber;
 	pg1->Header.PageType = hdr.PageType;
 
+	mptspi_print_write_nego(hd, starget, le32_to_cpu(pg1->RequestedParameters));
+
 	if (mpt_config(ioc, &cfg)) {
 		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
 		goto out_free;
