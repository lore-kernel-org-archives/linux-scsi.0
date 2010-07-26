From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: rq-based mpath failed path on SCSI target failure (malformed
 discard)
Date: Mon, 26 Jul 2010 13:40:31 -0400
Message-ID: <20100726174031.GA11088@redhat.com>
References: <20100726133008.GA26771@redhat.com>
 <20100726150000.GA31293@redhat.com>
 <4C4DB67D.1070903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0GZRkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 13:40:46 -0400
Content-Disposition: inline
In-Reply-To: <4C4DB67D.1070903@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, Jul 26 2010 at 12:23pm -0400,
Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 07/26/2010 10:00 AM, Mike Snitzer wrote:
> >
> >diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> >index ec2b43e..125c80f 100644
> >--- a/drivers/md/dm-mpath.c
> >+++ b/drivers/md/dm-mpath.c
> >@@ -1272,6 +1272,9 @@ static int do_end_io(struct multipath *m, struct request *clone,
> >  	if (error == -EOPNOTSUPP)
> >  		return error;
> >
> >+	if (clone->cmd_flags&  REQ_DISCARD)
> >+		return error;   /* pass all discard request failures up */
> >+
> 
> 
> If a discard where failed due to a transport problem then you are
> going to fail the IO instead of just retrying on another path.
> 
> You need something like Hannes's work to pass up the sense, or
> something like generic block error codes like I started to work on,
> so you know why the IO failed.

Thanks for reminding me about previous work done in the area of error
propagation.

Yes, we certainly need a more intelligent check but since neither of the
solutions you referenced are available yet we're better off failing the
discard in the near-term.  Clearly not ideal but failing a path when an
optional discard IO failure occurs isn't going to fly either.

I'll slap a FIXME on this interim "fix".

In parallel I'll see if I can track down Hannes' and/or your work,
rebase it as needed, etc.  If you have updated patches please let me
know.

Thanks,
Mike
