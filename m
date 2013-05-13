From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 19:50:42 +0300
Message-ID: <CAC9+anLx1AtvG7b6Rw9WCLvQ78cYZAyx2610aRHzuPUfOOO8Nw@mail.gmail.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
 <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com>
 <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com>
 <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com>
 <51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com>
 <519100A5.2060509@suse.de> <51910DB0.70009@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44400 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3EMQvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 12:51:05 -0400
Received: by mail-ee0-f43.google.com with SMTP id b15so3916621eek.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 09:51:03 -0700 (PDT)
In-Reply-To: <51910DB0.70009@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On Mon, May 13, 2013 at 6:58 PM, Jeremy Linton <jlinton@tributary.com> wrote:
> On 5/13/2013 10:03 AM, Hannes Reinecke wrote:
>> The other LUNs haven't reported an error. But how do you know whether they
>> are still okay? The other LUNs might simply be idle, and no commands have
>> been send to them.
>
>         Well, how about generating std inquiry against them if they are idle and the
> given HBA has a device in error state? Then you can make a rough approximation
> of what has failed, and escalate the error handling if all the devices at a
> particular level have failed.
>
>         The midlayer may not even need to send the inquiries. If the individual
> device drivers (sd/st/etc) are responsible for monitoring and error recovery
> then they can be tasked with determining device availability as well. I think
> this solves other problems too. For example, the use of TUR in the midlayer,
> is a problem because it doesn't have enough knowledge about the possible check
> conditions being returned to act on them appropriately.

Such an approach is preferable IMO than the big hammer, especially if
we are talking about a likely condition of using multipath and having
other links over the same host  that do have traffic flowing through
them. If there is traffic already on the same host there is no reason
to do a host reset, if there is no traffic and there are no other
luns, go for the big gun it will not matter to anything else, if there
are other inactive luns some mechanism to trigger some basic traffic
(inquiry/tur) on them is much preferable to just a plain big hammer
application.

It might be that the kernel is not the right place for all of this
diagnostics work but then some interface for an external daemon to do
this diagnostics is preferable to just wielding the big hammer and
killing all traffic.

In my experience if the device doesn't respond it usually just
disappeared from the network, if it is on the network and the task
abort or target reset do not return successfully it is either unlikely
that the host reset will help (the host is fine, device is gone) or
that the host reset is the only way since the host is dead but then a
simple check on all other luns would reveal that quite fast. In many
cases the host controller itself is mostly dead and the driver could
detect that on its own without waiting for the traffic to time out but
that's an issue for each driver to handle.

Baruch

Baruch
