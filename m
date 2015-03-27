From: Hannes Reinecke <hare@suse.de>
Subject: Re: Scsi Error handling query
Date: Fri, 27 Mar 2015 17:02:16 +0100
Message-ID: <55157F08.3070707@suse.de>
References: <5d00e10b067fd4d0fb82ecdec18dd325@mail.gmail.com> <55142C6D.1060205@suse.de> <bc74695bc632f3cda3ccec360eb6e0ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbbC0QCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 12:02:20 -0400
In-Reply-To: <bc74695bc632f3cda3ccec360eb6e0ae@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org

On 03/26/2015 07:43 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Thursday, March 26, 2015 9:28 PM
>> To: Kashyap Desai; linux-scsi@vger.kernel.org
>> Subject: Re: Scsi Error handling query
>>
>> On 03/26/2015 02:38 PM, Kashyap Desai wrote:
>>> Hi Hannes,
>>>
>>> I was going through one of the slide posted at below link.
>>>
>>> http://events.linuxfoundation.org/sites/events/files/slides/SCSI-EH=
=2Epd
>>> f
>>>
>>> Slide #59 has below data. I was trying to correlate with latest
>>> upstream code, but do not understand few things. Does Linux handle
>>> blocking I/O to the device and target before it actually start lega=
cy EH
>> recovery ?
>>
>> Yes. This is handled by 'scsi_eh_scmd_add()', which adds the command=
 to
>> the
>> internal 'eh_entry' list and starts recovery once all remaining
>> outstanding
>> commands are completed.
>=20
> Thanks Hannes..! Scsi_eh_scmd_add() move shost state to recovery, so =
it
> means  blocking further IO to the Host and not really a limited to
> Device/Target for which command was timed out. Right ?
> I understood that, new improvement of scsi error handling will allow =
IOs to
> the other Devices attached to the host except the IO belongs to speci=
fic
> target.
>=20
> Also, one more thing to clarify... In presentation, term "task set ab=
orts"
> was used. Does this mean task set abort is handled as traversing comp=
lete
> list of timed out command and sending individual TASK ABORT ?
>=20
No. The idea was to send 'task set aborts' as a single TMF.
However, I'm not sure if I'll be going ahead with that one; once
we've issued a 'transport reset the commands will be cone anyway.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
