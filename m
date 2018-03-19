From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 08:21:44 -0700
Message-ID: <20180319152144.GM2943022@devbig577.frc2.facebook.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
 <20180319143147.GF2943022@devbig577.frc2.facebook.com>
 <1521472566.2776.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521472566.2776.6.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Mar 19, 2018 at 03:16:07PM +0000, Bart Van Assche wrote:
> As explained in the comment in scsi_device_quiesce(), the effect of
> blk_set_preempt_only() must be visible for percpu_ref_tryget() calls that
> occur after the queue unfreeze triggered by scsi_device_quiesce(). Hence the
> RCU read lock calls in blk_queue_enter(). Since these RCU read lock calls
> surround a function call that uses rcu_read_lock_sched(), namely
> percpu_ref_tryget_live(), we have to use sched-RCU in both blk_queue_enter()
> and scsi_device_quiesce().

Let's please not depend on rcu_read_lock_sched() in
percpu_ref_tryget_live().  That's an implementation detail.  If the
code needs RCU based synchronization, it should perform them
explicitly.

Thanks.

-- 
tejun
