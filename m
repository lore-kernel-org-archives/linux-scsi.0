From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 07 Dec 2006 12:16:17 -0600
Message-ID: <1165515378.4698.24.camel@mulgrave.il.steeleye.com>
References: <265807.57572.qm@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45143 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162930AbWLGSRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 13:17:00 -0500
In-Reply-To: <265807.57572.qm@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Andrew Morton <akpm@osdl.org>, mdr@sgi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2006-12-06 at 12:24 -0800, Luben Tuikov wrote:
> NEEDS_RETRY _does_ terminate, after it exhausts the retries.  But since
> by the ASC value we know that no amount of retries is going to work,
> this chunk of the patch resolves it quicker, i.e. eliminates the
> "NEEDS_RETRY" pointless retries (given the SK/ASC combination).

I agree that it's useful behaviour.  However, the change header should
be something like "scsi_error: don't retry for unrecoverable medium
errors" not "infinite retries .."

> > > -	if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> > > +	if (good_bytes &&
> > > +	    scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> > >  		return;
> > 
> > What exactly is this supposed to be doing?  its result is identical to
> > the code it's replacing (because of the way scsi_end_request() processes
> > its second argument), so it can't have any effect on the stated problem.
> 
> I suppose this is true, but I'd rather it not even go in
> scsi_end_request as (cmd, uptodate=1, good_bytes=0, retry=0) and complete
> at the bottom as (cmd, uptodate=0, total_xfer, retry=0).

But, logically, this isn't part of the change set ... the behaviour
you're altering is unrelated to the change set details, so this piece
shouldn't be in.

James


