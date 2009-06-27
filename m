From: Neil Brown <neilb@suse.de>
Subject: Re: REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Sat, 27 Jun 2009 22:32:31 +1000
Message-ID: <19014.4447.248248.63960@notabene.brown>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<20090625194015.GB31415@kernel.dk>
	<19012.49673.454853.975682@notabene.brown>
	<20090626125037.GO23611@kernel.dk>
	<f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
	<20090626132940.GR23611@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Jens Axboe on Friday June 26
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Friday June 26, jens.axboe@oracle.com wrote:
> On Fri, Jun 26 2009, NeilBrown wrote:
> > On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
> > > On Fri, Jun 26 2009, Neil Brown wrote:
> > >> Every block device has a 'gendisk' (aka generic disk).
> > >> Every block device also (currently) has a request_queue.
> > >
> > > I don't know why you keep saying currently. It has always had a queue,
> > > and I don't see a good reason why that should change for "special" block
> > > devices like md/dm/loop/whatnot.
> > 
> > I say "currently" because I'm planning to create patches to make it
> > optional, and I want to get you used to the idea :-)
> > 
> > And md/dm/loop/whatnot are not "special" block devices, any more than
> > scsi/ide are "special" block devices.  They are all just block devices.
> > They use different mechanisms, but each is just as valid as the other.
> 
> That was why I put it in quotes, they are just regular devices.

Ahh... I missed your point.  You were saying that they aren't special,
they are just like everything else and so should still have a queue.
Sorry for misunderstanding.
See below for my response.

> 
> > The current code makes 'struct request' based block devices in to
> > first-class citizens, and all the rest are second class (having to
> > tag our data structures on ->queue data and/or ->private_data).
> 
> ?? How is that different from devices, the ones you refer to as
> first-class citizens? They too store device private data in eg
> ->queue_data.
> 
> > I just want all block devices to be equal.
> 
> There's no such thing as first or second class block devices. The fact
> that drivers using ->make_request_fn directly do not utilize the full
> scope of the queue isn't a very interesting fact, imho.

 Your phrase "drivers using ->make_request_fn directly" seems to
 suggest you are looking at things very differently to me.

 From my perspective, all drivers use ->make_request_fn equally.
 Some set it to "__make_request", some to "md_make_request", others to
 "dm_request" or "loop_make_request" etc.

 Each of these different drivers need some private storage.
 __make_request uses struct request_queue
 md_make_request uses struct mddev_s
 dm_request uses struct mapped_device
 loop_make_request uses struct loop_device
  etc

 These structures are all attached to gendisk one way or another.

 Of these examples, the first three have an extra level.  They are
 intermediaries or "midlayers" for multiple drivers and perform some
 processing before passing the request down.
 __make_request provides this for ide and scsi (etc) via ->request_fn and
    ->queuedata in struct request_queue (and other fields).
 md_make_request provides this for raid1 and raid5 (etc) via
    ->pers->make_request and  ->private is struct mddev_s (and other
    fields). 
 dm_request provides this for crypt and multipath (etc) via
    ->map->targets[]->type->map and ->map->targets[]->private (and
    other fields).

 Looked at from this perspective, the fact that some drivers 'do not
 utilise the full scope of the queue' certainly isn't the interesting
 point.  The interesting point is that they have to use parts of the
 queue at all.

 And from this perspective, __make_request is a class above everything
 else.  __make_request gets a dedicate field in gendisk (->queue) and
 every driver has to provide a queue.  Other (lower class) drivers get
 to share gendisk->private_date and/or gendisk->queue->queuedata.


NeilBrown
