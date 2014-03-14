From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel bug triggered in multipath
Date: Fri, 14 Mar 2014 12:21:11 -0400
Message-ID: <20140314162111.GB14188@redhat.com>
References: <1394795632-86434-1-git-send-email-hare@suse.de>
 <20140314111520.GA17288@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbaCNQVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 12:21:42 -0400
Content-Disposition: inline
In-Reply-To: <20140314111520.GA17288@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Fri, Mar 14 2014 at  7:15am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Mar 14, 2014 at 12:13:52PM +0100, Hannes Reinecke wrote:
> > Starting multipath on a cciss device will cause a kernel
> > warning to be triggered. Problem is that we're using the
> > ->queuedata field of the request_queue to derefence the
> > scsi device; however, for other (non-SCSI) devices this
> > points to a totally different structure.
> > So we should rather be using accessors here which make
> > sure we're only returning valid SCSI device structures.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Looks reasonable to me as a short term fix.  Long ter mwe should stop
> calling into scsi-specific code directly from the DM code.

DM multipath has a role in insuring the desired scsi_dh is attached and
that it holds a reference on the attached scsi_dh.

I'm open to ideas of how dm-multipath could avoid having _any_ role here
but it isn't so simple to avoid, dm-multipath does 3 things in this
area (ranging from lightest to heaviest relative to scsi_dh interface use):
1) get reference on scsi_dh that is already attached -- most widely used
   now that the scsi_dh matching code has been improved to get correct
   scsi_dh attached during scsi device scan)
2) no scsi_dh was attached, but one should be -- really shouldn't happen
   anymore
3) switch from the scsi_dh that was auto-attached by scsi_dh matching to
   some user-specified override -- shouldn't be needed now but a user may
   have a custom scsi_dh they've developed.

I have no problem with this patch, added safety-net and all, but
bottomline: if scsi_dh interfaces were being called against a DM
multipath request_queue that is a bug.  In practice that never happens
in supported configurations.  AFAICT, Hannes just stumbled upon it cause
he was trying to get cciss working with dm-multipath.

Acked-by: Mike Snitzer <snitzer@redhat.com>
