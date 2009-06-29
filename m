From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Mon, 29 Jun 2009 12:18:41 +0200
Message-ID: <20090629101841.GF23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name> <20090626132940.GR23611@kernel.dk> <19014.4447.248248.63960@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19014.4447.248248.63960@notabene.brown>
Sender: linux-ide-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 27 2009, Neil Brown wrote:
> > There's no such thing as first or second class block devices. The fact
> > that drivers using ->make_request_fn directly do not utilize the full
> > scope of the queue isn't a very interesting fact, imho.
> 
>  Your phrase "drivers using ->make_request_fn directly" seems to
>  suggest you are looking at things very differently to me.
> 
>  From my perspective, all drivers use ->make_request_fn equally.
>  Some set it to "__make_request", some to "md_make_request", others to
>  "dm_request" or "loop_make_request" etc.

Neil, will you please stop these silly games. Stop trying to invent
differences based on interpretations of what you read into my replies.

>  Each of these different drivers need some private storage.
>  __make_request uses struct request_queue
>  md_make_request uses struct mddev_s
>  dm_request uses struct mapped_device
>  loop_make_request uses struct loop_device
>   etc
> 
>  These structures are all attached to gendisk one way or another.
> 
>  Of these examples, the first three have an extra level.  They are
>  intermediaries or "midlayers" for multiple drivers and perform some
>  processing before passing the request down.
>  __make_request provides this for ide and scsi (etc) via ->request_fn and
>     ->queuedata in struct request_queue (and other fields).
>  md_make_request provides this for raid1 and raid5 (etc) via
>     ->pers->make_request and  ->private is struct mddev_s (and other
>     fields). 
>  dm_request provides this for crypt and multipath (etc) via
>     ->map->targets[]->type->map and ->map->targets[]->private (and
>     other fields).

Nothing - I repeat nothing - stops md/dm from removing that layer. It's
a layer they imposed themselves based on the design they chose to
implement internally. It has NOTHING to do with how the block layer is
designed. If md raid1 assigned raid1_dev (or whatever raid1 uses a its
device identifier structure) to ->queuedata, and had an mddev_s in its
raid1 structure, that would be a perfectly viable design as well.

Loop does that. md/dm have their own internal layering, if anything is a
"midlayer" (to keep to the apparent theme of design patterns), it's the
code md and dm bits.

>  Looked at from this perspective, the fact that some drivers 'do not
>  utilise the full scope of the queue' certainly isn't the interesting
>  point.  The interesting point is that they have to use parts of the
>  queue at all.
> 
>  And from this perspective, __make_request is a class above everything
>  else.  __make_request gets a dedicate field in gendisk (->queue) and
>  every driver has to provide a queue.  Other (lower class) drivers get
>  to share gendisk->private_date and/or gendisk->queue->queuedata.

That's just utter nonsense.

-- 
Jens Axboe

