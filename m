From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 00/18] ALUA update and Referrals support
Date: Wed, 20 Nov 2013 08:44:48 +0100
Message-ID: <528C6870.6090607@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>	 <1384904569.4307.34.camel@haakon3.risingtidesystems.com> <1384905976.4307.39.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384905976.4307.39.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/20/2013 01:06 AM, Nicholas A. Bellinger wrote:
> On Tue, 2013-11-19 at 15:42 -0800, Nicholas A. Bellinger wrote:
>> Hey Hannes!
>>
>> On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
>>> Hi Nic,
>>>
>>> here's the second version of my ALUA update & Referrals support pat=
ches.
>>> As per request I've split up the supported states into individual
>>> attributes, and while there I've also renamed the rather confusing
>>> 'alua_access_type' and 'alua_access_status' into 'alua_management_t=
ype'
>>> and 'alua_status_modification', respectively.
>>>
>>> The other features are:
>>>
>>> - Make supported states configurable:
>>>   We should make the list of supported ALUA states configurable,
>>>   as some setups would possibly like to support a small subset
>>>   of ALUA states only.
>>> - Asynchronous transitioning: I've switched 'transitioning'
>>>   handling to use a workqueue, that should allow us to simulate
>>>   asynchronous transitioning modes. IE TCM should now be capable
>>>   of handling requests while in transitioning, and properly termina=
te
>>>   these with the correct sense code.
>>> - Include target device descriptor in VPD page 83
>>>   For the ALUA device handler we'd need to identify the target devi=
ce
>>>   where a given target port belongs to. So include the respective
>>>   values in the VPD page.
>>>
>>> And, of course, referrals support.
>>>
>>
>> Ok, even though it is late, I've applied this series to for-next.
>>
>> So the one main concern here is that the user visible changes to
>> existing ALUA configfs attributes end up breaking the lio-utils code
>> related to ALUA that depend upon them, which will need to be resolve=
d
>> separately.
>>
>> However, this breakage is pretty minor and having more sensible +
>> consistent attribute naming is worth the inconvenience.
>>
>=20
> OK, I'm having second thoughts about the user-visible changes to
> existing configfs attributes..
>=20
> I'm fine with these types of changes, but need some more time to sort
> out how it's going to effect existing userspace dependencies.  The on=
e
> that immediately made do a double take is changing 'alua_access_state=
'
> to change input/output, but keep the same attribute name which makes
> backwards compatibility alot more tricky.
>=20
It's just a matter of parsing, innit?

> So all that said, let's defer to v3.14 for this particular series, an=
d
> sort out the user visable changes first, and make adjustments as
> necessary from there.
>=20
> WDYT..?
>=20
Sigh.
Another patchset getting nowhere.

Okay, here's the thing:
The patchset can be split into three individual parts:
The ALUA update proper, which affects only the internal flow of
control (patches 1-6 and 11-16), then there's the ALUA configfs
modifications (patches 7-10) and the Referrals support (17 and 18).
If you have second thoughts you should be able to pull patches 7-10;
the rest will work as designed even without them.

But then, there's not much difference on having all the patches in
for 3.13, and sort out the userspace then, or wait for the next
round and adjust the userspace during that time.

Anyway, I don't mind either way. You're the maintainer, you get to
decide. As least I got feedback about the patchset, which is more
than one can hope for nowadays :-(

Give me a shout what you prefer, and I'll adapt the patchset
accordingly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
