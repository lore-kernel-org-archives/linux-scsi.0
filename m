From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Wed, 01 Apr 2015 22:37:27 -0700
Message-ID: <1427953047.9176.292.camel@haakon3.risingtidesystems.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
	 <20150330120823.GA20193@infradead.org>
	 <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
	 <20150401070400.GA3431@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51051 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbDBFha (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 01:37:30 -0400
In-Reply-To: <20150401070400.GA3431@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>

On Wed, 2015-04-01 at 00:04 -0700, Christoph Hellwig wrote:
> On Tue, Mar 31, 2015 at 11:51:56PM -0700, Nicholas A. Bellinger wrote:
> > Since last week, enable/disable device_list code has been converted to
> > use mempool + call_rcu() and performs the RCU pointer swap in
> > se_node_acl->lun_entry_hlist[] under se_node_acl->lun_entry_mutex.
> 
> Why use a mempool there?

Would be nice to guarantee a certain number of new se_dev_entry
allocations always succeed as existing code expects.

>  Please take a look at my branch, it's much simpler and logical than
> the old version.
> 

Yes, nice simplifications and code cleanups.  I'm still working to get
things functionally correct first, and will be applying parts of
target-rcu-hch from there..

The use of t10_pr_registration->pr_reg_deve is still wrong though, as
it's held for the lifetime of the pr_reg, and not just while
pr_ref_count is non zero for REGISTER w/ I_PORT + REGISTER_AND_MOVE
special cases.

I've already fixed this for v2 by using se_dev_entry->pr_reg for
signaling when a PR registration is active.

> > There are a few more target_core_pr.c pieces that need to be updated to
> > handle NULL se_node_acl->lun_entry_hlist[] pointers, along with proper
> > rcu_dereference_protected() and rcu_access_pointer() notations for
> > se_dev_entry pointer access outside of RCU read lock.
> 
> In my branch I've been over all the places to make sure they handle
> the NULL case.
> 

Great.

> > > that implements this scheme.  Note that I dropped the percpu refcount
> > > changes - the reference is only taken in the SCSI3-PR slow path, and the
> > > percpu refcount API is extremly cumbersome.
> > > 
> > 
> > Well, there still needs to be some manner of reference counting on
> > se_dev_entry once rcu_read_lock() is released for the REGISTER w/ I_PORT
> > and REGISTER_AND_MOVE cases with a non-local I_T_L se_dev_entry
> > reference.
> 
> The refcount is still there in the good old atomic_t-based version,
> which is perfectl fine for the PRIN and PROUT subcommands which aren't
> the I/O fast path.

Agreed the percpu_ref is overkill and percpu_ref_init() is problematic
because it can still -ENOMEM during se_dev_entry creation..

Switching to a normal kref with a blocking completion probably makes the
most sense, in order to avoid potentially spinning on atomic_read() if
APTPL metadata write-out ends up blocking during the two special PR
cases.

--nab

