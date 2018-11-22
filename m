From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Wed, 21 Nov 2018 22:43:08 -0500
Message-ID: <20181122034308.GA7843@thunk.org>
References: <20181114082551.12141-1-ming.lei@redhat.com>
 <63c063ad-7d74-4268-bfd4-2de89908949e@kernel.dk>
 <4e24ace9-c83f-5311-5419-18f4a0fb5148@kernel.dk>
 <20181121220213.GK26006@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121220213.GK26006@thunk.org>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 21, 2018 at 05:02:13PM -0500, Theodore Y. Ts'o wrote:
> On Wed, Nov 21, 2018 at 02:47:35PM -0700, Jens Axboe wrote:
> > > Thanks applied, this bug was elusive but ever present in recent
> > > testing that we did internally, it's been a huge pain in the butt.
> > > The symptoms were usually a crash in blk_mq_get_driver_tag() with
> > > hctx->tags == NULL, or a crash inside deadline request insert off
> > > requeue.
> > 
> > I'm still hitting some weird crashes even with this applied, like
> > this one:
> 
> FYI, there are a number of Ubuntu users running 4.19, 4.19.1, and
> 4.19.2 which have been reporting file system corruption problems.
> They have a fix of configurations, but one of the things which is seem
> to be a common factor is they all have CONFIG_SCSI_MQ_DEFAULT
> disabled.  (Which also happens to be how I happen to be running my
> laptop, and I've noticed no problems.)

One correction to the above --- the people who are having the problem
have CONFIG_SCSI_MQ_DEFAULT *enabled* (at least for those who reported
the kernel configs --- not all of them did).

I have CONFIG_SCSI_MQ_DEFAULT *disabled*, and things are running just
fine on my laptop.  Although that may be a red herring, since as you
pointed out on the bug NVMe isn't affected by the SCSI_MQ_DEFAULT
setting (sorry, I'm still used to a world where SCSI controls the
whole world :-).  And my laptop is an XPS 13 with an NVMe-attached 1T
SSD.  Fortunately I've not seen any corruption (or at least nothing
visible yet).

Anyway, all of this is in the bug, and I'll see if I can find a way of
repro'ing corruption in a KVM or GCE crash-and-burn environment...

		  	     	      	 - Ted
