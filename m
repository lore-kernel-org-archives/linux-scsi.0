From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 5/9] mptfusion: sas nexus loss support
Date: Tue, 11 Jul 2006 17:25:35 -0600
Message-ID: <20060711232535.GE12249@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14546 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932253AbWGKXi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:38:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

sas nexus loss support for systems that suport failover.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-07-11 12:42:53.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-07-11 12:58:55.000000000 -0600
@@ -66,6 +66,7 @@
 
 #include "mptbase.h"
 #include "mptscsih.h"
+#include "lsi/mpi_log_sas.h"
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define my_NAME		"Fusion MPT SCSI Host driver"
@@ -667,8 +668,24 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			}
 			break;
 
-		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 		case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:		/* 0x004B */
+			if ( ioc->bus_type == SAS ) {
+				u16 ioc_status = le16_to_cpu(pScsiReply->IOCStatus);
+				if (ioc_status & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
+					u32 log_info = le32_to_cpu(mr->u.reply.IOCLogInfo);
+					log_info &=SAS_LOGINFO_MASK;
+					if (log_info == SAS_LOGINFO_NEXUS_LOSS) {
+						sc->result = (DID_BUS_BUSY << 16);
+						break;
+					}
+				}
+			}
+
+			/*
+			 * Allow non-SAS & non-NEXUS_LOSS to drop into below code
+			 */
+
+		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			/* Linux handles an unsolicited DID_RESET better
 			 * than an unsolicited DID_ABORT.
