From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 16:17:27 +0200
Message-ID: <53FF39F7.3070004@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaH1ORa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 10:17:30 -0400
In-Reply-To: <53FF2283.9000502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/28/2014 02:37 PM, Hans de Goede wrote:
> Hi,
>
> On 08/28/2014 02:33 PM, Paolo Bonzini wrote:
>> Il 28/08/2014 14:26, Hans de Goede ha scritto:
>>>>> Then, blk_complete_request will do nothing because its call to
>>>>> blk_mark_rq_complete returns true.
>>>>>
>>>>> All this, of course, as long as ->scsi_done is called _before_ eh=
_abort
>>>>> returns.
>>> What about calling scsi_done after eh_abort if eh_abort returned FA=
ILED?
>>
>> I invoke the fifth amendment. :)
>
> Although I appreciate the tongue in cheek answer, this was sort of a =
serious
> question, as at the moment this may happen with the uas driver.
>
As mentioned earlier, as soon as SCSI EH is invoked control
is assumed to be transferred back to the SCSI midlayer.
How the midlayer interprets any return value from the various eh_XX
callbacks is immaterial to the LLDD.

So even if the eh_abort returns FAILED control is still with the SCSI=20
midlayer, so the earlier statements apply.
IE the command will be short-circuited by the block layer anyway if=20
->scsi_done() is called.

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
