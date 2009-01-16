From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Fri, 16 Jan 2009 01:53:14 +0100
Message-ID: <496FDA7A.6080502@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com> <496FA001.1000501@s5r6.in-berlin.de> <496FAE09.2040207@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461AbZAPAxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 19:53:38 -0500
In-Reply-To: <496FAE09.2040207@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> net/netfilter/nf_conntrack_expect.c:
> 
> struct nf_conntrack_expect *
> nf_ct_expect_find_get(struct net *net, const struct nf_conntrack_tuple *tuple)
> {
> 	struct nf_conntrack_expect *i;
> 
> 	rcu_read_lock();
> 	i = __nf_ct_expect_find(net, tuple);
> 	if (i && !atomic_inc_not_zero(&i->use))
> 		i = NULL;
> 	rcu_read_unlock();
> 
> 	return i;
> }
> 
> void nf_ct_expect_put(struct nf_conntrack_expect *exp)
> {
> 	if (atomic_dec_and_test(&exp->use))
> 		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
> }
> 
> 
> fs/nfs/nfs4state.c:
> 
> static struct nfs4_state *
> __nfs4_find_state_byowner(struct inode *inode, struct nfs4_state_owner *owner)
> {
> 	struct nfs_inode *nfsi = NFS_I(inode);
> 	struct nfs4_state *state;
> 
> 	list_for_each_entry(state, &nfsi->open_states, inode_states) {
> 		if (state->owner != owner)
> 			continue;
> 		if (atomic_inc_not_zero(&state->count))
> 			return state;
> 	}
> 	return NULL;
> }
> 
> struct nfs4_state *
> nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
> {
> 	struct nfs4_state *state, *new;
> 	struct nfs_inode *nfsi = NFS_I(inode);
> 
> 	spin_lock(&inode->i_lock);
> 	state = __nfs4_find_state_byowner(inode, owner);
> 	spin_unlock(&inode->i_lock);
> 	...
> }
> 
> void nfs4_put_open_state(struct nfs4_state *state)
> {
> 	struct inode *inode = state->inode;
> 	struct nfs4_state_owner *owner = state->owner;
> 
> 	if (!atomic_dec_and_lock(&state->count, &owner->so_lock))
> 		return;
> 	spin_lock(&inode->i_lock);
> 	list_del(&state->inode_states);
> 	list_del(&state->open_states);
> 	spin_unlock(&inode->i_lock);
> 	spin_unlock(&owner->so_lock);
> 	iput(inode);
> 	nfs4_free_open_state(state);
> 	nfs4_put_state_owner(owner);
> }
> 
> 
> ... etc.  But I'm sure all those silly network and RCU developers didn't
> understand what they were doing.

Is it obvious from these excerpts what the lifetime rules of the objects
are?  Not really immediately.

Do we know merely from looking at the code why its developers chose to
do it this way?  No.

Is there a necessity to do similarly complicated things in sg?  No,
definitely not.
-- 
Stefan Richter
-=====-==--= ---= =----
http://arcgraph.de/sr/
