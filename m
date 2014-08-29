From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 12:49:30 +0200
Message-ID: <54005ABA.2020602@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <alpine.LNX.2.00.1408291419070.29948@nippy.intranet> <540018E0.9050907@suse.de> <alpine.LNX.2.00.1408291924010.25858@nippy.intranet> <54005642.8050805@suse.de> <54005871.4040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaH2Ktc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 06:49:32 -0400
In-Reply-To: <54005871.4040300@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Robert Elliot <elliot@hp.com>

On 08/29/2014 12:39 PM, Hans de Goede wrote:
> Hi,
>
> On 08/29/2014 12:30 PM, Hannes Reinecke wrote:
>> On 08/29/2014 12:14 PM, Finn Thain wrote:
>>>
>>> On Fri, 29 Aug 2014, Hannes Reinecke wrote:
>>>
>>>> On 08/29/2014 06:39 AM, Finn Thain wrote:
>>>>>
>>>>> On Thu, 28 Aug 2014, Hannes Reinecke wrote:
>>>>>
>>>>>> What might happen, though, that the command is already dead and =
gone
>>>>>> by the time you're calling ->scsi_done() (if you call it after
>>>>>> eh_abort). So there might not _be_ a command upon which you can =
call
>>>>>> ->scsi_done() to start with.
>>>>>>
>>>>>> Hence any LLDD need to clear up any internal references after a =
call
>>>>>> to eh_XXX to ensure it doesn't call ->scsi_done() an in invalid
>>>>>> command.
>>>>>>
>>>>>> So even if the LLDD returns 'FAILED' upon a call to eh_XXX it
>>>>>> _still_ needs to clear up the internal reference.
>>>>>
>>>>> This is a question that has been bothering me too. If the host's
>>>>> eh_abort_cmd() method returns FAILED, it seems the mid-layer is l=
iable
>>>>> to re-issue the same command to the LLD (?)
>>>>>
>>>> No.
>>>> FAILED for any eh_abort_cmd() means that the TMF hasn't been sent.
>>>
>>> Makes sense, though it appears to contradict this advice about retu=
rning
>>> SUCCESS in some situations:
>>> http://marc.info/?l=3Dlinux-scsi&m=3D140923498632496&w=3D2
>>>
>> Well, if the LLDD detects an invalid command (ie if it cannot find a=
ny
 >> internal command matching the midlayer command) that's an=20
automatic success, obviously.
>>
>> So we should rephrase things to:
>>
>> - The eh_XXX callback shall return 'SUCCESS' if the respective
>>    TMF (or equvalent) could be initiated or if the matching command
>>    reference has already been completed by the LLDD. Otherwise
>>    the eh_XXX callback shall return 'FAILED'.
>
> Your talking about "could be initiated", so that means that at this
> point the abort does not yet have to be completed, do I get that
> right? What should the LLDD then do when the abort finishes,
> call eh_scsi_done on the cmnd ?
>
Correct. It's up to the LLDD whether it waits for the TMF to=20
complete before returning or if it just kicks off the TMF and
returns immediately.
In the latter case the LLDD obviously has to be prepared to handle
concurrent TMFs.

scsi_eh_done() is the internal 'scsi_done' callback for commands
issued during SCSI EH. This is _not_ the completion routine for=20
TMFs. That's again up to the LLDD to implement TMF completion if he=20
chooses to implement synchronous TMFs.

No LLDD should _ever_ touch nor call scsi_eh_done().

> What about the abort never finishing (timeout), does the mid layer
> track this, or should the LLDD do that?
>
TMFs have not timeout associated with them (sadly), to the LLDD=20
needs to track it internally.
(And please do. We've run into quite some issues with LLDDs _not_
implementing a TMF timeout.)

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
