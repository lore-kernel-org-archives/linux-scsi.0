From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] aacraid: update dma mapping
Date: Wed, 30 Nov 2005 18:49:51 +0000
Message-ID: <20051130184951.GA18583@infradead.org>
References: <1133375778.2288.23.camel@markh1.pdx.osdl.net> <1133376327.3312.43.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15013 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751456AbVK3Stz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:49:55 -0500
Content-Disposition: inline
In-Reply-To: <1133376327.3312.43.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Nov 30, 2005 at 12:45:27PM -0600, James Bottomley wrote:
> On Wed, 2005-11-30 at 10:36 -0800, Mark Haverkamp wrote:
> > This patch changes map_single to map_page in compliance with
> > recommendations made in the IO-Perf howto document to prevent bounce
> > buffering of DMA requests.
> 
> Erm, there's a misunderstanding somewhere.  You're replacing correct
> pci_map_single calls with its more difficult to use pci_map_page.  This
> has absolutely zero performance impact and adds the risk that because
> pci_map_page is more complex to use, someone gets it wrong somewhere.
> Really, for block devices pci_map_single is the absolutely correct
> interface.  pci_map_page should really only be used by the net stack for
> packet fragment mapping.

And the really nice thing is that this whole non-S/G I/O path will go away
completely for 2.6.16 :)

