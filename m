From: Christoph Hellwig <hch@lst.de>
Subject: Re: unchecked_isa_dma on sparcv9
Date: Tue, 29 Apr 2003 12:50:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030429125017.A21769@lst.de>
References: <20030429101925.A20537@lst.de> <20030429.001511.23033900.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:34575 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261328AbTD2KiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 06:38:09 -0400
Content-Disposition: inline
In-Reply-To: <20030429.001511.23033900.davem@redhat.com>; from davem@redhat.com on Tue, Apr 29, 2003 at 12:15:11AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 29, 2003 at 12:15:11AM -0700, David S. Miller wrote:
>    The only thing host->unchecked_isa_dma = 1 does is to add a __GFP_DMA
>    flag to certain memory allocations, but IIRC __GFP_DMA is a noop on
>    sparcv9.  So what is this supposed to do?
> 
> It's bogus, delete it.

James, could you please apply the following patch?


--- 1.10/drivers/scsi/pluto.c	Thu Feb 20 14:26:15 2003
+++ edited/drivers/scsi/pluto.c	Tue Apr 29 11:27:54 2003
@@ -246,11 +246,6 @@
 				host->max_channel = inq->channels;
 				host->irq = fc->irq;
 
-#ifdef __sparc_v9__
-				host->unchecked_isa_dma = 1;
-#endif
-
-
 				fc->channels = inq->channels + 1;
 				fc->targets = inq->targets;
 				fc->ages = ages;
