From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/9] block/scsi: Implement SMR drive support
Date: Sat, 9 Apr 2016 10:01:45 +0200
Message-ID: <5708B6E9.50400@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <CAJVOszAp_u2JQcDxbVatPKkFN7TKp7kxqauBBvSrmcWjeuSYDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbcDIIBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Apr 2016 04:01:49 -0400
In-Reply-To: <CAJVOszAp_u2JQcDxbVatPKkFN7TKp7kxqauBBvSrmcWjeuSYDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/08/2016 08:35 PM, Shaun Tancheff wrote:
> On Mon, Apr 4, 2016 at 5:00 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Hi all,
>>
>> here's a patchset implementing SMR (shingled magnetic recording)
>> device support for the block and SCSI layer.
>>
>> There are two main parts to it:
>> - mapping the 'RESET WRITE POINTER' command to the 'discard' functio=
nality.
>>    The 'RESET WRITE POINTER' operation is pretty close to the existi=
ng
>>    'discard' functionality with the 'discard_zeroes_blocks' bit set.
>>    So I've added a new 'reset_wp' provisioning mode for this.
>
> Completely agree with the REQ_OP_DISCARD -> Reset WP translation
> seems like a good idea. I have tried something similar and ended up
> essentially adding a 'reset wp' flag instead.
> Now I am optimistic to see if I can use you patch to get the
> discard -> reset wp working in my device mapper.
>
It works quite well here with my setup, although I've tripped across tw=
o=20
caveats:

- We currently don't handle conventional zones.
   It would make sense to fallback to normal block zeroing here.
- Issuing 'RESET WP' is dead slow (at least on the prototypes I've had)
   Short-circuiting it for empty zones is a _major_ performance win her=
e;
   the time for issuing discards for an entire drive is reduced by
   several orders of magnitude. So you absolutely need an in-kernel
   zone tree for this.

>> - Adding a 'zone' pointer to the request queue. This pointer holds a=
n
>>    RB-tree with the zone information, which can be used by other lay=
ers
>>    to access the write pointer.
>
> Here is where I have some concerns. Having a common in-kernel
> shadow of the drive's zone state seems problematic to me.
>
Well, this is the general SMR programming model, is it not?
And as already pointed out above you really want this tree to be presen=
t=20
to avoid unnecessary RESET WP calls.
You also need it to format READ calls correctly for host-managed drives=
;=20
from my understanding of the programming model any READ call crossing=20
the write pointer will be aborted.
Which you could easily circumvent by splitting the READ call in two=20
parts, one up to the read pointer and another beyond it. For which agai=
n=20
you need the zone tree.

> Also if I am understanding the direction here it is to hold the zone
> information in an rbtree. Since that comes to just under 30,000
> entries I think it would be better to shift to an array of
> write pointer offsets.
>
The thing is that using an rbtree might actually be faster than an=20
array; the rbtree entries easily fit into the processor cache, whereas=20
the array doesn't. So you might end up having a slower access when usin=
g=20
arrays despite being easier to code.

> At the moment my translation layer keeps track of activity and state
> of all the zones on the drive so that is how I have been handling
> the zone data up to this point.
>
As outlined above: Any driver/filesystem need access to the zone states=
=20
as it might need to align its internal structures to the zones.
But you also need to keep track of the zones in the SCSI layer so as to=
=20
format the RESET WP correctly. Which means you basically need a common =
tree.

As you might've seen I've also programmed my own zoned device-mapper=20
device, caching individual zones. We should discuss if those two=20
approached can't be merged, to end up with a common device-mapper targe=
t.

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
