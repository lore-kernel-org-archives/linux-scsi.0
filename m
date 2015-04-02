From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Thu, 2 Apr 2015 01:56:07 -0700
Message-ID: <20150402085607.GA31017@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
 <20150330120823.GA20193@infradead.org>
 <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
 <20150401070400.GA3431@infradead.org>
 <1427953047.9176.292.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427953047.9176.292.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2015 at 10:37:27PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-04-01 at 00:04 -0700, Christoph Hellwig wrote:
> > On Tue, Mar 31, 2015 at 11:51:56PM -0700, Nicholas A. Bellinger wrote:
> > > Since last week, enable/disable device_list code has been converted to
> > > use mempool + call_rcu() and performs the RCU pointer swap in
> > > se_node_acl->lun_entry_hlist[] under se_node_acl->lun_entry_mutex.
> > 
> > Why use a mempool there?
> 
> Would be nice to guarantee a certain number of new se_dev_entry
> allocations always succeed as existing code expects.

mempools are for I/O path that make guaranteed progress.  While the
callers of core_enable_device_list_for_node are in the control path,
and not in a very deep callstack, fairly shallow below the configfs
interface.  This is not a use case for mempools, as there is no need
to guarantee progress in deep I/O callstacks.

> The use of t10_pr_registration->pr_reg_deve is still wrong though, as
> it's held for the lifetime of the pr_reg, and not just while
> pr_ref_count is non zero for REGISTER w/ I_PORT + REGISTER_AND_MOVE
> special cases.

Seems like we should just take the reference properly.

> I've already fixed this for v2 by using se_dev_entry->pr_reg for
> signaling when a PR registration is active.

At least in the version you posted ->pr_reg is just used as a boolean
flag, in which case we might want to keep the real def_pr_registered
flag.

> > The refcount is still there in the good old atomic_t-based version,
> > which is perfectl fine for the PRIN and PROUT subcommands which aren't
> > the I/O fast path.
> 
> Agreed the percpu_ref is overkill and percpu_ref_init() is problematic
> because it can still -ENOMEM during se_dev_entry creation..
> 
> Switching to a normal kref with a blocking completion probably makes the
> most sense, in order to avoid potentially spinning on atomic_read() if
> APTPL metadata write-out ends up blocking during the two special PR
> cases.

The nice part about using the dynamically allocated dev entry is that
the shutdown path doesn't need to be sync.  You can just use a normal
kref and don't care when it actually gets freed.  One thing I didn't
do in my branch but which would e useful is to rename -> pr_ref
to just ->ref as it's a generic refcount - for now it's only used by
the PR code, but there is nothing specific to it in there.
