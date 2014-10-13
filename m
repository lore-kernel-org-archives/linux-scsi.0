From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Mon, 13 Oct 2014 03:23:39 -0700
Message-ID: <20141013102339.GA8765@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
 <543B9827.2060305@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJMKXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2014 06:23:49 -0400
Content-Disposition: inline
In-Reply-To: <543B9827.2060305@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On Mon, Oct 13, 2014 at 11:15:19AM +0200, Bart Van Assche wrote:
> At least to me patches 1/4..3/4 look like nice cleanup patches. Regarding
> patch 4/4: I'm not sure yet what's the best way for addressing potentially
> concurrent SG_SCSI_RESET ioctl calls. As far as I know many SCSI LLDs have
> been implemented assuming that eh_*_reset_handler() calls are serialized per
> SCSI host. Does this mean that a mutex has to be added to avoid that an
> eh_*_reset_handler() call can be triggered via an ioctl while at the same
> time the SCSI error handler thread is invoking one of the
> eh_*_reset_handler() callback functions due to SCSI error handling ?

Both the existing code and my new code still serialize
eh_*_reset_handler callers using the crude tmf_in_progress flag. Using
a proper lock for it would seem preferable to me, as would be bouncing
the work for SG_SCSI_RESET to the EH thread.

