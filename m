From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Tue, 2 Aug 2016 16:35:40 +0200
Message-ID: <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de>
 <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021AbcHBPXp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 11:23:45 -0400
In-Reply-To: <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>, Christoph Hellwig <hch@lst.de>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>

On 08/01/2016 07:07 PM, Shaun Tancheff wrote:
> On Mon, Aug 1, 2016 at 4:41 AM, Christoph Hellwig <hch@lst.de> wrote:
>>
>> Can you please integrate this with Hannes series so that it uses
>> his cache of the zone information?
> 
> Adding Hannes and Damien to Cc.
> 
> Christoph,
> 
> I can make a patch the marshal Hannes' RB-Tree into to a block report, that is
> quite simple. I can even have the open/close/reset zone commands update the
> RB-Tree .. the non-private parts anyway. I would prefer to do this around the
> CONFIG_SD_ZBC support, offering the existing type of patch for setups that do
> not need the RB-Tree to function with zoned media.
> 
> I do still have concerns with the approach which I have shared in smaller
> forums but perhaps I have to bring them to this group.
> 
> First is the memory consumption. This isn't really much of a concern for large
> servers with few drives but I think the embedded NAS market will grumble as
> well as the large data pods trying to stuff 300+ drives in a chassis.
> 
> As of now the RB-Tree needs to hold ~30000 zones.
> sizeof() reports struct blk_zone to use 120 bytes on x86_64. This yields
> around 3.5 MB per zoned drive attached.
> Which is fine if it is really needed, but most of it is fixed information
> and it can be significantly condensed (I have proposed 8 bytes per zone held
> in an array as more than adequate). Worse is that the crucial piece of
> information, the current wp needed for scheduling the next write, is mostly
> out of date because it is updated only after the write completes and zones
> being actively written to must work off of the last location / size that was
> submitted, not completed. The work around is for that tracking to be handled
> in the private_data member. I am not saying that updating the wp on
> completing a write isn’t important, I am saying that the bi_end_io hook is
> the existing hook that works just fine.
> 
Which _actually_ is not true; with my patches I'll update the write
pointer prior to submit the I/O (on the reasoning that most of the time
I/O will succeed) and re-read the zone information if an I/O failed.
(Which I'll have to do anyway as after an I/O failure the write pointer
status is not clearly defined.)

I have thought about condensing the RB tree information, but then I
figured that for 'real' SMR handling we cannot assume all zones are of
fixed size, and hence we need all the information there.
Any condensing method would assume a given structure of the zones, which
the standard just doesn't provide.
Or am I missing something here?

As for write pointer handling: yes, the write pointer on the zones is
not really useful for upper-level usage.
Where we do need it is to detect I/O which is crossing the write pointer
(eg when doing reads over the entire zone).
As per spec you will be getting an I/O error here, so we need to split
the I/O on the write pointer to get valid results back.

> This all tails into domain responsibility. With the RB-Tree doing half of the
> work and the ‘responsible’ domain handling the active path via private_data
> why have the split at all? It seems to be a double work to have second object
> tracking the first so that I/O scheduling can function.
> 
Tracking the zone states via RB trees is mainly to handly host-managed
drives seamlessly. Without an RB tree we will be subjected to I/O errors
during boot, as eg with new drives we inevitably will try to read beyond
the write pointer, which in turn will generate I/O errors on certain drives.
I do agree that there is no strict need to setup an RB tree for
host-aware drives; I can easily add an attribute/flag to disable RB
trees for those.
However, tracking zone information in the RB tree _dramatically_ speeds
up device initialisation; issuing a blkdev_discard() for the entire
drive will take _ages_ without it.

> Finally is the error handling path when the RB-Tree encounters and error it
> attempts to requery the drive topology virtually guaranteeing that the
> private_data is now out-of-sync with the RB-Tree. Again this is something
> that can be better encapsulated in the bi_end_io to be informed of the
> failed I/O and schedule the appropriate recovery (including re-querying the
> zone information of the affected zone(s)).
> 
Well, if we have an RB tree with write pointers of course we need to
re-read the zone information on failure (and I thought I did that?).
Plus the error information will be propagated via the usual mechanism,
so they need to take care of updating any information in ->private_data.

I'm perfectly fine with integrating your patches for the various
blkdev_XX callouts and associated ioctls; Jens favours that approach,
too, so we should be combining those efforts.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
