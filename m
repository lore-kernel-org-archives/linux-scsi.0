From: Christoph Hellwig <hch@lst.de>
Subject: osst changes required to move forward to block request
Date: Mon, 6 Feb 2006 14:19:44 +0100
Message-ID: <20060206131944.GA1769@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20442 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932083AbWBFNTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 08:19:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: linux-scsi@vger.kernel.org

Hi Willem,

do you still maintain the osst driver?  We're moving forward to
completly get rid of the scsi_request structure in the scsi midlayer,
and osst is the only upper level driver still using it.  I've tried to
convert it similar to st, but gave up.  The biggest problem for me is
the scsi_request reuse over the driver where a pointer to a pointer to
a scsi_request is passed along all the callchain, and I have a really
hard time to find out whether the functions actually looks it, or only
reuse it.  The latter isn't nessecary these days that the slab allocator
behind struct scsi_request does a very good job, and definitly not
needed after converting away from it.

If you're still interested in the driver it would be very nice if you
could untangle it so that the scsi_request is only passed along in
places where subroutines need to look at it - after that converting
the driver should be more along the lines of st so a lot easier.  I'd
be more than happy to lend a helping hand or to in the conversion once
I actually understand what I'm doing :)  It would be a pity to either
stop the scsi subsystem from moving forward because of osst or breaking
the driver.


p.s. there's quite a few other changes in st that osst hasn't caught up
on, maybe it's time for a big resync?
