From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] lockdep splat with cpu_hotplug_lock
Date: Thu, 20 Jul 2017 16:48:46 -0700
Message-ID: <1500594526.3568.44.camel@HansenPartnership.com>
References: <20170720193501.4f09499f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170720193501.4f09499f@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

[redirecting to linux-scsi]
On Thu, 2017-07-20 at 19:35 -0400, Steven Rostedt wrote:
> My tests triggered this splat on 4.13-rc1:
> 
> Loading iSCSI transport class v2.0-870.
> QLogic NetXtreme II iSCSI Driver bnx2i v2.7.10.1 (Jul 16, 2014)
> iscsi: registered transport (bnx2i)
> 
> ============================================
> WARNING: possible recursive locking detected
> 4.13.0-rc1-test+ #2 Not tainted
> --------------------------------------------
> swapper/0/1 is trying to acquire lock:
>  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffffb505329e>]
> __cpuhp_setup_state+0x28/0x59
> 
> but task is already holding lock:
>  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffffb64d54e9>]
> bnx2i_mod_init+0x134/0x209
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(cpu_hotplug_lock.rw_sem);
>   lock(cpu_hotplug_lock.rw_sem);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 1 lock held by swapper/0/1:
>  #0:  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffffb64d54e9>]
> bnx2i_mod_init+0x134/0x209
> 
> stack backtrace:
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.13.0-rc1-test+ #2
> Hardware name: MSI MS-7823/CSM-H87M-G43 (MS-7823), BIOS V1.6
> 02/22/2014
> Call Trace:
>  dump_stack+0x68/0x92
>  __lock_acquire+0x84b/0xebb
>  ? __lock_is_held+0x47/0x7a
>  ? mark_held_locks+0x5e/0x74
>  ? _raw_spin_unlock_irqrestore+0x40/0x47
>  lock_acquire+0x108/0x19c
>  ? lock_acquire+0x108/0x19c
>  ? __cpuhp_setup_state+0x28/0x59
>  cpus_read_lock+0x2f/0x5f
>  ? __cpuhp_setup_state+0x28/0x59
>  __cpuhp_setup_state+0x28/0x59
>  ? bnx2i_percpu_thread_create+0x79/0x79
>  bnx2i_mod_init+0x17a/0x209
>  ? iscsi_transport_init+0x1c1/0x1c1
>  ? set_debug_rodata+0x17/0x17
>  do_one_initcall+0x90/0x131
>  ? set_debug_rodata+0x17/0x17
>  kernel_init_freeable+0x1e5/0x26d
>  ? rest_init+0xd8/0xd8
>  kernel_init+0xe/0xfa
>  ret_from_fork+0x27/0x40
> ahci 0000:00:1f.2: version 3.0
> ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl
> SATA mode
> ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst
> scsi host0: ahci
> 
> I'd let the powers that be figure it out.

It sounds like it's an annotation issue not an actual problem.  I've
added the correct list, so hopefully our usual enthusiasts can take a
look.

James
