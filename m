From: Christoph Hellwig <hch@lst.de>
Subject: unchecked_isa_dma on sparcv9
Date: Tue, 29 Apr 2003 10:19:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030429101925.A20537@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:25102 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261198AbTD2IHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 04:07:10 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: davem@redhat.com
Cc: linux-scsi@vger.kernel.org

drivers/scsi/pluto.c contains the following code:

#ifdef __sparc_v9__
			host->unchecked_isa_dma = 1;
#endif

The only thing host->unchecked_isa_dma = 1 does is to add a __GFP_DMA
flag to certain memory allocations, but IIRC __GFP_DMA is a noop on
sparcv9.  So what is this supposed to do?

