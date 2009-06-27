From: Neil Brown <neilb@suse.de>
Subject: Re: REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Sat, 27 Jun 2009 22:50:05 +1000
Message-ID: <19014.5501.31618.7897@notabene.brown>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<20090625194015.GB31415@kernel.dk>
	<19012.49673.454853.975682@notabene.brown>
	<20090626125037.GO23611@kernel.dk>
	<7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name>
	<771af936681abb7ddc2191eb5b6b68d0.squirrel@neil.brown.name>
	<20090626134954.GS23611@kernel.dk>
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
> > Do you have a good reason for them going in /queue?
> 
> Do you have a good reason for moving them? Im my opinion that makes the
> separation between ->make_request_fn and ->request_fn devices bigger.

Yes, I have a good reason.

Put succinctly:  I have a reason for reverting the change to make
/queue visible in md/dm devices:  It contains mostly fields that are
irrelevant to those devices.
Given that, I have a reason for moving the new fields:  So that can be
visible for md/dm/loop/etc devices.

More verbosely:
Currently (i.e. 2.6.30 and earlier) every block device has a device
directory in /sys/devices.  e.g. "sda".  It contains attributes that
are generally applicable to any block device (size, ro etc).

Some devices, which use the __make_request driver/layer, have a
'queue' directory with attributes that are specific to the
implementation of __make_request and related code.
Other devices, which make use of the md_make_request driver/layer,
have an 'md' directory with attributes that are specific to that
implementation.
Other devices have no such directory (relevant values are managed
exclusively via ioctls).

We are adding a number of attributes that are generally applicable to
all block devices.
Given the above description of the current state, it seems natural for
the new attributes to go in the device directory -
e.g. sda/new-attribute.
This is exactly what has been done for 'alignment_offset'.
The same should be done for physical_block_size, minimum_io_size, and
optimal_io_size.
Introducing the 'queue' directory - which mostly contains fields
completely irrelevant to non- __make_request drivers - just to store
some values that can easily go elsewhere doesn't seem to make sense to
me.

As for increasing the "separation between ->make_request_fn and
->request_fn devices", I don't think that is a useful way to look at
the devices, as I detail in my other Email.

Thanks,
NeilBrown
