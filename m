From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/2] Block I/O while SG reset operation in progress -
 midlayer portion
Date: Fri, 24 Feb 2006 17:35:44 -0500
Message-ID: <43FF8A40.8080702@emulex.com>
References: <43FF39C0.7080509@emulex.com> <20060224201151.GA30144@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60801 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932620AbWBXWf7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 17:35:59 -0500
In-Reply-To: <20060224201151.GA30144@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Well for a couple of reasons. I didn't view it as an actual recovery
function as it's execution doesn't attempt to change the state of the
shost, starget or sdev. It's not part of an escalation policy, etc.
It's essentially performing the same effect as a reset by some other
initiator in a multi-initiator environment, just with i/o failing faster
than it may normally take us to detect it. As for side effects on the
teardown, I don't see anything different than what exists today.
At worst, it should only add a short delay until the ioflow resumes.

I also looked at what it would take to implement a full state change
or piggy back on SHOST_RECOVERY. It's a significant amount of code,
and the addition of a new state brings it's own set of additional
issues to get everything to play right. In the end, I saw very little
change in result, but with lots of code changes.

My main concern was - what is the interface definition we're telling
the LLDD's for the eh routines ?  Does the LLDD expect to always be
entered in them while in the error thread ? Does the LLDD expect that
an eh routine will never be invoked will another call to that routine
is outstanding ?  Obviously, none of these are true with the existing
implementation.

Thoughts ?

-- james


Mike Anderson wrote:
> James Smart <James.Smart@Emulex.Com> wrote:
>> This is the midlayer portion of the patch
>>
>> This patch ensures that i/o is stopped while an eh handler is being
>> processed. It adds a new flag, set by the async reset callers, which
>> augments the host-in-reset checks and stops i/o.  The async reset
>> callers are already synchronized to hold off until the error thread is
>> no longer running.
> 
> Why the new flag instead of calling scsi_host_set_state(shost,
> SHOST_RECOVERY) or a new state if you want different behavior?
> 
> Not using the state model but still doing recovery actions may run into
> issues if these happen while someone tries to remove a host.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
