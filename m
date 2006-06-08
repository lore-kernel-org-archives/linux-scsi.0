From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 8 Jun 2006 19:46:18 +0200
Message-ID: <20060608174618.GA22826@lst.de>
References: <20060603112113.GA17018@lst.de> <1149788401.3436.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:8418 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964924AbWFHRqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 13:46:22 -0400
Content-Disposition: inline
In-Reply-To: <1149788401.3436.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org

On Thu, Jun 08, 2006 at 01:40:01PM -0400, James Bottomley wrote:
> On Sat, 2006-06-03 at 13:21 +0200, Christoph Hellwig wrote:
> > Various scsi drivers use scsi_cmnd.buffer and scsi_cmnd.bufflen in their
> > queuecommand functions.  Those fields are internal storage for the
> > midlayer only and are used to restore the original payload after
> > request_buffer and request_bufflen have been overwritten for EH.  Using
> > the buffer and bufflen fields means they do very broken things in error
> > handling.
> 
> We probably need this too, don't we?

At this point both values are always the same.  The patch I sent is just
driver fixes, all the core changes are in the second patch I sent out as
an rfc.

