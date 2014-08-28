From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 14:04:40 +0200
Message-ID: <53FF1AD8.9020800@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaH1MEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 08:04:42 -0400
In-Reply-To: <53FB1ACD.1040208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/25/2014 01:15 PM, Paolo Bonzini wrote:
> Il 25/08/2014 12:28, Bart Van Assche ha scritto:
>>
>>  From SPC-4: "7.5.8 Control mode page [ ... ] A task aborted status =
(TAS)
>> bit set to zero specifies that aborted commands shall be terminated =
by
>> the device server without any response to the application client. A =
TAS
>> bit set to one specifies that commands aborted by the actions of an =
I_T
>> nexus other than the I_T nexus on which the command was received sha=
ll
>> be completed with TASK ABORTED status (see SAM-5)."
>
> Note the "aborted by the actions of an I_T nexus other than the I_T
> nexus on which the command was received".
>
> In practice, this means that TASK ABORTED should only happen if you u=
se
> the CLEAR TASK SET tmf and TST is not set to 001b (i.e. _not_ to "per
> I_T nexus") in the Control mode page.  It should never happen for a p=
en
> drive.
>
> Setting TASK ABORTED aside, the important part is that an abort can d=
o
> one of two things:
>
> - complete the command, and then eh_abort should return after the dri=
ver
> has noticed the completion and called the ->scsi_done callback for th=
e
> Scsi_Cmnd*.
>
> - abort the command, and then the driver should never call the
> ->scsi_done callback for the Scsi_Cmnd*.
>
In practice we rely on the latter behaviour; when ->scsi_done is=20
called while the command is under eh_abort _really bad things_
will happen.
As soon as eh_abort is called control is transferred back to the
SCSI midlayer, so any LLDD should never send completions for these
commands back to the midlayer.

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
