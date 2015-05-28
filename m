From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH-v2 0/4] target: Eliminate se_port +
 t10_alua_tg_pt_gp_member
Date: Thu, 28 May 2015 08:48:02 -0700
Message-ID: <20150528154802.GB5989@linux.vnet.ibm.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
 <55646A9E.5050401@sandisk.com>
 <1432703582.26863.33.camel@haakon3.risingtidesystems.com>
 <20150527203650.GO5989@linux.vnet.ibm.com>
 <1432791697.26863.79.camel@haakon3.risingtidesystems.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:51768 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbbE1PsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2015 11:48:12 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 28 May 2015 09:48:11 -0600
Content-Disposition: inline
In-Reply-To: <1432791697.26863.79.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>

On Wed, May 27, 2015 at 10:41:37PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-05-27 at 13:36 -0700, Paul E. McKenney wrote:
> > On Tue, May 26, 2015 at 10:13:02PM -0700, Nicholas A. Bellinger wrote:
> > > On Tue, 2015-05-26 at 14:44 +0200, Bart Van Assche wrote:
> > > > On 05/26/15 08:57, Nicholas A. Bellinger wrote:
> > > > >    - Add various rcu_dereference and lockless_dereference RCU notation
> > > > 
> > > > Hello Nic,
> > > > 
> > > > Feedback from an RCU expert (which I'm not) would be appreciated here. 
> > > > But my understanding is that lockless_dereference(p) should be used for 
> > > > a pointer p that has *not* been annotated as an RCU pointer. I think in 
> > > > the for-next branch of the target repository that this macro is used to 
> > > > access RCU-annotated pointers. Is that why sparse complains about how 
> > > > lockless_dereference() is used in the target tree ?
> > > > 
> > > 
> > > Was curious about this myself..  Thanks for raising the question!
> > > 
> > > The intention of lockless_dereference() in both this and preceding
> > > series is for __rcu protected pointers that are accessed outside of
> > > rcu_read_lock() protection, and who's lifetime is controlled by a:
> > > 
> > >   - struct kref
> > >   - struct percpu_ref
> > >   - struct config_group symlink
> > >   - RCU updater path with some manner of mutex or spinlock held
> > > 
> > > This is supposed to be following Paul's comment in rcupdate.h:
> > > 
> > >  * Similar to rcu_dereference(), but for situations where the pointed-to
> > >  * object's lifetime is managed by something other than RCU.  That
> > >  * "something other" might be reference counting or simple immortality.
> > > 
> > > Paul, would you be to kind to clarify the intention for us..?
> > 
> > The lockless_dereference() primitive is to be used for pointers that
> > are -not- marked with __rcu.  In fact, the sparse tool should yell
> > at you if you use lockless_dereference() on an __rcu-marked pointer.
> 
> Yep, definitely wrong usage of lockless_dereference on my part.
> 
> Thanks for the clarification.
> 
> > You could use smp_store_release() to update the pointer when inserting
> > new data.  If you are using one of the lists, then the _rcu variant of the
> > list-insert macro should be used (list_add_rcu()), because that is needed
> > to make sure that the reader sees a properly initialized new element.
> > 
> > If you have a pointer that is sometimes protected by RCU and other times
> > protected by something else, you still use one of the rcu_dereference()
> > macros to access it.  For example, if a given RCU-protected pointer is
> > protected either by RCU or by some lock, you might write common code
> > that is called from either context as follows:
> > 
> > 	p = rcu_dereference_check(pointer, lockdep_is_held(&some_lock));
> > 
> > Does that help, or am I missing your point?
> > 
> 
> This makes more sense now.
> 
> Ok, so for an updater path where a __rcu protected pointer is being
> dereferenced with a lock held synchronizing modification of an
> hlist_head or hlist_node, the rcu_dereference_check() usage is clear to
> me..
> 
> What I'm still unclear about is other three cases above, where a __rcu
> protected pointer is dereferenced outside of the updater path, but it's
> release is protected by some external means; kref, percpu_ref, or a
> configfs parent/child config_group reference.
> 
> For example, say a __rcu protected pointer is dereferenced under
> rcu_read_lock().  The data structure itself contains a percpu_ref that
> is incremented under rcu_read_lock(), and also contains a rcu_head.
> rcu_read_unlock() happens immediately after the percpu_ref has been
> incremented.
> 
> If this structure is then attempted to be released from an updater path,
> it first blocks on a completion waiting for the percpu_ref count to
> return to zero, before invoking the final kfree_rcu().
> 
> So the question I'm getting at is, what's the correct notation for
> dereferencing a __rcu pointer outside of rcu_read_lock(), who's data
> structure is protected by some manner of reference counting obtained
> under rcu_read_lock(), that prevents kfree_rcu() from happening until
> the reference count is dropped..?

If feasible, use rcu_dereference_check() with an expression checking for
the reference being held.  If that does not work for whatever reason,
use rcu_dereference_raw() with a comment indicating that you are relying
on a kref, percpu_ref, or whatever.

							Thanx, Paul

