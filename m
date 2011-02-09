From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
Date: Wed, 9 Feb 2011 11:00:34 -0800
Message-ID: <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <20110209092851.bba6c40c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110209092851.bba6c40c.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Joel Becker <jlbec@evilplan.org>, James Bottomley <James.Bottomley@suse.de>
Cc: scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 9, 2011 at 9:28 AM, Randy Dunlap <randy.dunlap@oracle.com> =
wrote:
> x86_64, nearly allmodconfig. =A0No target hardware.
>
>
> [ =A0144.508473] general protection fault: 0000 [#1] SMP DEBUG_PAGEAL=
LOC
> [ =A0144.509901] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.=
1/usb6/6-1/6-1.3/devnum
> [ =A0144.512026] CPU 1
> [ =A0144.512026]
> [ =A0144.512026] Pid: 2597, comm: rmmod Not tainted 2.6.38-rc4 #1 0TY=
565/OptiPlex 745
> [ =A0144.512026] RIP: 0010:[<ffffffff810c3e5f>] =A0[<ffffffff810c3e5f=
>] __lock_acquire+0xd8/0x4e8
> [ =A0144.512026] RSP: 0018:ffff88006df1bb78 =A0EFLAGS: 00010006
> [ =A0144.512026] RAX: 0000000000000002 RBX: 6b6b6b6b6b6b6be3 RCX: 000=
0000000000000

The code disassembles to

   0:	8d 01                	lea    (%rcx),%eax
   2:	e8 6c b1 fb ff       	callq  0xfffffffffffbb173
   7:	48 ff 05 8b 32 8d 01 	incq   0x18d328b(%rip)        # 0x18d3299
   e:	48 ff 05 8c 32 8d 01 	incq   0x18d328c(%rip)        # 0x18d32a1
  15:	48 ff 05 95 32 8d 01 	incq   0x18d3295(%rip)        # 0x18d32b1
  1c:	e9 e3 03 00 00       	jmpq   0x404
  21:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32a9
  28:*	48 81 3b 40 5f 26 82 	cmpq   $0xffffffff82265f40,(%rbx)     <--
trapping instruction
  2f:	75 07                	jne    0x38
  31:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32b9
  38:	83 fe 01             	cmp    $0x1,%esi

and %rbx (and %rdi) contains the poison pattern for free'd memory (0x6b=
6b6b..).

> [ =A0144.512026] Process rmmod (pid: 2597, threadinfo ffff88006df1a00=
0, task ffff88006dec3000)

=2E. and that's likely not a very commonly tested case.

> [ =A0144.512026] =A0[<ffffffffa06ace26>] configfs_unregister_subsyste=
m+0x105/0x194 [configfs]
> [ =A0144.512026] =A0[<ffffffffa06baf55>] target_core_exit_configfs+0x=
185/0x1eb [target_core_mod]
> [ =A0144.512026] =A0[<ffffffff810d46a8>] sys_delete_module+0x2d6/0x36=
8

The target_core_exit_configfs() code looks _very_ broken. It looks
broken for two reasons:

 - it's very different from the cleanup code for the "failed to init"
case in target_core_init_configfs, which does a lot less (see the
"out:" code there)

 - it seems to do a lot of manual freeing of the
"su_group.default_groups" stuff etc, which is all internal configfs
stuff, and seems to be used by the register/unregister phases.

So somebody show knows configfs better should really check that
cleanup, but it looks like target-core is just totally broken for the
rmmod case.

Added more people to the cc. Nicholas, Joel and James. Guys: please
check the insmod/rmmod case with
 (a) spinlock debugging and lockdep enabled
 (b) SLUB poisoning enabled.
ie all of these should be on:

  CONFIG_SLUB_DEBUG_ON=3Dy
  CONFIG_DEBUG_SPINLOCK=3Dy
  CONFIG_DEBUG_MUTEXES=3Dy
  CONFIG_DEBUG_LOCK_ALLOC=3Dy
  CONFIG_PROVE_LOCKING=3Dy
  CONFIG_LOCKDEP=3Dy
  CONFIG_DEBUG_LOCKDEP=3Dy
  CONFIG_TRACE_IRQFLAGS=3Dy
  CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
  CONFIG_STACKTRACE=3Dy

and you might also want to add CONFIG_DEBUG_PAGEALLOC to the mix.

                        Linus
