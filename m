From: Matthew Wilcox <willy@debian.org>
Subject: Re: Scatter Gather question : 2.6.test4 . page to vaddr
Date: Mon, 22 Sep 2003 21:41:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922204109.GY13172@parcelfarce.linux.theplanet.co.uk>
References: <20030922201540.68358.qmail@web60210.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50840 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263281AbTIVUlN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:41:13 -0400
Content-Disposition: inline
In-Reply-To: <20030922201540.68358.qmail@web60210.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: jd <jpd_hp_linux_scsi@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 22, 2003 at 01:15:40PM -0700, jd wrote:
> I see that 2.6 scatterlist.h has eliminated the "address" element
> and uses page struct only, and that  pci_map_sg() is used to 
> populate the dma_address field. I'm not really planning on
> using DMA .
> 
> How can I convert the page * entry 
> pointed to by  SCpnt->request_buffer   back to a vaddr ? 
> I don't see a page-to-vaddr() . function ?

The trick is that there may not be a vaddr for that struct page.  If it's
in highmem on x86, then it only ever gets temporary mappings into the
kernel's space.  You're probably looking for kmap(), kmap_atomic() or,
if you really really know it's a lowmem page, page_address().

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
