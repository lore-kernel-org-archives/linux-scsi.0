From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] sata_vsc initialization fix
Date: Thu, 22 Apr 2004 19:15:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040423021544.GA874976@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:35689 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264572AbUDWCRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 22:17:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com, linux-scsi@vger.kernel.org

I neglected to initialize a couple of registers that are usually
zero, but not always.  :-)

Please apply.

jeremy


# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1783  -> 1.1784 
#	drivers/scsi/sata_vsc.c	1.6     -> 1.7    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/04/22	jeremy@tomahawk.engr.sgi.com	1.1784
# Fix sata_vsc to initialize upper address pointer registers.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/sata_vsc.c b/drivers/scsi/sata_vsc.c
--- a/drivers/scsi/sata_vsc.c	Thu Apr 22 19:14:14 2004
+++ b/drivers/scsi/sata_vsc.c	Thu Apr 22 19:14:14 2004
@@ -44,6 +44,8 @@
 #define VSC_SATA_TF_CTL_OFFSET		0x29
 
 /* DMA base */
+#define VSC_SATA_UP_DESCIPTOR_OFFSET	0x64
+#define VSC_SATA_UP_DATA_BUFFER_OFFSET	0x6C
 #define VSC_SATA_DMA_CMD_OFFSET		0x70
 
 /* SCRs base */
@@ -234,6 +236,8 @@
 	port->ctl_addr		= base + VSC_SATA_TF_CTL_OFFSET;
 	port->bmdma_addr	= base + VSC_SATA_DMA_CMD_OFFSET;
 	port->scr_addr		= base + VSC_SATA_SCR_STATUS_OFFSET;
+	writel(0, base + VSC_SATA_UP_DESCIPTOR_OFFSET);
+	writel(0, base + VSC_SATA_UP_DATA_BUFFER_OFFSET);
 }
 
 
