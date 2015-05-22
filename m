From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 1/9] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Fri, 22 May 2015 13:31:19 +0200
Message-ID: <20150522113119.GA28758@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-2-git-send-email-nab@daterainc.com> <20150522082411.GB5384@infradead.org> <1432284930.898.19.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432284930.898.19.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 22, 2015 at 01:55:30AM -0700, Nicholas A. Bellinger wrote:
> > This update will now be racy, ditto for the read/write_bytes update
> > later.
> 
> This should become an atomic_long_t increment, yes..?

Yes.

> Yes, this helper is from your patch above.
> 
> Considering there is a single user of it here, and complexities involved
> for a RCU conversion + bisect, is it really work adding as a separate
> patch ahead of this one..?

The golden Linus style is to put preparatory patches first so that the
actual logic change is as small as possible.  Adding helpers so that
low level accesses that will e changed soon is a very typical case for that.

> > > +		kref_put(&orig->pr_kref, target_pr_kref_release);
> > > +		wait_for_completion(&orig->pr_comp);
> > >  
> > 
> > > +	kref_put(&orig->pr_kref, target_pr_kref_release);
> > >  	/*
> > > -	 * Disable struct se_dev_entry LUN ACL mapping
> > > +	 * Before fireing off RCU callback, wait for any in process SPEC_I_PT=1
> > > +	 * or REGISTER_AND_MOVE PR operation to complete.
> > >  	 */
> > > +	wait_for_completion(&orig->pr_comp);
> > > +	kfree_rcu(orig, rcu_head);
> > 
> > The release callback should just call kfree_rcu, no need to wait for the
> > release in the caller.
> > 
> 
> Why doesn't se_dev_entry release this need to wait for the special case
> references to drop..?

Why would it?  There is no access to the structure at this point, so there
is no point to keep it around localy.  If there were other references to
it they by defintion don't need it anymore by the time they drop the
reference count.  Freeing a structure as soon as the refcount drops
zero is the normal style all over the place.  Waiting for a reference
count only makes sense if it's a drain style operation where you don't
free the structure but you just want to wait for some class of consumers
to stop using it.
