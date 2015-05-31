From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
 RCU usage
Date: Sat, 30 May 2015 22:24:41 -0700
Message-ID: <1433049881.3170.27.camel@haakon3.risingtidesystems.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
	 <1432623445-25776-3-git-send-email-nab@daterainc.com>
	 <55648374.80802@sandisk.com>
	 <1432704585.26863.47.camel@haakon3.risingtidesystems.com>
	 <20150527210446.GP5989@linux.vnet.ibm.com>
	 <1432792930.26863.97.camel@haakon3.risingtidesystems.com>
	 <20150528155720.GC5989@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60461 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbEaFYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2015 01:24:43 -0400
In-Reply-To: <20150528155720.GC5989@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>

On Thu, 2015-05-28 at 08:57 -0700, Paul E. McKenney wrote:
> On Wed, May 27, 2015 at 11:02:10PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2015-05-27 at 14:04 -0700, Paul E. McKenney wrote:
> > > On Tue, May 26, 2015 at 10:29:45PM -0700, Nicholas A. Bellinger wrote:

<SNIP>

> > > > In this particular case, the se_device behind se_lun->lun_se_dev
> > > > __rcu protected pointer can't be released without first releasing the
> > > > pre-existing se_lun->lun_group reference to se_device->dev_group.
> > > > 
> > > > And since se_lun->lun_group is the source of a configfs symlink to
> > > > se_lun_acl->se_lun_group here, the se_lun associated RCU pointer and
> > > > underlying se_device can't be released out from under the above
> > > > target_fabric_mappedlun_link() code accessing a __rcu protected pointer.
> > > > 
> > > > Paul, is lockless_dereference the correct notation for this type of
> > > > use-case..?
> > > 
> > > My guess is "no", but I don't claim to understand your use case.
> > > 
> > > The splat is against some other code than the patch, judging by the
> > > patch line numbers.
> > > 
> > > The rule is that if a pointer points to something that is freed (or
> > > reused) after a grace period, you mark that pointer with __rcu.
> > > Any access to that pointer must then be accessed in an RCU read-side
> > > critical section, using one of the RCU list iterators or one of the
> > > rcu_dereference() macros.  No lockless_dereference() in this case.
> > > 
> > > You use lockless_dereference() when something other than RCU controls
> > > when the pointer target is freed.
> > 
> > For this case, there is a pointer with __rcu notation being
> > dereferenced, but given the way configfs parent/child config_group
> > reference counting works, it's impossible for this __rcu pointer to be
> > modified, and impossible for RCU updater path (-> kfree_rcu) of the
> > structure being dereferenced to run, while this particular code is
> > executed.
> > 
> > So I was thinking this should be using something like
> > rcu_dereference_protected(), but from the comment it sounds like this is
> > intended only for RCU updater path code.
> 
> If something is preventing the pointer from changing, then it is OK
> to use rcu_dereference_protected().  If the pointer might change, then
> you are right, you absolutely cannot use rcu_dereference_protected(),
> as it does not protect against concurrent updates.
> 
> If reasonably possible, you should pass a reference-held expression to
> rcu_dereference_protected().
> 
> > Is there some other notation to use for this type of case where the RCU
> > updater path can't run due to external reference counting, or should
> > this not be using __rcu notation at all..?
> 
> You should be OK with rcu_dereference_protected().  However, for
> rcu_dereference_protected() to work properly, it must be the case
> that the pointer it is reading doesn't change.
> 
> So you do have to be a bit careful.  For example, if structure A has
> a reference held so that it cannot be removed at the moment, but if it
> points to some structure B that -can- be removed, then you cannot use
> rcu_dereference_protected() to access the pointer from A to B because
> that pointer could change.
> 
> For another example, assume that structures C and D both have references
> held (and thus cannot be removed), and that structure C points to
> structure D.  But if a structure E could be inserted between C and D,
> we -cannot- use rcu_dereference_protected() because the pointer from
> C to D could change at any time, despite both C and D being nailed down.
> 
> In other words, the distinction is whether or not a given pointer can
> change, not whether or not the enclosing structure is guaranteed to live.
> 
> Make sense?
> 

Most certainly.  Thanks for the explanation here, it's very helpful.

Ok, so converting the bogus lockless_dereference() usage to:

 - rcu_dereference_check() when called from a read-critical path to 
   include the necessary smp_read_barrier_depends() + ACCESS_ONCE(), 
   when RCU updater side can potentially execute.
 - rcu_dereference_protected() when called from an updater path with
   a lock held.
 - rcu_dereference_protected() when called from a reader path that can
   only run while the updater side cannot execute due to external 
   reference counting.
 - rcu_dereference_raw() for other special cases where a reference
   can't be verified, with an appropriate comment.

Thank you,

--nab

