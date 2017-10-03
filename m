From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V8 5/8] percpu-refcount: introduce
 __percpu_ref_tryget_live
Date: Wed, 4 Oct 2017 03:20:40 +0800
Message-ID: <20171003192039.GB5362@ming.t460p>
References: <20171003140406.26060-1-ming.lei@redhat.com>
 <20171003140406.26060-6-ming.lei@redhat.com>
 <20171003141459.GI3301751@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003141459.GI3301751@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2017 at 07:14:59AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 03, 2017 at 10:04:03PM +0800, Ming Lei wrote:
> > Block layer need to call this function after holding
> > rcu lock in a real hot path, so introduce this helper.
> 
> The patch description is too anemic.  It doesn't even describe what
> changes are being made, let alone justifying them.

Sorry for Cc you, and this change is needed by the following
patch:

	https://marc.info/?l=linux-scsi&m=150703956929333&w=2

Block layer need to call percpu_ref_tryget_live()
with holding RCU read lock, given it is a hot I/O
path, that is why I make this patch so that we can
avoid nested RCU read lock and save a bit cost.

--
Ming
