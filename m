From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Wed, 21 Nov 2018 17:02:13 -0500
Message-ID: <20181121220213.GK26006@thunk.org>
References: <20181114082551.12141-1-ming.lei@redhat.com>
 <63c063ad-7d74-4268-bfd4-2de89908949e@kernel.dk>
 <4e24ace9-c83f-5311-5419-18f4a0fb5148@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e24ace9-c83f-5311-5419-18f4a0fb5148@kernel.dk>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 21, 2018 at 02:47:35PM -0700, Jens Axboe wrote:
> > Thanks applied, this bug was elusive but ever present in recent
> > testing that we did internally, it's been a huge pain in the butt.
> > The symptoms were usually a crash in blk_mq_get_driver_tag() with
> > hctx->tags == NULL, or a crash inside deadline request insert off
> > requeue.
> 
> I'm still hitting some weird crashes even with this applied, like
> this one:

FYI, there are a number of Ubuntu users running 4.19, 4.19.1, and
4.19.2 which have been reporting file system corruption problems.
They have a fix of configurations, but one of the things which is seem
to be a common factor is they all have CONFIG_SCSI_MQ_DEFAULT
disabled.  (Which also happens to be how I happen to be running my
laptop, and I've noticed no problems.)

	https://bugzilla.kernel.org/show_bug.cgi?id=201685

One user in particular reported that 4.19 worked fine, and 4.19.1 had
fs corruptions (and there are no storage-related changes between 4.19
and 4.19.1) --- but the one thing those two kernels had in common was
his 4.19 build had SCSI_MQ_DEFAULT disabled, and his 4.19.1 build did
*not* have SCSI_MQ_DEFAULT enabled.  This same user tried 4.19.3, and
after two hours of heavy I/O, he's not seen a repeat, and
interestingly, 4.19.3 has the backport mentioned on this thread.

The weird thing is that it looked like the problem that was fixed by
this commit would only show up at queue setup and teardown time.  Is
that correct?  Is it possible that the bug fixed here would manifest
as data corruptions on disk?  Or would only manifest as kernel
BUG_ON's and/or crashes?

One more thing.  I tried building a 4.20-rc2 based kernel with
CONFIG_SCSI_MQ_DEFAULT=y, and I tried running gce-xfstests (which uses
virtio-scsi) and I saw no failures.  So I don't have a clean repro of
Kernel Bugzilla #201685, and at the moment I'm too chicken to enable
CONFIG_SCSI_MQ_DEFAULT on my primary development laptop...

Any thoughts/suggestions appreciated.

						- Ted
