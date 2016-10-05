From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and blk_resume_queue()
Date: Thu, 6 Oct 2016 06:49:17 +0800
Message-ID: <CACVXFVMwQnOuUukEMO8CyG3sPOg6DxuKAZx+5FT+LS+hGAcWVQ@mail.gmail.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com> <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com> <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
 <a11bb09a-6207-f4a8-cfd4-4fe5627c1700@sandisk.com> <09238e87-7d60-89c9-98b0-e51caa0c0839@grimberg.me>
 <6d612be9-7ba7-888e-f9c6-f8aa4ef1606a@sandisk.com> <732bf5d6-d7a8-6ff0-6501-8a3d46f12fab@grimberg.me>
 <07628c2f-3a4e-b12e-663a-b0711ce20cc9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <07628c2f-3a4e-b12e-663a-b0711ce20cc9-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 6, 2016 at 5:08 AM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 10/05/2016 12:11 PM, Sagi Grimberg wrote:
>>
>> I was referring to weather we can take srcu in the submission path
>> conditional of the hctx being STOPPED?
>
>
> Hello Sagi,
>
> Regarding run-time overhead:
> * rcu_read_lock() is a no-op on CONFIG_PREEMPT_NONE kernels and is
>   translated into preempt_disable() with preemption enabled. The latter
>   function modifies a per-cpu variable.
> * Checking BLK_MQ_S_STOPPED before taking an rcu or srcu lock is only
>   safe if the BLK_MQ_S_STOPPED flag is tested in such a way that the
>   compiler is told to reread the hctx flags (READ_ONCE()) and if the
>   compiler and CPU are told not to reorder test_bit() with the
>   memory accesses in (s)rcu_read_lock(). To avoid races
>   BLK_MQ_S_STOPPED will have to be tested a second time after the lock
>   has been obtained, similar to the double-checked-locking pattern.
> * srcu_read_lock() reads a word from the srcu structure, disables
>   preemption, calls __srcu_read_lock() and re-enables preemption. The
>   latter function increments two CPU-local variables and triggers a
>   memory barrier (smp_mp()).

We can use srcu read lock for BLOCKING and rcu read lock for non-BLOCKING,
by putting *_read_lock() and *_read_unlock() into two wrappers, which
should minimize the cost of srcu read lock & unlock and the code is still easy
to read & verify.

>
> Swapping srcu_read_lock() and the BLK_MQ_S_STOPPED flag test will make the
> code more complicated. Going back to the implementation that calls
> rcu_read_lock() if .queue_rq() won't sleep will result in an implementation
> that is easier to read and to verify.

Yeah, I agree.

Thanks,
Ming Lei
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
