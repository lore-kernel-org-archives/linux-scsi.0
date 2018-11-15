From: Ming Lei <ming.lei@redhat.com>
Subject: Re: kobject lifetime issues in blk-mq
Date: Thu, 15 Nov 2018 08:36:17 +0800
Message-ID: <20181115003616.GA32603@ming.t460p>
References: <20181109203518.GA7130@roeck-us.net>
 <20181112092051.GA391@ming.t460p>
 <20181112094406.GB391@ming.t460p>
 <20181112164848.GA1790@roeck-us.net>
 <20181112200236.GA4415@kroah.com>
 <20181113002226.GA4455@ming.t460p>
 <20181113004124.GC4455@ming.t460p>
 <20181114110827.GA31430@ming.t460p>
 <20181114151410.GB26378@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114151410.GB26378@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, Peter Zijlstra <peterz@infradead.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 14, 2018 at 07:14:10AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Nov 14, 2018 at 07:08:28PM +0800, Ming Lei wrote:
> > On Tue, Nov 13, 2018 at 08:41:24AM +0800, Ming Lei wrote:
> > > On Tue, Nov 13, 2018 at 08:22:26AM +0800, Ming Lei wrote:
> > > > On Mon, Nov 12, 2018 at 12:02:36PM -0800, Greg Kroah-Hartman wrote:
> > > > > On Mon, Nov 12, 2018 at 08:48:48AM -0800, Guenter Roeck wrote:
> > > > > > On Mon, Nov 12, 2018 at 05:44:07PM +0800, Ming Lei wrote:
> > > > > > > On Mon, Nov 12, 2018 at 05:20:51PM +0800, Ming Lei wrote:
> > > > > > > > On Fri, Nov 09, 2018 at 12:35:18PM -0800, Guenter Roeck wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > Images with CONFIG_DEBUG_KOBJECT=y, CONFIG_DEBUG_KOBJECT_RELEASE=y
> > > > > > > > > enabled report kobject lifetime issues when booting an image in qemu
> > > > > > > > > using virtio-scsi-pci.
> > > > > > > > > 
> > > > > > > > > Bisect points to two different commits, depending on the kernel
> > > > > > > > > configuration.
> > > > > > > > > 
> > > > > > > > > 1st configuration: defconfig plus:
> > > > > > > > > 
> > > > > > > > > CONFIG_VIRTIO_BLK=y
> > > > > > > > > CONFIG_SCSI_LOWLEVEL=y
> > > > > > > > > CONFIG_SCSI_VIRTIO=y
> > > > > > > > > CONFIG_VIRTIO_PCI=y
> > > > > > > > > CONFIG_VIRTIO_MMIO=y
> > > > > > > > > CONFIG_DEBUG_OBJECTS=y
> > > > > > > > > CONFIG_DEBUG_OBJECTS_FREE=y
> > > > > > > > > CONFIG_DEBUG_OBJECTS_TIMERS=y
> > > > > > > > > CONFIG_DEBUG_KOBJECT=y
> > > > > > > > > CONFIG_DEBUG_KOBJECT_RELEASE=y
> > > > > > > > > 
> > > > > > > > > Bisecting this configuration points to commit b5b6e8c8d3b4 ("scsi:
> > > > > > > > > virtio_scsi: fix IO hang caused by automatic irq vector affinity")
> > > > > > > > > as the culprit. This commit enforces the use of blk-mq for virtio_scsi;
> > > > > > > > > the bisect log is therefore a bit misleading.
> > > > > > > > > 
> > > > > > > > > 2nd configuration: As above, plus:
> > > > > > > > > CONFIG_SCSI_MQ_DEFAULT=y
> > > > > > > > > 
> > > > > > > > > With this configuration, bisect points to commit 7ea5fe31c12d
> > > > > > > > > ("blk-mq: make lifetime consitent between q/ctx and its kobject").
> > > > > > > > > 
> > > > > > > > > The qemu command line used to reproduce the problem is as follows.
> > > > > > > > > The qemu version does not seem to matter (I tested with qemu versions
> > > > > > > > > 2.5, 2.11, and 3.0).
> > > > > > > > > 
> > > > > > > > > qemu-system-x86_64 \
> > > > > > > > > 	-kernel arch/x86/boot/bzImage \
> > > > > > > > > 	-device virtio-scsi-pci,id=scsi \
> > > > > > > > > 	-device scsi-hd,bus=scsi.0,drive=d0 \
> > > > > > > > > 	-drive file=./wheezy.img,format=raw,if=none,id=d0 \
> > > > > > > > > 	-snapshot \
> > > > > > > > > 	-m 2G -smp 4 -enable-kvm \
> > > > > > > > > 	-net user,host=10.0.2.10,hostfwd=tcp::10022-:22 -net nic \
> > > > > > > > > 	-nographic -monitor none \
> > > > > > > > > 	-no-reboot \
> > > > > > > > > 	-append "console=ttyS0 root=/dev/sda earlyprintk=serial panic_on_warn=1 panic=-1"
> > > > > > > > > 
> > > > > > > > > Root file system:
> > > > > > > > > 	https://storage.googleapis.com/syzkaller/wheezy.img
> > > > > > > > > or:
> > > > > > > > > 	https://github.com/groeck/linux-build-test/blob/master/rootfs/x86_64/rootfs.ext2.gz
> > > > > > > > > 
> > > > > > > > > It seems that any root file system can be used to reproduce the problem.
> > > > > > > > > Also, the problem is not limited to virtio-scsi-pci. I also tried
> > > > > > > > > am53c974, lsi53c810, and lsi53c895a (after enabling the respective
> > > > > > > > > drivers), with the same result.
> > > > > > > > > 
> > > > > > > > > Overall, this suggests that the problem is related to blk-mq and was
> > > > > > > > > indeed introduced with commit 7ea5fe31c12d.
> > > > > > > > > 
> > > > > > > > > For reference, I attached an actual crash log as well as a set of bisect
> > > > > > > > > logs below.
> > > > > > > > > 
> > > > > > > > > Unfortunately, my understanding of blk-mq is not good enough to find the
> > > > > > > > > underlying problem and suggest a fix. Please let me know if there is
> > > > > > > > > anything else I can do to help fixing the problem.
> > > > > > > > > 
> > > > > > > > > Note that the problem was originally reported by syzbot running a test
> > > > > > > > > on chromeos-4.14. It may well be that the problem has already been
> > > > > > > > > reported and is being worked on. If so, please apologize the noise.
> > > > > > > > > 
> > > > > > > > > Thanks,
> > > > > > > > > Guenter
> > > > > > > > > 
> > > > > > > > > ---
> > > > > > > > > [    8.700038] ------------[ cut here ]------------
> > > > > > > > > [    8.700376] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x10
> > > > > > > > > [    8.701032] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:329 debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032] Kernel panic - not syncing: panic_on_warn set ...
> > > > > > > > > [    8.701032] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.20.0-rc1 #30
> > > > > > > > > [    8.701032] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> > > > > > > > > [    8.701032] Call Trace:
> > > > > > > > > [    8.701032]  <IRQ>
> > > > > > > > > [    8.701032]  dump_stack+0x46/0x5b
> > > > > > > > > [    8.701032]  panic+0xf3/0x246
> > > > > > > > > [    8.701032]  ? debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032]  __warn+0xeb/0xf0
> > > > > > > > > [    8.701032]  ? debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032]  ? debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032]  report_bug+0xb1/0x120
> > > > > > > > > [    8.701032]  fixup_bug.part.10+0x13/0x30
> > > > > > > > > [    8.701032]  do_error_trap+0x8f/0xb0
> > > > > > > > > [    8.701032]  do_invalid_op+0x31/0x40
> > > > > > > > > [    8.701032]  ? debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032]  invalid_op+0x14/0x20
> > > > > > > > > [    8.701032] RIP: 0010:debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032] Code: 8b 43 10 83 c2 01 8b 4b 14 89 15 c1 e2 78 01 4c 8b 45 00 4c
> > > > > > > > > 89 e6 48 c7 c7 f0 ca 41 a6 48 8b 14 c5 a0 f7 24 a6 e8 06 8e cc ff <0f> 0b 5b 83
> > > > > > > > > 05 70 47 1a 01 01 5d 41 5c c3 83 05 65 47 1a 01 01 c3
> > > > > > > > > [    8.701032] RSP: 0018:ffff89b9fda03e48 EFLAGS: 00010082
> > > > > > > > > [    8.701032] RAX: 0000000000000000 RBX: ffff89b9fd49d0c8 RCX: ffffffffa6646e18
> > > > > > > > > [    8.701032] RDX: 0000000000000001 RSI: 0000000000000082 RDI: ffffffffa6cc596c
> > > > > > > > > [    8.701032] RBP: ffffffffa664a5c0 R08: 79616c6564203a74 R09: 5f6b726f775f6465
> > > > > > > > > [    8.701032] R10: ffff89b9fda03f10 R11: 3178302f3078302b R12: ffffffffa6403e22
> > > > > > > > > [    8.701032] R13: 0000000000000001 R14: ffffffffa6d4d458 R15: ffff89b9fc4c8780
> > > > > > > > > [    8.701032]  ? debug_print_object+0x6a/0x80
> > > > > > > > > [    8.701032]  debug_check_no_obj_freed+0x1b8/0x1ea
> > > > > > > > > [    8.701032]  ? rcu_process_callbacks+0x2a7/0x750
> > > > > > > > > [    8.701032]  kmem_cache_free+0x6e/0x1a0
> > > > > > > > > [    8.701032]  ? __blk_release_queue+0x150/0x150
> > > > > > > > > [    8.701032]  rcu_process_callbacks+0x2a7/0x750
> > > > > > > > > [    8.701032]  __do_softirq+0xf2/0x2c7
> > > > > > > > > [    8.701032]  irq_exit+0xb7/0xc0
> > > > > > > > > [    8.701032]  smp_apic_timer_interrupt+0x67/0x130
> > > > > > > > > [    8.701032]  apic_timer_interrupt+0xf/0x20
> > > > > > > > > [    8.701032]  </IRQ>
> > > > > > > > > [    8.701032] RIP: 0010:default_idle+0x12/0x140
> > > > > > > > > [    8.701032] Code: fe ff ff c6 43 08 00 fb eb b0 31 c0 eb b4 e8 65 c8 60 ff 90
> > > > > > > > > 90 90 90 90 41 54 55 53 65 8b 2d 15 c4 3b 5a 66 66 66 66 90 fb f4 <65> 8b 2d 07
> > > > > > > > > c4 3b 5a 66 66 66 66 90 5b 5d 41 5c c3 65 8b 05 f6 c3
> > > > > > > > > [    8.701032] RSP: 0018:ffffffffa6603e98 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> > > > > > > > > [    8.701032] RAX: ffffffffa5c52d10 RBX: 0000000000000000 RCX: 0000000000000000
> > > > > > > > > [    8.701032] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000020605092a
> > > > > > > > > [    8.701032] RBP: 0000000000000000 R08: ffffffffcff7766a R09: ffff89b9fda20b00
> > > > > > > > > [    8.701032] R10: 0000000000000000 R11: 0000000000002400 R12: ffffffffa6611740
> > > > > > > > > [    8.701032] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffffa6611740
> > > > > > > > > [    8.701032]  ? __sched_text_end+0x5/0x5
> > > > > > > > > [    8.701032]  do_idle+0x19c/0x230
> > > > > > > > > [    8.701032]  cpu_startup_entry+0x14/0x20
> > > > > > > > > [    8.701032]  start_kernel+0x491/0x4b1
> > > > > > > > > [    8.701032]  secondary_startup_64+0xa4/0xb0
> > > > > > > > > [    8.701032] Kernel Offset: 0x24200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > That is simply caused by enabling DEBUG_KOBJECT_RELEASE itself, which
> > > > > > > > tries to do kboject_release() after delaying a while.
> > > > > > > > 
> > > > > > > > Wrt. this issue, q->mq_kobj is embedded in 'request_queue' whose
> > > > > > > > instance is freed in release handler of q->kobj. So when one instance
> > > > > > > > of 'request_queue' is freed, DEBUG_KOBJECT_RELEASE still expects that
> > > > > > > > the q->mq_kobj is active.
> > > > > > > > 
> > > > > > > > The release handler of q->mq_kobj is NOP actually, so in reality it won't
> > > > > > > > be one issue at all.
> > > > > > > 
> > > > > > > Given we have removed legacy IO path completely, it should be fine to
> > > > > > > remove q->mq_kobj and simply put everything under the kobj of queue,
> > > > > > > especially any attributes under mq aren't marked as stable ABI.
> > > > > > 
> > > > > > That might be possible going forward, but that does not appear to be
> > > > > > a feasible solution for stable releases. I am not sure though if the
> > > > > > "stable ABI" argument is valid. Almost all sysfs attributes are not
> > > > > > marked stable. If there are applications using it, removing the atttributes
> > > > > > would still break userspace.
> > > > > 
> > > > > Yeah, don't move attributes around for no good reason, you will make
> > > > > userspace grumpy :)
> > > > 
> > > > There are very less attributes left under /sys/block/$DEV/mq.
> > > > 
> > > > > 
> > > > > > Since the release function of mq_kobj is NOP (for reference, I assume
> > > > > > we are talking about blk_mq_sysfs_release), can it just be NULL ?
> > > > > 
> > > > > Someone tried to work around the internal kernel warning that comes
> > > > > about when you set a release function to NULL.  As per the in-kernel
> > > > > documentation, I now get to make fun of that author by saying "do you
> > > > > think I added those checks and message just for no good reason?  Don't
> > > > > try to be smarter than the driver core by providing an empty release
> > > > > function to make the kernel be quiet.  That's NOT what the kernel is
> > > > > trying to tell you here at all."
> > > > > 
> > > > > So fix this, that is the correct thing to do.  Memory is freed in a
> > > > > release function, to not do so is almost always a sign of a design bug.
> > > > 
> > > > The root cause is that both q->kobj and q->mq_kobj are bound to lifetime
> > > > of same 'request_queue' instance.
> > > > 
> > > > We may allocate q->mq_kobj dynamically to fix this issue.
> > > > 
> > > > And now all drivers are converted to mq, and it is really necessary to keep
> > > > 'q->mq_kobj'
> > > > 
> > > > > 
> > > > > > That it is an empty function seems to be just as good or bad as having
> > > > > > no function at all. An empty function just avoids the "broken" debug
> > > > > > message. That message is still better than rendering DEBUG_KOBJECT_RELEASE
> > > > > > useless.
> > > > > > 
> > > > > > Copying GregKH for input.
> > > > > 
> > > > > Thanks, this code is broken and needs to be fixed.
> > > > 
> > > > I will post a patch to address the 'issue'.
> > > 
> > > Not only q->mq_kobj, there is also each 'struct blk_mq_ctx' which is
> > > referenced via percpu variable of q->queue_ctx, we still may introduce
> > > one indirect table and allocate each blk_mq_ctx dynamically just for
> > > making DEBUG_KOBJECT_RELEASE happy. But code can become not readable
> > > as before.
> > > 
> > > Just wondering if it is possible to deal with this kind of shared
> > > lifetime issue among kobjects.
> > > 
> > > In this case, q->mq_kobj, every 'struct blk_mq_ctx' referenced via
> > > q->queue_ctx and q->kobj share same lifetime, it is fine to just
> > > release them in one release handler.
> > > 
> > > I will think further and see if it can be done in clean/simple way.
> > 
> > Hi Guenter, Greg and Guys,
> > 
> > What do you think about the following approach?
> > 
> > ---
> > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> > index 2d737f9e7ba7..e15f5760ea1f 100644
> > --- a/block/blk-mq-sysfs.c
> > +++ b/block/blk-mq-sysfs.c
> > @@ -298,10 +298,12 @@ void blk_mq_sysfs_init(struct request_queue *q)
> >  	int cpu;
> >  
> >  	kobject_init(&q->mq_kobj, &blk_mq_ktype);
> > +	kobject_mark_no_delay_release(&q->mq_kobj);
> >  
> >  	for_each_possible_cpu(cpu) {
> >  		ctx = per_cpu_ptr(q->queue_ctx, cpu);
> >  		kobject_init(&ctx->kobj, &blk_mq_ctx_ktype);
> > +		kobject_mark_no_delay_release(&ctx->kobj);
> >  	}
> >  }
> >  
> > diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> > index 1ab0d624fb36..a8857366fb76 100644
> > --- a/include/linux/kobject.h
> > +++ b/include/linux/kobject.h
> > @@ -78,6 +78,7 @@ struct kobject {
> >  	unsigned int state_add_uevent_sent:1;
> >  	unsigned int state_remove_uevent_sent:1;
> >  	unsigned int uevent_suppress:1;
> > +	unsigned int no_delay_release:1;
> >  };
> >  
> >  extern __printf(2, 3)
> > @@ -136,6 +137,16 @@ static inline bool kobject_has_children(struct kobject *kobj)
> >  	return kobj->sd && kobj->sd->dir.subdirs;
> >  }
> >  
> > +/*
> > + * DEBUG_KOBJECT_RELEASE may break case in which more than one kboject
> > + * share one same external object, and have same lifetime, so these
> > + * users may tell kobject core to not do delay release via this helper.
> > + */
> > +static inline void kobject_mark_no_delay_release(struct kobject *kobj)
> > +{
> > +	kobj->no_delay_release = 1;
> > +}
> 
> Ick, no, that's not ok.  "delay release" is a debugging tool, there is
> nothing keeping userspace from grabbing a reference to your kobject and
> holding on to it to emulate this "delay" test.
> 
> So even if you think the kernel is not going to do this, remember, you
> have no control over it.  Reference counted objects are done this way
> for a reason, you really do not know who has a reference and you really
> do not care.
> 
> You are just papering over the real issue here, see my previous email
> for how to start working on resolving it.

IMO, there isn't real issue, and the issue is actually in 'delay release'.

Please look at the code in block/blk-mq-sysfs.c, both q->mq_kobj and all
ctx->kobj share same lifetime with q->kobj, we even don't call get/put
on q->mq_kobj & all ctx->kobj, and all are simply released in q->kobj's
release handler.

So in short, if DEBUG_KOBJECT_RELEASE won't play the delay release
trick, there shouldn't be any issue.


thanks,
Ming
