From: Hannes Reinecke <hare@suse.de>
Subject: Re: Scsi Error handling query
Date: Mon, 30 Mar 2015 17:12:57 +0200
Message-ID: <551967F9.9020500@suse.de>
References: <5d00e10b067fd4d0fb82ecdec18dd325@mail.gmail.com> <55142C6D.1060205@suse.de> <bc74695bc632f3cda3ccec360eb6e0ae@mail.gmail.com> <55157F08.3070707@suse.de> <d88ae93f14d83d38941f67a956f1567c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbC3PM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 11:12:59 -0400
In-Reply-To: <d88ae93f14d83d38941f67a956f1567c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org

On 03/30/2015 01:45 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, March 27, 2015 9:32 PM
>> To: Kashyap Desai; linux-scsi@vger.kernel.org
>> Subject: Re: Scsi Error handling query
>>
>> On 03/26/2015 07:43 PM, Kashyap Desai wrote:
>>>> -----Original Message-----
>>>> From: Hannes Reinecke [mailto:hare@suse.de]
>>>> Sent: Thursday, March 26, 2015 9:28 PM
>>>> To: Kashyap Desai; linux-scsi@vger.kernel.org
>>>> Subject: Re: Scsi Error handling query
>>>>
>>>> On 03/26/2015 02:38 PM, Kashyap Desai wrote:
>>>>> Hi Hannes,
>>>>>
>>>>> I was going through one of the slide posted at below link.
>>>>>
>>>>> http://events.linuxfoundation.org/sites/events/files/slides/SCSI-=
EH.
>>>>> pd
>>>>> f
>>>>>
>>>>> Slide #59 has below data. I was trying to correlate with latest
>>>>> upstream code, but do not understand few things. Does Linux handl=
e
>>>>> blocking I/O to the device and target before it actually start
>>>>> legacy EH
>>>> recovery ?
>>>>
>>>> Yes. This is handled by 'scsi_eh_scmd_add()', which adds the comma=
nd
>>>> to the internal 'eh_entry' list and starts recovery once all
>>>> remaining outstanding commands are completed.
>>>
>>> Thanks Hannes..! Scsi_eh_scmd_add() move shost state to recovery, s=
o
>>> it means  blocking further IO to the Host and not really a limited =
to
>>> Device/Target for which command was timed out. Right ?
>>> I understood that, new improvement of scsi error handling will allo=
w
>>> IOs to the other Devices attached to the host except the IO belongs=
 to
>>> specific target.
>>>
>>> Also, one more thing to clarify... In presentation, term "task set
>>> aborts"
>>> was used. Does this mean task set abort is handled as traversing
>>> complete list of timed out command and sending individual TASK ABOR=
T ?
>>>
>> No. The idea was to send 'task set aborts' as a single TMF.
>=20
> Thanks Hannes.!  OK so idea was to have single TMF for "Task set abor=
t."   I
> am not sure how to frame my  next question.. But what if Linux SCSI l=
ayer
> traverse each IO of one particular target and issue individual Task a=
bort?
> Don=E2=80=99t we call that as "task set aborts" ?  How LLD Driver sho=
uld interface
> for "task set aborts" as single TMF ? My understanding is "Task set a=
bort"
> will be internally converted to single Task abort either by SCSI laye=
r or
> HBA FW.
>=20
Why? There _is_ a 'task set abort' TMF defined in SAM.
If the firmware doesn't implement it I'd thought the respective
command to be failed?

However, at this point I'm not sure if 'task set abort' is actually
required; it _should_ be superseded by the new 'transport reset' EH
handler.
On the FC side this will translate into a relogin, which will
automatically abort all outstanding tasks.
SAS even has a dedicated TMF IT NEXUS LOSS, which looks like it
could be used here.

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
