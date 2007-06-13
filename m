From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/6] mpt fusion: fc loginfo using defines from the header
Date: Wed, 13 Jun 2007 16:34:36 -0600
Message-ID: <20070613223435.GA21178@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35695 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbXFMWit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:38:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

rewrite of  mpt_fc_log_info to use the enum/defines from mpi_log_fc.h

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-06-13 14:46:35.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-06-13 15:39:17.000000000 -0600
@@ -64,6 +64,7 @@
 #endif
 
 #include "mptbase.h"
+#include "lsi/mpi_log_fc.h"
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define my_NAME		"Fusion MPT base driver"
@@ -6349,14 +6350,37 @@ ProcessEventNotification(MPT_ADAPTER *io
 static void
 mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info)
 {
-	static char *subcl_str[8] = {
-		"FCP Initiator", "FCP Target", "LAN", "MPI Message Layer",
-		"FC Link", "Context Manager", "Invalid Field Offset", "State Change Info"
-	};
-	u8 subcl = (log_info >> 24) & 0x7;
+	char *desc = "unknown";
+
+	switch (log_info & 0xFF000000) {
+	case MPI_IOCLOGINFO_FC_INIT_BASE:
+		desc = "FCP Initiator";
+		break;
+	case MPI_IOCLOGINFO_FC_TARGET_BASE:
+		desc = "FCP Target";
+		break;
+	case MPI_IOCLOGINFO_FC_LAN_BASE:
+		desc = "LAN";
+		break;
+	case MPI_IOCLOGINFO_FC_MSG_BASE:
+		desc = "MPI Message Layer";
+		break;
+	case MPI_IOCLOGINFO_FC_LINK_BASE:
+		desc = "FC Link";
+		break;
+	case MPI_IOCLOGINFO_FC_CTX_BASE:
+		desc = "Context Manager";
+		break;
+	case MPI_IOCLOGINFO_FC_INVALID_FIELD_BYTE_OFFSET:
+		desc = "Invalid Field Offset";
+		break;
+	case MPI_IOCLOGINFO_FC_STATE_CHANGE:
+		desc = "State Change Info";
+		break;
+	}
 
-	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): SubCl={%s}\n",
-			ioc->name, log_info, subcl_str[subcl]);
+	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): SubClass={%s}, Value=(0x%06x)\n",
+			ioc->name, log_info, desc, (log_info & 0xFFFFFF));
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
