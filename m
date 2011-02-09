From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
Date: Wed, 09 Feb 2011 14:13:53 -0600
Message-ID: <1297282433.3016.43.camel@mulgrave.site>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110209092851.bba6c40c.randy.dunlap@oracle.com>
	 <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
	 <1297281744.18212.44.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297281744.18212.44.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, Joel Becker <jlbec@evilplan.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-02-09 at 12:02 -0800, Nicholas A. Bellinger wrote:
> On Wed, 2011-02-09 at 11:00 -0800, Linus Torvalds wrote:
> > On Wed, Feb 9, 2011 at 9:28 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > x86_64, nearly allmodconfig.  No target hardware.
> > >
> > >
> > > [  144.508473] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > > [  144.509901] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
> > > [  144.512026] CPU 1
> > > [  144.512026]
> > > [  144.512026] Pid: 2597, comm: rmmod Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745
> > > [  144.512026] RIP: 0010:[<ffffffff810c3e5f>]  [<ffffffff810c3e5f>] __lock_acquire+0xd8/0x4e8
> > > [  144.512026] RSP: 0018:ffff88006df1bb78  EFLAGS: 00010006
> > > [  144.512026] RAX: 0000000000000002 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
> > 
> > The code disassembles to
> > 
> >    0:	8d 01                	lea    (%rcx),%eax
> >    2:	e8 6c b1 fb ff       	callq  0xfffffffffffbb173
> >    7:	48 ff 05 8b 32 8d 01 	incq   0x18d328b(%rip)        # 0x18d3299
> >    e:	48 ff 05 8c 32 8d 01 	incq   0x18d328c(%rip)        # 0x18d32a1
> >   15:	48 ff 05 95 32 8d 01 	incq   0x18d3295(%rip)        # 0x18d32b1
> >   1c:	e9 e3 03 00 00       	jmpq   0x404
> >   21:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32a9
> >   28:*	48 81 3b 40 5f 26 82 	cmpq   $0xffffffff82265f40,(%rbx)     <--
> > trapping instruction
> >   2f:	75 07                	jne    0x38
> >   31:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32b9
> >   38:	83 fe 01             	cmp    $0x1,%esi
> > 
> > and %rbx (and %rdi) contains the poison pattern for free'd memory (0x6b6b6b..).
> > 
> > > [  144.512026] Process rmmod (pid: 2597, threadinfo ffff88006df1a000, task ffff88006dec3000)
> > 
> > .. and that's likely not a very commonly tested case.
> > 
> > > [  144.512026]  [<ffffffffa06ace26>] configfs_unregister_subsystem+0x105/0x194 [configfs]
> > > [  144.512026]  [<ffffffffa06baf55>] target_core_exit_configfs+0x185/0x1eb [target_core_mod]
> > > [  144.512026]  [<ffffffff810d46a8>] sys_delete_module+0x2d6/0x368
> > 
> > The target_core_exit_configfs() code looks _very_ broken. It looks
> > broken for two reasons:
> > 
> >  - it's very different from the cleanup code for the "failed to init"
> > case in target_core_init_configfs, which does a lot less (see the
> > "out:" code there)
> > 
> 
> When registering a top level struct configfs_subsystem to appear under
> 
> 	/sys/kernel/config/$SUBSYSTEM
> 
> the releasing of the top-level default group via
> configfs_unregister_subsystem() during a failure in
> target_core_init_configfs() is done for us, but we are still missing the
> extra config_item_put()'s on the sub top-level groups (Joel, please
> correct me)
> 
> The original 'out:' failure path code does not call config_item_put() on
> these default groups, because config_group_init_type_name() has only
> initialized struct config_group until configfs_register_subsystem() is
> called to register the top level struct config_subsystem.
> 
> With the current 'out:' path being broken, to address the first point I
> think moving the following code chunk in target_core_init_configfs to
> before the configfs_register_subsystem() would make sense so that
> configfs_register_subsystem() will fail last:
> 
>         /*
>          * Register built-in RAMDISK subsystem logic for virtual LUN 0
>          */
>         ret = rd_module_init();
>         if (ret < 0)
>                 goto out;
> 
>         if (core_dev_setup_virtual_lun0() < 0)
>                 goto out;
> 
>         return 0;
> 
> However looking at fs/configfs/dir.c:configfs_register_subsystem(), I
> think the caller is still expected to release any sub top-level struct
> config_group->default_groups[] w/ config_item_put() even though
> unlink_group() is called from the configfs_attach_group() failure path..
> (Joel..?)
> 
> >  - it seems to do a lot of manual freeing of the
> > "su_group.default_groups" stuff etc, which is all internal configfs
> > stuff, and seems to be used by the register/unregister phases.
> > 
> 
> The specific issue rmmod with SLUB poisioning had been reported by Fubo
> Chen to linux-scsi in the last weeks.  The patch to address the proper
> release of the top-level + sub top-level struct configfs_subsystem's
> default_groups in target_core_exit_configfs() has been committed into
> the upstream tree in lio-core-2.6.git/linus-38-rc3 and sent out to
> linux-scsi here:
> 
> [PATCH] target: Fix top-level configfs_subsystem default_group shutdown breakage
> http://marc.info/?l=linux-scsi&m=129662389218924&w=2
> 
> > So somebody show knows configfs better should really check that
> > cleanup, but it looks like target-core is just totally broken for the
> > rmmod case.
> > 
> > Added more people to the cc. Nicholas, Joel and James. Guys: please
> > check the insmod/rmmod case with
> >  (a) spinlock debugging and lockdep enabled
> >  (b) SLUB poisoning enabled.
> > ie all of these should be on:
> > 
> >   CONFIG_SLUB_DEBUG_ON=y
> >   CONFIG_DEBUG_SPINLOCK=y
> >   CONFIG_DEBUG_MUTEXES=y
> >   CONFIG_DEBUG_LOCK_ALLOC=y
> >   CONFIG_PROVE_LOCKING=y
> >   CONFIG_LOCKDEP=y
> >   CONFIG_DEBUG_LOCKDEP=y
> >   CONFIG_TRACE_IRQFLAGS=y
> >   CONFIG_DEBUG_SPINLOCK_SLEEP=y
> >   CONFIG_STACKTRACE=y
> > 
> > and you might also want to add CONFIG_DEBUG_PAGEALLOC to the mix.
> > 
> 
> <nod>  I believe the above patch resolves the specific rmmod issue.
> However, during SLUB poisioning testing we also came across errors with
> the incorrect use of struct config_item_operations->release() in
> target_core_configfs.c and target_core_fabric_configfs.c code.  The
> series to address these was included in the last series to James here:
> 
> [PATCH 00/12] target: Updates for .38-rc4
> http://marc.info/?l=linux-scsi&m=129680191624837&w=2
> 
> Note that this series for-38 mainline needs to be applied on top of the
> original update series after the drivers/target/ mainline merge:
> 
> [PATCH 00/24] target updates for .38-rc3 (v2)
> http://marc.info/?l=linux-scsi&m=129632617326015&w=2
> 
> The entire series is available from
>      
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc4
> 
> James, please review + sign-off so we can get these updates into mainline.

Firstly, could we get the serious bug fixes identified and separated
from the general enhancement updates, so they can go in a fixes tree
without depending on enhancements?  The former category would include
the /proc interface removal, since we don't want the legacy interface to
be in a released kernel.

James
