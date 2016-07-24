From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sun, 24 Jul 2016 09:10:04 +0200
Message-ID: <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

On 07/24/2016 12:13 AM, Bart Van Assche wrote:
> On 07/23/16 05:43, Hannes Reinecke wrote:
>> On 07/22/2016 10:45 PM, Martin K. Petersen wrote:
>>>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>>>
>>> Hannes> Add a sysfs queue attribute 'zoned' to display the zone lay=
out
>>> Hannes> for zoned devices.
>>>
>>> Not quite one value per file :(
>>>
>> Yes.
>> But I wanted to display the zone layout in a concise way allowing
>> user-space programs to determine the zone layout without having to
>> issue a 'REPORT ZONES' command themselves.
>> I found it slightly pointless to add one sysfs entry per zone,
>> and at the same time a simple 'zone_size' attribute wouldn't cover a=
ll
>> possibilities.
>>
>> However, as SMR drives seem to stabilise around having a fixed zone =
size
>> (with a possible exemption of the last zone to cover left-overs)
>> I'd be fine a replace this with a single 'zone_size' attribute which
>> could be set to eg '-1' for drives which indeed would implement vari=
able
>> zone sizes.
>=20
> It's not that hard to convert the information exported by
> queue_zoned_show() from a single sysfs attribute into one directory p=
er
> zone. Doing so would make it much easier for scripts to parse that
> information and would also avoid that the zone information has to be
> truncated because not all of it fits into a single page.
>=20
But this is precisely what I've tried to avoid.
Creating one file or directory per zone would mean we'll end up with
rough 20k files/directories.
Which I found rather excessive.

Of course, it that is not a concern that I can easily convert it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-block" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
