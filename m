From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Fri, 10 Jun 2016 10:18:52 -0400
Message-ID: <20160610141852.GA28876@redhat.com>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com>
 <575AC10F.7020504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbcFJOSy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 10:18:54 -0400
Content-Disposition: inline
In-Reply-To: <575AC10F.7020504@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, Jun 10 2016 at  9:30am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 06/10/2016 03:19 PM, Mike Snitzer wrote:
> > On Mon, May 30 2016 at  3:24am -0400,
> > Hannes Reinecke <hare@suse.de> wrote:
> > 
> >> When checking a cloned request there is no need to check
> >> the overall request size; this won't have changed even
> >> when resubmitting to another queue.
> >> Without this patch ppc64le on ibmvfc fails to boot.
> > 
> > By simply removing the check aren't you papering over the real problem?
> > Looking at Martin's commit f31dc1cd490539 (which introduced the current
> > variant of the limits check) I'm not convinced it is equivalent to what
> > he replaced.  I'll look closer in a bit.
> > 
> The check itself is wrong, as we need (at least) to check the
> max_hw_sectors here; the request is already fully assembled, so there is
> a really good chance he's going beyond the max_sectors.
> But trying the error still was found to be present.
> So I decided to rip it out, as the overall value of this check is zero.

fine, any chance you can improve the header to include these details.
At least mention that commit f31dc1cd490539 incorrectly removed the
max_hw_sectors checking.  And then please add these tags to a v2 repost:

Fixes: f31dc1cd490539 ("block: Consolidate command flag and queue limit checks for merges")
Reported-by: Mark Bergman <mark.bergman@uphs.upenn.edu>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 3.7+

> > Also you categorized your fix was for "ppc64le on ibmvfc"; whereas Mark
> > has reported this issue (off-list) against x86_64.  By making it seem
> > ppc64le specific I didn't take this patch to be generally applicable.
> > 
> Well, it has been observed on ppc64. That doesn't mean _only_ ppc64 is
> affected. If it were ppc64 only it should've been marked as such, right?

If it is a generic problem, being specific about the hardware you saw it
on leads idiots like me to filter unnecessarily ;)

Though I'm curious what you mean by "it should've been marked as
such".. "it" being what?  The patch?  And how would it have been marked
as ppc64 only?
