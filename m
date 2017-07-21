From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] lockdep splat with cpu_hotplug_lock
Date: Fri, 21 Jul 2017 11:42:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1707211141170.2077@nanos>
References: <20170720193501.4f09499f@gandalf.local.home> <1500594526.3568.44.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1824905611-1500630127=:2077"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500594526.3568.44.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1824905611-1500630127=:2077
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Jul 2017, James Bottomley wrote:
> [redirecting to linux-scsi]
> On Thu, 2017-07-20 at 19:35 -0400, Steven Rostedt wrote:
> > My tests triggered this splat on 4.13-rc1:
> > 
> > Loading iSCSI transport class v2.0-870.
> > QLogic NetXtreme II iSCSI Driver bnx2i v2.7.10.1 (Jul 16, 2014)
> > iscsi: registered transport (bnx2i)
> > 
> > ============================================
> > WARNING: possible recursive locking detected
> > 4.13.0-rc1-test+ #2 Not tainted
> > --------------------------------------------
> > swapper/0/1 is trying to acquire lock:
> >  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffffb505329e>]
> > __cpuhp_setup_state+0x28/0x59
> > 
> > but task is already holding lock:
> >  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffffb64d54e9>]
> > bnx2i_mod_init+0x134/0x209
> > 
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> > 
> >        CPU0
> >        ----
> >   lock(cpu_hotplug_lock.rw_sem);
> >   lock(cpu_hotplug_lock.rw_sem);
> 
> It sounds like it's an annotation issue not an actual problem.  I've
> added the correct list, so hopefully our usual enthusiasts can take a
> look.

Nope. It's a recursive locking/\ of cpuhotplug lock. I'll have a look on
monday.

Thanks,

	tglx


--8323329-1824905611-1500630127=:2077--
