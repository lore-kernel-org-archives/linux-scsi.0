From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 17:50:58 -0400
Message-ID: <482B5EC2.7010302@emulex.com>
References: <1210700704.16304.1.camel@localhost.localdomain> <1210793893.3075.6.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52777 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYENVvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 17:51:09 -0400
In-Reply-To: <1210793893.3075.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Just from a point of first principles, what makes you think the target
> port queue depth of an array is anything like constant?  All the
> information I've got back from array vendors over the years leads me to
> conclude that it's dynamically determined based on resources available
> at the time the array services the request.  Additionally, I've been
> told that even a heuristic rule of thumb value varies with the array
> cache size (which is a quantity not reflected in the inquiry strings).

Well, I know there are fixed limits based on the context limits in their
interface chips. Tachyons are a good example of this, especially some of
the older ones. There are also a lot of arrays that are sold in fixed
configurations so they don't have the variability you mention.

But, I agree with you. There are a number of arrays where it does vary
based on the configuration of the array that isn't reflected by the
Inquiry strings. And, there are others that melt down based on how busy
they are internally. I've also seen others melt down because the cmd
storm they are receiving overwhelms them so badly they can't generate
the TASK_SET_FULL responses. What I saw work in many of these cases was
the introduction of a tgt limit, especially as manipulating it as an
aggregate of all the lun queue depths never worked right.

So - you're right, it isn't always the case they are static. But, static
is a good starting point. And if there's a sysfs tunable on top of it,
to tailor for the configuration, you solve much of this variability
argument.

> My best guess for the way of handling this is that we should be using
> the Doug Leaford track_queue_full infrastructure but on a per target
> bases.

I don't fully agree, as it really depends on whether the queue fulls,
reported on a lun level, really apply to a target level resource.
Additionally, the queue_full handling has issues due to: a) the target
has to generate the queue_fulls, and your storm may have overwhelmed
it by several degrees. You've killed the array performance while you
are hoping to level out the load; b) there's always questions on how/when you
ramp up and at what rate, which is confused again if the queue full
wasn't because of target-level resources. We also have to be careful
that there aren't two queue full handlers working at the same time - one
at the target level, and another at the lun level (which is in the LLDs
currently).

Many times, having a target limit was the simplest knob with the best
bang for the buck. It was also the easiest to explain to admins on
its effect on array load  (try explaining those cyclical ramp ups/downs
to an admin and why they can't set a knob and start to get consistent
behavior).

There is merit in both, but I'm sticking with the most bang for the buck.

-- james s
