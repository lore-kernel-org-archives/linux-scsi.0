From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 11:00:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425110002.A9928@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <3EA94263.1020902@rogers.com> <20030425095055.B8776@beaverton.ibm.com> <3EA97456.9060702@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:43650 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263615AbTDYRvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 13:51:40 -0400
Content-Disposition: inline
In-Reply-To: <3EA97456.9060702@rogers.com>; from tluben@rogers.com on Fri, Apr 25, 2003 at 01:45:58PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2003 at 01:45:58PM -0400, Luben Tuikov wrote:
> Patrick Mansfield wrote:

> No, it is NOT different, because I can see your patch deleting
> the good code which currently impements just that.
> 
> All we want is for IO to keep going.  It does, so leave it alone.

It is not clear that the IO will always make forward progress.

> >>2. Why spare_cmd is a pointer? Why? Why?
> >>Wouldn't it be much more *flexible* to be a list_head,
> >>so that maybe we can hook up more commands in the future?
> >>I.e. keep your options open...
> > 
> > 
> > When or if we use more than one spare we can change the code to a
> > list_head. I don't plan to add such code, so I see no reason to use a
> > list_head.
> 
> Yeah, and then you're going to change a WHOLE bunch of code
> everywhere.

No, maybe a few lines, maybe less code than is needed to actually
support dyanmically changing the number of spared/cached commands.

> It's good not to overengineer, but it's even BETTER to know
> when to do so and when to NOT do so.

Well we should never overengineer, but the term is subjective.

We should not have code for functionallity that we do not and do not plan
to use.

> Ideally, commands come out of cache/free_list, travel through
> lists as they go about SCSI Core, and go back to the cache/free_list.
> 
> So the following axiom: scsi command always belongs to a list.

If they are freed (into cache), they are not on any list.

-- Patrick Mansfield
