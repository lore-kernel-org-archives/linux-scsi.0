From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4 use __dma_buffer in scsi.h
Date: Thu, 13 Jun 2002 13:52:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206131752.g5DHqdm24049@localhost.localdomain>
References: <roland@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA32764
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2002 10:52:43 -0700
In-Reply-To: Message from Roland Dreier <roland@topspin.com>
   of "13 Jun 2002 10:42:16 PDT." <52fzzr2hzb.fsf@topspin.com>
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@topspin.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

roland@topspin.com said:
> Out of curiousity, how do you deal with someone writing to Scsi_Cmnd
> _before_ the DMA and having that data lost when pci_map_single() with
> PCI_DMA_FROMDEVICE invalidates the cache before writeback? 

The the pci_map_single with PCI_DMA_FROMDEVICE is supposed to do a writeback 
invalidate cycle on the cache when pci_sync_single is called (at least this is 
how it is implemented on parisc) so any writes up to the sync point are 
flushed to memory before the cache line is trashed.

James


