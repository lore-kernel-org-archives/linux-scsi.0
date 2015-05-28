From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH-v2 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
 RCU usage
Date: Thu, 28 May 2015 08:57:20 -0700
Message-ID: <20150528155720.GC5989@linux.vnet.ibm.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
 <1432623445-25776-3-git-send-email-nab@daterainc.com>
 <55648374.80802@sandisk.com>
 <1432704585.26863.47.camel@haakon3.risingtidesystems.com>
 <20150527210446.GP5989@linux.vnet.ibm.com>
 <1432792930.26863.97.camel@haakon3.risingtidesystems.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432792930.26863.97.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 27, 2015 at 11:02:10PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-05-27 at 14:04 -0700, Paul E. McKenney wrote:
> > On Tue, May 26, 2015 at 10:29:45PM -0700, Nicholas A. Bellinger wrote:
> > > On Tue, 2015-05-26 at 16:30 +0200, Bart Van Assche wrote:
> > > > On 05/26/15 08:57, Nicholas A. Bellinger wrote:
> > > > > @@ -625,6 +626,7 @@ int core_dev_add_initiator_node_lun_acl(
> > > > >   	u32 lun_access)
> > > > >   {
> > > > >   	struct se_node_acl *nacl = lacl->se_lun_nacl;
> > > > > +	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
> > > > >   
> > > > >   	if (!nacl)
> > > > >   		return -EINVAL;
> > > > 
> > > > An attempt to run this code on a system with RCU debugging enabled
> > > > resulted in the following complaint:
> > > > 
> > > > ===============================
> > > > [ INFO: suspicious RCU usage. ]
> > > > 4.1.0-rc1-lio-dbg+ #1 Not tainted
> > > > -------------------------------
> > > > drivers/target/target_core_device.c:617 suspicious rcu_dereference_check() usage!
> > > > 
> > > > other info that might help us debug this:
> > > > 
> > > > 
> > > > rcu_scheduler_active = 1, debug_locks = 1
> > > > 2 locks held by ln/1497:
> > > >  #0:  (sb_writers#11){.+.+.+}, at: [<ffffffff811d9ca4>] mnt_want_write+0x24/0x50
> > > >  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.+.}, at: [<ffffffff811c4cdd>] filename_create+0xad/0x1a0
> > > > 
> > > > stack backtrace:
> > > > CPU: 0 PID: 1497 Comm: ln Not tainted 4.1.0-rc1-lio-dbg+ #1
> > > > Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > >  0000000000000001 ffff88005955bd68 ffffffff814fa346 0000000000000011
> > > >  ffff880058bf1270 ffff88005955bd98 ffffffff810ab235 ffff880050db9a68
> > > >  ffff880058ae2e68 0000000000000002 ffff880058ae4120 ffff88005955be08
> > > > Call Trace:
> > > >  [<ffffffff814fa346>] dump_stack+0x4f/0x7b
> > > >  [<ffffffff810ab235>] lockdep_rcu_suspicious+0xd5/0x110
> > > >  [<ffffffffa04324bc>] core_dev_add_initiator_node_lun_acl+0xec/0x190 [target_core_mod]
> > > >  [<ffffffff8108f871>] ? get_parent_ip+0x11/0x50
> > > >  [<ffffffffa04346f9>] target_fabric_mappedlun_link+0x129/0x240 [target_core_mod]
> > > >  [<ffffffffa043466c>] ? target_fabric_mappedlun_link+0x9c/0x240 [target_core_mod]
> > > >  [<ffffffffa035824d>] configfs_symlink+0x13d/0x360 [configfs]
> > > >  [<ffffffff811be8c8>] vfs_symlink+0x58/0xb0
> > > >  [<ffffffff811c75c5>] SyS_symlink+0x65/0xc0
> > > >  [<ffffffff81502eb2>] system_call_fastpath+0x16/0x7a
> > > > 
> > > 
> > > In this particular case, the se_device behind se_lun->lun_se_dev
> > > __rcu protected pointer can't be released without first releasing the
> > > pre-existing se_lun->lun_group reference to se_device->dev_group.
> > > 
> > > And since se_lun->lun_group is the source of a configfs symlink to
> > > se_lun_acl->se_lun_group here, the se_lun associated RCU pointer and
> > > underlying se_device can't be released out from under the above
> > > target_fabric_mappedlun_link() code accessing a __rcu protected pointer.
> > > 
> > > Paul, is lockless_dereference the correct notation for this type of
> > > use-case..?
> > 
> > My guess is "no", but I don't claim to understand your use case.
> > 
> > The splat is against some other code than the patch, judging by the
> > patch line numbers.
> > 
> > The rule is that if a pointer points to something that is freed (or
> > reused) after a grace period, you mark that pointer with __rcu.
> > Any access to that pointer must then be accessed in an RCU read-side
> > critical section, using one of the RCU list iterators or one of the
> > rcu_dereference() macros.  No lockless_dereference() in this case.
> > 
> > You use lockless_dereference() when something other than RCU controls
> > when the pointer target is freed.
> 
> For this case, there is a pointer with __rcu notation being
> dereferenced, but given the way configfs parent/child config_group
> reference counting works, it's impossible for this __rcu pointer to be
> modified, and impossible for RCU updater path (-> kfree_rcu) of the
> structure being dereferenced to run, while this particular code is
> executed.
> 
> So I was thinking this should be using something like
> rcu_dereference_protected(), but from the comment it sounds like this is
> intended only for RCU updater path code.

If something is preventing the pointer from changing, then it is OK
to use rcu_dereference_protected().  If the pointer might change, then
you are right, you absolutely cannot use rcu_dereference_protected(),
as it does not protect against concurrent updates.

If reasonably possible, you should pass a reference-held expression to
rcu_dereference_protected().

> Is there some other notation to use for this type of case where the RCU
> updater path can't run due to external reference counting, or should
> this not be using __rcu notation at all..?

You should be OK with rcu_dereference_protected().  However, for
rcu_dereference_protected() to work properly, it must be the case
that the pointer it is reading doesn't change.

So you do have to be a bit careful.  For example, if structure A has
a reference held so that it cannot be removed at the moment, but if it
points to some structure B that -can- be removed, then you cannot use
rcu_dereference_protected() to access the pointer from A to B because
that pointer could change.

For another example, assume that structures C and D both have references
held (and thus cannot be removed), and that structure C points to
structure D.  But if a structure E could be inserted between C and D,
we -cannot- use rcu_dereference_protected() because the pointer from
C to D could change at any time, despite both C and D being nailed down.

In other words, the distinction is whether or not a given pointer can
change, not whether or not the enclosing structure is guaranteed to live.

Make sense?

							Thanx, Paul
