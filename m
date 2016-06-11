From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Sat, 11 Jun 2016 12:05:13 +0200
Message-ID: <575BE259.4080901@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <575AC10F.7020504@suse.de>
 <20160610141852.GA28876@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbcFKKFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 06:05:15 -0400
In-Reply-To: <20160610141852.GA28876@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>

On 06/10/2016 04:18 PM, Mike Snitzer wrote:
> On Fri, Jun 10 2016 at  9:30am -0400,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> On 06/10/2016 03:19 PM, Mike Snitzer wrote:
>>> On Mon, May 30 2016 at  3:24am -0400,
>>> Hannes Reinecke <hare@suse.de> wrote:
>>>
>>>> When checking a cloned request there is no need to check
>>>> the overall request size; this won't have changed even
>>>> when resubmitting to another queue.
>>>> Without this patch ppc64le on ibmvfc fails to boot.
>>>
>>> By simply removing the check aren't you papering over the real prob=
lem?
>>> Looking at Martin's commit f31dc1cd490539 (which introduced the cur=
rent
>>> variant of the limits check) I'm not convinced it is equivalent to =
what
>>> he replaced.  I'll look closer in a bit.
>>>
>> The check itself is wrong, as we need (at least) to check the
>> max_hw_sectors here; the request is already fully assembled, so ther=
e is
>> a really good chance he's going beyond the max_sectors.
>> But trying the error still was found to be present.
>> So I decided to rip it out, as the overall value of this check is ze=
ro.
>
> fine, any chance you can improve the header to include these details.
> At least mention that commit f31dc1cd490539 incorrectly removed the
> max_hw_sectors checking.  And then please add these tags to a v2 repo=
st:
>
> Fixes: f31dc1cd490539 ("block: Consolidate command flag and queue lim=
it checks for merges")
> Reported-by: Mark Bergman <mark.bergman@uphs.upenn.edu>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org # 3.7+
>
Okay, will be doing for a repost.

>>> Also you categorized your fix was for "ppc64le on ibmvfc"; whereas =
Mark
>>> has reported this issue (off-list) against x86_64.  By making it se=
em
>>> ppc64le specific I didn't take this patch to be generally applicabl=
e.
>>>
>> Well, it has been observed on ppc64. That doesn't mean _only_ ppc64 =
is
>> affected. If it were ppc64 only it should've been marked as such, ri=
ght?
>
> If it is a generic problem, being specific about the hardware you saw=
 it
> on leads idiots like me to filter unnecessarily ;)
>
> Though I'm curious what you mean by "it should've been marked as
> such".. "it" being what?  The patch?  And how would it have been mark=
ed
> as ppc64 only?
Exactly my point.
I was just trying to figure out what caused you to ignore the patch.

Anyway.

Will be reposting a v2 once Martin is happy.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
