From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: differences in megaraid2 v2.00.9 source from LSIL FTP and 2.4.24 tree
Date: Wed, 3 Nov 2004 07:47:34 -0600
Message-ID: <20041103134734.GA3686@lists.us.dell.com>
References: <20040113125922.58ccb619@philou.gramoulle.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:30288 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261608AbUKCNrj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Nov 2004 08:47:39 -0500
Content-Disposition: inline
In-Reply-To: <20040113125922.58ccb619@philou.gramoulle.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Philippe Gramoull? <philippe.gramoulle@mmania.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 13, 2004 at 12:59:22PM +0100, Philippe Gramoull? wrote:
> 
>  Hi,
> 
> I just compared the original source code from ftp.lsil.com and 2.4.24.
> v2.00.9 megaraid driver and i'd like to know what are the differences and which one i should use.
> 
> I assume that the one in the 2.4.24 is the one to be used but i just wanted to be sure.
> 
> Thanks,
> 
> Philippe
> Lycos Europe
> 
> 
> ~/2.4.24-filer/megaraid$ diff -Nu megaraid2.c ../linux-2.4.24/drivers/scsi/megaraid2.c 
> --- megaraid2.c 2003-09-09 21:24:36.000000000 +0200
> +++ ../linux-2.4.24/drivers/scsi/megaraid2.c    2003-11-28 19:26:20.000000000 +0100
> @@ -398,9 +398,7 @@
>                 // replace adapter->lock with io_request_lock for kernels w/o
>                 // per host lock and delete the line which tries to initialize
>                 // the lock in host structure.
> -               adapter->host_lock = &adapter->lock;
> -
> -               host->lock = adapter->host_lock;
> +               adapter->host_lock = &io_request_lock;

This is because stock 2.4 doesn't have the field host->lock, so
instead the lock must still be &io_request_lock.  This is correct.

> @@ -2402,7 +2400,7 @@
>         *len = (u32)cmd->request_bufflen;
>  
>         if( scb->dma_direction == PCI_DMA_TODEVICE ) {
> -               pci_dma_sync_sg(adapter->host->pci_dev, sgl, cmd->use_sg,
> +               pci_dma_sync_sg(adapter->host->pci_dev, cmd->request_buffer, cmd->use_sg,

There was a bug around this.  Ahh, found it (thanks gmane).  The
latter is correct of course.

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix wrong argument to pci_dma_sync_sg in megaraid
driver
Newsgroups: gmane.linux.scsi
Cc: linux-scsi@vger.kernel.org
Date: Sun, 1 Feb 2004 17:00:32 +0100

sgl is incremented for each element in the routine, but
pci_dma_sync_sg needs the original buffer.


--- 1.59/drivers/scsi/megaraid.c    Fri Jan 23 06:37:03 2004
+++ edited/drivers/scsi/megaraid.c  Sat Jan 31 07:09:25 2004
@@ -1805,7 +1805,7 @@
   *len = (u32)cmd->request_bufflen;
 
    if( scb->dma_direction == PCI_DMA_TODEVICE ) {
-	pci_dma_sync_sg(adapter->dev, sgl, cmd->use_sg,
+				      pci_dma_sync_sg(adapter->dev,
cmd->request_buffer, cmd->use_sg,
				PCI_DMA_TODEVICE);
				}
 

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
