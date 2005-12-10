From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Sat, 10 Dec 2005 09:28:27 +0000
Message-ID: <20051210092827.GA4356@infradead.org>
References: <4399CF7B.7060708@s5r6.in-berlin.de> <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de> <20051210084832.GS26185@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63650 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965119AbVLJJ2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 04:28:33 -0500
Content-Disposition: inline
In-Reply-To: <20051210084832.GS26185@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, James.Bottomley@steeleye.com

On Sat, Dec 10, 2005 at 09:48:33AM +0100, Jens Axboe wrote:
> On Fri, Dec 09 2005, Stefan Richter wrote:
> > scsi: dont allow DMA_TO_DEVICE with zero data length
> > 
> > When preparing a request in scsi_lib or in a SCSI high-level driver,
> > always set a transfer direction of DMA_NONE if data length is zero,
> > even for alleged write requests. (Extended patch derived from Jens
> > Axboe's version.)
> > 
> > Write requests with request buffer length == 0 lead to kernel panic
> > or oops if channeled through sbp2:
> > http://marc.theaimsgroup.com/?l=linux1394-devel&m=113399994920181
> > http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435
> > 
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> My quick grep just showed the one, I'd encourage you to turn this into a
> static inline function instead of duplicating the same code again 3 (or
> more) times.

Actually Mike has code pending to remove all copies but the scsi_lib.c
one.
