From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Wed, 1 Apr 2015 00:04:00 -0700
Message-ID: <20150401070400.GA3431@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
 <20150330120823.GA20193@infradead.org>
 <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 31, 2015 at 11:51:56PM -0700, Nicholas A. Bellinger wrote:
> Since last week, enable/disable device_list code has been converted to
> use mempool + call_rcu() and performs the RCU pointer swap in
> se_node_acl->lun_entry_hlist[] under se_node_acl->lun_entry_mutex.

Why use a mempool there?  Please take a look at my branch, it's much
simpler and logical than the old version.

> There are a few more target_core_pr.c pieces that need to be updated to
> handle NULL se_node_acl->lun_entry_hlist[] pointers, along with proper
> rcu_dereference_protected() and rcu_access_pointer() notations for
> se_dev_entry pointer access outside of RCU read lock.

In my branch I've been over all the places to make sure they handle
the NULL case.

> > that implements this scheme.  Note that I dropped the percpu refcount
> > changes - the reference is only taken in the SCSI3-PR slow path, and the
> > percpu refcount API is extremly cumbersome.
> > 
> 
> Well, there still needs to be some manner of reference counting on
> se_dev_entry once rcu_read_lock() is released for the REGISTER w/ I_PORT
> and REGISTER_AND_MOVE cases with a non-local I_T_L se_dev_entry
> reference.

The refcount is still there in the good old atomic_t-based version,
which is perfectl fine for the PRIN and PROUT subcommands which aren't
the I/O fast path.
