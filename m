From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 16:43:37 -0500
Message-ID: <496FAE09.2040207@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com> <496FA001.1000501@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4207 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZAOVnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 16:43:40 -0500
In-Reply-To: <496FA001.1000501@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> What are locks for?
>
> They serialize accesses to data, in order to protect the data from
> invalid modifications due to concurrent accesses.
>   
...
> What are reference counters for?
>
> Well, the name says it.  I'd better ask:  What is reference counting
> for?  Of course to prevent premature destruction of objects; IOW to
> implement lifetime rules.
>
> Locks don't implement lifetime rules.  They only implement serialization
> of accesses.
>
>   
...
> In your case, you want to extend sg_index_lock's purposes to also
> serialize access to a state variable of the sg device objects.  Nothing
> wrong with that, as long as you and, later on, readers of your code are
> aware what is going on.
>
>   

OK, so your argument now seems to be that the code just might in
practice work correctly, but in theory it is not philosophically right,
semantically pure, or politically correct because it uses fundamental
programming constructs in odd ways that are not the "right" ways taught
in CS courses that everyone understands and loves.  That is a valid
viewpoint I suppose, but I tend to be much more pragmatic.  BTW, you
might want to do a quick grep of the kernel source for all users of
atomic_inc_not_zero() and make sure they all follow the established CS
curricula:

net/netfilter/nf_conntrack_expect.c:

struct nf_conntrack_expect *
nf_ct_expect_find_get(struct net *net, const struct nf_conntrack_tuple *tuple)
{
	struct nf_conntrack_expect *i;

	rcu_read_lock();
	i = __nf_ct_expect_find(net, tuple);
	if (i && !atomic_inc_not_zero(&i->use))
		i = NULL;
	rcu_read_unlock();

	return i;
}

void nf_ct_expect_put(struct nf_conntrack_expect *exp)
{
	if (atomic_dec_and_test(&exp->use))
		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
}


fs/nfs/nfs4state.c:

static struct nfs4_state *
__nfs4_find_state_byowner(struct inode *inode, struct nfs4_state_owner *owner)
{
	struct nfs_inode *nfsi = NFS_I(inode);
	struct nfs4_state *state;

	list_for_each_entry(state, &nfsi->open_states, inode_states) {
		if (state->owner != owner)
			continue;
		if (atomic_inc_not_zero(&state->count))
			return state;
	}
	return NULL;
}

struct nfs4_state *
nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
{
	struct nfs4_state *state, *new;
	struct nfs_inode *nfsi = NFS_I(inode);

	spin_lock(&inode->i_lock);
	state = __nfs4_find_state_byowner(inode, owner);
	spin_unlock(&inode->i_lock);
	...
}

void nfs4_put_open_state(struct nfs4_state *state)
{
	struct inode *inode = state->inode;
	struct nfs4_state_owner *owner = state->owner;

	if (!atomic_dec_and_lock(&state->count, &owner->so_lock))
		return;
	spin_lock(&inode->i_lock);
	list_del(&state->inode_states);
	list_del(&state->open_states);
	spin_unlock(&inode->i_lock);
	spin_unlock(&owner->so_lock);
	iput(inode);
	nfs4_free_open_state(state);
	nfs4_put_state_owner(owner);
}


... etc.  But I'm sure all those silly network and RCU developers didn't
understand what they were doing.

I would still like for some other people to weigh in with their opinions
before I spend more effort on another patch or else push forward with
kref_get_not_zero().

Tony
