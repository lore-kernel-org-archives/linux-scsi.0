From: Philippe =?ISO-8859-15?Q?Gramoull=E9?=
	<philippe.gramoulle@mmania.com>
Subject: differences in megaraid2 v2.00.9 source from LSIL FTP and 2.4.24
 tree
Date: Tue, 13 Jan 2004 12:59:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113125922.58ccb619@philou.gramoulle.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pgramoul.net2.nerim.net ([80.65.227.234]:20446 "EHLO
	philou.aspic.com") by vger.kernel.org with ESMTP id S264409AbUAML7Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 06:59:25 -0500
Received: from philou.gramoulle.local (philou.gramoulle.local [192.168.254.2])
	by philou.aspic.com (Postfix) with SMTP id ABACD136B4
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2004 12:59:22 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 Hi,

I just compared the original source code from ftp.lsil.com and 2.4.24.
v2.00.9 megaraid driver and i'd like to know what are the differences and which one i should use.

I assume that the one in the 2.4.24 is the one to be used but i just wanted to be sure.

Thanks,

Philippe
Lycos Europe


~/2.4.24-filer/megaraid$ diff -Nu megaraid2.c ../linux-2.4.24/drivers/scsi/megaraid2.c 
--- megaraid2.c 2003-09-09 21:24:36.000000000 +0200
+++ ../linux-2.4.24/drivers/scsi/megaraid2.c    2003-11-28 19:26:20.000000000 +0100
@@ -398,9 +398,7 @@
                // replace adapter->lock with io_request_lock for kernels w/o
                // per host lock and delete the line which tries to initialize
                // the lock in host structure.
-               adapter->host_lock = &adapter->lock;
-
-               host->lock = adapter->host_lock;
+               adapter->host_lock = &io_request_lock;
 
                host->cmd_per_lun = max_cmd_per_lun;
                host->max_sectors = max_sectors_per_io;
@@ -2402,7 +2400,7 @@
        *len = (u32)cmd->request_bufflen;
 
        if( scb->dma_direction == PCI_DMA_TODEVICE ) {
-               pci_dma_sync_sg(adapter->host->pci_dev, sgl, cmd->use_sg,
+               pci_dma_sync_sg(adapter->host->pci_dev, cmd->request_buffer, cmd->use_sg,
                                PCI_DMA_TODEVICE);
        }
