From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 16:22:08 +0200
Message-ID: <53FF3B10.1040401@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>	 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>	 <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <1409229105.714.14.camel@br9vgx5g.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaH1OWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 10:22:10 -0400
In-Reply-To: <1409229105.714.14.camel@br9vgx5g.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/28/2014 02:31 PM, Martin Peschke wrote:
> On Thu, 2014-08-28 at 14:04 +0200, Hannes Reinecke wrote:
>> On 08/25/2014 01:15 PM, Paolo Bonzini wrote:
>>> - abort the command, and then the driver should never call the
>>> ->scsi_done callback for the Scsi_Cmnd*.
>>>
>> In practice we rely on the latter behaviour; when ->scsi_done is
>> called while the command is under eh_abort _really bad things_
>> will happen.
>> As soon as eh_abort is called control is transferred back to the
>> SCSI midlayer, so any LLDD should never send completions for these
>> commands back to the midlayer.
>
> Mmh, then there is a small race window starting at the point in time
> when the abort function of an LLDD is called up to the point in time
> when that abort function has taken the necessary measures to make sur=
e
> that scsi_done won't be called for a racing command completion , isn'=
t
> it?
>
No, that's fine. The timeout function is under control of the block=20
layer, which sets an atomic flag on the request before calling the=20
timeout function.
And ->scsi_done() essentially just calls 'blk_complete_request();, whic=
h=20
checks the very same flag before raising the block soft irq.

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
