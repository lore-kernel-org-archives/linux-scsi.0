From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Tue, 21 Feb 2012 09:42:22 -0500
Message-ID: <20120221144145.GA4743@redhat.com>
References: <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
 <20120221031854.GA468@redhat.com>
 <yq1pqd825zt.fsf@sermon.lab.mkp.net>
 <20120221065504.GB468@redhat.com>
 <yq1linw1i6e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2BUOml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 09:42:41 -0500
Content-Disposition: inline
In-Reply-To: <yq1linw1i6e.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Tue, Feb 21 2012 at  7:31am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> This patch fixed the issue for me (though I'm still missing why
> Mike> bio->bi_phys_segments was 0 given blkdev_issue_write_same() sets
> Mike> it):
> 
> Ok, I see what's going on. You have your own dm-specific make request
> function. When cloning the original bio phys_segments isn't carried
> over. And that's why we see 0 in sd.

Ah, yes indeed.  I was just setting out to answer the why on it so
you've saved me some time, thanks!

> For discard this is not a problem because we hardwire things in sd.c
> regardless of what was passed down. And besides you have special
> handling for mapping discards in DM.

sd allocating the page used for discard was what enabled DM to have
discard support; otherwise cloning a discard required allocation of the
page and it all got _really_ ugly.

> I was trying to avoid perpetuating Christoph's horrible hack (his words,
> not mine). But maybe it's better to do it the same way as for discard so
> we only have to have to deal with pure evil in one place.

Which hack are you referring to?  sd allocates the page used for
discard (I had a hand in that work, along with tomo, and don't hold it
to be too big a hack really).

But I'm not immediately seeing a clean way to do so for WRITE SAME
because the user provided buffer would need to get down to sd somehow.

> I'll contemplate a bit...
> 
> 
> PS. The good news is that your async stuff works when I set phys_segs to
> 1 in sd.

Yeah, it worked with the patch I provided in my previous mail too.  But
ultimately the async stuff wasn't working for me due to merging.
