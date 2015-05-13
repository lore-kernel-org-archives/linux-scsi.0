From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Tue, 12 May 2015 23:20:12 -0700
Message-ID: <1431498012.26897.61.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <20150513054646.GA20825@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56139 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbEMGUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 02:20:16 -0400
In-Reply-To: <20150513054646.GA20825@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

On Wed, 2015-05-13 at 07:46 +0200, Christoph Hellwig wrote:
> On Tue, May 12, 2015 at 09:25:25AM +0000, Nicholas A. Bellinger wrote:
> > @@ -240,18 +237,12 @@ int core_free_device_list_for_node(
> >  {
> >  	struct se_dev_entry *deve;
> >  	struct se_lun *lun;
> > -	u32 i;
> > -
> > -	if (!nacl->device_list)
> > -		return 0;
> > -
> > -	spin_lock_irq(&nacl->device_list_lock);
> > -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> > -		deve = nacl->device_list[i];
> > +	u32 mapped_lun;
> >  
> > +	rcu_read_lock();
> > +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
> >  		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
> >  			continue;
> > -
> >  		if (!deve->se_lun) {
> >  			pr_err("%s device entries device pointer is"
> >  				" NULL, but Initiator has access.\n",
> > @@ -259,16 +250,14 @@ int core_free_device_list_for_node(
> >  			continue;
> >  		}
> >  		lun = deve->se_lun;
> > +		mapped_lun = deve->mapped_lun;
> > +		rcu_read_unlock();
> >  
> > -		spin_unlock_irq(&nacl->device_list_lock);
> > -		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
> > -			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> > -		spin_lock_irq(&nacl->device_list_lock);
> > +		core_disable_device_list_for_node(lun, NULL, mapped_lun,
> > +					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> 
> I don't think this change is a good idea.  Now that you've just switched
> to a list call into core_disable_device_list_for_node with the lock
> instead of retaking it and restart the list walk after it instead of
> encoding the previous wrong behavior with the local mapped_lun
> variable.  Note that this patter is the same for all all but one of the
> callers, and even core_dev_del_initiator_node_lun_acl would benefit
> from being called locked and with an already looked up dev entry.
> 

Ugh, yes.  Fixing up clear_lun_from_tpg + free_device_list_for_node to
use a common caller acquiring se_node_acl->lun_entry_mutex during
se_dev_entry release.

Fixing up target_fabric_mappedlun_unlink() as well.

> Note that if you cherry picked this patch I posted a while ago
> to be before the series one of the callers would already be gone:
> 
> http://git.infradead.org/users/hch/scsi.git/commitdiff/dfb7096ba5ea47cb5b7fb5b6e2f8d7d6436af24f
> 
> > +	spin_lock_irq(&nacl->lun_entry_lock);
> > +	deve = target_nacl_find_deve(nacl, mapped_lun);
> > +	if (deve) {
> > +		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> > +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> > +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> > +		} else {
> > +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> > +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> > +		}
> >  	}
> > -	spin_unlock_irq(&nacl->device_list_lock);
> > +	spin_unlock_irq(&nacl->lun_entry_lock);
> > +
> > +	synchronize_rcu();
> 
> This only updates scalar fields, the synchronize_rcu() calls isn't
> going to buy you anything.
> 
> Btw, it would be good to always document what a synchronize_rcu()
> call code is for.

<nod>, dropping synchronize_rcu() here

> 
> > +
> > +static void target_nacl_deve_callrcu(struct rcu_head *head)
> > +{
> > +	struct se_dev_entry *deve = container_of(head, struct se_dev_entry,
> > +						 rcu_head);
> > +	kfree(deve);
> >  }
> 
> Just use kfree_rcu instead of open coding it.
> 

Done

> > +/*
> > + * Called with rcu_read_lock or nacl->device_list_lock held.
> > + */
> 
> It would be good to assert that.  Paul, is there a good way to assert
> we're called under rcu_read_lock?
> 
> > +	spin_lock_irq(&nacl->device_list_lock);
> > +	orig = target_nacl_find_deve(nacl, mapped_lun);
> > +	if (orig && orig->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> > +		BUG_ON(orig->se_lun_acl != NULL);
> > +		BUG_ON(orig->se_lun != lun);
> > +
> > +		rcu_assign_pointer(new->se_lun, lun);
> > +		rcu_assign_pointer(new->se_lun_acl, lun_acl);
> > +		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
> >  		spin_unlock_irq(&nacl->device_list_lock);
> > +		spin_lock_bh(&port->sep_alua_lock);
> > +		list_del(&orig->alua_port_list);
> > +		list_add_tail(&new->alua_port_list, &port->sep_alua_list);
> > +		spin_unlock_bh(&port->sep_alua_lock);
> >  
> > +		return 0;
> >  	}
> 
> The case where we have an original one is the demo mode -> explicit
> change.  So I don't think we actually need the newly allocate dev
> entry here.  Just change lun_flags like in core_update_device_list_access
> and do an rcu_assign_pointer for the lun ACLs.

Will take a look at this.

> 
> > -	deve->creation_time = get_jiffies_64();
> > -	deve->attach_count++;
> > +	rcu_assign_pointer(new->se_lun, lun);
> > +	rcu_assign_pointer(new->se_lun_acl, lun_acl);
> > +	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
> >  	spin_unlock_irq(&nacl->device_list_lock);
> >  
> >  	spin_lock_bh(&port->sep_alua_lock);
> > -	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
> > +	list_add_tail(&new->alua_port_list, &port->sep_alua_list);
> >  	spin_unlock_bh(&port->sep_alua_lock);
> >  
> > +	synchronize_rcu();
> 
> Please add a comment why we need the synchronize_rcu here again.  Nothing
> is delete from any list, and nothing is freed so I don't see any need
> to wait for a grace period.
> 

I don't think it's required either.  Dropping.

> > +	core_scsi3_ua_release_all(orig);
> > +	rcu_assign_pointer(orig->se_lun, NULL);
> > +	rcu_assign_pointer(orig->se_lun_acl, NULL);
> 
> Can you document the life time rules that ensure ->se_lun and ->se_lun_acl
> stay around while readers in the RCU grace period may still access them?

Will do.

Thanks HCH.

--nab

