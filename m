From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Thu, 20 Jan 2005 15:57:16 +0000
Message-ID: <20050120155716.GA4000@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C12EA1B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37550 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262170AbVATP5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 10:57:16 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EA1B@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 20, 2005 at 10:54:47AM -0500, James.Smart@Emulex.Com wrote:
> > No, sorry for have been unclear.  I want a pointer to the remote port
> > structure in the fc_target transport data.  Every driver needs the
> > linkage of these two, and instead of everyone having it in their
> > private data we'd better move it to the fc_transport data structure.
> 
> Ok. It's already there. What this boils down do is exactly your last
> statement (and our driver doesn't do it - we'll fix it).
> 
> Note: there's a flipside here... with the remote port stuff, we had
> removed almost all the reasons for a fc driver to reference a scsi_target.
> The only place we really had to was in the case the older fc_transport/xxx
> sysfs attributes (which all but one exist only for compatibility).
> 
> We could move this into the remote port structure (already set up for this)
> which will always exist for a scsi_target. Even so, I think extending the
> scsi target and fixing the calling sequence is the correct thing to do.

This sounds like a good idea, but I wonder if we have userland relying
on those attributes already.  But given that the fc transport class
was mostly a joke before you encehanced it it might be worth breaking
it..

