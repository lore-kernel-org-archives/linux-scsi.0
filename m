From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Thu, 04 Apr 2013 08:26:55 +0200
Message-ID: <515D1D2F.7050007@suse.de>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com> <51432503.5000703@acm.org> <51436DB0.8030406@cs.wisc.edu> <514372DC.40709@acm.org> <5146BDBD.3070408@suse.de> <5159F6E6.9030900@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763276Ab3DDG06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Apr 2013 02:26:58 -0400
In-Reply-To: <5159F6E6.9030900@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, "Bryn M. Reeves" <bmr@redhat.com>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>

On 04/01/2013 11:06 PM, James Smart wrote:
>=20
> On 3/18/2013 3:09 AM, Hannes Reinecke wrote:
>> On 03/15/2013 08:13 PM, Bart Van Assche wrote:
>>> On 03/15/13 19:51, Mike Christie wrote:
>>>> On 03/15/2013 08:41 AM, Bart Van Assche wrote:
>>>>> How about using the value of scsi_cmnd.jiffies_at_alloc to finish
>>>>> only
>>>>> those SCSI commands in the host reset handler that exceeded a
>>>>> certain
>>>>> processing time ?
>>>>
>>>> We basically do this now. When a scsi command times out the scsi
>>>> layer
>>>> blocks the host from processing new commands and waits for all
>>>> outstanding commands to either finish normally or timeout. When al=
l
>>>> commands have finished or timedout, then we start the scsi eh
>>>> code. So,
>>>> by the time we have go to the scsi eh callbacks we are in a state
>>>> where
>>>> all the commands being processed by the eh have exceeded a certain
>>>> processing time.
>>>>
>>>> If you mean you want to drop the block and wait part, then I
>>>> think it
>>>> could speed things up to do the abort callbacks while other IO is
>>>> running (as long as the driver can support it). However if the
>>>> abort
>>>> fails and you need to escalate to operations like resets which
>>>> interfere
>>>> with multiple commands, then the driver/scsi-ml does not have much
>>>> choice in what it does cleanup wise. There would be no point in
>>>> checking
>>>> the jiffies_at_alloc. The commands that are going to be affected
>>>> by the
>>>> tmf or host reset operation must be returned to the scsi-ml for
>>>> retries
>>>> or failure upwards.
>>>
>>> Hello Mike,
>>>
>>> It seems like there is a misunderstanding. With my comment I was no=
t
>>> referring to the SCSI ML but to the SCSI LLD. LLD drivers like
>>> ib_srp keep track of outstanding SCSI requests. With the SRP
>>> protocol it is possible to tell the InfiniBand HCA not to deliver
>>> completions for outstanding requests by closing the connection used
>>> for SRP communication. Hence my suggestion to finish SCSI commands
>>> that were queued longer than a certain time ago from inside the LLD
>>> host reset handler. I'm not sure though whether all types of FC
>>> HBA's allow something equivalent.
>>>
>> Well, this is not quite identical to what I've been trying to
>> achieve with this patch.
>> This patch is for an individual rport which has gone out to lunch.
>> Sure we could down the link from the HBA, but that would terminate
>> I/O to _all_ connected rports, not just the malfunctioning one.
>> So that wouldn't help us here.
>>
>> The closest equivalent to that would be a port logout; however, as
>> discussed in the I_T nexus reset thread we would need another
>> callout to the LLDs here as this definitely needs LLD support
>> and none of the current LLDs have it implemented.
>>
>> Cheers,
>>
>> Hannes
>=20
> I think lpfc survives your rport state change as : part of the lld
> behavior on the callback, to clean up reference counts, is to abort
> all i/o that is outstanding to the rport.   So the ref checking not
> only protects lpfc from prematurely freeing a structure (my real
> concern), but also just happens to abort all i/o.  We got lucky.
>=20
> I still believe the I_T_nexus reset is the right way to solve this.
>=20
Yes, but this would be an even more intrusive patch.
And we would need to implement yet another callback into the LLDDs
which need to be implemented there, too.

But for this to make any sense we would need to revamp the scsi
error handler, as the current problem is that error recovery takes
too long. Adding yet another callback will make the escalation chain
even longer.

So yeah, in the long run I_T nexus reset is the correct way of doing
things, but in the short term I would opt to make port_state
writeable to simulate an I_T nexus reset.

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
