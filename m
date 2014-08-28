From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 17:13:13 +0200
Message-ID: <53FF4709.9040801@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaH1PNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 11:13:15 -0400
In-Reply-To: <53FF430F.5060103@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/28/2014 04:56 PM, Paolo Bonzini wrote:
> Il 28/08/2014 16:17, Hannes Reinecke ha scritto:
>>>
>> As mentioned earlier, as soon as SCSI EH is invoked control
>> is assumed to be transferred back to the SCSI midlayer.
>> How the midlayer interprets any return value from the various eh_XX
>> callbacks is immaterial to the LLDD.
>>
>> So even if the eh_abort returns FAILED control is still with the SCS=
I
>> midlayer, so the earlier statements apply.
>> IE the command will be short-circuited by the block layer anyway if
>> ->scsi_done() is called.
>
> As I parsed it, the question is not whether the short-circuiting will
> happen.  It's whether you will have use-after-free bugs or not if you
> call ->scsi_done() after eh_abort returns FAILED.
>
> Paolo
>
No. Once eh_abort is called control is back with the SCSI midlayer.
(Read: REQ_ATOM_COMPLETE is set in req->atomic_flags).
So you can call ->scsi_done() at your hearts content and nothing will=20
happen.
What might happen, though, that the command is already dead and gone by=
=20
the time you're calling ->scsi_done() (if you call it after eh_abort).
So there might not _be_ a command upon which you can call ->scsi_done()
to start with.

Hence any LLDD need to clear up any internal references after a call to=
=20
eh_XXX to ensure it doesn't call ->scsi_done() an in invalid command.

So even if the LLDD returns 'FAILED' upon a call to eh_XXX it _still_=20
needs to clear up the internal reference.
Either that or return 'FAILED' for any later eh_XXX function until the=20
internal references can be cleared up.

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
