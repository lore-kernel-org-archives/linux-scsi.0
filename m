From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sata_vsc initialization fix
Date: Fri, 23 Apr 2004 11:08:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040423180843.GA862691@sgi.com>
References: <20040423021544.GA874976@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:41799 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264896AbUDWSJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 14:09:40 -0400
Content-Disposition: inline
In-Reply-To: <20040423021544.GA874976@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com, linux-scsi@vger.kernel.org
Cc: erikj@sgi.com, jbarnes@sgi.com

A typo was spotted (DESCIPTOR ==> DESCRIPTOR).


diff -Nru a/drivers/scsi/sata_vsc.c b/drivers/scsi/sata_vsc.c
--- a/drivers/scsi/sata_vsc.c	Thu Apr 22 19:14:14 2004
+++ b/drivers/scsi/sata_vsc.c	Thu Apr 22 19:14:14 2004
@@ -44,6 +44,8 @@
 #define VSC_SATA_TF_CTL_OFFSET		0x29
 
 /* DMA base */
+#define VSC_SATA_UP_DESCRIPTOR_OFFSET	0x64
+#define VSC_SATA_UP_DATA_BUFFER_OFFSET	0x6C
 #define VSC_SATA_DMA_CMD_OFFSET		0x70
 
 /* SCRs base */
@@ -234,6 +236,8 @@
 	port->ctl_addr		= base + VSC_SATA_TF_CTL_OFFSET;
 	port->bmdma_addr	= base + VSC_SATA_DMA_CMD_OFFSET;
 	port->scr_addr		= base + VSC_SATA_SCR_STATUS_OFFSET;
+	writel(0, base + VSC_SATA_UP_DESCRIPTOR_OFFSET);
+	writel(0, base + VSC_SATA_UP_DATA_BUFFER_OFFSET);
 }
 
 
