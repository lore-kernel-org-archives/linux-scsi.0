From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Mon, 25 Jul 2016 07:56:02 +0200
Message-ID: <b3c579f5-bbfa-7553-d8f3-d3f57bed876b@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
 <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
 <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
 <65e6de30-4811-969b-6c9e-312104e1ae6a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbcGYF4H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 01:56:07 -0400
In-Reply-To: <65e6de30-4811-969b-6c9e-312104e1ae6a@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@hgst.com>

On 07/24/2016 03:51 PM, Bart Van Assche wrote:
> On 07/24/16 06:37, Bart Van Assche wrote:
>> On 07/24/16 00:10, Hannes Reinecke wrote:
>>> On 07/24/2016 12:13 AM, Bart Van Assche wrote:
>>>> On 07/23/16 05:43, Hannes Reinecke wrote:
>>>>> On 07/22/2016 10:45 PM, Martin K. Petersen wrote:
>>>>>>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>>>>>>
>>>>>> Hannes> Add a sysfs queue attribute 'zoned' to display the zone
>>>>>> layout
>>>>>> Hannes> for zoned devices.
>>>>>>
>>>>>> Not quite one value per file :(
>>>>>>
>>>>> Yes.
>>>>> But I wanted to display the zone layout in a concise way allowing
>>>>> user-space programs to determine the zone layout without having t=
o
>>>>> issue a 'REPORT ZONES' command themselves.
>>>>> I found it slightly pointless to add one sysfs entry per zone,
>>>>> and at the same time a simple 'zone_size' attribute wouldn't cove=
r all
>>>>> possibilities.
>>>>>
>>>>> However, as SMR drives seem to stabilise around having a fixed zo=
ne
>>>>> size
>>>>> (with a possible exemption of the last zone to cover left-overs)
>>>>> I'd be fine a replace this with a single 'zone_size' attribute wh=
ich
>>>>> could be set to eg '-1' for drives which indeed would implement
>>>>> variable
>>>>> zone sizes.
>>>>
>>>> It's not that hard to convert the information exported by
>>>> queue_zoned_show() from a single sysfs attribute into one director=
y per
>>>> zone. Doing so would make it much easier for scripts to parse that
>>>> information and would also avoid that the zone information has to =
be
>>>> truncated because not all of it fits into a single page.
>>>>
>>> But this is precisely what I've tried to avoid.
>>> Creating one file or directory per zone would mean we'll end up wit=
h
>>> rough 20k files/directories.
>>> Which I found rather excessive.
>>>
>>> Of course, it that is not a concern that I can easily convert it.
>>
>> If there are 10K zones and since queue_zoned_show() is limited to on=
e
>> page then only a very small fraction of the zone information will be
>> available through sysfs. I remember from your presentations that rea=
ding
>> the zone information is slow. Is 10K zones a typical value or a wors=
t
>> case value?
>=20
> (replying to my own e-mail)
>=20
> Something I should have asked before: is the zone information intende=
d
> for end users or rather for software developers? In the latter case,
> have you considered to use debugfs instead of sysfs to export this
> information? From Documentation/filesystems/debugfs.txt: "Unlike /pro=
c,
> which is only meant for information about a process, or sysfs, which =
has
> strict one-value-per-file rules, debugfs has no rules at all."
>=20
I would be perfectly fine with exporting the zone information via debug=
fs.
But at the same time I would like to have a simple sysfs representation
for SMR drives which can be utilized by mkfs and friend.
Typically SMR drives have a fixed zone size, and more often than not th=
e
size of the zones is identical.
So mkfs would benefit from knowing the fixed zone layout as it then can
arrange the filesystem structures to align to those zones.
At the same time it doesn't need to know the write pointer, so full zon=
e
information is not required here.
And during normal operation ideally the zone information is handled
within the kernel, so again userspace doesn't necessarily need to
have access to the full zone information.

So I guess I'll redo this one to export a sysfs attribute 'zone_size'
(if the zones are of identical size), and make the full zone informatio=
n
available via debugfs.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
