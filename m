From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH-v2 0/4] target: Eliminate se_port +
 t10_alua_tg_pt_gp_member
Date: Wed, 27 May 2015 13:36:50 -0700
Message-ID: <20150527203650.GO5989@linux.vnet.ibm.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
 <55646A9E.5050401@sandisk.com>
 <1432703582.26863.33.camel@haakon3.risingtidesystems.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432703582.26863.33.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 26, 2015 at 10:13:02PM -0700, Nicholas A. Bellinger wrote:
> On Tue, 2015-05-26 at 14:44 +0200, Bart Van Assche wrote:
> > On 05/26/15 08:57, Nicholas A. Bellinger wrote:
> > >    - Add various rcu_dereference and lockless_dereference RCU notation
> > 
> > Hello Nic,
> > 
> > Feedback from an RCU expert (which I'm not) would be appreciated here. 
> > But my understanding is that lockless_dereference(p) should be used for 
> > a pointer p that has *not* been annotated as an RCU pointer. I think in 
> > the for-next branch of the target repository that this macro is used to 
> > access RCU-annotated pointers. Is that why sparse complains about how 
> > lockless_dereference() is used in the target tree ?
> > 
> 
> Was curious about this myself..  Thanks for raising the question!
> 
> The intention of lockless_dereference() in both this and preceding
> series is for __rcu protected pointers that are accessed outside of
> rcu_read_lock() protection, and who's lifetime is controlled by a:
> 
>   - struct kref
>   - struct percpu_ref
>   - struct config_group symlink
>   - RCU updater path with some manner of mutex or spinlock held
> 
> This is supposed to be following Paul's comment in rcupdate.h:
> 
>  * Similar to rcu_dereference(), but for situations where the pointed-to
>  * object's lifetime is managed by something other than RCU.  That
>  * "something other" might be reference counting or simple immortality.
> 
> Paul, would you be to kind to clarify the intention for us..?

The lockless_dereference() primitive is to be used for pointers that
are -not- marked with __rcu.  In fact, the sparse tool should yell
at you if you use lockless_dereference() on an __rcu-marked pointer.
You could use smp_store_release() to update the pointer when inserting
new data.  If you are using one of the lists, then the _rcu variant of the
list-insert macro should be used (list_add_rcu()), because that is needed
to make sure that the reader sees a properly initialized new element.

If you have a pointer that is sometimes protected by RCU and other times
protected by something else, you still use one of the rcu_dereference()
macros to access it.  For example, if a given RCU-protected pointer is
protected either by RCU or by some lock, you might write common code
that is called from either context as follows:

	p = rcu_dereference_check(pointer, lockdep_is_held(&some_lock));

Does that help, or am I missing your point?

							Thanx, Paul
