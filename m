From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Tue, 16 Aug 2016 01:07:30 -0500
Message-ID: <CAJVOszDGxEsLkQ3jMcvhd7N9FtY5r4Q2ARqyebJqwtmTDmsk=w@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de> <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de> <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
 <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com>
 <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de> <D3D5E748-ADB9-4376-8969-623A8A815E36@hgst.com>
 <CAJVOszDavBDA0hZTox-nNtPHCz-tWecOJCJ5R25u+AV6Wq3xwQ@mail.gmail.com> <37fdd603-403d-84bf-9f3d-51e9791006c4@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <37fdd603-403d-84bf-9f3d-51e9791006c4@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 9, 2016 at 11:38 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
> Shaun,
>
> On 8/10/16 12:58, Shaun Tancheff wrote:
>>
>> On Tue, Aug 9, 2016 at 3:09 AM, Damien Le Moal <Damien.LeMoal@hgst.com>
>> wrote:
>>>>
>>>> On Aug 9, 2016, at 15:47, Hannes Reinecke <hare@suse.de> wrote:
>>
>>
>> [trim]
>>
>>>>> Since disk type == 0 for everything that isn't HM so I would prefer the
>>>>> sysfs 'zoned' file just report if the drive is HA or HM.
>>>>>
>>>> Okay. So let's put in the 'zoned' attribute the device type:
>>>> 'host-managed', 'host-aware', or 'device managed'.
>>>
>>>
>>> I hacked your patches and simply put a "0" or "1" in the sysfs zoned
>>> file.
>>> Any drive that has ZBC/ZAC command support gets a "1", "0" for everything
>>> else. This means that drive managed models are not exposed as zoned block
>>> devices. For HM vs HA differentiation, an application can look at the
>>> device type file since it is already present.
>>>
>>> We could indeed set the "zoned" file to the device type, but HM drives
>>> and
>>> regular drives will both have "0" in it, so no differentiation possible.
>>> The other choice could be the "zoned" bits defined by ZBC, but these
>>> do not define a value for host managed drives, and the drive managed
>>> value
>>> being not "0" could be confusing too. So I settled for a simple 0/1
>>> boolean.
>>
>>
>> This seems good to me.
>
>
> Another option I forgot is for the "zoned" file to indicate the total number
> of zones of the device, and 0 for a non zoned regular block device. That
> would work as well.

Clearly either is sufficient.

> [...]
>>>
>>> Done: I hacked Shaun ioctl code and added finish zone too. The
>>> difference with Shaun initial code is that the ioctl are propagated down
>>> to
>>> the driver (__blkdev_driver_ioctl -> sd_ioctl) so that there is no need
>>> for
>>> BIO request definition for the zone operations. So a lot less code added.
>>
>>
>> The purpose of the BIO flags is not to enable the ioctls so much as
>> the other way round. Creating BIO op's is to enable issuing ZBC
>> commands from device mapper targets and file systems without some
>> heinous ioctl hacks.
>> Making the resulting block layer interfaces available via ioctls is just a
>> reasonable way to exercise the code ... or that was my intent.
>
>
> Yes, I understood your code. However, since (or if) we keep the zone
> information in the RB-tree cache, there is no need for the report zone
> operation BIO interface. Same for reset write pointer by keeping the mapping
> to discard. blk_lookup_zone can be used in kernel as a report zone BIO
> replacement and works as well for the report zone ioctl implementation. For
> reset, there is blkdev_issue_discrad in kernel, and the reset zone ioctl
> becomes equivalent to BLKDISCARD ioctl. These are simple. Open, close and
> finish zone remains. For these, adding the BIO interface seemed an overkill.
> Hence my choice of propagating the ioctl to the driver.
> This is debatable of course, and adding an in-kernel interface is not hard:
> we can implement blk_open_zone, blk_close_zone and blk_finish_zone using
> __blkdev_driver_ioctl. That looks clean to me.

Uh. I would call that "heinous" ioctl hacks myself. Kernel -> User API
-> Kernel
is not really a good designed IMO.

> Overall, my concern with the BIO based interface for the ZBC commands is
> that it adds one flag for each command, which is not really the philosophy
> of the interface and potentially opens the door for more such
> implementations in the future with new standards and new commands coming up.
> Clearly that is not a sustainable path. So I think that a more specific
> interface for these zone operations is a better choice. That is consistent
> with what happens with the tons of ATA and SCSI commands not actually doing
> data I/Os (mode sense, log pages, SMART, etc). All these do not use BIOs and
> are processed as request REQ_TYPE_BLOCK_PC.

Part of the reason for following on Mike Christie's bio op/flags cleanup was to
make these op's. The advantage of being added as ops is that there is only
1 extra bit need (not 4 or 5 bits for flags). The other reason for being
promoted into the block layer as commands is because it seems to me
to make sense that these abstractions could be allowed to be passed through
a DM layer and be handled by a files system.

>>> The ioctls do not mimic exactly the ZBC standard. For instance, there is
>>> no
>>> reporting options for report zones, nor is the "all" bit supported for
>>> open,
>>> close or finish zone commands. But the information provided on zones is
>>> complete
>>> and maps to the standard definitions.
>>
>>
>> For the reporting options I have planned to reuse the stream_id in
>> struct bio when that is formalized. There are certainly other places in
>> struct bio to stuff a few extra bits ...

Sorry I was confused here. I was under the impression you were talking
about one of my patches when you seem to have been talking about
your hacking thereof.

> We could add reporting options to blk_lookup_zones to filter the result and
> use that in the ioctl implementation as well. This can be added without any
> problem.
>
>> As far as the all bit ... this is being handled by all the zone action
>> commands. Just pass a sector of ~0ul and it's handled in sd.c by
>> sd_setup_zone_action_cmnd().
>>
>> Apologies as apparently my documentation here is lacking :-(
>
>
> Yes, I got it (libzbc does the same actually). I did not add it for
> simplicity. But indeed may be it should be. The same trick can be used with
> the ioctl to driver interface. No problems.
>
>>> I also added a reset_wp ioctl for completeness, but this one simply calls
>>> blkdev_issue_discard internally, so it is in fact equivalent to the
>>> BLKDISCARD
>>> ioctl call with a range exactly aligned on a zone.
>>
>>
>> I'm confused as my patch set includes a Reset WP (BLKRESETZONE) that
>> creates a REQ_OP_ZONE_RESET .. same as open and close. My
>> expectation being that BLKDISCARD doesn't really need yet another alias.

Same as above.

> Yes, we could remove the BLKRESETZONE ioctl and have applications use the
> BLKDISCARD ioctl instead. In the kernel, both generate blkdev_issue_discard
> calls and are thus identical. Only the ioctl interface differs (sector vs
> range argument). Again, I added it to have the full set of 5 ZBC/ZAC
> operations mapping to one BLKxxxZONE ioctl. But granted, reset is optional.

Which is the opposite of what I had stated above which is that I do _not_
think reset is optional. I think that if the user wants discard they should
call discard and if they want reset wp they *can* call reset wp and have
it behave as expected.
Why would I and a new ioctl that just calls discard? That makes no sense to me.
