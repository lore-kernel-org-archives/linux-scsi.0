From: Hannes Reinecke <hare@suse.de>
Subject: Re: Error handling on FC devices
Date: Mon, 03 Dec 2012 08:15:10 +0100
Message-ID: <50BC517E.4090208@suse.de>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de> <50B78715.2060109@emulex.com> <50B89C2D.8030108@suse.de> <50B8E4AC.8@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2LCHPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2012 02:15:18 -0500
In-Reply-To: <50B8E4AC.8@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@emulex.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "emilne@redhat.com" <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/30/2012 05:54 PM, Mike Christie wrote:
> On 11/30/2012 05:44 AM, Hannes Reinecke wrote:
>> On 11/29/2012 05:02 PM, James Smart wrote:
>>> Always possible - but....   Our f/w works at the FCP level and
>>> below, which means it doesn't know/do SCSI commands - e.g what the
>>> cdb within the FCP CMD frame is; know anything about SCSI device
>>> classes and state; etc. And it shouldn't be required to do so.
>>> Anytime this has been there in the past, it's been problematic.
>>>
>>> if we want to do this - we should add it to the midlayer/transport.
>>>
>> D'accord. Transport layer looks like a good fit.
>>
>> What we should be doing is hooking up 'bus_reset' to be equivalent t=
o
>> REMOVE I_T NEXUS (SAS is already doing this).
>
> Do you mean the scsi eh bus reset callout and if so does that work on
> multiple targets but REMOVE I_T NEXUS only will operate on one at a
> time? I think it would be cleaner to add a new callout that works lik=
e
> the target reset one where the scsi-ml loops over the targets for the
> drivers.
>
Well, looking at QLogic and Emulex both emulate a bus reset with a=20
loop over each target and invoke a target reset there.
I somewhat fail to see the rationale behind it, other than emulating=20
the bus reset behaviour on SPI.
Given that the original target reset already failed (otherwise we=20
wouldn't be doing a bus reset), I doubt a _second_ target reset
will lead to a different result.

So invoking REMOVE I_T NEXUS here can only improve matters :-)

I'm all for renaming bus_reset, though :-)

>>
>> In our case a REMOVE I_T NEXUS would be roughly equivalent to
>> scsi_remote_port_delete(); only we should be starting aborting
>> outstanding I/O directly and not waiting for fast_fail_tmo
>> to kick in.
>>
>
> To abort IO, will you be calling the drivers terminate_rport_io or
> dev_loss_tmo_callbk? If so I just wanted to warn you that I noticed t=
hat
> some drivers will only initiate the aborting/cleanup of IO in there. =
So
> if you call those callouts and expect that when finished scsi-ml can
> free the scsi command and pass the request back up, I think we could =
hit
> some races with memory issues.
>
Yeah, I know.
What I had in mind was to invoke terminate_rport_io() and then wait=20
for a certain time until either all outstanding commands have been
processes (ie starget->busy drops to zero) or the port state changed.
I'm not quite sure as for how long I should be waiting, but=20
dev_loss_tmo will be a good upper limit here.

As said, I'll be posting a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
