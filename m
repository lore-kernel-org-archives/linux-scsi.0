From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym2: remove code to handle DMA_BIDIRECTION requests
Date: Thu, 15 Sep 2005 13:16:09 +0100
Message-ID: <20050915121609.GA26713@infradead.org>
References: <20050914134131.GA9700@lst.de> <43296531.5090709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60809 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751163AbVIOMQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:16:12 -0400
Content-Disposition: inline
In-Reply-To: <43296531.5090709@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@lst.de>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Sep 15, 2005 at 10:12:33PM +1000, Douglas Gilbert wrote:
> Christoph Hellwig wrote:
> > The upper layer doesn't send these down since 2.4.x (or 2.6 in
> > practice), so no need to handle it.  Inline sym_setup_data_pointers
> > into it's only caller so we can fail gracefully in the case we'd get
> > one neverless.
> 
> Christoph,
> I have no objection to this patch.
> 
> I would like to flag that at some stage in the
> future the SCSI (or whatever it may be called)
> subsystem will need to support true bidirectional
> commands (there are a few of these in SBC-2 and
> lots of them in OSD). To do it properly I think we
> need two scatter gather lists, one for data out
> (to the device) and one for data in (from the device).
> The SBC-2 XDWRITEREAD command indicates that the data out
> is done before the data in (from the device); I'm not
> sure whether that ordering is always the case.

Yes, we will need to support truely bidirectional commands one
day, but hopefully never on SPI HBAs ;-)

At the same point we'll probably need to support > 16 byte CDBs
aswell, and we'll need to switch to dynamically allocating the
actual ->cmnd buffer (maybe only if it's > 12 bytes?).

Sounds like a nice research projects for someone's Bacchelors
thesis if anyone out there is looking for something like that ;-)
