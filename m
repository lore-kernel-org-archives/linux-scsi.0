From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions
 (v2)
Date: Tue, 22 May 2012 15:33:43 +0200
Message-ID: <4FBB95B7.5070809@suse.de>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <4FBA2BF7.7070500@suse.de> <4FBA60C2.20007@cs.wisc.edu> <CAPXgP10t_pMCJuavrBsNcyv1XKy4WThV8CfVBz-4wD=Q_fq_=w@mail.gmail.com> <4FBA7595.8020400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2EVNdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 09:33:45 -0400
In-Reply-To: <4FBA7595.8020400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Kay Sievers <kay@vrfy.org>, linux-scsi@vger.kernel.org

On 05/21/2012 07:04 PM, Mike Christie wrote:
> On 05/21/2012 11:49 AM, Kay Sievers wrote:
>> On Mon, May 21, 2012 at 5:35 PM, Mike Christie <michaelc@cs.wisc.edu=
> wrote:
>>> On 05/21/2012 06:50 AM, Hannes Reinecke wrote:
>>>> On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
>>>>> The following patches were made over the misc branch of the scsi =
tree.
>>>>>
>>>>> The patches fix a issue where if the device is offlined or IO is
>>>>> failed due to fast_io_fail (fc) /recovery_tmo (iscsi) then comes
>>>>> back, apps do not have a way a nice way to figure out the state
>>>>> has transitioned to running. Apps have to either poll the sysfs s=
tate
>>>>> file or send a SG IO to figure it out. With the patch apps can li=
sten
>>>>> for the KOBJ CHANGE event like some of them (at least udev does) =
do
>>>>> already.
>>>>>
>>>>> v2:
>>>>> - Rebased to misc.
>>>>>
>>>> In principle, yes.
>>>>
>>>
>>> ccing Kay.
>>>
>>>> However, when doing this, we're now sending 'CHANGE' uevents from
>>>> SCSI devices. With the potential of putting _quite_ some strain on=
 udev.
>>>> Kay explicitely debarred me from using uevents for my SCSI sense
>>>
>>> Kay told me to do it this way :) In this case udev was the app we
>>> discovered the issue with, so maybe that is the diff.
>>
>> Hah, I basically only told you not to use online/offline events. :)
>=20
> Yeah, I guess you guys got me confused :) Harold said to send an even=
t
> for this issue. Then later you said "please always use change". I
> thought you and Harold were in sync :(
>=20
>>
>> Uevents are ok to use if we can be sure there is _never_ a storm of
>> events. Uevents are not meant to handle large amounts of events
>> happening at the same time. They must never be used to handle things
>> like reporting errors which are not limited in their rate, or where
>> many devices might send similar events at the same time in a row.
>>
>=20
> In this case you can get many devices sending the same events at the
> same time, because when the transport/connection comes back you all t=
he
> device accessed through that connection will be set to running at the
> same time.
>=20
> So what is the fix for this case? Just send one event for the host or
> transport/connection then have udev loop over all devices accessed
> through that object and fix things up? If so, what type of event do y=
ou
> want? CHANGE event plus some other info to indicate to look at child
> devices?

The 'correct' way would be to send a 'CHANGE' event for the rport /
iSCSI session.
That way we'll be in sync with what's actually happening, and won't
get a spurious duplication of events.

And letting udev rules / programs figure out what's happening and
which devices are affected. Bit like dev_loss_tmo setting, only the
other way around.

Alternative would be to hook into the yet-to-be submitted SCSI sense
code infrastructure.

I'll update the patch for that and send an RFC.

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
