From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/9] target: Convert se_node_acl->device_list[] to
 RCU hlist
Date: Mon, 25 May 2015 21:11:51 -0700
Message-ID: <1432613511.26863.10.camel@haakon3.risingtidesystems.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
	 <1432275071-28882-2-git-send-email-nab@daterainc.com>
	 <20150522082411.GB5384@infradead.org>
	 <1432284930.898.19.camel@haakon3.risingtidesystems.com>
	 <20150522113119.GA28758@lst.de>
	 <1432592058.722.14.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432592058.722.14.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-05-25 at 15:14 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2015-05-22 at 13:31 +0200, Christoph Hellwig wrote:
> > On Fri, May 22, 2015 at 01:55:30AM -0700, Nicholas A. Bellinger wrote:

<SNIP>

> > > > > +		kref_put(&orig->pr_kref, target_pr_kref_release);
> > > > > +		wait_for_completion(&orig->pr_comp);
> > > > >  
> > > > 
> > > > > +	kref_put(&orig->pr_kref, target_pr_kref_release);
> > > > >  	/*
> > > > > -	 * Disable struct se_dev_entry LUN ACL mapping
> > > > > +	 * Before fireing off RCU callback, wait for any in process SPEC_I_PT=1
> > > > > +	 * or REGISTER_AND_MOVE PR operation to complete.
> > > > >  	 */
> > > > > +	wait_for_completion(&orig->pr_comp);
> > > > > +	kfree_rcu(orig, rcu_head);
> > > > 
> > > > The release callback should just call kfree_rcu, no need to wait for the
> > > > release in the caller.
> > > > 
> > > 
> > > Why doesn't se_dev_entry release this need to wait for the special case
> > > references to drop..?
> > 
> > Why would it?
> 
> It originally had to wait in order for the se_dev_entry consumers to
> drop, before it could be reused in se_node_acl->device_list[]..
> 
> > There is no access to the structure at this point, so there
> > is no point to keep it around localy.  If there were other references to
> > it they by defintion don't need it anymore by the time they drop the
> > reference count.  Freeing a structure as soon as the refcount drops
> > zero is the normal style all over the place.  Waiting for a reference
> > count only makes sense if it's a drain style operation where you don't
> > free the structure but you just want to wait for some class of consumers
> > to stop using it.
> 
> .. but since it's not being reused anymore, doing a kfree_rcu() from the
> final kref_put() should be fine.
> 
> Converting now.

Looking at this more while adding rcu notation, just calling kfree_rcu()
from kref_put() is not going to work here.

The wait_for_completion(&orig->pr_comp) above is still required because
core_scsi3_lunacl_depend_item() has to dereference se_deve->se_lun_acl
outside of the lock (with se_deve->pr_kref held) to obtain the configfs
dependency for se_lun_acl->se_lun_group.

Otherwise, se_lun_acl->se_lun_group can be removed from out below the
core_scsi3_lunacl_depend_item() caller, if se_deve->pr_comp doesn't wait
for the configfs dependency to be released.

--nab
