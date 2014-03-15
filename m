From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel bug triggered in multipath
Date: Sat, 15 Mar 2014 06:22:57 -0700
Message-ID: <20140315132257.GB13647@infradead.org>
References: <1394795632-86434-1-git-send-email-hare@suse.de>
 <20140314111520.GA17288@infradead.org>
 <20140314162111.GB14188@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaCONXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2014 09:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20140314162111.GB14188@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Fri, Mar 14, 2014 at 12:21:11PM -0400, Mike Snitzer wrote:
> DM multipath has a role in insuring the desired scsi_dh is attached and
> that it holds a reference on the attached scsi_dh.
> 
> I'm open to ideas of how dm-multipath could avoid having _any_ role here
> but it isn't so simple to avoid, dm-multipath does 3 things in this
> area (ranging from lightest to heaviest relative to scsi_dh interface use):
> 1) get reference on scsi_dh that is already attached -- most widely used
>    now that the scsi_dh matching code has been improved to get correct
>    scsi_dh attached during scsi device scan)
> 2) no scsi_dh was attached, but one should be -- really shouldn't happen
>    anymore
> 3) switch from the scsi_dh that was auto-attached by scsi_dh matching to
>    some user-specified override -- shouldn't be needed now but a user may
>    have a custom scsi_dh they've developed.

What we currently have surely is a bit of a layering violation.  I don't
think it's urgent or overly important to fix it now, but I see two ways
out:

 a) move the handler registration to dm-multipath.  This still leaves
 the problem on figuring out if a handler supports a device, but at
 least that problem is inside the handlers now.
 b) move the path selectors to the block layer, and have the methods
 provided indirect off the requeuest_queue

b) seems like the cleanest layering, although in the case of SCSI (the
only one that matters at the moment) that would give us a double
indirection.

