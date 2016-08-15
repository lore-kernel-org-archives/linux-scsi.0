From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: always return reservation conflict
Date: Mon, 15 Aug 2016 09:40:39 -0400
Message-ID: <20160815134039.GA5569@redhat.com>
References: <1470141392-25479-1-git-send-email-hch@lst.de>
 <1470141392-25479-2-git-send-email-hch@lst.de>
 <20160811183832.GA27144@lst.de>
 <20160815130829.GA14829@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbcHONkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 09:40:40 -0400
Content-Disposition: inline
In-Reply-To: <20160815130829.GA14829@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Mon, Aug 15 2016 at  9:08P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Not sure how Hannes' original patch was overlooked but...

It wasn't overlooked.  It was very much unresolved.  The original thread
unraveled to all sorts of PR edge case concerns (and doubt about whether
anything relies on the current multipath handling of reservation
conflicts).  See patchwork thread below.

Obviously you have found a problematic case which requires Hannes'
patch.  So there is definitely increased pressure to fix this.

> One issue I see with the patch is it will return -EBADE regardless of
> whether 'queue_if_no_path' is set.  That's fine (since path isn't being
> failed for this case any more).  But why not just return error
> immediately?
> 
> But taking a step back, shouldn't all paths be tried once before
> returning an error?  Obviously that'd impose the use of a new
> 'conflict_seen' (or whatever) flag at the end of 'struct pgpath'.  And
> then only return error if the flag is set.
> 
> I threw together the following RFC patch to illustrate what I'm
> thinking, but thinking about this further it is tough to know all paths
> have seen the reservation conflict (my patch assumes if 'conflict_seen'
> is set then the conflict iterated through all paths.. but if paths
> aren't being failed there isn't a guarantee that the path selector
> didn't just hand us back the same path that just experienced the
> conflict).

Seems we still need a more sophisticated approach.  But I'm left
wondering: if we didn't do it would anything notice?  Sadly, the same
big question from the original thread from a year ago:

https://patchwork.kernel.org/patch/6797111/

> So this is throw-away for now (and I'll get Hannes' patch applied for
> 4.8-rc3, with the tweak of returning -EBADE immediately):

Unfortunately, I'm _not_ staging Hannes' patch until I have James
Bottomley's Ack (given his original issues with the patch haven't been
explained away AFAICT).

Mike
