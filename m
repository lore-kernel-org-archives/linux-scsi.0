From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 12:30:26 +0200
Message-ID: <54005642.8050805@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <alpine.LNX.2.00.1408291419070.29948@nippy.intranet> <540018E0.9050907@suse.de> <alpine.LNX.2.00.1408291924010.25858@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaH2Ka3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 06:30:29 -0400
In-Reply-To: <alpine.LNX.2.00.1408291924010.25858@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Robert Elliot <elliot@hp.com>

On 08/29/2014 12:14 PM, Finn Thain wrote:
>
> On Fri, 29 Aug 2014, Hannes Reinecke wrote:
>
>> On 08/29/2014 06:39 AM, Finn Thain wrote:
>>>
>>> On Thu, 28 Aug 2014, Hannes Reinecke wrote:
>>>
>>>> What might happen, though, that the command is already dead and go=
ne
>>>> by the time you're calling ->scsi_done() (if you call it after
>>>> eh_abort). So there might not _be_ a command upon which you can ca=
ll
>>>> ->scsi_done() to start with.
>>>>
>>>> Hence any LLDD need to clear up any internal references after a ca=
ll
>>>> to eh_XXX to ensure it doesn't call ->scsi_done() an in invalid
>>>> command.
>>>>
>>>> So even if the LLDD returns 'FAILED' upon a call to eh_XXX it
>>>> _still_ needs to clear up the internal reference.
>>>
>>> This is a question that has been bothering me too. If the host's
>>> eh_abort_cmd() method returns FAILED, it seems the mid-layer is lia=
ble
>>> to re-issue the same command to the LLD (?)
>>>
>> No.
>> FAILED for any eh_abort_cmd() means that the TMF hasn't been sent.
>
> Makes sense, though it appears to contradict this advice about return=
ing
> SUCCESS in some situations:
> http://marc.info/?l=3Dlinux-scsi&m=3D140923498632496&w=3D2
>
Well, if the LLDD detects an invalid command (ie if it cannot find=20
any internal command matching the midlayer command) that's an=20
automatic success, obviously.

So we should rephrase things to:

- The eh_XXX callback shall return 'SUCCESS' if the respective
   TMF (or equvalent) could be initiated or if the matching command
   reference has already been completed by the LLDD. Otherwise
   the eh_XXX callback shall return 'FAILED'.

>> The command will only ever be re-issued once EH completes.
>
> ...
>
>>
>> But indeed, 'FAILED' is not very meaningful here, leaving the midlay=
er
>> with no information about what happened to the command.
>>
>> Personally I would like to enforce this meaning on the eh_XXX callba=
cks:
>> - upon each eh_XXX callback the LLDD clears any internal references
>>    to the command / command scope (ie eh_abort_cmd clears the
>>    references to the command, eh_lun_reset clears all internal
>>    references to commands to this ITL nexus etc.)
>>    This happens irrespective of the return code.
>> - The eh_XXX callback shall return 'FAILED' if the respective
>>    TMF (or equivalent) could not be initiated.
>> - The eh_XXX callback shall return 'SUCCESS' if the respective
>>    TMF (or equvalent) could be initiated.
>> - After each eh_XXX callback control for this command / command
>>    scope is transferred back to the midlayer; the LLDD shall not
>>    assume the associated command structures to remain valid after
>>    that point.
>
> Perhaps that last constraint should be relaxed to "After the final EH
> callback (whether implemented or unimplemented by the host), command =
/
> command scope is transferred back to the midlayer..."
>
No, that's wrong.

By the time any eh_XXX callbacks are triggered control _is_ already=20
back at the midlayer. IE the command timeout triggered and the block=20
layer already set the REQ_ATOM_COMPLETED flag, short-circuiting any=20
attempts to call ->scsi_done().
So with the callbacks the midlayer actually informs the LLDD about a=20
certain fact; there is nothing the LLDD can do to change ownership=20
at that point.

(Correction: During the call of any eh_XXX callbacks control _is_=20
back at the LLDD, otherwise the callbacks would be pointless. It's
just that the LLDD shouldn't assume the command is valid _after_
any of the eh_XXX callbacks has terminated.)

> A more severe TMF is probably mandatory (e.g. bus reset) but if the d=
river
> author later added a milder one (e.g. bus device reset), your rule wo=
uld
> mean that the existing handler would then operate under new constrain=
ts,
> which might cause surprises.
>
Well, _if_ we were to adopt this rule we obviously have to audit
existing LLDDs if the rule is followed, and tweak them if not.

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
