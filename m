From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Tue, 9 Aug 2016 22:26:27 -0500
Message-ID: <CAJVOszB4dfEFM+XxvDy4+7ue6au_RzjuOB-SSvYTh96H-UjZ1Q@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de> <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de> <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
 <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com> <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <Damien.LeMoal@hgst.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 9, 2016 at 1:47 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 08/05/2016 10:35 PM, Shaun Tancheff wrote:
>> On Tue, Aug 2, 2016 at 8:29 PM, Damien Le Moal <Damien.LeMoal@hgst.com> wrote:
>>>> On Aug 2, 2016, at 23:35, Hannes Reinecke <hare@suse.de> wrote:
>>>> On 08/01/2016 07:07 PM, Shaun Tancheff wrote:
>>>>> On Mon, Aug 1, 2016 at 4:41 AM, Christoph Hellwig <hch@lst.de> wrote:

[trim]
>> Also the zone report is 'slow' in that there is an overhead for the
>> report itself but
>> the number of zones per query can be quite large so 4 or 5 I/Os that
>> run into the
>> hundreds if milliseconds to cache the entire drive isn't really unworkable for
>> something that is used infrequently.
>>
> No, surely not.
> But one of the _big_ advantages for the RB tree is blkdev_discard().
> Without the RB tree any mkfs program will issue a 'discard' for every
> sector. We will be able to coalesce those into one discard per zone, but
> we still need to issue one for _every_ zone.
> Which is (as indicated) really slow, and easily takes several minutes.
> With the RB tree we can short-circuit discards to empty zones, and speed
> up processing time dramatically.
> Sure we could be moving the logic into mkfs and friends, but that would
> require us to change the programs and agree on a library (libzbc?) which
> should be handling that.

Adding an additional library dependency seems overkill for a program
that is already doing ioctls and raw block I/O ... but I would leave that
up to each file system. As it sits issuing the ioctl and walking the array
of data returned [see blkreport.c] is already quite trivial.

I believe the goal here is for F2FS, and perhaps NILFS? to "just
work" with the DISCARD to Reset WP and zone cache in place.

Still quite skeptical about other common file systems
"just working" without their respective mkfs et. al. being
zone aware and handling the topology of the media at mkfs time.
Perhaps there is something I am unaware of?

[trim]

>> I can add finish zone ... but I really can't think of a use for it, myself.
>>
> Which is not the point. The standard defines this, so clearly someone
> found it a reasonable addendum. So let's add this for completeness.

Agreed and queued for the next version.

Regards,
Shaun
