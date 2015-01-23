From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Fri, 23 Jan 2015 05:12:49 -0800
Message-ID: <20150123131249.GA8045@infradead.org>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbbAWNMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 08:12:50 -0500
Content-Disposition: inline
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 23, 2015 at 01:05:30PM +0100, Bart Van Assche wrote:
> There is some confusion in the SCSI core and in SCSI LLDs around the
> meaning of sc_data_direction and whether or not this member can have the
> value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
> series are:

I wonder if we should change the code to set DMA_BIDIRECTIONAL for
bidi commands.  That seems a lot more logical than the current
version.

Also I don't think all the debug checks for bidi commands that you
change should stay at all - driver need to set the QUEUE_FLAG_BIDI to
ever see a bidi command.

It would also nice to add a host template flag for bidi support instead
of having to poke into the block layer request_queue while we're at it.
