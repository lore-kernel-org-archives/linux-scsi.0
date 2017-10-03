From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V8 5/8] percpu-refcount: introduce
 __percpu_ref_tryget_live
Date: Wed, 4 Oct 2017 03:24:13 +0800
Message-ID: <20171003192412.GC5362@ming.t460p>
References: <20171003140406.26060-1-ming.lei@redhat.com>
 <20171003140406.26060-6-ming.lei@redhat.com>
 <1507056023.2567.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507056023.2567.1.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "tj@kernel.org" <tj@kernel.org>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2017 at 06:40:24PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-03 at 22:04 +0800, Ming Lei wrote:
> > Block layer need to call this function after holding
> > rcu lock in a real hot path, so introduce this helper.
> 
> Since it is allowed to nest rcu_read_lock_sched() calls I don't think
> that this patch is necessary.

Yeah, I know that, with this patch, we can avoid the nest RCU lock.
As I mentioned, it is a real hot path, so maybe better to not
introduce the extra RCU read lock/unlock.

If you guys doesn't care the little cost, I can remove that.

-- 
Ming
