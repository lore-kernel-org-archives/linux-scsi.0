From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 15:14:39 -0400
Message-ID: <20110928191439.GA9534@infradead.org>
References: <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
 <20110928174859.GA21628@redhat.com>
 <20110928175304.GA3985@infradead.org>
 <20110928180905.GB21628@redhat.com>
 <20110928181649.GA27441@infradead.org>
 <CADOQvuM2VP1TsLMAOL+NC-zEypDS2NJGmiN6RFCxmjUT6LqaPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADOQvuM2VP1TsLMAOL+NC-zEypDS2NJGmiN6RFCxmjUT6LqaPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Seppanen <eric@purestorage.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 12:05:10PM -0700, Eric Seppanen wrote:
> I agree: queue lock is the worst performance killer when hw can do
> >100K IOPS per block device.
> 
> Rather than just being chased away from the request queue due to
> performance issues, I could argue there's very little point to having
> a queue for devices that
> (a) have no seek penalty (and always use noop elevator)
> (b) have hardware queues at least as deep as the default request queue
> (c) don't benefit from merging
> 
> (c) is maybe debatable, but if a device can saturate its bus bandwidth
> on 4KB IO, the latency is probably not worth it.

In theory, yes.  But at some point we will be able to saturate them,
and then people want proportional I/O, light amounts of queueing, etc.

And I really don't want to reinvent that for every little device.  The
other problem is that we a single driver might driver totally different
types of devices, already today we have iSCSI or FC accessibly high
IOPS devices, there are good PCI-e flash devices masquerading as AHCI,
and my current problem is that the queue_lock really hurts me in
virtio-blk when using a PCIe flash device underneath.

So we really need some infrastructure that allows a generic interface
to the driver, and allow us to plug in merging, scheduling, queueing
on an as needed basis.

That is my long term plan - making request_lock suck a little less,
and improving the driver interface is a good first step, though.
