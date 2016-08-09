From: Damien Le Moal <Damien.LeMoal@hgst.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Tue, 9 Aug 2016 08:09:49 +0000
Message-ID: <D3D5E748-ADB9-4376-8969-623A8A815E36@hgst.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de>
 <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de>
 <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
 <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com>
 <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Content-Language: en-US
Content-ID: <51E41E1B4D8ED343A924DD70D5EF6E7D@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Hannes,

> On Aug 9, 2016, at 15:47, Hannes Reinecke <hare@suse.de> wrote:
[...]
>>> 
>>> Can we agree on an interface ?
>>> Summarizing all the discussions we had, I am all in favor of the following:
>>> 
>>> 1) A "zone_size" sysfs attribute to indicate that a drive is zoned:
>>> The already existing device type file can tell us if this is an host
>>> managed disk (type==20) or a host aware disk (type==0). Drive managed
>>> disks could also be detected, but since no information on their zone
>>> configuration can be obtained, lets treat those as regular drives.
>> 
>> Since disk type == 0 for everything that isn't HM so I would prefer the
>> sysfs 'zoned' file just report if the drive is HA or HM.
>> 
> Okay. So let's put in the 'zoned' attribute the device type:
> 'host-managed', 'host-aware', or 'device managed'.

I hacked your patches and simply put a "0" or "1" in the sysfs zoned file.
Any drive that has ZBC/ZAC command support gets a "1", "0" for everything
else. This means that drive managed models are not exposed as zoned block
devices. For HM vs HA differentiation, an application can look at the
device type file since it is already present.

We could indeed set the "zoned" file to the device type, but HM drives and
regular drives will both have "0" in it, so no differentiation possible.
The other choice could be the "zoned" bits defined by ZBC, but these
do not define a value for host managed drives, and the drive managed value
being not "0" could be confusing too. So I settled for a simple 0/1 boolean.

> 
>>> 2) Add ioctls for zone management:
>>> Report zones (get information from RB tree), reset zone (simple wrapper
>>> to ioctl for block discard), open zone, close zone and finish zone. That
>>> will allow mkfs like tools to get zone information without having to parse
>>> thousands of sysfs files (and can also be integrated in libzbc block backend
>>> driver for a unified interface with the direct SG_IO path for kernels without
>>> the ZBC code enabled).
>> 
>> I can add finish zone ... but I really can't think of a use for it, myself.
>> 
> Which is not the point. The standard defines this, so clearly someone
> found it a reasonable addendum. So let's add this for completeness.

Done: I hacked Shaun ioctl code and added finish zone too. The
difference with Shaun initial code is that the ioctl are propagated down to
the driver (__blkdev_driver_ioctl -> sd_ioctl) so that there is no need for
BIO request definition for the zone operations. So a lot less code added.
The ioctls do not mimic exactly the ZBC standard. For instance, there is no
reporting options for report zones, nor is the "all" bit supported for open,
close or finish zone commands. But the information provided on zones is complete
and maps to the standard definitions.

I also added a reset_wp ioctl for completeness, but this one simply calls
blkdev_issue_discard internally, so it is in fact equivalent to the BLKDISCARD
ioctl call with a range exactly aligned on a zone.

> 
>>> 3) Try to condense the blkzone data structure to save memory:
>>> I think that we can at the very least remove the zone length, and also
>>> may be the per zone spinlock too (a single spinlock and proper state flags can
>>> be used).
>> 
>> I have a variant that is an array of descriptors that roughly mimics the
>> api from blk-zoned.c that I did a few months ago as an example.
>> I should be able to update that to the current kernel + patches.
>> 
> Okay. If we restrict the in-kernel SMR drive handling to devices with
> identical zone sizes of course we can remove the zone length.
> And we can do away with the per-zone spinlock and use a global one instead.

Did that too. The blk_zone struct is now exactly 64B. I removed the per zone
spinlock and replaced it with a flag so that zones can still be locked
independently using wait_on_bit_lock & friends (I added the functions
blk_zone_lock, blk_zone_trylock and blk_zone_unlock to do that). This per zone
locking comes in handy to implement the ioctls code without stalling the command
queue for read, writes and discard on different zones.

I however kept the zone length in the structure. The reason for doing so is that
this allows supporting drives with non-constant zone sizes, albeit with a more
limited interface since in such case the device chunk_sectors is not set (that
is how a user or application can detect that the zones are not constant size).
For these drives, the block layer may happily merge BIOs across zone boundaries
and the discard code will not split and align calls on the zones. But upper layers
(an FS or a device mapper) can still do all this by themselves if they want/can
support non-constant zone sizes.

The only exception is drives like the Seagate one with only the last zone of a
different size. This case is handled exactly as if all zones are the same size
simply because any operation on the last smaller zone will naturally align as
the checks of operation size against the drive capacity will do the right things.

The ioctls work for all cases (drive with constant zone size or not). This is again
to allow supporting eventual weird drives at application level. I integrated all
these ioctl into libzbc block device backend driver and everything is fine. Can't
tell the difference with direct-to-drive SG_IO accesses. But unlike these, the zone
ioctls keep the zone information RB-tree cache up to date.

> 
> I will be updating my patchset accordingly.

I need to cleanup my code and rebase on top of 4.8-rc1. Let me do this and I will send
everything for review. If you have any comment on the above, please let me know and
I will be happy to incorporate changes.

Best regards.


------------------------
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com 

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

