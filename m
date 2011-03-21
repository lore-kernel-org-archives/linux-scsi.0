From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Mon, 21 Mar 2011 16:38:29 -0400
Message-ID: <20110321203829.GB12157@redhat.com>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
 <1300737774.10634.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1CUUie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 16:38:34 -0400
Content-Disposition: inline
In-Reply-To: <1300737774.10634.37.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Mon, Mar 21 2011 at  4:02pm -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Mon, 2011-03-21 at 15:57 -0400, Mike Snitzer wrote:
> > From: Eddie Williams <eddie.williams@steeleye.com>
> > 
> > Do not sdev_printk() a scsi_device that was, or is being, deleted.
> > 
> > If multiple failures occur (e.g. FC switch with multiple paths fails),
> > and both the active path and next path is failed in the process, the
> > scsi_device associated with the next path can be accessed after it was
> > deleted.
> 
> This treats the symptom, not the cause, doesn't it?  Why do we have a
> reference to an ungot instance of an sdev here ... and should it have
> had a reference taken on it?

Stands to reason, and to be fair Eddie thought that might be the case
too -- I should have shared as much.  I'll take a closer look (quite
busy this week but...).

Finding the root cause in the near-term would be ideal.  Short of that
this "fix" isn't unreasonable.  Only problem with taking it would be if
someone like me didn't know to actively chase the real problem with this
"fix" reverted.  Whereby papering over the real issue.

Anyway, it's now on my plate to sort out.  No idea if I'll do so by the
close of the merge window.  But maybe a real fix to this can go in after
the window closes?

I guess time will tell, thanks.
Mike
